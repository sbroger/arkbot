
#include <cstdio>

#include <GameData.h>
#include <GameConsts.h>
#include <GameState.h>
#include <GameOperations.h>
#include <EvalOperations.h>
#include <Utilities.h>

#include <UnitTests.h>

#include <vector>
#include <chrono>
#include <string>
#include <fstream>
#include <unordered_map>

std::wstring FileUtil::workingDir = L"";

std::vector<LevelParams> params = {
    {},

    // level 1 TAS: 567-1774, score 0 (completes at depth 23)
    { 567, 1774, 0,
        {
            [] (const GameState& state, const EvalState& eval) {
                bool anyBroken = false;
                for (int index = 5 * GameConsts::BlocksPerRow; index < 6 * GameConsts::BlocksPerRow; index++)
                {
                    if (BlkHits(state.blocks[index]) == 0)
                    {
                        anyBroken = true;
                        break;
                    }
                }

                return (eval.depth == 9 && !anyBroken);
            },
            [] (const GameState& state, const EvalState& eval) {
                bool anyBroken = false;
                for (int index = 4 * GameConsts::BlocksPerRow; index < 5 * GameConsts::BlocksPerRow; index++)
                {
                    if (BlkHits(state.blocks[index]) == 0)
                    {
                        anyBroken = true;
                        break;
                    }
                }

                return (eval.depth == 13 && !anyBroken);
            },
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth == 18 && EvalOp::BlockProgressPercent(state) < 80); //19 = 600 seconds
            }

        }
    },

    // level 2 TAS: 2071-3152, score 7050
    { 2071, 3152, 7050,
        {
            [](const GameState& state, const EvalState& eval) {
                return (state._frame > 2071 + 600 && EvalOp::BlockProgressPercent(state) < 80);
            }
        }
    },
    
    // level 3 TAS: 3449-4152, score 13730
                // Temporarily modified to 13530
    { 3449, 4152, 13530, {} },

    // level 4 TAS: 4449-5281, score 20710
    { 4449, 5281, 20710,
        /*{
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 7 && EvalOp::BlockProgressPercent(state) < 60);
            }
        }*/
    },
    
    // level 5 TAS: 5578-6890, score 34610
    { 5578, 6890, 34610, {} },

    // level 6 TAS: 7187-7806, score 51540
    { 7187, 7806, 51540,
        {
            //[] (const GameState& state, const EvalState& eval) {
            //    return (eval.depth > 5 && EvalOp::BlockProgressPercent(state) < 50);
            //}
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists);
            }
        }
    },

    // level 7 TAS: 8103-8910, score 58300
    { 8103, 8910, 58300, {} },

    // level 8 TAS: 9207-9455, score 65970
    { 9207, 9455, 65970, {} },

    // level 9 TAS: 9752-10379, score 67620
    { 9752, 10379, 67620, {} },

    // level 10 TAS: 10676-11486, score 72260
    { 10676, 11486, 72260,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists && state.ball[0].pos.y > 0x8a);
            }
        }
    },

    // level 11 TAS: 11783-13471, score 76420
    { 11783, 13471, 76420, {} },
    
    // level 12 TAS: 13768-14475, score 103770
    { 13768, 14475, 103770, {} },

    // level 13 TAS: 14772-15264, score 105370
    { 14772, 15264, 105370,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 5 && EvalOp::BlockProgressPercent(state) < 50);
            }
        }
    },

    // level 14 TAS: 15561-16379, score 111410
    { 15561, 16379, 111410, {} },

    // level 15 TAS: 16676-18425, score 136290
    { 16676, 18425, 136290, {} },

    // level 16 TAS: 18722-19380, score 175170
    { 18722, 19380, 175170, {} },

    // level 17 TAS: 19677-20506, score 181670
    { 19677, 20506, 181670, {} },

    // level 18 TAS: 20803-21475, score 193620
                // Temporarily modified to 193420
    { 20803, 21475, 193420, {} },

    // level 19 TAS: 21772-22492, score 199320
    { 21772, 22492, 199320, {} },

    // level 20 TAS: 22789-23343, score 204600
    { 22789, 23343, 204600, {} },

    // level 21 TAS: 23640-24088, score 211220
    { 23640, 24088, 211220,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists && state.ball[0].pos.y > 0x78);
            }
        }
    },

    // level 22 TAS: 24385-25024, score 214100
    { 24385, 25024, 214100, {} },

    // level 23 TAS: 25321-26625, score 220940
    { 25321, 26625, 220940, {} },

    // level 24 TAS: 26922-27913, score 298160
    { 26922, 27913, 298160,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists);
            }/*,
            [] (const GameState& state, const EvalState& eval) {
                return (state._frame > 26922 + 550 && EvalOp::BlockProgressPercent(state) < 50);
            }*/
        }
    },

    // level 25 TAS: 28210-29403, score 303860
    { 28210, 29403, 303860, {} },

    // level 26 TAS: 29700-30431, score 318090 (completes at depth 8)
    { 29700, 30431, 318090, {} },

    // level 27 TAS: 30728-32314, score 322850
    { 30728, 32314, 322850, {} },

    // level 28 TAS: 32611-33537, score 385960
    { 32611, 33537, 385960, {} },

    // level 29 TAS: 33834-35473, score 391630
    { 33834, 35473, 391630, {} },

    // level 30 TAS: 35770-37210, score 410530
    { 35770, 37210, 410530, {} },

    // level 31 TAS: 37507-38573, score 425340
                // Temporarily modified to 425740
    { 37507, 38573, 425740, {} },

    // level 32 TAS: 38870-39686, score 490750
    { 38870, 39686, 490750,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && EvalOp::BlockProgressPercent(state) < 30);
            }
        }
    },

    // level 33 TAS: 39983-41420, score 504910
    { 39983, 41420, 504910, {} },

    // level 34 TAS: 41717-42664, score 528000
    { 41717, 42664, 528000, {} },

    // level 35 TAS: 42961-43779, score 533470
    { 42961, 43779, 533470, {} },

    // level 36 TAS: TBD
    { 44077, 45888, 551220, {} },
};

