#include <EvalOperations.h>

#include <GameState.h>
#include <GameData.h>
#include <GameOperations.h>

#include <Utilities.h>

#include <fstream>
#include <string>
#include <sstream>
#include <iomanip>
#include <unordered_map>

#define NOMINMAX
#include <Windows.h>

auto GetNumThreads(EvalState& eval)
{
    unsigned int numThreads;
    switch (eval.multithreading)
    {
    case Multithreading::All:
        numThreads = std::thread::hardware_concurrency();
        break;

    case Multithreading::AllButOne:
        numThreads = std::thread::hardware_concurrency() - 1;
        break;

    case Multithreading::None:
    default:
        numThreads = 1;
        break;
    }

    return numThreads;
}

void EvalOp::Evaluate(const GameState& state, EvalState& eval)
{
    auto title = L"Level " + std::to_wstring(state.level) + L"   Mask " + eval.bounceMask;
    if (eval.testSinglePaddlePos)
    {
        title += L"   Position " + std::to_wstring(eval.testSinglePaddlePos);
    }

    if (eval.skipToDepth != 0)
    {
        title += L"   Start depth " + std::to_wstring(eval.skipToDepth) + L" (frame " + std::to_wstring(eval.skipToFrame) + L")";
    }

    ::SetConsoleTitle(title.c_str());

    if (eval.timeLimit != 0)
    {
        eval.startTime = std::chrono::high_resolution_clock::now();
    }

    const auto numThreads = GetNumThreads(eval);
    eval.sharedState->perThreadQueue = std::vector<ResultSet>(numThreads, ResultSet{});

    // Prime the queue with one decision point's worth of jobs, then start the job queue.
    auto stateCopyA = state;
    auto stateCopyB = state;
    ExecuteNextDecisionPoint(stateCopyA, eval);
    StartJobQueue(stateCopyB, eval);
}

void EvalOp::StartJobQueue(GameState& state, EvalState& eval)
{
    const auto numThreads = GetNumThreads(eval);

    if (numThreads > 1)
    {
        std::vector<std::future<void>> threads;
        auto nextThreadId = 0;
        for (auto i = 0u; i < numThreads; i++)
        {
            eval.sharedState->perThreadQueueSentry.emplace_back(std::make_unique<std::mutex>());

            threads.emplace_back(std::async(std::launch::async, [&] {
                std::pair<GameState, EvalState> result;
                auto jobCount = 0;
                auto threadId = -1;

                {
                    std::lock_guard<std::mutex> lock(eval.sharedState->genericSentry);
                    threadId = nextThreadId++;
                }

                auto& thisThreadQueue = eval.sharedState->perThreadQueue[threadId];
                auto queueEmpty = [&] { return thisThreadQueue.empty(); };

                const auto claimJob = [&] {
                    std::lock_guard<std::mutex> lock(*eval.sharedState->perThreadQueueSentry[threadId]);

                    result = std::move(thisThreadQueue.back());
                    thisThreadQueue.pop_back();
                    result.second.threadId = threadId;
                    jobCount++;
                };

                while(true)
                {
                    // Sometimes the queue can be drained midway even though there's still
                    // work to go around. Wait a bit and retry.
                    if (queueEmpty()) { EvalOp::Sleep(100); }
                    if (queueEmpty()) { EvalOp::Sleep(100); }
                    if (queueEmpty()) { EvalOp::Sleep(100); }

                    if (queueEmpty()) break;

                    {
                        claimJob();

                        const auto id = result.first.paddleX;

                        if (jobCount % 100000 == 0) printf("Thread %d completed %d jobs\n", threadId, jobCount);

                        ExecuteNextDecisionPoint(result.first, result.second);
                    }
                }

                printf(" == Thread %d finished, %d jobs completed ==\n", threadId, jobCount);
            }));
        }

        for (auto&& thread : threads)
        {
            thread.get();
        }
    }
    else
    {
        auto iter = 0;
        const auto startingSize = static_cast<int>(eval.sharedState->results.size());
        while (eval.sharedState->results.size() > 0)
        {
            auto result = eval.sharedState->results.back();
            eval.sharedState->results.pop_back();

            auto& stateItr = result.first;
            auto& evalItr = result.second;

            ++iter;

            ExecuteNextDecisionPoint(stateItr, evalItr);
        }
    }
}

DecisionPoint EvalOp::GetNextDecisionPoint(GameState& state, EvalState& eval, unsigned int& targetFrame, unsigned int& expectedBallPos,
                                           const std::vector<DecisionPoint>& exclusions, const bool manipulateFromLeftSide)
{
    const auto ballInRange = [](Ball& ball) {
        return (ball.pos.y + 4 >= GameConsts::PaddleTop
                && GameConsts::PaddleTop + 3 >= ball.pos.y
                && ball.vSign.vy == 1
                && !ball._paddleCollis);
    };

    const auto excluded = [exclusions](const DecisionPoint decisionPoint) {
        return (std::find(exclusions.begin(), exclusions.end(), decisionPoint) != exclusions.end());
    };

    if (eval.timeLimit != 0)
    {
        auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::high_resolution_clock::now() - eval.startTime);
        if (elapsed.count() >= eval.timeLimit)
        {
            targetFrame = state._frame;
            return DecisionPoint::None_LimitReached;
        }
    }

    if (state.opState == OperationalState::BallNotLaunched)
    {
        targetFrame = state._frame;
        return DecisionPoint::LaunchBall;
    }

    if (state.spawnedPowerup != Powerup::None && state.spawnedPowerup != Powerup::Multiball)
    {
        // We spawned a non-multiball powerup while executing something else; reject the iteration.
        targetFrame = state._frame;
        return DecisionPoint::Invalid;
    }

    // Don't check enemy-manip flags here since we have to simulate the state properly either way.
    if (_SimulateEnemies(state))
    {
        for (auto enemyIdx = 0; enemyIdx <= 2; enemyIdx++)
        {
            if (EnemyOverlapsPaddle(state.enemies[enemyIdx], state.paddleX))
            {
                // We're warping the paddle away before it can be processed for collisions this frame,
                // but it overlaps an enemy and would normally destroy it no matter what under normal
                // paddle rules. Simulate that by destroying the enemy manually.
                state._queueEnemyDestruction = enemyIdx;
            }
        }
    }

    // Move the paddle out of the way so it doesn't interfere with the game state.
    state.paddleX = manipulateFromLeftSide ? 0 : 0xd0;
    state._disablePaddleHitbox = true;

    auto firstFrame = true;

    while (!ReachedFrameLimit(state, eval))
    {
        GameOp::ExecuteInput(state, NoInput);

        if (state.level == GameConsts::BossLevel)
        {
            if (state.bossHits >= 0x10)
            {
                targetFrame = state._frame;
                return DecisionPoint::None_LevelEnded;
            }
        }
        else if (state.currentBlocks == 0)
        {
            // Allow the score to tally up.
            while (state.pendingScore > 0)
            {
                GameOp::ExecuteInput(state, NoInput);
            }

            targetFrame = state._frame;
            return DecisionPoint::None_LevelEnded;
        }

        if (eval.depth > static_cast<int>(eval.depthLimit))
        {
            targetFrame = state._frame;
            return DecisionPoint::None_LimitReached;
        }

        if (eval.strictHitProgression && CheckHitLimitExceeded(state, eval))
        {
            targetFrame = state._frame;
            return DecisionPoint::None_LimitReached;
        }

        if (AnyBallLost(state))
        {
            targetFrame = state._frame;
            return DecisionPoint::None_BallLost;
        }

        if (ballInRange(state.ball[0]))
        {
            targetFrame = state._frame;
            expectedBallPos = state.ball[0].pos.x;
            return DecisionPoint::BounceBall1;
        }

        if (ballInRange(state.ball[1]))
        {
            targetFrame = state._frame;
            expectedBallPos = state.ball[1].pos.x;
            return DecisionPoint::BounceBall2;
        }

        if (ballInRange(state.ball[2]))
        {
            targetFrame = state._frame;
            expectedBallPos = state.ball[2].pos.x;
            return DecisionPoint::BounceBall3;
        }

        if (state.justSpawnedPowerup)
        {
            targetFrame = state._frame;
            return DecisionPoint::ManipPowerup;
        }

        if (state.spawnedPowerup == Powerup::Multiball
            && state.powerupPos.y + 8 >= GameConsts::PaddleTop && GameConsts::PaddleTop + 4 >= state.powerupPos.y)
        {
            targetFrame = state._frame;
            return DecisionPoint::CollectPowerup;
        }

        if (_SimulateEnemies(state) && eval.manipulateEnemies)
        {
            // Skip enemy gate manipulations on the first frame; spawn manipulation ends one
            // frame before the gate state actually changes so this avoids re-triggering on
            // the same event. In the rare case that this is a legitimate isolated event, it'll
            // almost always be impossible to manipulate it anyway with just a one-frame window,
            // so it's safe enough to omit them.
            if (state.enemyGateState == 1 && !excluded(DecisionPoint::ManipEnemySpawn) && !firstFrame)
            {
                targetFrame = state._frame;
                return DecisionPoint::ManipEnemySpawn;
            }

            if (state.enemies[0].active && GameConsts::PaddleTop + 4 >= state.enemies[0].pos.y
                && state.enemies[0].pos.y + 0xe >= GameConsts::PaddleTop
                && !excluded(DecisionPoint::HitEnemy1WithPaddle))
            {
                targetFrame = state._frame;
                return DecisionPoint::HitEnemy1WithPaddle;
            }

            if (state.enemies[1].active && GameConsts::PaddleTop + 4 >= state.enemies[1].pos.y
                && state.enemies[1].pos.y + 0xe >= GameConsts::PaddleTop
                && !excluded(DecisionPoint::HitEnemy2WithPaddle))
            {
                targetFrame = state._frame;
                return DecisionPoint::HitEnemy2WithPaddle;
            }

            if (state.enemies[2].active && GameConsts::PaddleTop + 4 >= state.enemies[2].pos.y
                && state.enemies[2].pos.y + 0xe >= GameConsts::PaddleTop
                && !excluded(DecisionPoint::HitEnemy3WithPaddle))
            {
                targetFrame = state._frame;
                return DecisionPoint::HitEnemy3WithPaddle;
            }

            // Skip enemy move manipulations on the first frame. Rationale is the same as enemy spawn
            // manipulations; see above.
            if (eval.manipulateEnemyMoves && !firstFrame)
            {
                if (state._justMovedEnemy == 0 && !excluded(DecisionPoint::ManipEnemy1Move))
                {
                    targetFrame = state._frame;
                    expectedBallPos = state._enemyMoveOptions;
                    return DecisionPoint::ManipEnemy1Move;
                }

                if (state._justMovedEnemy == 1 && !excluded(DecisionPoint::ManipEnemy2Move))
                {
                    targetFrame = state._frame;
                    expectedBallPos = state._enemyMoveOptions;
                    return DecisionPoint::ManipEnemy2Move;
                }

                if (state._justMovedEnemy == 2 && !excluded(DecisionPoint::ManipEnemy3Move))
                {
                    targetFrame = state._frame;
                    expectedBallPos = state._enemyMoveOptions;
                    return DecisionPoint::ManipEnemy3Move;
                }
            }
        }

        firstFrame = false;
    }

    if (ReachedFrameLimit(state, eval))
    {
        targetFrame = state._frame;
        return DecisionPoint::None_LimitReached;
    }
    else
    {
        targetFrame = state._frame;
        return DecisionPoint::Invalid;
    }
}

bool EvalOp::CheckHitLimitExceeded(GameState& state, EvalState& eval)
{
    if (eval.enforceTasRefHitProgression)
    {
        if (state._frame >= eval.startFrame + eval.hitProgressionLeadupInterval)
        {
            const auto currentHits = GetRemainingHits(state);

            if (eval.useHitProgressionAveraging)
            {
                int effectiveFrame = static_cast<int>(state._frame - eval.startFrame) - eval.hitProgressionGraceInterval;
                int frameLen = eval.frameLimit() - eval.startFrame;
                const auto framePercentComplete = effectiveFrame / static_cast<double>(frameLen);

                auto adjustedFramePercent = (1.0 - framePercentComplete);
                MathUtil::Clamp(adjustedFramePercent, 0.0, 1.0);

                const auto expectedHits = static_cast<unsigned int>(std::ceil(eval.sharedState->hitTable[eval.startFrame] * adjustedFramePercent));

                if (currentHits > expectedHits)
                {
                    return true;
                }
            }
            else
            {
                auto frame = state._frame - eval.hitProgressionGraceInterval;
                MathUtil::Clamp(frame, eval.startFrame, eval.frameLimit());

                if (currentHits > eval.sharedState->hitTable[frame])
                {
                    return true;
                }
            }
        }
    }

    return false;
}

void EvalOp::QueueJob(Result&& job)
{
    std::vector<Result> jobs;
    jobs.emplace_back(std::move(job));

    QueueJobs(std::move(jobs));
}

