#include <GameOperations.h>

#include <GameConsts.h>
#include <GameData.h>
#include <GameState.h>

#include <Utilities.h>

#include <string>
#include <functional>

void GameOp::Init(GameState& state)
{
    // Stuff that gets initialized once.
    state._frame = 0;
    state.score = 0;
    state.inputChain.reserve(1200);
    state.bossHits = 0;

    // These values are in the 0xff region that doesn't get cleared during init.
    for (int i = 0; i < 3; i++)
    {
        state.justHitBlock[i] = Block(0xff);
        state.justHitBlockCell[i] = { 0xff, 0xff };
        state.justDestrBlock[i] = true;
    }

    // TODO do this at the appropriate op state transition instead of during init.
    AdvanceToLevel(state, 1);
}

void GameOp::AdvanceToLevel(GameState& state, const unsigned int level)
{
    // Stuff that gets initialized every time a level is loaded.

    // TODO other init phases.
    state.opState = OperationalState::BallNotLaunched;

    state.level = level;

    state.buttons = 0;
    state.prevButtons = 0;

    state.paddleCollis = false;
    state.blockCollisCount = 0;
    state.blockCollisSide = { false, false, false, false };
    state.calculatedCell = { 0, 0 };
    state.spawnedPowerup = Powerup::None;
    state.ownedPowerup = Powerup::None;
    state.powerupPos = { 0, 0 };
    state.justSpawnedPowerup = false;
    state.pendingScore = 0;
    state.speedReduction = 0;
    state.ceilCollis = false;

    for (auto&& ball : state.ball)
    {
        ball.pos = { 0, 0 };
        ball.vel = { 0, 0 };
        ball.vSign = { 1, 1 };
        ball.angle = Angle::Steep;
        ball.cycle = 0;
        ball.exists = false;
        ball.xCollis = false;
        ball.yCollis = false;
        ball.speedMult = 0;
        ball.speedStage = 0;
        ball.speedStageM = 0;

        ball._paddleCollis = false;
    }

    auto id = 0;
    for (auto&& enemy : state.enemies)
    {
        enemy.pos = { 0, 0 };
        enemy.active = false;
        enemy.exiting = false;
        enemy.destrFrame = 0;
        enemy.moveTimer = 0;
        enemy.moveDir = 0;
        enemy.movementType = MovementType::Normal;
        enemy.descentTimer = 0;
        enemy.animTimer = 0;
        enemy.circleStage = 0;
        enemy.circleHalf = CircleHalf::Bottom;
        enemy.circleDir = CircleDir::Clockwise;

        enemy._id = id++;
    }

    state.enemyGateState = 0;
    state.enemyGateIndex = 0;
    state.enemyGateTimer = 0;

    // Formal init routines.
    LoadLevel(state, state.level);
    InitPaddleAndBall(state, state.level);
}

void GameOp::ExecuteInput(GameState& state, const Input& input)
{
    SetInput(state, input);
    AdvanceFrame(state);
}

void GameOp::ExecuteInput(GameState& state, const Input& input, const unsigned int count)
{
    for (unsigned int i = 0; i < count; i++)
    {
        ExecuteInput(state, input);
    }
}

void GameOp::ExecuteInputChain(GameState& state, const std::vector<Input>& inputChain)
{
    for (const auto& input : inputChain)
    {
        ExecuteInput(state, input);
    }
}

void GameOp::SetInput(GameState& state, const Input& input)
{
    state._pendingInput = input;
}

void GameOp::AdvanceFrame(GameState& state)
{
    state._justMovedEnemy = -1;
    state._enemyMoveOptions = 0;
    state._enemyMysteryInput = 0x77;

    state._frame++;
    state.inputChain.emplace_back(state._pendingInput);

    RefreshMiscState(state);
    ProcessInput(state, state._pendingInput);
    if(_SimulateScore(state)) UpdateScore(state);
    CheckPowerupCanSpawn(state);
    if (_SimulateEnemies(state)) UpdateEnemies(state);
    if (_SimulateEnemies(state)) CheckPaddleCollisWithEnemy(state);
    UpdatePowerup(state);
    UpdateBallSprites(state);
    CheckLaunchBall(state);
    CheckPaddleMove(state);
    UpdateActiveBalls(state);
    CheckPowerupCanBeCollected(state);
    if (_SimulateEnemies(state)) UpdateTimers(state);

    state._OnFrameAdvance(state);
}

void GameOp::LoadLevel(GameState& state, unsigned int level)
{
    int i = 0;
    for (auto&& timer : state.enemySpawnTimers)
    {
        timer = Data::EnemySpawnTimerTable[state.level][i];

        // TODO remove fixup once simulating between-level state
        if (timer >= 8) timer -= 8;

        i++;
    }

    if (level == 36)
    {
        state.currentBlocks = 0;
        state.totalBlocks = 0;
    }
    else
    {
        state.currentBlocks = Data::LevelBlockCount[level];
        state.totalBlocks = state.currentBlocks;

        for (int i = 0; i < GameConsts::BlockTableSize; i++)
        {
            state.blocks[i] = Data::LevelData[level][i];
        }
    }
}

void GameOp::InitPaddleAndBall(GameState& state, unsigned int level)
{
    state.ball[0].exists = true;
    // TODO set paddle transformation
    state.ball[0].pos.y = 0xcc;
    // TODO other values?

    // These values aren't explicitly set in the game code, instead
    // they're set implicitly from the struct-clear routine.
    state.ball[0].angle = Angle::Steep;
    state.ball[0].vSign.vx = 1;
    state.ball[0].vSign.vy = -1;

    state.overallSpeedStage = Data::StartingSpeedStage[level];
    state.overallSpeedStageM = Data::StartingSpeedStage[level];
    state.speedStageCounter = Data::SpeedStageThresholds[state.overallSpeedStage];
    state.ball[0].speedStage = state.overallSpeedStage;
    state.ball[0].speedStageM = state.overallSpeedStage;

    state.paddleX = GameConsts::PaddleStart;
    const auto paddleLeftEdge = state.paddleX;
    const auto paddleLeftCenter = paddleLeftEdge + 8;
    const auto paddleRightCenter = paddleLeftCenter + 8;

    state.ball[0].pos.x = paddleRightCenter;
}

unsigned int GameOp::_RandNum(GameState& state, const unsigned int inputCarry)
{
    const auto scoreDigit4 = _SimulateScore(state) ? (state.score % 1000) / 100 : 0;
    const auto scoreDigit5 = _SimulateScore(state) ? (state.score % 100) / 10 : 0;

    // Mystery input values, always seem to be constant.
    const auto mystery0379 = 0;
    const auto mystery037a = 0;

    // Other values.
    const auto paddleLeftEdge = state.paddleX;
    const auto paddleLeftCenter = paddleLeftEdge + 8;

    auto rng = state.mysteryInput;
    auto carry = inputCarry;

    const auto adc = [&rng, &carry](unsigned int val) {
        rng += val + carry;
        carry = (rng > 0xff);
        rng &= 0xff;
    };

    const auto rol = [&rng, &carry] {
        const auto topBit = (rng & 0x80) >> 7;

        rng = (rng << 1) & 0xff;
        rng |= carry;
        carry = topBit;
    };

    const auto ror = [&rng, &carry] {
        const auto bottomBit = (rng & 1);

        rng = rng >> 1;
        rng |= (carry << 7);
        carry = bottomBit;
    };

    rng = Data::RngTable[rng % 16];

    adc(state.mysteryInput);
    adc(scoreDigit4);
    adc(scoreDigit5);
    rol();
    rol();
    adc(mystery0379);
    adc(mystery037a);
    adc(paddleLeftEdge);
    adc(paddleLeftCenter);
    rol();
    rol();
    rol();
    adc(state.ball[0].pos.y);
    adc(state.ball[0].pos.x);
    ror();
    ror();

    state.mysteryInput += 3;

    return rng;
}

void GameOp::RefreshMiscState(GameState& state)
{
    if (state.opState == OperationalState::BallNotLaunched
        || state.opState == OperationalState::BallLaunched)
    {
        ReactToBlockCollis(state);

        if (_SimulateEnemies(state))
        {
            if (!state.justSpawnedPowerup)
            {
                UpdateEnemyGate(state);
            }
        }

        // TODO other updates

        state.justSpawnedPowerup = false;
    }

    // TODO other updates
}

