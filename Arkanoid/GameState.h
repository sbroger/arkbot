#pragma once

#include <GameConsts.h>

#include <functional>

struct Point
{
	unsigned int x = 0;
	unsigned int y = 0;
};

struct Vel
{
    int vx = 0;
    int vy = 0;
};

struct Rect
{
    unsigned int left = 0;
    unsigned int right = 0;
    unsigned int top = 0;
    unsigned int bottom = 0;

    unsigned int width()
    {
        return right - left;
    }

    unsigned int height()
    {
        return bottom - top;
    }
};

struct SpeedTableRow
{
    unsigned int cycleLen = 0;
    unsigned int speedMult = 0;
    unsigned int speedReduction = 0;
    unsigned int _unused = 0;

    unsigned int vel[16] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
};

struct Ball
{
    Point pos = { 0x77, 0x77 };

    Vel vel = { 0x77, 0x77 };
    Vel vSign = { 0x77, 0x77 };

    Angle angle = Angle::Invalid;

    unsigned int cycle = 0x77;

    bool exists = true;

    bool xCollis = true;
    bool yCollis = true;

    // This is part of the ball data since it varies based on the angle.
    unsigned int speedMult = 0x77;

    unsigned int speedStage = 0x77;
    unsigned int speedStageM = 0x77;

    SpeedTableRow* speedRow = nullptr;
    unsigned int speedRowIdx = 0;

    // The game doesn't track this but it's useful for the AI.
    bool _paddleCollis = false;
};

typedef uint8_t Block;
typedef uint8_t ControllerInput;
struct Input
{
    ControllerInput controller;
    uint8_t paddle;
};

struct Proximity
{
    bool thisBlock = false;
    bool oneRight = false;
    bool oneDown = false;
    bool oneDownRight = false;
};

struct Enemy
{
    bool active = true;
    bool exiting = true;
    unsigned int destrFrame = 0x77;
    Point pos = { 0x77, 0x77 };
    MovementType movementType = MovementType::Circling;
    unsigned int moveTimer = 0x77;
    unsigned int moveDir = 0x77;
    unsigned int descentTimer = 0x77;
    unsigned int animTimer = 0x77;
    unsigned int circleStage = 0x77;
    CircleHalf circleHalf = CircleHalf::Top;
    CircleDir circleDir = CircleDir::Counterclockwise;

    unsigned int _id = 0x77;
};

// Special flags to control simulation behavior.
// TODO use templates instead

constexpr unsigned int _Level = 1;
constexpr bool _CompileTimeLevel = true;

// Do extra updates and checks done by the original game engine, that aren't
// strictly necessary for the evaluation.
constexpr bool _Pedantic = false;

constexpr bool _EnableDebug = false;
constexpr bool _PrintSolution = false;

constexpr bool _Debug()
{
    return _EnableDebug;
}

constexpr bool EnemySimTable[37] = {
    true,
    false, true, true, true, true, true, true, true,
    true, true, true, false, false, true, false, true,
    true, true, true, true, true, true, true, false,
    true, true, true, false, true, true, true, false,
    true, false, true,
    false
};

constexpr bool GoldBlockTable[37] = {
    true,
    false, false, true, false, false, true, false, true,
    true, true, false, true, false, true, false, true,
    true, true, true, true, true, true, false, false,
    true, true, false, true, true, true, false, true,
    false, true, true,
    false
};

constexpr bool SimulateScoreTable[37] = {
    true,
    true, true, true, true, true, true, true, true,
    true, true, true, true, true, true, true, true,
    true, true, true, true, true, true, true, true,
    true, true, true, true, true, true, true, true,
    true, true, true,
    false
};

struct GameState
{
    // Overall operational state.
    OperationalState opState = OperationalState::Invalid;

    // Input data.
    Input buttons = { 0x77, 0x77 };
    Input prevButtons = { 0x77, 0x77 };

	// Paddle values.
	unsigned int paddleX = 0x77;
    bool paddleCollis = true;

	// Ball data.
    Ball ball[3];

    // Block data.
    Block blocks[GameConsts::BlockTableSize];
    unsigned int totalBlocks = 0x77;
    unsigned int currentBlocks = 0x77;
    unsigned int blockCollisCount = 0x77;
    Proximity blockCollisSide = { true, true, true, true };
    Block justHitBlock[3] = { 0x77, 0x77, 0x77 };
    Point justHitBlockCell[3] = { { 0x77, 0x77 }, { 0x77, 0x77 }, { 0x77, 0x77 } };
    bool justDestrBlock[3] = { true, true, true };
    Point calculatedCell = { 0x77, 0x77 };

    // Powerup data.
    Powerup spawnedPowerup = Powerup::Invalid;
    Powerup ownedPowerup = Powerup::Invalid;
    Point powerupPos = { 0x77, 0x77 };
    bool justSpawnedPowerup = true;

    // Score data.
    unsigned int score = 0x77;
    unsigned int pendingScore = 0x77;

    // Enemy data.
    Enemy enemies[3];
    unsigned int enemySpawnTimers[3] = { 0x77, 0x77, 0x77 };
    unsigned int enemySpawnIndex = 0x77;
    unsigned int enemyGateState = 0x77;
    unsigned int enemyGateIndex = 0x77;
    unsigned int enemyGateTimer = 0x77;

    // Other stuff.
    unsigned int overallSpeedStage = 0x77;
    unsigned int overallSpeedStageM = 0x77;
    unsigned int speedStageCounter = 0x77;
    unsigned int speedReduction = 0x77;
    unsigned int level = 0x77;
    unsigned int mysteryInput = 0x77;
    unsigned int bossHits = 0x77;

    // Despite triggering off a single ball at a time, its value is consumed during the same
    // ball update cycle, so it's here in the global state block rather than the block state.
    bool ceilCollis = true;

    // Simulation-specific data - not used by the actual game logic.
    unsigned int _frame = 0;
    Input _pendingInput;
    std::vector<Input> inputChain;
    std::function<void(const GameState&)> _OnFrameAdvance = [](const GameState&) {};
    int _justMovedEnemy = -1;
    unsigned int _enemyMysteryInput = 0x77;
    unsigned int _enemyMoveOptions = 0;
    bool _disablePaddleHitbox = false;
    bool _disableBlockHitboxes = false;
    int _queueEnemyDestruction = -1;
};

constexpr bool _SimulateEnemies(const GameState& state)
{
    const auto level = _CompileTimeLevel ? _Level : state.level;
    return (level == 0 || EnemySimTable[level]);
}

constexpr bool _SimulateGoldBlocks(const GameState& state)
{
    const auto level = _CompileTimeLevel ? _Level : state.level;
    return (level == 0 || GoldBlockTable[level]);
}

constexpr bool _SimulateScore(const GameState& state)
{
    const auto level = _CompileTimeLevel ? _Level : state.level;
    return (level == 0 || SimulateScoreTable[level]);
}