void EvalOp::QueueJobs(std::vector<Result>&& jobs)
{
    if (jobs.empty()) return;

    auto sharedState = jobs.front().second.sharedState;
    const auto threadId = jobs.front().second.threadId;

    for (auto i = 0; i < sharedState->perThreadQueue.size(); i++)
    {
        if (sharedState->perThreadQueue[i].size() < 5)
        {
            printf("Thread %d: Queue %d empty, adding\n", threadId, i);
            std::lock_guard<std::mutex> lock(*sharedState->perThreadQueueSentry[i]);

            for (auto&& job : jobs)
            {
                sharedState->perThreadQueue[i].emplace_back(std::move(job));
            }
            return;
        }
    }

    std::lock_guard<std::mutex> lock(*sharedState->perThreadQueueSentry[threadId]);

    for (auto&& job : jobs)
    {
        sharedState->perThreadQueue[threadId].emplace_back(std::move(job));
    }
}

void EvalOp::ExecuteNextDecisionPoint(GameState& state, EvalState& eval, const std::vector<DecisionPoint>& exclusions)
{
    if (!eval.noConditions)
    {
        for (auto&& condition : eval.conditions)
        {
            if (condition(state, eval))
            {
                return;
            }
        }
    }

    if (!eval.strictHitProgression && CheckHitLimitExceeded(state, eval))
    {
        return;
    }

    const auto checkLevelEnd = [](GameState& state, EvalState& eval, const DecisionPoint decisionPoint) {
        auto complete = (decisionPoint == DecisionPoint::None_LevelEnded && state._frame <= eval.sharedState->frameLimit.load());
        
        if (complete)
        {
            std::string msg("Level " + std::to_string(state.level) + " completed on frame " + std::to_string(state._frame)
                            + "!\nInput chain: " + InputChainToStringShort(state.inputChain));
            printf("%s\n", msg.c_str());
            Log::Write(msg);
            
            if (_PrintSolution)
            {
                GameState freshState;
                GameOp::Init(freshState);
                GameOp::AdvanceToLevel(freshState, state.level);

                eval.sleepLen = 10;
                for (int i = 0; i < state.inputChain.size(); i++)
                {
                    GameOp::ExecuteInput(freshState, state.inputChain[i]);
                    PrintGameState(freshState, eval);
                }
            }

            {
                eval.sharedState->frameLimit.store(state._frame - 1);
                eval.sharedState->bestBlockHitCount.store(0);
            }

            if (eval.outputBizHawkMovie)
            {
                OutputBizHawkMovie(state, eval, OutputMode::Normal);

                if (eval.outputBestAttempts)
                {
                    OutputBizHawkMovie(state, eval, OutputMode::RemainingHits);
                }
            }

            if (_PrintSolution)
            {
                exit(0);
            }

            return true;
        }

        return false;
    };

    eval.depth++;

    const auto SEQ_START = state;
    unsigned int targetFrame = 0u;
    unsigned int expectedBallPos = 0u;
    auto manipulateFromLeftSide = false;
    const auto decisionPoint = GetNextDecisionPoint(state, eval, targetFrame, expectedBallPos, exclusions, manipulateFromLeftSide);
    
    const auto levelEnded = checkLevelEnd(state, eval, decisionPoint);
    const auto failedPowerupCheck = (eval.ensurePowerupByDepth > 0 && eval.depth == eval.ensurePowerupByDepth
                                     && decisionPoint != DecisionPoint::ManipPowerup && state.ownedPowerup == Powerup::None
                                     && state.spawnedPowerup == Powerup::None);

    if (_SimulateEnemies(state) && eval.manipulateEnemies)
    {
        if (exclusions.size() > 0)
        {
            // Need to check if the result's different when the paddle's on the other side.
            // If it is, kick off another execution branch.

            state = SEQ_START;

            unsigned int otherTargetFrame = 0u;
            unsigned int otherExpectedBallPos = 0u;
            manipulateFromLeftSide = true;
            const auto otherDecisionPoint = GetNextDecisionPoint(state, eval, otherTargetFrame, otherExpectedBallPos, exclusions, manipulateFromLeftSide);

            const auto levelEndedOther = checkLevelEnd(state, eval, otherDecisionPoint);
            const auto failedPowerupCheckOther = (eval.ensurePowerupByDepth > 0 && eval.depth == eval.ensurePowerupByDepth
                                                  && otherDecisionPoint != DecisionPoint::ManipPowerup && state.ownedPowerup == Powerup::None
                                                  && state.spawnedPowerup == Powerup::None);

            if (otherDecisionPoint != decisionPoint || otherExpectedBallPos != expectedBallPos || otherTargetFrame != targetFrame)
            {
                if (!levelEndedOther && !failedPowerupCheckOther)
                {
                    state = SEQ_START;
                    eval.action = otherDecisionPoint;

                    ExecuteDecisionPoint(state, eval, otherDecisionPoint, otherTargetFrame, otherExpectedBallPos, exclusions);
                }
            }
        }
    }

    if (!levelEnded && !failedPowerupCheck)
    {
        state = std::move(SEQ_START);
        eval.action = decisionPoint;
        ExecuteDecisionPoint(state, eval, decisionPoint, targetFrame, expectedBallPos, exclusions);
    }

    eval.depth--;
}

void EvalOp::ExecuteDecisionPoint(GameState& state, EvalState& eval, const DecisionPoint decisionPoint, const unsigned int targetFrame,
                                  const unsigned int expectedBallPos, const std::vector<DecisionPoint>& prevExclusions)
{
    const auto executeEnemyManip = [&] {
        const auto SEQ_START = state;

        // Option 1: No manipulation.
        // Since this involves immediately searching for a new decision point without executing anything,
        // need to persist any existing exclusions forward.
        auto exclusions = prevExclusions;
        exclusions.push_back(DecisionPoint::ManipEnemySpawn);
        ExecuteNextDecisionPoint(state, eval, exclusions);

        state = std::move(SEQ_START);

        // Option 2: Enemy manipulations.
        auto results = ManipulateEnemySpawn(state, eval, targetFrame);
        for (auto result : results)
        {
            ExecuteNextDecisionPoint(result.first, result.second);
        }
    };

    const auto executeEnemyPaddleHit = [&](const DecisionPoint decisionPoint) {
        const auto SEQ_START = state;

        // Option 1: No enemy interaction.
        // Since this involves immediately searching for a new decision point without executing anything,
        // need to persist any existing exclusions forward.
        auto exclusions = prevExclusions;
        exclusions.push_back(decisionPoint);
        ExecuteNextDecisionPoint(state, eval, exclusions);

        state = std::move(SEQ_START);

        auto enemyIdx = 0;
        if (decisionPoint == DecisionPoint::HitEnemy2WithPaddle) enemyIdx = 1;
        if (decisionPoint == DecisionPoint::HitEnemy3WithPaddle) enemyIdx = 2;

        // Option 2: Evaluate.
        HitEnemyWithPaddle(state, eval, enemyIdx, targetFrame);
    };

    const auto executeEnemyMoveManip = [&](const DecisionPoint decisionPoint) {
        const auto SEQ_START = state;

        // Option 1: No enemy interaction.
        // Since this involves immediately searching for a new decision point without executing anything,
        // need to persist any existing exclusions forward.
        auto exclusions = prevExclusions;
        exclusions.push_back(decisionPoint);
        ExecuteNextDecisionPoint(state, eval, exclusions);

        state = std::move(SEQ_START);

        auto enemyIdx = 0;
        if (decisionPoint == DecisionPoint::ManipEnemy2Move) enemyIdx = 1;
        if (decisionPoint == DecisionPoint::ManipEnemy3Move) enemyIdx = 2;

        // Option 2: Evaluate.
        ManipulateEnemyMove(state, eval, enemyIdx, targetFrame, expectedBallPos, exclusions);
    };

    switch (decisionPoint)
    {
    case DecisionPoint::LaunchBall:
        LaunchBall(state, eval);
        break;

    case DecisionPoint::BounceBall1:
    {
        auto results = BounceBall(state, eval, 0, targetFrame, expectedBallPos);
        QueueJobs(std::move(results));
        break;
    }

    case DecisionPoint::BounceBall2:
    {
        auto results = BounceBall(state, eval, 1, targetFrame, expectedBallPos);
        QueueJobs(std::move(results));
        break;
    }

    case DecisionPoint::BounceBall3:
    {
        auto results = BounceBall(state, eval, 2, targetFrame, expectedBallPos);
        QueueJobs(std::move(results));
        break;
    }

    case DecisionPoint::CollectPowerup:
        CollectPowerup(state, eval);
        break;

    case DecisionPoint::ManipPowerup:
        ManipulatePowerup(state, eval, targetFrame);
        break;

    case DecisionPoint::ManipEnemySpawn:
        executeEnemyManip();
        break;

    case DecisionPoint::HitEnemy1WithPaddle:
    case DecisionPoint::HitEnemy2WithPaddle:
    case DecisionPoint::HitEnemy3WithPaddle:
        executeEnemyPaddleHit(decisionPoint);
        break;

    case DecisionPoint::ManipEnemy1Move:
    case DecisionPoint::ManipEnemy2Move:
    case DecisionPoint::ManipEnemy3Move:
        executeEnemyMoveManip(decisionPoint);
        break;

    case DecisionPoint::None_LevelEnded:
        // No action. In theory level endings should already have been specially handled above,
        // but since the frame limit is a shared resource the detected level ending may no longer
        // be applicable.
        break;

    case DecisionPoint::None_LimitReached:
    case DecisionPoint::None_BallLost:
    case DecisionPoint::Invalid:
    default:
        // No action.
        break;
    }
}

// Manipulate which gate the next enemy will exit from.
ResultSet EvalOp::ManipulateEnemySpawn(GameState& state, EvalState& eval, const unsigned int targetFrame)
{
    ResultSet manipResults;

    const auto SEQ_START = state;

    // Sanity check.
    if (!eval.manipulateEnemies) return manipResults;

    // Sanity check.
    if (targetFrame > eval.frameLimit())
    {
        if (_Debug())
        {
            DebugDumpState(state, eval);
            printf("ManipulateEnemySpawn: Target frame %d greater than frame limit %d!\n", targetFrame, eval.frameLimit());
            exit(0);
        }
        else
        {
            return manipResults;
        }
    }

    bool firstFrame;

    const auto generateResult = [&] {
        // We're in position; wait until just before the gate opens.
        while (state._frame < targetFrame - 1)
        {
            firstFrame = false;
            GameOp::ExecuteInput(state, NoInput);
        }

        if (state._frame == targetFrame - 1 && !firstFrame)
        {
            // Store the one-frame-before state. Enemy updates happen before paddle moves
            // during the game's main loop, so this saves a frame that can be spent elsewhere.
            manipResults.emplace_back(Result{ state, eval });

            // Need to make sure the gate actually opened; if for some reason it didn't, undo
            // the previous action so we don't needlessly evaluate the branch.
            GameOp::ExecuteInput(state, NoInput);
            if (state.enemyGateState != 1 && !firstFrame)
            {
                manipResults.pop_back();
            }
        }
    };

    state = SEQ_START;

    // Option 2: Left gate.
    firstFrame = true;
    if (state.paddleX >= 0x68)
    {
        MovePaddleTo(state, 0x67);
        firstFrame = false;
    }

    generateResult();

    state = std::move(SEQ_START);

    // Option 3: Right gate.
    firstFrame = true;
    if (state.paddleX < 0x68)
    {
        // 0x68 isn't a multiple of 3 so bump up to 0x6a.
        MovePaddleTo(state, 0x6a);
        firstFrame = false;
    }

    generateResult();

    return manipResults;
}