void GameOp::ReactToBlockCollis(GameState& state)
{
    for(auto i = 0u; i < state.blockCollisCount; i++)
    {
        if (state.justDestrBlock[i])
        {
            state.currentBlocks--;
        }
    }
}

void GameOp::UpdateEnemyGate(GameState& state)
{
    if (state.opState == OperationalState::BallNotLaunched
        || state.opState == OperationalState::BallLaunched)
    {
        if (state.enemyGateTimer > 0)
        {
            state.enemyGateTimer--;
        }
        else
        {
            if (state.enemyGateState != 0)
            {
                if (Data::GateStateSignalValues[state.enemyGateState] == 0)
                {
                    return;
                }
                else if (Data::GateStateSignalValues[state.enemyGateState] == 0xff)
                {
                    state.enemyGateState = 0;
                    return;
                }
                else
                {
                    state.enemyGateTimer = Data::GateTimerDurations[state.enemyGateState];
                    state.enemyGateState++;
                }
            }
        }
    }
}

void GameOp::ProcessInput(GameState& state, const Input& input)
{
    state.prevButtons = state.buttons;
    state.buttons = input;
}

void GameOp::UpdateScore(GameState& state)
{
    UpdatePendingBlockScore(state);

    if (state.pendingScore % 100 > 0)
    {
        state.pendingScore -= 10;
        state.score += 10;
    }
    else if (state.pendingScore > 0)
    {
        state.pendingScore -= 100;
        state.score += 100;
    }
}

void GameOp::UpdatePendingBlockScore(GameState& state)
{
    for (auto i = 0u; i < state.blockCollisCount; i++)
    {
        // TODO multiple block collisions
        const auto blockType = BlkType(state.justHitBlock[i]);

        if (blockType == BlockType::Silver)
        {
            state.pendingScore += 50 * state.level;
        }
        else if (!_SimulateGoldBlocks(state) || blockType != BlockType::Gold)
        {
            const auto scoreIndex = (static_cast<int>(blockType) >> 4) - 1;
            state.pendingScore += Data::BlockScoreTable[scoreIndex];
        }
    }
}

void GameOp::UpdateEnemies(GameState& state)
{
    if (state.level != GameConsts::BossLevel
        && (state.opState == OperationalState::BallNotLaunched || state.opState == OperationalState::BallLaunched))
    {
        EnemyOp::UpdateEnemyAnimTimers(state);
        EnemyOp::AdvanceEnemies(state);
        EnemyOp::UpdateEnemyStatus(state);
        EnemyOp::HandleEnemyDestruction(state);
        EnemyOp::UpdateEnemySprites(state);
    }
}

void GameOp::DestroyEnemy(GameState& state, Enemy& enemy)
{
    state.pendingScore += 100;
    enemy.active = false;
    enemy.destrFrame = 1;
}

void GameOp::CheckPaddleCollisWithEnemy(GameState& state)
{
    if (!state.ball[0].exists && !state.ball[1].exists && !state.ball[2].exists) return;

    for (auto&& enemy : state.enemies)
    {
        if (enemy.active && !enemy.exiting && enemy.pos.y < 0xe0
            && GameConsts::PaddleTop + 4 >= enemy.pos.y
            && enemy.pos.y + 0xe >= GameConsts::PaddleTop
            && enemy.pos.x + 0xc >= state.paddleX
            && state.paddleX + 24 + 5 >= enemy.pos.x)
        {
            DestroyEnemy(state, enemy);
        }
    }

    if (state._queueEnemyDestruction != -1)
    {
        DestroyEnemy(state, state.enemies[state._queueEnemyDestruction]);
        state._queueEnemyDestruction = -1;
    }
}

void GameOp::CheckPowerupCanSpawn(GameState& state)
{
    const auto exactlyOneBallActive = (state.ball[0].exists && !state.ball[1].exists && !state.ball[2].exists);

    const auto preconditions = _Pedantic ? (exactlyOneBallActive && state.currentBlocks > 0 && state.spawnedPowerup == Powerup::None)
                                         : (state.ownedPowerup == Powerup::None && state.spawnedPowerup == Powerup::None);

    if (preconditions)
    {
        for (auto i = 0u; i < state.blockCollisCount; i++)
        {
            if (BlkPowerup(state.justHitBlock[i]))
            {
                const auto cell = state.justHitBlockCell[i];
                state.powerupPos = { cell.x * GameConsts::BlockWidth + GameConsts::FieldMinX,
                                     cell.y * GameConsts::BlockHeight + GameConsts::FieldMinY };

                GenPowerup(state);
            }
        }
    }
}

void GameOp::GenPowerup(GameState& state)
{
    auto inputCarry = 0;

    auto newPowerup = Powerup::None;
    while (newPowerup == Powerup::None)
    {
        // This always seems to be constant...
        state.mysteryInput = 1;
        const auto rn = _RandNum(state, inputCarry);

        auto spawnedRarePowerup = false;
        for (int x = 0; x < 6; x++)
        {
            if (rn == Data::SpecialPowerupTable[x])
            {
                if (x < 3)
                {
                    newPowerup = Powerup::ExtraLife;
                }
                else
                {
                    newPowerup = Powerup::Warp;
                }

                spawnedRarePowerup = true;
            }
        }

        if (!spawnedRarePowerup)
        {
            const auto rnLoBits = (rn & 7);
            if (rnLoBits == 0)
            {
                // rn == 7 would be an extra life, but since those have special handling,
                // a large-paddle powerup gets spawned instead.
                newPowerup = Powerup::LargePaddle;
            }
            else if (rnLoBits < 6)
            {
                newPowerup = static_cast<Powerup>(rnLoBits);
            }
            else
            {
                // rn == 6 would be a warp powerup, but since those have special handling,
                // a multiball powerup gets spawned instead.
                newPowerup = Powerup::Multiball;
            }
        }

        if (newPowerup == state.ownedPowerup)
        {
            // We already have this powerup, reset and try again.
            inputCarry = (newPowerup >= state.ownedPowerup);
            newPowerup = Powerup::None;
        }
    }

    state.spawnedPowerup = newPowerup;
    state.justSpawnedPowerup = true;
}

void GameOp::UpdatePowerup(GameState& state)
{
    if (_Pedantic)
    {
        if (state.opState != OperationalState::Paused)
        {
            if (state.spawnedPowerup == Powerup::None)
            {
                state.powerupPos.y = 0xf0;
            }

            if (state.powerupPos.y >= 0xf0)
            {
                state.spawnedPowerup = Powerup::None;
                state.powerupPos.y = 0xf0;
            }

            state.powerupPos.y++;
        }
    }
    else
    {
        state.powerupPos.y++;
    }
}

void GameOp::UpdateBallSprites(GameState& state)
{
    // Sprites aren't really a concern for this simulation, but this function does
    // do a few other important updates.

    if (_Pedantic)
    {
        for (auto&& ball : state.ball)
        {
            if (!ball.exists)
            {
                ball.pos.y = 0xf0;
            }
        }
    }
}

void GameOp::CheckLaunchBall(GameState& state)
{
    const auto aButtonJustPressed = (InputA(state.buttons) && !InputA(state.prevButtons));
    // TODO auto-launch flag

    if (aButtonJustPressed && state.opState == OperationalState::BallNotLaunched)
    {
        // TODO clear auto-launch

        state.ball[0].cycle = 0;
        state.opState = OperationalState::BallLaunched;
    }
}

void GameOp::CheckPaddleMove(GameState& state)
{
    const auto ballsExist = (state.ball[0].exists || state.ball[1].exists || state.ball[2].exists);
    
    // TODO other checks?
    if (!_Pedantic || (ballsExist && state.opState != OperationalState::Paused && state.currentBlocks > 0))
    {
        if (InputLeft(state.buttons) && !InputRight(state.buttons))
        {
            DoPaddleMove(state, -3);
        }
        else if (InputRight(state.buttons) && !InputLeft(state.buttons))
        {
            DoPaddleMove(state, 3);
        }
    }
}