std::vector<LevelParams> params_chefTas = {
    {},

    // level 1 TAS: 567-1555 (length 988), starting score 0
    { 566, 1555, 0, {} },

    // level 2 TAS: 1851-2676 (length 825), starting score 7050
    { 1851, 2676, 7050, {} },
    
    // level 3 TAS: 2973-3577, (length 604), starting score 13530
    { 2973, 3577, 13530, {} },

    // level 4 TAS: 3874-4632, (length 758), starting score 20710
    { 3874, 4632, 20710, {} },
    

    // TBD: Other levels. For now the rest are placeholders copied from above.


    // level 5 TAS: 5578-6890, score 34610
    { 5578, 6890, 34610, {} },

    // level 6 TAS: 7187-7806, score 51540
    { 7187, 7806, 51540,
        {
            //[] (const GameState& state, const EvalState& eval) {
            //    return (eval.depth > 5 && EvalOp::BlockProgressPercent(state) < 50);
            //}
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists);
            }
        }
    },

    // level 7 TAS: 8103-8910, score 58300
    { 8103, 8910, 58300, {} },

    // level 8 TAS: 9207-9455, score 65970
    { 9207, 9455, 65970, {} },

    // level 9 TAS: 9752-10379, score 67620
    { 9752, 10379, 67620, {} },

    // level 10 TAS: 10676-11486, score 72260
    { 10676, 11486, 72260,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists && state.ball[0].pos.y > 0x8a);
            }
        }
    },

    // level 11 TAS: 11783-13471, score 76420
    { 11783, 13471, 76420, {} },
    
    // level 12 TAS: 13768-14475, score 103770
    { 13768, 14475, 103770, {} },

    // level 13 TAS: 14772-15264, score 105370
    { 14772, 15264, 105370,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 5 && EvalOp::BlockProgressPercent(state) < 50);
            }
        }
    },

    // level 14 TAS: 15561-16379, score 111410
    { 15561, 16379, 111410, {} },

    // level 15 TAS: 16676-18425, score 136290
    { 16676, 18425, 136290, {} },

    // level 16 TAS: 18722-19380, score 175170
    { 18722, 19380, 175170, {} },

    // level 17 TAS: 19677-20506, score 181670
    { 19677, 20506, 181670, {} },

    // level 18 TAS: 20803-21475, score 193620
                // Temporarily modified to 193420
    { 20803, 21475, 193420, {} },

    // level 19 TAS: 21772-22492, score 199320
    { 21772, 22492, 199320, {} },

    // level 20 TAS: 22789-23343, score 204600
    { 22789, 23343, 204600, {} },

    // level 21 TAS: 23640-24088, score 211220
    { 23640, 24088, 211220,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists && state.ball[0].pos.y > 0x78);
            }
        }
    },

    // level 22 TAS: 24385-25024, score 214100
    { 24385, 25024, 214100, {} },

    // level 23 TAS: 25321-26625, score 220940
    { 25321, 26625, 220940, {} },

    // level 24 TAS: 26922-27913, score 298160
    { 26922, 27913, 298160,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && !state.ball[1].exists);
            }/*,
            [] (const GameState& state, const EvalState& eval) {
                return (state._frame > 26922 + 550 && EvalOp::BlockProgressPercent(state) < 50);
            }*/
        }
    },

    // level 25 TAS: 28210-29403, score 303860
    { 28210, 29403, 303860, {} },

    // level 26 TAS: 29700-30431, score 318090 (completes at depth 8)
    { 29700, 30431, 318090, {} },

    // level 27 TAS: 30728-32314, score 322850
    { 30728, 32314, 322850, {} },

    // level 28 TAS: 32611-33537, score 385960
    { 32611, 33537, 385960, {} },

    // level 29 TAS: 33834-35473, score 391630
    { 33834, 35473, 391630, {} },

    // level 30 TAS: 35770-37210, score 410530
    { 35770, 37210, 410530, {} },

    // level 31 TAS: 37507-38573, score 425340
                // Temporarily modified to 425740
    { 37507, 38573, 425740, {} },

    // level 32 TAS: 38870-39686, score 490750
    { 38870, 39686, 490750,
        {
            [] (const GameState& state, const EvalState& eval) {
                return (eval.depth > 4 && EvalOp::BlockProgressPercent(state) < 30);
            }
        }
    },

    // level 33 TAS: 39983-41420, score 504910
    { 39983, 41420, 504910, {} },

    // level 34 TAS: 41717-42664, score 528000
    { 41717, 42664, 528000, {} },

    // level 35 TAS: 42961-43779, score 533470
    { 42961, 43779, 533470, {} },

    // level 36 TAS: TBD
    { 44077, 45888, 551220, {} },
};