void EvalOp::HitEnemyWithPaddle(GameState& state, EvalState& eval, const unsigned int enemyIdx, const unsigned int targetFrame)
{
    const auto maxHitWindow = 75;

    // Sanity check.
    if (!eval.manipulateEnemies) return;

    const auto SEQ_START = state;

    const auto paddleLeft = state.paddleX;
    const auto paddleRight = state.paddleX + 8 + 8 + 8;
    const auto& enemy = state.enemies[enemyIdx];

    const auto canHitEnemy = [&] {
        // Give up if we ran out of time to hit the enemy.
        if (ReachedFrameLimit(state, eval)) return false;

        // Give up if we couldn't even make it to the enemy before it dropped below the paddle.
        if (state.enemies[enemyIdx].pos.y > GameConsts::PaddleTop + 4) return false;

        // Give up if the enemy was already destroyed.
        if (!enemy.active) return false;

        return true;
    };

    // Option 1: Let the enemy hit the paddle directly.
    {
        // TODO figure out if the exact position of the paddle is ever important
        auto targetX = enemy.pos.x + 0xc - GameConsts::FieldMinX;
        targetX -= (targetX % 3);
        targetX += GameConsts::FieldMinX;

        MathUtil::Clamp(targetX, GameConsts::PaddleMin, GameConsts::PaddleMax);

        MovePaddleTo(state, targetX);
        if (canHitEnemy())
        {
            while (enemy.active)
            {
                GameOp::ExecuteInput(state, NoInput);

                if (!canHitEnemy()) break;
                if (EnemyOverlapsPaddle(enemy, state.paddleX)) break;
            }

            if (EnemyOverlapsPaddle(enemy, state.paddleX))
            {
                ExecuteNextDecisionPoint(state, eval);
            }
        }
    }

    if (!eval.allEnemyHitOptions) return;

    state = SEQ_START;

    const auto evaluateHitWindow = [&](const ControllerInput leftRightInput) {
        while (enemy.pos.y + 0xe + 1 < GameConsts::PaddleTop)
        {
            GameOp::ExecuteInput(state, NoInput);

            if (!canHitEnemy()) break;
        }

        // Also wait out the move timer since the update order is enemy move -> check paddle collis -> move paddle.
        // Check for 1 instead of 0 since we need an extra frame to actually perform the paddle move.
        while (enemy.moveTimer > 1)
        {
            GameOp::ExecuteInput(state, NoInput);

            if (!canHitEnemy()) break;
        }

        if (canHitEnemy())
        {
            const auto SUBSEQ_START = state;

            // Map from destruction frame to corresponding game state. There's a frame rule
            // for when enemies get destroyed, so no reason to explore more than one option
            // that ends on the same frame.
            std::unordered_map<unsigned int, GameState> results;

            for (int frameWait = 1; frameWait <= maxHitWindow; frameWait++)
            {
                state = SUBSEQ_START;

                GameOp::ExecuteInput(state, NoInput, frameWait);
                GameOp::ExecuteInput(state, leftRightInput);
                
                const auto initFrame = state._frame;

                if (EnemyOverlapsPaddle(enemy, state.paddleX) && !ReachedFrameLimit(state, eval))
                {
                    auto JUST_DESTROYED = state;
                    while (enemy.destrFrame != 2 && !ReachedFrameLimit(state, eval))
                    {
                        GameOp::ExecuteInput(state, NoInput);

                        if (enemy.destrFrame == 0) break;
                    }

                    if (enemy.destrFrame == 2)
                    {
                        if (results.find(state._frame) == results.end())
                        {
                            // No result yet for this frame. Add an entry for the enemy destruction.
                            results[state._frame] = std::move(JUST_DESTROYED);
                        }
                    }
                    else
                    {
                        // The paddle overlaps the enemy, but the enemy wasn't actually destroyed,
                        // or we ran out of time. No point in testing longer delays, so break here.
                        break;
                    }
                }
                else
                {
                    // Sanity check, should already broken out of the loop on a previous iteration (see above).
                    break;
                }
            }

            for (auto&& result : results)
            {
                ExecuteNextDecisionPoint(result.second, eval);
            }
        }
    };


    // Hit the enemy from the left on each available frame.
    // TODO figure out if both left-side and right-side hits are actually necessary

    if (enemy.pos.x > GameConsts::PaddleRightEdgeMin + 5)
    {
        // The enemy can miss the paddle on the right side.
        // Move paddle to the left of the enemy location.

        auto targetX = (enemy.pos.x) - 24 - 5 - GameConsts::FieldMinX - 1;
        targetX -= (targetX % 3);
        targetX += GameConsts::FieldMinX;

        MovePaddleTo(state, targetX);
        evaluateHitWindow(RightInput);
    }

    state = std::move(SEQ_START);

    // Hit the enemy from the right on each available frame.
    // TODO generalize
    // TODO figure out if both left-side and right-side hits are actually necessary

    if (enemy.pos.x + 0xc < GameConsts::PaddleMax)
    {
        // The enemy can miss the paddle on the left side.
        // Move paddle to the right of the enemy location.

        auto targetX = (enemy.pos.x + 0xc) - GameConsts::FieldMinX;
        targetX += 3 - (targetX % 3);
        targetX += GameConsts::FieldMinX;

        MovePaddleTo(state, targetX);
        evaluateHitWindow(LeftInput);
    }
}

void EvalOp::ManipulateEnemyMove(GameState& state, EvalState& eval, const unsigned int enemyIdx, const unsigned int targetFrame, const unsigned int moveMask,
                                 const std::vector<DecisionPoint>& prevExclusions)
{
    const auto SEQ_START = state;

    const auto paddleStart = state.paddleX;

    // Calculate how many frames of movement are available. Subtract one because the random
    // enemy movement actually happens prior to the paddle move during a frame.
    const auto movementFrames = static_cast<int>(targetFrame) - static_cast<int>(state._frame) - 1;

    // Identify a reasonable target location for the paddle. This reduces the possibility
    // that a manipulation position will result in not being able to handle the next
    // decision point.

    unsigned int nextTargetFrame, expectedBallPos;
    const auto nextDecisionPoint = GetNextDecisionPoint(state, eval, nextTargetFrame, expectedBallPos, prevExclusions);

    unsigned int favorPaddleLocation;

    switch (nextDecisionPoint)
    {
    case DecisionPoint::BounceBall1:
    case DecisionPoint::BounceBall2:
    case DecisionPoint::BounceBall3:
        favorPaddleLocation = expectedBallPos;
        break;

    case DecisionPoint::ManipEnemySpawn:
        favorPaddleLocation = 0x68;
        break;

    default:
        favorPaddleLocation = paddleStart;
        break;
    }
    
    state = SEQ_START;

    // Construct a map of the best paddle locations for each movement possibility.

    std::unordered_map<unsigned int, unsigned int> moveMap;
    moveMap[0] = 9999;
    moveMap[1] = 9999;
    moveMap[2] = 9999;
    moveMap[3] = 9999;
    moveMap[4] = 9999;

    while (state._frame < targetFrame - 1)
    {
        GameOp::ExecuteInput(state, NoInput);
    }

    // Enemy movement occurs after score updates but before paddle and ball updates.
    // Generate a special game state that combines the relevant values from before
    // and after the RN is requested.
    auto manipState = state;
    GameOp::ExecuteInput(state, NoInput);
    const auto manipScore = state.score;
    const auto manipMysteryInput = state._enemyMysteryInput;

    // Figure out what the input carry bit should be.
    auto carry = -1;
    if (moveMask == 0b11111)
    {
        carry = 0;
    }
    else if (moveMask == 0b00110)
    {
        carry = (manipState.enemies[enemyIdx].pos.x >= 0xb0);
    }
    else if (moveMask == 0b01001)
    {
        carry = 1;
    }
    else
    {
        printf("Unknown move mask %d\n", moveMask);
        exit(0);
    }

    // Warp the paddle to each position and note the generated random movements.
    for (auto pos = GameConsts::PaddleMin; pos <= GameConsts::PaddleMax; pos += 3)
    {
        manipState.paddleX = pos;
        manipState.score = manipScore;
        manipState.mysteryInput = manipMysteryInput;

        const auto rn = GameOp::_RandNum(manipState, carry);

        auto expectedMove = -1;
        if (moveMask == 0b11111)
        {
            auto rnModFour = (rn % 4);
            if (rnModFour == 0 || rnModFour == 2)
            {
                expectedMove = 4;
            }
            else
            {
                expectedMove = rnModFour;
            }
        }
        else if (moveMask == 0b00110)
        {
            expectedMove = (rn % 2 == 0 ? 2 : 1);
        }
        else if (moveMask == 0b01001)
        {
            expectedMove = ((rn % 2 == 0) ? 3 : 0);
        }

        const auto bestDist = std::abs(static_cast<int>(moveMap[expectedMove] - favorPaddleLocation));
        const auto currDist = std::abs(static_cast<int>(pos - favorPaddleLocation));
        const auto distFromStart = std::abs(static_cast<int>(pos - paddleStart));

        if (currDist < bestDist)
        {
            // New best distance; check if there are enough frames to reach it.
            if (movementFrames * 3 >= distFromStart)
            {
                // Reachable, store new position.
                moveMap[expectedMove] = pos;
            }
        }
    }

    // Check if there are actually multiple manipulation options; if there's only one (or zero),
    // no point in continuing; the default path has already been evaluated.
    auto numOptions = 0;
    for (auto&& entry : moveMap)
    {
        if (entry.second != 9999)
        {
            numOptions++;
        }
    }

    if (numOptions > 1)
    {
        // For each generated movement, move the paddle to the position and wait until the target frame.

        for (auto&& entry : moveMap)
        {
            const auto pos = entry.second;
            if (pos != 9999)
            {
                state = SEQ_START;
                MovePaddleTo(state, pos);

                while (state._frame < targetFrame - 1)
                {
                    GameOp::ExecuteInput(state, NoInput);
                }

                // Enemy updates happen before paddle moves, so we can save a frame by stopping
                // just before the actual movement happens.
                auto resultState = state;

                GameOp::ExecuteInput(state, NoInput);

                // If the enemy didn't actually move randomly, or it moved in a different random direction
                // than expected, give up and don't evaluate the branch.
                // Theory: This happens when there are two random-move events in a row, and we're in the
                // "do nothing, no evaluation" branch of the first one, and the paddle movement here changes
                // the first manipulation implicitly such that the second movement is invalidated. This case
                // will be automatically handled when doing the other branches of the first event, so no need
                // to worry about missing anything by skipping it here.

                auto evaluate = true;
                if (state._justMovedEnemy == -1)
                {
                    evaluate = false;
                    if (_Debug())
                    {
                        PrintGameState(state, eval);
                        printf("Expected random enemy movement but no movement occurred!\n");
                    }
                }

                const auto actualMove = state.enemies[state._justMovedEnemy].moveDir;
                if (actualMove != entry.first)
                {
                    evaluate = false;
                    if (_Debug())
                    {
                        PrintGameState(state, eval);
                        printf("Manipulation mismatch, expected %d but got %d\n", entry.first, actualMove);
                    }
                }

                if (evaluate)
                {
                    ExecuteNextDecisionPoint(resultState, eval);
                }
            }
        }
    }
}

void EvalOp::CollectPowerup(GameState& state, EvalState& eval)
{
    const auto SEQ_START = state;

    const auto paddleLeft = state.paddleX;
    const auto paddleRight = state.paddleX + 8 + 8 + 8;

    const auto canCollectPowerup = [&] {
        // Give up if we ran out of time to collect the powerup.
        if (ReachedFrameLimit(state, eval)) return false;

        // Give up if we couldn't even make it to the powerup before it was lost.
        if (state.powerupPos.y > GameConsts::PaddleTop + 4) return false;

        return true;
    };

    // Option 1: Collect the powerup directly.
    {
        // TODO figure out if the exact position of the paddle is ever important
        auto targetX = state.powerupPos.x + 8 - GameConsts::FieldMinX;
        targetX -= (targetX % 3);
        targetX += GameConsts::FieldMinX;

        MathUtil::Clamp(targetX, GameConsts::PaddleMin, GameConsts::PaddleMax);

        MovePaddleTo(state, targetX);
        while (state.ownedPowerup == Powerup::None)
        {
            GameOp::ExecuteInput(state, NoInput);

            if (!canCollectPowerup()) return;
        }

        ExecuteNextDecisionPoint(state, eval);
    }

    bool collectedFromLeft = false;

    state = SEQ_START;

    // Options 2-12: Collect the powerup from the left on each available frame.
    // TODO figure out if both left-side and right-side collection is actually necessary
    if (state.powerupPos.x + 8 > GameConsts::PaddleRightEdgeMin)
    {
        // The powerup can miss the paddle on the right side.
        // Move paddle to the left of the powerup location.
        
        auto targetX = (state.powerupPos.x + 8) - 8 - 8 - 8 - 8 - GameConsts::FieldMinX - 1;
        targetX -= (targetX % 3);
        targetX += GameConsts::FieldMinX;

        MovePaddleTo(state, targetX);
        while (state.powerupPos.y + 8 < GameConsts::PaddleTop - 1)
        {
            GameOp::ExecuteInput(state, NoInput);

            if (!canCollectPowerup()) break;
        }

        if (canCollectPowerup())
        {
            const auto SUBSEQ_START = state;

            const auto collectWindow = 12;
            for (int frameWait = 1; frameWait < collectWindow; frameWait++)
            {
                state = SUBSEQ_START;

                GameOp::ExecuteInput(state, NoInput, frameWait);
                GameOp::ExecuteInput(state, RightInput);

                if (state.ownedPowerup != Powerup::None && !ReachedFrameLimit(state, eval))
                {
                    collectedFromLeft = true;
                    QueueJob({ state, eval });
                }
            }
        }
    }

    if (!eval.allPowerupCollectionOptions && collectedFromLeft) return;

    state = std::move(SEQ_START);

    // Options 13-23: Collect the powerup from the right on each available frame.
    // TODO generalize
    // TODO figure out if both left-side and right-side collection is actually necessary
    if (state.powerupPos.x + 8 < GameConsts::PaddleMax)
    {
        // The powerup can miss the paddle on the left side.
        // Move paddle to the right of the powerup location.

        auto targetX = (state.powerupPos.x + 8) - GameConsts::FieldMinX + 1; // TODO possible logic error, +1 with rounding can lead to +4 total
        targetX += 3 - (targetX % 3);
        targetX += GameConsts::FieldMinX;

        MovePaddleTo(state, targetX);
        while (state.powerupPos.y + 8 < GameConsts::PaddleTop - 1)
        {
            GameOp::ExecuteInput(state, NoInput);

            if (!canCollectPowerup()) break;
        }

        if (canCollectPowerup())
        {
            const auto SUBSEQ_START = state;

            const auto collectWindow = 12;
            for (int frameWait = 1; frameWait < collectWindow; frameWait++)
            {
                state = SUBSEQ_START;

                GameOp::ExecuteInput(state, NoInput, frameWait);
                GameOp::ExecuteInput(state, LeftInput);

                if (state.ownedPowerup != Powerup::None && !ReachedFrameLimit(state, eval))
                {
                    QueueJob({ state, eval });
                }
            }
        }
    }
}