void GameOp::DoPaddleMove(GameState& state, int delta)
{
    if (_Pedantic)
    {
        auto ballPaddleDelta = state.ball[0].pos.x - state.paddleX;

        state.paddleX += delta;
        MathUtil::Clamp(state.paddleX, GameConsts::PaddleMin, GameConsts::PaddleMax);

        if (state.opState == OperationalState::BallNotLaunched)
        {
            // If the ball is attached to the paddle, move it with the paddle.
            state.ball[0].pos.x = state.paddleX + ballPaddleDelta;

            // Clamp the ball to the field edges. This is independent of the paddle,
            // so the ball is allowed to move to a different spot on the paddle with
            // this operation.
            MathUtil::Clamp(state.ball[0].pos.x, GameConsts::FieldMinX, GameConsts::FieldMaxX);
        }
    }
    else
    {
        state.paddleX += delta;
        MathUtil::Clamp(state.paddleX, GameConsts::PaddleMin, GameConsts::PaddleMax);

        if (state.opState == OperationalState::BallNotLaunched)
        {
            state.ball[0].pos.x += delta;
        }
    }
}

void GameOp::UpdateActiveBalls(GameState& state)
{
    state.blockCollisCount = 0;

    if (state.opState != OperationalState::BallLaunched) return;
    if (state.currentBlocks == 0 && state.level != GameConsts::BossLevel) return;

    if (_Pedantic)
    {
        if (state.speedReduction > 0)
        {
            state.speedReduction--;
            return;
        }
    }

    for (auto&& ball : state.ball)
    {
        if (ball.exists)
        {
            std::function<void()> updateBall = [&] {
                BallOp::UpdateBallSpeedData(state, ball);
                BallOp::AdvanceOneBall(state, ball);
                BallOp::CheckBlockBossCollis(state, ball);
                BallOp::CheckPaddleCollis(state, ball);
                if (_SimulateEnemies(state)) BallOp::CheckEnemyCollis(state, ball);
                BallOp::UpdateCeilCollisVSign(state, ball);
                BallOp::HandleBlockCollis(state, ball);
                BallOp::CheckBallLost(state, ball);

                if (ball.cycle > 0)
                {
                    ball.speedMult--;
                    if (ball.speedMult > 0)
                    {
                        updateBall();
                    }
                    else
                    {
                        ball.cycle--;
                    }
                }
            };

            updateBall();
        }
    }
}

void GameOp::CheckPowerupCanBeCollected(GameState& state)
{
    // Ensure at least one ball exists.
    if (!(state.ball[0].exists || state.ball[1].exists || state.ball[2].exists)) return;

    // Ensure there's a powerup around.
    if (state.spawnedPowerup == Powerup::None) return;

    const auto paddleTop = GameConsts::PaddleTop;
    const auto paddleBot = GameConsts::PaddleTop + 4;
    const auto paddleLeft = state.paddleX;
    const auto paddleRight = state.paddleX + 8 + 8 + 8;

    // Check if the powerup can be collected.
    if (state.powerupPos.y + 8 >= paddleTop && paddleBot >= state.powerupPos.y
        && state.powerupPos.x + 8 >= paddleLeft && state.powerupPos.x + 8 < paddleRight + 8)
    {
        state.ownedPowerup = state.spawnedPowerup;
        state.spawnedPowerup = Powerup::None;

        if(_SimulateScore(state)) state.pendingScore += 1000;

        // TODO other powerups
        if (state.ownedPowerup == Powerup::Multiball)
        {
            GetMultiBallPowerup(state);
        }
    }
}

void GameOp::GetMultiBallPowerup(GameState& state)
{
    state.ball[1] = state.ball[0];
    state.ball[2] = state.ball[0];

    const auto initAng = state.ball[0].angle;
    if (initAng == Angle::Steep)
    {
        state.ball[1].angle = Angle::Normal;
        state.ball[2].angle = Angle::Shallow;
    }
    else if (initAng == Angle::Normal)
    {
        state.ball[1].angle = Angle::Steep;
        state.ball[2].angle = Angle::Shallow;
    }
    else if (initAng == Angle::Shallow)
    {
        state.ball[1].angle = Angle::Steep;
        state.ball[2].angle = Angle::Normal;
    }
}

void GameOp::UpdateTimers(GameState& state)
{
    if (state.opState != OperationalState::Paused)
    {
        // TODO return if there's a loading timer active

        // TODO handle title timer

        // TODO handle auto-launch timer

        for (auto&& timer : state.enemySpawnTimers)
        {
            if (timer > 0) timer--;
        }
    }
}

void BallOp::UpdateBallSpeedData(GameState& state, Ball& ball)
{
    if (ball.cycle == 0)
    {
        std::vector<SpeedTableRow>* speedTable = nullptr;
        if (ball.angle == Angle::Steep)
        {
            speedTable = &Data::SteepSpeedTable;
        }
        else if (ball.angle == Angle::Normal)
        {
            speedTable = &Data::NormalSpeedTable;
        }
        else
        {
            speedTable = &Data::ShallowSpeedTable;
        }

        ball.speedRow = &(*speedTable)[ball.speedStage];

        ball.cycle = ball.speedRow->cycleLen;
        ball.speedMult = 0;
        if(_Pedantic) state.speedReduction = ball.speedRow->speedReduction;
        ball.speedRowIdx = 0;
    }

    if (ball.speedMult == 0)
    {
        ball.speedMult = ball.speedRow->speedMult;
    }

    ball.vel.vy = ball.speedRow->vel[ball.speedRowIdx];
    ball.vel.vx = ball.speedRow->vel[ball.speedRowIdx + 1];

    ball.speedRowIdx += 2;
}

void BallOp::AdvanceOneBall(GameState& state, Ball& ball)
{
    ball.xCollis = false;
    ball.yCollis = false;
    state.ceilCollis = false;

    const auto moveBall = [&] {
        ball.pos.x += ball.vel.vx * ball.vSign.vx;
        ball.pos.y += ball.vel.vy * ball.vSign.vy;

        if (ball.pos.x <= GameConsts::FieldMinX)
        {
            ball.pos.x = GameConsts::FieldMinX;
            ball.xCollis = true;
        }
        if (ball.pos.x >= GameConsts::FieldMaxX)
        {
            ball.pos.x = GameConsts::FieldMaxX;
            ball.xCollis = true;
        }
        if (ball.pos.y <= GameConsts::FieldMinY)
        {
            ball.pos.y = GameConsts::FieldMinY;
            ball.yCollis = (ball.vSign.vy == -1);
            state.ceilCollis = ball.yCollis;
        }
    };

    moveBall();
    
    // Update ball a second time if there aren't any (wall) collisions, the ball
    // is moving upwards, and it's at or below 0xcd.
    if (ball.pos.y >= 0xcd && ball.vSign.vy == -1 && !ball.xCollis && !ball.yCollis)
    {
        moveBall();
    }
}

void BallOp::CheckBlockBossCollis(GameState& state, Ball& ball)
{
    state.blockCollisSide = { false, false, false, false };

    if (ball.vel.vx == 0 && ball.vel.vy == 0) return;

    if (state.level == GameConsts::BossLevel)
    {
        CheckBossCollis(state, ball);
    }
    else
    {
        CheckBlockCollis(state, ball);
    }
}

//
//               y-overlap
//                   |
//                   |
//               |-------|
//     "This block"     "One right"
//    _______________ _______________
//   |               |               |
//   |           +---|---.           | ---
//   |___________:___|___:___________|  |----- x-overlap
//   |           :...|...:           | ---
//   |               |               |
//   |_______________|_______________|
//
//      "One Down"    "One Down-Right"
//
//