void SetupAndExecute(EvalState& eval, const unsigned int level, const unsigned int maxDepth, const unsigned int launchDelayRange,
                     const unsigned int skipToFrame, const unsigned int overrideFrameLimit = 0)
{
    const auto& levelParams = params_chefTas;

    GameState state;
    GameOp::Init(state);
    GameOp::AdvanceToLevel(state, level);

    state._frame = levelParams[state.level].startFrame;
    eval.startFrame = state._frame;

    auto endingFrame = 0u;
    if (overrideFrameLimit)
    {
        endingFrame = eval.startFrame + overrideFrameLimit;
    }
    else
    {
        endingFrame = state._frame + EvalOp::GetBizHawkMovieFrameLen(state);
        if (endingFrame == state._frame)
        {
            endingFrame = levelParams[state.level].endFrameRef;
            //endingFrame = 99999;
        }
    }

    state.score = levelParams[state.level].startingScore;

    eval.sharedState->frameLimit.store(endingFrame);

    eval.depthLimit = maxDepth;
    eval.launchDelayRange = launchDelayRange;

    // Apply level-specific conditions.
    for (const auto& condition : levelParams[state.level].conditions)
    {
        eval.conditions.push_back(condition);
    }

    if (eval.printState)
    {
        state._OnFrameAdvance = [&](const GameState& state) {
            EvalOp::OnFrameAdvance(state, eval);
        };
    }

    // Override certain flags that are implied by the circumstances.

    // Disabled for performance testing
    //if (!_SimulateEnemies())
    //{
    //    // No reason to delay if there aren't enemies to wait around for.
    //    eval.launchDelayRange = 0;
    //}

    // Start evaluating.

    printf("Available thread count: %d\n", std::thread::hardware_concurrency());

    printf("Evaluating level %d: %d-%d (%d frames), max depth %d, time limit %d\n", state.level, state._frame,
           eval.sharedState->frameLimit.load(), eval.sharedState->frameLimit.load() - state._frame, eval.depthLimit, eval.timeLimit);

    std::string str;

    if (eval.multithreading == Multithreading::All) str = "Full multithreading";
    else if (eval.multithreading == Multithreading::AllButOne) str = "N-1 multithreading";
    else str = "One thread";

    if (skipToFrame > 0) str += "\n\n- Jumping to frame " + std::to_string(skipToFrame) + " -";

    printf("%s\n", str.c_str());

    const auto initTime = std::chrono::high_resolution_clock::now();

    if (eval.testAllScoreVariations) printf(" -- Score %d --\n", state.score);

    if (skipToFrame > 0)
    {
        const auto inputChain = EvalOp::BizHawkMovieToInputChain(FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(level) + L".txt");
        if (inputChain.size() > 0)
        {
            if (skipToFrame >= inputChain.size())
            {
                printf("SkipToFrame value %d exceeds movie length %d!\n", skipToFrame, static_cast<int>(inputChain.size()));
                exit(0);
            }
            else
            {
                for (auto i = 0u; i < skipToFrame; i++)
                {
                    GameOp::ExecuteInput(state, inputChain[i]);
                }
            }
        }
    }

    EvalOp::Evaluate(state, eval);

    if (eval.testAllScoreVariations)
    {
        for (int i = 1; i <= 9; i++)
        {
            state.score += 1000;
            printf(" -- Score %d --\n", state.score);
            EvalOp::Evaluate(state, eval);
        }
    }

    const auto finishTime = std::chrono::high_resolution_clock::now();
    const auto intervalMs = std::chrono::duration_cast<std::chrono::milliseconds>(finishTime - initTime);

    printf("Elapsed time %lld.%lld seconds\n", intervalMs.count() / 1000, intervalMs.count() % 1000);
}

std::wstring GenerateTimeEntry(const unsigned int level, EvalState& eval, const std::chrono::milliseconds& time)
{
    auto str = (L"Level " + std::to_wstring(level) + L" bounce mask " + eval.bounceMask
                + (eval.enforceTasRefHitProgression ? L" hit prog. " + std::to_wstring(eval.hitProgressionGraceInterval) + L"/" + std::to_wstring(eval.hitProgressionLeadupInterval) : L"")
                + L": " + std::to_wstring(time.count() / 1000) + L"." + std::to_wstring(time.count() % 1000));

    if (eval.outputBestAttempts && eval.sharedState->bestBlockHitCount > 0 && eval.sharedState->bestBlockHitCount < 9999)
    {
        str += L" (" + std::to_wstring(eval.sharedState->bestBlockHitCount) + L" block" + (eval.sharedState->bestBlockHitCount == 1 ? L"" : L"s") + L" remaining)";
    }

    return str;
}

void WriteOneReferenceLevel(const unsigned int level)
{
    // TODO also clean up input at the same time

    GameState state;
    GameOp::Init(state);
    GameOp::AdvanceToLevel(state, level);
    state.score = params[state.level].startingScore;

    const auto fullInputChain = EvalOp::BizHawkMovieToInputChain(FileUtil::ResultsDir() + L"Input Log_TASRef.txt");

    std::vector<Input> inputChain;
    for (auto i = params[level].startFrame; i < params[level].endFrameRef; i++)
    {
        inputChain.push_back(fullInputChain[i]);
    }

    int idx = 0;
    for (const auto input : inputChain)
    {
        if ((input.controller == LeftInput && state.paddleX == GameConsts::PaddleMin)
            || (input.controller == RightInput && state.paddleX == GameConsts::PaddleMax))
        {
            GameOp::ExecuteInput(state, { NoInput, input.arkConInput });
            inputChain[idx] = { NoInput, input.arkConInput };
        }
        else if ((input.controller == LeftAInput && state.paddleX == GameConsts::PaddleMin)
                 || (input.controller == RightAInput && state.paddleX == GameConsts::PaddleMax))
        {
            GameOp::ExecuteInput(state, { AInput, input.arkConInput });
            inputChain[idx] = { AInput, input.arkConInput };
        }
        else
        {
            GameOp::ExecuteInput(state, input);
        }

        ++idx;
    }

    // Allow the score to tally up.
    while (state.pendingScore > 0)
    {
        GameOp::ExecuteInput(state, { NoInput, 0 });
    }

    EvalState eval;
    eval.startFrame = 0;

    EvalOp::OutputBizHawkMovie(state, eval);
}

