#pragma once

#include <GameState.h>

#include <vector>

static const Input NoInput = 0;
static const Input AInput = 0x80;
static const Input BInput = 0x40;
static const Input SelectInput = 0x20;
static const Input StartInput = 0x10;
static const Input UpInput = 8;
static const Input DownInput = 4;
static const Input LeftInput = 2;
static const Input RightInput = 1;
static const Input RightAInput = 0x81;
static const Input LeftAInput = 0x82;
static const Input FutureInput = 0xf0;

extern unsigned int BlkHits(const Block block);
extern unsigned int BlkPowerup(const Block block);
extern BlockType BlkType(const Block block);

bool InputA(const Input inp);
bool InputB(const Input inp);
bool InputLeft(const Input inp);
bool InputRight(const Input inp);
bool InputUp(const Input inp);
bool InputDown(const Input inp);
bool InputStart(const Input inp);
bool InputSelect(const Input inp);

namespace Data
{
    extern std::vector<std::vector<unsigned int>> EnemySpawnTimerTable;
    extern std::vector<std::vector<Block>> LevelData;
    extern std::vector<unsigned int> LevelBlockCount;
    extern std::vector<unsigned int> StartingSpeedStage;
    extern std::vector<unsigned int> SpeedStageThresholds;
    extern std::vector<unsigned int> RngTable;
    extern std::vector<unsigned int> GateStateSignalValues;
    extern std::vector<unsigned int> GateTimerDurations;
    extern std::vector<unsigned int> BlockScoreTable;
    extern std::vector<unsigned int> SpecialPowerupTable;
    extern std::vector<SpeedTableRow> SteepSpeedTable;
    extern std::vector<SpeedTableRow> NormalSpeedTable;
    extern std::vector<SpeedTableRow> ShallowSpeedTable;
    extern std::vector<unsigned int> CeilingBounceSpeedStage;
    extern std::vector<int> CircleMovementTable;

    constexpr unsigned int MinBlockRow[37] = {
        0,
        4, 2, 3, 4, 2, 3, 4, 3,
        2, 0, 4, 2, 4, 3, 3, 2,
        2, 3, 3, 3, 3, 3, 2, 5,
        3, 4, 7, 3, 3, 4, 3, 3,
        2, 3, 0,
        0
    };

    constexpr unsigned int MaxBlockRow[37] = {
        0,
        9, 12, 17, 17, 15, 13, 15, 13,
        12, 16, 12, 14, 11, 16, 14, 15,
        13, 12, 11, 13, 13, 12, 14, 13,
        13, 10, 13, 12, 12, 13, 16, 13,
        15, 17, 14,
        0
    };
}