void BallOp::CheckBlockCollis(GameState& state, Ball& ball)
{
    // No collisions if we've disabled hitboxes.
    if (state._disableBlockHitboxes) return;

    // If we're already full on collisions, return.
    if (ball.xCollis && ball.yCollis) return;

    Point posHi;
    posHi.y = (ball.pos.y - GameConsts::FieldMinY) >> 3;

    // If the ball is too low to hit any blocks, return.
    if (posHi.y + 1 >= 0x18) return;

    auto cellOverlapX = false;
    auto cellOverlapY = false;

    // Despite the name these are simply the "original" unmodified cell values.
    const auto ballCellX = state.calculatedCell.x;
    const auto ballCellY = state.calculatedCell.y;

    // Use shorter names for clarity...
    // This is also a shortcut for writing back the modified values;
    // normally this'd happen just before the block proximity check.
    auto& cellX = state.calculatedCell.x;
    auto& cellY = state.calculatedCell.y;

    Point posLo;
    posLo.y = (ball.pos.y - GameConsts::FieldMinY) % 8;
    posHi.x = (ball.pos.x - GameConsts::FieldMinX) >> 4;
    posLo.x = (ball.pos.x - GameConsts::FieldMinX) % 16;

    state.calculatedCell.x = posHi.x;
    state.calculatedCell.y = posHi.y;

    const auto posHiOrig = posHi;
    const auto posLoOrig = posLo;

    if (state.level != 0 && !_Pedantic)
    {
        if ((Data::MinBlockRow[state.level] > 0 && posHi.y < Data::MinBlockRow[state.level] - 1)
            || posHi.y > Data::MaxBlockRow[state.level] + 1)
        {
            if (ball.vSign.vx == -1 && !ball.xCollis && posLo.x == 0) cellX--;
            if (ball.vSign.vy == -1 && !ball.yCollis && posLo.y == 0) cellY--;

            return;
        }
    }

    const auto snapDown = [&] {
        if (posLo.y != 0)
        {
            posLo.y = 0;
            posHi.y++;
        }
    };

    const auto snapRight = [&] {
        if (posLo.x != 0)
        {
            posLo.x = 0;
            posHi.x++;
        }
    };

    const auto snapLeft = [&] {
        posLo.x = 0xc;
    };

    const auto snapUp = [&] {
        posLo.y = 0x4;
    };


    auto bounceDown = [&] {
        snapDown();
        ball.yCollis = true;
    };

    auto bounceRight = [&] {
        snapRight();
        ball.xCollis = true;
    };

    auto bounceLeft = [&] {
        snapLeft();
        ball.xCollis = true;
    };

    auto bounceUp = [&] {
        snapUp();
        ball.yCollis = true;
    };

    if (ball.vSign.vx == -1 && ball.vSign.vy == -1)
    {
        // The ball is moving diagonally up-left.

        if (!ball.yCollis)
        {
            if (posLo.y == 0)
            {
                cellY--;
                cellOverlapY = true;
            }

            if(posLo.y >= 5)
            {
                cellOverlapY = true;
            }
        }

        if (!ball.xCollis)
        {
            if (posLo.x == 0)
            {
                cellX--;
                cellOverlapX = true;
            }

            if(posLo.x >= 0xd)
            {
                cellOverlapX = true;
            }
        }

        auto prox = GetBlockProximity(state, cellX, cellY);

        if (cellOverlapY && !cellOverlapX)
        {
            // The ball overlaps only the cell above.

            // If there's no block here, nothing to do, so return.
            if (!prox.thisBlock) return;

            bounceDown();
            state.blockCollisSide.thisBlock = true;
        }
        else if (cellOverlapX && !cellOverlapY)
        {
            // The ball overlaps only the cell to the left.

            // If there's no block here, nothing to do, so return.
            if (!prox.thisBlock) return;

            bounceRight();
            state.blockCollisSide.thisBlock = true;
        }
        else if (cellOverlapX && cellOverlapY)
        {
            // The ball overlaps the cell to the left and above.

            if (prox.thisBlock && !prox.oneRight && !prox.oneDown && !prox.oneDownRight)
            {
                // The only block around is this one.

                auto cornerBounce = [&] {
                    bounceDown();
                    bounceRight();
                };

                if (posLo.x == posLo.y && ball.vel.vx == ball.vel.vy) cornerBounce(); // Perfectly aligned to the block corner, and moving perfectly diagonally -> corner bounce
                else if (posLo.y == 0) bounceDown(); // exactly against the bottom of the block -> bounce down
                else if (posLo.x == 0) bounceRight(); // exactly against the left side of the block -> bounce right
                else if (posHi.y == ballCellY) bounceRight(); // not precisely against the bottom side of the block -> bounce right
                else if (posHi.x == ballCellX) bounceDown(); // not precisely against the left side of the block -> bounce down
                else cornerBounce(); // shouldn't get here, but otherwise -> corner bounce

                state.blockCollisSide = prox;
            }
            else if (!prox.thisBlock && prox.oneRight && !prox.oneDown && !prox.oneDownRight)
            {
                // The only block around is to the right.

                bounceDown();
                state.blockCollisSide = prox;
            }
            else if (!prox.thisBlock && !prox.oneRight && prox.oneDown && !prox.oneDownRight)
            {
                // The only block around is below.

                bounceRight();
                state.blockCollisSide = prox;
            }
            else if (prox.thisBlock && prox.oneRight && !prox.oneDown && !prox.oneDownRight)
            {
                // Blocks here and to the right.

                bounceDown();

                if (posLo.x == 0xf)
                {
                    state.blockCollisSide.oneRight = true;
                }
                else
                {
                    state.blockCollisSide.thisBlock = true;
                }
            }
            else if (prox.thisBlock && !prox.oneRight && prox.oneDown && !prox.oneDownRight)
            {
                // Blocks here and below.

                bounceRight();

                if (posLo.y == 7)
                {
                    state.blockCollisSide.oneDown = true;
                }
                else
                {
                    state.blockCollisSide.thisBlock = true;
                }
            }
            else if (!prox.thisBlock && !prox.oneRight && !prox.oneDown && !prox.oneDownRight)
            {
                // No blocks around at all, return.
                return;
            }
            else if ((!prox.thisBlock && prox.oneRight && prox.oneDown && !prox.oneDownRight)
                     || (prox.thisBlock && prox.oneRight && prox.oneDown && !prox.oneDownRight))
            {
                // One block down, one block right OR all blocks but the one down-right.
                // Theory: these are combined since it doesn't really matter if "this block"
                // exists; the ball is colliding with the top or side block first anyway.

                bounceDown();
                bounceRight();

                // Select either oneRight or oneDown as the collision side. By default pick
                // oneDown, but if oneRight isn't gold, pick oneRight.
                const auto index = cellY * GameConsts::BlocksPerRow + cellX;
                if (!_SimulateGoldBlocks(state) || BlkType(state.blocks[index + 1]) != BlockType::Gold)
                {
                    state.blockCollisSide.oneRight = true;
                }
                else
                {
                    state.blockCollisSide.oneDown = true;
                }
            }
        }
    }
    else if (ball.vSign.vx == 1 && ball.vSign.vy == -1)
    {
        // The ball is moving diagonally up-right.

        if (!ball.yCollis)
        {
            if (posLo.y == 0)
            {
                cellY--;
                cellOverlapY = true;
            }

            if (posLo.y >= 5)
            {
                cellOverlapY = true;
            }
        }

        if (!ball.xCollis)
        {
            if (posLo.x >= 0xc)
            {
                cellOverlapX = true;
            }
        }

        auto prox = GetBlockProximity(state, cellX, cellY);

        if (cellOverlapY && !cellOverlapX)
        {
            // The ball overlaps only the cell above.

            // If there's no block here, nothing to do, so return.
            if (!prox.thisBlock) return;

            bounceDown();
            state.blockCollisSide.thisBlock = true;
        }
        else if (cellOverlapX && !cellOverlapY)
        {
            // The ball overlaps only the cell to the right.

            if (!prox.oneRight) return;

            bounceLeft();
            state.blockCollisSide.oneRight = true;
        }
        else if (cellOverlapX && cellOverlapY)
        {
            // The ball overlaps the cell to the left and above.

            if (!prox.thisBlock && prox.oneRight && !prox.oneDown && !prox.oneDownRight)
            {
                // The only block around is to the right.

                auto cornerBounce = [&] {
                    bounceDown();
                    bounceLeft();
                };

                if (posLo.x == posLo.y && ball.vel.vx == ball.vel.vy) cornerBounce(); // No coverage
                else if (posLo.y == 0) bounceDown();
                else if (posLo.x == 0xc) bounceLeft();
                else if (posLo.y == ballCellY) bounceLeft();  // No coverage - note possible bug, would expect comparison with high bits
                else if (posLoOrig.y == 0) bounceLeft();  // No coverage
                else if (posLoOrig.x < 0xc) cornerBounce();  // No coverage
                else bounceDown();

                state.blockCollisSide = prox;
            }
            else if (prox.thisBlock && !prox.oneRight && !prox.oneDown && !prox.oneDownRight) // 0x8
            {
                // The only block around is this one.

                bounceDown();
                state.blockCollisSide = prox;
            }
            else if (!prox.thisBlock && !prox.oneRight && !prox.oneDown && prox.oneDownRight) // 0x1
            {
                // The only block around is one-down-right.

                bounceLeft();
                state.blockCollisSide = prox;
            }
            else if (prox.thisBlock && prox.oneRight && !prox.oneDown && !prox.oneDownRight)
            {
                // This block and the one to the right exist.

                bounceDown();

                if (posLo.x == 0xf)
                {
                    state.blockCollisSide.oneRight = true;
                }
                else
                {
                    state.blockCollisSide.thisBlock = true;
                }
            }
            else if (!prox.thisBlock && prox.oneRight && !prox.oneDown && prox.oneDownRight)
            {
                // One block right and one block down-right exist.

                bounceLeft();

                if (posLo.y == 7)
                {
                    state.blockCollisSide.oneDownRight = true;
                }
                else
                {
                    state.blockCollisSide.oneRight = true;
                }
            }
            else if((prox.thisBlock && prox.oneRight && !prox.oneDown && prox.oneDownRight)
                    || (prox.thisBlock && !prox.oneRight && !prox.oneDown && prox.oneDownRight))
            {
                // This block + one block down-right OR all blocks but the one down.
                // Theory: these are combined since it doesn't really matter if the
                // "one right" block exists; the ball is colliding with the top or
                // side block first anyway.

                bounceDown();
                bounceLeft();

                const auto index = cellY * GameConsts::BlocksPerRow + cellX;

                // Select either thisBlock or oneDownRight as the collision side. By default pick
                // oneDownRight, but if thisBlock isn't gold, pick thisBlock.
                if (!_SimulateGoldBlocks(state) || BlkType(state.blocks[index]) != BlockType::Gold)
                {
                    state.blockCollisSide.thisBlock = true;
                }
                else
                {
                    state.blockCollisSide.oneDownRight = true;
                }
            }
        }
    }
    else if (ball.vSign.vx == -1 && ball.vSign.vy == 1)
    {
        // The ball is moving diagonally down-left.

        if (posLo.y >= 4)
        {
            cellOverlapY = true;
        }

        if (!ball.xCollis)
        {
            if (posLo.x == 0)
            {
                cellX--;
                cellOverlapX = true;
            }

            if (posLo.x >= 0xd)
            {
                cellOverlapX = true;
            }
        }

        auto prox = GetBlockProximity(state, cellX, cellY);

        if (!cellOverlapX && cellOverlapY)
        {
            // The block overlaps only the cell below.

            // If there's only a y-overlap and no block below, nothing to do, so return.
            if (!prox.oneDown) return;

            bounceUp();
            state.blockCollisSide.oneDown = true;
        }
        else if (cellOverlapX && !cellOverlapY)
        {
            // The block overlaps only the cell to the left.

            // If there's only an x-overlap and no block here, nothing to do, so return.
            if (!prox.thisBlock) return;

            bounceRight();
            state.blockCollisSide.thisBlock = true;
        }
        else if (cellOverlapX && cellOverlapY)
        {
            if (!prox.thisBlock && prox.oneDown && !prox.oneRight && !prox.oneDownRight)
            {
                auto cornerBounce = [&] {
                    bounceUp();
                    bounceRight();
                };

                if (posLo.x == posLo.y && ball.vel.vx == ball.vel.vy) cornerBounce(); // No coverage
                else if (posLo.y == 4) bounceUp();
                else if (posLo.x == 0) bounceRight();
                else if (posHi.x == ballCellX) bounceUp();
                else cornerBounce();

                state.blockCollisSide = prox;
            }
            else if (prox.thisBlock && !prox.oneDown && !prox.oneRight && !prox.oneDownRight)
            {
                bounceRight();
                state.blockCollisSide = prox;
            }
            else if (!prox.thisBlock && !prox.oneDown && !prox.oneRight && prox.oneDownRight) // 0x1
            {
                bounceUp();
                state.blockCollisSide = prox;
            }
            else if (prox.thisBlock && prox.oneDown && !prox.oneRight && !prox.oneDownRight) // 0xA
            {
                bounceRight();

                if (posLo.y == 7)
                {
                    state.blockCollisSide.oneDown = true;
                }
                else
                {
                    state.blockCollisSide.thisBlock = true;
                }
            }
            else if (!prox.thisBlock && prox.oneDown && !prox.oneRight && prox.oneDownRight) // 0x3
            {
                bounceUp();

                if (posLo.x == 0xf)
                {
                    state.blockCollisSide.oneDownRight = true;
                }
                else
                {
                    state.blockCollisSide.oneDown = true;
                }
            }
            else if ((prox.thisBlock && !prox.oneDown && !prox.oneRight && prox.oneDownRight)
                || (prox.thisBlock && prox.oneDown && !prox.oneRight && prox.oneDownRight))
            {
                bounceUp();
                bounceRight();

                // Select either thisBlock or oneDownRight as the collision side. By default pick
                // thisBlock, but if it's gold and oneDownRight is not, switch to oneDownRight.
                const auto index = cellY * GameConsts::BlocksPerRow + cellX;
                if (_SimulateGoldBlocks(state) && BlkType(state.blocks[index]) == BlockType::Gold
                    && BlkType(state.blocks[index + GameConsts::BlocksPerRow + 1]) != BlockType::Gold)
                {
                    state.blockCollisSide.oneDownRight = true;
                }
                else
                {
                    state.blockCollisSide.thisBlock = true;
                }
            }
        }
    }
    else
    {
        // The ball is moving diagonally down-right.

        if (posLo.y >= 4)
        {
            cellOverlapY = true;
        }

        if (!ball.xCollis)
        {
            if (posLo.x >= 0xc)
            {
                cellOverlapX = true;
            }
        }

        auto prox = GetBlockProximity(state, cellX, cellY);

        if (!cellOverlapX && cellOverlapY)
        {
            // The block overlaps only the cell below.

            // If there's no block directly below, nothing to do, so return.
            if (!prox.oneDown) return;

            bounceUp();
            state.blockCollisSide.oneDown = true;
        }
        else if (cellOverlapX && !cellOverlapY)
        {
            // The block overlaps only the cell to the right.

            // If there's no block to the right, nothing to do, so return.
            if (!prox.oneRight) return;

            bounceLeft();
            state.blockCollisSide.oneRight = true;
        }
        else if (cellOverlapX && cellOverlapY)
        {
            if (!prox.thisBlock && !prox.oneDown && !prox.oneRight && prox.oneDownRight) // 0x1
            {
                auto cornerBounce = [&] {
                    bounceUp();
                    bounceLeft();
                };

                if (posLo.x == posLo.y && ball.vel.vx == ball.vel.vy) cornerBounce();
                else if (posLo.y == 4) bounceUp();
                else if (posLo.x == 0xc) bounceLeft();
                else if (posLoOrig.y >= 4) bounceLeft();
                else if (posLoOrig.x < 0xc) cornerBounce();
                else bounceUp();

                state.blockCollisSide = prox;
            }
            else if (!prox.thisBlock && !prox.oneDown && prox.oneRight && !prox.oneDownRight) // 0x4
            {
                bounceLeft();
                state.blockCollisSide = prox;
            }
            else if (!prox.thisBlock && prox.oneDown && !prox.oneRight && !prox.oneDownRight) // 0x2
            {
                bounceUp();
                state.blockCollisSide = prox;
            }
            else if (!prox.thisBlock && !prox.oneDown && prox.oneRight && prox.oneDownRight) // 0x5
            {
                bounceLeft();

                if (posLo.y == 7)
                {
                    state.blockCollisSide.oneDownRight = true;
                }
                else
                {
                    state.blockCollisSide.oneRight = true;
                }
            }
            else if (!prox.thisBlock && prox.oneDown && !prox.oneRight && prox.oneDownRight) // 0x3
            {
                bounceUp();

                if (posLo.x == 0xf)
                {
                    state.blockCollisSide.oneDownRight = true;
                }
                else
                {
                    state.blockCollisSide.oneDown = true;
                }
            }
            else if ((!prox.thisBlock && prox.oneDown && prox.oneRight && !prox.oneDownRight) // 0x6
                     || (!prox.thisBlock && prox.oneDown && prox.oneRight && prox.oneDownRight)) // 0x7
            {
                bounceUp();
                bounceLeft();

                // Select either oneRight or oneDown as the collision side. By default pick
                // oneRight, but if it's gold and oneDown is not, switch to oneDown.
                const auto index = cellY * GameConsts::BlocksPerRow + cellX;
                if (_SimulateGoldBlocks(state) && BlkType(state.blocks[index + 1]) == BlockType::Gold
                    && BlkType(state.blocks[index + GameConsts::BlocksPerRow]) != BlockType::Gold)
                {
                    state.blockCollisSide.oneDown = true;
                }
                else
                {
                    state.blockCollisSide.oneRight = true;
                }
            }
        }
    }
}

