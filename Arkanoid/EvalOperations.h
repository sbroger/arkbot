#pragma once

#include <GameState.h>

#include <atomic>
#include <memory>
#include <future>

#include <unordered_map>

enum class DecisionPoint
{
    LaunchBall,
    BounceBall1,
    BounceBall2,
    BounceBall3,
    CollectPowerup,
    ManipPowerup,
    ManipEnemySpawn,
    ManipEnemy1Move,
    ManipEnemy2Move,
    ManipEnemy3Move,
    HitEnemy1WithPaddle,
    HitEnemy2WithPaddle,
    HitEnemy3WithPaddle,
    None_LevelEnded,
    None_LimitReached,
    None_BallLost,
    Invalid
};

enum class BounceResult
{
    Missed,
    Bounced,
    StillArriving,
    Mismatch,
    Invalid
};

enum class Multithreading
{
    None,
    AllButOne,
    All
};

enum class OutputMode
{
    Normal,
    Debug,
    RemainingHits,
    ScoreVariant
};


struct BallInitState
{
    int startDir;
    Point startPos;
    unsigned int startCycle;
    unsigned int speedStage;
    unsigned int paddleX;

    bool operator==(const BallInitState& other) const
    {
        return (startDir == other.startDir
            && startPos.x == other.startPos.x
            && startPos.y == other.startPos.y
            && startCycle == other.startCycle
            && speedStage == other.speedStage
            && paddleX == other.paddleX);
    }
};

struct BallInitStateHasher
{
    std::size_t operator()(const BallInitState& b) const
    {
        size_t hash = 17;
        hash = hash * 31 + std::hash<int>()(b.startDir);
        hash = hash * 31 + std::hash<unsigned int>()(b.startPos.x);
        hash = hash * 31 + std::hash<unsigned int>()(b.startPos.y);
        hash = hash * 31 + std::hash<unsigned int>()(b.startCycle);
        hash = hash * 31 + std::hash<unsigned int>()(b.speedStage);
        hash = hash * 31 + std::hash<unsigned int>()(b.paddleX);

        return hash;
    }
};

struct PaddleBounceState
{
    bool bounced;
    int bounceDir;
};

const unsigned int MaxResults = 9999999;

struct EvalState;

using Result = std::pair<GameState, EvalState>;
using ResultSet = std::vector<Result>;

// Data that can update mid-evaluation, that needs to be propagated
// to other executing threads.
struct SharedState
{
    // General-purpose sentry to avoid thread contention on things beyond the scope of this struct.
    // Located here for convenience.
    std::mutex genericSentry;

    std::atomic<unsigned int> frameLimit = 0;
    std::atomic<unsigned int> bestBlockHitCount = 9999;

    std::mutex resultsSentry;
    ResultSet results;


    std::vector<std::unique_ptr<std::mutex>> perThreadQueueSentry;
    std::vector<ResultSet> perThreadQueue;


    // These are constant once set and don't need to be atomic.
    std::unordered_map<BallInitState, PaddleBounceState, BallInitStateHasher> bounceTable;
    std::vector<unsigned int> hitTable;
};

struct EvalState
{
    bool printState = false;
    unsigned int printRate = 0;
    unsigned int sleepLen = 0;
    unsigned int printCounter = 0;
    int depth = 0;
    DecisionPoint action = DecisionPoint::Invalid;
    std::string decisionChain;
    Multithreading multithreading;
    unsigned int depthLimit = 999;
    bool outputBizHawkMovie = false;
    bool allPowerupManipOptions = false;
    unsigned int ensurePowerupByDepth = 0;
    bool includeBumpOptions = false;
    unsigned int launchDelayRange = 0;
    bool printProgress = false;
    bool testAllScoreVariations = false;
    bool noConditions = false;
    unsigned int timeLimit = 0;
    std::chrono::steady_clock::time_point startTime;
    unsigned int startFrame = 0;
    unsigned int testSinglePaddlePos = 0;
    std::wstring bounceMask = L"1=1";
    bool manipulateEnemies = false;
    bool allPowerupCollectionOptions = false;
    bool useBounceTableLookups = false;
    bool allEnemyHitOptions = false;
    int skipToDepth = 0;
    unsigned int skipToFrame = 0;
    bool outputBestAttempts = false;
    bool manipulateEnemyMoves = false;
    bool allSideHitVariations = false;
    bool treatLookupFailuresAsFatal = false;
    bool bounceTableDebugChecks = false;
    bool enforceTasRefHitProgression = false;
    unsigned int hitProgressionGraceInterval = 0;
    unsigned int hitProgressionLeadupInterval = 0;
    bool useHitProgressionAveraging = false;
    bool strictHitProgression = false;

    unsigned int threadId;
    unsigned int numThreads;

    std::vector<std::function<bool(const GameState& state, const EvalState& eval)>> conditions;

    unsigned int frameLimit() const { return sharedState->frameLimit.load(); }

    std::shared_ptr<SharedState> sharedState = std::make_shared<SharedState>();
};

const std::vector<unsigned int> TotalHits = {
    0,
    77, 76, 64, 126, 124, 61, 68, 7,
    34, 27, 147, 8, 56, 131, 212, 60,
    74, 47, 42, 32, 22, 64, 275, 53,
    82, 18, 242, 45, 104, 79, 234, 54,
    125, 59, 52
};