void EvalOp::LaunchBall(GameState& state, EvalState& eval)
{
    for (auto delayFrames = 0u; delayFrames <= eval.launchDelayRange; delayFrames++)
    //auto delayFrames = 13u;
    {
        const auto SEQ_START = state;

        std::vector<unsigned int> launchPositions;
        if (eval.testSinglePaddlePos != 0)
        {
            launchPositions.emplace_back(eval.testSinglePaddlePos);
        }
        else
        {
            for (auto launchPos = GameConsts::PaddleMin; launchPos <= GameConsts::PaddleMax; launchPos += GameConsts::PaddleSpeed)
            {
                launchPositions.emplace_back(launchPos);
            }
        }

        // For each launch position...
        const auto numThreads = GetNumThreads(eval);
        auto threadId = 0;
        for (auto&& launchPos : launchPositions)
        {
            state = SEQ_START;

            MovePaddleTo(state, launchPos);

            GameOp::ExecuteInput(state, NoInput, delayFrames);

            // TODO combine A press with next directional input
            GameOp::ExecuteInput(state, AInput);

            eval.sharedState->perThreadQueue[threadId].push_back(std::make_pair(state, eval));

            ++threadId;
            threadId %= numThreads;
        }

        state = SEQ_START;
    }
}

void EvalOp::ManipulatePowerup(GameState& state, EvalState& eval, const unsigned int targetFrame)
{
    // Sanity check.
    if (state.ownedPowerup != Powerup::None)
    {
        if (_Debug())
        {
            DebugDumpState(state, eval);
            printf("ManipulatePowerup: Powerup already exists!\n");
            exit(0);
        }
        else
        {
            return;
        }
    }

    const auto timeToEvent = targetFrame - state._frame;

    const auto SEQ_START = state;

    std::vector<GameState> results;

    for (auto waitPos = GameConsts::PaddleMin; waitPos <= GameConsts::PaddleMax; waitPos += GameConsts::PaddleSpeed)
    {
        state = SEQ_START;

        const auto steps = GetNumPaddleStepsTo(state, waitPos);
        if (steps > timeToEvent)
        {
            // If a powerup spawns too early to manipulate it from this position, skip the iteration.
            continue;
        }

        GameOp::ExecuteInput(state, (waitPos < state.paddleX ? LeftInput : RightInput), steps);

        auto gotPowerup = false;
        while (!ReachedFrameLimit(state, eval))
        {
            if (state.justSpawnedPowerup)
            {
                gotPowerup = (state.spawnedPowerup == Powerup::Multiball);
                break;
            }

            GameOp::ExecuteInput(state, NoInput);
        }

        if (gotPowerup)
        {
            results.push_back(state);
        }
    }

    if (!eval.allPowerupManipOptions && results.size() > 0)
    {
        // Evaluate the median result.
        ExecuteNextDecisionPoint(results[results.size() / 2], eval);
    }
    else
    {
        for (auto&& result : results)
        {
            ExecuteNextDecisionPoint(result, eval);
        }
    }
}

ResultSet EvalOp::BounceBall(GameState& state, EvalState& eval, const unsigned int ballIdx, const unsigned int targetFrame, const unsigned int expectedBallPos)
{
    ResultSet bounceResults;

    const auto SEQ_START = state;

    const auto paddleStart = state.paddleX;

    // First note where the ball will cross the paddle line.

    const auto ballArrivalFrame = targetFrame;
    const auto framesToArrive = ballArrivalFrame - state._frame;
    auto paddleCentralTarget = expectedBallPos - ((expectedBallPos - GameConsts::FieldMinX) % 3);
    MathUtil::Clamp(paddleCentralTarget, GameConsts::PaddleMin, GameConsts::PaddleMax);

    const auto numFutures = ballArrivalFrame - state._frame;

    while (state._frame < ballArrivalFrame - 1)
    {
        GameOp::ExecuteInput(state, FutureInput);
    }

    if (_Debug() && state.ball[ballIdx]._paddleCollis)
    {
        DebugDumpState(state, eval);
        printf("BounceBall: Ball bounced from paddle too early!\n");
        exit(0);
    }

    const auto JUST_ARRIVING = state;

    const auto ballInRange = [](Ball& ball) {
        return (ball.pos.y + 4 >= GameConsts::PaddleTop
            && GameConsts::PaddleTop + 3 >= ball.pos.y);
    };

    auto anyMismatch = false;

    for (auto&& enemy : state.enemies)
    {
        if (enemy.active && enemy.movementType == MovementType::Downward)
        {
            anyMismatch = true;
            break;
        }
    }

    state._disablePaddleHitbox = true;
    GameOp::ExecuteInput(state, NoInput);
    if (state.ball[ballIdx].pos.x != expectedBallPos || !ballInRange(state.ball[ballIdx]) || JUST_ARRIVING.ball[ballIdx]._paddleCollis)
    {
        // The just-arriving ball position may vary from the originally-estimated ball position
        // if the paddle location affected enemy movements in the level. Note whether there's a
        // mismatch, and use the value to switch to fallback algorithms that don't use the just-
        // arriving state shortcut.
        anyMismatch = true;
    }

    if (ballInRange(state.ball[ballIdx]))
    {
        while (ballInRange(state.ball[ballIdx]) && state._frame < eval.frameLimit())
        {
            for (int i = 0; i < 3; i++)
            {
                if (i != ballIdx && state.ball[i].yCollis && state.ball[i].pos.y == GameConsts::FieldMinY)
                {
                    // If any of the other balls hit the ceiling, the cycle timer gets reset for all balls,
                    // which invalidates the bounce table prediction.
                    anyMismatch = true;
                    break;
                }
            }

            if (anyMismatch) break;
            GameOp::ExecuteInput(state, NoInput);
        }
    }

    auto anyBounce = false;

    std::unordered_map<int, bool> results;
    results[-1] = true;
    results[-2] = true;
    results[-3] = true;
    results[1] = true;
    results[2] = true;
    results[3] = true;

    unsigned int resultCount = 6;

    auto side = -1;
    for (int i = 0; i < 7; i++)
    {
        const auto val = eval.bounceMask[i];

        if (val == '=') side = 1;
        else if (val == 0) break;
        else
        {
            results[(val - 48) * side] = false;
            resultCount--;
        }
    }

    const auto IsUniqueResult = [](const unsigned int ballIdx, const ResultSet& existingResults, const GameState& candidateResult) {
        for (auto&& result : existingResults)
        {
            if (result.first._frame == candidateResult._frame
                && result.first.ball[ballIdx].angle == candidateResult.ball[ballIdx].angle
                && result.first.ball[ballIdx].pos.x == candidateResult.ball[ballIdx].pos.x
                && result.first.ball[ballIdx].pos.y == candidateResult.ball[ballIdx].pos.y
                && result.first.ball[ballIdx].vSign.vx == candidateResult.ball[ballIdx].vSign.vx)
            {
                return false;
            }
        }

        return true;
    };

    const auto CheckPaddleBounceWithSkipping = [&](unsigned int& minMaxBounce, bool& anyMinMaxBounce, const unsigned int paddleTarget)
    {
        auto breakEarly = false;

        if (!eval.allSideHitVariations && !eval.includeBumpOptions && resultCount >= 6)
        {
            // Quit early if all the results have been generated.
            breakEarly = true;
            return breakEarly;
        }

        const auto steps = std::abs(static_cast<int>(paddleStart) - static_cast<int>(paddleTarget)) / GameConsts::PaddleSpeed;
        if (steps <= framesToArrive)
        {
            // The paddle can make it to the target position in time. Evaluate.

            // Load the moments-before-arrival state and warp the paddle to the target spot.
            state = JUST_ARRIVING; // TODO skip load on first iter
            state.paddleX = paddleTarget;
            GameOp::ExecuteInput(state, FutureInput);

            const auto result = EvaluateOneBounceOptionAux(state, eval, state.ball[ballIdx]);
            if (result == BounceResult::Bounced)
            {
                // The ball bounced, so use this as a new branch point and store
                // the new edge value.

                minMaxBounce = paddleTarget;
                anyBounce = true;

                const auto angle = state.ball[ballIdx].angle;
                const auto resultIdx = state.ball[ballIdx].vSign.vx * (static_cast<int>(angle) + 1);
                if (!results[resultIdx] || (eval.allSideHitVariations && angle == Angle::Shallow))
                {
                    if (IsUniqueResult(ballIdx, bounceResults, state))
                    {
                        results[resultIdx] = true;
                        resultCount++;

                        ConvertFuturesTo(state, paddleStart > paddleTarget ? Input{ LeftInput, 0 } : Input{ RightInput, 0 }, numFutures, steps);
                        bounceResults.emplace_back(std::pair<GameState, EvalState>{ state, eval });
                    }
                }
            }
            else if (result == BounceResult::Missed)
            {
                anyMinMaxBounce = true;

                // The ball missed the paddle. Any further position will also result
                // in the ball missing, so break early.
                breakEarly = true;
            }
        }

        return breakEarly;
    };

    const auto CanQuitEarly = [&] {
        return (!eval.allSideHitVariations && !eval.includeBumpOptions && resultCount >= 6);
    };

    const auto CheckPaddleBounceNoSkipping = [&](unsigned int& minMaxBounce, bool& anyMinMaxBounce, const unsigned int paddleTarget)
    {
        auto breakEarly = false;

        if (CanQuitEarly())
        {
            // Quit early if all the results have been generated.
            breakEarly = true;
            return breakEarly;
        }

        state = SEQ_START;

        const auto result = EvaluateOneBounceOption(state, eval, state.ball[ballIdx], paddleTarget, targetFrame, expectedBallPos);
        if (result == BounceResult::Bounced)
        {
            // The ball bounced, so use this as a new branch point and store
            // the new edge value.

            minMaxBounce = paddleTarget;
            anyBounce = true;

            const auto angle = state.ball[ballIdx].angle;
            const auto resultIdx = state.ball[ballIdx].vSign.vx * (static_cast<int>(angle) + 1);
            if (!results[resultIdx] || (eval.allSideHitVariations && angle == Angle::Shallow))
            {
                if (IsUniqueResult(ballIdx, bounceResults, state))
                {
                    results[resultIdx] = true;
                    resultCount++;

                    bounceResults.emplace_back(std::pair<GameState, EvalState>{ state, eval });
                }
            }
        }
        else if (result == BounceResult::Missed)
        {
            anyMinMaxBounce = true;

            // The ball missed the paddle. Any further position will also result
            // in the ball missing, so break early.
            breakEarly = true;
        }

        return breakEarly;
    };

    const auto CheckPaddleBounce = [&](unsigned int& minMaxBounce, bool& anyMinMaxBounce, const unsigned int paddleTarget) {
        if (_SimulateEnemies(state)) return CheckPaddleBounceNoSkipping(minMaxBounce, anyMinMaxBounce, paddleTarget);
        else return CheckPaddleBounceWithSkipping(minMaxBounce, anyMinMaxBounce, paddleTarget);
    };

    auto minBounce = GameConsts::PaddleMax;
    auto anyMinBounce = false;

    auto maxBounce = GameConsts::PaddleMin;
    auto anyMaxBounce = false;

    if (eval.useBounceTableLookups && !anyMismatch)
    {
        const auto doBounceTableLookup = [&](const unsigned int paddleTarget) {

            BallInitState ballInit;
            ballInit.speedStage = JUST_ARRIVING.ball[ballIdx].speedStage;
            ballInit.startCycle = JUST_ARRIVING.ball[ballIdx].cycle;
            ballInit.startPos = JUST_ARRIVING.ball[ballIdx].pos;
            ballInit.startDir = (static_cast<int>(JUST_ARRIVING.ball[ballIdx].angle) + 1) * JUST_ARRIVING.ball[ballIdx].vSign.vx;
            ballInit.paddleX = paddleTarget;

            // TODO organize bounce table in "rows" of paddle positions for better caching
            const auto res = eval.sharedState->bounceTable.find(ballInit);

            if (eval.bounceTableDebugChecks)
            {
                auto testState = JUST_ARRIVING;
                testState.paddleX = paddleTarget;

                const auto result = EvaluateOneBounceOptionAux(testState, eval, testState.ball[ballIdx]);
                if (result == BounceResult::Missed && res != eval.sharedState->bounceTable.end())
                {
                    if (eval.treatLookupFailuresAsFatal)
                    {
                        eval.sharedState->frameLimit.store(1);
                    }

                    const auto msg = "Bounce table registers hit but actual result misses!\n";
                    printf(msg);
                    Log::Write(msg);
                }
                else if (result == BounceResult::Bounced && res == eval.sharedState->bounceTable.end())
                {
                    if (eval.treatLookupFailuresAsFatal)
                    {
                        eval.sharedState->frameLimit.store(1);
                    }

                    const auto msg = "Bounce table registers miss but actual result hits!\n";
                    printf(msg);
                    Log::Write(msg);
                }
                else if (result == BounceResult::Bounced && res != eval.sharedState->bounceTable.end())
                {
                    const auto angle = static_cast<Angle>(std::abs(res->second.bounceDir) - 1);
                    const auto expectedAngle = testState.ball[ballIdx].angle;

                    if (angle != expectedAngle)
                    {
                        if (eval.treatLookupFailuresAsFatal)
                        {
                            eval.sharedState->frameLimit.store(1);
                        }

                        const auto msg = "Bounce table angle mismatch! Bounce table angle is " + std::to_string(static_cast<int>(angle))
                            + ", actual angle is " + std::to_string(static_cast<int>(expectedAngle)) + "\n";
                        printf(msg.c_str());
                        Log::Write(msg);
                    }
                }
                else if (result == BounceResult::Missed && res == eval.sharedState->bounceTable.end())
                {
                    // Expected condition, continue.
                }
                else if (result == BounceResult::Invalid)
                {
                    // Expected condition, continue.
                }
                else
                {
                    if (eval.treatLookupFailuresAsFatal)
                    {
                        eval.sharedState->frameLimit.store(1);
                    }

                    const auto msg = "??? Unknown bounce table condition\n";
                    printf(msg);
                    Log::Write(msg);
                }
            }

            if (res != eval.sharedState->bounceTable.end())
            {
                minBounce = std::min(minBounce, res->first.paddleX);
                maxBounce = std::max(maxBounce, res->first.paddleX);
                anyMinBounce = true;
                anyMaxBounce = true;
                anyBounce = true;

                const auto angle = static_cast<Angle>(std::abs(res->second.bounceDir) - 1);
                if (!results[res->second.bounceDir] || (eval.allSideHitVariations && angle == Angle::Shallow))
                {
                    // Ignore the break-early return value since we're not going to miss the ball
                    // and are checking the result table directly here.
                    unsigned int minBounceDummy;
                    bool anyMinBounceDummy;
                    CheckPaddleBounce(minBounceDummy, anyMinBounceDummy, paddleTarget);
                }
            }
            else
            {
                if (res->first.paddleX > minBounce && res->first.paddleX < maxBounce && anyMinBounce && anyMaxBounce)
                {
                    Log::Write("Warning: Paddle pos " + std::to_string(res->first.paddleX) + " misses, but range "
                        + std::to_string(minBounce) + " to " + std::to_string(maxBounce) + " bounces, case not handled!\n");
                }
            }
        };

        // Evaluate from the center outwards. For reasons that are unclear, not all
        // solutions are found when iterating from one side to the other in one sweep.

        for (auto paddleTarget = paddleCentralTarget; paddleTarget >= GameConsts::PaddleMin; paddleTarget -= 3)
        {
            if (CanQuitEarly()) break;
            doBounceTableLookup(paddleTarget);
        }

        // Start at +3 since we already tested the central position.
        for (auto paddleTarget = paddleCentralTarget + 3; paddleTarget <= GameConsts::PaddleMax; paddleTarget += 3)
        {
            if (CanQuitEarly()) break;
            doBounceTableLookup(paddleTarget);
        }
    }
    else
    {
        // Next, evaluate each position left of the target. Keep track of
        // the minimum bounce location so it can be used for ball-bumping later.

        for (auto paddleTarget = paddleCentralTarget; paddleTarget >= GameConsts::PaddleMin; paddleTarget -= 3)
        {
            const auto breakEarly = CheckPaddleBounce(minBounce, anyMinBounce, paddleTarget);
            if (breakEarly) break;
        }

        // Then evaluate each position right of the target. Keep track of the
        // maximum bounce location so it can be used for ball-bumping later.

        // Start at +3 since we already tested the central position.
        for (auto paddleTarget = paddleCentralTarget + 3; paddleTarget <= GameConsts::PaddleMax; paddleTarget += 3)
        {
            const auto breakEarly = CheckPaddleBounce(maxBounce, anyMaxBounce, paddleTarget);
            if (breakEarly) break;
        }
    }

    if (eval.includeBumpOptions && anyBounce)
    {
        if (anyMinBounce && minBounce != GameConsts::PaddleMin)
        {
            state = SEQ_START;

            auto bumpResults = EvaluateOneBumpOption(state, eval, state.ball[ballIdx], ballIdx, ballArrivalFrame, expectedBallPos, minBounce - 3, false);
            for (auto&& result : bumpResults)
            {
                bounceResults.emplace_back(std::move(result));
            }
        }

        if (anyMaxBounce && maxBounce != GameConsts::PaddleMax)
        {
            state = std::move(SEQ_START);

            auto bumpResults = EvaluateOneBumpOption(state, eval, state.ball[ballIdx], ballIdx, ballArrivalFrame, expectedBallPos, maxBounce + 3, true);
            for (auto&& result : bumpResults)
            {
                bounceResults.emplace_back(std::move(result));
            }
        }
    }

    return bounceResults;
}