void BallOp::CheckBossCollis(GameState& state, Ball& ball)
{
    if (ball.pos.y + 3 >= 0x28 && ball.pos.y < 0x88
        && ball.pos.x + 3 >= 0x50 && ball.pos.x < 0x80)
    {
        state.bossHits++;
        
        const auto doCollisY = [&] {
            ball.yCollis = true;
            if (ball.vSign.vy == 1 && ball.pos.y > 0x24)
            {
                ball.pos.y = 0x24;
            }
            else if(ball.vSign.vy == -1 && ball.pos.y < 0x88)
            {
                ball.pos.y = 0x88;
            }
        };

        const auto doCollisX = [&] {
            ball.xCollis = true;
            if (ball.vSign.vx == 1 && ball.pos.x > 0x4c)
            {
                ball.pos.x = 0x4c;
            }
            else if (ball.vSign.vx == -1 && ball.pos.x < 0x80)
            {
                ball.pos.x = 0x80;
            }
        };

        if (ball.vSign.vy == -1)
        {
            if (ball.pos.y + 4 > 0x88)
            {
                doCollisY();
            }
            else
            {
                doCollisX();
            }
        }
        else
        {
            if (ball.pos.y < 0x28)
            {
                doCollisY();
            }
            else
            {
                doCollisX();
            }
        }
    }
}

