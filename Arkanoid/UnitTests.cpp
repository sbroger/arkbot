#include <UnitTests.h>

#include <Utilities.h>

#include <GameData.h>
#include <GameState.h>
#include <GameConsts.h>
#include <GameOperations.h>

#include <string>
#include <ostream>
#include <fstream>
#include <sstream>
#include <iterator>
#include <map>

namespace
{
    template<class T, class V>
    void TestEqual(const T& expected, const V& actual)
    {
        if (expected != actual)
        {
            printf(("Expected " + std::to_string(expected) + ", got " + std::to_string(actual) + "\n").c_str());
            exit(1);
        }
    }

    template<class T, class V>
    void TestEqual(const T& expected, const V& actual, const std::string& info, const unsigned int frame)
    {
        if (expected != actual)
        {
            printf(("Frame " + std::to_string(frame) + " " + info + ": Expected " + std::to_string(expected) + ", got " + std::to_string(actual) + "\n").c_str());
            exit(1);
        }
    }

    void TestTrue(const bool test)
    {
        if (!test)
        {
            printf("Test evaluated false\n");
            exit(1);
        }
    }

    void TestFalse(const bool test)
    {
        if (test)
        {
            printf("Test evaluated true\n");
            exit(1);
        }
    }

    enum class MemMap
    {
        GameState = 0xa,
        CurrentBlocks = 0xf,
        TitleTimerHi = 0x12,
        TitleTimerLo = 0x13,
        CurrentLevel = 0x1a,
        TotalBlocks = 0x1f,
        BallVelSign = 0x33,
        BallCollisType = 0x34,
        Ball_1_Vel_Y = 0x35,
        Ball_1_Vel_X = 0x36,
        Ball_1_Y = 0x37,
        Ball_1_X = 0x38,
        BallYHiBits = 0x39,
        BallYLoBits = 0x3a,
        BallXHiBits = 0x3b,
        BallXLoBits = 0x3c,
        BallCycle = 0x45,
        BallSpeedMult = 0x46,
        Ball_1_Angle = 0x48,
        BallSpeedStage = 0x49,
        BallSpeedStageM = 0x4a,
        ActiveBalls = 0x81,
        SpawnedPowerup = 0x8c,
        Powerup_Y = 0x91,
        Powerup_X = 0x94,
        EnemyActive = 0x95,
        Enemy2Active = 0x96,
        Enemy3Active = 0x97,
        EnemyDestrFrame = 0x98,
        Enemy2DestrFrame = 0x99,
        Enemy3DestrFrame = 0x9a,
        EnemyExiting = 0x9b,
        Enemy2Exiting = 0x9c,
        Enemy3Exiting = 0x9d,
        EnemyMovementType = 0x9e,
        Enemy2MovementType = 0x9f,
        Enemy3MovementType = 0xa0,
        EnemyCircleStage = 0xa1,
        Enemy2CircleStage = 0xa2,
        Enemy3CircleStage = 0xa3,
        EnemyCircleHalf = 0xa4,
        Enemy2CircleHalf = 0xa5,
        Enemy3CircleHalf = 0xa6,
        EnemyCircleDir = 0xa7,
        Enemy2CircleDir = 0xa8,
        Enemy3CircleDir = 0xa9,
        EnemyDescendTimer = 0xaa,
        Enemy2DescendTimer = 0xab,
        Enemy3DescendTimer = 0xac,
        EnemySpawnIndex = 0xad,
        EnemyY = 0xae,
        Enemy2Y = 0xaf,
        Enemy3Y = 0xb0,
        EnemyX = 0xb7,
        Enemy2X = 0xb8,
        Enemy3X = 0xb9,
        EnemyMoveDir = 0xba,
        Enemy2MoveDir = 0xbb,
        Enemy3MoveDir = 0xbc,
        EnemyMoveTimer = 0xbd,
        Enemy2MoveTimer = 0xbe,
        Enemy3MoveTimer = 0xbf,
        EnemySpawnTimerHi = 0xc0,
        EnemySpawnTimerLo = 0xc1,
        EnemyTwoSpawnTimerHi = 0xc2,
        EnemyTwoSpawnTimerLo = 0xc3,
        EnemyThreeSpawnTimerHi = 0xc4,
        EnemyThreeSpawnTimerLo = 0xc5,
        EnemyAnimTimer = 0xd5,
        Enemy2AnimTimer = 0xd6,
        Enemy3AnimTimer = 0xd7,
        SpeedStage = 0x100,
        SpeedStageM = 0x101,
        SpeedStageCounter = 0x102,
        CeilCollisFlag = 0x104,
        BallSpeedReduction = 0x105,
        BlockCollisSide = 0x107,
        CalculatedCellY = 0x10c,
        CalculatedCellX = 0x10d,
        EnemyGateState = 0x10f,
        EnemyGateIndex = 0x110,
        EnemyGateTimer = 0x111,
        PaddleCollisFlag = 0x112,
        PaddleLeftEdge = 0x11a,
        OwnedPowerup = 0x12d,
        BlockCollisFlag = 0x145,
        HighScoreTopDigit = 0x366,
        HighScoreDigit2 = 0x367,
        HighScoreDigit3 = 0x368,
        HighScoreDigit4 = 0x369,
        HighScoreDigit5 = 0x36a,
        HighScoreDigit6 = 0x36b,
        ScoreTopDigit = 0x370,
        ScoreDigit2 = 0x371,
        ScoreDigit3 = 0x372,
        ScoreDigit4 = 0x373,
        ScoreDigit5 = 0x374,
        ScoreDigit6 = 0x375,
        PendingScoreTopDigit = 0x37c,
        PendingScoreDigit2 = 0x37d,
        PendingScoreDigit3 = 0x37e,
        PendingScoreDigit4 = 0x37f,
        PendingScoreDigit5 = 0x380,
        PendingScoreDigit6 = 0x381,
        LastBlockHit_YInd = 0x680,
        LastBlockHit_XInd = 0x681,
        LastBlockHit_Val = 0x682,
        LastBlockHit2_YInd = 0x683,
        LastBlockHit2_XInd = 0x684,
        LastBlockHit2_Val = 0x685,
        LastBlockHit3_YInd = 0x686,
        LastBlockHit3_XInd = 0x687,
        LastBlockHit3_Val = 0x688,
        LastBlockDestr_Val = 0x69a,
        LastBlockDestr2_Val = 0x69d,
        LastBlockDestr3_Val = 0x6a0
    };