BounceResult EvalOp::MovePaddleWithConditions(GameState& state, EvalState& eval, Ball& ball, const unsigned int ballArrivalFrame,
                                              const unsigned int expectedBallPos, const unsigned int paddleTarget)
{
    const auto& start = state.paddleX;
    const auto steps = GetNumPaddleStepsTo(state, paddleTarget);

    if (steps == 0)
    {
        // The paddle doesn't have to move at all, so the ball is in the same
        // state as before (arriving) and this function is a no-op.
        return BounceResult::StillArriving;
    }

    for (unsigned int i = 0; i < steps; i++)
    {
        // On the initial frame the ball may still have the collision flag set
        // from a previous bounce.
        if (i != 0 && ball._paddleCollis)
        {
            // The ball already bounced off the paddle, so no point in checking
            // for bounces at this spot.
            return BounceResult::Invalid;
        }

        if (ReachedFrameLimit(state, eval))
        {
            // Time limit reached, no result.
            return BounceResult::Invalid;
        }

        if (state._frame == ballArrivalFrame && ball.pos.x != expectedBallPos)
        {
            // There's a position mismatch, which indicates the ball ended up
            // in a different position than expected due to the paddle movement.
            return BounceResult::Mismatch;
        }

        GameOp::ExecuteInput(state, (start > paddleTarget ? LeftInput : RightInput));
    }

    // Fencepost case, need to check conditions after the final frame of input.

    if (ball._paddleCollis)
    {
        // The ball bounced on the very last frame of movement.
        return BounceResult::Bounced;
    }

    if (ReachedFrameLimit(state, eval))
    {
        // Time limit reached, no result.
        return BounceResult::Invalid;
    }

    return BounceResult::StillArriving;
}

BounceResult EvalOp::EvaluateOneBounceOption(GameState& state, EvalState& eval, Ball& ball, const unsigned int paddleTarget, const unsigned int targetFrame,
                                             const unsigned int expectedBallPos)
{
    const auto initFrame = state._frame;

    // TODO rename targetFrame -> ballArrivalFrame here and elsewhere
    const auto result = MovePaddleWithConditions(state, eval, ball, targetFrame, expectedBallPos, paddleTarget);
    if (result != BounceResult::StillArriving) return result;

    auto firstFrame = (state._frame == initFrame);

    // Note: Should not use the ball arrival frame since the ball may actually bounce
    // a few frames later if it's off the paddle side.
    while (!ReachedFrameLimit(state, eval))
    {
        // Check if the ball was lost.
        if (BallLost(ball)) return BounceResult::Missed;

        // On the initial frame the ball may still have the collision flag set
        // from a previous bounce.
        if (!firstFrame)
        {
            // Check if the ball bounced.
            if (ball._paddleCollis) return BounceResult::Bounced;
        }

        // Check if there's a position mismatch, which indicates the ball ended up
        // in a different position than expected due to the paddle movement.
        if (state._frame == targetFrame && ball.pos.x != expectedBallPos)
        {
            return BounceResult::Mismatch;
        }

        firstFrame = false;

        // Otherwise, wait a frame while the ball continues moving down.
        GameOp::ExecuteInput(state, NoInput);
    }

    // Time limit reached, no result.
    return BounceResult::Invalid;
}

BounceResult EvalOp::EvaluateOneBounceOptionAux(GameState& state, EvalState& eval, Ball& ball)
{
    // Note: Should not use the ball arrival frame since the ball may actually bounce
    // a few frames later if it's off the paddle side.
    while (!ReachedFrameLimit(state, eval))
    {
        // Check if the ball was lost.
        if (BallLost(ball)) return BounceResult::Missed;

        // Check if the ball bounced.
        if (ball._paddleCollis) return BounceResult::Bounced;

        // Otherwise, wait a frame while the ball continues moving down.
        GameOp::ExecuteInput(state, NoInput);
    }

    // Time limit reached, no result.
    return BounceResult::Invalid;
}

ResultSet EvalOp::EvaluateOneBumpOption(GameState& state, EvalState& eval, Ball& ball, const unsigned int ballIdx, const unsigned int ballArrivalFrame,
                                                    const unsigned int expectedBallPos, const unsigned int paddleTarget, const bool bumpLeft)
{
    ResultSet bumpResults;

    const auto initFrame = state._frame;

    const auto result = MovePaddleWithConditions(state, eval, ball, ballArrivalFrame, expectedBallPos, paddleTarget);

    if (result == BounceResult::Bounced)
    {
        // Simply moving the paddle to the target ended up bumping the ball.
        // This usually wouldn't happen since it'd have been detected by the
        // simple-bounce logic, but there's a corner case when the ball's
        // hitting the side close to the paddle line, and moving the paddle
        // slightly closer or farther lets the ball bounce off the side. If this
        // does happen, move on and treat it as a new decision point.
        bumpResults.emplace_back(Result{ state, eval });
        return bumpResults;
    }

    // If the ball is still arriving, it's a bump candidate. Otherwise return.
    if (result != BounceResult::StillArriving) return bumpResults;

    // First allow the ball to cross the paddle line. Note that the ball might
    // already be there or beyond due to time spent moving the paddle.

    while (state._frame < ballArrivalFrame)
    {
        GameOp::ExecuteInput(state, NoInput);
        if (ReachedFrameLimit(state, eval)) return bumpResults;
    }

    if (state._frame == ballArrivalFrame)
    {
        // Check if there's a position mismatch, which indicates the ball ended up
        // in a different position than expected due to the paddle movement.
        if (ball.pos.x != expectedBallPos) return bumpResults;

        // Execute one more frame so the ball's properly at the paddle line. Since the paddle
        // gets updated first, if the ball still needed a frame to come down, the 0-frame-wait
        // paddle move would turn the bump into a regular bounce. Waiting a frame ensures that
        // we're dealing with a proper bump situation.
        GameOp::ExecuteInput(state, NoInput);
        if (ReachedFrameLimit(state, eval)) return bumpResults;
    }

    const auto SEQ_START = state;

    // Next, figure out how long the bump window is.

    state.paddleX = 0xd0;

    const auto firstBumpFrame = state._frame;
    while (!BallLost(ball))
    {
        GameOp::ExecuteInput(state, NoInput);

        if (ReachedFrameLimit(state, eval)) return bumpResults;
    }
    
    auto bumpRange = (state._frame > firstBumpFrame ? state._frame - firstBumpFrame - 1 : 0);

    // Evaluate bumping the ball on each frame.

    for (auto waitFrames = 0u; waitFrames <= bumpRange; waitFrames++)
    {
        state = SEQ_START;

        // TODO optimize
        GameOp::ExecuteInput(state, NoInput, waitFrames);

        if (state._frame != initFrame && ball._paddleCollis)
        {
            if (_Debug())
            {
                DebugDumpState(state, eval);
                printf("EvaluateOneBumpOption: Ball bounced from paddle too early!\n");
                exit(0);
            }
            else
            {
                return bumpResults;
            }
        }

        while (!ReachedFrameLimit(state, eval))
        {
            // Check if the ball was lost.
            if (BallLost(ball)) break;

            // On the initial frame the ball may still have the collision flag set
            // from a previous bounce.
            if (state._frame != initFrame)
            {
                // Check if the ball bounced.
                if (ball._paddleCollis)
                {
                    bumpResults.emplace_back(Result{ state, eval });
                    break;
                }
            }

            // Otherwise, chase the ball for a frame.
            GameOp::ExecuteInput(state, (bumpLeft ? LeftInput : RightInput));
        }
    }

    return bumpResults;
}

std::string EvalOp::InputChainToStringShort(const std::vector<Input>& inputChain)
{
    auto charCount = 0;
    std::string currChar;
    std::string prevChar;
    std::string str;

    for (auto&& input : inputChain)
    {
        if (InputA(input))
        {
            if (InputLeft(input)) currChar = "L";
            else if (InputRight(input)) currChar = "R";
            else currChar = "A";
        }
        else if (InputStart(input)) currChar = "S";
        else if (InputLeft(input)) currChar = "<";
        else if (InputRight(input)) currChar = ">";
        else currChar = "-";

        if (currChar == prevChar)
        {
            charCount++;
        }
        else
        {
            if (charCount <= 1) str += prevChar;
            else str += prevChar + std::to_string(charCount);

            charCount = 1;
        }

        prevChar = currChar;
    }

    if (charCount <= 1) str += currChar;
    else str += currChar + std::to_string(charCount);

    return str;
}

unsigned int EvalOp::BlockProgressPercent(const GameState& state)
{
    const auto startingHits = TotalHits[state.level];
    const auto remainingHits = GetRemainingHits(state);

    return (100 - (100 * remainingHits / startingHits));
}

unsigned int EvalOp::GetRemainingHits(const GameState& state)
{
    auto count = 0u;
    for (auto&& block : state.blocks)
    {
        count += BlkHits(block);
    }

    return count;
}