Proximity BallOp::GetBlockProximity(GameState& state, const unsigned int cellX, const unsigned int cellY)
{
    const auto index = cellY * GameConsts::BlocksPerRow + cellX;

    const auto isBlockPresent = [&](unsigned int index) -> bool {
        if (index >= GameConsts::BlockTableSize)
        {
            return false;
        }

        return (state.blocks[index] != Block(0));
    };

    return { isBlockPresent(index),
        isBlockPresent(index + 1),
        isBlockPresent(index + GameConsts::BlocksPerRow),
        isBlockPresent(index + GameConsts::BlocksPerRow + 1) };
}

void BallOp::CheckPaddleCollis(GameState& state, Ball& ball)
{
    state.paddleCollis = false;
    ball._paddleCollis = false;

    // No collision if we've disabled the hitbox.
    if (state._disablePaddleHitbox) return;

    // No collision if the ball is moving upwards.
    if (ball.vSign.vy == -1) return;

    const auto paddleLeftEdge = state.paddleX;
    const auto paddleLeftCenter = paddleLeftEdge + 8;
    const auto paddleRightCenter = paddleLeftCenter + 8;
    const auto paddleRightEdge = paddleRightCenter + 8; // TODO handle large paddle etc.

    // No collision if the ball is too far above or below the paddle.
    if (ball.pos.y + 4 < GameConsts::PaddleTop) return;
    if (GameConsts::PaddleTop + 3 < ball.pos.y) return;

    // No collision if the ball is too far from the paddle sides.
    if (ball.pos.x + 4 < paddleLeftEdge) return;
    if (ball.pos.x - 8 >= paddleRightEdge) return;

    if (ball.pos.x < paddleLeftEdge)
    {
        ball.angle = Angle::Shallow;
        ball.vSign.vy = -1;
        ball.vSign.vx = -1;
    }
    else if (ball.pos.x < paddleLeftCenter)
    {
        ball.angle = Angle::Normal;
        ball.vSign.vy = -1;
        ball.vSign.vx = -1;
    }
    else if (ball.pos.x + 1 < paddleRightCenter)
    {
        ball.angle = Angle::Steep;
        ball.vSign.vy = -1;
        ball.vSign.vx = -1;
    }
    else if (ball.pos.x < paddleRightEdge)
    {
        ball.angle = Angle::Steep;
        ball.vSign.vy = -1;
        ball.vSign.vx = 1;
    }
    else if (ball.pos.x - paddleRightEdge < 5)
    {
        ball.angle = Angle::Normal;
        ball.vSign.vy = -1;
        ball.vSign.vx = 1;
    }
    else if (ball.pos.x - paddleRightEdge < 8)
    {
        ball.angle = Angle::Shallow;
        ball.vSign.vy = -1;
        ball.vSign.vx = 1;
    }
    else
    {
        return;
    }

    state.speedReduction = 0;
    ball.speedStage = state.overallSpeedStage;
    ball.speedStageM = state.overallSpeedStageM;
    ball.cycle = 0;
    state.paddleCollis = true;

    ball._paddleCollis = true;

    // TODO other flags
    // TODO sticky paddle
}

void BallOp::CheckEnemyCollis(GameState& state, Ball& ball)
{
    // If there are any other collisions active (note that this is atypical),
    // don't do enemy collisions.
    if (ball.xCollis || ball.yCollis) return;

    for (auto&& enemy : state.enemies)
    {
        if (enemy.active && !enemy.exiting && enemy.pos.y < 0xe0)
        {
            if (ball.pos.x >= enemy.pos.x && enemy.pos.x + 0xc >= ball.pos.x
                && ball.pos.y >= enemy.pos.y && enemy.pos.y + 0xc >= ball.pos.y)
            {
                state.pendingScore += 100;

                enemy.active = false;
                enemy.destrFrame = 1;

                // In the original code the ball collision flags get replaced wholesale
                // instead of being combined with existing collision values, but since
                // we only get here if there are no collisions at all, it doesn't matter
                // in practice.

                if (ball.vSign.vy == -1)
                {
                    if (enemy.pos.y + 8 < ball.pos.y) ball.yCollis = true;
                    else ball.xCollis = true;
                }
                else
                {
                    if (enemy.pos.y + 8 < ball.pos.y) ball.xCollis = true;
                    else ball.yCollis = true;
                }
            }
        }
    }
}

void BallOp::UpdateCeilCollisVSign(GameState& state, Ball& ball)
{
    auto updateSigns = [&] {
        if (ball.xCollis) ball.vSign.vx *= -1;
        if (ball.yCollis) ball.vSign.vy *= -1;
    };

    // Don't change the speed stage on paddle bounces.
    // Also no need to update signs since the paddle-bounce logic handles that itself.
    if (state.paddleCollis) return;

    if (state.ceilCollis)
    {
        const auto ceilSpeedStage = Data::CeilingBounceSpeedStage[state.level];
        if (ceilSpeedStage > 0 && ceilSpeedStage > state.overallSpeedStage)
        {
            state.overallSpeedStage = ceilSpeedStage;
            state.overallSpeedStageM = ceilSpeedStage;
            state.speedStageCounter = Data::SpeedStageThresholds[state.overallSpeedStage];

            // Reset the cycle timer and speed stage for all three balls.
            for (auto&& ball : state.ball)
            {
                ball.cycle = 0;
                ball.speedStage = ceilSpeedStage;
                ball.speedStageM = ceilSpeedStage;
            }
        }

        updateSigns();
    }
    else if (ball.xCollis || ball.yCollis)
    {
        ball.cycle = 0;

        updateSigns();

        if (ball.vSign.vy == -1)
        {
            if (ball.speedStage != state.overallSpeedStage)
            {
                ball.speedStage = state.overallSpeedStage;
                ball.speedStageM = state.overallSpeedStage;
            }
            else if (ball.speedStageM != state.overallSpeedStageM)
            {
                ball.speedStageM = state.overallSpeedStageM;
            }
            else
            {
                return;
            }

            // Switch to a new angle since the speed stage was changed.
            if (ball.angle == Angle::Steep) ball.angle = Angle::Normal;
            else if (ball.angle == Angle::Normal) ball.angle = Angle::Steep;
            else if (ball.angle == Angle::Shallow) ball.angle = Angle::Normal;
        }
    }
}