void VisualizeLevelSolution(const unsigned int level)
{
    EvalState testEval;
    testEval.sleepLen = 14;

    GameState state;
    GameOp::Init(state);
    GameOp::AdvanceToLevel(state, level);
    state.score = params[state.level].startingScore;

    const auto inputChain = EvalOp::BizHawkMovieToInputChain(FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(level) + L".txt");

    if (inputChain.size() > 0)
    {
        //const auto decisionSet = EvalOp::ObserveDecisionPoints(inputChain, level, state.score, true, true);

        for (int i = 0; i < inputChain.size(); i++)
        {
            GameOp::ExecuteInput(state, inputChain[i]);
            EvalOp::PrintGameState(state, testEval);
        }

        EvalOp::Sleep(1200);
    }
    else
    {
        const auto fullInputChain = EvalOp::BizHawkMovieToInputChain(FileUtil::ResultsDir() + L"Input Log_TASRef.txt");

        std::vector<Input> inputChain;
        for (auto i = params[level].startFrame; i < params[level].endFrameRef; i++)
        {
            inputChain.push_back(fullInputChain[i]);
        }

        int idx = 0;
        for (const auto input : inputChain)
        {
            if ((input.controller == LeftInput && state.paddleX == GameConsts::PaddleMin)
                || (input.controller == RightInput && state.paddleX == GameConsts::PaddleMax))
            {
                GameOp::ExecuteInput(state, { NoInput, input.arkConInput });
                inputChain[idx] = { NoInput, input.arkConInput };
            }
            else if ((input.controller == LeftAInput && state.paddleX == GameConsts::PaddleMin)
                     || (input.controller == RightAInput && state.paddleX == GameConsts::PaddleMax))
            {
                GameOp::ExecuteInput(state, { AInput, input.arkConInput });
                inputChain[idx] = { AInput, input.arkConInput };
            }
            else
            {
                GameOp::ExecuteInput(state, input);
            }

            EvalOp::PrintGameState(state, testEval);

            ++idx;
        }

        //const auto decisionSet = EvalOp::ObserveDecisionPoints(inputChain, level, state.score, true, true);
    }
}

void VisualizeFullTAS()
{
    EvalOp::PrintBlankScreen();
    EvalOp::Sleep(250);

    for (int i = 0; i < 5; i++)
    {
        EvalOp::PrintGameStartScreen(true);
        EvalOp::Sleep(500);
        EvalOp::PrintGameStartScreen(false);
        EvalOp::Sleep(500);
    }

    EvalOp::PrintGameStartScreen(true);
    EvalOp::Sleep(500);

    for (int i = 1; i <= 36; i++)
    {
        EvalOp::PrintLevelLoadScreen(i);
        EvalOp::Sleep(1500);

        GameState state;
        GameOp::Init(state);
        GameOp::AdvanceToLevel(state, i);
        state.score = params[state.level].startingScore;

        EvalOp::PrintGameState(state, EvalState(), true);

        VisualizeLevelSolution(i);
    }

    EvalOp::Sleep(2000);
    EvalOp::PrintEndingText(100);
    EvalOp::Sleep(15000);
}

void GenerateBlockHitTable(const std::wstring& filename, const bool originalTAS)
{
    FileUtil::ClearFile(filename.c_str());

    std::ofstream outFile;
    outFile.open(filename, std::ios::out);

    if (outFile.good())
    {
        const auto inputChainRef = EvalOp::BizHawkMovieToInputChain(FileUtil::ResultsDir() + (originalTAS ? L"Input Log_TASRef.txt" : L"Input Log_Combined.txt"));

        GameState refState;
        GameOp::Init(refState);
        refState._frame = (originalTAS ? 567 : 565);

        const auto writeHitVal = [&](const unsigned int value, const unsigned int count) {
            for (auto i = 0u; i < count; i++)
            {
                std::string str = std::to_string(value) + "\r\n";
                outFile.write(str.c_str(), str.size());
            }
        };

        writeHitVal(9999, refState._frame);

        for (auto level = 1; level <= 35; level++)
        {
            GameOp::AdvanceToLevel(refState, level);

            auto hits = 99;
            while (hits > 0)
            {
                GameOp::ExecuteInput(refState, inputChainRef[refState._frame]);

                hits = EvalOp::GetRemainingHits(refState);
                std::string str = std::to_string(hits) + "\r\n";
                outFile.write(str.c_str(), str.size());
            }

            // Wait a frame before checking the score, since the block hit and the score change happen
            // on different frames.
            GameOp::ExecuteInput(refState, NoInput);
            writeHitVal(0, 1);

            // Wait for the score to tally.
            while (refState.pendingScore > 0)
            {
                GameOp::ExecuteInput(refState, NoInput);
                writeHitVal(0, 1);
            }

            writeHitVal(9999, 297);
            refState._frame += 297;
        }
    }

    outFile.close();
}

void LoadBlockHitTable(EvalState& eval, const bool originalTAS)
{
    const auto filename = FileUtil::ResultsDir() + (originalTAS ? L"HitTable_TASRef.txt" : L"HitTable_CombinedBest.txt");
    eval.sharedState->hitTable.reserve(params[35].endFrameRef + 1);

    std::ifstream inFile;
    inFile.open(filename);

    if (!inFile.good())
    {
        inFile.close();

        GenerateBlockHitTable(filename, originalTAS);

        inFile.open(filename);
    }

    if (inFile.good())
    {
        std::string line;
        while (std::getline(inFile, line))
        {
            // Remove the trailing carriage return + newline.
            const auto parts = StringUtil::Split(line, '\r');
            if (parts.size() > 0)
            {
                eval.sharedState->hitTable.push_back(atoi(parts[0].c_str()));
            }
        }
    }
}