bool EvalOp::ReachedFrameLimit(const GameState& state, EvalState& eval)
{
    if (state._frame >= eval.frameLimit())
    {
        // Disabled for performance improvements. TODO move to compile-time constant?
        /*if (eval.outputBestAttempts)
        {
            auto outputResult = false;
            const auto hitsRemaining = EvalOp::GetRemainingHits(state);

            if (hitsRemaining < eval.sharedState->bestBlockHitCount.load())
            {
                eval.sharedState->frameLimit.store(eval.sharedState->frameLimit.load() + 10000);

                auto stateCopy = state;

                unsigned int targetFrame, expectedBallPos;
                const auto nextDecision = GetNextDecisionPoint(stateCopy, eval, targetFrame, expectedBallPos);

                eval.sharedState->frameLimit.store(eval.sharedState->frameLimit.load() - 10000);

                if (nextDecision != DecisionPoint::None_BallLost && nextDecision != DecisionPoint::Invalid)
                {
                    // TODO verbose flag?
                    //const auto text = std::to_string(hitsRemaining) + " block hit" + (hitsRemaining == 1 ? "" : "s") + " remaining at frame limit "
                    //    + std::to_string(eval.frameLimit() - eval.startFrame)
                    //    + (eval.testSinglePaddlePos == 0 ? "" : " (observed from launch pos " + std::to_string(eval.testSinglePaddlePos) + ")");
                    //printf("%s\n", text.c_str());
                    //Log::Write(text);

                    eval.sharedState->bestBlockHitCount.store(hitsRemaining);
                    outputResult = true;
                }
            }

            if (outputResult && eval.outputBizHawkMovie)
            {
                OutputBizHawkMovie(state, eval, OutputMode::RemainingHits);
            }
        }*/

        return true;
    }

    // Fallbacks in case we're just executing with nothing happening.
    // This also guards against reentrancy from GetNextDecisionPoint -> ReachedFrameLimit call chaining.
    if (state.inputChain.size() > 2000) return true;
    if (eval.frameLimit() <= 1) return true;

    return false;
}

unsigned int EvalOp::ScoreToId(const unsigned int score)
{
    return (score - (score % 100)) % 1000;
}

void EvalOp::OnFrameAdvance(const GameState& state, EvalState& eval)
{
    if (eval.printCounter == 0)
    {
        if (eval.printState)
        {
            PrintGameState(state, eval);
        }

        eval.printCounter = eval.printRate;
    }
    else
    {
        eval.printCounter--;
    }
}

void EvalOp::PrintLevelLoadScreen(const unsigned int level)
{
    HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleCursorPosition(console, { 0, 0 });

    std::vector<std::string> field;
    field.reserve(0xf0 / 8);

    for (auto i = 0; i < 0xf0; i += 8)
    {
        field.emplace_back("                                                                               ");
    }

    field[10] = "                                   ROUND " + std::to_string(level) + "                                    ";

    for (auto&& str : field)
    {
        printf("%s\n", str.c_str());
    }
}

void EvalOp::PrintGameStartScreen(const bool showPlayerOneText)
{
    HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleCursorPosition(console, { 0, 0 });

    std::vector<std::string> field;
    field.reserve(0xf0 / 8);

    for (auto i = 0; i < 0xf0; i += 8)
    {
        field.emplace_back("                                                                               ");
    }

    field[1] =  "               1UP                 HIGH SCORE                                 ";
    field[2] =  "                 00                   50000                                   ";
    field[7] =  "                                   ARKANOID                                   ";
    if(showPlayerOneText) field[14] = "                                   1 PLAYER                                   ";
    field[16] = "                                   2 PLAYERS                                  ";
    field[20] = "                                     TAITO                                    ";
    field[22] = "                          (C) TAITO CORPORATION 1987                          ";
    field[23] = "                                  LICENSED BY                                 ";
    field[24] = "                            NINTENDO OF AMERICA INC.                          ";

    for (auto&& str : field)
    {
        printf("%s\n", str.c_str());
    }
}

void EvalOp::PrintBlankScreen()
{
    HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleCursorPosition(console, { 0, 0 });

    std::vector<std::string> field;
    field.reserve(0xf0 / 8);

    for (auto i = 0; i < 0xf0; i += 8)
    {
        field.emplace_back("                                                                               ");
    }

    for (auto&& str : field)
    {
        printf("%s\n", str.c_str());
    }
}

void EvalOp::PrintEndingText(unsigned int timeBetweenSteps)
{
    for (int i = 30; i >= 0; i--)
    {
        HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
        SetConsoleCursorPosition(console, { 0, 0 });

        std::vector<std::string> field;
        field.reserve(2 * 0xf0 / 8);

        for (auto j = 0; j < 2 * 0xf0; j += 8)
        {
            field.emplace_back("                                                                               ");
        }

        field[1] =  "               1UP                 HIGH SCORE                                 ";
        field[2] =  "             552920                  552920                                   ";

        field[6 + i] =  "                       DIMENSION-CONTROLLING FORT                             ";
        field[8 + i] =  "                       \"DOH\" HAS NOW BEEN                                     ";
        field[10 + i] = "                       DEMOLISHED, AND TIME                                   ";
        field[12 + i] = "                       STARTED FLOWING REVERSLY.                              ";

        field[15 + i] = "                       \"VAUS\" MANAGED TO ESCAPE                               ";
        field[17 + i] = "                       FROM THE DISTORTED SPACE.                              ";

        field[20 + i] = "                       BUT THE REAL VOYAGE OF                                 ";
        field[22 + i] = "                       \"ARKANOID\" IN THE GALAXY                               ";
        field[24 + i] = "                       HAS ONLY STARTED......                                 ";

        for (auto i = 0; i < 0xf0; i += 8)
        {
            auto str = field[i / 8];
            printf("%s\n", str.c_str());
        }

        EvalOp::Sleep(timeBetweenSteps);
    }
}

void EvalOp::PrintGameState(const GameState& state, const EvalState& eval, const bool introOnly, const bool realtime)
{
    const bool debug = false;

    const auto CellWidth = GameConsts::BlockWidth;
    const auto CellHeight = GameConsts::BlockHeight;
    const auto CellsPerRow = GameConsts::BlocksPerRow;

    std::vector<std::string> field;
    field.reserve(0xf0 / 8);

    for (auto i = 0; i < 0xf0; i += CellHeight)
    {
        field.emplace_back(std::string());

        for (auto j = 0; j <= GameConsts::FieldMaxX + CellWidth; j += CellWidth)
        {
            field.back() += "     ";
        }
    }

    field[1] = "     ";
    for (auto j = 16; j < GameConsts::FieldMaxX; j += CellWidth)
    {
        field[1] += "_____";
    }
    field[1] += "     ";

    for (auto i = 2; i < 0xf0 / 8; i++)
    {
        field[i].at(4) = '|';
        field[i].at(60) = '|';
    }

    if (state.level == 36)
    {
        for (auto row = 5; row <= 16; row++)
        {
            for (auto col = 23; col <= 41; col++)
            {
                field[row].at(col) = '#';
            }
        }
    }
    else
    {
        for (int k = 0; k < GameConsts::BlockTableSize; k++)
        {
            const auto row = 2 + k / CellsPerRow;
            const auto col = (1 + (k % CellsPerRow)) * 5;

            if (BlkType(state.blocks[k]) == BlockType::Gold)
            {
                // TODO ascii pipes?

                field[row].at(col) = '|';
                field[row].at(col + 1) = debug ? 'F' : '#';
                field[row].at(col + 2) = debug ? 'F' : '#';
                field[row].at(col + 3) = debug ? 'F' : '#';
                field[row].at(col + 4) = '|';
            }
            else if (state.blocks[k] != Block(0))
            {
                if (debug)
                {
                    field[row].at(col) = '|';
                    field[row].at(col + 1) = BlkPowerup(state.blocks[k]) ? '=' : '-';
                    field[row].at(col + 2) = std::to_string(BlkHits(state.blocks[k])).at(0);
                    field[row].at(col + 3) = BlkPowerup(state.blocks[k]) ? '=' : '-';
                    field[row].at(col + 4) = '|';
                }
                else
                {
                    field[row].at(col) = '|';
                    field[row].at(col + 1) = '_';
                    field[row].at(col + 2) = '_';
                    field[row].at(col + 3) = '_';
                    field[row].at(col + 4) = '|';

                    if (k > CellsPerRow && BlkType(state.blocks[k - CellsPerRow]) != BlockType::Gold)
                    {
                        field[row - 1].at(col + 1) = '_';
                        field[row - 1].at(col + 2) = '_';
                        field[row - 1].at(col + 3) = '_';
                    }
                }
            }
        }
    }

    if (introOnly)
    {
        field[20].at(30) = 'P';
        field[20].at(31) = 'L';
        field[20].at(32) = 'A';
        field[20].at(33) = 'Y';
        field[20].at(34) = 'E';
        field[20].at(35) = 'R';
        field[20].at(37) = '1';

        field[22].at(31) = 'R';
        field[22].at(32) = 'E';
        field[22].at(33) = 'A';
        field[22].at(34) = 'D';
        field[22].at(35) = 'Y';
    }
    else
    {
        if (state.spawnedPowerup != Powerup::None && state.powerupPos.y < 0xf0)
        {
            const auto row = state.powerupPos.y / CellHeight;
            const auto col = 5 * state.powerupPos.x / CellWidth;

            if (debug)
            {
                field[row].at(col + 1) = '=';
                field[row].at(col + 2) = std::to_string(static_cast<int>(state.spawnedPowerup)).at(0);
                field[row].at(col + 3) = '=';
            }
            else
            {
                field[row].at(col) = '(';
                field[row].at(col + 1) = '_';
                field[row].at(col + 2) = '_';
                field[row].at(col + 3) = '_';
                field[row].at(col + 4) = ')';

                field[row - 1].at(col + 1) = '_';
                field[row - 1].at(col + 2) = '_';
                field[row - 1].at(col + 3) = '_';
            }
        }

        auto idx = 1;
        for (auto&& ball : state.ball)
        {
            if (ball.exists)
            {
                const auto row = ball.pos.y / CellHeight;
                const auto col = 5 * ball.pos.x / CellWidth;

                if (row < field.size())
                {
                    field[row].at(col) = debug ? std::to_string(idx).at(0) : 'O';
                }
            }

            idx++;
        }

        for (auto&& enemy : state.enemies)
        {
            auto enemyChar = ' ';
            if (enemy.exiting) enemyChar = '+';
            if (enemy.active && enemy.pos.y < 230) enemyChar = '*';
            if (enemy.destrFrame > 0) enemyChar = '-';

            if (enemyChar != ' ')
            {
                const auto row = enemy.pos.y / CellHeight;
                const auto col = 5 * enemy.pos.x / CellWidth;

                field[row].at(col) = enemyChar;
                field[row].at(col + 1) = enemyChar;
                field[row + 1].at(col) = enemyChar;
                field[row + 1].at(col + 1) = enemyChar;
            }
        }

        const auto paddleRow = GameConsts::PaddleTop / CellHeight;
        if (state.paddleX > GameConsts::PaddleMax)
        {
            field[paddleRow].at(61) = '*';
            field[paddleRow].at(62) = '*';
            field[paddleRow].at(63) = '*';
            field[paddleRow].at(64) = '*';
        }
        else
        {
            const auto paddleCol = 5 * state.paddleX / CellWidth;

            field[paddleRow].at(paddleCol) = '=';
            field[paddleRow].at(paddleCol + 1) = '=';
            field[paddleRow].at(paddleCol + 2) = '=';
            field[paddleRow].at(paddleCol + 3) = '=';
            field[paddleRow].at(paddleCol + 4) = '=';
            field[paddleRow].at(paddleCol + 5) = '=';
            field[paddleRow].at(paddleCol + 6) = '=';
            field[paddleRow].at(paddleCol + 7) = '=';
            field[paddleRow].at(paddleCol + 8) = '=';
            field[paddleRow].at(paddleCol + 9) = '=';
        }
    }

    std::stringstream stream;
    stream << std::setw(6) << state.score;

    field[4] += stream.str();

    if (eval.frameLimit() >= state._frame)
    {
        field[22] += std::to_string(eval.frameLimit() - state._frame) + "     ";
    }
    field[23] += std::to_string(state._frame) + " / " + std::to_string(eval.frameLimit());

    if (realtime)
    {
        HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
        SetConsoleCursorPosition(console, { 0, 0 });
    }

    for (auto&& str : field)
    {
        printf("%s\n", str.c_str());
    }

    if (introOnly)
    {
        EvalOp::Sleep(2500);
    }
    else if (eval.sleepLen > 0)
    {
        EvalOp::Sleep(eval.sleepLen);
    }
}

unsigned int EvalOp::GetBizHawkMovieFrameLen(const GameState& state)
{
    const auto filename = FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(state.level) + L".txt";
    std::ifstream inFile;
    inFile.open(filename);

    unsigned int frames = 0;
    if (inFile.good())
    {
        std::string str;

        while (std::getline(inFile, str))
        {
            frames++;
        }

        // Two header lines and one footer line.
        frames -= 3;
    }

    inFile.close();

    return frames;
}

std::vector<Input> EvalOp::BizHawkMovieToInputChain(unsigned int level)
{
    return BizHawkMovieToInputChain(FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(level) + L".txt");
}