void BallOp::HandleBlockCollis(GameState& state, Ball& ball)
{
    const auto cellX = state.calculatedCell.x;
    const auto cellY = state.calculatedCell.y;

    if(state.blockCollisSide.thisBlock || state.blockCollisSide.oneRight
       || state.blockCollisSide.oneDown || state.blockCollisSide.oneDownRight)
    {
        // Update speed stage data.
        state.speedStageCounter++;
        if (state.speedStageCounter == 256) state.speedStageCounter = 0;

        for (int i = 0; i < Data::SpeedStageThresholds.size(); i++)
        {
            if (state.speedStageCounter == Data::SpeedStageThresholds[i]
                && state.speedStageCounter > 0)
            {
                state.overallSpeedStageM = i;
                if (state.overallSpeedStage != 0xf)
                {
                    state.overallSpeedStage = i;
                }
                break;
            }
        }

        auto offset = 0;
        if (state.blockCollisSide.thisBlock)
        {
            offset = 0;
        }
        else if (state.blockCollisSide.oneRight)
        {
            offset = 1;
        }
        else if (state.blockCollisSide.oneDown)
        {
            offset = GameConsts::BlocksPerRow;
        }
        else if (state.blockCollisSide.oneDownRight)
        {
            offset = GameConsts::BlocksPerRow + 1;
        }

        // Note that this is the pre-collision value, so it maps directly onto the new index.
        const auto collisId = state.blockCollisCount;

        state.justHitBlock[collisId] = Block(0xf0);

        const auto index = cellY * GameConsts::BlocksPerRow + cellX + offset;
        if (index < GameConsts::BlockTableSize)
        {
            auto& block = state.blocks[index];
            if (!_SimulateGoldBlocks(state) || BlkType(block) != BlockType::Gold)
            {
                block = static_cast<uint8_t>(BlkType(block)) | BlkPowerup(block) | (BlkHits(block) - 1);
                if (BlkHits(block) == 0)
                {
                    state.justHitBlock[collisId] = block;
                    block = 0;
                }
            }

            state.justHitBlockCell[collisId] = { index % GameConsts::BlocksPerRow, index / GameConsts::BlocksPerRow };
        }

        state.justDestrBlock[collisId] = (state.justHitBlock[collisId] != Block(0xf0));

        state.blockCollisCount++;
    }
}

void BallOp::CheckBallLost(GameState& state, Ball& ball)
{

}


void EnemyOp::UpdateEnemyAnimTimers(GameState& state)
{
    for (int i = 0; i < 3; i++)
    {
        auto& enemy = state.enemies[i];
        if (enemy.active)
        {
            if (enemy.animTimer > 0) enemy.animTimer--;
            else enemy.animTimer = (i == 0 ? 0xa : 6);
        }
    }
}

void EnemyOp::AdvanceEnemies(GameState& state)
{
    for (auto&& enemy : state.enemies)
    {
        if (enemy.active)
        {
            if (enemy.moveTimer == 0)
            {
                AdvanceOneEnemy(state, enemy);
            }
            else
            {
                enemy.moveTimer--;
            }
        }
    }
}

void EnemyOp::AdvanceOneEnemy(GameState& state, Enemy& enemy)
{
    enemy.moveTimer = 3;

    CheckNormalMovement(state, enemy);
    CheckCirclingMovement(state, enemy);
    CheckDownMovement(state, enemy);
}

void EnemyOp::CheckNormalMovement(GameState& state, Enemy& enemy)
{
    if (enemy.movementType == MovementType::Normal)
    {
        if (enemy.exiting)
        {
            enemy.pos.y++;
            if (enemy.pos.y >= 0x10)
            {
                enemy.exiting = false;
                state.enemyGateState++;
            }
        }
        else
        {
            DoNormalEnemyMove(state, enemy);

            if (enemy.pos.y >= 0xb0)
            {
                enemy.movementType = MovementType::Downward;
            }
            else if(enemy.pos.y >= 0x60)
            {
                const auto startIndex = GameConsts::BlocksPerRow * ((enemy.pos.y - GameConsts::FieldMinY) >> 3);
                for (auto idx = startIndex; idx < startIndex + 36; idx++)
                {
                    if (idx < GameConsts::BlockTableSize && state.blocks[idx] != Block(0))
                    {
                        return;
                    }
                }

                enemy.movementType = MovementType::Circling;
                enemy.circleHalf = CircleHalf::Bottom;
                enemy.circleStage = 0;
                enemy.circleDir = (enemy.pos.x < 0x68 ? CircleDir::Counterclockwise : CircleDir::Clockwise);
            }
        }
    }
}

void EnemyOp::DoNormalEnemyMove(GameState& state, Enemy& enemy)
{
    auto CheckEnemyCollisGoingDown = [&] {
        auto collisIdx = CheckOtherEnemyCollis(state, enemy);
        if (collisIdx < 3 && enemy.pos.y < state.enemies[collisIdx].pos.y)
        {
            state._enemyMysteryInput = state.mysteryInput;

            // carry state = 0 since the last operation (A < B) cleared the flag
            auto rn = GameOp::_RandNum(state, 0);
            auto rnModFour = (rn % 4);

            if (rnModFour == 0 || rnModFour == 2)
            {
                enemy.moveDir = 4;
                enemy.descentTimer = 0x20;
            }
            else
            {
                enemy.moveDir = rnModFour;
            }

            state._justMovedEnemy = enemy._id;
            state._enemyMoveOptions = 0b11111;
        }
    };

    auto CheckEnemyCollisGoingRight = [&] {
        auto collisIdx = CheckOtherEnemyCollis(state, enemy);
        if (collisIdx < 3 && enemy.pos.x < state.enemies[collisIdx].pos.x)
        {
            enemy.moveDir = 2;
        }
    };

    auto CheckEnemyCollisGoingUp = [&] {
        auto collisIdx = CheckOtherEnemyCollis(state, enemy);
        if (collisIdx < 3 && enemy.pos.y >= state.enemies[collisIdx].pos.y)
        {
            enemy.moveDir = 0;
        }
    };

    auto CheckEnemyCollisGoingLeft = [&] {
        auto collisIdx = CheckOtherEnemyCollis(state, enemy);
        if (collisIdx < 3 && enemy.pos.x >= state.enemies[collisIdx].pos.x)
        {
            enemy.moveDir = 4;
            enemy.descentTimer = 0x20;
        }
    };

    // General flow: Given a movement direction, try to move in one of two directions
    // (e.g. move dir 0 -> priority A = move down, priority B = move right). If neither
    // movement is possible, figure out a new movement direction value. If either movement
    // succeeds, do a secondary check to see if this enemy bumped into any others; if so,
    // set a new movement direction.

    if (enemy.moveDir == 0)
    {
        enemy.pos.y++;
        if (CheckVertBlockCollis(state, enemy))
        {
            enemy.pos.y--;
            enemy.pos.x++;
            if (CheckHorizBlockCollis(state, enemy))
            {
                enemy.pos.x--;

                if (enemy.pos.x == 0xb0)
                {
                    enemy.moveDir = 2;
                }
                else
                {
                    state._enemyMysteryInput = state.mysteryInput;

                    // Set the carry state based on the previous comparison.
                    const auto carryBit = (enemy.pos.x >= 0xb0);

                    auto rn = GameOp::_RandNum(state, carryBit);
                    enemy.moveDir = (rn % 2 == 0 ? 2 : 1);

                    state._justMovedEnemy = enemy._id;
                    state._enemyMoveOptions = 0b00110;
                }
            }
            else
            {
                CheckEnemyCollisGoingRight();
            }
        }
        else
        {
            CheckEnemyCollisGoingDown();
        }
    }
    else if (enemy.moveDir == 1)
    {
        enemy.pos.x++;
        if (CheckHorizBlockCollis(state, enemy))
        {
            enemy.pos.x--;
            enemy.pos.y--;
            if (CheckVertBlockCollis(state, enemy))
            {
                enemy.pos.y++;
                enemy.moveDir = 2;
            }
            else
            {
                CheckEnemyCollisGoingUp();
            }
        }
        else
        {
            enemy.moveDir = 0;
            CheckEnemyCollisGoingRight();
        }
    }
    else if (enemy.moveDir == 2)
    {
        enemy.pos.y++;
        if (CheckVertBlockCollis(state, enemy))
        {
            enemy.pos.y--;
            enemy.pos.x--;
            if (CheckHorizBlockCollis(state, enemy))
            {
                enemy.pos.x++;
                if (enemy.pos.x == 0x10)
                {
                    enemy.moveDir = 3;
                }
                else
                {
                    state._enemyMysteryInput = state.mysteryInput;

                    // carry state = 1 since last comparison (x == 0x10) set the flag
                    auto rn = GameOp::_RandNum(state, 1);
                    enemy.moveDir = ((rn % 2 == 0) ? 3 : 0);

                    state._justMovedEnemy = enemy._id;
                    state._enemyMoveOptions = 0b01001;
                }
            }
            else
            {
                CheckEnemyCollisGoingLeft();
            }
        }
        else
        {
            CheckEnemyCollisGoingDown();
        }
    }
    else if (enemy.moveDir == 3)
    {
        enemy.pos.x--;
        if (CheckHorizBlockCollis(state, enemy))
        {
            enemy.pos.x++;
            enemy.pos.y--;
            if (CheckVertBlockCollis(state, enemy))
            {
                enemy.pos.y++;
                enemy.moveDir = 0;
            }
            else
            {
                CheckEnemyCollisGoingUp();
            }
        }
        else
        {
            enemy.moveDir = 2;
            CheckEnemyCollisGoingLeft();
        }
    }
    else if (enemy.moveDir == 4)
    {
        if (enemy.descentTimer == 0)
        {
            enemy.moveDir = 0;
        }
        else
        {
            enemy.descentTimer--;
            enemy.pos.y--;
            if (CheckVertBlockCollis(state, enemy))
            {
                enemy.pos.y++;
                enemy.moveDir = 0;
                enemy.descentTimer = 0;
            }
            else
            {
                CheckEnemyCollisGoingUp();
            }
        }
    }
}