    void LoadStateFrom(const std::string& data, GameState& state)
    {
        std::stringstream ss(data);
        std::istream_iterator<std::string> begin(ss);
        std::istream_iterator<std::string> end;
        std::vector<std::string> strValues(begin, end);

        std::map<MemMap, unsigned int> values;

        int idx = 0;
        for (auto&& str : strValues)
        {
            values.emplace(std::make_pair(static_cast<MemMap>(idx++), std::stoi(str)));
        }

        state.opState = static_cast<OperationalState>(values[MemMap::GameState]);
        state.ceilCollis = values[MemMap::CeilCollisFlag];

        auto offset = 0;
        for (auto&& ball : state.ball)
        {
            ball.angle = static_cast<Angle>(values[static_cast<MemMap>(static_cast<int>(MemMap::Ball_1_Angle) + offset)]);
            ball.xCollis = (values[static_cast<MemMap>(static_cast<int>(MemMap::BallCollisType) + offset)] & 0x2) > 0;
            ball.yCollis = (values[static_cast<MemMap>(static_cast<int>(MemMap::BallCollisType) + offset)] & 0x1) > 0;
            ball.cycle = values[static_cast<MemMap>(static_cast<int>(MemMap::BallCycle) + offset)];
            ball.pos.x = values[static_cast<MemMap>(static_cast<int>(MemMap::Ball_1_X) + offset)];
            ball.pos.y = values[static_cast<MemMap>(static_cast<int>(MemMap::Ball_1_Y) + offset)];
            ball.vel.vx = values[static_cast<MemMap>(static_cast<int>(MemMap::Ball_1_Vel_X) + offset)];
            ball.vel.vy = values[static_cast<MemMap>(static_cast<int>(MemMap::Ball_1_Vel_Y) + offset)];
            ball.speedMult = values[static_cast<MemMap>(static_cast<int>(MemMap::BallSpeedMult) + offset)];
            ball.speedStage = values[static_cast<MemMap>(static_cast<int>(MemMap::BallSpeedStage) + offset)];
            ball.speedStageM = values[static_cast<MemMap>(static_cast<int>(MemMap::BallSpeedStageM) + offset)];

            offset += 0x1a;
        }

        state.ball[0].exists = (values[MemMap::ActiveBalls] & 0x1) > 0;
        state.ball[1].exists = (values[MemMap::ActiveBalls] & 0x2) > 0;
        state.ball[2].exists = (values[MemMap::ActiveBalls] & 0x4) > 0;

        state.blockCollisCount = values[MemMap::BlockCollisFlag];
        state.blockCollisSide.oneDownRight = (values[MemMap::BlockCollisSide] & 0x1) != 0;
        state.blockCollisSide.oneDown = (values[MemMap::BlockCollisSide] & 0x2) != 0;
        state.blockCollisSide.oneRight = (values[MemMap::BlockCollisSide] & 0x4) != 0;
        state.blockCollisSide.thisBlock = (values[MemMap::BlockCollisSide] & 0x8) != 0;
        state.calculatedCell.x = values[MemMap::CalculatedCellX];
        state.calculatedCell.y = values[MemMap::CalculatedCellY];
        state.currentBlocks = values[MemMap::CurrentBlocks];

        offset = 0;
        for (auto&& enemy : state.enemies)
        {
            enemy.active = (values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyActive) + offset)] > 0);
            enemy.exiting = (values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyExiting) + offset)] > 0);
            enemy.destrFrame = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyDestrFrame) + offset)];
            enemy.pos.x = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyX) + offset)];
            enemy.pos.y = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyY) + offset)];
            enemy.moveTimer = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyMoveTimer) + offset)];
            enemy.movementType = static_cast<MovementType>(values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyMovementType) + offset)]);
            enemy.moveDir = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyMoveDir) + offset)];
            enemy.descentTimer = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyDescendTimer) + offset)];
            enemy.animTimer = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyAnimTimer) + offset)];
            enemy.circleStage = values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyCircleStage) + offset)];
            enemy.circleHalf = static_cast<CircleHalf>(values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyCircleHalf) + offset)]);
            enemy.circleDir = static_cast<CircleDir>(values[static_cast<MemMap>(static_cast<int>(MemMap::EnemyCircleDir) + offset)]);

            offset++;
        }

        state.enemyGateState = values[MemMap::EnemyGateState];
        state.enemyGateIndex = values[MemMap::EnemyGateIndex];
        state.enemyGateTimer = values[MemMap::EnemyGateTimer];

        offset = 0;
        for (auto&& timer : state.enemySpawnTimers)
        {
            timer = (values[static_cast<MemMap>(static_cast<int>(MemMap::EnemySpawnTimerHi) + offset)] << 8)
                     + values[static_cast<MemMap>(static_cast<int>(MemMap::EnemySpawnTimerLo) + offset)];

            offset += 2;
        }

        for (int i = 0; i < 3; i++)
        {
            state.justHitBlock[i] = Block(values[static_cast<MemMap>(static_cast<int>(MemMap::LastBlockHit_Val) + i * 3)]);
            state.justHitBlockCell[i].x = values[static_cast<MemMap>(static_cast<int>(MemMap::LastBlockHit_XInd) + i * 3)];
            state.justHitBlockCell[i].y = values[static_cast<MemMap>(static_cast<int>(MemMap::LastBlockHit_YInd) + i * 3)];
            state.justDestrBlock[i] = (values[static_cast<MemMap>(static_cast<int>(MemMap::LastBlockDestr_Val) + i * 3)] > 0);
        }

        state.level = values[MemMap::CurrentLevel];
        state.ownedPowerup = static_cast<Powerup>(values[MemMap::OwnedPowerup]);
        state.paddleCollis = values[MemMap::PaddleCollisFlag];
        state.paddleX = values[MemMap::PaddleLeftEdge];

        state.pendingScore = values[MemMap::PendingScoreTopDigit] * 100000
                             + values[MemMap::PendingScoreDigit2] * 10000
                             + values[MemMap::PendingScoreDigit3] * 1000
                             + values[MemMap::PendingScoreDigit4] * 100
                             + values[MemMap::PendingScoreDigit5] * 10
                             + values[MemMap::PendingScoreDigit6];

        state.powerupPos.x = values[MemMap::Powerup_X];
        state.powerupPos.y = values[MemMap::Powerup_Y];

        state.score = values[MemMap::ScoreTopDigit] * 100000
                      + values[MemMap::ScoreDigit2] * 10000
                      + values[MemMap::ScoreDigit3] * 1000
                      + values[MemMap::ScoreDigit4] * 100
                      + values[MemMap::ScoreDigit5] * 10
                      + values[MemMap::ScoreDigit6];

        state.spawnedPowerup = static_cast<Powerup>(values[MemMap::SpawnedPowerup]);
        state.speedReduction = values[MemMap::BallSpeedReduction];
        state.overallSpeedStage = values[MemMap::SpeedStage];
        state.overallSpeedStageM = values[MemMap::SpeedStageM];
        state.speedStageCounter = values[MemMap::SpeedStageCounter];
        state.totalBlocks = values[MemMap::TotalBlocks];
    }

    void CompareStates(const GameState& expectedState, const GameState& simulatedState, const unsigned int frame)
    {
        TestEqual(static_cast<int>(expectedState.opState), static_cast<int>(simulatedState.opState), "Game state mismatch", frame);
        TestEqual(expectedState.blockCollisCount, simulatedState.blockCollisCount, "Block collis count mismatch", frame);

        TestEqual(expectedState.calculatedCell.x, simulatedState.calculatedCell.x, "Calculated cell x mismatch", frame);
        TestEqual(expectedState.calculatedCell.y, simulatedState.calculatedCell.y, "Calculated cell y mismatch", frame);

        for (int i = 0; i < 3; i++)
        {
            TestEqual(expectedState.ball[i].exists, simulatedState.ball[i].exists, "Ball " + std::to_string(i + 1) + " existence mismatch", frame);
            TestEqual(static_cast<int>(expectedState.ball[i].angle), static_cast<int>(simulatedState.ball[i].angle), "Ball " + std::to_string(i + 1) + " angle mismatch", frame);
            TestEqual(expectedState.ball[i].xCollis, simulatedState.ball[i].xCollis, "Ball " + std::to_string(i + 1) + " x-collision mismatch", frame);
            TestEqual(expectedState.ball[i].yCollis, simulatedState.ball[i].yCollis, "Ball " + std::to_string(i + 1) + " y-collision mismatch", frame);
            TestEqual(expectedState.ball[i].cycle, simulatedState.ball[i].cycle, "Ball " + std::to_string(i + 1) + " cycle mismatch", frame);
            TestEqual(expectedState.ball[i].pos.x, simulatedState.ball[i].pos.x, "Ball " + std::to_string(i + 1) + " x-pos mismatch", frame);
            TestEqual(expectedState.ball[i].pos.y, simulatedState.ball[i].pos.y, "Ball " + std::to_string(i + 1) + " y-pos mismatch", frame);
            TestEqual(expectedState.ball[i].speedStage, simulatedState.ball[i].speedStage, "Ball " + std::to_string(i + 1) + " speed stage mismatch", frame);
            TestEqual(expectedState.ball[i].speedStageM, simulatedState.ball[i].speedStageM, "Ball " + std::to_string(i + 1) + " speed stage mirror mismatch", frame);
            TestEqual(expectedState.ball[i].speedMult, simulatedState.ball[i].speedMult, "Ball " + std::to_string(i + 1) + " speed multiplier mismatch", frame);
        }

        // Note that these values are shared by all three balls, and as such
        // only contain the values used for the final ball update of the frame.
        TestEqual(expectedState.blockCollisSide.thisBlock, simulatedState.blockCollisSide.thisBlock, "Block collis side this-block mismatch", frame);
        TestEqual(expectedState.blockCollisSide.oneDown, simulatedState.blockCollisSide.oneDown, "Block collis side one-down mismatch", frame);
        TestEqual(expectedState.blockCollisSide.oneRight, simulatedState.blockCollisSide.oneRight, "Block collis side one-right mismatch", frame);
        TestEqual(expectedState.blockCollisSide.oneDownRight, simulatedState.blockCollisSide.oneDownRight, "Block collis side one-down-right mismatch", frame);

        TestEqual(expectedState.currentBlocks, simulatedState.currentBlocks, "Current blocks mismatch", frame);

        if (_SimulateEnemies(simulatedState))
        {
            for (int i = 0; i < 3; i++)
            {
                TestEqual(expectedState.enemies[i].active, simulatedState.enemies[i].active, "Enemy " + std::to_string(i + 1) + " existence mismatch", frame);
                TestEqual(expectedState.enemies[i].destrFrame, simulatedState.enemies[i].destrFrame, "Enemy " + std::to_string(i + 1) + " destruction frame mismatch", frame);
                TestEqual(expectedState.enemies[i].exiting, simulatedState.enemies[i].exiting, "Enemy " + std::to_string(i + 1) + " exit flag mismatch", frame);
                TestEqual(expectedState.enemies[i].moveTimer, simulatedState.enemies[i].moveTimer, "Enemy " + std::to_string(i + 1) + " move timer mismatch", frame);
                TestEqual(expectedState.enemies[i].moveDir, simulatedState.enemies[i].moveDir, "Enemy " + std::to_string(i + 1) + " move direction mismatch", frame);
                TestEqual(static_cast<int>(expectedState.enemies[i].movementType), static_cast<int>(simulatedState.enemies[i].movementType), "Enemy " + std::to_string(i + 1) + " movement type mismatch", frame);
                TestEqual(expectedState.enemies[i].descentTimer, simulatedState.enemies[i].descentTimer, "Enemy " + std::to_string(i + 1) + " descent timer mismatch", frame);
                TestEqual(expectedState.enemies[i].animTimer, simulatedState.enemies[i].animTimer, "Enemy " + std::to_string(i + 1) + " animation timer mismatch", frame);
                TestEqual(expectedState.enemies[i].circleStage, simulatedState.enemies[i].circleStage, "Enemy " + std::to_string(i + 1) + " circle stage mismatch", frame);
                TestEqual(static_cast<int>(expectedState.enemies[i].circleHalf), static_cast<int>(simulatedState.enemies[i].circleHalf), "Enemy " + std::to_string(i + 1) + " circle half mismatch", frame);
                TestEqual(static_cast<int>(expectedState.enemies[i].circleDir), static_cast<int>(simulatedState.enemies[i].circleDir), "Enemy " + std::to_string(i + 1) + " circle dir mismatch", frame);
                TestEqual(expectedState.enemies[i].pos.x, simulatedState.enemies[i].pos.x, "Enemy " + std::to_string(i + 1) + " x-position mismatch", frame);
                TestEqual(expectedState.enemies[i].pos.y, simulatedState.enemies[i].pos.y, "Enemy " + std::to_string(i + 1) + " y-position mismatch", frame);
            }

            TestEqual(expectedState.enemyGateState, simulatedState.enemyGateState, "Enemy gate state mismatch", frame);
            TestEqual(expectedState.enemyGateIndex, simulatedState.enemyGateIndex, "Enemy gate index mismatch", frame);
            TestEqual(expectedState.enemyGateTimer, simulatedState.enemyGateTimer, "Enemy gate timer mismatch", frame);

            for (int i = 0; i < 3; i++)
            {
                TestEqual(expectedState.enemySpawnTimers[i], simulatedState.enemySpawnTimers[i], "Enemy spawn timer " + std::to_string(i + 1) + " mismatch", frame);
            }
        }

        TestEqual(BlkHits(expectedState.justHitBlock[0]), BlkHits(simulatedState.justHitBlock[0]), "Just-hit block 1 hit mismatch", frame);
        TestEqual(BlkPowerup(expectedState.justHitBlock[0]), BlkPowerup(simulatedState.justHitBlock[0]), "Just-hit block 1 powerup mismatch", frame);
        TestEqual(expectedState.justHitBlockCell[0].y, simulatedState.justHitBlockCell[0].y, "Just-hit block 1 cell y mismatch", frame);
        TestEqual(expectedState.justHitBlockCell[0].x, simulatedState.justHitBlockCell[0].x, "Just-hit block 1 cell x mismatch", frame);
        TestEqual(static_cast<int>(BlkType(expectedState.justHitBlock[0])), static_cast<int>(BlkType(simulatedState.justHitBlock[0])), "Just-hit block 1 type mismatch", frame);
        TestEqual(expectedState.justDestrBlock[0], simulatedState.justDestrBlock[0], "Just-destroyed block 1 flag mismatch", frame);
        TestEqual(BlkHits(expectedState.justHitBlock[1]), BlkHits(simulatedState.justHitBlock[1]), "Just-hit block 2 hit mismatch", frame);
        TestEqual(BlkPowerup(expectedState.justHitBlock[1]), BlkPowerup(simulatedState.justHitBlock[1]), "Just-hit block 2 powerup mismatch", frame);
        TestEqual(static_cast<int>(BlkType(expectedState.justHitBlock[1])), static_cast<int>(BlkType(simulatedState.justHitBlock[1])), "Just-hit block 2 type mismatch", frame);
        TestEqual(expectedState.justHitBlockCell[1].x, simulatedState.justHitBlockCell[1].x, "Just-hit block 2 cell x mismatch", frame);
        TestEqual(expectedState.justHitBlockCell[1].y, simulatedState.justHitBlockCell[1].y, "Just-hit block 2 cell y mismatch", frame);
        TestEqual(expectedState.justDestrBlock[1], simulatedState.justDestrBlock[1], "Just-destroyed block 2 flag mismatch", frame);
        TestEqual(BlkHits(expectedState.justHitBlock[2]), BlkHits(simulatedState.justHitBlock[2]), "Just-hit block 3 hit mismatch", frame);
        TestEqual(BlkPowerup(expectedState.justHitBlock[2]), BlkPowerup(simulatedState.justHitBlock[2]), "Just-hit block 3 powerup mismatch", frame);
        TestEqual(static_cast<int>(BlkType(expectedState.justHitBlock[2])), static_cast<int>(BlkType(simulatedState.justHitBlock[2])), "Just-hit block 3 type mismatch", frame);
        TestEqual(expectedState.justHitBlockCell[2].x, simulatedState.justHitBlockCell[2].x, "Just-hit block 3 cell x mismatch", frame);
        TestEqual(expectedState.justHitBlockCell[2].y, simulatedState.justHitBlockCell[2].y, "Just-hit block 3 cell y mismatch", frame);
        TestEqual(expectedState.justDestrBlock[2], simulatedState.justDestrBlock[2], "Just-destroyed block 3 flag mismatch", frame);
        TestEqual(expectedState.level, simulatedState.level, "Level mismatch", frame);
        TestEqual(static_cast<int>(expectedState.ownedPowerup), static_cast<int>(simulatedState.ownedPowerup), "Owned powerup mismatch", frame);
        TestEqual(expectedState.paddleCollis, simulatedState.paddleCollis, "Paddle collis flag mismatch", frame);
        TestEqual(expectedState.paddleX, simulatedState.paddleX, "Paddle x mismatch", frame);
        TestEqual(expectedState.pendingScore, simulatedState.pendingScore, "Pending score mismatch", frame);
        TestEqual(expectedState.powerupPos.x, simulatedState.powerupPos.x, "Powerup x mismatch", frame);
        TestEqual(expectedState.powerupPos.y, simulatedState.powerupPos.y, "Powerup x mismatch", frame);
        TestEqual(expectedState.score, simulatedState.score, "Score mismatch", frame);
        TestEqual(static_cast<int>(expectedState.spawnedPowerup), static_cast<int>(simulatedState.spawnedPowerup), "Spawned powerup mismatch", frame);
        if (_Pedantic) TestEqual(expectedState.speedReduction, simulatedState.speedReduction, "Speed reduction mismatch", frame);
        TestEqual(expectedState.overallSpeedStage, simulatedState.overallSpeedStage, "Overall speed stage mismatch", frame);
        TestEqual(expectedState.overallSpeedStageM, simulatedState.overallSpeedStageM, "Overall speed stage mirror mismatch", frame);
        TestEqual(expectedState.speedStageCounter, simulatedState.speedStageCounter, "Speed stage counter mismatch", frame);
        TestEqual(expectedState.totalBlocks, simulatedState.totalBlocks, "Total blocks mismatch", frame);
    }

    void TestOneFrame(GameState& state, const std::string& data, const unsigned int frame)
    {
        GameState expectedState;
        LoadStateFrom(data, expectedState);

        CompareStates(expectedState, state, frame);
    }

    void TestFullGameSim()
    {
        GameState state;
        GameOp::Init(state);

        const auto movieLen = 48000;

        std::vector<int> startFrames = {
            568, 2072, 3450, 4450, 5579, 7188, 8104, 9208,
            9753, 10677, 11784, 13769, 14773, 15562, 16677, 18723,
            19678, 20804, 21773, 22790, 23641, 24386, 25322, 26923,
            28211, 29701, 30729, 32612, 33835, 35771, 37508, 38871,
            39984, 41718, 42962
        };
        std::vector<int> endFrames = {
            1774, 3152, 4152, 5281, 6890, 7806, 8910, 9455,
            10379, 11486, 13471, 14475, 15264, 16379, 18425, 19380,
            20506, 21475, 22492, 23343, 24088, 25024, 26625, 27913,
            29403, 30431, 32314, 33537, 35473, 37210, 38573, 39686,
            41420, 42664, 43779
        };

        std::vector<Input> inputs;
        inputs.reserve(movieLen);

        const auto inputPath = FileUtil::UnitTestDir() + L"TestInput.txt";
        if (!std::filesystem::exists(inputPath))
        {
            wprintf(L"\nError: Couldn't find unit test input file %s.\n", inputPath.c_str());
            exit(1);
        }

        std::ifstream inputFile(inputPath);
        std::string inputLine;

        inputs.emplace_back(Input());
        for (int i = 1; i <= movieLen; i++)
        {
            if (std::getline(inputFile, inputLine))
            {
                inputs.emplace_back(Input());
                if (inputLine.find('S') != std::string::npos) inputs.back() |= StartInput;
                if (inputLine.find('s') != std::string::npos) inputs.back() |= SelectInput;
                if (inputLine.find('A') != std::string::npos) inputs.back() |= AInput;
                if (inputLine.find('L') != std::string::npos) inputs.back() |= LeftInput;
                if (inputLine.find('R') != std::string::npos) inputs.back() |= RightInput;
            }
        }

        const auto dataPath = FileUtil::UnitTestDir() + L"TestData.txt";
        std::ifstream dataFile(dataPath);
        if (!std::filesystem::exists(dataPath))
        {
            wprintf(L"\nError: Couldn't find unit test input file %s.\n", dataPath.c_str());
            exit(1);
        }

        std::string dataLine;

        // TODO better method for this?
        for (auto i = 0; i < startFrames[0]; i++) std::getline(dataFile, dataLine);

        auto frame = startFrames[0];

        const int skipToFrame = -1;

        for (auto i = 0; i < startFrames.size(); i++)
        {
            if (i != 0) printf("-----");

            while (frame < startFrames[i] && std::getline(dataFile, dataLine))
            {
                frame++;
            }

            GameOp::AdvanceToLevel(state, i + 1);

            while (frame <= endFrames[i] && frame < inputs.size() && std::getline(dataFile, dataLine))
            {
                if (frame == startFrames[i]) printf("\n%d\n", frame);
                else if (frame % 10 == 0 && frame != 0) printf("%d\n", frame);

                GameOp::ExecuteInput(state, inputs[frame]);
                state._frame = frame;

                if (frame >= skipToFrame)
                {
                    TestOneFrame(state, dataLine, frame);
                }

                frame++;
            }
        }
    }


    void TestSingleLevelSpecial(const unsigned int level)
    {
        GameState state;
        GameOp::Init(state);

        const auto movieLen = 450;

        std::vector<Input> inputs;
        inputs.reserve(movieLen);

        auto inputFilename = FileUtil::UnitTestDir() + L"TestInputLevel" + std::to_wstring(level) + L"Special.txt";
        std::ifstream inputFile(inputFilename);
        std::string inputLine;

        inputs.emplace_back(Input());
        for (int i = 1; i <= movieLen; i++)
        {
            if (std::getline(inputFile, inputLine))
            {
                inputs.emplace_back(Input());
                if (inputLine.find('S') != std::string::npos) inputs.back() |= StartInput;
                if (inputLine.find('s') != std::string::npos) inputs.back() |= SelectInput;
                if (inputLine.find('A') != std::string::npos) inputs.back() |= AInput;
                if (inputLine.find('L') != std::string::npos) inputs.back() |= LeftInput;
                if (inputLine.find('R') != std::string::npos) inputs.back() |= RightInput;
            }
        }

        auto dataFilename = FileUtil::UnitTestDir() + L"TestDataLevel" + std::to_wstring(level) + L"Special.txt";
        std::ifstream dataFile(dataFilename);
        std::string dataLine;
        std::getline(dataFile, dataLine);

        auto frame = 1;

        const int skipToFrame = 148;

        GameOp::AdvanceToLevel(state, level);
        state.score = 67620;
        printf("\n");

        while (frame <= movieLen && frame < inputs.size() && std::getline(dataFile, dataLine))
        {
            if (frame % 10 == 0 && frame != 0) printf("%d\n", frame);

            GameOp::ExecuteInput(state, inputs[frame]);
            state._frame = frame;

            if (frame >= skipToFrame)
            {
                TestOneFrame(state, dataLine, frame);
            }

            frame++;
        }
    }

    void TestMathUtilClamp()
    {
        auto val = 1;
        auto delta = MathUtil::Clamp(val, 0, 2);
        TestEqual(0, delta);
        TestEqual(1, val);

        val = -7;
        delta = MathUtil::Clamp(val, 0, 2);
        TestEqual(7, delta);
        TestEqual(0, val);

        val = 10;
        delta = MathUtil::Clamp(val, 0, 2);
        TestEqual(-8, delta);
        TestEqual(2, val);
    }

    void TestMathUtilPointInRect()
    {
        TestEqual(false, MathUtil::PointInRect(-2, -2, -1, -1, 2, 2));
        TestEqual(true, MathUtil::PointInRect(-1, -1, -1, -1, 2, 2));
        TestEqual(true, MathUtil::PointInRect(0, 0, -1, -1, 2, 2));
        TestEqual(true, MathUtil::PointInRect(1, 1, -1, -1, 2, 2));
        TestEqual(false, MathUtil::PointInRect(2, 2, -1, -1, 2, 2));
    }

    void TestAdc()
    {
        auto accum = 0;
        auto carry = 0;

        const auto adc = [&accum, &carry](unsigned int val) {
            accum += val + carry;
            carry = (accum > 0xff);
            accum &= 0xff;
        };

        // Test 0 + 0
        accum = 0;
        carry = 0;
        adc(0);
        TestEqual(0, accum);
        TestEqual(0, carry);

        // Test 0 + 1
        adc(1);
        TestEqual(1, accum);
        TestEqual(0, carry);

        // Test 1 + 0xfe
        adc(0xfe);
        TestEqual(0xff, accum);
        TestEqual(0, carry);

        // Test 0xff + 1
        adc(1);
        TestEqual(0, accum);
        TestEqual(1, carry);

        // Test 0 + 0 with carry -> 1
        adc(0);
        TestEqual(1, accum);
        TestEqual(0, carry);

        // Test 0xff + 1 with carry -> 1
        carry = 1;
        accum = 0xff;
        adc(1);
        TestEqual(1, accum);
        TestEqual(1, carry);

        // TODO
        /*const auto rol = [&rng, &carry] {
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
        };*/
    }

    void TestPaddleMoveNoLaunch()
    {
        GameState state;
        GameOp::Init(state);

        TestEqual(88u, state.paddleX);
        TestEqual(104u, state.ball[0].pos.x);
        TestEqual(204u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, LeftInput);

        TestEqual(85u, state.paddleX);
        TestEqual(101u, state.ball[0].pos.x);

        for (int i = 0; i < 30; i++)
        {
            GameOp::ExecuteInput(state, LeftInput);
        }

        TestEqual(16u, state.paddleX);
        TestEqual(32u, state.ball[0].pos.x);

        for (int i = 0; i < 90; i++)
        {
            GameOp::ExecuteInput(state, RightInput);
        }

        TestEqual(160u, state.paddleX);
        TestEqual(176u, state.ball[0].pos.x);
    }

    void TestBallLaunch()
    {
        GameState state;
        GameOp::Init(state);

        GameOp::ExecuteInput(state, AInput);

        TestTrue(state.ball[0].exists);
        TestTrue(state.ball[0].angle == Angle::Steep);
        TestEqual(3u, state.ball[0].cycle);
        TestEqual(105u, state.ball[0].pos.x);
        TestEqual(202u, state.ball[0].pos.y);
    }

    void TestBallInitTrajectory()
    {
        GameState state;
        GameOp::Init(state);

        GameOp::ExecuteInput(state, AInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(105u, state.ball[0].pos.x);
        TestEqual(202u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(2u, state.ball[0].cycle);
        TestEqual(106u, state.ball[0].pos.x);
        TestEqual(200u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(1u, state.ball[0].cycle);
        TestEqual(107u, state.ball[0].pos.x);
        TestEqual(197u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(0u, state.ball[0].cycle);
        TestEqual(109u, state.ball[0].pos.x);
        TestEqual(194u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(110u, state.ball[0].pos.x);
        TestEqual(192u, state.ball[0].pos.y);
    }

    void TestBallRightWallBounce()
    {
        GameState state;
        GameOp::Init(state);

        for (int i = 0; i < 24; i++)
        {
            GameOp::ExecuteInput(state, RightInput);
        }

        GameOp::ExecuteInput(state, AInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(177u, state.ball[0].pos.x);
        TestEqual(202u, state.ball[0].pos.y);

        for (int i = 0; i < 8; i++)
        {
            GameOp::ExecuteInput(state, NoInput);
        }

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(187u, state.ball[0].pos.x);
        TestEqual(182u, state.ball[0].pos.y);

        // The ball collides with the wall on this frame...
        GameOp::ExecuteInput(state, NoInput);

        TestEqual(0u, state.ball[0].cycle);
        TestEqual(188u, state.ball[0].pos.x);
        TestEqual(180u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(187u, state.ball[0].pos.x);
        TestEqual(178u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(2u, state.ball[0].cycle);
        TestEqual(186u, state.ball[0].pos.x);
        TestEqual(176u, state.ball[0].pos.y);
    }

    // Same as TestBallRightWallBounce, with a different cycle.
    void TestBallRightWallBounceOneSpaceAway()
    {
        GameState state;
        GameOp::Init(state);

        // Move one space away from the right wall.
        for (int i = 0; i < 23; i++)
        {
            GameOp::ExecuteInput(state, RightInput);
        }

        GameOp::ExecuteInput(state, AInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(174u, state.ball[0].pos.x);
        TestEqual(202u, state.ball[0].pos.y);

        for (int i = 0; i < 10; i++)
        {
            GameOp::ExecuteInput(state, NoInput);
        }

        TestEqual(1u, state.ball[0].cycle);
        TestEqual(186u, state.ball[0].pos.x);
        TestEqual(177u, state.ball[0].pos.y);

        // The ball collides with the wall on this frame...
        GameOp::ExecuteInput(state, NoInput);

        TestEqual(0u, state.ball[0].cycle);
        TestEqual(188u, state.ball[0].pos.x);
        TestEqual(174u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(187u, state.ball[0].pos.x);
        TestEqual(172u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(2u, state.ball[0].cycle);
        TestEqual(186u, state.ball[0].pos.x);
        TestEqual(170u, state.ball[0].pos.y);
    }

    // Same as TestBallRightWallBounce, with a different cycle.
    void TestBallRightWallBounceThreeSpacesAway()
    {
        GameState state;
        GameOp::Init(state);

        // Move one space away from the right wall.
        for (int i = 0; i < 21; i++)
        {
            GameOp::ExecuteInput(state, RightInput);
        }

        GameOp::ExecuteInput(state, AInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(168u, state.ball[0].pos.x);
        TestEqual(202u, state.ball[0].pos.y);

        for (int i = 0; i < 16; i++)
        {
            GameOp::ExecuteInput(state, NoInput);
        }

        TestEqual(0u, state.ball[0].cycle);
        TestEqual(187u, state.ball[0].pos.x);
        TestEqual(164u, state.ball[0].pos.y);

        // The ball collides with the wall on this frame...
        GameOp::ExecuteInput(state, NoInput);

        TestEqual(0u, state.ball[0].cycle); // Note that the cycle remains at 0.
        TestEqual(188u, state.ball[0].pos.x);
        TestEqual(162u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(187u, state.ball[0].pos.x);
        TestEqual(160u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(2u, state.ball[0].cycle);
        TestEqual(186u, state.ball[0].pos.x);
        TestEqual(158u, state.ball[0].pos.y);
    }

    void TestPaddleBounceRightSide()
    {
        GameState state;
        GameOp::Init(state);

        for (int i = 0; i < 8; i++)
        {
            GameOp::ExecuteInput(state, RightInput);
        }

        GameOp::ExecuteInput(state, AInput);

        for (int i = 0; i < 42; i++)
        {
            GameOp::ExecuteInput(state, NoInput);
        }

        // The ball is about to hit a block and then the wall; sanity-check some values.
        TestEqual(181u, state.ball[0].pos.x);
        GameOp::ExecuteInput(state, NoInput);
        TestEqual(94u, state.ball[0].pos.y);
        GameOp::ExecuteInput(state, NoInput);
        TestEqual(65u, state.currentBlocks);

        // The ball hits the wall here...
        GameOp::ExecuteInput(state, NoInput);
        GameOp::ExecuteInput(state, NoInput);
        GameOp::ExecuteInput(state, NoInput);
        GameOp::ExecuteInput(state, NoInput);
        TestEqual(187u, state.ball[0].pos.x);
        TestEqual(106u, state.ball[0].pos.y);

        // The ball hits the paddle here...
        for (int i = 0; i < 39; i++)
        {
            GameOp::ExecuteInput(state, NoInput);
        }

        TestEqual(138u, state.ball[0].pos.x);
        TestEqual(204u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(140u, state.ball[0].pos.x);
        TestEqual(202u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(142u, state.ball[0].pos.x);
        TestEqual(200u, state.ball[0].pos.y);
    }

    void TestBallPaddleBounceRightCorner()
    {
        GameState state;
        GameOp::Init(state);

        GameOp::ExecuteInput(state, AInput);
        GameOp::ExecuteInput(state, RightInput, 14);
        GameOp::ExecuteInput(state, NoInput, 73);

        TestEqual(163u, state.ball[0].pos.x);
        TestEqual(204u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(3u, state.ball[0].cycle);
        TestEqual(162u, state.ball[0].pos.x);
        TestEqual(206u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(0u, state.ball[0].cycle);
        TestEqual(161u, state.ball[0].pos.x);
        TestEqual(208u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(3u, state.ball[0].cycle);
        TestEqual(165u, state.ball[0].pos.x);
        TestEqual(206u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(2u, state.ball[0].cycle);
        TestEqual(169u, state.ball[0].pos.x);
        TestEqual(204u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(1u, state.ball[0].cycle);
        TestEqual(172u, state.ball[0].pos.x);
        TestEqual(203u, state.ball[0].pos.y);
    }

    void TestBallShoveBounce()
    {
        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 14);
            GameOp::ExecuteInput(state, NoInput, 72);

            // This moves the paddle a frame before it'd count as a bounce,
            // i.e. this should be identical to moving the paddle beforehand.
            GameOp::ExecuteInput(state, RightInput);
            TestEqual(163u, state.ball[0].pos.x);
            TestEqual(204u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(165u, state.ball[0].pos.x);
            TestEqual(203u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(167u, state.ball[0].pos.x);
            TestEqual(202u, state.ball[0].pos.y);
        }

        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 14);
            GameOp::ExecuteInput(state, NoInput, 73);

            // Shove the ball on the first frame possible.
            GameOp::ExecuteInput(state, RightInput);
            TestEqual(0u, state.ball[0].cycle);
            TestEqual(162u, state.ball[0].pos.x);
            TestEqual(206u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(3u, state.ball[0].cycle);
            TestEqual(166u, state.ball[0].pos.x);
            TestEqual(204u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(2u, state.ball[0].cycle);
            TestEqual(0xa8u, state.ball[0].pos.x); // 168u
            TestEqual(203u, state.ball[0].pos.y);
        }

        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 14);
            GameOp::ExecuteInput(state, NoInput, 74);

            // Shove the ball on the second frame possible.
            GameOp::ExecuteInput(state, RightInput);
            TestEqual(161u, state.ball[0].pos.x);
            TestEqual(208u, state.ball[0].pos.y);

            // This should send the ball on a 45-degree trajectory.
            GameOp::ExecuteInput(state, NoInput);
            TestEqual(165u, state.ball[0].pos.x);
            TestEqual(204u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(167u, state.ball[0].pos.x);
            TestEqual(202u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(169u, state.ball[0].pos.x);
            TestEqual(200u, state.ball[0].pos.y);
        }

        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 14);
            GameOp::ExecuteInput(state, NoInput, 75);

            // This moves the paddle one frame too late, so it should be equivalent to the ball
            // bouncing off the side on its own.
            GameOp::ExecuteInput(state, RightInput);
            TestEqual(165u, state.ball[0].pos.x);
            TestEqual(206u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(169u, state.ball[0].pos.x);
            TestEqual(204u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(172u, state.ball[0].pos.x);
            TestEqual(203u, state.ball[0].pos.y);
        }
    }

    void TestBallBounceNearEdge()
    {
        GameState state;
        GameOp::Init(state);

        GameOp::ExecuteInput(state, LeftInput, 8);
        GameOp::ExecuteInput(state, AInput);
        GameOp::ExecuteInput(state, RightInput, 30);
        GameOp::ExecuteInput(state, NoInput, 58);

        TestEqual(186u, state.ball[0].pos.x);
        TestEqual(205u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(185u, state.ball[0].pos.x);
        TestEqual(208u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(188u, state.ball[0].pos.x);
        TestEqual(206u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);
        TestEqual(184u, state.ball[0].pos.x);
        TestEqual(204u, state.ball[0].pos.y);
    }

    void TestBallShoveNearEdge()
    {
        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, LeftInput, 8);
            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 30);
            GameOp::ExecuteInput(state, NoInput, 57);

            TestEqual(187u, state.ball[0].pos.x);
            TestEqual(203u, state.ball[0].pos.y);

            // This triggers a top-side bounce on the frame the paddle moves, which has special behavior.
            GameOp::ExecuteInput(state, RightInput);
            TestEqual(186u, state.ball[0].pos.x);
            TestEqual(205u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(188u, state.ball[0].pos.x);
            TestEqual(204u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(186u, state.ball[0].pos.x);
            TestEqual(203u, state.ball[0].pos.y);
        }
        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, LeftInput, 8);
            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 30);
            GameOp::ExecuteInput(state, NoInput, 58);
            TestEqual(186u, state.ball[0].pos.x);
            TestEqual(205u, state.ball[0].pos.y);

            // This shoves the ball into the side on the only frame possible.
            GameOp::ExecuteInput(state, RightInput);
            TestEqual(185u, state.ball[0].pos.x);
            TestEqual(208u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(188u, state.ball[0].pos.x);
            TestEqual(204u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(186u, state.ball[0].pos.x);
            TestEqual(202u, state.ball[0].pos.y);
        }
        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, LeftInput, 8);
            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 30);
            GameOp::ExecuteInput(state, NoInput, 59);
            TestEqual(185u, state.ball[0].pos.x);
            TestEqual(208u, state.ball[0].pos.y);

            // This moves the paddle too late to make a difference; should be identical to TestBallBounceNearEdge.
            GameOp::ExecuteInput(state, RightInput);
            TestEqual(188u, state.ball[0].pos.x);
            TestEqual(206u, state.ball[0].pos.y);

            GameOp::ExecuteInput(state, NoInput);
            TestEqual(184u, state.ball[0].pos.x);
            TestEqual(204u, state.ball[0].pos.y);
        }
    }

    void TestBallLevel1BlockBounce()
    {
        GameState state;
        GameOp::Init(state);

        GameOp::ExecuteInput(state, AInput);

        for (int i = 0; i < 42; i++)
        {
            GameOp::ExecuteInput(state, NoInput);
        }

        TestEqual(1u, state.ball[0].cycle);
        TestEqual(157u, state.ball[0].pos.x);
        TestEqual(97u, state.ball[0].pos.y);

        // The ball collides with the lowest row of blocks on this frame...
        GameOp::ExecuteInput(state, NoInput);

        TestEqual(0u, state.ball[0].cycle);
        TestEqual(159u, state.ball[0].pos.x);
        TestEqual(94u, state.ball[0].pos.y);

        // Verify that the expected block is gone.
        TestEqual(0u, BlkHits(state.blocks[9 * GameConsts::BlocksPerRow + 9])); // second-to-last block in the bottom row

        GameOp::ExecuteInput(state, NoInput);

        // Verify that the block count has been updated.
        TestEqual(65u, state.currentBlocks);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(160u, state.ball[0].pos.x);
        TestEqual(96u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(2u, state.ball[0].cycle);
        TestEqual(161u, state.ball[0].pos.x);
        TestEqual(98u, state.ball[0].pos.y);

        // Also verify that the ball is still moving downward, and no other blocks were destroyed.
        TestTrue(state.ball[0].vel.vy > 0);
        TestEqual(65u, state.currentBlocks);
    }

    void TestBallLevel1BlockBounceLeftSide()
    {
        GameState state;
        GameOp::Init(state);
        
        // Remove the third-to-last block in the bottom row.
        state.blocks[9 * GameConsts::BlocksPerRow + 8] = 0;
        state.currentBlocks = 65;

        GameOp::ExecuteInput(state, LeftInput);
        GameOp::ExecuteInput(state, AInput);

        for (int i = 0; i < 42; i++)
        {
            GameOp::ExecuteInput(state, NoInput);
        }

        TestEqual(1u, state.ball[0].cycle);
        TestEqual(154u, state.ball[0].pos.x);
        TestEqual(97u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(0u, state.ball[0].cycle);
        TestEqual(156u, state.ball[0].pos.x);
        TestEqual(94u, state.ball[0].pos.y);

        // The ball bounces off the left side of the block this frame...
        GameOp::ExecuteInput(state, NoInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(155u, state.ball[0].pos.x);
        TestEqual(92u, state.ball[0].pos.y);

        // Verify that the expected block is gone.
        TestEqual(0u, BlkHits(state.blocks[9 * GameConsts::BlocksPerRow + 9])); // second-to-last block in the bottom row

        GameOp::ExecuteInput(state, NoInput);

        // Verify that the block count has been updated.
        TestEqual(64u, state.currentBlocks);

        TestEqual(2u, state.ball[0].cycle);
        TestEqual(154u, state.ball[0].pos.x);
        TestEqual(90u, state.ball[0].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        TestEqual(0u, state.ball[0].cycle);
        TestEqual(153u, state.ball[0].pos.x);
        TestEqual(87u, state.ball[0].pos.y);

        // The ball bounces off the second row of blocks this frame...
        GameOp::ExecuteInput(state, NoInput);

        TestEqual(3u, state.ball[0].cycle);
        TestEqual(152u, state.ball[0].pos.x);
        TestEqual(89u, state.ball[0].pos.y);

        // Verify that the expected block is gone.
        TestEqual(0u, BlkHits(state.blocks[8 * GameConsts::BlocksPerRow + 8])); // third-to-last block in the second-to-last row

        GameOp::ExecuteInput(state, NoInput);

        // Verify that the block count has been updated.
        TestEqual(63u, state.currentBlocks);
    }

    void TestPowerupSpawnType()
    {
        auto passCount = 0;
        auto passed = true;

        auto manipTest = [&](const int leftMoves, const Powerup expectedPowerup) {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, LeftInput);
            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, LeftInput, leftMoves);
            GameOp::ExecuteInput(state, NoInput, 43 - leftMoves);
            GameOp::ExecuteInput(state, NoInput);

            if (expectedPowerup != state.spawnedPowerup) printf("\n failing on group 1, test %d\n", leftMoves);
            TestEqual(static_cast<int>(expectedPowerup), static_cast<int>(state.spawnedPowerup));
        };

        manipTest(0, Powerup::LargePaddle);
        manipTest(1, Powerup::Multiball);
        manipTest(2, Powerup::LargePaddle);
        manipTest(3, Powerup::Multiball);
        manipTest(4, Powerup::LargePaddle);
        manipTest(5, Powerup::Multiball);
        manipTest(6, Powerup::LargePaddle);
        manipTest(7, Powerup::Multiball);
        manipTest(8, Powerup::LargePaddle);
        manipTest(9, Powerup::Multiball);
        manipTest(10, Powerup::LargePaddle);
        manipTest(11, Powerup::Multiball);
        manipTest(12, Powerup::LargePaddle);
        manipTest(13, Powerup::Multiball);
        manipTest(14, Powerup::LargePaddle);
        manipTest(15, Powerup::Multiball);
        manipTest(16, Powerup::LargePaddle);
        manipTest(17, Powerup::Multiball);
        manipTest(18, Powerup::LargePaddle);
        manipTest(19, Powerup::Multiball);
        manipTest(20, Powerup::LargePaddle);
        manipTest(21, Powerup::Multiball);
        manipTest(22, Powerup::LargePaddle);
        manipTest(23, Powerup::Multiball);

        auto manipTest2 = [&](const int leftMoves, const Powerup expectedPowerup) {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, LeftInput, 3);
            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, LeftInput, leftMoves);
            GameOp::ExecuteInput(state, NoInput, 43 - leftMoves);

            GameOp::ExecuteInput(state, NoInput);

            if (expectedPowerup != state.spawnedPowerup) printf("\n failing on group 2, test %d\n", leftMoves);
            TestEqual(static_cast<int>(expectedPowerup), static_cast<int>(state.spawnedPowerup));
        };

        manipTest2(0, Powerup::Sticky);
        manipTest2(1, Powerup::Warp);
        manipTest2(2, Powerup::Sticky);
        manipTest2(3, Powerup::Multiball);
        manipTest2(4, Powerup::Sticky);
        manipTest2(5, Powerup::Multiball);
        manipTest2(6, Powerup::Slow);
        manipTest2(7, Powerup::Laser);
        manipTest2(8, Powerup::Slow);
        manipTest2(9, Powerup::Laser);
        manipTest2(10, Powerup::Sticky);
        manipTest2(11, Powerup::Multiball);
        manipTest2(12, Powerup::Slow);
        manipTest2(13, Powerup::Laser);
        manipTest2(14, Powerup::Slow);
        manipTest2(15, Powerup::Laser);
        manipTest2(16, Powerup::Slow);
        manipTest2(17, Powerup::Laser);
        manipTest2(18, Powerup::Slow);
        manipTest2(19, Powerup::Laser);
        manipTest2(20, Powerup::Warp);
        manipTest2(21, Powerup::Laser);

        auto manipTest3 = [&](const int rightMoves, const Powerup expectedPowerup) {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, RightInput, 16);
            GameOp::ExecuteInput(state, NoInput, 74);
            GameOp::ExecuteInput(state, LeftInput, 40);
            GameOp::ExecuteInput(state, NoInput, 66);
            GameOp::ExecuteInput(state, RightInput, rightMoves);
            GameOp::ExecuteInput(state, NoInput, 43 - rightMoves);

            GameOp::ExecuteInput(state, NoInput);

            if (expectedPowerup != state.spawnedPowerup) printf("\n failing on group 3, test %d\n", rightMoves);
            TestEqual(static_cast<int>(expectedPowerup), static_cast<int>(state.spawnedPowerup));
        };

        manipTest3(0, Powerup::Multiball);
        manipTest3(1, Powerup::Sticky);
        manipTest3(2, Powerup::Multiball);
        manipTest3(3, Powerup::Sticky);
        manipTest3(4, Powerup::Multiball);
        manipTest3(5, Powerup::Sticky);
        manipTest3(6, Powerup::Multiball);
        manipTest3(7, Powerup::Sticky);
        manipTest3(8, Powerup::Multiball);
        manipTest3(9, Powerup::Sticky);
        manipTest3(10, Powerup::Multiball);
        manipTest3(11, Powerup::Sticky);
        manipTest3(12, Powerup::Multiball);
        manipTest3(13, Powerup::Sticky);
        manipTest3(14, Powerup::Multiball);
        manipTest3(15, Powerup::Sticky);
        manipTest3(16, Powerup::Multiball);
        manipTest3(17, Powerup::LargePaddle);
        manipTest3(18, Powerup::Multiball);
        manipTest3(19, Powerup::Sticky);
        manipTest3(20, Powerup::Multiball);
        manipTest3(21, Powerup::Sticky);
        manipTest3(22, Powerup::Multiball);
        manipTest3(23, Powerup::LargePaddle);
        manipTest3(24, Powerup::Multiball);
        manipTest3(25, Powerup::LargePaddle);
        manipTest3(26, Powerup::Multiball);
        manipTest3(27, Powerup::LargePaddle);
        manipTest3(28, Powerup::Multiball);
        manipTest3(29, Powerup::LargePaddle);
        manipTest3(30, Powerup::Multiball);
        manipTest3(31, Powerup::LargePaddle);
        manipTest3(32, Powerup::Multiball);
        manipTest3(33, Powerup::LargePaddle);
        manipTest3(34, Powerup::Multiball);
        manipTest3(35, Powerup::LargePaddle);
        manipTest3(36, Powerup::Multiball);
        manipTest3(37, Powerup::LargePaddle);
        manipTest3(38, Powerup::Multiball);
        manipTest3(39, Powerup::LargePaddle);
        manipTest3(40, Powerup::Multiball);
        manipTest3(41, Powerup::LargePaddle);
        manipTest3(42, Powerup::Multiball);
        manipTest3(43, Powerup::Warp);
    }

    void TestPowerupSpawnData()
    {
        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, LeftInput);
            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, NoInput, 43);

            // Verify that there's no powerup yet.
            TestEqual(0, state.powerupPos.x);
            TestEqual(0xf1, state.powerupPos.y);
            TestEqual(static_cast<int>(Powerup::None), static_cast<int>(state.spawnedPowerup));

            GameOp::ExecuteInput(state, NoInput);

            // Verify that a multiball powerup was spawned in the right spot.
            TestEqual(0x90, state.powerupPos.x);
            TestEqual(0x59, state.powerupPos.y);
            TestEqual(static_cast<int>(Powerup::LargePaddle), static_cast<int>(state.spawnedPowerup));
        }
        {
            GameState state;
            GameOp::Init(state);

            GameOp::ExecuteInput(state, LeftInput);
            GameOp::ExecuteInput(state, AInput);
            GameOp::ExecuteInput(state, LeftInput, 23);
            GameOp::ExecuteInput(state, NoInput, 20);

            // Verify that there's no powerup yet.
            TestEqual(0, state.powerupPos.x);
            TestEqual(0xf1, state.powerupPos.y);
            TestEqual(static_cast<int>(Powerup::None), static_cast<int>(state.spawnedPowerup));

            GameOp::ExecuteInput(state, NoInput);

            // Verify that a multiball powerup was spawned in the right spot.
            TestEqual(0x90, state.powerupPos.x);
            TestEqual(0x59, state.powerupPos.y);
            TestEqual(static_cast<int>(Powerup::Multiball), static_cast<int>(state.spawnedPowerup));
        }
    }
}

void TestNoDoublePowerupSpawns()
{
    {
        GameState state;
        GameOp::Init(state);

        GameOp::ExecuteInput(state, LeftInput, 24);
        GameOp::ExecuteInput(state, AInput);
        GameOp::ExecuteInput(state, RightInput, 35);
        GameOp::ExecuteInput(state, NoInput, 8);

        // Verify there's no powerup yet.
        TestEqual(static_cast<int>(Powerup::None), static_cast<int>(state.spawnedPowerup));

        // Verify the right powerup spawns on the next frame.
        GameOp::ExecuteInput(state, NoInput);
        TestEqual(static_cast<int>(Powerup::Sticky), static_cast<int>(state.spawnedPowerup));

        // Wait 90 frames, verify the next block was broken and the same
        // powerup is still around.
        GameOp::ExecuteInput(state, NoInput, 90);
        TestEqual(64, state.currentBlocks);
        TestEqual(static_cast<int>(Powerup::Sticky), static_cast<int>(state.spawnedPowerup));
    }
}

void TestCollectMultiball()
{
    {
        GameState state;
        GameOp::Init(state);

        GameOp::ExecuteInput(state, LeftInput, 1);
        GameOp::ExecuteInput(state, AInput);
        GameOp::ExecuteInput(state, RightInput, 20);
        GameOp::ExecuteInput(state, NoInput, 100);

        // Verify there's a multiball powerup in the correct spot
        TestEqual(static_cast<int>(Powerup::Multiball), static_cast<int>(state.spawnedPowerup));
        TestEqual(0x90, state.powerupPos.x);
        TestEqual(0xa5, state.powerupPos.y);

        GameOp::ExecuteInput(state, NoInput, 34);

        // Verify the powerup is just above the paddle.
        TestEqual(static_cast<int>(Powerup::Multiball), static_cast<int>(state.spawnedPowerup));
        TestEqual(0x90, state.powerupPos.x);
        TestEqual(0xc7, state.powerupPos.y);
        TestEqual(static_cast<int>(Powerup::None), static_cast<int>(state.ownedPowerup));

        // Also verify that ball 2 and 3 haven't spawned yet.
        TestTrue(state.ball[0].exists);
        TestFalse(state.ball[1].exists);
        TestFalse(state.ball[2].exists);

        GameOp::ExecuteInput(state, NoInput);

        // Verify the powerup is collected this frame (but still exists
        // in the original spot).
        TestEqual(static_cast<int>(Powerup::None), static_cast<int>(state.spawnedPowerup));
        TestEqual(0x90, state.powerupPos.x);
        TestEqual(0xc8, state.powerupPos.y);
        TestEqual(static_cast<int>(Powerup::Multiball), static_cast<int>(state.ownedPowerup));

        // Also verify that three balls now exist in the ball position.
        TestTrue(state.ball[0].exists);
        TestTrue(state.ball[1].exists);
        TestTrue(state.ball[2].exists);
        TestEqual(state.ball[0].pos.x, state.ball[1].pos.x);
        TestEqual(state.ball[0].pos.y, state.ball[1].pos.y);
        TestEqual(state.ball[0].pos.x, state.ball[2].pos.x);
        TestEqual(state.ball[0].pos.y, state.ball[2].pos.y);

        // Also verify the new balls have different angles.
        TestEqual(static_cast<int>(Angle::Steep), static_cast<int>(state.ball[0].angle));
        TestEqual(static_cast<int>(Angle::Normal), static_cast<int>(state.ball[1].angle));
        TestEqual(static_cast<int>(Angle::Shallow), static_cast<int>(state.ball[2].angle));

        GameOp::ExecuteInput(state, NoInput);

        // Verify the powerup has moved offscreen.
        TestEqual(static_cast<int>(Powerup::None), static_cast<int>(state.spawnedPowerup));
        TestEqual(0x90, state.powerupPos.x);
        TestEqual(0xf1, state.powerupPos.y);

        // Also verify that three balls are still in the same spot.
        TestEqual(state.ball[0].pos.x, state.ball[1].pos.x);
        TestEqual(state.ball[0].pos.y, state.ball[1].pos.y);
        TestEqual(state.ball[0].pos.x, state.ball[2].pos.x);
        TestEqual(state.ball[0].pos.y, state.ball[2].pos.y);

        GameOp::ExecuteInput(state, NoInput);

        // Verify that three balls have diverged slightly.
        TestEqual(0x7e, state.ball[0].pos.x);
        TestEqual(0x7d, state.ball[1].pos.x);
        TestEqual(0x7d, state.ball[2].pos.x);
        TestEqual(0x9e, state.ball[0].pos.y);
        TestEqual(0x9e, state.ball[1].pos.y);
        TestEqual(0x9d, state.ball[2].pos.y);
    }
}

void UnitTest::Run()
{
    printf("TestFullGameSim: ");
    TestFullGameSim();
    printf("passed\n");

    printf("TestMathUtilClamp: ");
    TestMathUtilClamp();
    printf("passed\n");

    printf("TestMathUtilPointInRect: ");
    TestMathUtilPointInRect();
    printf("passed\n");

    printf("TestAdc: ");
    TestAdc();
    printf("passed\n");

    printf("TestPaddleMoveNoLaunch: ");
    TestPaddleMoveNoLaunch();
    printf("passed\n");

    printf("TestBallLaunch: ");
    TestBallLaunch();
    printf("passed\n");

    printf("TestBallInitTrajectory: ");
    TestBallInitTrajectory();
    printf("passed\n");

    printf("TestBallRightWallBounce: ");
    TestBallRightWallBounce();
    printf("passed\n");

    printf("TestBallRightWallBounceOneSpaceAway: ");
    TestBallRightWallBounceOneSpaceAway();
    printf("passed\n");

    printf("TestPaddleBounceRightSide: ");
    TestPaddleBounceRightSide();
    printf("passed\n");

    printf("TestBallLevel1BlockBounce: ");
    TestBallLevel1BlockBounce();
    printf("passed\n");

    printf("TestBallLevel1BlockBounceLeftSide: ");
    TestBallLevel1BlockBounceLeftSide();
    printf("passed\n");

    printf("TestBallPaddleBounceRightCorner: ");
    TestBallPaddleBounceRightCorner();
    printf("passed\n");

    printf("TestBallShoveBounce: ");
    TestBallShoveBounce();
    printf("passed\n");

    printf("TestBallBounceNearEdge: ");
    TestBallBounceNearEdge();
    printf("passed\n");

    printf("TestBallShoveNearEdge: ");
    TestBallShoveNearEdge();
    printf("passed\n");

    printf("TestPowerupSpawnType: ");
    TestPowerupSpawnType();
    printf("passed\n");

    printf("TestPowerupSpawnData: ");
    TestPowerupSpawnData();
    printf("passed\n");

    printf("TestNoDoublePowerupSpawns: ");
    TestNoDoublePowerupSpawns();
    printf("passed\n");

    printf("TestCollectMultiball: ");
    TestCollectMultiball();
    printf("passed\n");

    printf("\n");
}