std::vector<Input> EvalOp::BizHawkMovieToInputChain(const std::wstring& filename)
{
    std::vector<Input> inputChain;

    std::ifstream inFile;
    inFile.open(filename);

    if (inFile.good())
    {
        std::string str;

        // Two header lines.
        std::getline(inFile, str);
        std::getline(inFile, str);

        while (std::getline(inFile, str))
        {
            if (str.find('[') != std::string::npos)
            {
                break;
            }

            Input input = { 0, 0 };
            if (str.find('L') != std::string::npos) input.controller |= LeftInput;
            if (str.find('R') != std::string::npos) input.controller |= RightInput;
            if (str.find('U') != std::string::npos) input.controller |= UpInput;
            if (str.find('D') != std::string::npos) input.controller |= DownInput;
            if (str.find('S') != std::string::npos) input.controller |= StartInput;
            if (str.find('s') != std::string::npos) input.controller |= SelectInput;
            if (str.find('A') != std::string::npos) input.controller |= AInput;
            if (str.find('B') != std::string::npos) input.controller |= BInput;

            inputChain.emplace_back(input);
        }
    }

    inFile.close();

    return inputChain;
}

void EvalOp::OutputBizHawkMovie(const GameState& state, const EvalState& eval, const OutputMode mode)
{
    std::lock_guard<std::mutex> lock(eval.sharedState->genericSentry);

    const auto writeFile = [&](const std::wstring& filename) {
        FileUtil::ClearFile(filename);

        std::ofstream outFile;
        outFile.open(filename);

        outFile << "[Input]" << std::endl;
        outFile << "LogKey:#Reset|Power|#P1 Up|P1 Down|P1 Left|P1 Right|P1 Start|P1 Select|P1 B|P1 A|" << std::endl;

        for (auto&& input : state.inputChain)
        {
            outFile << "|..|";
            outFile << (InputUp(input) ? "U" : ".");
            outFile << (InputDown(input) ? "D" : ".");
            outFile << (InputLeft(input) ? "L" : ".");
            outFile << (InputRight(input) ? "R" : ".");
            outFile << (InputStart(input) ? "S" : ".");
            outFile << (InputSelect(input) ? "s" : ".");
            outFile << (InputB(input) ? "B" : ".");
            outFile << (InputA(input) ? "A" : ".");
            outFile << "|" << std::endl;
        }

        outFile << "[/Input]" << std::endl;

        outFile.close();
    };
    
    const auto levelFilename = FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(state.level) + L".txt";
    const auto debugFilename = FileUtil::ResultsDir() + L"Input Log_debug.txt";
    const auto levelFrameFilename = FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(state.level)
                                    + L"_" + std::to_wstring(state._frame - eval.startFrame) + L".txt";

    const auto levelFrameHitsDirectory = FileUtil::PartialsDir() + LR"(\Level )" + std::to_wstring(state.level) + L" "
                                         + (eval.skipToDepth == 0 ? L"" : L"skips_")
                                         + eval.bounceMask
                                         + (eval.includeBumpOptions ? L"_bumps" : L"") + (eval.manipulateEnemies ? L"_manips" : L"")
                                         + (eval.launchDelayRange > 0 ? L"_delay" + std::to_wstring(eval.launchDelayRange) : L"")
                                         + (eval.ensurePowerupByDepth == 0 ? L"_powerupanywhere" : L"");
    const auto levelFrameHitsFilename = levelFrameHitsDirectory + LR"(\Input Log_)" + std::to_wstring(state.level)
                                        + L"_" + std::to_wstring(state._frame - eval.startFrame)
                                        + L"_" + std::to_wstring(eval.sharedState->bestBlockHitCount.load()) + L"_hits"
                                        + (eval.sharedState->bestBlockHitCount.load() == 0 ? L"_COMPLETE" : L"" ) + L".txt";
    
    const auto scoreId = L"score" + std::to_wstring(ScoreToId(state.score));
    const auto scoreVarFilename = FileUtil::ScoreVarDir() + L"Input Log_" + std::to_wstring(state.level)
                                  + L"_" + scoreId + L".txt";

    if (mode == OutputMode::Debug)
    {
        writeFile(debugFilename);
    }
    else if (mode == OutputMode::RemainingHits)
    {
        CreateDirectory(levelFrameHitsDirectory.c_str(), NULL);
        writeFile(levelFrameHitsFilename);
    }
    else if (mode == OutputMode::ScoreVariant)
    {
        CreateDirectory(FileUtil::ScoreVarDir().c_str(), NULL);
        writeFile(scoreVarFilename);
    }
    else
    {
        writeFile(levelFilename);
        writeFile(levelFrameFilename);
    }
}

void EvalOp::GenerateAllScoreVariants(const unsigned int level, const unsigned int defaultScore, const bool printResults)
{
    const auto inputFilename = FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(level) + L".txt";
    const auto baseInputChain = BizHawkMovieToInputChain(inputFilename);

    EvalState eval;
    eval.sleepLen = 14;

    if (baseInputChain.size() > 0)
    {
        GameState baseState;
        GameOp::Init(baseState);
        GameOp::AdvanceToLevel(baseState, level);
        baseState.score = defaultScore;
        baseState._frame = 0;

        GameState state;
        std::vector<Input> workingInputChain = baseInputChain;

        for (int scoreId = 0; scoreId <= 900; scoreId += 100)
        {
            auto startingScore = defaultScore;
            startingScore -= ScoreToId(startingScore);
            startingScore += scoreId;

            auto powerupDivFrame = 99999;
            auto enemyDivFrame = 99999;
            auto prevEnemyDivFrame = 99999;
            auto expectedMoveDir = 99999;

            const auto initState = [](GameState& state, unsigned int level, unsigned int startingScore, unsigned int scoreId) {
                state = GameState();
                GameOp::Init(state);
                GameOp::AdvanceToLevel(state, level);
                state._frame = 0;

                state.score = startingScore;
            };

            const auto checkLevelCompletion = [&] {
                if (state.currentBlocks == 0)
                {
                    // If this is a resync, the score timing may be slightly different. Allow any
                    // extra score to tally up.
                    while (state.pendingScore > 0)
                    {
                        GameOp::ExecuteInput(state, NoInput);
                    }

                    state.score = startingScore;
                    OutputBizHawkMovie(state, EvalState(), OutputMode::ScoreVariant);
                    return true;
                }

                return false;
            };

            const auto checkInputChainForPowerups = [&](std::vector<Input> testInputChain) {
                powerupDivFrame = 99999;
                enemyDivFrame = 99999;

                initState(state, level, startingScore, scoreId);
                auto refState = baseState;

                for (int i = 0; i < testInputChain.size(); i++)
                {
                    GameOp::ExecuteInput(refState, baseInputChain[i]);
                    GameOp::ExecuteInput(state, testInputChain[i]);

                    if (state.spawnedPowerup != refState.spawnedPowerup)
                    {
                        const auto str = ("Level " + std::to_string(state.level) + " score " + std::to_string(startingScore) + " powerup spawn divergence!");
                        //printf("%s\n", str.c_str());
                        powerupDivFrame = state._frame;
                        break;
                    }
                }
            };

            const auto checkInputChainForEnemies = [&](std::vector<Input> testInputChain) {
                powerupDivFrame = 99999;
                enemyDivFrame = 99999;

                // First just try running the whole level; if it works, no need to worry about enemy manipulation.
                initState(state, level, startingScore, scoreId);
                for (auto&& input : testInputChain)
                {
                    GameOp::ExecuteInput(state, input);
                }

                if (state.currentBlocks == 0)
                {
                    return;
                }

                initState(state, level, startingScore, scoreId);
                auto refState = baseState;

                for(int i = 0; i < testInputChain.size(); i++)
                {
                    GameOp::ExecuteInput(refState, baseInputChain[i]);
                    GameOp::ExecuteInput(state, testInputChain[i]);

                    if (state.enemies[state._justMovedEnemy].moveDir != refState.enemies[state._justMovedEnemy].moveDir)
                    {
                        const auto str = ("Level " + std::to_string(state.level) + " score " + std::to_string(startingScore) + " enemy move dir divergence!");
                        //printf("Level %d score %d enemy move divergence on frame %d, expected %d, got %d\n", level, startingScore, state._frame,
                        //       refState.enemies[state._justMovedEnemy].moveDir, state.enemies[state._justMovedEnemy].moveDir);

                        enemyDivFrame = state._frame;
                        expectedMoveDir = refState.enemies[state._justMovedEnemy].moveDir;
                        break;
                    }
                }
            };

            const auto resyncPowerup = [&] {
                //printf("Re-syncing level %d for powerup divergence on frame %d\n", level, powerupDivFrame);

                unsigned int priorDecisFrame = 0;
                unsigned int powerupSpawnFrame = 0;
                unsigned int nextDecisFrame = 0;
                const auto decisionPoints = ObserveDecisionPoints(workingInputChain, level, defaultScore, true, false);
                for (int i = 0; i < decisionPoints.size(); i++)
                {
                    const auto& point = decisionPoints[i];
                    if (point.first == DecisionPoint::ManipPowerup)
                    {
                        priorDecisFrame = decisionPoints[i - 1].second;
                        powerupSpawnFrame = decisionPoints[i].second;
                        nextDecisFrame = decisionPoints[i + 1].second;
                    }
                }

                initState(state, level, startingScore, scoreId);

                auto destPaddleX = 0;
                while (state._frame < nextDecisFrame)
                {
                    GameOp::ExecuteInput(state, workingInputChain[state._frame]);
                }

                destPaddleX = state.paddleX;


                initState(state, level, startingScore, scoreId);

                while (state._frame < priorDecisFrame)
                {
                    GameOp::ExecuteInput(state, workingInputChain[state._frame]);
                }

                const auto SEQ_START = state;

                std::vector<Input> bestInputChain;
                unsigned int bestDist = 99999;
                const auto startingPos = state.paddleX;

                for (int pos = GameConsts::PaddleMin; pos <= GameConsts::PaddleMax; pos += 3)
                {
                    state = SEQ_START;
                    MovePaddleTo(state, pos);

                    while (state._frame < powerupSpawnFrame)
                    {
                        GameOp::ExecuteInput(state, NoInput);
                    }

                    if (state.justSpawnedPowerup)
                    {
                        if (state.spawnedPowerup == Powerup::Multiball)
                        {
                            //printf(" -> spawned multiball\n");

                            MovePaddleTo(state, destPaddleX);

                            if (state._frame <= nextDecisFrame)
                            {
                                while (state._frame < nextDecisFrame)
                                {
                                    GameOp::ExecuteInput(state, NoInput);
                                }

                                while (state._frame < workingInputChain.size())
                                {
                                    GameOp::ExecuteInput(state, workingInputChain[state._frame]);
                                }

                                //printf("  --> returned to position in time\n");

                                const auto dist = static_cast<unsigned int>(abs(static_cast<int>(pos) - static_cast<int>(startingPos)));
                                if (dist < bestDist)
                                {
                                    bestInputChain = state.inputChain;
                                    //printf("   ---> registered new best input chain\n");
                                }
                            }
                            else
                            {
                                //printf("  (ran out of frames)\n");
                            }
                        }
                        else
                        {
                            //printf(" (spawned powerup %d)\n", static_cast<int>(state.spawnedPowerup));
                        }
                    }
                    else
                    {
                        //printf("Failed to spawn powerup\n");
                    }
                }

                if (bestInputChain.size() > 0)
                {
                    workingInputChain = bestInputChain;
                    return true;
                }

                return false;
            };

            const auto resyncEnemy = [&] {
                //printf("Re-syncing level %d for enemy divergence on frame %d\n", level, enemyDivFrame);

                unsigned int priorDecisFrame = 0;
                unsigned int enemyManipFrame = 0;
                unsigned int nextDecisFrame = 0;
                const auto decisionPoints = ObserveDecisionPoints(workingInputChain, level, defaultScore, true, true);
                for (int i = 0; i < decisionPoints.size(); i++)
                {
                    const auto& point = decisionPoints[i];
                    if ((point.first == DecisionPoint::ManipEnemy1Move
                        || point.first == DecisionPoint::ManipEnemy2Move
                        || point.first == DecisionPoint::ManipEnemy3Move)
                        && point.second == enemyDivFrame)
                    {
                        priorDecisFrame = decisionPoints[i - 1].second;
                        enemyManipFrame = decisionPoints[i].second;

                        // Find the next decision point that's not a movement manipulation. Any move manips
                        // that don't work out will be caught and corrected by this process in a later pass.
                        for (int j = i + 1; j < decisionPoints.size(); j++)
                        {
                            if (decisionPoints[j].first != DecisionPoint::ManipEnemy1Move
                                && decisionPoints[j].first != DecisionPoint::ManipEnemy2Move
                                && decisionPoints[j].first != DecisionPoint::ManipEnemy3Move)
                            {
                                nextDecisFrame = decisionPoints[j].second;
                                break;
                            }
                        }
                        break;
                    }
                }

                if (prevEnemyDivFrame != 99999)
                {
                    priorDecisFrame = prevEnemyDivFrame;
                }

                initState(state, level, startingScore, scoreId);

                auto destPaddleX = 0;
                while (state._frame < nextDecisFrame)
                {
                    GameOp::ExecuteInput(state, workingInputChain[state._frame]);
                }

                destPaddleX = state.paddleX;


                initState(state, level, startingScore, scoreId);

                while (state._frame < priorDecisFrame)
                {
                    GameOp::ExecuteInput(state, workingInputChain[state._frame]);
                }

                const auto SEQ_START = state;

                std::vector<Input> bestInputChain;
                unsigned int bestDist = 99999;
                const auto startingPos = state.paddleX;

                for (int pos = GameConsts::PaddleMin; pos <= GameConsts::PaddleMax; pos += 3)
                {
                    state = SEQ_START;
                    MovePaddleTo(state, pos);

                    while (state._frame < enemyManipFrame)
                    {
                        GameOp::ExecuteInput(state, NoInput);
                        //PrintGameState(state, eval);
                    }

                    if (state._justMovedEnemy >= 0)
                    {
                        if (state.enemies[state._justMovedEnemy].moveDir == expectedMoveDir)
                        {
                            //printf(" -> got desired move dir %d\n", expectedMoveDir);

                            MovePaddleTo(state, destPaddleX);

                            if (state._frame <= nextDecisFrame)
                            {
                                while (state._frame < nextDecisFrame)
                                {
                                    GameOp::ExecuteInput(state, NoInput);
                                }

                                while (state._frame < workingInputChain.size())
                                {
                                    GameOp::ExecuteInput(state, workingInputChain[state._frame]);
                                }

                                //printf("  --> returned to position in time\n");

                                const auto dist = static_cast<unsigned int>(abs(static_cast<int>(pos) - static_cast<int>(startingPos)));
                                if (dist < bestDist)
                                {
                                    bestInputChain = state.inputChain;
                                    bestDist = dist;
                                    //printf("   ---> registered new best input chain\n");
                                }

                                //checkLevelCompletion();
                            }
                            else
                            {
                                while (state._frame < workingInputChain.size())
                                {
                                    GameOp::ExecuteInput(state, workingInputChain[state._frame]);
                                }

                                //checkLevelCompletion();

                                //printf("  (ran out of frames)\n");
                            }
                        }
                        else
                        {
                            //printf(" (got movement dir %d)\n", state.enemies[state._justMovedEnemy].moveDir);
                        }
                    }
                    else
                    {
                        //printf("Failed to get enemy movement\n");
                    }
                }

                prevEnemyDivFrame = enemyDivFrame;

                if (bestInputChain.size() > 0)
                {
                    workingInputChain = bestInputChain;
                    return true;
                }

                return false;
            };

            initState(state, level, startingScore, scoreId);
            for (auto&& input : baseInputChain)
            {
                GameOp::ExecuteInput(state, input);
            }

            if (checkLevelCompletion())
            {
                if(printResults) printf("Existing solution works for level %d score %d\n", level, startingScore);
            }
            else
            {
                auto count = 0;
                checkInputChainForPowerups(workingInputChain);
                while (powerupDivFrame != 99999)
                {
                    if (!resyncPowerup())
                    {
                        //printf("Failed to find any powerup resync patterns, quitting early\n");
                        break;
                    }

                    checkInputChainForPowerups(workingInputChain);

                    if (++count >= 10)
                    {
                        //printf("Failed to resync powerups in 10 attempts\n");
                        break;
                    }
                }

                count = 0;
                checkInputChainForEnemies(workingInputChain);
                while (enemyDivFrame != 99999)
                {
                    if (!resyncEnemy())
                    {
                        //printf("Failed to find any enemy resync patterns, quitting early\n");
                        break;
                    }

                    checkInputChainForEnemies(workingInputChain);

                    if (++count >= 10)
                    {
                        //printf("Failed to resync enemies in 10 attempts\n");
                        break;
                    }
                }

                if (checkLevelCompletion())
                {
                    if(printResults) printf("== Resync successful for level %d score %d ==\n", level, startingScore);
                }
                else
                {
                    if(printResults) printf("** Resync not successful for level %d score %d **\n", level, startingScore);
                }
            }
        }
    }
}