void EnemyOp::CheckCirclingMovement(GameState& state, Enemy& enemy)
{
    if (enemy.movementType == MovementType::Circling)
    {
        auto deltaY = Data::CircleMovementTable[enemy.circleStage];
        if (deltaY == 0x80)
        {
            enemy.circleStage -= 2;
            enemy.circleHalf = (enemy.circleHalf == CircleHalf::Bottom ? CircleHalf::Top : CircleHalf::Bottom);
        }

        deltaY = Data::CircleMovementTable[enemy.circleStage];
        enemy.pos.y += deltaY;

        auto deltaX = Data::CircleMovementTable[enemy.circleStage + 1];

        if ((enemy.circleHalf == CircleHalf::Top && enemy.circleDir == CircleDir::Counterclockwise)
            || (enemy.circleHalf == CircleHalf::Bottom && enemy.circleDir == CircleDir::Clockwise))
        {
            enemy.pos.x += deltaX;
        }
        else
        {
            deltaX *= -1;

            // If 0, set to 1. This is a side-effect of the two's-complement negation code,
            // which sets the correct value but neglects to clear the carry bit. If the value
            // was 0, flipping the bits and adding one produces a carry, which is implicitly
            // applied to the subsequent position update.
            if (deltaX == 0) deltaX = 1;

            enemy.pos.x += deltaX;
        }
        
        if (enemy.circleHalf == CircleHalf::Bottom)
        {
            enemy.circleStage += 2;
        }
        else
        {
            enemy.circleStage -= 2;
            if (enemy.circleStage == 0)
            {
                enemy.circleHalf = CircleHalf::Bottom;
            }
        }

        if (enemy.pos.x < 0x11)
        {
            enemy.pos.x = 0x10;

            if (!(enemy.circleDir == CircleDir::Counterclockwise && enemy.circleHalf == CircleHalf::Bottom))
            {
                enemy.circleStage = 0;
                enemy.circleHalf = CircleHalf::Bottom;
                enemy.circleDir = CircleDir::Counterclockwise;
            }
        }
        else if (enemy.pos.x >= 0xb0)
        {
            enemy.pos.x = 0xb0;

            if (!(enemy.circleDir == CircleDir::Clockwise && enemy.circleHalf == CircleHalf::Bottom))
            {
                enemy.circleStage = 0;
                enemy.circleHalf = CircleHalf::Bottom;
                enemy.circleDir = CircleDir::Clockwise;
            }
        }

        if (enemy.pos.y >= 0xb0)
        {
            enemy.movementType = MovementType::Downward;
        }
    }
}

void EnemyOp::CheckDownMovement(GameState& state, Enemy& enemy)
{
    if (enemy.movementType == MovementType::Downward)
    {
        enemy.pos.y++;
        if (enemy.pos.y >= 0xf0)
        {
            enemy.active = false;
            enemy.movementType = MovementType::Normal;
        }
    }
}

bool EnemyOp::CheckVertBlockCollis(GameState& state, Enemy& enemy)
{
    if (enemy.pos.y == 0xf) return true;

    auto indexOffset = 0;
    if ((enemy.pos.y & 0x7) != 7)
    {
        indexOffset = 0x16;
        if ((enemy.pos.y & 7) != 1) return false;
    }
    
    state.mysteryInput = indexOffset;
    auto index = ((enemy.pos.y - 0x10) >> 3) * GameConsts::BlocksPerRow + ((enemy.pos.x - 0x10) >> 4);
    index += indexOffset;

    if (state.blocks[index] != Block(0))
    {
        return true;
    }
    else
    {
        if ((enemy.pos.x & 0xf) == 0) return false;
        else if (state.blocks[index + 1] == Block(0)) return false;
        else return true;
    }
}

bool EnemyOp::CheckHorizBlockCollis(GameState& state, Enemy& enemy)
{
    if (enemy.pos.x < 0x10) return true;
    if (enemy.pos.x >= 0xb1) return true;

    auto indexOffset = 0;
    if ((enemy.pos.x & 0xf) != 0xf)
    {
        indexOffset = 1;
        if ((enemy.pos.x & 0xf) != 1) return false;
    }

    state.mysteryInput = indexOffset;
    auto index = ((enemy.pos.y - 0x10) >> 3) * GameConsts::BlocksPerRow + ((enemy.pos.x - 0x10) >> 4);
    index += indexOffset;

    if (state.blocks[index] != Block(0))
    {
        return true;
    }
    else if (state.blocks[index + GameConsts::BlocksPerRow] != Block(0))
    {
        return true;
    }
    else if ((enemy.pos.y & 0x7) == 0)
    {
        return false;
    }
    else if (state.blocks[index + 2 * GameConsts::BlocksPerRow] == Block(0))
    {
        return false;
    }
    else
    {
        return true;
    }
}

unsigned int EnemyOp::CheckOtherEnemyCollis(GameState& state, Enemy& enemy)
{
    for (auto&& otherEnemy : state.enemies)
    {
        state.mysteryInput = otherEnemy._id;

        if (enemy._id != otherEnemy._id && otherEnemy.active)
        {
            if (otherEnemy.pos.x + 0xf >= enemy.pos.x
                && enemy.pos.x + 0xf >= otherEnemy.pos.x
                && otherEnemy.pos.y + 0xf >= enemy.pos.y
                && enemy.pos.y + 0xf >= otherEnemy.pos.y)
            {
                return otherEnemy._id;
            }
        }
    }

    return 0xff;
}

void EnemyOp::UpdateEnemyStatus(GameState& state)
{
    if (state.enemyGateState == 5)
    {
        // SpawnEnemy
        state.enemies[state.enemySpawnIndex].active = true;
        state.enemies[state.enemySpawnIndex].exiting = true;
        state.enemies[state.enemySpawnIndex].movementType = MovementType::Normal;
        state.enemies[state.enemySpawnIndex].moveTimer = 3;
        state.enemies[state.enemySpawnIndex].animTimer = 6;
        state.enemies[state.enemySpawnIndex].pos.y = 0;
        state.enemies[state.enemySpawnIndex].pos.x = (state.enemyGateIndex == 0 ? 0x34 : 0x8c);
        state.enemies[state.enemySpawnIndex].moveDir = (state.enemyGateIndex == 0 ? 2 : 0);

        state.enemyGateState++;
    }
    else if (state.enemyGateState == 0) // stand-in for EnemyGateState == 0
    {
        for (auto i = 0; i < 3; i++)
        {
            if (!state.enemies[i].active && (state.enemies[i].destrFrame == 0) && state.enemySpawnTimers[i] == 0)
            {
                // BeginSpawnEnemy
                state.enemySpawnIndex = i;
                state.enemyGateState = 1;
                state.enemyGateIndex = (state.paddleX >= 0x68 ? 1 : 0);
                break;
            }
        }
    }
}

void EnemyOp::HandleEnemyDestruction(GameState& state)
{
    for (auto&& enemy : state.enemies)
    {
        if (enemy.destrFrame > 0)
        {
            if (enemy.animTimer > 0)
            {
                enemy.animTimer--;
            }
            else
            {
                enemy.animTimer = 6;
                enemy.destrFrame++;

                if (enemy.destrFrame > 5)
                {
                    enemy.pos.y = 0xf0;
                    enemy.destrFrame = 0;
                }
            }
        }
    }
}

void EnemyOp::UpdateEnemySprites(GameState& state)
{
    // Lots of other stuff happens here in the game code, but the important bit
    // for the simulation is the state check and possible position update.
    for (auto&& enemy : state.enemies)
    {
        if (!enemy.active && enemy.destrFrame == 0)
        {
            enemy.pos.y = 0xf0;
        }
    }
}