void GenerateBounceResultTable(const std::wstring& filename, const unsigned int xPos)
{
    EvalState testEval;
    testEval.sleepLen = 0;

    const auto minPaddleBounceY = GameConsts::PaddleTop - 4 - 8;
    const auto maxPaddleBounceY = GameConsts::PaddleTop + 5;

    GameState testState;
    GameOp::Init(testState);
    GameOp::AdvanceToLevel(testState, 1);
    testState._disableBlockHitboxes = true;
    GameOp::ExecuteInput(testState, AInput);

    std::unordered_map<BallInitState, PaddleBounceState, BallInitStateHasher> bounceTable;
    bounceTable.reserve(6 * 172 * 12 * 4 * 16);

    const auto outputResults = [&] {
        std::ofstream outFile;
        outFile.open(filename, std::ios::out | std::ios::app);

        for (auto&& entry : bounceTable)
        {
            std::string line = std::to_string(entry.first.startDir) + " " + std::to_string(entry.first.startPos.x) + " " + std::to_string(entry.first.startPos.y)
                               + " " + std::to_string(entry.first.startCycle) + " " + std::to_string(entry.first.speedStage) + " "
                               + std::to_string(entry.first.paddleX) + " " + std::to_string(entry.second.bounced) + " "
                               + std::to_string(entry.second.bounceDir) + "\r\n";

            outFile.write(line.c_str(), line.size());
        }

        outFile.close();
    };

    for (int startDir = -3; startDir <= 3; startDir++)
    {
        if (startDir == 0) continue;

        const auto angle = static_cast<Angle>(std::abs(startDir) - 1);

        std::vector<SpeedTableRow>* speedTable = nullptr;
        if (angle == Angle::Steep) speedTable = &Data::SteepSpeedTable;
        else if (angle == Angle::Normal) speedTable = &Data::NormalSpeedTable;
        else speedTable = &Data::ShallowSpeedTable;

        printf(".");

        for (unsigned int yPos = minPaddleBounceY; yPos <= maxPaddleBounceY; yPos++)
        {
            for (unsigned int speedStage = 6; speedStage < 16; speedStage++)
            {
                const auto speedRow = &(*speedTable)[speedStage];
                const auto cycleLen = speedRow->cycleLen;

                for (auto paddleX = GameConsts::PaddleMin; paddleX <= GameConsts::PaddleMax; paddleX += 3)
                {
                    for (unsigned int cycle = 0; cycle < cycleLen; cycle++)
                    {
                        testState.paddleX = paddleX;
                        testState.overallSpeedStage = speedStage;
                        testState.overallSpeedStageM = speedStage;
                        testState.ball[0].speedStage = speedStage;
                        testState.ball[0].speedStageM = speedStage;
                        testState.ball[0].cycle = cycle;
                        testState.ball[0].pos = { xPos, yPos };
                        testState.ball[0].angle = angle;
                        testState.ball[0].vSign.vx = startDir < 0 ? -1 : 1;
                        testState.ball[0].vSign.vy = 1;

                        testState.ball[0].speedRow = speedRow;
                        // The speed row index moves in a stride of two each time, starting at
                        // zero and advancing for each cycle value and each "extra" move that's
                        // generated from the speedMult value.
                        testState.ball[0].speedRowIdx = 2 * speedRow->speedMult * (cycleLen - cycle);
                        testState.ball[0].speedMult = 0;
                        testState.ball[0]._paddleCollis = false;
                        testState.ball[0].yCollis = false;
                        testState.ball[0].xCollis = false;

                        testState.paddleCollis = false;

                        while (!testState.paddleCollis && testState.ball[0].pos.y <= maxPaddleBounceY)
                        {
                            GameOp::ExecuteInput(testState, NoInput);
                        }

                        BallInitState ballInit;
                        ballInit.paddleX = paddleX;
                        ballInit.speedStage = speedStage;
                        ballInit.startCycle = cycle;
                        ballInit.startPos = { xPos, yPos };
                        ballInit.startDir = startDir;

                        PaddleBounceState result;
                        result.bounced = testState.paddleCollis;

                        if (result.bounced)
                        {
                            result.bounceDir = (static_cast<int>(testState.ball[0].angle) + 1) * testState.ball[0].vSign.vx;
                            bounceTable.insert(std::make_pair<BallInitState, PaddleBounceState>(std::move(ballInit), std::move(result)));
                        }
                    }
                }
            }

            outputResults();
            bounceTable.clear();
        }
    }
}

void LoadBounceResultTable(const std::wstring& filename, EvalState& eval)
{
    eval.sharedState->bounceTable.reserve(6 * 172 * 12 * 4 * 16);

    std::ifstream inFile;
    inFile.open(filename);

    if (!inFile.good())
    {
        inFile.close();

        for (unsigned int xPos = GameConsts::FieldMinX; xPos <= GameConsts::FieldMaxX; xPos++)
        {
            GenerateBounceResultTable(filename, xPos);
        }

        inFile.open(filename);
    }

    if (inFile.good())
    {
        printf("Parsing\n");

        std::string line;
        while (std::getline(inFile, line))
        {
            // Remove the trailing carriage return + newline.
            const auto lineParts = StringUtil::Split(line, '\r');
            if (lineParts.size() > 0)
            {
                const auto parts = StringUtil::Split(lineParts[0], ' ');
                if (parts.size() == 8)
                {
                    const auto startDir = atoi(parts[0].c_str());
                    const auto xPos = atoi(parts[1].c_str());
                    const auto yPos = atoi(parts[2].c_str());
                    const auto cycle = atoi(parts[3].c_str());
                    const auto speedStage = atoi(parts[4].c_str());
                    const auto paddleX = atoi(parts[5].c_str());

                    const bool paddleCollis = atoi(parts[6].c_str());
                    const auto bounceDir = atoi(parts[7].c_str());

                    BallInitState ballInit;
                    ballInit.paddleX = paddleX;
                    ballInit.speedStage = speedStage;
                    ballInit.startCycle = cycle;
                    ballInit.startPos = { static_cast<unsigned int>(xPos), static_cast<unsigned int>(yPos) };
                    ballInit.startDir = startDir;

                    PaddleBounceState result;
                    result.bounced = paddleCollis;
                    result.bounceDir = bounceDir;
                    eval.sharedState->bounceTable.insert(std::make_pair<BallInitState, PaddleBounceState>(std::move(ballInit), std::move(result)));
                }
            }
        }
    }
    else
    {
        printf("Couldn't open bounce table\n");
        exit(0);
    }
}