void EvalOp::CombineMovieFiles(const std::vector<LevelParams>& defaultParams)
{
    printf("Combining movie files\n");

    for (int i = 3; i <= 36; i++)
    {
        GenerateAllScoreVariants(i, defaultParams[i].startingScore, false);
    }

    const auto outputFilename = FileUtil::ResultsDir() + L"Input Log_Combined.txt";
    FileUtil::ClearFile(outputFilename);

    std::ofstream outFile;
    outFile.open(outputFilename);

    outFile << "[Input]" << std::endl;
    outFile << "LogKey:#Reset|Power|#P1 Up|P1 Down|P1 Left|P1 Right|P1 Start|P1 Select|P1 B|P1 A|" << std::endl;


    // Prepend game-start input.

    for (int i = 0; i < 12; i++)
    {
        outFile << "|..|........|" << std::endl;
    }

    outFile << "|..|....S...|" << std::endl;

    for (int i = 0; i < 552; i++)
    {
        outFile << "|..|........|" << std::endl;
    }

    auto prevEndingScore = 0;
    for (int i = 1; i <= 36; i++)
    {
        const auto basicInputFilename = FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(i) + L".txt";
        const auto scoreId = ScoreToId(prevEndingScore);
        const auto scoreIdStr = L"score" + std::to_wstring(scoreId);
        const auto scoreSpecificFilename = FileUtil::ScoreVarDir() + L"Input Log_" + std::to_wstring(i) + L"_" + scoreIdStr + L".txt";

        auto inputFilename = scoreSpecificFilename;
        auto inputChain = BizHawkMovieToInputChain(scoreSpecificFilename);
        if (inputChain.empty())
        {
            if(i >= 3) printf("Warning: No input file for level %d score %d\n", i, scoreId);
            inputChain = BizHawkMovieToInputChain(basicInputFilename);
            inputFilename = basicInputFilename;
        }

        GameState state;
        GameOp::Init(state);
        GameOp::AdvanceToLevel(state, i);
        state.score = prevEndingScore;

        for (int i = 0; i < inputChain.size(); i++)
        {
            GameOp::ExecuteInput(state, inputChain[i]);
        }

        prevEndingScore = state.score;

        std::ifstream inFile;
        inFile.open(inputFilename);

        if (inFile.good())
        {
            std::string str;
            std::string prevStr;

            // Seek past the two header lines.
            std::getline(inFile, str);
            std::getline(inFile, str);

            while (std::getline(inFile, str))
            {
                // Use a prevStr cache to avoid including the footer line.
                if (!prevStr.empty())
                {
                    outFile << prevStr << std::endl;
                }
                prevStr = str;
            }

            if (i != GameConsts::BossLevel)
            {
                // Append frames for the level transition.
                for (int i = 0; i < 297; i++)
                {
                    outFile << "|..|........|" << std::endl;
                }
            }
        }
        else
        {
            break;
        }
    }

    outFile << "[/Input]" << std::endl;

    outFile.close();
}

DecisionSet EvalOp::ObserveDecisionPoints(const std::vector<Input>& inputChain, const unsigned int level, const unsigned int startingScore,
                                          const bool includeStandardEnemyManips, const bool includeEnemyMoveManips, const bool printValues)
{
    GameState state;
    GameOp::Init(state);
    GameOp::AdvanceToLevel(state, level);
    state.score = startingScore;
    state._frame = 0;

    EvalState eval;
    eval.sharedState->frameLimit.store(99999);
    eval.depth = 0;
    eval.depthLimit = 999;
    eval.timeLimit = 0;
    eval.manipulateEnemies = includeStandardEnemyManips;
    eval.manipulateEnemyMoves = includeEnemyMoveManips;
    
    std::vector<DecisionPoint> exclusions;
    if (!includeStandardEnemyManips)
    {
        exclusions = { DecisionPoint::HitEnemy1WithPaddle,
                       DecisionPoint::HitEnemy2WithPaddle,
                       DecisionPoint::HitEnemy3WithPaddle,
                       DecisionPoint::ManipEnemySpawn };
    }

    if (!includeEnemyMoveManips)
    {
        exclusions.push_back(DecisionPoint::ManipEnemy1Move);
        exclusions.push_back(DecisionPoint::ManipEnemy2Move);
        exclusions.push_back(DecisionPoint::ManipEnemy3Move);
    }

    DecisionSet decisionPoints;
    
    while (state._frame < inputChain.size())
    {
        unsigned int targetFrame, expectedBallPos;
        const auto includeEnemyActions = true;
        auto stateCopy = state;

        const auto decisionPoint = EvalOp::GetNextDecisionPoint(stateCopy, eval, targetFrame, expectedBallPos, exclusions);

        // The target frame represents which frame the decision point occurs on. For the
        // purposes of this function, it indicates what frame to execute up to in order to
        // go beyond the decision point. E.g. if an enemy is generated on frame 22, executing
        // through frame 22 ensures that the enemy has been generated and the next decision
        // point can be detected.
        // Special case: Ball-launching is detected immediately, so push the target frame
        // out by one.
        if (decisionPoint == DecisionPoint::LaunchBall) targetFrame++;

        const auto entry = std::make_pair(decisionPoint, targetFrame);

        // Ball-bounce arrival frames are when the ball crosses the paddle line, but the actual
        // collision may be a few frames later if we're doing a corner hit or bump, so the same
        // decision point could be returned again. If that happens, overwrite the latest entry
        // with the new decision point.
        if (decisionPoints.size() > 0 && decisionPoints.back().first == decisionPoint && decisionPoints.back().second == targetFrame - 1)
        {
            decisionPoints.pop_back();
        }

        decisionPoints.emplace_back(std::move(entry));

        if (decisionPoint == DecisionPoint::Invalid) break;

        while (state._frame < targetFrame && state._frame < inputChain.size())
        {
            GameOp::ExecuteInput(state, inputChain[state._frame]);
        }
    }

    if (printValues)
    {
        Log::Write("Level " + std::to_string(level) + " decision points:");
        std::unordered_map<DecisionPoint, std::string> strMap = 
        {
            { DecisionPoint::LaunchBall, "Launch Ball" },
            { DecisionPoint::BounceBall1, "Bounce Ball 1" },
            { DecisionPoint::BounceBall2, "Bounce Ball 2" },
            { DecisionPoint::BounceBall3, "Bounce Ball 3" },
            { DecisionPoint::CollectPowerup, "Collect Powerup" },
            { DecisionPoint::ManipPowerup, "Manipulate Powerup" },
            { DecisionPoint::ManipEnemySpawn, "Manipulate Enemy Spawn" },
            { DecisionPoint::ManipEnemy1Move, "Manipulate Enemy 1 Move" },
            { DecisionPoint::ManipEnemy2Move, "Manipulate Enemy 2 Move" },
            { DecisionPoint::ManipEnemy3Move, "Manipulate Enemy 3 Move" },
            { DecisionPoint::HitEnemy1WithPaddle, "Hit Enemy 1 With Paddle" },
            { DecisionPoint::HitEnemy2WithPaddle, "Hit Enemy 2 With Paddle" },
            { DecisionPoint::HitEnemy3WithPaddle, "Hit Enemy 3 With Paddle" },
            { DecisionPoint::None_LevelEnded, "Level End" },
            { DecisionPoint::None_LimitReached, "Limit Reached" },
            { DecisionPoint::None_BallLost, "Ball Lost" },
            { DecisionPoint::Invalid, "Invalid" }
        };

        for (auto&& entry : decisionPoints)
        {
            const auto str = " " + strMap[entry.first] + " on frame " + std::to_string(entry.second);
            Log::Write(str);
        }

        Log::Write("");
    }

    return decisionPoints;
}

bool EvalOp::AnyBallLost(const GameState& state)
{
    auto anyLost = false;
    for (auto&& ball : state.ball)
    {
        anyLost |= (ball.exists && ball.pos.y > GameConsts::PaddleTop + 3);
    }
    
    return anyLost;
}

bool EvalOp::BallLost(const Ball& ball)
{
    return (ball.exists && ball.pos.y > GameConsts::PaddleTop + 3);
}

bool EvalOp::EnemyOverlapsPaddle(const Enemy& enemy, const unsigned int paddleX) {
    return (GameConsts::PaddleTop + 4 >= enemy.pos.y
        && (enemy.pos.y + 0xe >= GameConsts::PaddleTop
            // Also consider the case where the enemy will move into the paddle on the next frame.
            // (Update sequence is enemy move -> check paddle collis -> paddle move)
            || (enemy.pos.y + 0xf >= GameConsts::PaddleTop && enemy.moveTimer == 0))
        && enemy.pos.x + 0xc >= paddleX
        && paddleX + 24 + 5 >= enemy.pos.x);
};

unsigned int EvalOp::GetNumPaddleStepsTo(GameState& state, unsigned int pos)
{
    return std::abs(static_cast<int>(state.paddleX) - static_cast<int>(pos)) / GameConsts::PaddleSpeed;
}

void EvalOp::MovePaddleTo(GameState& state, const unsigned int pos)
{
    const auto& start = state.paddleX;
    const auto steps = GetNumPaddleStepsTo(state, pos);

    GameOp::ExecuteInput(state, (start > pos ? LeftInput : RightInput), steps);
}

void EvalOp::ConvertFuturesTo(GameState& state, const Input& input, const unsigned int numFutures, const unsigned int countToReplace)
{
    const auto numBlanks = numFutures - countToReplace;

    for (auto i = state.inputChain.size() - numFutures; i < state.inputChain.size() - numBlanks; i++)
    {
        state.inputChain[i] = input;
    }

    for (auto i = state.inputChain.size() - numBlanks; i < state.inputChain.size(); i++)
    {
        state.inputChain[i] = { NoInput, 0 };
    }
}

void EvalOp::DebugDumpState(GameState& state, EvalState& eval)
{
    EvalOp::PrintGameState(state, eval, false, false);
    printf("Input chain: %s\n", InputChainToStringShort(state.inputChain).c_str());
    OutputBizHawkMovie(state, eval, OutputMode::Debug);
}

void EvalOp::Sleep(const unsigned int milliseconds)
{
    ::Sleep(milliseconds);
}