struct LevelParams
{
    // Level window is the first input frame to the frame when the last block is broken.
    unsigned int startFrame;
    unsigned int endFrameRef;
    unsigned int startingScore;

    std::vector<std::function<bool(const GameState& state, const EvalState& eval)>> conditions;
};


using DecisionSet = std::vector<std::pair<DecisionPoint, unsigned int>>;

class EvalOp
{
public:
    static void Evaluate(const GameState& state, EvalState& eval);
    static void OnFrameAdvance(const GameState& state, EvalState& eval);

    static void PrintGameState(const GameState& state, const EvalState& eval, bool introOnly = false, bool realtime = true);
    static void PrintLevelLoadScreen(unsigned int level);
    static void PrintGameStartScreen(bool showPlayerOneText);
    static void PrintBlankScreen();
    static void PrintEndingText(unsigned int timeBetweenSteps);

    static unsigned int GetBizHawkMovieFrameLen(const GameState& state);
    static void CombineMovieFiles(const std::vector<LevelParams>& defaultParams);
    static std::vector<Input> BizHawkMovieToInputChain(const std::wstring& filename);
    static std::vector<Input> BizHawkMovieToInputChain(unsigned int level);
    static void OutputBizHawkMovie(const GameState& state, const EvalState& eval, OutputMode mode = OutputMode::Normal);
    static void GenerateAllScoreVariants(unsigned int level, unsigned int defaultScore, bool printResults);

    static DecisionSet ObserveDecisionPoints(const std::vector<Input>& inputChain, unsigned int level, unsigned int startingScore,
                                             bool includeStandardEnemyManips, bool includeEnemyMoveManips, bool printValues = false);

    static unsigned int BlockProgressPercent(const GameState& state);
    static unsigned int GetRemainingHits(const GameState& state);

    static void Sleep(const unsigned int milliseconds);

private:
    static void StartJobQueue(GameState& state, EvalState& eval);

    static bool AnyBallLost(const GameState& state);
    static bool BallLost(const Ball& ball);
    static bool EnemyOverlapsPaddle(const Enemy& enemy, unsigned int paddleX);
    static unsigned int GetNumPaddleStepsTo(GameState& state, unsigned int pos);
    static void MovePaddleTo(GameState& state, unsigned int pos);
    static std::string InputChainToStringShort(const std::vector<Input>& inputChain);
    static bool ReachedFrameLimit(const GameState& state, EvalState& eval);
    static unsigned int ScoreToId(unsigned int score);
    static bool CheckHitLimitExceeded(GameState& state, EvalState& eval);

    static DecisionPoint GetNextDecisionPoint(GameState& state, EvalState& eval, unsigned int& targetFrame, unsigned int& expectedBallPos,
                                              const std::vector<DecisionPoint>& exclusions = {}, bool manipulateFromLeftSide = false);
    static void ExecuteNextDecisionPoint(GameState& state, EvalState& eval, const std::vector<DecisionPoint>& exclusions = {});
    static void ExecuteDecisionPoint(GameState& state, EvalState& eval, DecisionPoint decisionPoint, unsigned int targetFrame, unsigned int expectedBallPos,
                                     const std::vector<DecisionPoint>& prevExclusions);

    static void QueueJobs(std::vector<std::pair<GameState, EvalState>>&& jobs);
    static void QueueJob(std::pair<GameState, EvalState>&& job);

    static void LaunchBall(GameState& state, EvalState& eval);
    static ResultSet BounceBall(GameState& state, EvalState& eval, unsigned int ballIdx, unsigned int targetFrame, unsigned int expectedBallPos);
    static void ManipulatePowerup(GameState& state, EvalState& eval, unsigned int targetFrame);
    static void CollectPowerup(GameState& state, EvalState& eval);
    static ResultSet ManipulateEnemySpawn(GameState& state, EvalState& eval, unsigned int targetFrame);
    static void HitEnemyWithPaddle(GameState& state, EvalState& eval, unsigned int enemyIdx, unsigned int targetFrame);
    static void ManipulateEnemyMove(GameState& state, EvalState& eval, unsigned int enemyIdx, unsigned int targetFrame, unsigned int moveMask,
                                    const std::vector<DecisionPoint>& prevExclusions);

    static BounceResult EvaluateOneBounceOption(GameState& state, EvalState& eval, Ball& ball, unsigned int paddleTarget, unsigned int targetFrame, unsigned int expectedBallPos);
    static BounceResult EvaluateOneBounceOptionAux(GameState& state, EvalState& eval, Ball& ball);
    static ResultSet EvaluateOneBumpOption(GameState& state, EvalState& eval, Ball& ball, unsigned int ballIdx, unsigned int ballArrivalFrame, unsigned int expectedBallPos, unsigned int paddleTarget, bool bumpLeft);
    static BounceResult MovePaddleWithConditions(GameState& state, EvalState& eval, Ball& ball, unsigned int ballArrivalFrame, unsigned int expectedBallPos, unsigned int paddleTarget);

    static void ConvertFuturesTo(GameState& state, const Input& input, unsigned int numFutures, unsigned int countToReplace);

    static void DebugDumpState(GameState& state, EvalState& eval);
};