void ConvertOnePlayerMovieToTwoPlayerFormat()
{
    std::ifstream inFile;
    inFile.open(FileUtil::ResultsDir() + L"Input Log.txt");

    std::ofstream outFile;
    outFile.open(FileUtil::ResultsDir() + L"Input Log-2P.txt");

    if (inFile.good())
    {
        std::string str;

        while (std::getline(inFile, str))
        {
            outFile << (str + "........|").c_str() << std::endl;
        }
    }

    inFile.close();
    outFile.close();
}

int wmain(int argc, wchar_t** argv)
{
    FileUtil::SetWorkingDir((argc < 2) ? L"" : std::wstring(argv[1]));
    Log::Clear();

    if (_Pedantic)
    {
#ifdef _DEBUG
        printf("Run unit tests in Release for better performance.\n");
#endif

        UnitTest::Run();
        exit(0);
    }

    // Watch the whole TAS including title and level transition screens.
    //VisualizeFullTAS();
    //exit(0);

    // Watch the solution for a subset of levels.
    /*for (int i = 8; i <= 8; i++)
    {
        VisualizeLevelSolution(i);
    }
    exit(0);*/

    Log::Write("Starting evaluation\n");

    EvalState eval;

    eval.outputBizHawkMovie = true;
    eval.printProgress = false;

    eval.useBounceTableLookups = false;
    eval.treatLookupFailuresAsFatal = true;
    eval.bounceTableDebugChecks = false;

    eval.testAllScoreVariations = false;

    eval.printState = false;
    eval.printRate = 0;
    eval.sleepLen = 12;

    auto excessTime = 0;

    constexpr int EnsurePowerupByDepthTable[37] = {
        0,
        2, 2, 3, 2, 2, 2, 3, 2,
        2, 0, 0, 0, 2, 3, 5, 2,
        2, 2, 2, 2, 2, 2, 3, 3,
        9, 0, 9, 3, 5, 9, 2, 2,
        6, 2, 2,
        0
    };

    std::vector<std::wstring> TwoBouncePermutations = {
        L"1=1", L"1=2", L"1=3", L"2=1", L"2=2", L"2=3", L"3=1", L"3=2", L"3=3",
        L"12=", L"13=", L"23=", L"=12", L"=13", L"=23"
    };

    std::vector<std::wstring> ThreeBouncePermutations = {
        L"12=1", L"12=2", L"12=3", L"13=1", L"13=2", L"13=3", L"23=1", L"23=2", L"23=3",
        L"1=12", L"2=12", L"3=12", L"1=13", L"2=13", L"3=13", L"1=23", L"2=23", L"3=23",
        L"=123", L"123="
    };

    std::vector<std::wstring> FourBouncePermutations = {
        L"12=12", L"12=13", L"12=23", L"13=12", L"13=13", L"13=23", L"23=12", L"23=13", L"23=23",
        L"1=123", L"2=123", L"3=123", L"123=1", L"123=2", L"123=3"
    };

    std::vector<std::wstring> FiveBouncePermutations = {
        L"12=123", L"13=123", L"23=123", L"123=12", L"123=13", L"123=23"
    };

    struct LaunchRange
    {
        LaunchRange() {}
        LaunchRange(unsigned int first, unsigned int last)
         : firstPos(first), lastPos(last)
        {}

        unsigned int firstPos = 0;
        unsigned int lastPos = 0;
    };

    struct HitPrg
    {
        HitPrg() {}
        HitPrg(int grace, int leadup)
            : graceInterval(grace), leadupInterval(leadup)
        {
            enabled = true;
        }

        int graceInterval = -999;
        int leadupInterval = -999;
        bool enabled = false;
    };

    enum class PowerupAnywhere { Off, On };
    enum class LaunchDelay { Off, On };
    enum class EnemyManips { Off, On };
    enum class Bumps { Off, On };
    enum class SideHits { Off, On };

    struct LevelJob
    {
        unsigned int level;
        int skipToDepth;
        std::vector<std::wstring> bounceMasks;
        LaunchRange launchRange;
        HitPrg hitProgression;
        unsigned int timeLimit;
        SideHits sideHits;
        Bumps bumps;
        EnemyManips enemyManips;
        LaunchDelay launchDelay;
        PowerupAnywhere powerupAnywhere;
    };

    eval.allPowerupManipOptions = false;

    eval.multithreading = Multithreading::AllButOne;

    eval.noConditions = true;
    eval.useHitProgressionAveraging = false;
    eval.strictHitProgression = false;
    eval.manipulateEnemyMoves = false;
    bool hitProgAgainstOriginalTAS = true;

    std::vector<LevelJob> jobs;

    VisualizeLevelSolution(2);

    //jobs.emplace_back(LevelJob{ 1, 0, { L"123=123" }, LaunchRange{16, 16}, HitPrg{}, 20000 * 60 * 60, SideHits::On, Bumps::On, EnemyManips::Off, LaunchDelay::Off, PowerupAnywhere::Off });

    // A few examples of jobs that can be run:

    // 1. Standard job for a particular level; nothing special going on.
    //jobs.emplace_back(LevelJob{ 4, 0, { L"123=123" }, LaunchRange{}, HitPrg{}, 200 * 60 * 60, SideHits::On, Bumps::On, EnemyManips::Off, LaunchDelay::On, PowerupAnywhere::On });

    // 2. Reverse-evaluated job; starting from the current-best solution,
    // go more and more decision points backwards and evaluate from there.
    /*for (int i = -1; i >= -99; i--)
    {
        jobs.emplace_back( LevelJob { 15, i, { L"123=123" }, LaunchRange{}, HitPrg{}, 2 * 60 * 60, SideHits::On, Bumps::On, EnemyManips::Off, LaunchDelay::Off, PowerupAnywhere::On } );
    }*/

    // 3. "Hit progression" job; normal, except if at any point we're too far
    // behind the old TAS, give up and prune the branch.
    //jobs.emplace_back( LevelJob { 1, 0, { L"123=123" }, LaunchRange{}, HitPrg{ 400, 50 }, 200 * 60 * 60, SideHits::Off, Bumps::Off, EnemyManips::Off, LaunchDelay::Off, PowerupAnywhere::Off } );
    
    // 4. Custom length-limited job; normal, except the frame limit beyond which
    // branches are pruned is the number here instead of the current-best length.
    // Useful for answering questions like "can level N be completed in less than
    // X frames", where X is the limit specified here.
    const auto enableOverrideFrameLimit = false;
    const auto overrideFrameLimit = 100;
    //jobs.emplace_back( LevelJob { 8, 0, { L"123=123" }, LaunchRange{}, HitPrg{}, 200 * 60 * 60, SideHits::Off, Bumps::Off, EnemyManips::Off, LaunchDelay::Off, PowerupAnywhere::Off } );

    const auto fullLevelTimeLimit = true;

    eval.allPowerupCollectionOptions = false;
    eval.allEnemyHitOptions = true;

    const auto maxDepth = 999;
    const auto printDecisionPoints = false;
    const auto printEachLaunchTime = true;
    eval.outputBestAttempts = false;

    if (eval.useBounceTableLookups && !jobs.empty())
    {
        LoadBounceResultTable(FileUtil::ResultsDir() + L"BounceTable.txt", eval);
    }

    std::unordered_map<unsigned int, bool> skipList;

    const auto initTime = std::chrono::high_resolution_clock::now();
    std::vector<std::wstring> timeResults;

    for (auto&& job : jobs)
    {
        if (skipList.find(job.level) != skipList.end()) continue;

        if (enableOverrideFrameLimit && overrideFrameLimit > EvalOp::BizHawkMovieToInputChain(job.level).size()) continue;

        const auto level = job.level;

        printf("\n=========\n");
        printf("Level %d\n", level);
        printf("=========\n");

        const auto timeLimit = job.timeLimit;

        auto evalBase = eval;
        const auto allowPowerupAnywhere = (job.powerupAnywhere == PowerupAnywhere::On);
        const auto launchDelayRange = (job.launchDelay == LaunchDelay::On) ? 100 : 0;
        evalBase.manipulateEnemies = (job.enemyManips == EnemyManips::On);
        evalBase.includeBumpOptions = (job.bumps == Bumps::On);
        evalBase.allSideHitVariations = (job.sideHits == SideHits::On);

        evalBase.enforceTasRefHitProgression = job.hitProgression.enabled;
        evalBase.hitProgressionGraceInterval = job.hitProgression.graceInterval;   // Allow being at a hit count up to N frames behind the reference movie (larger = more permissive)
        evalBase.hitProgressionLeadupInterval = job.hitProgression.leadupInterval; // Ignore hit progression for the first N frames, then start enforcing (larger = more permissive)

        if (evalBase.enforceTasRefHitProgression)
        {
            LoadBlockHitTable(eval, hitProgAgainstOriginalTAS);
        }

        for (auto&& mask : job.bounceMasks)
        {
            eval = evalBase;
            eval.bounceMask = mask;
            wprintf(L"\nBounce Mask %s\n\n", eval.bounceMask.c_str());

            if (eval.outputBestAttempts)
            {
                // Reset the block hit count so it doesn't persist between attempts.
                eval.sharedState->bestBlockHitCount = 9999;
            }

            const auto iterInitTime = std::chrono::high_resolution_clock::now();

            eval.ensurePowerupByDepth = allowPowerupAnywhere ? 0 : EnsurePowerupByDepthTable[level];

            auto remainingTime = timeLimit;
            auto outOfTime = false;

            std::vector<unsigned int> launchPositions;

            if (job.skipToDepth == 0)
            {
                LaunchRange range = job.launchRange;
                if (range.firstPos == 0)
                {
                    range.firstPos = GameConsts::PaddleMin;
                    range.lastPos = GameConsts::PaddleMax;
                }

                for (auto launchPos = range.firstPos; launchPos <= range.lastPos; launchPos += GameConsts::PaddleSpeed)
                {
                    launchPositions.emplace_back(launchPos);
                }
            }
            else
            {
                launchPositions.emplace_back(0);
            }

            for(auto&& launchPos : launchPositions)
            {
                eval.timeLimit = (fullLevelTimeLimit ? remainingTime : timeLimit + excessTime);

                const auto startTime = std::chrono::high_resolution_clock::now();

                if (launchPos == job.launchRange.firstPos || (job.launchRange.firstPos == 0 && launchPos == GameConsts::PaddleMin))
                {
                    Log::Write(L"Level " + std::to_wstring(level) + L" bounce mask " + eval.bounceMask
                               + (eval.enforceTasRefHitProgression ? L" hit prog. " + std::to_wstring(eval.hitProgressionGraceInterval) + L"/" + std::to_wstring(eval.hitProgressionLeadupInterval) : L""));
                }

                unsigned int skipToFrame = 0;

                if (job.skipToDepth == 0)
                {
                    printf("\n\nLaunch Position %d\n\n", launchPos);
                    eval.testSinglePaddlePos = launchPos;
                }
                else
                {
                    const auto inputChain = EvalOp::BizHawkMovieToInputChain(FileUtil::ResultsDir() + L"Input Log_" + std::to_wstring(level) + L".txt");
                    const auto decisionSet = EvalOp::ObserveDecisionPoints(inputChain, level, params[level].startingScore, eval.manipulateEnemies, eval.manipulateEnemyMoves, printDecisionPoints);

                    // Subtract one from the set size since the last entry corresponds to the level end,
                    // making the second-to-last entry the actual last chance.
                    const auto sizeAdjust = (decisionSet.back().first == DecisionPoint::None_LevelEnded ? -1 : 0);

                    auto index = (job.skipToDepth < 0 ? static_cast<int>(decisionSet.size()) + sizeAdjust + job.skipToDepth : job.skipToDepth);
                    if (index < 0)
                    {
                        auto str = "SkipToDepth value " + std::to_string(job.skipToDepth) + " means nothing will be skipped! Reference movie depth "
                                   + std::to_string(decisionSet.size() - 1);
                        str = str + "\r\n -> Exiting early";

                        Log::Write("  " + str);
                        printf("%s\n\n", str.c_str());

                        skipList.emplace(std::make_pair(level, true));
                        break;
                    }
                    else if (index == 0)
                    {
                        const auto str = "SkipToDepth value " + std::to_string(job.skipToDepth) + " means nothing will be skipped! Reference movie depth "
                                         + std::to_string(decisionSet.size() - 1);

                        Log::Write("  " + str);
                        printf("%s\n\n", str.c_str());
                    }
                    else
                    {
                        // Check if the requested depth-skip means that nothing will be evaluated.
                        if (index > decisionSet.size() - 1)
                        {
                            auto str = "SkipToDepth value " + std::to_string(job.skipToDepth) + " exceeds reference movie depth "
                                       + std::to_string(decisionSet.size() - 1) + ", no evaluation to perform!";
                            str = str + "\r\n -> Exiting early";

                            Log::Write("  " + str);
                            printf("%s\n", str.c_str());

                            skipList.emplace(std::make_pair(level, true));
                            break;
                        }

                        skipToFrame = decisionSet[index - 1].second;
                        Log::Write("  Skipping to depth " + std::to_string(index) + ", frame " + std::to_string(skipToFrame)
                                   + " (reference movie completes at depth " + std::to_string(decisionSet.size() - 1)
                                   + ", frame " + std::to_string(decisionSet.back().second) + ")");
                    }
                }

                eval.skipToDepth = job.skipToDepth;
                eval.skipToFrame = skipToFrame;

                SetupAndExecute(eval, level, maxDepth, launchDelayRange, skipToFrame, enableOverrideFrameLimit ? overrideFrameLimit : 0);

                const auto endTime = std::chrono::high_resolution_clock::now();
                const auto onePosDuration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();
                const auto onePosDurationSeconds = std::chrono::duration_cast<std::chrono::seconds>(endTime - startTime).count();

                if (printEachLaunchTime)
                {
                    Log::Write(" Launch pos " + std::to_string(launchPos) + " elapsed time "
                               + std::to_string(onePosDuration / 1000) + "." + std::to_string(onePosDuration % 1000));
                }

                if (fullLevelTimeLimit)
                {
                    remainingTime -= static_cast<int>(onePosDurationSeconds);
                    if (remainingTime <= 0)
                    {
                        const auto iterDuration = std::chrono::duration_cast<std::chrono::seconds>(endTime - iterInitTime).count();

                        printf("Time limit reached, ending early\n");

                        Log::Write(L"  Level " + std::to_wstring(level) + L" bounce mask " + eval.bounceMask
                                   + (eval.enforceTasRefHitProgression ? L" hit prog. " + std::to_wstring(eval.hitProgressionGraceInterval) + L"/" + std::to_wstring(eval.hitProgressionLeadupInterval) : L"")
                                   + L" incomplete after " + std::to_wstring(iterDuration) + L" seconds! "
                                   + L"(Stopped during position " + std::to_wstring(eval.testSinglePaddlePos) + L")");

                        outOfTime = true;

                        if (job.skipToDepth != 0)
                        {
                            skipList.emplace(std::make_pair(level, true));
                        }

                        break;
                    }
                }
                else
                {
                    if (onePosDurationSeconds < eval.timeLimit)
                    {
                        excessTime = eval.timeLimit - static_cast<int>(onePosDurationSeconds);
                        printf("Finished early, transferring %d seconds of extra time\n", excessTime);
                    }
                    else
                    {
                        excessTime = 0;
                    }
                }
            }

            if (!outOfTime)
            {
                const auto iterFinishTime = std::chrono::high_resolution_clock::now();
                const auto iterIntervalMs = std::chrono::duration_cast<std::chrono::milliseconds>(iterFinishTime - iterInitTime);
                timeResults.emplace_back(GenerateTimeEntry(level, eval, iterIntervalMs));
                Log::Write(timeResults.back());
            }
        }
    }

    const auto finishTime = std::chrono::high_resolution_clock::now();
    const auto intervalMs = std::chrono::duration_cast<std::chrono::milliseconds>(finishTime - initTime);

    if (timeResults.size() <= 1)
    {
        printf("Total elapsed time %lld.%lld seconds\n", intervalMs.count() / 1000, intervalMs.count() % 1000);
    }
    else
    {
        Log::Write("");
        printf("\n");
        for (auto&& timeResult : timeResults)
        {
            Log::Write(timeResult);
            wprintf(L"%s\n", timeResult.c_str());
        }
    }

    EvalOp::CombineMovieFiles(params);
    
    return 0;
}