#pragma once

#include <GameConsts.h>
#include <GameState.h>

#include <vector>
#include <initializer_list>

class GameOp
{
public:
    // Simulation APIs.
    static void Init(GameState& state);
    static void AdvanceToLevel(GameState& state, unsigned int level);
    static void ExecuteInput(GameState& state, const Input& input);
    static void ExecuteInput(GameState& state, const Input& input, unsigned int count);
    static void ExecuteInputChain(GameState& state, const std::vector<Input>& inputChain);

    // Game functions that execute on-demand.
    static void LoadLevel(GameState& state, unsigned int level);
    static void InitPaddleAndBall(GameState& state, unsigned int level);
    static unsigned int _RandNum(GameState& state, unsigned int inputCarry);

private:
    // Internal simulation functions.
    static void SetInput(GameState& state, const Input& input);
    static void AdvanceFrame(GameState& state);
    
    // Game functions that execute every frame.
    static void RefreshMiscState(GameState& state);
    static void ProcessInput(GameState& state, const Input& input);
    static void UpdateScore(GameState& state);
    static void CheckPowerupCanSpawn(GameState& state);
    static void UpdateEnemies(GameState& state);
    static void CheckPaddleCollisWithEnemy(GameState& state);
    static void UpdatePowerup(GameState& state);
    static void UpdateBallSprites(GameState& state);
    static void CheckLaunchBall(GameState& state);
    static void CheckPaddleMove(GameState& state);
    static void UpdateActiveBalls(GameState& state);
    static void CheckPowerupCanBeCollected(GameState& state);
    static void UpdateTimers(GameState& state);

    // Internal sub-routines.
    static void UpdatePendingBlockScore(GameState& state);
    static void ReactToBlockCollis(GameState& state);
    static void UpdateEnemyGate(GameState& state);
    static void DestroyEnemy(GameState& state, Enemy& enemy);

    static void DoPaddleMove(GameState& state, int delta);
    static void GenPowerup(GameState& state);
    static void GetMultiBallPowerup(GameState& state);
};

class BallOp
{
public:
    static void UpdateBallSpeedData(GameState& state, Ball& ball);
    static void AdvanceOneBall(GameState& state, Ball& ball);
    static void CheckBlockBossCollis(GameState& state, Ball& ball);
    static void CheckPaddleCollis(GameState& state, Ball& ball);
    static void CheckEnemyCollis(GameState& state, Ball& ball);
    static void UpdateCeilCollisVSign(GameState& state, Ball& ball);
    static void HandleBlockCollis(GameState& state, Ball& ball);
    static void CheckBallLost(GameState& state, Ball& ball);

private:
    static void CheckBlockCollis(GameState& state, Ball& ball);
    static void CheckBossCollis(GameState& state, Ball& ball);
    static Proximity GetBlockProximity(GameState& state, unsigned int cellX, unsigned int cellY);
};

class EnemyOp
{
public:
    static void UpdateEnemyAnimTimers(GameState& state);
    static void AdvanceEnemies(GameState& state);
    static void UpdateEnemyStatus(GameState& state);
    static void HandleEnemyDestruction(GameState& state);
    static void UpdateEnemySprites(GameState& state);

private:
    static void AdvanceOneEnemy(GameState& state, Enemy& enemy);
    static void CheckNormalMovement(GameState& state, Enemy& enemy);
    static void CheckCirclingMovement(GameState& state, Enemy& enemy);
    static void CheckDownMovement(GameState& state, Enemy& enemy);
    static void DoNormalEnemyMove(GameState& state, Enemy& enemy);

    // Collision checks
    static bool CheckVertBlockCollis(GameState& state, Enemy& enemy);
    static bool CheckHorizBlockCollis(GameState& state, Enemy& enemy);
    static unsigned int CheckOtherEnemyCollis(GameState& state, Enemy& enemy);
};