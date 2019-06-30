;-------------------------------------------------------------------------------
; Arkanoid (USA).nes disasembled by DISASM6 v1.5
;-------------------------------------------------------------------------------

; Buttons.
;   0000 0000
;   ABsS ^v<>
Buttons        = $00
PrevButtons    = $01
ButtonsP2      = $02
PrevButtonsP2  = $03
ButtonsM       = $04
PrevButtonsM   = $05
ButtonsP2M     = $06
PrevButtonsP2M = $07


; Active game state.
;     0 = init
;     1 = on title screen
;     2 = blank screen before story
;     3 = story showing
;     4 = game starting (still on title screen)
;     5 = "round X" level intro screen
;     6 = transitioning into level (very brief)
;     7 = level intro playing
;     8 = level started, ball not launched (also applies when using sticky powerup)
;  0x10 = ball moving
;  0x18 = ball lost
;  0x20 = paused
GameState     = $0a


; Ball auto-launch trigger.
; Set to 1 for a single frame, when the ball gets launched on its own.
AutoLaunchFlag = $0c

NumLives      = $0d


CurrentBlocks = $0f

IsDemo        = $10
DemoLevelIdx  = $11

; Timer for things on the title screen (story, demos).
; Two-byte value.
TitleTimerHi = $12
TitleTimerLo = $13

_PPU_Ctrl1_Mirror = $14
_PPU_Ctrl2_Mirror = $15
_VScrollOffset    = $16
_HScrollOffset    = $17 ; Not used

CurrentLevel  = $1a

; Mirror of extra life count?
; NumLives    = $1d


TotalBlocks   = $1f


CurrentLevelM = $21


; Spawn timer mirrors. Copied and retrieved in the context of level switching.
EnemySpawnTimerHiM   = $27
EnemySpawnTimerLoM   = $28
; TwoEnemySpawnTimerHiM   = $29
; TwoEnemySpawnTimerLoM   = $2a
; ThreeEnemySpawnTimerHiM = $2b
; ThreeEnemySpawnTimerLoM = $2c


; Ball velocity sign bits.
; Bit 0 = vy sign, 1 = positive, 0 = negative
; Bit 1 = vx sign, 0 = positive, 1 = negative
BallVelSign           = $33

; Ball collision indicator.
; Bit 0 = y-collision, bit 1 = x-collision
BallCollisType        = $34

Ball_1_Vel_Y          = $35
Ball_1_Vel_X          = $36
Ball_1_Y              = $37
Ball_1_X              = $38

; Bit components of the ball x and y position.
; Note that the position gets normalized to 0, 0 prior to storage.
; Y is split 5 / 3, X is split 4 / 4.
BallYHiBits           = $39
BallYLoBits           = $3a
BallXHiBits           = $3b
BallXLoBits           = $3c

; Indicators for which logical cell the ball is in (1 cell = 1 potential block).
; E.g. top-left corner is (0, 0), bottom-right just above the paddle is (11, 16).
; Lags one frame behind the "official" calculated cell values ($10c / $10d).
BallCellY             = $3d
BallCellX             = $3e

BallYLoBitsM          = $3f
BallXLoBitsM          = $40

; 41 = some kind of height indicator, coarse


; Speed table address.
; 0xacXX = steep, 0xadXX = normal, 0xaeXX = shallow
SpeedTablePtrLo       = $43
SpeedTablePtrHi       = $44

; Ball velocity cycle
BallCycle             = $45

; Number of times to move the ball this frame. Used to move the ball faster
; in later speed stages.
; Doesn't get cleared to 0 after a collision, so it could double as a general collision indicator.
BallSpeedMult         = $46

; Current index into the speed table.
SpeedTableIdx         = $47

Ball_1_Angle          = $48

BallSpeedStage        = $49
BallSpeedStageM       = $4a


; $4d - $66 = data for ball 2
; $67 - $80 = data for ball 3

; Flag for which balls are active.
; 7 = all three
; 5 = one and three
; 3 = one and two
; 1 = just one
ActiveBalls        = $81

; Internal-use iterators for how many balls are left to update
BallUpdateItr      = $82
ActiveBallItr      = $83

BlockRamAddrLo     = $84
BlockRamAddrHi     = $85

; General-purpose pointers
; GenPtrALo        = $86
; GenPtrAHi        = $87
; GenPtrBLo        = $88
; GenPtrBHi        = $89
; GenPtrCLo        = $8a
; GenPtrCHi        = $8b

; Powerup data
; Types:
;   0 = None
;   1 = Slow
;   2 = Sticky
;   3 = LargePaddle
;   4 = Multiball
;   5 = Laser
;   6 = Warp
;   7 = Extra Life
SpawnedPowerup     = $8c
PowerupAnimFrame   = $8d
PowerupAnimTimer   = $8e


; Powerup sprite data, doubles as location data for other calculations.
; Copied into sprite memory and tweaked to produce the two halves of the actual sprite.
Powerup_Y          = $91
PowerupTileId      = $92
PowerupSprFlags    = $93
Powerup_X          = $94

; Enemy data
; Up to 3 enemies active at once, all enemies' memory values are individually adjacent
EnemyActive      = $95
; Enemy2Active     = $96
; Enemy3Active     = $97
EnemyDestrFrame  = $98
; Enemy2DestrFrame = $99
; Enemy3DestrFrame = $9a
EnemyExiting     = $9b
; Enemy2Exiting    = $9c
; Enemy3Exiting    = $9d
EnemyMovementType = $9e
; Enemy2MovementType = $9f
; Enemy3MovementType = $a0
EnemyCircleStage  = $a1
; Enemy2CircleStage = $a2
; Enemy3CircleStage = $a3
EnemyCircleHalf   = $a4   ; Which semicircle the enemy is on. 0 = bottom, 1 = top
; Enemy2CircleHalf  = $a5
; Enemy3CircleHalf  = $a6
EnemyCircleDir   = $a7    ; Which direction to circle. 0 = clockwise, 1 = counterclockwise
; Enemy2CircleDir  = $a8
; Enemy3CircleDir  = $a9
EnemyDescendTimer = $aa
; Enemy2DescendTimer = $ab
; Enemy3DescendTimer = $ac
EnemySpawnIndex  = $ad
EnemyY           = $ae
; Enemy2Y          = $af
; Enemy3Y          = $b0
EnemyAnimFrame   = $b1
; Enemy2AnimFrame  = $b2
; Enemy3AnimFrame  = $b3

EnemyX           = $b7
; Enemy2Y          = $b8
; Enemy3Y          = $b9
EnemyMoveDir     = $ba
; Enemy2MoveDir    = $bb
; Enemy3MoveDir    = $bc
EnemyMoveTimer   = $bd
; Enemy2MoveTimer   = $be
; Enemy3MoveTimer   = $bf

; Enemy spawn timers. If the Nth timer has reached 0, up to N enemies
; are allowed to be on the field at once. Furthermore, enemies will
; continue spawning until the maximum is reached.
; Levels may start with one or more timers already at 0 to immediately
; spawn enemies.
EnemySpawnTimerHi   = $c0
EnemySpawnTimerLo   = $c1
; TwoEnemySpawnTimerHi   = $c2
; TwoEnemySpawnTimerLo   = $c3
; ThreeEnemySpawnTimerHi = $c4
; ThreeEnemySpawnTimerLo = $c5

EnemyCircleAddrLo = $cc
EnemyCircleAddrHi = $cd
; Enemy2CircleAddrLo = $ce
; Enemy2CircleAddrHi = $cf
; Enemy2CircleAddrLo = $d0
; Enemy2CircleAddrHi = $d1

EnemyAnimTimer   = $d5
Enemy2AnimTimer  = $d6
Enemy3AnimTimer   = $d7


SpeedStage         = $100
SpeedStageM        = $101
SpeedStageCounter  = $102

; Not used
; _Unused_A          = $103

CeilCollisFlag     = $104

; Number of frames to delay before moving the ball. Used to move the ball slower
; in very early speed stages.
BallSpeedReduction = $105

; Block-relative flags.
; 1 = one block below and to the right
; 2 = one block below
; 4 = one block to the right
; 8 = this block
BlockProximity     = $106
; After a block collision, which of the four nearby blocks was hit.
BlockCollisSide    = $107

; Flags for whether the ball overlaps two cells (i.e. is colliding into a cell).
; low bit = y-overlap
; high bit = x-overlap
BallCellOverlap    = $108

; Flag indicating the game is in a can't-act state after clearing a level or losing the ball.
ActionFrozenFlag  = $109

BlocksPerColumn   = $10a
BlocksPerRow      = $10b

; Intermediate location of logical-cell values.
; Given a pixel position, the normalized (block-coordinate cell) position is written to these.
; They're then copied back to whatever struct needs them (e.g. $3d / $3e for the ball).
CalculatedCellY   = $10c
CalculatedCellX   = $10d

; Sound effect mute counter.
; Suppresses new sounds effects when > 0, decremented each frame.
; Used to give the 1-up ditty center stage for its duration.
MuteSoundEffectsTimer = $10e

EnemyGateState = $10f
EnemyGateIndex = $110
EnemyGateTimer = $111

; Paddle data

PaddleCollisFlag   = $112


PaddleTop_A        = $114
PaddleTop_B        = $115
PaddleTop_C        = $116
PaddleTop_D        = $117
PaddleTop_E        = $118
PaddleTop_F        = $119

PaddleLeftEdge     = $11a
PaddleLeftCenter   = $11b
PaddleLeftCenterM  = $11c
PaddleRightCenter  = $11d
PaddleRightCenterM = $11e
PaddleRightEdge    = $11f


; some kind of paddle state flag
; MiscPaddleStateFlag = $121

IsPaddleWarping    = $123

; Warp state: 0 = inactive, 1 and 2 = active (different animation frames)
; The timer cycles the animation every 3 frames
WarpState          = $124
WarpGateAnimTimer  = $125


IsStickyPaddle     = $128

; Paddle transformation flags
; 1 = normal paddle
; 2 = large paddle
; 4 = lasers
PendingPdlTransf   = $129
PaddleTransf       = $12a

LaserPdlAnimTimer     = $12b
LaserPdlAnimTimerTick = $12c

OwnedPowerup       = $12d

; General-purpose variables, used for a variety of operations.
; GenVar_12e       = $12e
; GenVar_12f       = $12f


IsScorePending      = $134

IsHighScore         = $135


; Timer to auto-launch the ball from the paddle.
AutoLaunchTimer     = $138


LoadingTimer        = $13b


; Flag for whether a powerup was just spawned. (brief)
JustSpawnedPowerup  = $13e

GameStartTimerHi    = $13f
GameStartTimerLo    = $140


BlockCollisFlag     = $145 ; TODO rename to BlockCollisCount


BossHealth          = $166
BossHealthM         = $167


; Sprite data write locations (4 bytes each)
; PaddleA: $0204
; PaddleB: $0208
; PaddleC: $020c
; PaddleD: $0210
; PaddleE: $0214
; PaddleF: $0218
;
; Ball1:    $022c
; Ball2:    $0230
; Ball3:    $0234
;
; PowerupLeftHalf:  $0248
; PowerupRightHalf: $024c

; Paddle sprite data format
; [ y position
;   tile id
;   color and attributes
;   x position ]

; Sprite tile map
;  01 = edge,
;  02-08 = slimmed-down edges (for animations),
;  09 = center,
;  0a = laser edge,
;  0b-11 = slimmed-down laser edges (for animations),
;  12 = laser center
;  13 = destroyed edge
;  14 = destroyed paddle
;  15-1c = powerups
;  1d = laser shot?
;  1e = ball
;  1f = [blank]
;  20-5f = more powerups
;  

; Score data

; High score values
HighScoreTopDigit = $366
HighScoreDigit2   = $367
HighScoreDigit3   = $368
HighScoreDigit4   = $369
HighScoreDigit5   = $36a
HighScoreDigit6   = $36b

; Current score values
ScoreTopDigit     = $370
ScoreDigit2       = $371
ScoreDigit3       = $372
ScoreDigit4       = $373
ScoreDigit5       = $374
ScoreDigit6       = $375

; Pending score
PendingScoreTopDigit = $37c
PendingScoreDigit2   = $37d
PendingScoreDigit3   = $37e
PendingScoreDigit4   = $37f
PendingScoreDigit5   = $380
PendingScoreDigit6   = $381

; Block data
LastBlockHit_YInd = $680
LastBlockHit_XInd = $681
LastBlockHit_Val  = $682

LastBlockDestr_Val= $69a

; Constants
BallStructSize       = #$1a
BallStructSizeDouble = #$34

; Sound effect table
;   1 :
;   2 :
;   3 :
;   4 :
;   5 :
;   6 :
;   7 :
;   8 : paddle expanding
;   9 :
; 0xa : 
; 0xb : warping??
; 0xc :
; 0xd : level intro ditty
; 0xe : extra life ditty
; 0xf : 
; 0x10: boss intro ditty
; 0x11:

;-------------------------------------------------------------------------------
; iNES Header
;-------------------------------------------------------------------------------
            .db "NES", $1A     ; Header
            .db 2              ; 2 x 16k PRG banks
            .db 2              ; 2 x 8k CHR banks
            .db %00110000      ; Mirroring: Horizontal
                               ; SRAM: Not used
                               ; 512k Trainer: Not used
                               ; 4 Screen VRAM: Not used
                               ; Mapper: 3
            .db %00000000      ; RomType: NES
            .hex 00 00 00 00   ; iNES Tail 
            .hex 00 00 00 00    

;-------------------------------------------------------------------------------
; Program Origin
;-------------------------------------------------------------------------------
            .org $8000         ; Set program counter

;-------------------------------------------------------------------------------
; ROM Start
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; reset vector
;-------------------------------------------------------------------------------
reset:      sei                ; $8000: 78        . Disable interrupts
            lda #$40           ; $8001: a9 40     .
            sta $4017          ; $8003: 8d 17 40  | Set APU frame counter to 0x40
            lda #$10           ; $8006: a9 10     .
            sta $2000          ; $8008: 8d 00 20  | Write PPU control reg 1: 0x10 = 00010000 -> screen pattern table address = $1000
            lda #$06           ; $800b: a9 06     .
            sta $2001          ; $800d: 8d 01 20  | Write PPU control reg 2: 0x6 = 00000110 = keep left 8 columns blank
            lda #$00           ; $8010: a9 00     .
            sta $2002          ; $8012: 8d 02 20  | Write PPU status reg: 0x0
VBlank_Loop1: lda $2002        ; $8015: ad 02 20  .
            and #$80           ; $8018: 29 80     |
            beq VBlank_Loop1   ; $801a: f0 f9     | Loop until VBlank flag set
            lda #$00           ; $801c: a9 00     .
            sta $2002          ; $801e: 8d 02 20  | Clear VBlank
VBlank_Loop2: lda $2002        ; $8021: ad 02 20  .
            and #$80           ; $8024: 29 80     |
            beq VBlank_Loop2   ; $8026: f0 f9     | Loop until VBlank flag set
            lda #$00           ; $8028: a9 00     .
            sta $2002          ; $802a: 8d 02 20  | Clear VBlank
VBlank_Loop3: lda $2002        ; $802d: ad 02 20  .
            and #$80           ; $8030: 29 80     |
            beq VBlank_Loop3   ; $8032: f0 f9     | Loop until VBlank flag set
            ldx #$00           ; $8034: a2 00     . 
            lda #$00           ; $8036: a9 00     | 
ClearMem_8038: sta $00,x       ; $8038: 95 00     | 
            inx                ; $803a: e8        |
            bne ClearMem_8038  ; $803b: d0 fb     | Clear out $0000 - $00FF with 0
ClearMem_803d: sta $0100,x     ; $803d: 9d 00 01  .
            inx                ; $8040: e8        | 
            bne ClearMem_803d  ; $8041: d0 fa     | Clear out $0100 - $01FF with 0
            ldx #$ff           ; $8043: a2 ff     .
            txs                ; $8045: 9a        | Push 0xFF onto the stack
            ldx #$00           ; $8046: a2 00     . 
Loop_8048:  lda __808f,x       ; $8048: bd 8f 80  | --Warm boot check--
            cmp $0360,x        ; $804b: dd 60 03  | 
            bne DoCopy_8058    ; $804e: d0 08     | 
            inx                ; $8050: e8        |
            cpx #$06           ; $8051: e0 06     | If the (first 6) contents of __808f aren't
            bne Loop_8048      ; $8053: d0 f3     | in $0360 - $036b yet, go write them
            jmp PostInitSetup  ; $8055: 4c 65 80  . Continue with setup

;-------------------------------------------------------------------------------
DoCopy_8058: ldx #$00          ; $8058: a2 00     .
Loop_805a:  lda __808f,x       ; $805a: bd 8f 80  |
            sta $0360,x        ; $805d: 9d 60 03  |
            inx                ; $8060: e8        |
            cpx #$0c           ; $8061: e0 0c     | 
            bne Loop_805a      ; $8063: d0 f5     | Copy __808f values into $0360 - $036b
PostInitSetup: ldx #$00        ; $8065: a2 00     .
            lda #$00           ; $8067: a9 00     |
ClearMem_8069: sta $0370,x     ; $8069: 9d 70 03  |
            inx                ; $806c: e8        |
            cpx #$80           ; $806d: e0 80     | 
            bne ClearMem_8069  ; $806f: d0 f8     | Clear out $0370 - $03ef with 0
            jsr SetupSound     ; $8071: 20 c0 f3  . Go set up sound registers
            lda #$10           ; $8074: a9 10     .
            sta _PPU_Ctrl1_Mirror ; $8076: 85 14  | Mirror PPU ctrl reg 1 setting (0x10)
            lda #$06           ; $8078: a9 06     .
            sta _PPU_Ctrl2_Mirror ; $807a: 85 15  | Store future PPU 2 control reg setting: reg 2: 0x6 = 00000110 = keep left 8 columns blank
            lda #$2e           ; $807c: a9 2e     . Set Famicom control register = 0x2e = 00101110 = drive motor on, drive head on start of first track,
            sta $4025          ; $807e: 8d 25 40  |   disable disk write, horizontal screen mirroring, disable disk IRQs
            lda _PPU_Ctrl1_Mirror ; $8081: a5 14  .
            ora #$90           ; $8083: 09 90     |
            sta $2000          ; $8085: 8d 00 20  | Write PPU control reg 1: 0x10 = 00010000 -> screen pattern table address = $1000
Loop_8088:  nop                ; $8088: ea        .
            nop                ; $8089: ea        |
            nop                ; $808a: ea        |
            jmp Loop_8088      ; $808b: 4c 88 80  | Infinite loop

;-------------------------------------------------------------------------------
            rts                ; $808e: 60        

;-------------------------------------------------------------------------------
__808f:     .hex 11 33 55 77 99 aa
            .hex 00 05 00 00 00 00

;-------------------------------------------------------------------------------
; irq/brk vector
;-------------------------------------------------------------------------------
irq:        cli                ; $809b: 58        . clear interrupt flag
            rti                ; $809c: 40        . return from interrupt

;-------------------------------------------------------------------------------
            .hex 00 00 00

;-------------------------------------------------------------------------------
; nmi vector
;-------------------------------------------------------------------------------
nmi:        lda $2002          ; $80a0: ad 02 20  . Load PPU status register
            lda _PPU_Ctrl1_Mirror ; $80a3: a5 14  .
            and #$7f           ; $80a5: 29 7f     |
            sta $2000          ; $80a7: 8d 00 20  | Clear VBlank Enable bit (don't generate VBlank interrupts)
            lda _HScrollOffset ; $80aa: a5 17     .
            sta $2005          ; $80ac: 8d 05 20  | Set horizontal scroll offset to 0 (implicitly)
            lda _VScrollOffset ; $80af: a5 16     .
            sta $2005          ; $80b1: 8d 05 20  | Set vertical scroll offset
            jsr ResetSprites   ; $80b4: 20 58 8c  . Reset sprite memory
            lda LoadingTimer   ; $80b7: ad 3b 01  .
            bne Next_811c      ; $80ba: d0 60     | If loading, skip a bunch of processing
            jsr InitPowerupSpritePalette ; $80bc: 20 1b 92  
            jsr RefreshMiscState ; $80bf: 20 63 8c . go update misc. stuff based on what changed the previous frame
            jsr __bd21         ; $80c2: 20 21 bd  
            jsr __bca7         ; $80c5: 20 a7 bc  
            jsr __bda9         ; $80c8: 20 a9 bd  
            jsr ProcessGameState ; $80cb: 20 dd 92  
            jsr ProcessInput   ; $80ce: 20 e3 8b  
            jsr UpdateScore    ; $80d1: 20 c3 8d  
            jsr UpdateWarpState ; $80d4: 20 64 85  
            jsr CheckPowerupCanSpawn ; $80d7: 20 45 83
            jsr __8429         ; $80da: 20 29 84  
            jsr __bb2f         ; $80dd: 20 2f bb  
            jsr __91e1         ; $80e0: 20 e1 91  
            jsr UpdateLgPdlAnim; $80e3: 20 75 91  
            jsr __906c         ; $80e6: 20 6c 90  
            jsr UpdateLaserPdlAnim ; $80e9: 20 f0 90  
            jsr UpdateEnemies  ; $80ec: 20 8d be  
            jsr __88ff         ; $80ef: 20 ff 88  
            jsr CheckPaddleCollisWithEnemy ; $80f2: 20 a4 89  
            jsr UpdatePowerup  ; $80f5: 20 b1 ba  
            jsr UpdateBallSprites ; $80f8: 20 90 b9  
            jsr UpdatePaddleSprites ; $80fb: 20 0e ba  
            jsr __b94b         ; $80fe: 20 4b b9
            jsr CheckLaunchBall; $8101: 20 38 81  
            jsr CheckPaddleMove; $8104: 20 66 81  
            jsr UpdateActiveBalls ; $8107: 20 14 a7  
            jsr CheckBallSticksToPaddle ; $810a: 20 33 82  
            jsr CheckPowerupCanBeCollected ; $810d: 20 4d 82  
            jsr __880d         ; $8110: 20 0d 88   ; UpdateCalculatedCellPos??
            jsr __89fa         ; $8113: 20 fa 89  
            jsr CheckPauseUnpause ; $8116: 20 e0 85
            jsr CheckRemainingBallsBlocks ; $8119: 20 27 86  . Also includes level-skip cheat check
Next_811c:  jsr __f3c9         ; $811c: 20 c9 f3  
            jsr UpdateTimers   ; $811f: 20 a4 86  
            lda _HScrollOffset ; $8122: a5 17     .
            sta $2005          ; $8124: 8d 05 20  |
            lda _VScrollOffset ; $8127: a5 16     |
            sta $2005          ; $8129: 8d 05 20  | Update horizontal and vertical scrolling
            nop                ; $812c: ea        .
            nop                ; $812d: ea        |
            nop                ; $812e: ea        | wait a few cycles
            lda _PPU_Ctrl1_Mirror ; $812f: a5 14  .
            ora #$90           ; $8131: 09 90     |
            sta $2000          ; $8133: 8d 00 20  | Re-enable VBlank interrupts (top bit), also set screen pattern table to $1000 (4th bit)
            cli                ; $8136: 58        . Clear interrupt
            rti                ; $8137: 40        . Return from interrupt

;-------------------------------------------------------------------------------
CheckLaunchBall:
            lda AutoLaunchFlag ; $8138: a5 0c     .
            bne DoBallLaunch   ; $813a: d0 11     | if the auto-launch flag is set, launch the ball
            lda GameState      ; $813c: a5 0a     .
            cmp #$08           ; $813e: c9 08     |
            bne Ret_814c       ; $8140: d0 0a     | if game state == 8 (ball inactive),
            lda ButtonsM       ; $8142: a5 04       .
            eor PrevButtonsM   ; $8144: 45 05       |
            and ButtonsM       ; $8146: 25 04       | 
            cmp #$80           ; $8148: c9 80       |
            beq DoBallLaunch   ; $814a: f0 01       | if the A button was just pressed, launch the ball
Ret_814c:   rts                ; $814c: 60        . return

;-------------------------------------------------------------------------------
DoBallLaunch:
            lda #$00           ; $814d: a9 00     .
            sta AutoLaunchTimer; $814f: 8d 38 01  |
            sta AutoLaunchFlag ; $8152: 85 0c     | Clear auto-launch timer and flag
            sta $013c          ; $8154: 8d 3c 01  
            sta $013d          ; $8157: 8d 3d 01  
            sta BallCycle      ; $815a: 85 45     . Reset ball cycle
            lda #$01           ; $815c: a9 01     .
            jsr PlaySoundEffect; $815e: 20 c6 f3  | Play sound effect 1
            lda #$10           ; $8161: a9 10     .
            sta GameState      ; $8163: 85 0a     | Set game state to ball-active
            rts                ; $8165: 60        

;-------------------------------------------------------------------------------
CheckPaddleMove:
            lda ActiveBalls    ; $8166: a5 81     .
            bne Next_816b      ; $8168: d0 01     |
            rts                ; $816a: 60        | Confirm there are active balls around

;-------------------------------------------------------------------------------
Next_816b:  lda IsPaddleWarping; $816b: ad 23 01  
            beq Next_8171      ; $816e: f0 01     
            rts                ; $8170: 60        

;-------------------------------------------------------------------------------
Next_8171:  lda GameState      ; $8171: a5 0a     .
            cmp #$20           ; $8173: c9 20     |
            bne Next_8178      ; $8175: d0 01     |
            rts                ; $8177: 60        | if not paused, continue

;-------------------------------------------------------------------------------
Next_8178:  lda $0122          ; $8178: ad 22 01  
            beq Next_817e      ; $817b: f0 01     
            rts                ; $817d: 60        

;-------------------------------------------------------------------------------
Next_817e:  lda CurrentBlocks  ; $817e: a5 0f     .
            bne Next_8183      ; $8180: d0 01     |
            rts                ; $8182: 60        | if there are blocks left, continue

;-------------------------------------------------------------------------------
Next_8183:  sec                ; $8183: 38        .
            lda Ball_1_X       ; $8184: a5 38     |
            sbc PaddleLeftEdge ; $8186: ed 1a 01  |
            sta $012e          ; $8189: 8d 2e 01  | $012e = ball x - paddle left edge
            lda IsDemo         ; $818c: a5 10     .
            beq Next_819e      ; $818e: f0 0e     | if this is the demo,
            sec                ; $8190: 38           .
            lda Ball_1_X       ; $8191: a5 38        |
            sbc #$10           ; $8193: e9 10        | load [a] = ball x - 0x10
            cmp #$10           ; $8195: c9 10        .
            bcs Next_81a2      ; $8197: b0 09        |
            lda #$10           ; $8199: a9 10        |
            jmp Next_81a2      ; $819b: 4c a2 81     | ensure the result [a] is at least 0x10

;-------------------------------------------------------------------------------
Next_819e:  lda $08            ; $819e: a5 08     .
            beq Next_81ae      ; $81a0: f0 0c     | if $08 has a value (or this is the continuation of the above demo case)
Next_81a2:  sec                ; $81a2: 38        .
            sbc PaddleLeftEdge ; $81a3: ed 1a 01  |
            beq Ret_81c8       ; $81a6: f0 20     | if [a] - paddle left edge == 0, return
            sta $0131          ; $81a8: 8d 31 01  . else set the paddle delta to the difference
            jmp DoPaddleMove   ; $81ab: 4c c9 81  . go move the paddle

;-------------------------------------------------------------------------------
Next_81ae:  lda #$fd           ; $81ae: a9 fd     .
            sta $0131          ; $81b0: 8d 31 01  | Set paddle delta -3
            lda ButtonsM       ; $81b3: a5 04     .
            and #$03           ; $81b5: 29 03     |
            cmp #$02           ; $81b7: c9 02     |
            beq DoPaddleMove   ; $81b9: f0 0e     | If left button pressed, move the paddle
            lda #$03           ; $81bb: a9 03     .
            sta $0131          ; $81bd: 8d 31 01  | Set paddle delta 3
            lda ButtonsM       ; $81c0: a5 04     .
            and #$03           ; $81c2: 29 03     |
            cmp #$01           ; $81c4: c9 01     |
            beq DoPaddleMove   ; $81c6: f0 01     | If right button pressed, move the paddle
Ret_81c8:   rts                ; $81c8: 60        . return

;-------------------------------------------------------------------------------
DoPaddleMove:
            clc                ; $81c9: 18        .
            lda PaddleLeftEdge ; $81ca: ad 1a 01  |
            adc $0131          ; $81cd: 6d 31 01  |
            cmp #$10           ; $81d0: c9 10     |
            bcs Next_81e6      ; $81d2: b0 12     | if paddle left edge + delta >= 0x10, move on
            sec                ; $81d4: 38        .
            sbc #$10           ; $81d5: e9 10     |
            eor #$ff           ; $81d7: 49 ff     |
            clc                ; $81d9: 18        |
            adc #$01           ; $81da: 69 01     |
            clc                ; $81dc: 18        |
            adc $0131          ; $81dd: 6d 31 01  |
            sta $0131          ; $81e0: 8d 31 01  | else clamp calc result to 0x10
            jmp Next_8200      ; $81e3: 4c 00 82  . continue

;-------------------------------------------------------------------------------
Next_81e6:  clc                ; $81e6: 18        .
            lda PaddleRightEdge; $81e7: ad 1f 01  |
            adc $0131          ; $81ea: 6d 31 01  |
            cmp #$b8           ; $81ed: c9 b8     |
            bcc Next_8200      ; $81ef: 90 0f     | if paddle right edge + delta < 0xb8, move on
            sec                ; $81f1: 38        .
            sbc #$b8           ; $81f2: e9 b8     |
            eor #$ff           ; $81f4: 49 ff     |
            clc                ; $81f6: 18        |
            adc #$01           ; $81f7: 69 01     |
            clc                ; $81f9: 18        |
            adc $0131          ; $81fa: 6d 31 01  |
            sta $0131          ; $81fd: 8d 31 01  | else clamp calc result to 0xb8
Next_8200:  ldx #$00           ; $8200: a2 00     .
Loop_8202:  clc                ; $8202: 18        |
            lda $011a,x        ; $8203: bd 1a 01  |
            adc $0131          ; $8206: 6d 31 01  |
            sta $011a,x        ; $8209: 9d 1a 01  |
            inx                ; $820c: e8        |
            cpx #$06           ; $820d: e0 06     |
            bne Loop_8202      ; $820f: d0 f1     | Move paddle by delta amount
            lda GameState      ; $8211: a5 0a     .
            cmp #$08           ; $8213: c9 08     |
            bne Ret_8232       ; $8215: d0 1b     | if game state == 8 (ball not launched)
            clc                ; $8217: 18          .
            lda PaddleLeftEdge ; $8218: ad 1a 01    |
            adc $012e          ; $821b: 6d 2e 01    |
            sta Ball_1_X       ; $821e: 85 38       | Set ball x = paddle left edge + $012e
            cmp #$10           ; $8220: c9 10       .
            bcs Next_8229      ; $8222: b0 05       |
            lda #$10           ; $8224: a9 10       |
            sta Ball_1_X       ; $8226: 85 38       | if ball x < 0x10, ball x = 0x10
            rts                ; $8228: 60        . return

;-------------------------------------------------------------------------------
Next_8229:  cmp #$bc           ; $8229: c9 bc     .
            bcc Ret_8232       ; $822b: 90 05     |
            lda #$bc           ; $822d: a9 bc     |
            sta Ball_1_X       ; $822f: 85 38     | if ball x > 0xbc, ball x = 0xbc
            rts                ; $8231: 60        . return

;-------------------------------------------------------------------------------
Ret_8232:   rts                ; $8232: 60        . return

;-------------------------------------------------------------------------------
CheckBallSticksToPaddle:
            lda GameState      ; $8233: a5 0a     .
            cmp #$10           ; $8235: c9 10     |
            bne Ret_824c       ; $8237: d0 13     | if game state == 0x10 (ball active)
            lda PaddleCollisFlag ; $8239: ad 12 01  .
            beq Ret_824c       ; $823c: f0 0e       | if there's a paddle collision
            lda IsStickyPaddle ; $823e: ad 28 01      .
            beq Ret_824c       ; $8241: f0 09         | if the paddle is sticky
            lda #$08           ; $8243: a9 08           .
            sta GameState      ; $8245: 85 0a           | Set game state to 8 (ball not active)
            lda #$80           ; $8247: a9 80           .
            sta AutoLaunchTimer; $8249: 8d 38 01        | Set auto-launch timer to 0x80
Ret_824c:   rts                ; $824c: 60        . return

;-------------------------------------------------------------------------------
CheckPowerupCanBeCollected:
            lda ActiveBalls    ; $824d: a5 81     .
            bne AtLeastOneBall_8252 ; $824f: d0 01|
            rts                ; $8251: 60        | Confirm there are active balls around

;-------------------------------------------------------------------------------
AtLeastOneBall_8252:
            lda SpawnedPowerup ; $8252: a5 8c     .
            bne PowerupExists_8257 ; $8254: d0 01 |
            rts                ; $8256: 60        | Confirm there's a powerup around

;-------------------------------------------------------------------------------
PowerupExists_8257:
            lda Powerup_Y      ; $8257: a5 91        .
            clc                ; $8259: 18           |
            adc #$08           ; $825a: 69 08        |
            cmp PaddleTop_A    ; $825c: cd 14 01     |
            bcs PowerupCanBeCollected ; $825f: b0 01 |
            rts                ; $8261: 60           | Confirm powerup y + 8 >= paddle top

;-------------------------------------------------------------------------------
PowerupCanBeCollected:
            clc                ; $8262: 18        .
            lda PaddleTop_A    ; $8263: ad 14 01  |
            adc #$04           ; $8266: 69 04     |
            cmp Powerup_Y      ; $8268: c5 91     |
            bcc Ret_82cc       ; $826a: 90 60     | if paddle top + 4 >= powerup y
            lda Powerup_X      ; $826c: a5 94       .
            clc                ; $826e: 18          |
            adc #$08           ; $826f: 69 08       |
            cmp PaddleLeftEdge ; $8271: cd 1a 01    |
            bcc Ret_82cc       ; $8274: 90 56       | if powerup x + 8 >= paddle left edge
            clc                ; $8276: 18            .
            lda PaddleRightEdge ; $8277: ad 1f 01     |
            adc #$08           ; $827a: 69 08         |
            sta $0131          ; $827c: 8d 31 01      |
            clc                ; $827f: 18            |
            lda Powerup_X      ; $8280: a5 94         |
            adc #$08           ; $8282: 69 08         |
            cmp $0131          ; $8284: cd 31 01      |
            bcs Ret_82cc       ; $8287: b0 43         | if powerup x + 8 < paddle right edge + 8
            lda SpawnedPowerup ; $8289: a5 8c           .
            pha                ; $828b: 48              | push spawned powerup onto the stack
            lda #$00           ; $828c: a9 00           .
            sta SpawnedPowerup ; $828e: 85 8c           | clear spawned powerup
            sta IsStickyPaddle ; $8290: 8d 28 01        . clear sticky paddle flag
            sta $d9            ; $8293: 85 d9     
            sta $d8            ; $8295: 85 d8     
            lda AutoLaunchTimer; $8297: ad 38 01        .
            beq Next_82a1      ; $829a: f0 05           |
            lda #$01           ; $829c: a9 01           |
            sta AutoLaunchTimer; $829e: 8d 38 01        | if the ball's on the paddle, auto-launch it next frame
Next_82a1:  lda #$eb           ; $82a1: a9 eb           .
            sta $88            ; $82a3: 85 88           |
            lda #$83           ; $82a5: a9 83           |
            sta $89            ; $82a7: 85 89           | Load input address $83eb
            jsr AddPendingScore; $82a9: 20 56 90        . Add the powerup score to the pending score value
            pla                ; $82ac: 68              .
            sta OwnedPowerup   ; $82ad: 8d 2d 01        | Write powerup from stack into "owned" slot
            cmp #$01           ; $82b0: c9 01           .
            beq GetSlowPowerup ; $82b2: f0 19           | if it's 1, activate slow powerup
            cmp #$02           ; $82b4: c9 02           .
            beq GetStickyPowerup ; $82b6: f0 3c         | if it's 2, activate sticky powerup
            cmp #$03           ; $82b8: c9 03           .
            beq GetLgPdlPowerup ; $82ba: f0 43          | if it's 3, activate large-paddle powerup
            cmp #$04           ; $82bc: c9 04           .
            beq GetMultiBallPowerup ; $82be: f0 50      | if it's 4, activate multiball powerup
            cmp #$05           ; $82c0: c9 05           .
            beq GetLaserPowerup ; $82c2: f0 55          | if it's 5, activate laser powerup
            cmp #$06           ; $82c4: c9 06           .
            beq GetWarpPowerup ; $82c6: f0 57           | if it's 6, activate warp powerup
            cmp #$07           ; $82c8: c9 07           .
            beq GetLifePowerup ; $82ca: f0 63           | if it's 7, activate extra life powerup
Ret_82cc:   rts                ; $82cc: 60        . return

;-------------------------------------------------------------------------------
GetSlowPowerup:
            lda #$01           ; $82cd: a9 01     .
            sta PendingPdlTransf ; $82cf: 8d 29 01| Queue up a transform-to-normal-paddle change
            dec SpeedStage     ; $82d2: ce 00 01  .
            beq Next_82dc      ; $82d5: f0 05     | if the speed stage is 0, set to 1
            dec SpeedStage     ; $82d7: ce 00 01  . Decrement speed stage
            bne Next_82df      ; $82da: d0 03     .
Next_82dc:  inc SpeedStage     ; $82dc: ee 00 01  | if the speed stage is 0, set to 1
Next_82df:  ldx SpeedStage     ; $82df: ae 00 01  .
            stx SpeedStageM    ; $82e2: 8e 01 01  |
            stx BallSpeedStage ; $82e5: 86 49     |
            stx BallSpeedStageM; $82e7: 86 4a     | copy speed stage values to mirrors
            lda __SpeedStageThresholds,x ; $82e9: bd 8f 99 .
            sta SpeedStageCounter ; $82ec: 8d 02 01        | re-initialize speed stage counter
            lda #$00           ; $82ef: a9 00     .
            sta BallCycle      ; $82f1: 85 45     | reset ball cycle
            rts                ; $82f3: 60        . return

;-------------------------------------------------------------------------------
GetStickyPowerup:
            lda #$01           ; $82f4: a9 01     .
            sta PendingPdlTransf ; $82f6: 8d 29 01| Queue up a transform-to-normal-paddle change
            lda #$01           ; $82f9: a9 01     .
            sta IsStickyPaddle ; $82fb: 8d 28 01  | Set paddle state = sticky
            rts                ; $82fe: 60        . return

;-------------------------------------------------------------------------------
GetLgPdlPowerup:
            lda #$02           ; $82ff: a9 02           .
            sta PendingPdlTransf ; $8301: 8d 29 01      | Queue up a transform-to-large-paddle change
            lda MuteSoundEffectsTimer ; $8304: ad 0e 01 .
            beq Next_830a      ; $8307: f0 01           | if we're not muting sound effects, continue
            rts                ; $8309: 60              . return

;-------------------------------------------------------------------------------
Next_830a:  lda #$08           ; $830a: a9 08     .
            jsr PlaySoundEffect; $830c: 20 c6 f3  |
            rts                ; $830f: 60        | Play sound effect 8 (paddle expanding)

;-------------------------------------------------------------------------------
GetMultiBallPowerup:
            lda #$01           ; $8310: a9 01      .
            sta PendingPdlTransf ; $8312: 8d 29 01 | Queue up a transform-to-normal-paddle change
            jsr SpawnMultiBall ; $8315: 20 c2 8e  
            rts                ; $8318: 60        

;-------------------------------------------------------------------------------
GetLaserPowerup:
            lda #$04           ; $8319: a9 04      .
            sta PendingPdlTransf ; $831b: 8d 29 01 | Queue up a transform-to-laser-paddle change
            rts                ; $831e: 60        

;-------------------------------------------------------------------------------
GetWarpPowerup:
            lda #$01           ; $831f: a9 01      .
            sta PendingPdlTransf ; $8321: 8d 29 01 | Queue up a transform-to-normal-paddle change
            lda #$00           ; $8324: a9 00       .
            sta WarpGateAnimTimer ; $8326: 8d 25 01 | init the warp gate animation timer
            lda #$01           ; $8329: a9 01       .
            sta WarpState      ; $832b: 8d 24 01    | enable the warp gate
            rts                ; $832e: 60          . return

;-------------------------------------------------------------------------------
GetLifePowerup:
            lda #$01           ; $832f: a9 01      .
            sta PendingPdlTransf ; $8331: 8d 29 01 | Queue up a transform-to-normal-paddle change 
            lda IsDemo         ; $8334: a5 10      .
            bne Ret_8344       ; $8336: d0 0c      | don't collect if this is the demo
            inc NumLives       ; $8338: e6 0d      . Increment lives
            lda #$0e           ; $833a: a9 0e      .
            jsr PlaySoundEffect; $833c: 20 c6 f3   | Play sound effect 0xe (extra life ditty)
            lda #$26           ; $833f: a9 26           .
            sta MuteSoundEffectsTimer ; $8341: 8d 0e 01 | Suppress other sound effects for 0x26 frames
Ret_8344:   rts                ; $8344: 60              . return

;-------------------------------------------------------------------------------
CheckPowerupCanSpawn:
            lda ActiveBalls    ; $8345: a5 81   .
            cmp #$01           ; $8347: c9 01   |
            beq CheckBlocks_834c ; $8349: f0 01 |
            rts                ; $834b: 60      | Confirm there's exactly one ball around

;-------------------------------------------------------------------------------
CheckBlocks_834c:
            lda CurrentBlocks  ; $834c: a5 0f      .
            bne CheckSpPowerup_8351 ; $834e: d0 01 | 
            rts                ; $8350: 60         | don't do powerup spawning if there aren't any blocks left

;-------------------------------------------------------------------------------
CheckSpPowerup_8351:
            lda SpawnedPowerup ; $8351: a5 8c     .
            beq NoPowerup_8356 ; $8353: f0 01     |
            rts                ; $8355: 60        | don't do powerup spawning if there's one on the field already

;-------------------------------------------------------------------------------
NoPowerup_8356:
            lda #$00           ; $8356: a9 00     
            sta PowerupAnimFrame; $8358: 85 8d     
            lda #$f1           ; $835a: a9 f1     
            sta $8f            ; $835c: 85 8f     
            lda #$83           ; $835e: a9 83     
            sta $90            ; $8360: 85 90     
            ldx #$00           ; $8362: a2 00     .
            lda BlockCollisFlag; $8364: ad 45 01  |
            sta $0131          ; $8367: 8d 31 01  |
Loop_836a:  lda $0131          ; $836a: ad 31 01  |
            beq Ret_83e4       ; $836d: f0 75     | for each block collision
            lda $0682,x        ; $836f: bd 82 06    .
            and #$08           ; $8372: 29 08       |
            bne GenPowerup     ; $8374: d0 09       | if the block can spawn a powerup, spawn one
            inx                ; $8376: e8          .
            inx                ; $8377: e8          |
            inx                ; $8378: e8          | Advance pointer to next block
            dec $0131          ; $8379: ce 31 01  .
            jmp Loop_836a      ; $837c: 4c 6a 83  | loop

;-------------------------------------------------------------------------------
GenPowerup: lda $0680,x        ; $837f: bd 80 06  .
            asl                ; $8382: 0a        |
            asl                ; $8383: 0a        |
            asl                ; $8384: 0a        |
            clc                ; $8385: 18        |
            adc #$10           ; $8386: 69 10     |
            sta Powerup_Y      ; $8388: 85 91     | Set powerup y = (block y * 8) + 0x10
            lda $0681,x        ; $838a: bd 81 06  .
            asl                ; $838d: 0a        |
            asl                ; $838e: 0a        |
            asl                ; $838f: 0a        |
            asl                ; $8390: 0a        |
            clc                ; $8391: 18        |
            adc #$10           ; $8392: 69 10     |
            sta Powerup_X      ; $8394: 85 94     | Set powerup x = (block x * 16) + 0x10
GenRandPowerup: jsr _RandNum   ; $8396: 20 59 92  . Go get an rn
            ldx #$00           ; $8399: a2 00     . for x == 1..6
Loop_839b:  cmp __83e5,x       ; $839b: dd e5 83      .
            beq GenSpecialPowerup ; $839e: f0 17      | If the rn is a perfect match, generate a special powerup
            inx                ; $83a0: e8        .
            cpx #$06           ; $83a1: e0 06     |
            bne Loop_839b      ; $83a3: d0 f6     | loop
            and #$07           ; $83a5: 29 07       .
            beq TrySpawnLgPdlPowerup ; $83a7: f0 09 | if rn & 7 == 0 spawn a large-paddle powerup (instead of an extra life)
            cmp #$06           ; $83a9: c9 06       .
            bcc TrySpawnPowerup; $83ab: 90 16       | if (rn & 7) < 6, spawn whatever powerup is indicated by (rn & 7)
            lda #$04           ; $83ad: a9 04       .
            jmp TrySpawnPowerup; $83af: 4c c3 83    | else spawn a multiball (instead of a warp)

;-------------------------------------------------------------------------------
TrySpawnLgPdlPowerup:
            lda #$03           ; $83b2: a9 03     .
            jmp TrySpawnPowerup; $83b4: 4c c3 83  | spawn a large-paddle powerup

;-------------------------------------------------------------------------------
GenSpecialPowerup:
            lda #$07           ; $83b7: a9 07      .
            cpx #$03           ; $83b9: e0 03      |
            bcc TrySpawnPowerup; $83bb: 90 06      | if x < 3 (took less than 4 tries), spawn a 1-up powerup
            lda IsDemo         ; $83bd: a5 10      .
            bne TrySpawnLgPdlPowerup; $83bf: d0 f1 | else if this is the demo, turn it into a large-paddle powerup
            lda #$06           ; $83c1: a9 06      . else it's a warp powerup
TrySpawnPowerup: cmp OwnedPowerup; $83c3: cd 2d 01 .
            beq GenRandPowerup ; $83c6: f0 ce      | if we already have this powerup, go generate a new one
            sta SpawnedPowerup ; $83c8: 85 8c      . activate powerup
            sec                ; $83ca: 38           
            sbc #$01           ; $83cb: e9 01     
            asl                ; $83cd: 0a        
            asl                ; $83ce: 0a        
            asl                ; $83cf: 0a        
            clc                ; $83d0: 18        
            adc $8f            ; $83d1: 65 8f     
            sta $8f            ; $83d3: 85 8f     
            lda $90            ; $83d5: a5 90     
            adc #$00           ; $83d7: 69 00     
            sta $90            ; $83d9: 85 90     
            lda #$03           ; $83db: a9 03     .
            sta PowerupSprFlags; $83dd: 85 93     | Init powerup sprite flags (palette = 3, no special attribs)
            lda #$01           ; $83df: a9 01       .
            sta JustSpawnedPowerup ; $83e1: 8d 3e 01| set just-spawned-a-powerup flag
Ret_83e4:   rts                ; $83e4: 60        . return

;-------------------------------------------------------------------------------
__83e5:     .hex 07 df 3d b9 1b 5e

___PowerupScore:
__83eb:     .hex 00 00 01 00 00 00

            .hex 22 24 26 20 28 2a ff 00
            .hex 2c 2e 30 20 32 34 ff 00
            .hex 36 38 3a 20 3c 3e ff 00
            .hex 40 42 44 20 46 48 ff 00
            .hex 4a 4c 4e 20 50 52 ff 00
            .hex 54 56 58 20 5a 5c ff 00
            .hex 5e 15 17 20 19 1b ff 00

__8429:     lda GameState      ; $8429: a5 0a     
            cmp #$10           ; $842b: c9 10     
            bne __8450         ; $842d: d0 21     
            lda ActiveBalls    ; $842f: a5 81     
            beq __8450         ; $8431: f0 1d     
            lda CurrentBlocks  ; $8433: a5 0f     
            beq __8450         ; $8435: f0 19     
            lda BlockCollisFlag; $8437: ad 45 01  
            sta $012e          ; $843a: 8d 2e 01  
            ldx #$00           ; $843d: a2 00     
__843f:     lda $012e          ; $843f: ad 2e 01  
            beq __8450         ; $8442: f0 0c     
            jsr __8454         ; $8444: 20 54 84  
            inx                ; $8447: e8        
            inx                ; $8448: e8        
            inx                ; $8449: e8        
            dec $012e          ; $844a: ce 2e 01  
            jmp __843f         ; $844d: 4c 3f 84  

;-------------------------------------------------------------------------------
__8450:     jsr __84d8         ; $8450: 20 d8 84  
            rts                ; $8453: 60        

;-------------------------------------------------------------------------------
__8454:     lda $0680,x        ; $8454: bd 80 06  .
            asl                ; $8457: 0a        |
            asl                ; $8458: 0a        |
            asl                ; $8459: 0a        |
            clc                ; $845a: 18        |
            adc #$0f           ; $845b: 69 0f     |
            sta $0131          ; $845d: 8d 31 01  | set $0131 = last-hit block y (in pixels)
            lda $0681,x        ; $8460: bd 81 06  
            asl                ; $8463: 0a        
            asl                ; $8464: 0a        
            asl                ; $8465: 0a        
            asl                ; $8466: 0a        
            clc                ; $8467: 18        
            .hex 69            ; $8468: 69        Suspected data

__8469:     .hex 10 8d 32 01 a9 06 8d 2f 01 a0 00

__8474:     lda $0190,y        ; $8474: b9 90 01  
            beq __849b         ; $8477: f0 22     
            lda $0131          ; $8479: ad 31 01  
            cmp $0192,y        ; $847c: d9 92 01  
            bne __849b         ; $847f: d0 1a     
            lda $0132          ; $8481: ad 32 01  
            cmp $0193,y        ; $8484: d9 93 01  
            bne __849b         ; $8487: d0 12     
            lda $0682,x        ; $8489: bd 82 06  
            cmp #$f0           ; $848c: c9 f0     
            beq __84b7         ; $848e: f0 27     
            lda #$06           ; $8490: a9 06     
            sta $0190,y        ; $8492: 99 90 01  
            lda #$00           ; $8495: a9 00     
            sta $0191,y        ; $8497: 99 91 01  
            rts                ; $849a: 60        

;-------------------------------------------------------------------------------
__849b:     iny                ; $849b: c8        
            iny                ; $849c: c8        
            iny                ; $849d: c8        
            iny                ; $849e: c8        
            dec $012f          ; $849f: ce 2f 01  
            bne __8474         ; $84a2: d0 d0     
            lda #$06           ; $84a4: a9 06     
            sta $012f          ; $84a6: 8d 2f 01  
            ldy #$00           ; $84a9: a0 00     
__84ab:     lda $0190,y        ; $84ab: b9 90 01  
            bne __84ce         ; $84ae: d0 1e     
            lda $0682,x        ; $84b0: bd 82 06  
            cmp #$f0           ; $84b3: c9 f0     
            bne __84ce         ; $84b5: d0 17     
__84b7:     lda #$01           ; $84b7: a9 01     
            sta $0190,y        ; $84b9: 99 90 01  
            lda #$00           ; $84bc: a9 00     
            sta $0191,y        ; $84be: 99 91 01  
            lda $0131          ; $84c1: ad 31 01  
            sta $0192,y        ; $84c4: 99 92 01  
            lda $0132          ; $84c7: ad 32 01  
            sta $0193,y        ; $84ca: 99 93 01  
            rts                ; $84cd: 60        

;-------------------------------------------------------------------------------
__84ce:     iny                ; $84ce: c8        
            iny                ; $84cf: c8        
            iny                ; $84d0: c8        
            iny                ; $84d1: c8        
            dec $012f          ; $84d2: ce 2f 01  
            bne __84ab         ; $84d5: d0 d4     
            rts                ; $84d7: 60        

;-------------------------------------------------------------------------------
__84d8:     lda #$06           ; $84d8: a9 06     
            sta $012f          ; $84da: 8d 2f 01  
            ldx #$00           ; $84dd: a2 00     
            ldy #$00           ; $84df: a0 00     
__84e1:     lda $0191,x        ; $84e1: bd 91 01  
            beq __84ec         ; $84e4: f0 06     
            dec $0191,x        ; $84e6: de 91 01  
            jmp __8545         ; $84e9: 4c 45 85  

;-------------------------------------------------------------------------------
__84ec:     lda $0190,x        ; $84ec: bd 90 01  
            beq __8545         ; $84ef: f0 54     
            stx $0131          ; $84f1: 8e 31 01  
            sec                ; $84f4: 38        
            sbc #$01           ; $84f5: e9 01     
            asl                ; $84f7: 0a        
            tax                ; $84f8: aa        
            lda __8558,x       ; $84f9: bd 58 85  
            beq __850d         ; $84fc: f0 0f     
            sta $02cd,y        ; $84fe: 99 cd 02  
            lda __8559,x       ; $8501: bd 59 85  
            sta $02d1,y        ; $8504: 99 d1 02  
            ldx $0131          ; $8507: ae 31 01  
            jmp __8520         ; $850a: 4c 20 85  

;-------------------------------------------------------------------------------
__850d:     ldx $0131          ; $850d: ae 31 01  
            lda #$00           ; $8510: a9 00     
            sta $0190,x        ; $8512: 9d 90 01  
            lda #$f0           ; $8515: a9 f0     
            sta $02cc,y        ; $8517: 99 cc 02  
            sta $02d0,y        ; $851a: 99 d0 02  
            jmp __8545         ; $851d: 4c 45 85  

;-------------------------------------------------------------------------------
__8520:     lda $0192,x        ; $8520: bd 92 01  
            sta $02cc,y        ; $8523: 99 cc 02  
            sta $02d0,y        ; $8526: 99 d0 02  
            lda #$00           ; $8529: a9 00     
            sta $02ce,y        ; $852b: 99 ce 02  
            sta $02d2,y        ; $852e: 99 d2 02  
            lda $0193,x        ; $8531: bd 93 01  
            sta $02cf,y        ; $8534: 99 cf 02  
            clc                ; $8537: 18        
            adc #$08           ; $8538: 69 08     
            sta $02d3,y        ; $853a: 99 d3 02  
            inc $0190,x        ; $853d: fe 90 01  
            lda #$03           ; $8540: a9 03     
            sta $0191,x        ; $8542: 9d 91 01  
__8545:     txa                ; $8545: 8a        
            clc                ; $8546: 18        
            adc #$04           ; $8547: 69 04     
            tax                ; $8549: aa        
            tya                ; $854a: 98        
            clc                ; $854b: 18        
            adc #$08           ; $854c: 69 08     
            tay                ; $854e: a8        
            dec $012f          ; $854f: ce 2f 01  
            beq Ret_8557       ; $8552: f0 03     
            jmp __84e1         ; $8554: 4c e1 84  

;-------------------------------------------------------------------------------
Ret_8557:   rts                ; $8557: 60        

;-------------------------------------------------------------------------------
__8558:     .hex ff
__8559:     .hex df d2 d3 d4 d5 d6 d7 de ff 00 00

UpdateWarpState:
            lda IsPaddleWarping; $8564: ad 23 01  .
            bne AnimatePaddleWarp ; $8567: d0 3e  | If the paddle's actively warping, go update it
            lda ActiveBalls    ; $8569: a5 81     .
            beq Ret_85a6       ; $856b: f0 39     | If there aren't any active balls, return
            lda WarpState      ; $856d: ad 24 01  .
            beq Ret_85a6       ; $8570: f0 34     | If the warp gate isn't open, return
            lda PaddleRightEdge ; $8572: ad 1f 01 .
            cmp #$b8           ; $8575: c9 b8     |
            bcc Ret_85a6       ; $8577: 90 2d     | If paddle right edge >= 0xb8,
            lda #$00           ; $8579: a9 00       .
            sta ActiveBalls    ; $857b: 85 81       | Clear active balls
            sta SpawnedPowerup ; $857d: 85 8c       . Clear spawned powerup
            sta $d9            ; $857f: 85 d9     
            sta CurrentBlocks  ; $8581: 85 0f       . Clear active block count
            sta $d8            ; $8583: 85 d8     
            lda #$01           ; $8585: a9 01       .
            sta IsPaddleWarping; $8587: 8d 23 01    | Set the paddle state to warping
            lda #$10           ; $858a: a9 10       .
            sta GameState      ; $858c: 85 0a       | Set game state to 0x10 (ball active)
            lda #$00           ; $858e: a9 00       .
            sta AutoLaunchTimer; $8590: 8d 38 01    | Clear auto-launch timer
            sta IsStickyPaddle ; $8593: 8d 28 01    . Clear sticky paddle flag
            lda #$da           ; $8596: a9 da       
            sta $88            ; $8598: 85 88       
            lda #$85           ; $859a: a9 85       
            sta $89            ; $859c: 85 89       
            jsr AddPendingScore; $859e: 20 56 90    
            lda #$0b           ; $85a1: a9 0b       .
            jsr PlaySoundEffect; $85a3: 20 c6 f3    | Play sound effect 0xb (warping??)
Ret_85a6:   rts                ; $85a6: 60        . return

;-------------------------------------------------------------------------------
AnimatePaddleWarp:
            lda PaddleLeftEdge ; $85a7: ad 1a 01  .
            cmp #$c8           ; $85aa: c9 c8     |
            bcs __85d4         ; $85ac: b0 26     | if paddle left edge >= 0xc8, branch
            inc PaddleLeftEdge ; $85ae: ee 1a 01      .
            inc PaddleLeftCenter ; $85b1: ee 1b 01    |
            inc PaddleLeftCenterM ; $85b4: ee 1c 01   |
            inc PaddleRightCenter ; $85b7: ee 1d 01   |
            inc PaddleRightCenterM ; $85ba: ee 1e 01  |
            inc PaddleRightEdge ; $85bd: ee 1f 01     | move the paddle over by one tick
            ldx #$00           ; $85c0: a2 00     
__85c2:     lda $011a,x        ; $85c2: bd 1a 01  
            cmp #$c2           ; $85c5: c9 c2     
            bcc __85ce         ; $85c7: 90 05     
            lda #$f0           ; $85c9: a9 f0     
            sta $0114,x        ; $85cb: 9d 14 01  
__85ce:     inx                ; $85ce: e8        
            cpx #$06           ; $85cf: e0 06     
            bne __85c2         ; $85d1: d0 ef     
            rts                ; $85d3: 60        

;-------------------------------------------------------------------------------
__85d4:     lda #$00           ; $85d4: a9 00     .
            sta WarpState      ; $85d6: 8d 24 01  | Clear out the warp state flag
            rts                ; $85d9: 60        . return

;-------------------------------------------------------------------------------
            brk                ; $85da: 00        
            ora ($00,x)        ; $85db: 01 00     
            brk                ; $85dd: 00        
            brk                ; $85de: 00        
            brk                ; $85df: 00        
CheckPauseUnpause:
            lda IsDemo         ; $85e0: a5 10     .
            bne Ret_8626       ; $85e2: d0 42     | if this is the demo, return
            lda GameState      ; $85e4: a5 0a     .
            cmp #$10           ; $85e6: c9 10     |
            bne CheckUnpausing ; $85e8: d0 19     | if there isn't a ball active, move on
            lda Buttons        ; $85ea: a5 00     .
            eor PrevButtons    ; $85ec: 45 01     |
            and Buttons        ; $85ee: 25 00     |
            cmp #$10           ; $85f0: c9 10     |
            bne Ret_8626       ; $85f2: d0 32     | if the start button wasn't just pressed, return
            lda #$00           ; $85f4: a9 00     
            sta $013d          ; $85f6: 8d 3d 01  
            lda #$01           ; $85f9: a9 01     
            sta $013c          ; $85fb: 8d 3c 01  
            lda #$20           ; $85fe: a9 20     .
            sta GameState      ; $8600: 85 0a     | set game state to paused
            rts                ; $8602: 60        . return

;-------------------------------------------------------------------------------
CheckUnpausing: lda GameState  ; $8603: a5 0a     .
            cmp #$20           ; $8605: c9 20     |
            bne Ret_8626       ; $8607: d0 1d     | if the game isn't paused, return
            lda Buttons        ; $8609: a5 00     .
            eor PrevButtons    ; $860b: 45 01     |
            and PrevButtons    ; $860d: 25 01     |
            cmp #$10           ; $860f: c9 10     |
            bne Ret_8626       ; $8611: d0 13     | if the start button wasn't just pressed, return
            inc $013d          ; $8613: ee 3d 01  
            lda $013d          ; $8616: ad 3d 01  
            cmp #$02           ; $8619: c9 02     
            bcc Ret_8626       ; $861b: 90 09     
            lda #$01           ; $861d: a9 01     
            sta $013c          ; $861f: 8d 3c 01  
            lda #$10           ; $8622: a9 10     .
            sta GameState      ; $8624: 85 0a     | set game state = ball active
Ret_8626:   rts                ; $8626: 60        . return

;-------------------------------------------------------------------------------
CheckRemainingBallsBlocks:
            ldx #$00           ; $8627: a2 00     
            lda GameState      ; $8629: a5 0a     .
            cmp #$10           ; $862b: c9 10     |
            beq Next_8630      ; $862d: f0 01     |
            rts                ; $862f: 60        | if game state != ball active, return

;-------------------------------------------------------------------------------
Next_8630:  lda IsDemo         ; $8630: a5 10     .
            bne Next_8640      ; $8632: d0 0c     | if this isn't the demo
            lda Buttons        ; $8634: a5 00       .
            cmp #$90           ; $8636: c9 90       |
            bne Next_8640      ; $8638: d0 06       | if A and Start are pressed,
            lda CurrentLevel   ; $863a: a5 1a         .
            cmp #$10           ; $863c: c9 10         |
            bcc J_NextLevel    ; $863e: 90 25         | if current level < 0x10, skip the level
Next_8640:
Loop_8640:  lda PendingScoreTopDigit,x ; $8640: bd 7c 03 .
            bne CheckIfDownToOneBall ; $8643: d0 3f |
            inx                ; $8645: e8          |
            cpx #$05           ; $8646: e0 05       |
            bne Loop_8640      ; $8648: d0 f6       | if there's no pending score change,
            lda ActionFrozenFlag ; $864a: ad 09 01    .
            bne Next_8661      ; $864d: d0 12         | and we haven't already set the action-frozen flag,
            lda CurrentBlocks  ; $864f: a5 0f           .
            beq Next_8657      ; $8651: f0 04           |
            lda ActiveBalls    ; $8653: a5 81           |
            bne CheckIfDownToOneBall ; $8655: d0 2d     | and there aren't any blocks left, or there aren't any balls left
Next_8657:  lda #$00           ; $8657: a9 00             
            sta $d8            ; $8659: 85 d8             
            lda #$01           ; $865b: a9 01             .
            sta ActionFrozenFlag ; $865d: 8d 09 01        | Set action-frozen flag
            rts                ; $8660: 60                . return

;-------------------------------------------------------------------------------
Next_8661:  lda CurrentBlocks  ; $8661: a5 0f     .
            bne Next_8669      ; $8663: d0 04     |
J_NextLevel:jsr NextLevel      ; $8665: 20 9a 8b  |
            rts                ; $8668: 60        | if there are no blocks left, go to the next level

;-------------------------------------------------------------------------------
Next_8669:  lda ActiveBalls    ; $8669: a5 81       .
            bne CheckIfDownToOneBall ; $866b: d0 17 | If there are any balls around, do check
            lda #$00           ; $866d: a9 00       . else, all balls are lost
            sta $016a          ; $866f: 8d 6a 01    
            sta $016b          ; $8672: 8d 6b 01    
            sta $016c          ; $8675: 8d 6c 01    
            dec NumLives       ; $8678: c6 0d       . Lose a life
            lda #$18           ; $867a: a9 18       .
            sta GameState      ; $867c: 85 0a       | set game state to "lost a ball"
            lda #$01           ; $867e: a9 01       
            sta $0122          ; $8680: 8d 22 01    
            rts                ; $8683: 60          . return

;-------------------------------------------------------------------------------
CheckIfDownToOneBall:
            lda ActiveBalls    ; $8684: a5 81    .
            ldy #$00           ; $8686: a0 00    | Load active ball info
            ldx #BallStructSize ; $8688: a2 1a   .
            cmp #$02           ; $868a: c9 02    | 
            beq TransferToBall1; $868c: f0 06    | If only ball 2 is left, move data to ball 1
            ldx #BallStructSizeDouble ; $868e: a2 34 .
            cmp #$04           ; $8690: c9 04        |
            bne Ret_86a3       ; $8692: d0 0f        | If only ball 3 is left, move data to ball 1
TransferToBall1:
            lda $33,x          ; $8694: b5 33     .
            sta $0033,y        ; $8696: 99 33 00  |
            iny                ; $8699: c8        |
            inx                ; $869a: e8        |
            cpy #BallStructSize; $869b: c0 1a     |
            bne TransferToBall1; $869d: d0 f5     | Transfer data to ball 1's struct
            lda #$01           ; $869f: a9 01     .
            sta ActiveBalls    ; $86a1: 85 81     | Set ball 1 as active
Ret_86a3:   rts                ; $86a3: 60        . return

;-------------------------------------------------------------------------------
UpdateTimers:
            lda GameState      ; $86a4: a5 0a     .
            cmp #$20           ; $86a6: c9 20     |
            bne Next_86ab      ; $86a8: d0 01     |
            rts                ; $86aa: 60        | if the game is paused, return

;-------------------------------------------------------------------------------
Next_86ab:  lda LoadingTimer   ; $86ab: ad 3b 01  
            beq Next_86b4      ; $86ae: f0 04     
            dec LoadingTimer   ; $86b0: ce 3b 01  
            rts                ; $86b3: 60        

;-------------------------------------------------------------------------------
Next_86b4:  lda TitleTimerHi   ; $86b4: a5 12     .
            ora TitleTimerLo   ; $86b6: 05 13     |
            beq __871a         ; $86b8: f0 60     | if timers == 0, jump
            lda GameState      ; $86ba: a5 0a     .
            cmp #$01           ; $86bc: c9 01     |
            beq UpdateTitleTimers ; $86be: f0 0a  | if on the title screen, decrement timers
            lda ButtonsP2M     ; $86c0: a5 06     .
            bne Next_870b      ; $86c2: d0 47     | if any P2 buttons are pressed, exit the intro
            lda Buttons        ; $86c4: a5 00     .
            cmp #$10           ; $86c6: c9 10     |
            beq Next_870b      ; $86c8: f0 41     | if P1 start button is pressed, exit the intro
UpdateTitleTimers:
            dec TitleTimerLo   ; $86ca: c6 13     . decrement timer
            lda TitleTimerLo   ; $86cc: a5 13     .
            ora TitleTimerHi   ; $86ce: 05 12     |
            beq __86dd         ; $86d0: f0 0b     |
            lda TitleTimerLo   ; $86d2: a5 13     
            cmp #$ff           ; $86d4: c9 ff     
            bne __871a         ; $86d6: d0 42     
            dec TitleTimerHi   ; $86d8: c6 12     
            jmp __871a         ; $86da: 4c 1a 87  

;-------------------------------------------------------------------------------
__86dd:     lda #$00           ; $86dd: a9 00     .
            sta _VScrollOffset ; $86df: 85 16     | Clear vertical scroll value
            inc GameState      ; $86e1: e6 0a     . Bump game state by 1
            lda GameState      ; $86e3: a5 0a     .
            cmp #$09           ; $86e5: c9 09     |
            beq Next_870b      ; $86e7: f0 22     |
            cmp #$11           ; $86e9: c9 11     |
            beq Next_870b      ; $86eb: f0 1e     | if game state == 9 or 0x11, reset it and other values to 0
            cmp #$04           ; $86ed: c9 04     .
            beq StartDemo      ; $86ef: f0 09     | if game state == 4, start the demo
            lda #$01           ; $86f1: a9 01     .
            sta TitleTimerHi   ; $86f3: 85 12     |
            lda #$e0           ; $86f5: a9 e0     |
            sta TitleTimerLo   ; $86f7: 85 13     | set title timer to 0x1e0 (story timer)
            rts                ; $86f9: 60        . return

;-------------------------------------------------------------------------------
StartDemo:  lda #$05           ; $86fa: a9 05     .
            sta GameState      ; $86fc: 85 0a     | Set game state = 5 (level starting)
            lda #$01           ; $86fe: a9 01     .
            sta IsDemo         ; $8700: 85 10     | Set demo state = enabled
            lda #$09           ; $8702: a9 09     .
            sta TitleTimerHi   ; $8704: 85 12     |
            lda #$60           ; $8706: a9 60     |
            sta TitleTimerLo   ; $8708: 85 13     | set title timer to 0x960 (demo timer)
            rts                ; $870a: 60        

;-------------------------------------------------------------------------------
Next_870b:  lda #$00           ; $870b: a9 00     .
            sta GameState      ; $870d: 85 0a     | Reset game state
            sta IsDemo         ; $870f: 85 10     . Clear demo flag
            sta TitleTimerHi   ; $8711: 85 12     .
            sta TitleTimerLo   ; $8713: 85 13     | Clear timers
            sta CurrentLevelM  ; $8715: 85 21     . Clear level ID
            sta $24            ; $8717: 85 24     
            rts                ; $8719: 60        . return

;-------------------------------------------------------------------------------
__871a:     lda $da            ; $871a: a5 da     
            beq __8720         ; $871c: f0 02     
            dec $da            ; $871e: c6 da     
__8720:     lda $0126          ; $8720: ad 26 01  
            ora $0127          ; $8723: 0d 27 01  
            beq Next_8748      ; $8726: f0 20     
            dec $0127          ; $8728: ce 27 01  
            lda $0127          ; $872b: ad 27 01  
            ora $0126          ; $872e: 0d 26 01  
            bne __873b         ; $8731: d0 08     
            lda #$01           ; $8733: a9 01     
            sta WarpState      ; $8735: 8d 24 01  
            jmp Next_8748      ; $8738: 4c 48 87  

;-------------------------------------------------------------------------------
__873b:     lda $0127          ; $873b: ad 27 01  
            cmp #$ff           ; $873e: c9 ff     
            bne Next_8748      ; $8740: d0 06     
            dec $0126          ; $8742: ce 26 01  
            jmp Next_8748      ; $8745: 4c 48 87  

;-------------------------------------------------------------------------------
Next_8748:  lda AutoLaunchTimer; $8748: ad 38 01  .
            beq Next_8756      ; $874b: f0 09     |
            dec AutoLaunchTimer; $874d: ce 38 01  |
            bne Next_8756      ; $8750: d0 04     |
            lda #$01           ; $8752: a9 01     |
            sta AutoLaunchFlag ; $8754: 85 0c     | If the auto-launch timer has finished, set the launch flag
Next_8756:  ldy #$03           ; $8756: a0 03     .
            ldx #$00           ; $8758: a2 00     | for x = 0 2 4, y = 3 2 1 (for each timer),
Loop_875a:  lda EnemySpawnTimerHi,x ; $875a: b5 c0.
            ora EnemySpawnTimerLo,x ; $875c: 15 c1|
            beq Next_876d      ; $875e: f0 0d     | if any timer value is set,
            sec                ; $8760: 38          .
            lda EnemySpawnTimerLo,x ; $8761: b5 c1  |
            sbc #$01           ; $8763: e9 01       |
            sta EnemySpawnTimerLo,x ; $8765: 95 c1  | decrement timer low byte
            lda EnemySpawnTimerHi,x ; $8767: b5 c0  .
            sbc #$00           ; $8769: e9 00       |
            sta EnemySpawnTimerHi,x ; $876b: 95 c0  | decrement timer high byte if underflow occurred
Next_876d:  inx                ; $876d: e8        .
            inx                ; $876e: e8        |
            dey                ; $876f: 88        |
            bne Loop_875a      ; $8770: d0 e8     | loop
            lda MuteSoundEffectsTimer ; $8772: ad 0e 01  .
            beq __877a         ; $8775: f0 03            | if we're muting sound effects,
            dec MuteSoundEffectsTimer ; $8777: ce 0e 01    . decrement the timer
__877a:     lda $018e          ; $877a: ad 8e 01  
            ora $018f          ; $877d: 0d 8f 01  
            bne __8783         ; $8780: d0 01     
            rts                ; $8782: 60        

;-------------------------------------------------------------------------------
__8783:     dec $018f          ; $8783: ce 8f 01  
            lda $018f          ; $8786: ad 8f 01  
            ora $018e          ; $8789: 0d 8e 01  
            beq __879b         ; $878c: f0 0d     
            lda $018f          ; $878e: ad 8f 01  
            cmp #$ff           ; $8791: c9 ff     
            bne __880c         ; $8793: d0 77     
            dec $018e          ; $8795: ce 8e 01  
            jmp __880c         ; $8798: 4c 0c 88  

;-------------------------------------------------------------------------------
__879b:     lda GameState      ; $879b: a5 0a     
            cmp #$30           ; $879d: c9 30     
            bne __87d2         ; $879f: d0 31     
            lda $19            ; $87a1: a5 19     
            bne __87b0         ; $87a3: d0 0b     
            lda #$00           ; $87a5: a9 00     
            sta $1d            ; $87a7: 85 1d     
            sta TotalBlocks    ; $87a9: 85 1f     . Total blocks = 0
            sta $21            ; $87ab: 85 21     
            jmp __87b8         ; $87ad: 4c b8 87  

;-------------------------------------------------------------------------------
__87b0:     lda #$00           ; $87b0: a9 00     
            sta $1e            ; $87b2: 85 1e     
            sta $20            ; $87b4: 85 20     
            sta $24            ; $87b6: 85 24     
__87b8:     lda #$00           ; $87b8: a9 00     
            sta ActiveBalls    ; $87ba: 85 81     
            sta CurrentBlocks  ; $87bc: 85 0f     . Current blocks = 0
            sta $016a          ; $87be: 8d 6a 01  
            sta $016b          ; $87c1: 8d 6b 01  
            sta $016c          ; $87c4: 8d 6c 01  
            lda #$01           ; $87c7: a9 01     
            sta $018c          ; $87c9: 8d 8c 01  
            lda #$05           ; $87cc: a9 05     
            sta $018d          ; $87ce: 8d 8d 01  
            rts                ; $87d1: 60        

;-------------------------------------------------------------------------------
__87d2:     lda GameState      ; $87d2: a5 0a     
            cmp #$31           ; $87d4: c9 31     
            bne __87ec         ; $87d6: d0 14     
            lda #$11           ; $87d8: a9 11     .
            jsr PlaySoundEffect; $87da: 20 c6 f3  | Play sound effect 0x11
            lda #$00           ; $87dd: a9 00     
            sta $018e          ; $87df: 8d 8e 01  
            lda #$f0           ; $87e2: a9 f0     
            sta $018f          ; $87e4: 8d 8f 01  
            lda #$32           ; $87e7: a9 32     
            sta GameState      ; $87e9: 85 0a     
            rts                ; $87eb: 60        

;-------------------------------------------------------------------------------
__87ec:     lda GameState      ; $87ec: a5 0a     
            cmp #$32           ; $87ee: c9 32     
            bne __87f7         ; $87f0: d0 05
            lda #$60           ; $87f2: a9 60
            sta GameState      ; $87f4: 85 0a     
            rts                ; $87f6: 60        

;-------------------------------------------------------------------------------
__87f7:     lda GameState      ; $87f7: a5 0a     
            cmp #$35           ; $87f9: c9 35     
            bne __880c         ; $87fb: d0 0f     
            lda #$0f           ; $87fd: a9 0f     .
            jsr PlaySoundEffect; $87ff: 20 c6 f3  | play sound effect 0xf
            lda #$62           ; $8802: a9 62     .
            sta GameState      ; $8804: 85 0a     | set game state = 0x62
            lda #$c8           ; $8806: a9 c8     .
            sta LoadingTimer   ; $8808: 8d 3b 01  | init loading timer to 0xc8
            rts                ; $880b: 60        . return

;-------------------------------------------------------------------------------
__880c:     rts                ; $880c: 60        

;-------------------------------------------------------------------------------
__880d:     lda GameState      ; $880d: a5 0a     .
            cmp #$10           ; $880f: c9 10     |
            beq __8814         ; $8811: f0 01     |
            rts                ; $8813: 60        | if the ball isn't active, return

;-------------------------------------------------------------------------------
__8814:     lda $d8            ; $8814: a5 d8     
            bne __8819         ; $8816: d0 01     
            rts                ; $8818: 60        

;-------------------------------------------------------------------------------
__8819:     lda IsPaddleWarping; $8819: ad 23 01  .
            beq __881f         ; $881c: f0 01     |
            rts                ; $881e: 60        | if the paddle's warping, return

;-------------------------------------------------------------------------------
__881f:     lda $da            ; $881f: a5 da     
            bne Next_886c      ; $8821: d0 49     
            lda ButtonsM       ; $8823: a5 04     .
            eor PrevButtonsM   ; $8825: 45 05     |
            and ButtonsM       ; $8827: 25 04     |
            cmp #$80           ; $8829: c9 80     |
            bne Next_886c      ; $882b: d0 3f     | if the A button was just pressed, 
            lda $d9            ; $882d: a5 d9     
            and #$03           ; $882f: 29 03     
            bne __8845         ; $8831: d0 12     
            lda PaddleTop_A    ; $8833: ad 14 01  
            sta $dc            ; $8836: 85 dc     
            clc                ; $8838: 18        
            lda PaddleLeftEdge ; $8839: ad 1a 01  
            adc #$08           ; $883c: 69 08     
            sta $dd            ; $883e: 85 dd     
            lda #$03           ; $8840: a9 03     
            jmp __885a         ; $8842: 4c 5a 88  

;-------------------------------------------------------------------------------
__8845:     lda $d9            ; $8845: a5 d9     
            and #$0c           ; $8847: 29 0c     
            bne Next_886c      ; $8849: d0 21     
            lda PaddleTop_A    ; $884b: ad 14 01  
            sta $de            ; $884e: 85 de     
            clc                ; $8850: 18        
            lda PaddleLeftEdge ; $8851: ad 1a 01  
            adc #$08           ; $8854: 69 08     
            sta $df            ; $8856: 85 df     
            lda #$0c           ; $8858: a9 0c     
__885a:     ora $d9            ; $885a: 05 d9     
            sta $d9            ; $885c: 85 d9     
            lda #$03           ; $885e: a9 03     
            sta $da            ; $8860: 85 da     
            lda MuteSoundEffectsTimer ; $8862: ad 0e 01 .
            bne Next_886c      ; $8865: d0 05           | if we're not muting sound effects,
            lda #$0a           ; $8867: a9 0a             .
            jsr PlaySoundEffect; $8869: 20 c6 f3          | play sound effect 0xa
Next_886c:  lda $d9            ; $886c: a5 d9     .
            and #$03           ; $886e: 29 03     |
            beq __888b         ; $8870: f0 19     
            lda $dc            ; $8872: a5 dc     .
            sec                ; $8874: 38        |
            sbc #$04           ; $8875: e9 04     |
            sta $dc            ; $8877: 85 dc     | $dc = $dc - 4 (paddle top - 4?)
            cmp #$10           ; $8879: c9 10     .
            bcc __8885         ; $887b: 90 08     | if it's >= 0x10,
            tay                ; $887d: a8          . move it to y
            ldx $dd            ; $887e: a6 dd       . load $dd
            jsr __88ab         ; $8880: 20 ab 88    . go update calculated cell positions
            bcc __888b         ; $8883: 90 06     
__8885:     lda $d9            ; $8885: a5 d9     
            and #$0c           ; $8887: 29 0c     
            sta $d9            ; $8889: 85 d9     
__888b:     lda $d9            ; $888b: a5 d9     
            and #$0c           ; $888d: 29 0c     
            beq Ret_88aa       ; $888f: f0 19     
            lda $de            ; $8891: a5 de     
            sec                ; $8893: 38        
            sbc #$04           ; $8894: e9 04     
            sta $de            ; $8896: 85 de     
            cmp #$10           ; $8898: c9 10     
            bcc __88a4         ; $889a: 90 08     
            tay                ; $889c: a8        
            ldx $df            ; $889d: a6 df     
            jsr __88ab         ; $889f: 20 ab 88  
            bcc Ret_88aa       ; $88a2: 90 06     
__88a4:     lda $d9            ; $88a4: a5 d9     
            and #$03           ; $88a6: 29 03     
            sta $d9            ; $88a8: 85 d9     
Ret_88aa:   rts                ; $88aa: 60        

;-------------------------------------------------------------------------------
__88ab:     sec                ; $88ab: 38        
            tya                ; $88ac: 98        
            sbc #$10           ; $88ad: e9 10     
            lsr                ; $88af: 4a        
            lsr                ; $88b0: 4a        
            lsr                ; $88b1: 4a        
            sta CalculatedCellY; $88b2: 8d 0c 01  
            tay                ; $88b5: a8        
            sec                ; $88b6: 38        
            txa                ; $88b7: 8a        
            sta $db            ; $88b8: 85 db     
            sbc #$10           ; $88ba: e9 10     
            lsr                ; $88bc: 4a        
            lsr                ; $88bd: 4a        
            lsr                ; $88be: 4a        
            lsr                ; $88bf: 4a        
            sta CalculatedCellX; $88c0: 8d 0d 01  
            tax                ; $88c3: aa        
            jsr CheckBlockProximity ; $88c4: 20 36 ab  
            lda BlockProximity ; $88c7: ad 06 01  
            and #$0c           ; $88ca: 29 0c     
            sta BlockProximity ; $88cc: 8d 06 01  
            bne __88d3         ; $88cf: d0 02     
            clc                ; $88d1: 18        
            rts                ; $88d2: 60        

;-------------------------------------------------------------------------------
__88d3:     clc                ; $88d3: 18        
            php                ; $88d4: 08        
            lda BlockProximity ; $88d5: ad 06 01  
            and #$08           ; $88d8: 29 08     
            beq __88e5         ; $88da: f0 09     
            sta BlockCollisSide; $88dc: 8d 07 01  
            jsr HandleBlockCollis ; $88df: 20 ec a9  
            plp                ; $88e2: 28        
            sec                ; $88e3: 38        
            php                ; $88e4: 08        
__88e5:     lda $db            ; $88e5: a5 db     
            and #$0f           ; $88e7: 29 0f     
            bne __88ed         ; $88e9: d0 02     
            plp                ; $88eb: 28        
            rts                ; $88ec: 60        

;-------------------------------------------------------------------------------
__88ed:     lda BlockProximity ; $88ed: ad 06 01  
            and #$04           ; $88f0: 29 04     
            beq __88fd         ; $88f2: f0 09     
            sta BlockCollisSide; $88f4: 8d 07 01  
            jsr HandleBlockCollis ; $88f7: 20 ec a9  
            plp                ; $88fa: 28        
            sec                ; $88fb: 38        
            rts                ; $88fc: 60        

;-------------------------------------------------------------------------------
__88fd:     plp                ; $88fd: 28        
            rts                ; $88fe: 60        

;-------------------------------------------------------------------------------
__88ff:
            lda ActiveBalls    ; $88ff: a5 81     .
            beq Ret_8939       ; $8901: f0 36     | if there aren't any active balls, return
            lda $d9            ; $8903: a5 d9     
            and #$03           ; $8905: 29 03     
            beq Next_891e      ; $8907: f0 15     
            lda $dc            ; $8909: a5 dc     
            sta CalculatedCellY; $890b: 8d 0c 01  
            lda $dd            ; $890e: a5 dd     
            sta CalculatedCellX; $8910: 8d 0d 01  
            jsr DoEnemyCollisCheck ; $8913: 20 3a 89  
            bcc Next_891e      ; $8916: 90 06     
            lda $d9            ; $8918: a5 d9     
            and #$0c           ; $891a: 29 0c     
            sta $d9            ; $891c: 85 d9     
Next_891e:  lda $d9            ; $891e: a5 d9     
            and #$0c           ; $8920: 29 0c     
            beq Ret_8939       ; $8922: f0 15     
            lda $de            ; $8924: a5 de     
            sta CalculatedCellY; $8926: 8d 0c 01  
            lda $df            ; $8929: a5 df     
            sta CalculatedCellX; $892b: 8d 0d 01  
            jsr DoEnemyCollisCheck ; $892e: 20 3a 89  
            bcc Ret_8939       ; $8931: 90 06     
            lda $d9            ; $8933: a5 d9     
            and #$03           ; $8935: 29 03     
            sta $d9            ; $8937: 85 d9     
Ret_8939:   rts                ; $8939: 60        

;-------------------------------------------------------------------------------
DoEnemyCollisCheck:
            ldx #$00           ; $893a: a2 00     . for each enemy,
Loop_893c:  lda EnemyActive,x  ; $893c: b5 95     .
            beq __899d         ; $893e: f0 5d     | if the enemy isn't active, skip
            lda EnemyExiting,x ; $8940: b5 9b     .
            bne __899d         ; $8942: d0 59     | if the enemy's exiting, skip
            lda EnemyY,x       ; $8944: b5 ae     .
            cmp #$e0           ; $8946: c9 e0     |
            bcs __899d         ; $8948: b0 53     | if enemy[x].y >= 0xe0, skip
            lda CalculatedCellY; $894a: ad 0c 01  .
            cmp EnemyY,x       ; $894d: d5 ae     |
            bcc __899d         ; $894f: 90 4c     | if enemy[x].y < [$10c], skip
            clc                ; $8951: 18        .
            lda EnemyY,x       ; $8952: b5 ae     |
            adc #$0c           ; $8954: 69 0c     |
            cmp CalculatedCellY; $8956: cd 0c 01  |
            bcc __899d         ; $8959: 90 42     | if enemy[x].y + 0xc >= [$10c], skip
            clc                ; $895b: 18        .
            lda EnemyX,x       ; $895c: b5 b7     |
            adc #$01           ; $895e: 69 01     |
            cmp CalculatedCellX; $8960: cd 0d 01  |
            bcs __896d         ; $8963: b0 08     | if enemy[x].x + 1 < [$10d]
            clc                ; $8965: 18          .
            adc #$0a           ; $8966: 69 0a       |
            cmp CalculatedCellX; $8968: cd 0d 01    |
            bcs __8988         ; $896b: b0 1b       | if enemy[x].x + 0xb >= [$10d], go destroy the enemy
__896d:     clc                ; $896d: 18        .
            lda CalculatedCellX; $896e: ad 0d 01  |
            adc #$0d            ; $8971: 69 0d    |
            sta $0131          ; $8973: 8d 31 01  | set $0131 = [$10d] + 0xd
            clc                ; $8976: 18        .
            lda EnemyX,x       ; $8977: b5 b7     |
            adc #$01           ; $8979: 69 01     |
            cmp $0131          ; $897b: cd 31 01  |
            bcs __899d         ; $897e: b0 1d     | if enemy[x].x + 1 < $0131,
            clc                ; $8980: 18        .
            adc #$0a           ; $8981: 69 0a     |
            cmp $0131          ; $8983: cd 31 01  |
            bcc __899d         ; $8986: 90 15     |  and enemy[x].x + 0xb >= 0x$131,
__8988:     lda #$5f           ; $8988: a9 5f       .
            sta $88            ; $898a: 85 88       |
            lda #$8e           ; $898c: a9 8e       |
            sta $89            ; $898e: 85 89       | load $8e5f address (100 points)
            jsr AddPendingScore; $8990: 20 56 90    . add 100 points to pending score
            lda #$00           ; $8993: a9 00       .
            sta EnemyActive,x  ; $8995: 95 95       | mark enemy as inactive
            lda #$01           ; $8997: a9 01       .
            sta EnemyDestrFrame,x ; $8999: 95 98    | set destruction frame = 1
            sec                ; $899b: 38          
            rts                ; $899c: 60        

;-------------------------------------------------------------------------------
__899d:     inx                ; $899d: e8        
            cpx #$03           ; $899e: e0 03     
            bne Loop_893c      ; $89a0: d0 9a     
            clc                ; $89a2: 18        
            rts                ; $89a3: 60        

;-------------------------------------------------------------------------------
CheckPaddleCollisWithEnemy:
            lda ActiveBalls    ; $89a4: a5 81     .
            bne __89a9         ; $89a6: d0 01     |
            rts                ; $89a8: 60        | if there aren't any active balls, return

;-------------------------------------------------------------------------------
__89a9:     ldx #$00           ; $89a9: a2 00     . for each enemy
__89ab:     lda EnemyActive,x  ; $89ab: b5 95     .
            beq __89f4         ; $89ad: f0 45     | if it's active,
            lda EnemyExiting,x ; $89af: b5 9b     .
            bne __89f4         ; $89b1: d0 41     | and not exiting,
            lda EnemyY,x       ; $89b3: b5 ae     .
            cmp #$e0           ; $89b5: c9 e0     |
            bcs __89f4         ; $89b7: b0 3b     | and the enemy y < 0xe0,
            clc                ; $89b9: 18        .
            lda PaddleTop_A    ; $89ba: ad 14 01  |
            adc #$04           ; $89bd: 69 04     |
            cmp EnemyY,x       ; $89bf: d5 ae     |
            bcc __89f4         ; $89c1: 90 31     | and the paddle top + 4 >= enemy y,
            clc                ; $89c3: 18        .
            lda EnemyY,x       ; $89c4: b5 ae     |
            adc #$0e           ; $89c6: 69 0e     |
            cmp PaddleTop_A    ; $89c8: cd 14 01  |
            bcc __89f4         ; $89cb: 90 27     | and the enemy y + 0xe >= paddle top,
            clc                ; $89cd: 18        .
            lda EnemyX,x       ; $89ce: b5 b7     |
            adc #$0c           ; $89d0: 69 0c     |
            cmp PaddleLeftEdge ; $89d2: cd 1a 01  |
            bcc __89f4         ; $89d5: 90 1d     | and the enemy x + 0xc >= paddle left edge,
            clc                ; $89d7: 18        .
            lda PaddleRightEdge ; $89d8: ad 1f 01 |
            adc #$05           ; $89db: 69 05     |
            cmp EnemyX,x       ; $89dd: d5 b7     |
            bcc __89f4         ; $89df: 90 13     | and the paddle right edge + 5 >= enemy x,
            lda #$5f           ; $89e1: a9 5f       .
            sta $88            ; $89e3: 85 88       |
            lda #$8e           ; $89e5: a9 8e       |
            sta $89            ; $89e7: 85 89       | set pointer = $8e5f (score val = 100 points)
            jsr AddPendingScore; $89e9: 20 56 90    . go add the score
            lda #$00           ; $89ec: a9 00       .
            sta EnemyActive,x  ; $89ee: 95 95       | mark enemy as inactive
            lda #$01           ; $89f0: a9 01       .
            sta EnemyDestrFrame,x ; $89f2: 95 98    | set destruction frame = 1
__89f4:     inx                ; $89f4: e8        .
            cpx #$03           ; $89f5: e0 03     |
            bne __89ab         ; $89f7: d0 b2     | loop 0..2
            rts                ; $89f9: 60        . return

;-------------------------------------------------------------------------------
__89fa:     lda $0141          ; $89fa: ad 41 01  
            beq __8a03         ; $89fd: f0 04     
            dec $0141          ; $89ff: ce 41 01  
            rts                ; $8a02: 60        

;-------------------------------------------------------------------------------
__8a03:     lda $0122          ; $8a03: ad 22 01  
            cmp #$01           ; $8a06: c9 01     
            bne __8a36         ; $8a08: d0 2c     
            clc                ; $8a0a: 18        
            lda PaddleLeftEdge ; $8a0b: ad 1a 01  
            adc #$08           ; $8a0e: 69 08     
            sta PaddleLeftCenter ; $8a10: 8d 1b 01  
            sta PaddleLeftCenterM ; $8a13: 8d 1c 01  
            adc #$08           ; $8a16: 69 08     
            sta PaddleRightCenter ; $8a18: 8d 1d 01  
            sta PaddleRightCenterM ; $8a1b: 8d 1e 01  
            adc #$08           ; $8a1e: 69 08     
            sta PaddleRightEdge ; $8a20: 8d 1f 01  
            lda #$01           ; $8a23: a9 01     
            sta $0120          ; $8a25: 8d 20 01  
            lda #$09           ; $8a28: a9 09     
            sta $0121          ; $8a2a: 8d 21 01  
            inc $0122          ; $8a2d: ee 22 01  
            lda #$10           ; $8a30: a9 10     
            sta $0141          ; $8a32: 8d 41 01  
            rts                ; $8a35: 60        

;-------------------------------------------------------------------------------
__8a36:     cmp #$02           ; $8a36: c9 02     
            bne __8a52         ; $8a38: d0 18     
            lda #$13           ; $8a3a: a9 13     
            sta $0120          ; $8a3c: 8d 20 01  
            lda #$14           ; $8a3f: a9 14     
            sta $0121          ; $8a41: 8d 21 01  
            inc $0122          ; $8a44: ee 22 01  
            lda #$0a           ; $8a47: a9 0a     
            sta $0141          ; $8a49: 8d 41 01  
            lda #$05           ; $8a4c: a9 05     .
            jsr PlaySoundEffect; $8a4e: 20 c6 f3  | play sound effect 5
            rts                ; $8a51: 60        

;-------------------------------------------------------------------------------
__8a52:     cmp #$03           ; $8a52: c9 03     
            beq __8a59         ; $8a54: f0 03     
            jmp __8adb         ; $8a56: 4c db 8a  

;-------------------------------------------------------------------------------
__8a59:     sec                ; $8a59: 38        
            lda PaddleTop_A    ; $8a5a: ad 14 01  
            sbc #$08           ; $8a5d: e9 08     
            sta $0131          ; $8a5f: 8d 31 01  
            ldy #$03           ; $8a62: a0 03     
            ldx #$00           ; $8a64: a2 00     
__8a66:     lda #$06           ; $8a66: a9 06     
            sta $0132          ; $8a68: 8d 32 01  
__8a6b:     lda $0131          ; $8a6b: ad 31 01  
            sta $0254,x        ; $8a6e: 9d 54 02  
            inx                ; $8a71: e8        
            inx                ; $8a72: e8        
            inx                ; $8a73: e8        
            inx                ; $8a74: e8        
            dec $0132          ; $8a75: ce 32 01  
            bne __8a6b         ; $8a78: d0 f1     
            clc                ; $8a7a: 18        
            lda $0131          ; $8a7b: ad 31 01  
            adc #$08           ; $8a7e: 69 08     
            sta $0131          ; $8a80: 8d 31 01  
            dey                ; $8a83: 88        
            bne __8a66         ; $8a84: d0 e0     
            sec                ; $8a86: 38        
            .hex ad            ; $8a87: ad        Suspected data
__8a88:     .hex 1a            ; $8a88: 1a        Invalid Opcode - NOP 
            ora ($e9,x)        ; $8a89: 01 e9     
            php                ; $8a8b: 08        
            sta $0131          ; $8a8c: 8d 31 01  
            ldy #$03           ; $8a8f: a0 03     
            ldx #$00           ; $8a91: a2 00     
__8a93:     lda #$06           ; $8a93: a9 06     
            sta $0132          ; $8a95: 8d 32 01  
            lda $0131          ; $8a98: ad 31 01  
__8a9b:     sta $0257,x        ; $8a9b: 9d 57 02  
            clc                ; $8a9e: 18        
            adc #$08           ; $8a9f: 69 08     
            inx                ; $8aa1: e8        
            inx                ; $8aa2: e8        
            inx                ; $8aa3: e8        
            inx                ; $8aa4: e8        
            dec $0132          ; $8aa5: ce 32 01  
            bne __8a9b         ; $8aa8: d0 f1     
            dey                ; $8aaa: 88        
            bne __8a93         ; $8aab: d0 e6     
            ldy #$00           ; $8aad: a0 00     
            ldx #$00           ; $8aaf: a2 00     
            lda #$12           ; $8ab1: a9 12     
            sta $0132          ; $8ab3: 8d 32 01  
__8ab6:     lda __8b76,y       ; $8ab6: b9 76 8b  
            sta $0255,x        ; $8ab9: 9d 55 02  
            iny                ; $8abc: c8        
            inx                ; $8abd: e8        
            inx                ; $8abe: e8        
            inx                ; $8abf: e8        
            inx                ; $8ac0: e8        
            dec $0132          ; $8ac1: ce 32 01  
            bne __8ab6         ; $8ac4: d0 f0     
            ldx #$00           ; $8ac6: a2 00     
            lda #$f0           ; $8ac8: a9 f0     
__8aca:     sta $0114,x        ; $8aca: 9d 14 01  
            inx                ; $8acd: e8        
            cpx #$06           ; $8ace: e0 06     
            bne __8aca         ; $8ad0: d0 f8     
            inc $0122          ; $8ad2: ee 22 01  
            lda #$0a           ; $8ad5: a9 0a     
            sta $0141          ; $8ad7: 8d 41 01  
            rts                ; $8ada: 60        

;-------------------------------------------------------------------------------
__8adb:     cmp #$04           ; $8adb: c9 04     
            bne __8b01         ; $8add: d0 22     
            ldy #$00           ; $8adf: a0 00     
            ldx #$00           ; $8ae1: a2 00     
            lda #$12           ; $8ae3: a9 12     
            sta $0132          ; $8ae5: 8d 32 01  
__8ae8:     lda __8b88,y       ; $8ae8: b9 88 8b  
            sta $0255,x        ; $8aeb: 9d 55 02  
            iny                ; $8aee: c8        
            inx                ; $8aef: e8        
            inx                ; $8af0: e8        
            inx                ; $8af1: e8        
            inx                ; $8af2: e8        
            dec $0132          ; $8af3: ce 32 01  
            bne __8ae8         ; $8af6: d0 f0     
            inc $0122          ; $8af8: ee 22 01  
            lda #$06           ; $8afb: a9 06     
            sta $0141          ; $8afd: 8d 41 01  
            rts                ; $8b00: 60        

;-------------------------------------------------------------------------------
__8b01:     cmp #$05           ; $8b01: c9 05     
            bne __8b1e         ; $8b03: d0 19     
            ldx #$00           ; $8b05: a2 00     
            ldy #$12           ; $8b07: a0 12     
__8b09:     lda #$f0           ; $8b09: a9 f0     
            sta $0254,x        ; $8b0b: 9d 54 02  
            inx                ; $8b0e: e8        
            inx                ; $8b0f: e8        
            inx                ; $8b10: e8        
            inx                ; $8b11: e8        
            dey                ; $8b12: 88        
            bne __8b09         ; $8b13: d0 f4     
            inc $0122          ; $8b15: ee 22 01  
            lda #$20           ; $8b18: a9 20     
            sta $0141          ; $8b1a: 8d 41 01  
            rts                ; $8b1d: 60        

;-------------------------------------------------------------------------------
__8b1e:     cmp #$06           ; $8b1e: c9 06     
            beq __8b23         ; $8b20: f0 01     
            rts                ; $8b22: 60        

;-------------------------------------------------------------------------------
__8b23:     inc $0122          ; $8b23: ee 22 01  
            lda #$05           ; $8b26: a9 05     .
            sta GameState      ; $8b28: 85 0a     | set game state = 5 (level loading)
            lda #$3c           ; $8b2a: a9 3c     .
            sta LoadingTimer   ; $8b2c: 8d 3b 01  | init loading timer to 0x3c
            lda $19            ; $8b2f: a5 19     
            bne __8b49         ; $8b31: d0 16     
            lda NumLives       ; $8b33: a5 0d     
            sta $1d            ; $8b35: 85 1d     
            lda CurrentBlocks  ; $8b37: a5 0f     .
            sta TotalBlocks    ; $8b39: 85 1f     | total blocks = current blocks
            ldx #$00           ; $8b3b: a2 00     .
Loop_8b3d:  lda EnemySpawnTimerHi,x ; $8b3d: b5 c0|
            sta $27,x          ; $8b3f: 95 27     |
            inx                ; $8b41: e8        |
            cpx #$06           ; $8b42: e0 06     |
            bne Loop_8b3d      ; $8b44: d0 f7     | copy spawn timer data to $27-$2c
            jmp __8b5c         ; $8b46: 4c 5c 8b  

;-------------------------------------------------------------------------------
__8b49:     lda NumLives       ; $8b49: a5 0d     
            sta $1e            ; $8b4b: 85 1e     
            lda CurrentBlocks  ; $8b4d: a5 0f     .
            sta $20            ; $8b4f: 85 20     | $20 = current blocks
            ldx #$00           ; $8b51: a2 00     
__8b53:     lda EnemySpawnTimerHi,x ; $8b53: b5 c0     
            sta $2d,x          ; $8b55: 95 2d     
            inx                ; $8b57: e8        
            cpx #$06           ; $8b58: e0 06     
            bne __8b53         ; $8b5a: d0 f7     
__8b5c:     lda NumLives       ; $8b5c: a5 0d     
            beq __8b71         ; $8b5e: f0 11     
            clc                ; $8b60: 18        
            lda $1d            ; $8b61: a5 1d     
            adc $1e            ; $8b63: 65 1e     
            cmp NumLives       ; $8b65: c5 0d     
            bne __8b6a         ; $8b67: d0 01     
            rts                ; $8b69: 60        

;-------------------------------------------------------------------------------
__8b6a:     lda $18            ; $8b6a: a5 18     
            eor $19            ; $8b6c: 45 19     
            sta $19            ; $8b6e: 85 19     
            rts                ; $8b70: 60        

;-------------------------------------------------------------------------------
__8b71:     lda #$50           ; $8b71: a9 50     .
            sta GameState      ; $8b73: 85 0a     | set game state = 0x50
            rts                ; $8b75: 60        

;-------------------------------------------------------------------------------
__8b76:     .hex da            ; $8b76: da        Invalid Opcode - NOP 
            .hex d9 d8 d8      ; $8b77: d9 d8 d8  
            cmp __eada,y       ; $8b7a: d9 da ea  
            sbc #$e8           ; $8b7d: e9 e8     
            inx                ; $8b7f: e8        
            sbc #$ea           ; $8b80: e9 ea     
            .hex fa            ; $8b82: fa        Invalid Opcode - NOP 
            .hex f9 f8 f8      ; $8b83: f9 f8 f8  
            .hex f9 fa         ; $8b86: f9 fa     Suspected data
__8b88:     .hex dd dc db      ; $8b88: dd dc db  
            .hex db dc dd      ; $8b8b: db dc dd  Invalid Opcode - DCP __dddc,y
            sbc __ebec         ; $8b8e: ed ec eb  
            .hex eb ec         ; $8b91: eb ec     Invalid Opcode - SBC #$ec
            sbc __fcfd         ; $8b93: ed fd fc  
            .hex fb fb fc      ; $8b96: fb fb fc  Invalid Opcode - ISC __fcfb,y
            .hex fd            ; $8b99: fd        Suspected data
NextLevel:  inc CurrentLevel   ; $8b9a: e6 1a     
            lda #$05           ; $8b9c: a9 05     .
            sta GameState      ; $8b9e: 85 0a     | set game state = 5 (level loading)
            lda #$3c           ; $8ba0: a9 3c     .
            sta LoadingTimer   ; $8ba2: 8d 3b 01  | init loading timer to 0x3c
            lda $19            ; $8ba5: a5 19     
            bne __8bc6         ; $8ba7: d0 1d     
            lda NumLives       ; $8ba9: a5 0d     
            sta $1d            ; $8bab: 85 1d     
            lda CurrentLevel   ; $8bad: a5 1a     
            sta $21            ; $8baf: 85 21     
            lda #$00           ; $8bb1: a9 00     .
            sta CurrentBlocks  ; $8bb3: 85 0f     | current blocks = 0
            sta TotalBlocks    ; $8bb5: 85 1f     | total blocks = 0
            inc $23            ; $8bb7: e6 23     
            lda $23            ; $8bb9: a5 23     
            cmp #$0a           ; $8bbb: c9 0a     
            bcc __8be2         ; $8bbd: 90 23     
            lda #$00           ; $8bbf: a9 00     
            sta $23            ; $8bc1: 85 23     
            inc $22            ; $8bc3: e6 22     
            rts                ; $8bc5: 60        

;-------------------------------------------------------------------------------
__8bc6:     lda CurrentLevel   ; $8bc6: a5 1a     
            sta $24            ; $8bc8: 85 24     
            lda NumLives       ; $8bca: a5 0d     
            sta $1e            ; $8bcc: 85 1e     
            lda #$00           ; $8bce: a9 00     .
            sta CurrentBlocks  ; $8bd0: 85 0f     | current blocks = 0
            sta $20            ; $8bd2: 85 20     
            inc $26            ; $8bd4: e6 26     
            lda $26            ; $8bd6: a5 26     
            cmp #$0a           ; $8bd8: c9 0a     
            bcc __8be2         ; $8bda: 90 06     
            lda #$00           ; $8bdc: a9 00     
            sta $26            ; $8bde: 85 26     
            inc $25            ; $8be0: e6 25     
__8be2:     rts                ; $8be2: 60        

;-------------------------------------------------------------------------------
ProcessInput:
            lda Buttons        ; $8be3: a5 00     .
            sta PrevButtons    ; $8be5: 85 01     |
            lda ButtonsP2      ; $8be7: a5 02     |
            sta PrevButtonsP2  ; $8be9: 85 03     | Copy button states to previous
            lda ButtonsM       ; $8beb: a5 04     .
            sta PrevButtonsM   ; $8bed: 85 05     | Copy mirrored button states to previous
            lda ButtonsP2M     ; $8bef: a5 06     |
            sta PrevButtonsP2M ; $8bf1: 85 07     |
            lda $08            ; $8bf3: a5 08     
            sta $09            ; $8bf5: 85 09     
            ldy #$08           ; $8bf7: a0 08     . Set loop var to 8
            lda #$01           ; $8bf9: a9 01     .
            sta $4016          ; $8bfb: 8d 16 40  |
            lda #$00           ; $8bfe: a9 00     |
            sta $4016          ; $8c00: 8d 16 40  | Reset joysticks
Loop_8c03:  lda $4016          ; $8c03: ad 16 40  .
            ror                ; $8c06: 6a        |
            rol Buttons        ; $8c07: 26 00     | Store one bit of P1 input
            lda $4017          ; $8c09: ad 17 40  .
            ror                ; $8c0c: 6a        |
            rol ButtonsP2      ; $8c0d: 26 02     | Store one bit of P2 input
            ror                ; $8c0f: 6a        .
            ror                ; $8c10: 6a        |
            ror                ; $8c11: 6a        |
            rol ButtonsP2M     ; $8c12: 26 06     | Store one bit of P2 input in the mirror
            ror                ; $8c14: 6a        
            rol $08            ; $8c15: 26 08     
            dey                ; $8c17: 88        .
            bne Loop_8c03      ; $8c18: d0 e9     | Loop for y = 8..1
            lda $08            ; $8c1a: a5 08     
            beq Next_8c40      ; $8c1c: f0 22     
            eor #$ff           ; $8c1e: 49 ff     
            cmp #$20           ; $8c20: c9 20     
            bcc Next_8c28      ; $8c22: 90 04     
            cmp #$52           ; $8c24: c9 52     
            bcc Next_8c31      ; $8c26: 90 09     
Next_8c28:  sec                ; $8c28: 38        
            sbc #$52           ; $8c29: e9 52     
            sta $08            ; $8c2b: 85 08     
            cmp #$10           ; $8c2d: c9 10     
            bcs Next_8c38      ; $8c2f: b0 07     
Next_8c31:  lda #$10           ; $8c31: a9 10     
            sta $08            ; $8c33: 85 08     
            jmp Next_8c40      ; $8c35: 4c 40 8c  

;-------------------------------------------------------------------------------
Next_8c38:  cmp #$b0           ; $8c38: c9 b0     
            bcc Next_8c40      ; $8c3a: 90 04     
            lda #$b0           ; $8c3c: a9 b0     
            sta $08            ; $8c3e: 85 08     
Next_8c40:  lda Buttons        ; $8c40: a5 00     .
            sta ButtonsM       ; $8c42: 85 04     | copy P1 button state into mirror
            lda $19            ; $8c44: a5 19     
            beq Next_8c4c      ; $8c46: f0 04     
            lda ButtonsP2      ; $8c48: a5 02     .
            sta ButtonsM       ; $8c4a: 85 04     | copy P2 button state into mirror
Next_8c4c:  lda ButtonsP2M     ; $8c4c: a5 06     
            and #$80           ; $8c4e: 29 80     
            ora ButtonsM       ; $8c50: 05 04     
            sta ButtonsM       ; $8c52: 85 04     
            nop                ; $8c54: ea        
            nop                ; $8c55: ea        
            nop                ; $8c56: ea        
            rts                ; $8c57: 60        

;-------------------------------------------------------------------------------
ResetSprites:
            lda #$00           ; $8c58: a9 00     .
            sta $2003          ; $8c5a: 8d 03 20  | Reset sprite memory address
            lda #$02           ; $8c5d: a9 02     .
            sta $4014          ; $8c5f: 8d 14 40  | Move $0200 into sprite memory
            rts                ; $8c62: 60        . return

;-------------------------------------------------------------------------------
RefreshMiscState:
            lda GameState      ; $8c63: a5 0a     .
            cmp #$08           ; $8c65: c9 08     |
            beq __8c6d         ; $8c67: f0 04     |
            cmp #$10           ; $8c69: c9 10     |
            bne Next_8c83      ; $8c6b: d0 16     | if game state != ball not launched or ball active, jump to other sub
__8c6d:     jsr ReactToBlockCollis ; $8c6d: 20 57 8d . else do updates here
            lda JustSpawnedPowerup ; $8c70: ad 3e 01 .
            cmp #$00           ; $8c73: c9 00        |
            bne Next_8c83      ; $8c75: d0 0c        | if we just spawned a powerup, skip some processing
            jsr __b823         ; $8c77: 20 23 b8  
            jsr UpdateWarpGate ; $8c7a: 20 ea b8  
            jsr UpdateEnemyGate; $8c7d: 20 f1 c3  
            jsr __8c8f         ; $8c80: 20 8f 8c  
Next_8c83:  jsr __b7be         ; $8c83: 20 be b7  
            jsr __b895         ; $8c86: 20 95 b8  
            lda #$00           ; $8c89: a9 00        .
            sta JustSpawnedPowerup ; $8c8b: 8d 3e 01 | reset powerup-just-spawned flag
            rts                ; $8c8e: 60        

;-------------------------------------------------------------------------------
__8c8f:     lda IsDemo         ; $8c8f: a5 10     .
            beq __8c94         ; $8c91: f0 01     |
            rts                ; $8c93: 60        | if this is the demo, return

;-------------------------------------------------------------------------------
__8c94:     lda GameState      ; $8c94: a5 0a     
            cmp #$08           ; $8c96: c9 08     
            beq __8caf         ; $8c98: f0 15     
            cmp #$10           ; $8c9a: c9 10     
            beq __8caf         ; $8c9c: f0 11     
            cmp #$18           ; $8c9e: c9 18     
            beq __8ca7         ; $8ca0: f0 05     
            cmp #$20           ; $8ca2: c9 20     
            beq __8caf         ; $8ca4: f0 09     
            rts                ; $8ca6: 60        

;-------------------------------------------------------------------------------
__8ca7:     lda #$00           ; $8ca7: a9 00     
            sta $0136          ; $8ca9: 8d 36 01  
            sta $0137          ; $8cac: 8d 37 01  
__8caf:     lda $0137          ; $8caf: ad 37 01  
            beq __8cb8         ; $8cb2: f0 04     
            dec $0137          ; $8cb4: ce 37 01  
            rts                ; $8cb7: 60        

;-------------------------------------------------------------------------------
__8cb8:     lda #$1e           ; $8cb8: a9 1e     
            sta $0137          ; $8cba: 8d 37 01  
            lda #$06           ; $8cbd: a9 06     
            sta $2001          ; $8cbf: 8d 01 20  
            lda $19            ; $8cc2: a5 19     
            bne __8d09         ; $8cc4: d0 43     
            lda #$20           ; $8cc6: a9 20     
            sta $2006          ; $8cc8: 8d 06 20  
            lda #$f9           ; $8ccb: a9 f9     
            sta $2006          ; $8ccd: 8d 06 20  
            lda $0136          ; $8cd0: ad 36 01  
            bne __8cef         ; $8cd3: d0 1a     
            lda #$2e           ; $8cd5: a9 2e     
            sta $2007          ; $8cd7: 8d 07 20  
            lda #$1e           ; $8cda: a9 1e     
            sta $2007          ; $8cdc: 8d 07 20  
            lda #$19           ; $8cdf: a9 19     
            sta $2007          ; $8ce1: 8d 07 20  
            lda #$00           ; $8ce4: a9 00     
            sta $2005          ; $8ce6: 8d 05 20  
            sta $2005          ; $8ce9: 8d 05 20  
            jmp __8d49         ; $8cec: 4c 49 8d  

;-------------------------------------------------------------------------------
__8cef:     lda #$2d           ; $8cef: a9 2d     
            sta $2007          ; $8cf1: 8d 07 20  
            lda #$2d           ; $8cf4: a9 2d     
            sta $2007          ; $8cf6: 8d 07 20  
            lda #$2d           ; $8cf9: a9 2d     
            sta $2007          ; $8cfb: 8d 07 20  
            lda #$00           ; $8cfe: a9 00     
            sta $2005          ; $8d00: 8d 05 20  
            sta $2005          ; $8d03: 8d 05 20  
            jmp __8d49         ; $8d06: 4c 49 8d  

;-------------------------------------------------------------------------------
__8d09:     lda #$21           ; $8d09: a9 21     
            sta $2006          ; $8d0b: 8d 06 20  
            lda #$59           ; $8d0e: a9 59     
            sta $2006          ; $8d10: 8d 06 20  
            lda $0136          ; $8d13: ad 36 01  
            bne __8d32         ; $8d16: d0 1a     
            lda #$2f           ; $8d18: a9 2f     
            sta $2007          ; $8d1a: 8d 07 20  
            lda #$1e           ; $8d1d: a9 1e     
            sta $2007          ; $8d1f: 8d 07 20  
            lda #$19           ; $8d22: a9 19     
            sta $2007          ; $8d24: 8d 07 20  
            lda #$00           ; $8d27: a9 00     
            sta $2005          ; $8d29: 8d 05 20  
            sta $2005          ; $8d2c: 8d 05 20  
            jmp __8d49         ; $8d2f: 4c 49 8d  

;-------------------------------------------------------------------------------
__8d32:     lda #$2d           ; $8d32: a9 2d     
            sta $2007          ; $8d34: 8d 07 20  
            lda #$2d           ; $8d37: a9 2d     
            sta $2007          ; $8d39: 8d 07 20  
            lda #$2d           ; $8d3c: a9 2d     
            sta $2007          ; $8d3e: 8d 07 20  
            lda #$00           ; $8d41: a9 00     
            sta $2005          ; $8d43: 8d 05 20  
            sta $2005          ; $8d46: 8d 05 20  
__8d49:     lda _PPU_Ctrl2_Mirror ; $8d49: a5 15     
            sta $2001          ; $8d4b: 8d 01 20  
            lda $0136          ; $8d4e: ad 36 01  
            eor #$01           ; $8d51: 49 01     
            sta $0136          ; $8d53: 8d 36 01  
            rts                ; $8d56: 60        

;-------------------------------------------------------------------------------
ReactToBlockCollis:
            lda BlockCollisFlag; $8d57: ad 45 01  .
            sta $012e          ; $8d5a: 8d 2e 01  | copy block collision flag to $012e
            cmp #$00           ; $8d5d: c9 00     .
            beq Ret_8dc2       ; $8d5f: f0 61     | if there isn't a block collision, return
            lda #$06           ; $8d61: a9 06     
            sta $2001          ; $8d63: 8d 01 20  
            ldx #$00           ; $8d66: a2 00     
Loop_8d68:  lda $069a,x        ; $8d68: bd 9a 06  
            cmp #$00           ; $8d6b: c9 00     
            beq Next_8d9b      ; $8d6d: f0 2c     ; check if a block was actually broken last frame
            lda $0698,x        ; $8d6f: bd 98 06  
            sta $2006          ; $8d72: 8d 06 20  
            lda $0699,x        ; $8d75: bd 99 06  
            sta $2006          ; $8d78: 8d 06 20  
            lda $069a,x        ; $8d7b: bd 9a 06  
            sta $2007          ; $8d7e: 8d 07 20  
            clc                ; $8d81: 18        
            adc #$01           ; $8d82: 69 01     
            sta $2007          ; $8d84: 8d 07 20  
            lda #$00           ; $8d87: a9 00     
            sta $2005          ; $8d89: 8d 05 20  
            sta $2005          ; $8d8c: 8d 05 20  
            lda #$15           ; $8d8f: a9 15     
            sta $0126          ; $8d91: 8d 26 01  
            lda #$18           ; $8d94: a9 18     
            sta $0127          ; $8d96: 8d 27 01  
            dec CurrentBlocks  ; $8d99: c6 0f       . Decrement block count
Next_8d9b:  inx                ; $8d9b: e8        
            inx                ; $8d9c: e8        
            inx                ; $8d9d: e8        
            dec $012e          ; $8d9e: ce 2e 01  
            bne Loop_8d68      ; $8da1: d0 c5     
            lda _PPU_Ctrl2_Mirror ; $8da3: a5 15     
            sta $2001          ; $8da5: 8d 01 20  
            lda MuteSoundEffectsTimer ; $8da8: ad 0e 01 .
            bne Ret_8dc2       ; $8dab: d0 15           | if we're muting sound effects, jump ahead
            dex                ; $8dad: ca        
            dex                ; $8dae: ca        
            dex                ; $8daf: ca        
            lda $069a,x        ; $8db0: bd 9a 06  
            cmp #$00           ; $8db3: c9 00     
            beq Next_8dbd      ; $8db5: f0 06     
            lda #$02           ; $8db7: a9 02     .
            jsr PlaySoundEffect; $8db9: 20 c6 f3  | play sound effect 2
            rts                ; $8dbc: 60        . return

;-------------------------------------------------------------------------------
Next_8dbd:  lda #$03           ; $8dbd: a9 03     .
            jsr PlaySoundEffect; $8dbf: 20 c6 f3  |
Ret_8dc2:   rts                ; $8dc2: 60        | play sound effect 3

;-------------------------------------------------------------------------------
UpdateScore:
            jsr UpdatePendingBlockScore ; $8dc3: 20 e6 8e  
            lda #$00           ; $8dc6: a9 00     .
            sta IsScorePending ; $8dc8: 8d 34 01  | Reset score-pending flag
            ldx #$00           ; $8dcb: a2 00     .
Loop_8dcd:  lda PendingScoreTopDigit,x ; $8dcd: bd 7c 03 |
            cmp #$00           ; $8dd0: c9 00     |
            bne Next_8dda      ; $8dd2: d0 06     |
            inx                ; $8dd4: e8        |
            cpx #$06           ; $8dd5: e0 06     |
            bne Loop_8dcd      ; $8dd7: d0 f4     |
            rts                ; $8dd9: 60        | if there's any pending score change, jump to Next_8dda

;-------------------------------------------------------------------------------
Next_8dda:  lda #$01           ; $8dda: a9 01     .
            sta IsScorePending ; $8ddc: 8d 34 01  | Set score-pending flag
            lda #$59           ; $8ddf: a9 59     .
            sta $88            ; $8de1: 85 88     |
            lda #$8e           ; $8de3: a9 8e     |
            sta $89            ; $8de5: 85 89     | set $88 / $89 pointer to $8e59 (value 10)
            lda PendingScoreDigit5 ; $8de7: ad 80 03 .
            cmp #$00           ; $8dea: c9 00     |
            bne Next_8df6      ; $8dec: d0 08     | if the 10s digit is 0,
            lda #$5f           ; $8dee: a9 5f       .
            sta $88            ; $8df0: 85 88       |
            lda #$8e           ; $8df2: a9 8e       |
            sta $89            ; $8df4: 85 89       | set $88 / $89 pointer to $8e5f (value 100)
Next_8df6:  lda #$7c           ; $8df6: a9 7c     .
            sta $86            ; $8df8: 85 86     |
            sta $8a            ; $8dfa: 85 8a     |
            lda #$03           ; $8dfc: a9 03     |
            sta $87            ; $8dfe: 85 87     |
            sta $8b            ; $8e00: 85 8b     | set $86 / $87 and $8a / $8b to $037c (pending score digits)
            ldy #$06           ; $8e02: a0 06     .
            jsr DecimalSubtract; $8e04: 20 bb 92  | subtract 10 or 100 from pending score
            lda #$70           ; $8e07: a9 70     .
            sta $86            ; $8e09: 85 86     |
            sta $8a            ; $8e0b: 85 8a     |
            lda #$03           ; $8e0d: a9 03     |
            sta $87            ; $8e0f: 85 87     |
            sta $8b            ; $8e11: 85 8b     | set $86 / $87 and $8a / $8b to $0370 (score digits)
            lda $19            ; $8e13: a5 19     .
            cmp #$00           ; $8e15: c9 00     |
            beq Next_8e25      ; $8e17: f0 0c     | if $19 == 0,
            lda #$76           ; $8e19: a9 76             .
            sta $86            ; $8e1b: 85 86             |
            sta $8a            ; $8e1d: 85 8a             |
            lda #$03           ; $8e1f: a9 03             |
            sta $87            ; $8e21: 85 87             |
            sta $8b            ; $8e23: 85 8b             | set $86 / $87 and $8a / $8b to $376 (unknown??)
Next_8e25:  ldy #$06           ; $8e25: a0 06         .
            jsr DecimalAdd     ; $8e27: 20 9c 92      | add 10 or 100 to the actual score
            lda IsHighScore    ; $8e2a: ad 35 01      .
            cmp #$00           ; $8e2d: c9 00         |
            bne RegisterNewHighScore ; $8e2f: d0 13   | if the high score flag is set, just go register the new high score immediately 
            ldy #$00           ; $8e31: a0 00         .
Loop_8e33:  lda ($86),y        ; $8e33: b1 86         |
            cmp HighScoreTopDigit,y ; $8e35: d9 66 03 |
            bcc Next_8e55      ; $8e38: 90 1b         |
            bne RegisterNewHighScore ; $8e3a: d0 08   | 
            iny                ; $8e3c: c8            |
            cpy #$06           ; $8e3d: c0 06         |
            bne Loop_8e33      ; $8e3f: d0 f2         | if the current score beats the high score, go set the high score
            jmp Next_8e55      ; $8e41: 4c 55 8e      . continue

;-------------------------------------------------------------------------------
RegisterNewHighScore:
            lda #$01           ; $8e44: a9 01          .
            sta IsHighScore    ; $8e46: 8d 35 01       | Set the high score flag so the checks can be skipped next time
            ldy #$00           ; $8e49: a0 00          .
Loop_8e4b:  lda ($86),y        ; $8e4b: b1 86          |
            sta HighScoreTopDigit,y ; $8e4d: 99 66 03  |
            iny                ; $8e50: c8             |
            cpy #$06           ; $8e51: c0 06          |
            bne Loop_8e4b      ; $8e53: d0 f6          | Copy current score into the high score
Next_8e55:  jsr __8e65         ; $8e55: 20 65 8e  
            rts                ; $8e58: 60        

;-------------------------------------------------------------------------------
__8e59:     .hex 00 00 00 00 01 00
__8e5f:     .hex 00 00 00 01 00 00

__8e65:     lda $018c          ; $8e65: ad 8c 01  
            bne Ret_8ec1       ; $8e68: d0 57     
            ldx #$00           ; $8e6a: a2 00     
            ldy #$00           ; $8e6c: a0 00     
            lda $19            ; $8e6e: a5 19     
            cmp #$00           ; $8e70: c9 00     
            beq __8e76         ; $8e72: f0 02     
            ldx #$02           ; $8e74: a2 02     
__8e76:     lda ($86),y        ; $8e76: b1 86     
            cmp $036c,x        ; $8e78: dd 6c 03  
            bcc Ret_8ec1       ; $8e7b: 90 44     
            bne __8e87         ; $8e7d: d0 08     
            iny                ; $8e7f: c8        
            lda ($86),y        ; $8e80: b1 86     
            cmp $036d,x        ; $8e82: dd 6d 03  
            bcc Ret_8ec1       ; $8e85: 90 3a     
__8e87:     lda $036c,x        ; $8e87: bd 6c 03  
            cmp #$00           ; $8e8a: c9 00     
            bne __8e9d         ; $8e8c: d0 0f     
            lda $036d,x        ; $8e8e: bd 6d 03  
            cmp #$02           ; $8e91: c9 02     
            bne __8e9d         ; $8e93: d0 08     
            lda #$06           ; $8e95: a9 06     
            sta $036d,x        ; $8e97: 9d 6d 03  
            jmp __8eb5         ; $8e9a: 4c b5 8e  

;-------------------------------------------------------------------------------
__8e9d:     clc                ; $8e9d: 18        
            lda $036d,x        ; $8e9e: bd 6d 03  
            adc #$06           ; $8ea1: 69 06     
            sta $036d,x        ; $8ea3: 9d 6d 03  
            cmp #$0a           ; $8ea6: c9 0a     
            bcc __8eb5         ; $8ea8: 90 0b     
            clc                ; $8eaa: 18        
            adc #$06           ; $8eab: 69 06     
            and #$0f           ; $8ead: 29 0f     
            sta $036d,x        ; $8eaf: 9d 6d 03  
            inc $036c,x        ; $8eb2: fe 6c 03  
__8eb5:     inc NumLives       ; $8eb5: e6 0d     . bump life count by 1
            lda #$0e           ; $8eb7: a9 0e     .
            jsr PlaySoundEffect; $8eb9: 20 c6 f3  | play sound effect 0xe (extra life ditty)
            lda #$26           ; $8ebc: a9 26           .
            sta MuteSoundEffectsTimer ; $8ebe: 8d 0e 01 | mute other sound effects for 0x26 frames
Ret_8ec1:   rts                ; $8ec1: 60              . return

;-------------------------------------------------------------------------------
SpawnMultiBall:
            lda #$07           ; $8ec2: a9 07     .
            sta ActiveBalls    ; $8ec4: 85 81     | activate all 3 balls
            ldx #$00           ; $8ec6: a2 00     .
Loop_8ec8:  lda $33,x          ; $8ec8: b5 33     |
            sta $4d,x          ; $8eca: 95 4d     |
            inx                ; $8ecc: e8        |
            cpx #$34           ; $8ecd: e0 34     |
            bne Loop_8ec8      ; $8ecf: d0 f7     | copy ball 1 data to balls 2 and 3
            lda Ball_1_Angle   ; $8ed1: a5 48     .
            asl                ; $8ed3: 0a        |
            tax                ; $8ed4: aa        |
            lda __8ee0,x       ; $8ed5: bd e0 8e  |
            sta $62            ; $8ed8: 85 62     | set ball 2 angle = first byte indexed from table
            lda __8ee1,x       ; $8eda: bd e1 8e  .
            sta $7c            ; $8edd: 85 7c     | set ball 3 angle = second byte indexed from table
            rts                ; $8edf: 60        . return

;-------------------------------------------------------------------------------

___MultiBallAngles:
__8ee0:     .hex 01
__8ee1:     .hex    02   ; ball 1 angle is 0 -> ball 2 gets 01, ball 3 gets 02

            .hex 00 02   ; ball 1 angle is 1 -> ball 2 gets 00, ball 3 gets 02

            .hex 00 01   ; ball 1 angle is 2 -> ball 2 gets 00, ball 3 gets 01

UpdatePendingBlockScore:
            lda BlockCollisFlag; $8ee6: ad 45 01  .
            sta $012e          ; $8ee9: 8d 2e 01  | move block-collision flag to $012e
            ldx #$00           ; $8eec: a2 00     . set x to 0
Loop_8eee:  lda $012e          ; $8eee: ad 2e 01  .
            cmp #$00           ; $8ef1: c9 00     |
            beq Ret_8f3d       ; $8ef3: f0 48     | if there aren't any (more) block collisions, return
            lda $0682,x        ; $8ef5: bd 82 06  .
            and #$f0           ; $8ef8: 29 f0     |
            sta $0131          ; $8efa: 8d 31 01  | store just-hit block type[x] in $0131
            cmp #$f0           ; $8efd: c9 f0     .
            beq __8f34         ; $8eff: f0 33     | if it's a golden block, skip this iteration
            cmp #$e0           ; $8f01: c9 e0     .
            bne __8f17         ; $8f03: d0 12     | if it's a silver block,
            lda #$7e           ; $8f05: a9 7e       .
            sta $88            ; $8f07: 85 88       |
            lda #$8f           ; $8f09: a9 8f       |
            sta $89            ; $8f0b: 85 89       | set $88 / $89 to $8f7e
            lda CurrentLevel   ; $8f0d: a5 1a       .
            asl                ; $8f0f: 0a          |
            clc                ; $8f10: 18          |
            adc CurrentLevel   ; $8f11: 65 1a       |
            asl                ; $8f13: 0a          | load a = level * 6
            jmp Next_8f26      ; $8f14: 4c 26 8f  . else,

;-------------------------------------------------------------------------------
__8f17:     lda #$3e           ; $8f17: a9 3e       .
            sta $88            ; $8f19: 85 88       |
            lda #$8f           ; $8f1b: a9 8f       |
            sta $89            ; $8f1d: 85 89       | else set $88 / $89 to $8f3e
            sec                ; $8f1f: 38          .
            lda $0131          ; $8f20: ad 31 01    |
            sbc #$10           ; $8f23: e9 10       |
            lsr                ; $8f25: 4a          | load a = ($0131 - 0x10) >> 1
Next_8f26:  clc                ; $8f26: 18        .
            adc $88            ; $8f27: 65 88     |
            sta $88            ; $8f29: 85 88     | bump address by the calculated value
            lda $89            ; $8f2b: a5 89     .
            adc #$00           ; $8f2d: 69 00     |
            sta $89            ; $8f2f: 85 89     | no-op
            jsr AddPendingScore; $8f31: 20 56 90  . Add the mapped score to the pending-score value
__8f34:     inx                ; $8f34: e8        .
            inx                ; $8f35: e8        |
            inx                ; $8f36: e8        |
            dec $012e          ; $8f37: ce 2e 01  |
            jmp Loop_8eee      ; $8f3a: 4c ee 8e  | loop for each pending block collision

;-------------------------------------------------------------------------------
Ret_8f3d:   rts                ; $8f3d: 60        . return

;-------------------------------------------------------------------------------

; Score awarded per block.
___RegularBlockScoreTable:
__8f3e:     .hex 00 00 00 00 05 00   00 00   ; White
            .hex 00 00 00 00 06 00   00 00
            .hex 00 00 00 00 07 00   00 00
            .hex 00 00 00 00 08 00   00 00   ; Green
            .hex 00 00 00 00 09 00   00 00   ; Red
            .hex 00 00 00 01 00 00   00 00   ; Orange
            .hex 00 00 00 01 01 00   00 00   ; Pink
            .hex 00 00 00 01 02 00   00 00   ; Blue

; Score awarded for a silver block; varies per level.
___SilverBlockScoreTable
__8f7e:     .hex 00 00 00 00 00 00
            .hex 00 00 00 00 05 00
            .hex 00 00 00 01 00 00
            .hex 00 00 00 01 05 00
            .hex 00 00 00 02 00 00
            .hex 00 00 00 02 05 00
            .hex 00 00 00 03 00 00
            .hex 00 00 00 03 05 00
            .hex 00 00 00 04 00 00
            .hex 00 00 00 04 05 00
            brk                ; $8fba: 00        
            brk                ; $8fbb: 00        
            brk                ; $8fbc: 00        
            ora $00            ; $8fbd: 05 00     
            brk                ; $8fbf: 00        
            brk                ; $8fc0: 00        
            brk                ; $8fc1: 00        
            brk                ; $8fc2: 00        
            ora $05            ; $8fc3: 05 05     
            brk                ; $8fc5: 00        
            brk                ; $8fc6: 00        
            brk                ; $8fc7: 00        
            brk                ; $8fc8: 00        
            asl $00            ; $8fc9: 06 00     
            brk                ; $8fcb: 00        
            brk                ; $8fcc: 00        
            brk                ; $8fcd: 00        
            brk                ; $8fce: 00        
            asl $05            ; $8fcf: 06 05     
            brk                ; $8fd1: 00        
            brk                ; $8fd2: 00        
            brk                ; $8fd3: 00        
            brk                ; $8fd4: 00        
            .hex 07 00         ; $8fd5: 07 00     Invalid Opcode - SLO $00
            brk                ; $8fd7: 00        
            brk                ; $8fd8: 00        
            brk                ; $8fd9: 00        
            brk                ; $8fda: 00        
            .hex 07 05         ; $8fdb: 07 05     Invalid Opcode - SLO $05
            brk                ; $8fdd: 00        
            brk                ; $8fde: 00        
            brk                ; $8fdf: 00        
            brk                ; $8fe0: 00        
            php                ; $8fe1: 08        
            brk                ; $8fe2: 00        
            brk                ; $8fe3: 00        
            brk                ; $8fe4: 00        
            brk                ; $8fe5: 00        
            brk                ; $8fe6: 00        
            php                ; $8fe7: 08        
            ora $00            ; $8fe8: 05 00     
            brk                ; $8fea: 00        
            brk                ; $8feb: 00        
            brk                ; $8fec: 00        
            ora #$00           ; $8fed: 09 00     
            brk                ; $8fef: 00        
            brk                ; $8ff0: 00        
__8ff1:     brk                ; $8ff1: 00        
            brk                ; $8ff2: 00        
            ora #$05           ; $8ff3: 09 05     
            brk                ; $8ff5: 00        
            brk                ; $8ff6: 00        
            brk                ; $8ff7: 00        
            ora ($00,x)        ; $8ff8: 01 00     
            brk                ; $8ffa: 00        
            brk                ; $8ffb: 00        
            brk                ; $8ffc: 00        
            brk                ; $8ffd: 00        
            ora ($00,x)        ; $8ffe: 01 00     
            ora $00            ; $9000: 05 00     
            brk                ; $9002: 00        
            brk                ; $9003: 00        
            ora ($01,x)        ; $9004: 01 01     
            brk                ; $9006: 00        
            brk                ; $9007: 00        
            brk                ; $9008: 00        
            brk                ; $9009: 00        
            ora ($01,x)        ; $900a: 01 01     
            ora $00            ; $900c: 05 00     
            brk                ; $900e: 00        
            brk                ; $900f: 00        
            ora ($02,x)        ; $9010: 01 02     
            brk                ; $9012: 00        
            brk                ; $9013: 00        
            brk                ; $9014: 00        
            brk                ; $9015: 00        
            ora ($02,x)        ; $9016: 01 02     
            ora $00            ; $9018: 05 00     
            brk                ; $901a: 00        
            brk                ; $901b: 00        
            ora ($03,x)        ; $901c: 01 03     
            brk                ; $901e: 00        
            brk                ; $901f: 00        
            brk                ; $9020: 00        
            brk                ; $9021: 00        
            ora ($03,x)        ; $9022: 01 03     
            ora $00            ; $9024: 05 00     
            brk                ; $9026: 00        
            brk                ; $9027: 00        
            ora ($04,x)        ; $9028: 01 04     
            brk                ; $902a: 00        
            brk                ; $902b: 00        
            brk                ; $902c: 00        
            brk                ; $902d: 00        
            ora ($04,x)        ; $902e: 01 04     
            ora $00            ; $9030: 05 00     
            brk                ; $9032: 00        
            brk                ; $9033: 00        
            ora ($05,x)        ; $9034: 01 05     
            brk                ; $9036: 00        
            brk                ; $9037: 00        
            brk                ; $9038: 00        
            brk                ; $9039: 00        
            ora ($05,x)        ; $903a: 01 05     
            ora $00            ; $903c: 05 00     
            brk                ; $903e: 00        
            brk                ; $903f: 00        
            ora ($06,x)        ; $9040: 01 06     
            brk                ; $9042: 00        
            brk                ; $9043: 00        
            brk                ; $9044: 00        
            brk                ; $9045: 00        
            ora ($06,x)        ; $9046: 01 06     
            ora $00            ; $9048: 05 00     
            brk                ; $904a: 00        
            brk                ; $904b: 00        
            ora ($07,x)        ; $904c: 01 07     
            brk                ; $904e: 00        
            brk                ; $904f: 00        
            brk                ; $9050: 00        
            brk                ; $9051: 00        
            ora ($07,x)        ; $9052: 01 07     
            ora $00            ; $9054: 05 00     

AddPendingScore:
            lda IsDemo         ; $9056: a5 10     .
            bne Ret_906b       ; $9058: d0 11     | if this is the demo, return
            lda #$7c           ; $905a: a9 7c     .
            sta $86            ; $905c: 85 86     |
            sta $8a            ; $905e: 85 8a     |
            lda #$03           ; $9060: a9 03     |
            sta $87            ; $9062: 85 87     |
            sta $8b            ; $9064: 85 8b     | set $86 / $87 and $8a / $8b to $037c (pending score)
            ldy #$06           ; $9066: a0 06     .
            jsr DecimalAdd     ; $9068: 20 9c 92  | add the block score to the pending score total
Ret_906b:   rts                ; $906b: 60        . return

;-------------------------------------------------------------------------------
__906c:     lda GameState      ; $906c: a5 0a     .
            cmp #$08           ; $906e: c9 08     |
            beq Next_9076      ; $9070: f0 04     |
            cmp #$10           ; $9072: c9 10     |
            bne Ret_90dc       ; $9074: d0 66     | if game state isn't 8 or 0x10 (level started), return
Next_9076:  lda PaddleTransf   ; $9076: ad 2a 01  .
            cmp #$01           ; $9079: c9 01     |
            bne Ret_90dc       ; $907b: d0 5f     | if the paddle isn't normal, return
            lda PendingPdlTransf ; $907d: ad 29 01  .
            and #$04           ; $9080: 29 04       |
            beq Ret_90dc       ; $9082: f0 58       | if there's no pending laser paddle transformation, return
            lda LaserPdlAnimTimerTick ; $9084: ad 2c 01  .
            cmp #$00           ; $9087: c9 00            |
            beq Next_908f      ; $9089: f0 04            | if the laser animation timer hasn't ticked, go do an update
            dec LaserPdlAnimTimerTick ; $908b: ce 2c 01  .
            rts                ; $908e: 60               | else decrement the animation timer (back to 0)

;-------------------------------------------------------------------------------
Next_908f:  ldx LaserPdlAnimTimer; $908f: ae 2b 01  
            lda __90dd,x       ; $9092: bd dd 90  
            cmp #$ff           ; $9095: c9 ff     
            beq Next_90c8      ; $9097: f0 2f     
            cmp #$ee           ; $9099: c9 ee     
            beq Next_90bb      ; $909b: f0 1e     
            sta $0120          ; $909d: 8d 20 01  
            inc LaserPdlAnimTimer; $90a0: ee 2b 01  
            inc LaserPdlAnimTimerTick ; $90a3: ee 2c 01  
            lda LaserPdlAnimTimer; $90a6: ad 2b 01  .
            cmp #$09           ; $90a9: c9 09       |
            bcc Next_90b4      ; $90ab: 90 07       |
            dec PaddleLeftEdge ; $90ad: ce 1a 01    |  
            inc PaddleRightEdge; $90b0: ee 1f 01    |
            rts                ; $90b3: 60          | if the animation timer >= 9, expand the paddle edges outward

;-------------------------------------------------------------------------------
Next_90b4:  inc PaddleLeftEdge ; $90b4: ee 1a 01    .
            dec PaddleRightEdge; $90b7: ce 1f 01    |
            rts                ; $90ba: 60          | else expand the paddle edges inward

;-------------------------------------------------------------------------------
Next_90bb:  lda __90ef         ; $90bb: ad ef 90        .
            sta $0121          ; $90be: 8d 21 01        |
            inc LaserPdlAnimTimer; $90c1: ee 2b 01      . Update animation timer
            inc LaserPdlAnimTimerTick ; $90c4: ee 2c 01 . Signal animation "tick" (animation should be skipped next frame)
            rts                ; $90c7: 60              . return

;-------------------------------------------------------------------------------
Next_90c8:  lda #$00           ; $90c8: a9 00           .
            sta LaserPdlAnimTimerTick ; $90ca: 8d 2c 01 |
            sta LaserPdlAnimTimer; $90cd: 8d 2b 01      |
            sta PendingPdlTransf ; $90d0: 8d 29 01      | Clear out the animation timer and pending transformation
            lda #$04           ; $90d3: a9 04           .
            sta PaddleTransf   ; $90d5: 8d 2a 01        | Store the new paddle state
            lda #$01           ; $90d8: a9 01     
            sta $d8            ; $90da: 85 d8     
Ret_90dc:   rts                ; $90dc: 60              . return

;-------------------------------------------------------------------------------
__90dd:     .hex 02 03 04 05 06 07 08 2d ee
            .hex 11 10 0f 0e 0d 0c 0b 0a ff

__90ef:     .hex 12

UpdateLaserPdlAnim:
            lda GameState      ; $90f0: a5 0a     .
            cmp #$08           ; $90f2: c9 08     |
            beq Next_90fa      ; $90f4: f0 04     |
            cmp #$10           ; $90f6: c9 10     |
            bne Ret_9161       ; $90f8: d0 67     | if game state != 8 or 0x10 (ball inactive / active), return
Next_90fa:  lda PaddleTransf   ; $90fa: ad 2a 01  .
            cmp #$04           ; $90fd: c9 04     |
            bne Ret_9161       ; $90ff: d0 60     | if the paddle state isn't "laser", return
            lda PendingPdlTransf ; $9101: ad 29 01.
            and #$03           ; $9104: 29 03     |
            beq Ret_9161       ; $9106: f0 59     | if there isn't a non-laser pending transformation, return
            lda LaserPdlAnimTimerTick ; $9108: ad 2c 01.
            cmp #$00           ; $910b: c9 00          |
            beq Next_9113      ; $910d: f0 04          | if the laser animation timer hasn't ticked, go do an update
            dec LaserPdlAnimTimerTick ; $910f: ce 2c 01.
            rts                ; $9112: 60             | else decrement the animation timer (back to 0)

;-------------------------------------------------------------------------------
Next_9113:  ldx LaserPdlAnimTimer; $9113: ae 2b 01  
            lda __9162,x       ; $9116: bd 62 91  
            cmp #$ff           ; $9119: c9 ff     
            beq __914c         ; $911b: f0 2f     
            cmp #$ee           ; $911d: c9 ee     
            beq __913f         ; $911f: f0 1e     
            sta $0120          ; $9121: 8d 20 01  
            inc LaserPdlAnimTimer; $9124: ee 2b 01  
            inc LaserPdlAnimTimerTick ; $9127: ee 2c 01  
            lda LaserPdlAnimTimer; $912a: ad 2b 01  
            cmp #$09           ; $912d: c9 09     
            bcc __9138         ; $912f: 90 07     
            dec PaddleLeftEdge ; $9131: ce 1a 01  
            inc PaddleRightEdge; $9134: ee 1f 01
            rts                ; $9137: 60        

;-------------------------------------------------------------------------------
__9138:     inc PaddleLeftEdge ; $9138: ee 1a 01  
            dec PaddleRightEdge; $913b: ce 1f 01  
            rts                ; $913e: 60        

;-------------------------------------------------------------------------------
__913f:     lda __9174         ; $913f: ad 74 91  
            sta $0121          ; $9142: 8d 21 01  
            inc LaserPdlAnimTimer; $9145: ee 2b 01  
            inc LaserPdlAnimTimerTick ; $9148: ee 2c 01  
            rts                ; $914b: 60        

;-------------------------------------------------------------------------------
__914c:     lda #$00           ; $914c: a9 00     
__914e:     sta LaserPdlAnimTimerTick ; $914e: 8d 2c 01  
            sta LaserPdlAnimTimer; $9151: 8d 2b 01  
            lda PendingPdlTransf ; $9154: ad 29 01  
            and #$02           ; $9157: 29 02     
            sta PendingPdlTransf ; $9159: 8d 29 01  
            lda #$01           ; $915c: a9 01     
            sta PaddleTransf   ; $915e: 8d 2a 01  
Ret_9161:   rts                ; $9161: 60        

;-------------------------------------------------------------------------------
__9162:     .hex 0b 0b         ; $9162: 0b 0b     
            .hex 0d 0e 0f      ; $9164: 0d 0e 0f  
            .hex 10 11         ; $9167: 10 11     
            .hex 2d ee 08      ; $9169: 2d ee 08  
            .hex 07 06         ; $916c: 07 06     
            .hex 05 04         ; $916e: 05 04     
            .hex 03 02         ; $9170: 03 02     
            .hex 01 ff         ; $9172: 01 ff     
__9174:     .hex 09            ; $9174: 09        

UpdateLgPdlAnim:
            lda GameState      ; $9175: a5 0a     .
            cmp #$08           ; $9177: c9 08     |
            beq __917f         ; $9179: f0 04     | if game state == 0x8 (level started, ball not active), continue (pass-through?)
            cmp #$10           ; $917b: c9 10     .
            bne Ret_91e0       ; $917d: d0 61     | if game state != 0x10 (ball active), return
__917f:     lda PaddleTransf   ; $917f: ad 2a 01  .
            cmp #$01           ; $9182: c9 01     |
            bne Ret_91e0       ; $9184: d0 5a     | if the paddle isn't normal, return
            lda PendingPdlTransf ; $9186: ad 29 01.
            and #$02           ; $9189: 29 02     |
            beq Ret_91e0       ; $918b: f0 53     | if the pending paddle transformation isn't large-paddle, return
            dec PaddleLeftEdge     ; $918d: ce 1a 01 .
            dec PaddleLeftCenter   ; $9190: ce 1b 01 |
            inc PaddleRightCenterM ; $9193: ee 1e 01 |
            inc PaddleRightEdge    ; $9196: ee 1f 01 | Expand paddle edges by one step
            lda PaddleLeftEdge ; $9199: ad 1a 01     .
            cmp #$10           ; $919c: c9 10        |
            bcs Next_91b2      ; $919e: b0 12        |
            inc PaddleLeftEdge     ; $91a0: ee 1a 01 |
            inc PaddleLeftCenter   ; $91a3: ee 1b 01 |
            inc PaddleLeftCenterM  ; $91a6: ee 1c 01 |
            inc PaddleRightCenter  ; $91a9: ee 1d 01 |
            inc PaddleRightCenterM ; $91ac: ee 1e 01 |
            inc PaddleRightEdge    ; $91af: ee 1f 01 | Paddle left edge < 0x10? Expand to the right instead
Next_91b2:  lda PaddleRightEdge    ; $91b2: ad 1f 01 .
            cmp #$b1           ; $91b5: c9 b1        |
            bcc Next_91cb      ; $91b7: 90 12        |
            dec PaddleLeftEdge     ; $91b9: ce 1a 01 |
            dec PaddleLeftCenter   ; $91bc: ce 1b 01 |
            dec PaddleLeftCenterM  ; $91bf: ce 1c 01 |
            dec PaddleRightCenter  ; $91c2: ce 1d 01 |
            dec PaddleRightCenterM ; $91c5: ce 1e 01 |
            dec PaddleRightEdge    ; $91c8: ce 1f 01 | Paddle right edge >= 0xb1? Expand to the left instead
Next_91cb:  sec                ; $91cb: 38           .
            lda PaddleLeftCenterM ; $91cc: ad 1c 01  |
            sbc PaddleLeftCenter  ; $91cf: ed 1b 01  |
            cmp #$08           ; $91d2: c9 08        |
            bcc Ret_91e0       ; $91d4: 90 0a        | if the left centerpoints have diverged by at least 8,
            lda #$00           ; $91d6: a9 00          .
            sta PendingPdlTransf ; $91d8: 8d 29 01     | clear the pending transformation (it's done)
            lda #$02           ; $91db: a9 02          .
            sta PaddleTransf   ; $91dd: 8d 2a 01       | set the paddle state to large-paddle
Ret_91e0:   rts                ; $91e0: 60           . return

;-------------------------------------------------------------------------------
__91e1:     lda GameState      ; $91e1: a5 0a     
            cmp #$08           ; $91e3: c9 08     
            beq Next_91eb      ; $91e5: f0 04     
            cmp #$10           ; $91e7: c9 10     
            bne Ret_921a       ; $91e9: d0 2f     
Next_91eb:  lda PaddleTransf   ; $91eb: ad 2a 01  
            cmp #$02           ; $91ee: c9 02     
            bne Ret_921a       ; $91f0: d0 28     
            lda PendingPdlTransf ; $91f2: ad 29 01  
            and #$05           ; $91f5: 29 05     
            beq Ret_921a       ; $91f7: f0 21     
            inc PaddleLeftEdge     ; $91f9: ee 1a 01  
            inc PaddleLeftCenter   ; $91fc: ee 1b 01  
            dec PaddleRightCenterM ; $91ff: ce 1e 01  
            dec PaddleRightEdge    ; $9202: ce 1f 01  
            lda PaddleLeftCenterM  ; $9205: ad 1c 01  
            cmp PaddleLeftCenter   ; $9208: cd 1b 01  
            bne Ret_921a       ; $920b: d0 0d     
            lda PendingPdlTransf ; $920d: ad 29 01  
            and #$04           ; $9210: 29 04     
            sta PendingPdlTransf ; $9212: 8d 29 01  
            lda #$01           ; $9215: a9 01     
            sta PaddleTransf   ; $9217: 8d 2a 01  
Ret_921a:   rts                ; $921a: 60        

;-------------------------------------------------------------------------------
InitPowerupSpritePalette:
            lda JustSpawnedPowerup ; $921b: ad 3e 01 .
            cmp #$00           ; $921e: c9 00        |
            bne Next_9223      ; $9220: d0 01        | if we just spawned a powerup, go to sub
            rts                ; $9222: 60           . return

;-------------------------------------------------------------------------------
Next_9223:  lda SpawnedPowerup ; $9223: a5 8c     .
            sec                ; $9225: 38        |
            sbc #$01           ; $9226: e9 01     |
            asl                ; $9228: 0a        |
            asl                ; $9229: 0a        |
            tax                ; $922a: aa        |
            ldy #$00           ; $922b: a0 00     |
Loop_922d:  lda __923d,x       ; $922d: bd 3d 92  | Use powerup type to index into data
            sta $0162,y        ; $9230: 99 62 01  | copy 4 bytes from table into $0162 based on powerup type
            inx                ; $9233: e8        .
            iny                ; $9234: c8        |
            cpy #$04           ; $9235: c0 04     |
            bne Loop_922d      ; $9237: d0 f4     | loop
            jsr SetSpritePalette ; $9239: 20 3a a4. Update the sprite palette
            rts                ; $923c: 60        . return

;-------------------------------------------------------------------------------
__923d:     .hex 0f 20 26 28      ; $923d: 0f 20 26
            .hex 0f 20 29 28      ; $9241: 0f 20 29
            .hex 0f 20 02 28      ; $9245: 0f 20 02
            .hex 0f 20 21 28      ; $9249: 0f 20 21
            .hex 0f 20 16 28      ; $924d: 0f 20 16
            .hex 0f 20 25 28      ; $9251: 0f 20 25
            .hex 0f 20 00 21      ; $9255: 0f 20 00

_RandNum:   lda $0131          ; $9259: ad 31 01  .
            and #$0f           ; $925c: 29 0f     | get low nibble of input param
            tax                ; $925e: aa        .
            lda __RngTable,x   ; $925f: bd 8c 92  | use it to index into the RNG table
            adc $0131          ; $9262: 6d 31 01  . add to the original value
            adc ScoreDigit4    ; $9265: 6d 73 03  .
            adc ScoreDigit5    ; $9268: 6d 74 03  | add the 4th and 5th score digits (the lowest ones that aren't zero)
            rol                ; $926b: 2a        .
            rol                ; $926c: 2a        | rotate left twice
            adc $0379          ; $926d: 6d 79 03  .
            adc $037a          ; $9270: 6d 7a 03  | add some other mystery values (always seem to be 0?)
            adc PaddleLeftEdge   ; $9273: 6d 1a 01  .
            adc PaddleLeftCenter ; $9276: 6d 1b 01  | add paddle position values
            rol                ; $9279: 2a        .
            rol                ; $927a: 2a        |
            rol                ; $927b: 2a        | rotate left three times
            adc Ball_1_Y       ; $927c: 65 37     .
            adc Ball_1_X       ; $927e: 65 38     | add ball position
            ror                ; $9280: 6a        .
            ror                ; $9281: 6a        | rotate right twice
            inc $0131          ; $9282: ee 31 01  .
            inc $0131          ; $9285: ee 31 01  |
            inc $0131          ; $9288: ee 31 01  | increment input param three times
            rts                ; $928b: 60        . return

;-------------------------------------------------------------------------------
__RngTable: .hex 57 12 f3 bd 33 9c 21 4f     
            .hex 61 e7 0f aa 7e 84 c6 de

DecimalAdd: txa                ; $929c: 8a        
            pha                ; $929d: 48        
            tya                ; $929e: 98        
            pha                ; $929f: 48        
            tax                ; $92a0: aa        
            dey                ; $92a1: 88        
            clc                ; $92a2: 18        
Loop_92a3:  lda ($86),y        ; $92a3: b1 86     .
            adc ($88),y        ; $92a5: 71 88     |
            sta ($8a),y        ; $92a7: 91 8a     | one-digit add: ($8a + y) = ($86 + y) + ($88 + y)
            cmp #$0a           ; $92a9: c9 0a     .
            bcc __92b2         ; $92ab: 90 05     | if the digit overflowed,
            sec                ; $92ad: 38          .
            sbc #$0a           ; $92ae: e9 0a       |
            sta ($8a),y        ; $92b0: 91 8a       | subtract 10 and store the value (note that the carry bit is set for the next iter)
__92b2:     dey                ; $92b2: 88        .
            dex                ; $92b3: ca        |
            bne Loop_92a3      ; $92b4: d0 ed     | loop for each digit
            pla                ; $92b6: 68        
            tay                ; $92b7: a8        
            pla                ; $92b8: 68        
            tax                ; $92b9: aa        
            rts                ; $92ba: 60        

;-------------------------------------------------------------------------------
DecimalSubtract:
            txa                ; $92bb: 8a        
            pha                ; $92bc: 48        
            tya                ; $92bd: 98        
            pha                ; $92be: 48        
            tax                ; $92bf: aa        
            dey                ; $92c0: 88        
            sec                ; $92c1: 38        
__92c2:     lda ($86),y        ; $92c2: b1 86     .
            sbc ($88),y        ; $92c4: f1 88     |
            sta ($8a),y        ; $92c6: 91 8a     | one-digit subtract: ($8a + y) = ($86 + y) - ($88 + y)
            bcs __92d4         ; $92c8: b0 0a     . if the digit underflowed,
            eor #$ff           ; $92ca: 49 ff       .
            sec                ; $92cc: 38          |
            sbc #$0a           ; $92cd: e9 0a       |
            eor #$ff           ; $92cf: 49 ff       |
            sta ($8a),y        ; $92d1: 91 8a       |
            clc                ; $92d3: 18          | wrap the digit around (note that the carry bit is set for the next iter)
__92d4:     dey                ; $92d4: 88        .
            dex                ; $92d5: ca        |
            bne __92c2         ; $92d6: d0 ea     | loop for each digit
            pla                ; $92d8: 68        
            tay                ; $92d9: a8        
            pla                ; $92da: 68        
            tax                ; $92db: aa        
            rts                ; $92dc: 60        

;-------------------------------------------------------------------------------
ProcessGameState:
            lda GameState      ; $92dd: a5 0a     .
            cmp #$00           ; $92df: c9 00     |
            bne __92f4         ; $92e1: d0 11     | if game state == 0 (init)
            jsr __9fdf         ; $92e3: 20 df 9f    
            lda #$01           ; $92e6: a9 01       .
            sta TitleTimerHi   ; $92e8: 85 12       |
            lda #$e0           ; $92ea: a9 e0       |
            sta TitleTimerLo   ; $92ec: 85 13       | set title timer to 0x1e0
            lda #$00           ; $92ee: a9 00       
            sta $0144          ; $92f0: 8d 44 01    
            rts                ; $92f3: 60          . return

;-------------------------------------------------------------------------------
__92f4:     lda GameState      ; $92f4: a5 0a     .
            cmp #$01           ; $92f6: c9 01     |
            bne __92fe         ; $92f8: d0 04     | if game state == 1 (on title screen)
            jsr __9b65         ; $92fa: 20 65 9b    
            rts                ; $92fd: 60          . return

;-------------------------------------------------------------------------------
__92fe:     lda GameState      ; $92fe: a5 0a     .
            cmp #$02           ; $9300: c9 02     |
            bne __930a         ; $9302: d0 06     | if game state == 2 (loading story)
            jsr __a0ca         ; $9304: 20 ca a0    
            inc GameState      ; $9307: e6 0a       . advance game state to 3 (story showing)
            rts                ; $9309: 60          . return

;-------------------------------------------------------------------------------
__930a:     lda GameState      ; $930a: a5 0a     .
            cmp #$03           ; $930c: c9 03     |
            bne Next_9314      ; $930e: d0 04     | if game state == 3 (showing story)
            jsr __a3a7         ; $9310: 20 a7 a3    
            rts                ; $9313: 60          . return

;-------------------------------------------------------------------------------
Next_9314:  lda GameState      ; $9314: a5 0a     .
            cmp #$04           ; $9316: c9 04     |
            bne Next_931e      ; $9318: d0 04     | if game state == 4 (loading level)
            jsr UpdateGameStartTimers ; $931a: 20 38 9f . Update game start timers
            rts                ; $931d: 60          . return

;-------------------------------------------------------------------------------
Next_931e:  lda GameState      ; $931e: a5 0a     .
            cmp #$05           ; $9320: c9 05     |
            bne Next_9328      ; $9322: d0 04     | if game state == 5 ("round X" intro screen)
            jsr LoadLevel      ; $9324: 20 0d 94    . go load the level
            rts                ; $9327: 60          . return

;-------------------------------------------------------------------------------
Next_9328:  lda GameState      ; $9328: a5 0a     .
            cmp #$06           ; $932a: c9 06     |
            bne Next_9351      ; $932c: d0 23     | if game state == 6 (transitioning into level)
            inc GameState      ; $932e: e6 0a       . set game state = 7 (level intro playing)
            lda IsDemo         ; $9330: a5 10       .
            cmp #$00           ; $9332: c9 00       |
            beq Next_9337      ; $9334: f0 01       |
            rts                ; $9336: 60          | if the demo is active, no further processing (return)

;-------------------------------------------------------------------------------
Next_9337:  jsr __9c89         ; $9337: 20 89 9c    
            lda #$80           ; $933a: a9 80       .
            sta LoadingTimer   ; $933c: 8d 3b 01    | init loading timer to 0x80
            lda CurrentLevel   ; $933f: a5 1a       .
            cmp #$24           ; $9341: c9 24       |
            beq Next_934b      ; $9343: f0 06       | if this is the boss level, go play a different sound effect
            lda #$0d           ; $9345: a9 0d       .
            jsr PlaySoundEffect; $9347: 20 c6 f3    | else play sound effect 0xd (level intro dity)
            rts                ; $934a: 60        . return

;-------------------------------------------------------------------------------
Next_934b:  lda #$10           ; $934b: a9 10     .
            jsr PlaySoundEffect; $934d: 20 c6 f3  |
            rts                ; $9350: 60        | play sound effect 0x10 (boss intro ditty)

;-------------------------------------------------------------------------------
Next_9351:  lda GameState      ; $9351: a5 0a     .
            cmp #$07           ; $9353: c9 07     |
            bne Next_936e      ; $9355: d0 17     | if game state == 7 (level intro playing)
            jsr __9ed7         ; $9357: 20 d7 9e    
            jsr InitPaddleAndBall ; $935a: 20 0a 99 . go init the ball and paddle
            lda #$1e           ; $935d: a9 1e       .
            sta $2001          ; $935f: 8d 01 20    |
            sta _PPU_Ctrl2_Mirror ; $9362: 85 15    | Set PPU control reg 2 to 0x1e = 00011110 = show all columns, show sprites everywhere, enable screen, enable sprites
            lda #$08           ; $9364: a9 08       .
            sta GameState      ; $9366: 85 0a       | set game state = 8 (level ready, ball not launched)
            lda #$a0           ; $9368: a9 a0       .
            sta AutoLaunchTimer; $936a: 8d 38 01    | set initial auto-launch timer val to 0xa0
            rts                ; $936d: 60        . return

;-------------------------------------------------------------------------------
Next_936e:  lda GameState      ; $936e: a5 0a     
            cmp #$50           ; $9370: c9 50     
            bne __9384         ; $9372: d0 10     
            lda #$0f           ; $9374: a9 0f     .
            jsr PlaySoundEffect; $9376: 20 c6 f3  | play sound effect 0xf
            jsr __9cb0         ; $9379: 20 b0 9c  
            lda #$80           ; $937c: a9 80     .
            sta LoadingTimer   ; $937e: 8d 3b 01  | init loading timer to 0x80
            inc GameState      ; $9381: e6 0a     
            rts                ; $9383: 60        

;-------------------------------------------------------------------------------
__9384:     lda GameState      ; $9384: a5 0a     
            cmp #$51           ; $9386: c9 51     
            bne __9395         ; $9388: d0 0b     
            jsr __9ed7         ; $938a: 20 d7 9e  
            inc GameState      ; $938d: e6 0a     
            lda #$50           ; $938f: a9 50     .
            sta LoadingTimer   ; $9391: 8d 3b 01  | init loading timer to 0x50
            rts                ; $9394: 60        

;-------------------------------------------------------------------------------
__9395:     lda GameState      ; $9395: a5 0a     
            cmp #$52           ; $9397: c9 52     
            bne __93b1         ; $9399: d0 16     
            lda $1d            ; $939b: a5 1d     
            ora $1e            ; $939d: 05 1e     
            bne __93a6         ; $939f: d0 05     
            lda #$00           ; $93a1: a9 00     
            sta GameState      ; $93a3: 85 0a     
            rts                ; $93a5: 60        

;-------------------------------------------------------------------------------
__93a6:     lda #$05           ; $93a6: a9 05     
            sta GameState      ; $93a8: 85 0a     
            lda $18            ; $93aa: a5 18     
            eor $19            ; $93ac: 45 19     
            sta $19            ; $93ae: 85 19     
            rts                ; $93b0: 60        

;-------------------------------------------------------------------------------
__93b1:     lda GameState      ; $93b1: a5 0a     
            cmp #$60           ; $93b3: c9 60     
            bne __93bd         ; $93b5: d0 06     
            jsr __a111         ; $93b7: 20 11 a1  
            inc GameState      ; $93ba: e6 0a     
            rts                ; $93bc: 60        

;-------------------------------------------------------------------------------
__93bd:     lda GameState      ; $93bd: a5 0a     
            cmp #$61           ; $93bf: c9 61     
            bne __93dc         ; $93c1: d0 19     
            jsr __a3a7         ; $93c3: 20 a7 a3  
            lda _VScrollOffset ; $93c6: a5 16     
            cmp #$ef           ; $93c8: c9 ef     
            beq __93cd         ; $93ca: f0 01     
            rts                ; $93cc: 60        

;-------------------------------------------------------------------------------
__93cd:     lda #$35           ; $93cd: a9 35     
            sta GameState      ; $93cf: 85 0a     
            lda #$06           ; $93d1: a9 06     
            sta $018e          ; $93d3: 8d 8e 01  
            lda #$80           ; $93d6: a9 80     
            sta $018f          ; $93d8: 8d 8f 01  
            rts                ; $93db: 60        

;-------------------------------------------------------------------------------
__93dc:     lda GameState      ; $93dc: a5 0a     
            cmp #$62           ; $93de: c9 62     
            bne __93ea         ; $93e0: d0 08     
            lda #$00           ; $93e2: a9 00     .
            sta _VScrollOffset ; $93e4: 85 16     | Reset vertical scroll offset
            jsr __9ce9         ; $93e6: 20 e9 9c  
            rts                ; $93e9: 60        

;-------------------------------------------------------------------------------
__93ea:     lda GameState      ; $93ea: a5 0a     
            cmp #$63           ; $93ec: c9 63     
            bne __940c         ; $93ee: d0 1c     
            lda #$06           ; $93f0: a9 06     
            sta $2001          ; $93f2: 8d 01 20  
            sta _PPU_Ctrl2_Mirror ; $93f5: 85 15     
            lda $1d            ; $93f7: a5 1d     
            ora $1e            ; $93f9: 05 1e     
            beq __9408         ; $93fb: f0 0b     
            lda $18            ; $93fd: a5 18     
            eor $19            ; $93ff: 45 19     
            sta $19            ; $9401: 85 19     
            lda #$05           ; $9403: a9 05     
            sta GameState      ; $9405: 85 0a     
            rts                ; $9407: 60        

;-------------------------------------------------------------------------------
__9408:     lda #$00           ; $9408: a9 00     
            sta GameState      ; $940a: 85 0a     
__940c:     rts                ; $940c: 60        

;-------------------------------------------------------------------------------
LoadLevel:  lda #$06           ; $940d: a9 06     
            sta $2001          ; $940f: 8d 01 20  
            lda $0b            ; $9412: a5 0b     
            cmp #$00           ; $9414: c9 00     
            bne Next_9427      ; $9416: d0 0f     
            jsr __9fcd         ; $9418: 20 cd 9f  
            jsr __a19a         ; $941b: 20 9a a1  
            jsr __947b         ; $941e: 20 7b 94  
            jsr __9fba         ; $9421: 20 ba 9f  
            inc $0b            ; $9424: e6 0b     
            rts                ; $9426: 60        

;-------------------------------------------------------------------------------
Next_9427:  lda $0b            ; $9427: a5 0b     
            cmp #$01           ; $9429: c9 01     
            beq __943d         ; $942b: f0 10     
            cmp #$02           ; $942d: c9 02     
            beq __943d         ; $942f: f0 0c     
            cmp #$03           ; $9431: c9 03     
            beq __943d         ; $9433: f0 08     
            cmp #$04           ; $9435: c9 04     
            beq __943d         ; $9437: f0 04     
            cmp #$05           ; $9439: c9 05     
            bne __944c         ; $943b: d0 0f     
__943d:     lda IsDemo         ; $943d: a5 10     .
            beq __9446         ; $943f: f0 05     | if this is the demo
            lda #$06           ; $9441: a9 06       .
            sta $0b            ; $9443: 85 0b       | set $0b to 6
            rts                ; $9445: 60        . return

;-------------------------------------------------------------------------------
__9446:     jsr __95fe         ; $9446: 20 fe 95  
            inc $0b            ; $9449: e6 0b     
            rts                ; $944b: 60        

;-------------------------------------------------------------------------------
__944c:     lda $0b            ; $944c: a5 0b     
            cmp #$06           ; $944e: c9 06     
            bne __945e         ; $9450: d0 0c     
            jsr __9ae5         ; $9452: 20 e5 9a  
            jsr __a412         ; $9455: 20 12 a4  
            jsr SetSpritePalette ; $9458: 20 3a a4  
            inc $0b            ; $945b: e6 0b     
            rts                ; $945d: 60        

;-------------------------------------------------------------------------------
__945e:     lda $0b            ; $945e: a5 0b     
            cmp #$07           ; $9460: c9 07     
            bne __946a         ; $9462: d0 06     
            jsr __968b         ; $9464: 20 8b 96  
            inc $0b            ; $9467: e6 0b     
            rts                ; $9469: 60        

;-------------------------------------------------------------------------------
__946a:     jsr __97ab         ; $946a: 20 ab 97  
            lda #$00           ; $946d: a9 00     
            sta $0b            ; $946f: 85 0b     
            inc GameState      ; $9471: e6 0a     
            lda #$1e           ; $9473: a9 1e     
            sta $2001          ; $9475: 8d 01 20  
            sta _PPU_Ctrl2_Mirror ; $9478: 85 15     
            rts                ; $947a: 60        

;-------------------------------------------------------------------------------
__947b:     lda IsDemo         ; $947b: a5 10     .
            cmp #$00           ; $947d: c9 00     |
            beq Next_94a1      ; $947f: f0 20     | if the demo is active,
            lda #$00           ; $9481: a9 00       .
            sta TotalBlocks    ; $9483: 85 1f       | set total blocks = 0
            sta $19            ; $9485: 85 19     
            lda #$01           ; $9487: a9 01     
            sta $1d            ; $9489: 85 1d     
            inc DemoLevelIdx   ; $948b: e6 11       . Advance demo level index
            ldx DemoLevelIdx   ; $948d: a6 11       .
            lda __DemoLvlIds,x ; $948f: bd 68 95    | grab the demo level number
            sta CurrentLevelM  ; $9492: 85 21       . Set current level number
            cmp #$ff           ; $9494: c9 ff       .
            bne Next_94a1      ; $9496: d0 09       | if demo level ID == 0xff
            ldx #$00           ; $9498: a2 00         .
            stx DemoLevelIdx   ; $949a: 86 11         |
            lda __DemoLvlIds,x ; $949c: bd 68 95      | grab demo level number at idx 0
            sta CurrentLevelM  ; $949f: 85 21         . set current level number
Next_94a1:  lda $19            ; $94a1: a5 19     
            cmp #$00           ; $94a3: c9 00     
            bne __9507         ; $94a5: d0 60     
            lda #$a0           ; $94a7: a9 a0     .
            sta BlockRamAddrLo ; $94a9: 85 84     |
            lda #$03           ; $94ab: a9 03     |
            sta BlockRamAddrHi ; $94ad: 85 85     | set block data addr = $03a0
            lda $1d            ; $94af: a5 1d     
            sta NumLives       ; $94b1: 85 0d     
            lda #$00           ; $94b3: a9 00     
            sta $0e            ; $94b5: 85 0e     
            lda TotalBlocks    ; $94b7: a5 1f     .
            sta CurrentBlocks  ; $94b9: 85 0f     | current blocks = total blocks
            lda CurrentLevelM  ; $94bb: a5 21     .
            sta CurrentLevel   ; $94bd: 85 1a     | copy current level number
            lda $22            ; $94bf: a5 22     
            sta $1b            ; $94c1: 85 1b     
            lda $23            ; $94c3: a5 23     
            sta $1c            ; $94c5: 85 1c     
            ldx #$00           ; $94c7: a2 00     . for each spawn timer byte,
Loop_94c9:  lda $27,x          ; $94c9: b5 27       .
            sta EnemySpawnTimerHi,x ; $94cb: 95 c0  | copy $27[x] into the byte
            inx                ; $94cd: e8        .
            cpx #$06           ; $94ce: e0 06     |
            bne Loop_94c9      ; $94d0: d0 f7     | loop 0..5
            lda CurrentLevelM  ; $94d2: a5 21     .
            cmp #$24           ; $94d4: c9 24     |
            bne __94dc         ; $94d6: d0 04     | if level == 0x24 (boss level)
            lda #$00           ; $94d8: a9 00       .
            sta TotalBlocks    ; $94da: 85 1f       | total blocks = 0
__94dc:     lda TotalBlocks    ; $94dc: a5 1f     .
            cmp #$00           ; $94de: c9 00     |
            bne Next_9504      ; $94e0: d0 22     | if total blocks == 0, move on
            ldx CurrentLevelM  ; $94e2: a6 21     
            jsr __956e         ; $94e4: 20 6e 95  
            lda CurrentBlocks  ; $94e7: a5 0f     .
            sta TotalBlocks    ; $94e9: 85 1f     | total blocks = current blocks
            lda CurrentLevel   ; $94eb: a5 1a     
            asl                ; $94ed: 0a        
            clc                ; $94ee: 18        
            adc CurrentLevel   ; $94ef: 65 1a     
            asl                ; $94f1: 0a        
            tax                ; $94f2: aa        | set x = ((current level * 2) + current level) * 2
            ldy #$00           ; $94f3: a0 00     
Loop_94f5:  lda __EnemySpawnTimerTable,x ; $94f5: bd e9 99  
            sta $0027,y        ; $94f8: 99 27 00  
            sta EnemySpawnTimerHi,y ; $94fb: 99 c0 00  
            inx                ; $94fe: e8        
            iny                ; $94ff: c8        
            cpy #$06           ; $9500: c0 06     
            bne Loop_94f5      ; $9502: d0 f1     
Next_9504:  jmp __9564         ; $9504: 4c 64 95  

;-------------------------------------------------------------------------------
__9507:     lda #$10           ; $9507: a9 10     .
            sta BlockRamAddrLo ; $9509: 85 84     |
            lda #$05           ; $950b: a9 05     |
            sta BlockRamAddrHi ; $950d: 85 85     | set block data addr = $0510
            lda $1e            ; $950f: a5 1e     
            sta NumLives       ; $9511: 85 0d     
            lda #$00           ; $9513: a9 00     
            sta $0e            ; $9515: 85 0e     
            lda $20            ; $9517: a5 20     .
            sta CurrentBlocks  ; $9519: 85 0f     | current blocks = $20
            lda $24            ; $951b: a5 24     
            sta CurrentLevel   ; $951d: 85 1a     
            lda $25            ; $951f: a5 25     
            sta $1b            ; $9521: 85 1b     
            lda $26            ; $9523: a5 26     
            sta $1c            ; $9525: 85 1c     
            ldx #$00           ; $9527: a2 00     
__9529:     lda $2d,x          ; $9529: b5 2d     
            sta EnemySpawnTimerHi,x ; $952b: 95 c0     
            inx                ; $952d: e8        
            cpx #$06           ; $952e: e0 06     
            bne __9529         ; $9530: d0 f7     
            lda $24            ; $9532: a5 24     
            cmp #$24           ; $9534: c9 24     
            bne __953c         ; $9536: d0 04     
            lda #$00           ; $9538: a9 00     
            sta $20            ; $953a: 85 20     
__953c:     lda $20            ; $953c: a5 20     
            cmp #$00           ; $953e: c9 00     
            bne __9564         ; $9540: d0 22     
            ldx $24            ; $9542: a6 24     
            jsr __956e         ; $9544: 20 6e 95  
            lda CurrentBlocks  ; $9547: a5 0f     .
            sta $20            ; $9549: 85 20     | $20 = current blocks
            lda CurrentLevel   ; $954b: a5 1a     
            asl                ; $954d: 0a        
            clc                ; $954e: 18        
            adc CurrentLevel   ; $954f: 65 1a     
            asl                ; $9551: 0a        
            tax                ; $9552: aa        
            ldy #$00           ; $9553: a0 00     
__9555:     lda __EnemySpawnTimerTable,x ; $9555: bd e9 99  
            sta $002d,y        ; $9558: 99 2d 00  
            sta EnemySpawnTimerHi,y ; $955b: 99 c0 00  
            inx                ; $955e: e8        
            iny                ; $955f: c8        
            cpy #$06           ; $9560: c0 06     
            bne __9555         ; $9562: d0 f1     
__9564:     jsr __9b08         ; $9564: 20 08 9b  
            rts                ; $9567: 60        

;-------------------------------------------------------------------------------

; Demo level IDs (starts from index 1 and wraps)
__DemoLvlIds:
            .hex 05 0e 0f 17 1e ff

__956e:     lda BlockRamAddrLo ; $956e: a5 84     .
            sta $86            ; $9570: 85 86     |
            lda BlockRamAddrHi ; $9572: a5 85     |
            sta $87            ; $9574: 85 87     | Write block data ram addr into $86 / $87
            lda #$c0           ; $9576: a9 c0     .
            sta $88            ; $9578: 85 88     |
            lda #$c6           ; $957a: a9 c6     |
            sta $89            ; $957c: 85 89     | Write level 1 data addr c6c0 into $88 / $89
            dex                ; $957e: ca        
            txa                ; $957f: 8a        
            pha                ; $9580: 48        
Loop_9581:  cpx #$00           ; $9581: e0 00     
            beq Next_958a      ; $9583: f0 05     
            inc $89            ; $9585: e6 89     
            dex                ; $9587: ca        
            bne Loop_9581      ; $9588: d0 f7     
Next_958a:  ldy #$00           ; $958a: a0 00     
__958c:     lda ($88),y        ; $958c: b1 88     
            sta ($86),y        ; $958e: 91 86     
            iny                ; $9590: c8        
            cpy #$df           ; $9591: c0 df     
            bne __958c         ; $9593: d0 f7     
            sty $012f          ; $9595: 8c 2f 01  
Loop_9598:  lda #$00           ; $9598: a9 00     
            sta ($86),y        ; $959a: 91 86     
            iny                ; $959c: c8        
            cpy #$00           ; $959d: c0 00     
            bne __95a3         ; $959f: d0 02     
            inc $87            ; $95a1: e6 87     
__95a3:     cpy #$10           ; $95a3: c0 10     
            bne Loop_9598      ; $95a5: d0 f1     
            sty $012e          ; $95a7: 8c 2e 01  
Loop_95aa:  ldy $012f          ; $95aa: ac 2f 01  
            lda ($88),y        ; $95ad: b1 88     
            ldy $012e          ; $95af: ac 2e 01  
            sta ($86),y        ; $95b2: 91 86     
            inc $012e          ; $95b4: ee 2e 01  
            inc $012f          ; $95b7: ee 2f 01  
            bne Loop_95aa      ; $95ba: d0 ee     
            ldy #$ff           ; $95bc: a0 ff     .
            lda ($88),y        ; $95be: b1 88     |
            sta CurrentBlocks  ; $95c0: 85 0f     | set block count for current level
            dec $012e          ; $95c2: ce 2e 01  
            pla                ; $95c5: 68        
            sta $88            ; $95c6: 85 88     
            lda #$00           ; $95c8: a9 00     
            sta $89            ; $95ca: 85 89     
            ldx #$06           ; $95cc: a2 06     
__95ce:     clc                ; $95ce: 18        
            asl $88            ; $95cf: 06 88     
            rol $89            ; $95d1: 26 89     
            dex                ; $95d3: ca        
            bne __95ce         ; $95d4: d0 f8     
            clc                ; $95d6: 18        
            lda #$c0           ; $95d7: a9 c0     
            adc $88            ; $95d9: 65 88     
            sta $88            ; $95db: 85 88     
            lda #$ea           ; $95dd: a9 ea     
            adc $89            ; $95df: 65 89     
            sta $89            ; $95e1: 85 89     
            lda #$00           ; $95e3: a9 00     
            sta $012f          ; $95e5: 8d 2f 01  
            ldx #$40           ; $95e8: a2 40     
Loop_95ea:  ldy $012f          ; $95ea: ac 2f 01  
            lda ($88),y        ; $95ed: b1 88     
            ldy $012e          ; $95ef: ac 2e 01  
            sta ($86),y        ; $95f2: 91 86     
            inc $012e          ; $95f4: ee 2e 01  
            inc $012f          ; $95f7: ee 2f 01  
            dex                ; $95fa: ca        
            bne Loop_95ea      ; $95fb: d0 ed     
            rts                ; $95fd: 60        

;-------------------------------------------------------------------------------
__95fe:     lda $0b            ; $95fe: a5 0b     
            cmp #$01           ; $9600: c9 01     
            bne __960c         ; $9602: d0 08     
            ldy #$20           ; $9604: a0 20     
            ldx #$00           ; $9606: a2 00     
            jsr __a3ee         ; $9608: 20 ee a3  
            rts                ; $960b: 60        

;-------------------------------------------------------------------------------
__960c:     lda $0b            ; $960c: a5 0b     
            cmp #$02           ; $960e: c9 02     
            bne __9627         ; $9610: d0 15     
            ldy #$28           ; $9612: a0 28     
            ldx #$00           ; $9614: a2 00     
            jsr __a3ee         ; $9616: 20 ee a3  
            ldx #$00           ; $9619: a2 00     
__961b:     lda __a06a,x       ; $961b: bd 6a a0  
            sta $0146,x        ; $961e: 9d 46 01  
            inx                ; $9621: e8        
            cpx #$10           ; $9622: e0 10     
            bne __961b         ; $9624: d0 f5     
            rts                ; $9626: 60        

;-------------------------------------------------------------------------------
__9627:     lda $0b            ; $9627: a5 0b     
            cmp #$03           ; $9629: c9 03     
            bne __9631         ; $962b: d0 04     
            jsr __a412         ; $962d: 20 12 a4  
            rts                ; $9630: 60        

;-------------------------------------------------------------------------------
__9631:     lda $0b            ; $9631: a5 0b     
            cmp #$04           ; $9633: c9 04     
            bne __9645         ; $9635: d0 0e     
            lda #$5a           ; $9637: a9 5a     
            sta $86            ; $9639: 85 86     
            lda #$a1           ; $963b: a9 a1     
            sta $87            ; $963d: 85 87     
            lda #$23           ; $963f: a9 23     
            jsr __a462         ; $9641: 20 62 a4  
            rts                ; $9644: 60        

;-------------------------------------------------------------------------------
__9645:     ldy #$20           ; $9645: a0 20     
            jsr __a2a8         ; $9647: 20 a8 a2  
            lda #$82           ; $964a: a9 82     
            sta $86            ; $964c: 85 86     
            lda #$96           ; $964e: a9 96     
            sta $87            ; $9650: 85 87     
            jsr __a3c3         ; $9652: 20 c3 a3  
            lda #$21           ; $9655: a9 21     
            sta $2006          ; $9657: 8d 06 20  
            lda #$d2           ; $965a: a9 d2     
            sta $2006          ; $965c: 8d 06 20  
            lda $1b            ; $965f: a5 1b     
            cmp #$00           ; $9661: c9 00     
            bne __9667         ; $9663: d0 02     
            lda #$2d           ; $9665: a9 2d     
__9667:     sta $2007          ; $9667: 8d 07 20  
            lda $1c            ; $966a: a5 1c     
            sta $2007          ; $966c: 8d 07 20  
            lda #$00           ; $966f: a9 00     
            sta $2005          ; $9671: 8d 05 20  
            sta $2005          ; $9674: 8d 05 20  
            lda #$64           ; $9677: a9 64     .
            sta LoadingTimer   ; $9679: 8d 3b 01  | init loading timer to 0x64
            lda #$0e           ; $967c: a9 0e     
            sta $2001          ; $967e: 8d 01 20  
            rts                ; $9681: 60        

;-------------------------------------------------------------------------------
            .hex 21 cc 05

            ;     R  O  U  N  D
            .hex 1b 18 1e 17 0d
            .hex ff

__968b:     ldy #$20           ; $968b: a0 20     
            ldx #$00           ; $968d: a2 00     
            jsr __a3ee         ; $968f: 20 ee a3  
            lda #$d0           ; $9692: a9 d0     
            sta $86            ; $9694: 85 86     
            lda #$04           ; $9696: a9 04     
            sta $87            ; $9698: 85 87     
            lda $19            ; $969a: a5 19     
            cmp #$00           ; $969c: c9 00     
            beq __96a8         ; $969e: f0 08     
            lda #$40           ; $96a0: a9 40     
            sta $86            ; $96a2: 85 86     
            lda #$06           ; $96a4: a9 06     
            sta $87            ; $96a6: 85 87     
__96a8:     lda #$23           ; $96a8: a9 23     
            jsr __a462         ; $96aa: 20 62 a4  
            lda #$50           ; $96ad: a9 50     
            sta $86            ; $96af: 85 86     
            lda #$97           ; $96b1: a9 97     
            sta $87            ; $96b3: 85 87     
            jsr __a3c3         ; $96b5: 20 c3 a3  
            lda #$14           ; $96b8: a9 14     
            sta $2000          ; $96ba: 8d 00 20  
            lda #$6c           ; $96bd: a9 6c     
            sta $86            ; $96bf: 85 86     
            lda #$97           ; $96c1: a9 97     
            sta $87            ; $96c3: 85 87     
            jsr __a3c3         ; $96c5: 20 c3 a3  
            lda #$10           ; $96c8: a9 10     
            sta $2000          ; $96ca: 8d 00 20  
            lda #$2a           ; $96cd: a9 2a     
            sta $86            ; $96cf: 85 86     
            lda #$97           ; $96d1: a9 97     
            sta $87            ; $96d3: 85 87     
            jsr __a3c3         ; $96d5: 20 c3 a3  
            jsr __b7f3         ; $96d8: 20 f3 b7  
            jsr __b803         ; $96db: 20 03 b8  
            lda IsDemo         ; $96de: a5 10     .
            cmp #$00           ; $96e0: c9 00     |
            beq __96e5         ; $96e2: f0 01     |
            rts                ; $96e4: 60        | if this is the demo, return

;-------------------------------------------------------------------------------
__96e5:     lda $18            ; $96e5: a5 18     
            cmp #$00           ; $96e7: c9 00     
            beq __96f9         ; $96e9: f0 0e     
            lda #$40           ; $96eb: a9 40     
            sta $86            ; $96ed: 85 86     
            lda #$97           ; $96ef: a9 97     
            sta $87            ; $96f1: 85 87     
            jsr __a3c3         ; $96f3: 20 c3 a3  
            jsr __b813         ; $96f6: 20 13 b8  
__96f9:     jsr __b823         ; $96f9: 20 23 b8  
            lda #$47           ; $96fc: a9 47     
            sta $86            ; $96fe: 85 86     
            lda #$97           ; $9700: a9 97     
            sta $87            ; $9702: 85 87     
            jsr __a3c3         ; $9704: 20 c3 a3  
            lda #$23           ; $9707: a9 23     
            sta $2006          ; $9709: 8d 06 20  
            lda #$5d           ; $970c: a9 5d     
            sta $2006          ; $970e: 8d 06 20  
            lda $1b            ; $9711: a5 1b     
            cmp #$00           ; $9713: c9 00     
            bne __9719         ; $9715: d0 02     
            lda #$2d           ; $9717: a9 2d     
__9719:     sta $2007          ; $9719: 8d 07 20  
            lda $1c            ; $971c: a5 1c     
            sta $2007          ; $971e: 8d 07 20  
            lda #$00           ; $9721: a9 00     
            sta $2005          ; $9723: 8d 05 20  
            sta $2005          ; $9726: 8d 05 20  
            rts                ; $9729: 60        

;-------------------------------------------------------------------------------
            .hex 20 79 04
            ;     H  I  G  H
            .hex 11 12 10 11
            .hex 20 9a 05
            ;     S  C  O  R  E
            .hex 1c 0c 18 1b 0e
            .hex 20 f9 03
            ;     1  U  P
            .hex 2e 1e 19
            .hex ff
            
            .hex 21 59 03
            ;     1  U  P
            .hex 2f 1e 19
            .hex ff  
            
            .hex 23 3a 05
            ;     R  O  U  N  D
            .hex 1b 18 1e 17 0d
            .hex ff
            
            .hex 20 21 18
            .hex 84 94 94 94 94 80 81 82 95 94 94 94 94 94 94 94 80 81 82 95 94 94 94 85
            .hex ff
            
            .hex 20 41 1c
            .hex a5 a5 86 96 a6 a4 a5 a5 a5 86 96 a6 a4 a5 a5 a5 86 96 a6 a4 a5 a5 a5 86 96 a6 a4 a5

            .hex 20 58 1c
            .hex a5 a5 86 96 a6 a4 a5 a5 a5 86 96 a6 a4 a5 a5 a5 86 96 a6 a4 a5 a5 a5 86 96 a6 a4 a5
            .hex ff

__97ab:     lda CurrentLevelM  ; $97ab: a5 21     
            ldy $19            ; $97ad: a4 19     
            cpy #$00           ; $97af: c0 00     
            beq __97b5         ; $97b1: f0 02     
            lda $24            ; $97b3: a5 24     
__97b5:     cmp #$24           ; $97b5: c9 24     
            beq __97bc         ; $97b7: f0 03     
            sec                ; $97b9: 38        
            sbc #$01           ; $97ba: e9 01     
__97bc:     and #$03           ; $97bc: 29 03     
            ldx #$c0           ; $97be: a2 c0     
            cmp #$00           ; $97c0: c9 00     
            beq __97d2         ; $97c2: f0 0e     
            ldx #$c4           ; $97c4: a2 c4     
            cmp #$01           ; $97c6: c9 01     
            beq __97d2         ; $97c8: f0 08     
            ldx #$c8           ; $97ca: a2 c8     
            cmp #$02           ; $97cc: c9 02     
            beq __97d2         ; $97ce: f0 02     
            ldx #$cc           ; $97d0: a2 cc     
__97d2:     stx $0131          ; $97d2: 8e 31 01  
            lda #$b0           ; $97d5: a9 b0     
            sta $86            ; $97d7: 85 86     
            lda #$06           ; $97d9: a9 06     
            sta $87            ; $97db: 85 87     
            lda #$1c           ; $97dd: a9 1c     
            sta $012e          ; $97df: 8d 2e 01  
            lda #$00           ; $97e2: a9 00     
            sta $0132          ; $97e4: 8d 32 01  
            ldy #$00           ; $97e7: a0 00     
__97e9:     ldx #$0b           ; $97e9: a2 0b     
__97eb:     clc                ; $97eb: 18        
            lda $0131          ; $97ec: ad 31 01  
            adc $0132          ; $97ef: 6d 32 01  
            sta ($86),y        ; $97f2: 91 86     
            iny                ; $97f4: c8        
            bne __97f9         ; $97f5: d0 02     
            inc $87            ; $97f7: e6 87     
__97f9:     inc $0132          ; $97f9: ee 32 01  
            inc $0132          ; $97fc: ee 32 01  
            lda $0132          ; $97ff: ad 32 01  
            and #$33           ; $9802: 29 33     
            sta $0132          ; $9804: 8d 32 01  
            dex                ; $9807: ca        
            bne __97eb         ; $9808: d0 e1     
            clc                ; $980a: 18        
            lda $0132          ; $980b: ad 32 01  
            adc #$10           ; $980e: 69 10     
            and #$30           ; $9810: 29 30     
            sta $0132          ; $9812: 8d 32 01  
            dec $012e          ; $9815: ce 2e 01  
            bne __97e9         ; $9818: d0 cf     
            lda #$a0           ; $981a: a9 a0     
            sta $86            ; $981c: 85 86     
            lda #$03           ; $981e: a9 03     
            sta $87            ; $9820: 85 87     
            lda #$c0           ; $9822: a9 c0     
            sta $88            ; $9824: 85 88     
            lda #$04           ; $9826: a9 04     
            sta $89            ; $9828: 85 89     
            ldy $19            ; $982a: a4 19     
            cpy #$00           ; $982c: c0 00     
            beq __9840         ; $982e: f0 10     
            lda #$10           ; $9830: a9 10     
            sta $86            ; $9832: 85 86     
            lda #$05           ; $9834: a9 05     
            sta $87            ; $9836: 85 87     
            lda #$30           ; $9838: a9 30     
            sta $88            ; $983a: 85 88     
            lda #$06           ; $983c: a9 06     
            sta $89            ; $983e: 85 89     
__9840:     lda #$b0           ; $9840: a9 b0     
            sta $8a            ; $9842: 85 8a     
            lda #$06           ; $9844: a9 06     
            sta $8b            ; $9846: 85 8b     
            lda #$00           ; $9848: a9 00     
            sta $0131          ; $984a: 8d 31 01  
__984d:     ldy $0131          ; $984d: ac 31 01  
            lda ($86),y        ; $9850: b1 86     
            cmp #$00           ; $9852: c9 00     
            beq __9866         ; $9854: f0 10     
            lsr                ; $9856: 4a        
            lsr                ; $9857: 4a        
            lsr                ; $9858: 4a        
            lsr                ; $9859: 4a        
            tay                ; $985a: a8        
            lda ($88),y        ; $985b: b1 88     
            cmp #$00           ; $985d: c9 00     
            beq __9866         ; $985f: f0 05     
            ldy $0131          ; $9861: ac 31 01  
            sta ($8a),y        ; $9864: 91 8a     
__9866:     inc $0131          ; $9866: ee 31 01  
            bne __984d         ; $9869: d0 e2     
            lda #$1c           ; $986b: a9 1c     
            sta $012e          ; $986d: 8d 2e 01  
            ldy #$00           ; $9870: a0 00     
            lda #$b0           ; $9872: a9 b0     
            sta $86            ; $9874: 85 86     
            lda #$06           ; $9876: a9 06     
            sta $87            ; $9878: 85 87     
            lda #$20           ; $987a: a9 20     
            sta $88            ; $987c: 85 88     
            lda #$42           ; $987e: a9 42     
            sta $89            ; $9880: 85 89     
__9882:     lda $88            ; $9882: a5 88     
            sta $2006          ; $9884: 8d 06 20  
            lda $89            ; $9887: a5 89     
            sta $2006          ; $9889: 8d 06 20  
            ldx #$0b           ; $988c: a2 0b     
__988e:     lda ($86),y        ; $988e: b1 86     
            sta $2007          ; $9890: 8d 07 20  
            clc                ; $9893: 18        
            adc #$01           ; $9894: 69 01     
            sta $2007          ; $9896: 8d 07 20  
            iny                ; $9899: c8        
            bne __989e         ; $989a: d0 02     
            inc $87            ; $989c: e6 87     
__989e:     dex                ; $989e: ca        
            bne __988e         ; $989f: d0 ed     
            lda #$00           ; $98a1: a9 00     
            sta $2005          ; $98a3: 8d 05 20  
            sta $2005          ; $98a6: 8d 05 20  
            clc                ; $98a9: 18        
            lda $89            ; $98aa: a5 89     
            adc #$20           ; $98ac: 69 20     
            sta $89            ; $98ae: 85 89     
            lda $88            ; $98b0: a5 88     
            adc #$00           ; $98b2: 69 00     
            sta $88            ; $98b4: 85 88     
            dec $012e          ; $98b6: ce 2e 01  
            bne __9882         ; $98b9: d0 c7     
            lda CurrentLevel   ; $98bb: a5 1a     
            cmp #$24           ; $98bd: c9 24     
            bcc __9909         ; $98bf: 90 48     
            lda #$20           ; $98c1: a9 20     
            sta $86            ; $98c3: 85 86     
            lda #$a9           ; $98c5: a9 a9     
            sta $87            ; $98c7: 85 87     
            lda #$48           ; $98c9: a9 48     
            sta $0131          ; $98cb: 8d 31 01  
            ldy #$0c           ; $98ce: a0 0c     
__98d0:     ldx #$08           ; $98d0: a2 08     
            lda $86            ; $98d2: a5 86     
            sta $2006          ; $98d4: 8d 06 20  
            lda $87            ; $98d7: a5 87     
            sta $2006          ; $98d9: 8d 06 20  
__98dc:     lda $0131          ; $98dc: ad 31 01  
            sta $2007          ; $98df: 8d 07 20  
            inc $0131          ; $98e2: ee 31 01  
            dex                ; $98e5: ca        
            bne __98dc         ; $98e6: d0 f4     
            lda #$00           ; $98e8: a9 00     
            sta $2005          ; $98ea: 8d 05 20  
            sta $2005          ; $98ed: 8d 05 20  
            clc                ; $98f0: 18        
            lda $0131          ; $98f1: ad 31 01  
            adc #$08           ; $98f4: 69 08     
            sta $0131          ; $98f6: 8d 31 01  
            clc                ; $98f9: 18        
            lda $87            ; $98fa: a5 87     
            adc #$20           ; $98fc: 69 20     
            sta $87            ; $98fe: 85 87     
__9900:     lda $86            ; $9900: a5 86     
            adc #$00           ; $9902: 69 00     
            sta $86            ; $9904: 85 86     
            dey                ; $9906: 88        
            bne __98d0         ; $9907: d0 c7     
__9909:     rts                ; $9909: 60        

;-------------------------------------------------------------------------------
InitPaddleAndBall:
            lda #$01           ; $990a: a9 01     .
            sta ActiveBalls    ; $990c: 85 81     | Set active ball count = 1
            sta PaddleTransf   ; $990e: 8d 2a 01  . Set paddle transformation = 1 (normal paddle)
            lda #$18           ; $9911: a9 18     .
            sta BlocksPerColumn; $9913: 8d 0a 01  | set 0x18 blocks-per-column
            lda #$0b           ; $9916: a9 0b     .
            sta BlocksPerRow   ; $9918: 8d 0b 01  | Set 0xb blocks-per-row
            lda #$cc           ; $991b: a9 cc     .
            sta Ball_1_Y       ; $991d: 85 37     | Set ball y = 0xcc (top of paddle starting position)
            lda #$15           ; $991f: a9 15     
            sta $0126          ; $9921: 8d 26 01  
            lda #$18           ; $9924: a9 18     
            sta $0127          ; $9926: 8d 27 01  
            ldx CurrentLevel   ; $9929: a6 1a           .
            lda __StartingSpeedStage,x ; $992b: bd 9f 99|
            sta SpeedStage     ; $992e: 8d 00 01        |
            sta SpeedStageM    ; $9931: 8d 01 01        |
            sta BallSpeedStage ; $9934: 85 49           |
            sta BallSpeedStageM; $9936: 85 4a           | Set up initial speed stage based on current level number
            tax                ; $9938: aa                .
            lda __SpeedStageThresholds,x ; $9939: bd 8f 99| 
            sta SpeedStageCounter ; $993c: 8d 02 01       | Set up initial speed stage counter from initial stage val
            lda #$01           ; $993f: a9 01     
            sta $0120          ; $9941: 8d 20 01  
            lda #$09           ; $9944: a9 09     
            sta $0121          ; $9946: 8d 21 01  
            lda #$d0           ; $9949: a9 d0     .
            sta PaddleTop_A    ; $994b: 8d 14 01  |
            sta PaddleTop_B    ; $994e: 8d 15 01  |
            sta PaddleTop_C    ; $9951: 8d 16 01  |
            sta PaddleTop_D    ; $9954: 8d 17 01  |
            sta PaddleTop_E    ; $9957: 8d 18 01  |
            sta PaddleTop_F    ; $995a: 8d 19 01  | Initialize paddle top edge to 0xd0
            lda #$58           ; $995d: a9 58     .
            sta PaddleLeftEdge ; $995f: 8d 1a 01  | Initialize paddle left edge to 0x58
            lda $08            ; $9962: a5 08     .
            cmp #$00           ; $9964: c9 00     |
            beq Next_9971      ; $9966: f0 09     |
            cmp #$a0           ; $9968: c9 a0     |
            bcc Next_996e      ; $996a: 90 02     | if $08 > 0 and $08 < 0xa0,
            lda #$a0           ; $996c: a9 a0       .
Next_996e:  sta PaddleLeftEdge ; $996e: 8d 1a 01    | set paddle left edge = 0xa0
Next_9971:  clc                ; $9971: 18         .
            lda PaddleLeftEdge ; $9972: ad 1a 01   |
            adc #$08           ; $9975: 69 08      |
            sta PaddleLeftCenter ; $9977: 8d 1b 01 |
            sta PaddleLeftCenterM ; $997a: 8d 1c 01| set paddle left-center to left edge + 8 
            clc                ; $997d: 18          .
            adc #$08           ; $997e: 69 08       |
            sta PaddleRightCenter ; $9980: 8d 1d 01 | 
            sta PaddleRightCenterM ; $9983: 8d 1e 01| set paddle right-center to left-center + 8
            sta Ball_1_X       ; $9986: 85 38       . Initialize ball pos to right-center paddle
            clc                ; $9988: 18          .
            adc #$08           ; $9989: 69 08       |
            sta PaddleRightEdge ; $998b: 8d 1f 01   | set paddle right edge to right-center + 8
            rts                ; $998e: 60          . return

;-------------------------------------------------------------------------------
__SpeedStageThresholds:
            .hex 00 0a 0f 14 1e 28 37 50 6e 87 a0 b9 d2 e6 f5 ff

__StartingSpeedStage:
            .hex 07 07 07 07 07 07 07 08
            .hex 07 08 06 07 06 08 07 08
            .hex 06 07 07 07 07 07 08 07
            .hex 07 07 08 06 08 07 07 07
            .hex 07 07 07 07 07

__CeilBounceSpdStage:
            .hex 00 08 08 08 00 08 08 00
            .hex 00 08 07 08 08 09 07 00
            .hex 07 08 08 08 00 08 00 00
            .hex 00 00 00 09 00 00 08 00
            .hex 00 08 08 08 08

__EnemySpawnTimerTable:
            .hex 00 00  00 00  00 00
            .hex 07 08  0e 10  15 18
            .hex 00 00  07 08  0e 10
            .hex 00 00  00 00  00 00
            .hex 00 00  07 08  0e 10
            .hex 00 00  07 08  0e 10
            .hex 00 00  00 00  07 08
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  07 08
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 07 08  0e 10  15 18
            .hex 00 00  00 00  00 00
            .hex 07 08  0e 10  15 18
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 00 00  07 08  0e 10
            .hex 00 00  07 08  0e 10
            .hex 00 00  00 00  07 08
            .hex 00 00  00 00  00 00
            .hex 07 08  0e 10  15 18
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 07 08  0e 10  15 18
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 00 00  00 00  00 00
            .hex 07 08  0e 10  15 18
            .hex 00 00  00 00  00 00
            .hex 07 08  0e 10  15 18
            .hex 00 00  07 08  0e 10
            .hex 07 08  0e 10  15 18
            .hex 07 08  0e 10  15 18
            .hex 07 08  0e 10  15 18
            .hex ff ff  ff ff  ff ff

__9ad9:     ldy #$00           ; $9ad9: a0 00     
__9adb:     lda ($86),y        ; $9adb: b1 86     
            sta $0200,y        ; $9add: 99 00 02  
            iny                ; $9ae0: c8        
            dex                ; $9ae1: ca        
            bne __9adb         ; $9ae2: d0 f7     
            rts                ; $9ae4: 60        

;-------------------------------------------------------------------------------
__9ae5:     ldy #$00           ; $9ae5: a0 00     
            lda #$b0           ; $9ae7: a9 b0     
            sta $86            ; $9ae9: 85 86     
            lda #$04           ; $9aeb: a9 04     
            sta $87            ; $9aed: 85 87     
            lda $19            ; $9aef: a5 19     
            cmp #$00           ; $9af1: c9 00     
            beq __9afd         ; $9af3: f0 08     
            lda #$20           ; $9af5: a9 20     
            sta $86            ; $9af7: 85 86     
            lda #$06           ; $9af9: a9 06     
            sta $87            ; $9afb: 85 87     
__9afd:     lda ($86),y        ; $9afd: b1 86     
            sta $0146,y        ; $9aff: 99 46 01  
            iny                ; $9b02: c8        
            cpy #$10           ; $9b03: c0 10     
            bne __9afd         ; $9b05: d0 f6     
            rts                ; $9b07: 60        

;-------------------------------------------------------------------------------
__9b08:     ldx #$00           ; $9b08: a2 00     
            ldy #$00           ; $9b0a: a0 00     
            sec                ; $9b0c: 38        
            lda CurrentLevel   ; $9b0d: a5 1a     
            sbc #$01           ; $9b0f: e9 01     
            and #$03           ; $9b11: 29 03     
            asl                ; $9b13: 0a        
            asl                ; $9b14: 0a        
            asl                ; $9b15: 0a        
            asl                ; $9b16: 0a        
            tax                ; $9b17: aa        
__9b18:     lda __9b25,x       ; $9b18: bd 25 9b  
            sta $0156,y        ; $9b1b: 99 56 01  
            inx                ; $9b1e: e8        
            iny                ; $9b1f: c8        
            cpy #$10           ; $9b20: c0 10     
            bne __9b18         ; $9b22: d0 f4     
            rts                ; $9b24: 60        

;-------------------------------------------------------------------------------
__9b25:     .hex 0f 20 16      ; $9b25: 0f 20 16  Invalid Opcode - SLO $1620
            brk                ; $9b28: 00        
            .hex 0f 30 2c      ; $9b29: 0f 30 2c  Invalid Opcode - SLO $2c30
            .hex 1c 0f 27      ; $9b2c: 1c 0f 27  Invalid Opcode - NOP $270f,x
            asl $30,x          ; $9b2f: 16 30     
            .hex 0f 00 00      ; $9b31: 0f 00 00  Bad Addr Mode - SLO $0000
            bmi __9b45         ; $9b34: 30 0f     
            jsr $0016          ; $9b36: 20 16 00  
            .hex 0f 28 29      ; $9b39: 0f 28 29  Invalid Opcode - SLO $2928
            asl $0f,x          ; $9b3c: 16 0f     
            .hex 27 16         ; $9b3e: 27 16     Invalid Opcode - RLA $16
            bmi __9b51         ; $9b40: 30 0f     
            brk                ; $9b42: 00        
            brk                ; $9b43: 00        
            .hex 30            ; $9b44: 30        Suspected data
__9b45:     .hex 0f 20 16      ; $9b45: 0f 20 16  Invalid Opcode - SLO $1620
            brk                ; $9b48: 00        
            .hex 0f 30 31      ; $9b49: 0f 30 31  Invalid Opcode - SLO $3130
            and ($0f,x)        ; $9b4c: 21 0f     
            .hex 27 16         ; $9b4e: 27 16     Invalid Opcode - RLA $16
            .hex 30            ; $9b50: 30        Suspected data
__9b51:     .hex 0f 00 00      ; $9b51: 0f 00 00  Bad Addr Mode - SLO $0000
            .hex 30 0f         ; $9b54: 30 0f     
            jsr $0016          ; $9b56: 20 16 00  
            .hex 0f 26 16      ; $9b59: 0f 26 16  Invalid Opcode - SLO $1626
            asl $0f            ; $9b5c: 06 0f     
            .hex 27 16         ; $9b5e: 27 16     Invalid Opcode - RLA $16
            bmi __9b71         ; $9b60: 30 0f     
            brk                ; $9b62: 00        
            brk                ; $9b63: 00        
            .hex 30            ; $9b64: 30        Suspected data
__9b65:     lda $0144          ; $9b65: ad 44 01  
            cmp #$00           ; $9b68: c9 00     
            bne __9ba4         ; $9b6a: d0 38     
            inc $0144          ; $9b6c: ee 44 01  
            lda #$00           ; $9b6f: a9 00     
__9b71:     sta $0132          ; $9b71: 8d 32 01  
            sta $0133          ; $9b74: 8d 33 01  
            lda #$7f           ; $9b77: a9 7f     
            sta $0200          ; $9b79: 8d 00 02  
            lda CurrentLevelM  ; $9b7c: a5 21     
            cmp #$00           ; $9b7e: c9 00     
            beq __9b86         ; $9b80: f0 04     
            cmp #$25           ; $9b82: c9 25     
            bcc __9b90         ; $9b84: 90 0a     
__9b86:     lda #$01           ; $9b86: a9 01     
            sta CurrentLevelM  ; $9b88: 85 21     
            sta $23            ; $9b8a: 85 23     
            lda #$00           ; $9b8c: a9 00     
            sta $22            ; $9b8e: 85 22     
__9b90:     lda $24            ; $9b90: a5 24     
            cmp #$00           ; $9b92: c9 00     
            beq __9b9a         ; $9b94: f0 04     
            cmp #$25           ; $9b96: c9 25     
            bcc __9ba4         ; $9b98: 90 0a     
__9b9a:     lda #$01           ; $9b9a: a9 01     
            sta $24            ; $9b9c: 85 24     
            sta $26            ; $9b9e: 85 26     
            lda #$00           ; $9ba0: a9 00     
            sta $25            ; $9ba2: 85 25     
__9ba4:     lda Buttons        ; $9ba4: a5 00     .
            eor PrevButtons    ; $9ba6: 45 01     |
            and Buttons        ; $9ba8: 25 00     |
            sta $0131          ; $9baa: 8d 31 01  | store buttons in $0131
            cmp #$10           ; $9bad: c9 10     .
            beq Next_9bbc      ; $9baf: f0 0b     | if P1 start button was just pressed, go start the game
            lda ButtonsP2M     ; $9bb1: a5 06     .
            eor PrevButtonsP2M ; $9bb3: 45 07     |
            and ButtonsP2M     ; $9bb5: 25 06     | if P2 start button was just pressed, go start the game
            bne Next_9bbc      ; $9bb7: d0 03     
            jmp __9c4e         ; $9bb9: 4c 4e 9c  

;-------------------------------------------------------------------------------
Next_9bbc:  lda $0133          ; $9bbc: ad 33 01  
            sta $18            ; $9bbf: 85 18     
            lda #$00           ; $9bc1: a9 00     
            sta $19            ; $9bc3: 85 19     
            ldx #$00           ; $9bc5: a2 00     
            lda #$00           ; $9bc7: a9 00     
Loop_9bc9:  sta $0370,x        ; $9bc9: 9d 70 03  .
            inx                ; $9bcc: e8        |
            cpx #$24           ; $9bcd: e0 24     |
            bne Loop_9bc9      ; $9bcf: d0 f8     | set $0370 - $0393 = 0
            lda #$0c           ; $9bd1: a9 0c     .
            jsr PlaySoundEffect; $9bd3: 20 c6 f3  | play sound effect 0xc
            lda #$04           ; $9bd6: a9 04     .
            sta GameState      ; $9bd8: 85 0a     | set game state = 4 (level init, just leaving title screen)
            lda #$01           ; $9bda: a9 01     
            sta GameStartTimerHi ; $9bdc: 8d 3f 01  
            lda #$03           ; $9bdf: a9 03     
            sta $0140          ; $9be1: 8d 40 01  
            lda #$f0           ; $9be4: a9 f0     
            sta $0200          ; $9be6: 8d 00 02  
            lda #$00           ; $9be9: a9 00     
            sta $036c          ; $9beb: 8d 6c 03  
            sta $036e          ; $9bee: 8d 6e 03  
            lda #$02           ; $9bf1: a9 02     
            sta $036d          ; $9bf3: 8d 6d 03  
            sta $036f          ; $9bf6: 8d 6f 03  
            lda #$00           ; $9bf9: a9 00     
            sta $0144          ; $9bfb: 8d 44 01  
            sta IsDemo         ; $9bfe: 85 10     . Reset demo flag
            sta TitleTimerHi   ; $9c00: 85 12     .
            sta TitleTimerLo   ; $9c02: 85 13     | Reset title timers
            lda $18            ; $9c04: a5 18     
            cmp #$00           ; $9c06: c9 00     
            bne __9c29         ; $9c08: d0 1f     
            lda #$00           ; $9c0a: a9 00     .
            sta TotalBlocks    ; $9c0c: 85 1f     | Total blocks = 0
            sta $20            ; $9c0e: 85 20     
            sta $1e            ; $9c10: 85 1e     
            lda #$03           ; $9c12: a9 03     
            sta $1d            ; $9c14: 85 1d     
            lda $0132          ; $9c16: ad 32 01  
            cmp #$05           ; $9c19: c9 05     
            bcc __9c1e         ; $9c1b: 90 01     
            rts                ; $9c1d: 60        

;-------------------------------------------------------------------------------
__9c1e:     lda #$01           ; $9c1e: a9 01     
            sta CurrentLevelM  ; $9c20: 85 21     
            sta $23            ; $9c22: 85 23     
            lda #$00           ; $9c24: a9 00     
            sta $22            ; $9c26: 85 22     
            rts                ; $9c28: 60        

;-------------------------------------------------------------------------------
__9c29:     lda #$03           ; $9c29: a9 03     
            sta $1d            ; $9c2b: 85 1d     
            sta $1e            ; $9c2d: 85 1e     
            lda #$00           ; $9c2f: a9 00     .
            sta TotalBlocks    ; $9c31: 85 1f     | Total blocks = 0
            sta $20            ; $9c33: 85 20     
            lda $0132          ; $9c35: ad 32 01  
            cmp #$05           ; $9c38: c9 05     
            bcc __9c3d         ; $9c3a: 90 01     
            rts                ; $9c3c: 60        

;-------------------------------------------------------------------------------
__9c3d:     lda #$01           ; $9c3d: a9 01     
            sta CurrentLevelM  ; $9c3f: 85 21     
            sta $24            ; $9c41: 85 24     
            sta $23            ; $9c43: 85 23     
            sta $26            ; $9c45: 85 26     
            lda #$00           ; $9c47: a9 00     
            sta $22            ; $9c49: 85 22     
            sta $25            ; $9c4b: 85 25     
            rts                ; $9c4d: 60        

;-------------------------------------------------------------------------------
__9c4e:     lda Buttons        ; $9c4e: a5 00     
            cmp #$20           ; $9c50: c9 20     
            bne __9c78         ; $9c52: d0 24     
            lda $0131          ; $9c54: ad 31 01  
            cmp #$20           ; $9c57: c9 20     
            bne __9c78         ; $9c59: d0 1d     
            lda $0200          ; $9c5b: ad 00 02  
            cmp #$7f           ; $9c5e: c9 7f     
            beq __9c6d         ; $9c60: f0 0b     
            lda #$00           ; $9c62: a9 00     
            sta $0133          ; $9c64: 8d 33 01  
            lda #$7f           ; $9c67: a9 7f     
            sta $0200          ; $9c69: 8d 00 02  
            rts                ; $9c6c: 60        

;-------------------------------------------------------------------------------
__9c6d:     lda #$01           ; $9c6d: a9 01     
            sta $0133          ; $9c6f: 8d 33 01  
            lda #$8f           ; $9c72: a9 8f     
            sta $0200          ; $9c74: 8d 00 02  
            rts                ; $9c77: 60        

;-------------------------------------------------------------------------------
__9c78:     lda Buttons        ; $9c78: a5 00     
            cmp #$e0           ; $9c7a: c9 e0     
            bne Ret_9c88       ; $9c7c: d0 0a     
            lda $0131          ; $9c7e: ad 31 01  
            cmp #$20           ; $9c81: c9 20     
            bne Ret_9c88       ; $9c83: d0 03     
            inc $0132          ; $9c85: ee 32 01  
Ret_9c88:   rts                ; $9c88: 60        

;-------------------------------------------------------------------------------
__9c89:     ldx #$00           ; $9c89: a2 00     .
Loop_9c8b:  lda __9ee8,x       ; $9c8b: bd e8 9e  |
            sta $0254,x        ; $9c8e: 9d 54 02  |
            inx                ; $9c91: e8        |
            cpx #$1c           ; $9c92: e0 1c     |
            bne Loop_9c8b      ; $9c94: d0 f5     | copy 0x1c values from __9ee8 into $0254-$026f
            ldy #$00           ; $9c96: a0 00     .
Loop_9c98:  lda __9f04,y       ; $9c98: b9 04 9f  |
            sta $0254,x        ; $9c9b: 9d 54 02  |
            inx                ; $9c9e: e8        |
            iny                ; $9c9f: c8        |
            cpy #$14           ; $9ca0: c0 14     |
            bne Loop_9c98      ; $9ca2: d0 f4     | copy 0x14 values from __9f04 into $0270-$0283
            lda $19            ; $9ca4: a5 19     .
            cmp #$00           ; $9ca6: c9 00     |
            beq Ret_9caf       ; $9ca8: f0 05     |
            lda #$ce           ; $9caa: a9 ce     |
            sta $026d          ; $9cac: 8d 6d 02  |
Ret_9caf:   rts                ; $9caf: 60        | if $19 isn't 0, set a different tile ID for the sprite at $026c

;-------------------------------------------------------------------------------
__9cb0:     ldx #$00           ; $9cb0: a2 00     
__9cb2:     lda __9ee8,x       ; $9cb2: bd e8 9e  
            sta $0254,x        ; $9cb5: 9d 54 02  
            inx                ; $9cb8: e8        
            cpx #$1c           ; $9cb9: e0 1c     
            bne __9cb2         ; $9cbb: d0 f5     
            ldy #$00           ; $9cbd: a0 00     
__9cbf:     lda __9f18,y       ; $9cbf: b9 18 9f  
            sta $0254,x        ; $9cc2: 9d 54 02  
            inx                ; $9cc5: e8        
            iny                ; $9cc6: c8        
            cpy #$20           ; $9cc7: c0 20     
            bne __9cbf         ; $9cc9: d0 f4     
            lda $19            ; $9ccb: a5 19     
            beq __9cd4         ; $9ccd: f0 05     
            lda #$ce           ; $9ccf: a9 ce     
            sta $026d          ; $9cd1: 8d 6d 02  
__9cd4:     lda $18            ; $9cd4: a5 18     
            bne __9ce8         ; $9cd6: d0 10     
            ldy #$07           ; $9cd8: a0 07     
            ldx #$00           ; $9cda: a2 00     
            lda #$f0           ; $9cdc: a9 f0     
__9cde:     sta $0254,x        ; $9cde: 9d 54 02  
            inx                ; $9ce1: e8        
            inx                ; $9ce2: e8        
            inx                ; $9ce3: e8        
            inx                ; $9ce4: e8        
            dey                ; $9ce5: 88        
            bne __9cde         ; $9ce6: d0 f6     
__9ce8:     rts                ; $9ce8: 60        

;-------------------------------------------------------------------------------
__9ce9:     lda $0b            ; $9ce9: a5 0b     
            cmp #$00           ; $9ceb: c9 00     
            bne __9d0d         ; $9ced: d0 1e     
            ldy #$01           ; $9cef: a0 01     
            lda __9fcb,y       ; $9cf1: b9 cb 9f  
            sta __9fcb,y       ; $9cf4: 99 cb 9f  
            lda #$06           ; $9cf7: a9 06     
            sta $2001          ; $9cf9: 8d 01 20  
            ldy #$20           ; $9cfc: a0 20     
            ldx #$00           ; $9cfe: a2 00     
            jsr __a3ee         ; $9d00: 20 ee a3  
            ldy #$28           ; $9d03: a0 28     
            ldx #$00           ; $9d05: a2 00     
            jsr __a3ee         ; $9d07: 20 ee a3  
            inc $0b            ; $9d0a: e6 0b     
            rts                ; $9d0c: 60        

;-------------------------------------------------------------------------------
__9d0d:     lda $0b            ; $9d0d: a5 0b     
            cmp #$01           ; $9d0f: c9 01     
            bne __9d26         ; $9d11: d0 13     
            ldx #$00           ; $9d13: a2 00     
__9d15:     lda __9de4,x       ; $9d15: bd e4 9d  
            sta $0146,x        ; $9d18: 9d 46 01  
            inx                ; $9d1b: e8        
            cpx #$10           ; $9d1c: e0 10     
            bne __9d15         ; $9d1e: d0 f5     
            jsr __a412         ; $9d20: 20 12 a4  
            inc $0b            ; $9d23: e6 0b     
            rts                ; $9d25: 60        

;-------------------------------------------------------------------------------
__9d26:     lda $0b            ; $9d26: a5 0b     
            cmp #$02           ; $9d28: c9 02     
            bne __9d34         ; $9d2a: d0 08     
            ldy #$20           ; $9d2c: a0 20     
            jsr __a2a8         ; $9d2e: 20 a8 a2  
            inc $0b            ; $9d31: e6 0b     
            rts                ; $9d33: 60        

;-------------------------------------------------------------------------------
__9d34:     lda $0b            ; $9d34: a5 0b     
            cmp #$03           ; $9d36: c9 03     
            bne __9d78         ; $9d38: d0 3e     
            lda #$f4           ; $9d3a: a9 f4     
            sta $86            ; $9d3c: 85 86     
            lda #$9d           ; $9d3e: a9 9d     
            sta $87            ; $9d40: 85 87     
            jsr __a3c3         ; $9d42: 20 c3 a3  
            jsr __9cb0         ; $9d45: 20 b0 9c  
            ldy #$0f           ; $9d48: a0 0f     
            ldx #$00           ; $9d4a: a2 00     
__9d4c:     lda $0254,x        ; $9d4c: bd 54 02  
            cmp #$f0           ; $9d4f: c9 f0     
            beq __9d59         ; $9d51: f0 06     
            sec                ; $9d53: 38        
            sbc #$76           ; $9d54: e9 76     
            sta $0254,x        ; $9d56: 9d 54 02  
__9d59:     clc                ; $9d59: 18        
            lda $0257,x        ; $9d5a: bd 57 02  
            adc #$18           ; $9d5d: 69 18     
            sta $0257,x        ; $9d5f: 9d 57 02  
            inx                ; $9d62: e8        
            inx                ; $9d63: e8        
            inx                ; $9d64: e8        
            inx                ; $9d65: e8        
            dey                ; $9d66: 88        
            bne __9d4c         ; $9d67: d0 e3     
            inc $0b            ; $9d69: e6 0b     
            lda #$1e           ; $9d6b: a9 1e     
            sta $2001          ; $9d6d: 8d 01 20  
            sta _PPU_Ctrl2_Mirror ; $9d70: 85 15     
            lda #$96           ; $9d72: a9 96     .
            sta LoadingTimer   ; $9d74: 8d 3b 01  | init loading timer to 0x96
            rts                ; $9d77: 60        

;-------------------------------------------------------------------------------
__9d78:     lda $0b            ; $9d78: a5 0b     
            cmp #$04           ; $9d7a: c9 04     
            bne __9d9b         ; $9d7c: d0 1d     
            lda #$c5           ; $9d7e: a9 c5     
            sta $86            ; $9d80: 85 86     
            lda #$9e           ; $9d82: a9 9e     
            sta $87            ; $9d84: 85 87     
            lda #$06           ; $9d86: a9 06     
            sta $2001          ; $9d88: 8d 01 20  
            jsr __a3c3         ; $9d8b: 20 c3 a3  
            lda _PPU_Ctrl2_Mirror ; $9d8e: a5 15     
            sta $2001          ; $9d90: 8d 01 20  
            inc $0b            ; $9d93: e6 0b     
            lda #$0a           ; $9d95: a9 0a     .
            sta LoadingTimer   ; $9d97: 8d 3b 01  | init loading timer to 0x0a
            rts                ; $9d9a: 60        

;-------------------------------------------------------------------------------
__9d9b:     lda $0b            ; $9d9b: a5 0b     
            cmp #$05           ; $9d9d: c9 05     
            bne __9dbe         ; $9d9f: d0 1d     
            lda #$cb           ; $9da1: a9 cb     
            sta $86            ; $9da3: 85 86     
            lda #$9e           ; $9da5: a9 9e     
            sta $87            ; $9da7: 85 87     
            lda #$06           ; $9da9: a9 06     
            sta $2001          ; $9dab: 8d 01 20  
            jsr __a3c3         ; $9dae: 20 c3 a3  
            lda _PPU_Ctrl2_Mirror ; $9db1: a5 15     
            sta $2001          ; $9db3: 8d 01 20  
            inc $0b            ; $9db6: e6 0b     
            lda #$0a           ; $9db8: a9 0a     .
            sta LoadingTimer   ; $9dba: 8d 3b 01  | init loading timer to 0x0a
            rts                ; $9dbd: 60        . return

;-------------------------------------------------------------------------------
__9dbe:     lda #$d1           ; $9dbe: a9 d1     
            sta $86            ; $9dc0: 85 86     
            lda #$9e           ; $9dc2: a9 9e     
            sta $87            ; $9dc4: 85 87     
            lda #$06           ; $9dc6: a9 06     
            sta $2001          ; $9dc8: 8d 01 20  
            jsr __a3c3         ; $9dcb: 20 c3 a3  
            lda _PPU_Ctrl2_Mirror ; $9dce: a5 15     
            sta $2001          ; $9dd0: 8d 01 20  
            lda #$03           ; $9dd3: a9 03     .
            jsr PlaySoundEffect; $9dd5: 20 c6 f3  | play sound effect 0x3
            inc GameState      ; $9dd8: e6 0a     
            lda #$00           ; $9dda: a9 00     
            sta $0b            ; $9ddc: 85 0b     
            lda #$f0           ; $9dde: a9 f0     .
            sta LoadingTimer   ; $9de0: 8d 3b 01  | init loading timer to 0xf0
            rts                ; $9de3: 60        . return

;-------------------------------------------------------------------------------
__9de4:     .hex 0f 30 16 06 0f 30 16 06 0f 30 16 06 0f 30 16 06
            .hex 22 0e 04 2d 3b 3c 2d 22 2e 04 3d 3e 3f 70 22 4e
            .hex 04 71 72 73 74 22 6e 04 75 76 77 b2 22 8e 04 b3
            .hex 2d b4 b5

            .hex 22            ; $9e17: 22        Invalid Opcode - KIL 
            ldx __b604         ; $9e18: ae 04 b6  
            .hex 2d b7 c4      ; $9e1b: 2d b7 c4  
            .hex 22            ; $9e1e: 22        Invalid Opcode - KIL 
            dec __c504         ; $9e1f: ce 04 c5  
            dec $c7            ; $9e22: c6 c7     
            .hex d4            ; $9e24: d4        Suspected data
__9e25:     .hex 22            ; $9e25: 22        Invalid Opcode - KIL 
            .hex ee 04 d5      ; $9e26: ee 04 d5  
            .hex 2d d6 d7      ; $9e29: 2d d6 d7  
            .hex 23 0e         ; $9e2c: 23 0e     Invalid Opcode - RLA ($0e,x)
            .hex 04 e4         ; $9e2e: 04 e4     Invalid Opcode - NOP $e4
            sbc $e6            ; $9e30: e5 e6     
            .hex e7 21         ; $9e32: e7 21     Invalid Opcode - ISC $21
            sta ($05,x)        ; $9e34: 81 05     
            plp                ; $9e36: 28        
            and #$29           ; $9e37: 29 29     
            rol                ; $9e39: 2a        
            bmi __9e5d         ; $9e3a: 30 21     
            lda ($05,x)        ; $9e3c: a1 05     
            and ($32),y        ; $9e3e: 31 32     
            .hex 33 33         ; $9e40: 33 33     Invalid Opcode - RLA ($33),y
            .hex 34 21         ; $9e42: 34 21     Invalid Opcode - NOP $21,x
            tsx                ; $9e44: ba        
            ora $a3            ; $9e45: 05 a3     
            .hex 93 29         ; $9e47: 93 29     Invalid Opcode - AHX ($29),y
            and #$83           ; $9e49: 29 83     
            and ($da,x)        ; $9e4b: 21 da     
            ora $a7            ; $9e4d: 05 a7     
            .hex 33 33         ; $9e4f: 33 33     Invalid Opcode - RLA ($33),y
            .hex 97 87         ; $9e51: 97 87     Invalid Opcode - SAX $87,y
            and ($a9,x)        ; $9e53: 21 a9     
            .hex 04 2c         ; $9e55: 04 2c     Invalid Opcode - NOP $2c
            and #$29           ; $9e57: 29 29     
            .hex 0b 21         ; $9e59: 0b 21     Invalid Opcode - ANC #$21
            cmp #$04           ; $9e5b: c9 04     
__9e5d:     .hex 27 33         ; $9e5d: 27 33     Invalid Opcode - RLA $33
            .hex 33 0f         ; $9e5f: 33 0f     Invalid Opcode - RLA ($0f),y
            and ($93,x)        ; $9e61: 21 93     
            .hex 04 13         ; $9e63: 04 13     Invalid Opcode - NOP $13
            and #$29           ; $9e65: 29 29     
            .hex 14 21         ; $9e67: 14 21     Invalid Opcode - NOP $21,x
            .hex b3 04         ; $9e69: b3 04     Invalid Opcode - LAX ($04),y
            ora $33,x          ; $9e6b: 15 33     
            .hex 33 16         ; $9e6d: 33 16     Invalid Opcode - RLA ($16),y
            .hex 22            ; $9e6f: 22        Invalid Opcode - KIL 
            and $03            ; $9e70: 25 03     
            and $36,x          ; $9e72: 35 36     
            .hex 37 22         ; $9e74: 37 22     Invalid Opcode - RLA $22,x
            adc #$03           ; $9e76: 69 03     
            and $36,x          ; $9e78: 35 36     
            .hex 37 22         ; $9e7a: 37 22     Invalid Opcode - RLA $22,x
            .hex 37 03         ; $9e7c: 37 03     Invalid Opcode - RLA $03,x
            .hex 22            ; $9e7e: 22        Invalid Opcode - KIL 
            .hex 23 24         ; $9e7f: 23 24     Invalid Opcode - RLA ($24,x)
            .hex 22            ; $9e81: 22        Invalid Opcode - KIL 
            .hex 74 03         ; $9e82: 74 03     Invalid Opcode - NOP $03,x
            .hex 22            ; $9e84: 22        Invalid Opcode - KIL 
            .hex 23 24         ; $9e85: 23 24     Invalid Opcode - RLA ($24,x)
            .hex 22            ; $9e87: 22        Invalid Opcode - KIL 
            .hex 0c 02 38      ; $9e88: 0c 02 38  Invalid Opcode - NOP $3802
            and $3222,y        ; $9e8b: 39 22 32  
            .hex 02            ; $9e8e: 02        Invalid Opcode - KIL 
            and $26            ; $9e8f: 25 26     
            .hex 22            ; $9e91: 22        Invalid Opcode - KIL 
            txa                ; $9e92: 8a        
            ora ($f4,x)        ; $9e93: 01 f4     
            .hex 22            ; $9e95: 22        Invalid Opcode - KIL 
            sta $01,x          ; $9e96: 95 01     
            sbc $22,x          ; $9e98: f5 22     
            ldy __f601         ; $9e9a: ac 01 f6  
            .hex 22            ; $9e9d: 22        Invalid Opcode - KIL 
            .hex b2            ; $9e9e: b2        Invalid Opcode - KIL 
            ora ($f7,x)        ; $9e9f: 01 f7     
            .hex 23 40         ; $9ea1: 23 40     Invalid Opcode - RLA ($40,x)
            jsr $3a3a          ; $9ea3: 20 3a 3a  
            .hex 3a            ; $9ea6: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ea7: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ea8: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ea9: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eaa: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eab: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eac: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ead: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eae: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eaf: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb0: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb1: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb2: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb3: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb4: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb5: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb6: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb7: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb8: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eb9: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9eba: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ebb: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ebc: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ebd: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ebe: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ebf: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ec0: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ec1: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ec2: 3a        Invalid Opcode - NOP 
            .hex 3a            ; $9ec3: 3a        Invalid Opcode - NOP 
            .hex ff 22 4f      ; $9ec4: ff 22 4f  Invalid Opcode - ISC $4f22,x
            .hex 02            ; $9ec7: 02        Invalid Opcode - KIL 
            .hex 2b 1a         ; $9ec8: 2b 1a     Invalid Opcode - ANC #$1a
            .hex ff 22 4f      ; $9eca: ff 22 4f  Invalid Opcode - ISC $4f22,x
            .hex 02            ; $9ecd: 02        Invalid Opcode - KIL 
            ora __ff1f,x       ; $9ece: 1d 1f ff  
            .hex 22            ; $9ed1: 22        Invalid Opcode - KIL 
            .hex 4f 02 20      ; $9ed2: 4f 02 20  Invalid Opcode - SRE $2002
            and ($ff,x)        ; $9ed5: 21 ff     


__9ed7:     ldy #$0f           ; $9ed7: a0 0f     
            ldx #$00           ; $9ed9: a2 00     
            lda #$f0           ; $9edb: a9 f0     
__9edd:     sta $0254,x        ; $9edd: 9d 54 02  
            inx                ; $9ee0: e8        
            inx                ; $9ee1: e8        
            inx                ; $9ee2: e8        
            inx                ; $9ee3: e8        
            dey                ; $9ee4: 88        
            bne __9edd         ; $9ee5: d0 f6     
            rts                ; $9ee7: 60        

;-------------------------------------------------------------------------------

            ; some kind of sprite data
__9ee8:     tay                ; $9ee8: a8        
            .hex cb 00         ; $9ee9: cb 00     Invalid Opcode - AXS #$00
            lsr                ; $9eeb: 4a        
            tay                ; $9eec: a8        
            cpy $5200          ; $9eed: cc 00 52  
            tay                ; $9ef0: a8        
            cpy $00            ; $9ef1: c4 00     
            .hex 5a            ; $9ef3: 5a        Invalid Opcode - NOP 
            tay                ; $9ef4: a8        
            dec $00            ; $9ef5: c6 00     
            .hex 62            ; $9ef7: 62        Invalid Opcode - KIL 
            tay                ; $9ef8: a8        
            .hex c3 00         ; $9ef9: c3 00     Invalid Opcode - DCP ($00,x)
            ror                ; $9efb: 6a        
            tay                ; $9efc: a8        
            .hex c2 00         ; $9efd: c2 00     Invalid Opcode - NOP #$00
            .hex 72            ; $9eff: 72        Invalid Opcode - KIL 
            tay                ; $9f00: a8        
            .hex cd 00 82      ; $9f01: cd 00 82  
__9f04:     clv                ; $9f04: b8        
            .hex c2 00         ; $9f05: c2 00     Invalid Opcode - NOP #$00
            .hex 52            ; $9f07: 52        Invalid Opcode - KIL 
            clv                ; $9f08: b8        
            .hex c3 00         ; $9f09: c3 00     Invalid Opcode - DCP ($00,x)
            .hex 5a            ; $9f0b: 5a        Invalid Opcode - NOP 
            clv                ; $9f0c: b8        
            cpy $00            ; $9f0d: c4 00     
            .hex 62            ; $9f0f: 62        Invalid Opcode - KIL 
            clv                ; $9f10: b8        
            cmp $00            ; $9f11: c5 00     
            ror                ; $9f13: 6a        
            clv                ; $9f14: b8        
            dec $00            ; $9f15: c6 00     
            .hex 72            ; $9f17: 72        Invalid Opcode - KIL 
__9f18:     clv                ; $9f18: b8        
            .hex c7 00         ; $9f19: c7 00     Invalid Opcode - DCP $00
            lsr $b8            ; $9f1b: 46 b8     
            cpy $00            ; $9f1d: c4 00     
            .hex 4e b8 c8      ; $9f1f: 4e b8 c8  
            brk                ; $9f22: 00        
            lsr $b8,x          ; $9f23: 56 b8     
            .hex c3 00         ; $9f25: c3 00     Invalid Opcode - DCP ($00,x)
            .hex 5e b8 c9      ; $9f27: 5e b8 c9  
            brk                ; $9f2a: 00        
            .hex 6e b8 ca      ; $9f2b: 6e b8 ca  
            brk                ; $9f2e: 00        
            ror $b8,x          ; $9f2f: 76 b8     
            .hex c3 00         ; $9f31: c3 00     Invalid Opcode - DCP ($00,x)
            .hex 7e b8 c2      ; $9f33: 7e b8 c2  
            brk                ; $9f36: 00        
            .hex 86            ; $9f37: 86        Suspected data

UpdateGameStartTimers:
            lda GameStartTimerLo ; $9f38: ad 40 01  .
            beq Next_9f41        ; $9f3b: f0 04     | if game start timer low == 0, go update high timer
            dec GameStartTimerLo ; $9f3d: ce 40 01  
            rts                ; $9f40: 60          . return

;-------------------------------------------------------------------------------
Next_9f41:  lda GameStartTimerHi ; $9f41: ad 3f 01  .
            beq Ret_9f87       ; $9f44: f0 41       | if game start timer high == 0 (timer not started yet?), return
            cmp #$0b           ; $9f46: c9 0b     .
            bne Next_9f54      ; $9f48: d0 0a     | if game start timer high == 0x0b, 
            lda #$00           ; $9f4a: a9 00     
            sta GameStartTimerHi ; $9f4c: 8d 3f 01  
            lda #$05           ; $9f4f: a9 05     
            sta GameState      ; $9f51: 85 0a     
            rts                ; $9f53: 60        

;-------------------------------------------------------------------------------
Next_9f54:  lda #$88           ; $9f54: a9 88     
            sta $86            ; $9f56: 85 86     
            lda #$9f           ; $9f58: a9 9f
            sta $87            ; $9f5a: 85 87
            lda $18            ; $9f5c: a5 18     
            beq Next_9f68      ; $9f5e: f0 08     
            lda #$94           ; $9f60: a9 94     
            sta $86            ; $9f62: 85 86     
            lda #$9f           ; $9f64: a9 9f     
            sta $87            ; $9f66: 85 87     
Next_9f68:  lda GameStartTimerHi ; $9f68: ad 3f 01  
            and #$01           ; $9f6b: 29 01     
            beq __9f7c         ; $9f6d: f0 0d     
            clc                ; $9f6f: 18        
            lda $86            ; $9f70: a5 86     
            adc #$19           ; $9f72: 69 19     
            sta $86            ; $9f74: 85 86     
            lda $87            ; $9f76: a5 87     
            adc #$00           ; $9f78: 69 00     
            sta $87            ; $9f7a: 85 87     
__9f7c:     jsr __a3c3         ; $9f7c: 20 c3 a3    
            inc GameStartTimerHi ; $9f7f: ee 3f 01  . Bump game start timer high
            lda #$1e           ; $9f82: a9 1e       .
            sta GameStartTimerLo ; $9f84: 8d 40 01  | Set game start timer low = 0x1e (reset lower timer)
Ret_9f87:   rts                ; $9f87: 60          . return

;-------------------------------------------------------------------------------
            .hex 22 0c 08
            ;     1     P  L  A  Y  E  R
            .hex 01 2d 19 15 0a 22 0e 1b
            .hex ff

            .hex 22 4c 09
            ;     2     P  L  A  Y  E  R  S
            .hex 02 2d 19 15 0a 22 0e 1b 1c
            .hex ff
            .hex 22 0c 08        
            .hex 2d 2d 2d 2d 2d 2d 2d 2d
            .hex ff  
            .hex 22 4c 09
            ;    [spaces]
            .hex 2d 2d 2d 2d 2d 2d 2d 2d 2d
            .hex ff

__9fba:     ldy #$00           ; $9fba: a0 00     .
            lda CurrentLevel   ; $9fbc: a5 1a     |
            cmp #$24           ; $9fbe: c9 24     |
            bne __9fc4         ; $9fc0: d0 02     | Check for boss level
            ldy #$01           ; $9fc2: a0 01     | y = (level == 0x24 ? 1 : 0)
__9fc4:     lda __9fcb,y       ; $9fc4: b9 cb 9f  
            sta __9fcb,y       ; $9fc7: 99 cb 9f  
            rts                ; $9fca: 60        

;-------------------------------------------------------------------------------
__9fcb:     .hex 00 01

__9fcd:     ldx #$33           ; $9fcd: a2 33     
            lda #$00           ; $9fcf: a9 00     
Loop_9fd1:  sta $00,x          ; $9fd1: 95 00     
            inx                ; $9fd3: e8        
            bne Loop_9fd1      ; $9fd4: d0 fb     
Loop_9fd6:  sta $0100,x        ; $9fd6: 9d 00 01  
            inx                ; $9fd9: e8        
            cpx #$a0           ; $9fda: e0 a0     
            bne Loop_9fd6      ; $9fdc: d0 f8     
            rts                ; $9fde: 60        

;-------------------------------------------------------------------------------
__9fdf:     lda $0b            ; $9fdf: a5 0b     
            bne __a025         ; $9fe1: d0 42     
            lda #$06           ; $9fe3: a9 06     
            sta $2001          ; $9fe5: 8d 01 20  
            ldx #$00           ; $9fe8: a2 00     
__9fea:     lda __a06a,x       ; $9fea: bd 6a a0  
            sta $0146,x        ; $9fed: 9d 46 01  
            inx                ; $9ff0: e8        
            cpx #$20           ; $9ff1: e0 20     
            bne __9fea         ; $9ff3: d0 f5     
            jsr __a412         ; $9ff5: 20 12 a4  
            jsr SetSpritePalette ; $9ff8: 20 3a a4  
            jsr __f3c3         ; $9ffb: 20 c3 f3  
            jsr __9fcd         ; $9ffe: 20 cd 9f  
            jsr __a19a         ; $a001: 20 9a a1  
            ldx #$00           ; $a004: a2 00     
__a006:     lda __a05e,x       ; $a006: bd 5e a0  
            sta $02cc,x        ; $a009: 9d cc 02  
            inx                ; $a00c: e8        
            cpx #$0c           ; $a00d: e0 0c     
            bne __a006         ; $a00f: d0 f5     
            ldy #$00           ; $a011: a0 00     
            lda __9fcb,y       ; $a013: b9 cb 9f  
            sta __9fcb,y       ; $a016: 99 cb 9f  
            lda #$08           ; $a019: a9 08     .
            sta LoadingTimer   ; $a01b: 8d 3b 01  | init loading timer to 0x08
            lda #$00           ; $a01e: a9 00     
            sta _VScrollOffset ; $a020: 85 16     
            inc $0b            ; $a022: e6 0b     
            rts                ; $a024: 60        

;-------------------------------------------------------------------------------
__a025:     ldy #$20           ; $a025: a0 20     
            ldx #$00           ; $a027: a2 00     
            jsr __a3ee         ; $a029: 20 ee a3  
            ldy #$28           ; $a02c: a0 28     
            ldx #$00           ; $a02e: a2 00     
            jsr __a3ee         ; $a030: 20 ee a3  
            lda #$8a           ; $a033: a9 8a     
            sta $86            ; $a035: 85 86     
            lda #$a0           ; $a037: a9 a0     
            sta $87            ; $a039: 85 87     
            lda #$23           ; $a03b: a9 23     
            jsr __a462         ; $a03d: 20 62 a4  
            ldy #$20           ; $a040: a0 20     
            jsr __a2a8         ; $a042: 20 a8 a2  
            lda #$9c           ; $a045: a9 9c     
            sta $86            ; $a047: 85 86     
            lda #$a4           ; $a049: a9 a4     
            sta $87            ; $a04b: 85 87     
            jsr __a3c3         ; $a04d: 20 c3 a3  
            inc GameState      ; $a050: e6 0a     
            lda #$00           ; $a052: a9 00     
            sta $0b            ; $a054: 85 0b     
            lda #$1e           ; $a056: a9 1e     
            sta $2001          ; $a058: 8d 01 20  
            sta _PPU_Ctrl2_Mirror ; $a05b: 85 15     
            rts                ; $a05d: 60        

;-------------------------------------------------------------------------------
__a05e:     .hex 47 ee 00 96 47 ef 00 9e 4f fe 00 96

__a06a:     .hex 0f 30 30 30 0f 30 16 30 0f 30 24 01 0f 30 16 30
            .hex 0f 30 24 00 0f 00 00 00 0f 00 00 00 0f 00 00 00
            .hex 50 50 50 50 50 50 50 50 00 00 00 00 00 00 00 00
            .hex aa aa aa aa aa aa aa aa 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 40 50 50 10 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

__a0ca:     lda #$06           ; $a0ca: a9 06     
            sta $2001          ; $a0cc: 8d 01 20  
            ldx #$00           ; $a0cf: a2 00     
Loop_a0d1   lda __a06a,x       ; $a0d1: bd 6a a0  
            sta $0146,x        ; $a0d4: 9d 46 01  
            inx                ; $a0d7: e8        
            cpx #$10           ; $a0d8: e0 10     
            bne Loop_a0d1      ; $a0da: d0 f5
            jsr __a412         ; $a0dc: 20 12 a4
            ldy #$20           ; $a0df: a0 20
            ldx #$00           ; $a0e1: a2 00     
            jsr __a3ee         ; $a0e3: 20 ee a3  
            ldy #$28           ; $a0e6: a0 28     
            ldx #$00           ; $a0e8: a2 00     
            jsr __a3ee         ; $a0ea: 20 ee a3  
            lda #$5a           ; $a0ed: a9 5a     
            sta $86            ; $a0ef: 85 86     
            lda #$a1           ; $a0f1: a9 a1     
            sta $87            ; $a0f3: 85 87     
            lda #$2b           ; $a0f5: a9 2b     
            jsr __a462         ; $a0f7: 20 62 a4  
            ldy #$28           ; $a0fa: a0 28     
            jsr __a2a8         ; $a0fc: 20 a8 a2  
            lda #$58           ; $a0ff: a9 58     .
            sta $86            ; $a101: 85 86     |
            lda #$a5           ; $a103: a9 a5     |
            sta $87            ; $a105: 85 87     | Load intro text address
__a107:     jsr __a3c3         ; $a107: 20 c3 a3  
            lda #$00           ; $a10a: a9 00     
            sta CurrentLevelM  ; $a10c: 85 21     
            sta $24            ; $a10e: 85 24     
            rts                ; $a110: 60        

;-------------------------------------------------------------------------------
__a111:     ldy #$00           ; $a111: a0 00     
            lda __9fcb,y       ; $a113: b9 cb 9f  
            sta __9fcb,y       ; $a116: 99 cb 9f  
            lda #$06           ; $a119: a9 06     
            sta $2001          ; $a11b: 8d 01 20  
            ldx #$00           ; $a11e: a2 00     
Loop_a120:  lda __a06a,x       ; $a120: bd 6a a0  
            sta $0146,x        ; $a123: 9d 46 01  
            inx                ; $a126: e8        
            cpx #$10           ; $a127: e0 10     
            bne Loop_a120      ; $a129: d0 f5     
            jsr __a412         ; $a12b: 20 12 a4  
            ldy #$20           ; $a12e: a0 20     
            ldx #$00           ; $a130: a2 00     
            jsr __a3ee         ; $a132: 20 ee a3  
            ldy #$28           ; $a135: a0 28     
            ldx #$00           ; $a137: a2 00     
            jsr __a3ee         ; $a139: 20 ee a3  
            lda #$5a           ; $a13c: a9 5a     
            sta $86            ; $a13e: 85 86     
            lda #$a1           ; $a140: a9 a1     
            sta $87            ; $a142: 85 87     
            lda #$2b           ; $a144: a9 2b     
            jsr __a462         ; $a146: 20 62 a4  
            ldy #$28           ; $a149: a0 28     
            .hex 20            ; $a14b: 20        Suspected data
__a14c:     tay                ; $a14c: a8        
            .hex a2            ; $a14d: a2        Suspected data
__a14e:     lda #$2a           ; $a14e: a9 2a     
__a150:     sta $86            ; $a150: 85 86     
__a152:     lda #$a6           ; $a152: a9 a6     
            sta $87            ; $a154: 85 87     
            jsr __a3c3         ; $a156: 20 c3 a3  
            rts                ; $a159: 60        

;-------------------------------------------------------------------------------
            beq __a14c         ; $a15a: f0 f0     
            beq __a14e         ; $a15c: f0 f0     
            beq __a150         ; $a15e: f0 f0     
            beq __a152         ; $a160: f0 f0     
            brk                ; $a162: 00        
            brk                ; $a163: 00        
            brk                ; $a164: 00        
            brk                ; $a165: 00        
            brk                ; $a166: 00        
            brk                ; $a167: 00        
            brk                ; $a168: 00        
            brk                ; $a169: 00        
            brk                ; $a16a: 00        
            brk                ; $a16b: 00        
            brk                ; $a16c: 00        
            brk                ; $a16d: 00        
            brk                ; $a16e: 00        
            brk                ; $a16f: 00        
            brk                ; $a170: 00        
            brk                ; $a171: 00        
            brk                ; $a172: 00        
            brk                ; $a173: 00        
            brk                ; $a174: 00        
            brk                ; $a175: 00        
            brk                ; $a176: 00        
            brk                ; $a177: 00        
            brk                ; $a178: 00        
__a179:     brk                ; $a179: 00        
            brk                ; $a17a: 00        
            brk                ; $a17b: 00        
            brk                ; $a17c: 00        
            brk                ; $a17d: 00        
            brk                ; $a17e: 00        
            brk                ; $a17f: 00        
            brk                ; $a180: 00        
            brk                ; $a181: 00        
            brk                ; $a182: 00        
            brk                ; $a183: 00        
            brk                ; $a184: 00        
            brk                ; $a185: 00        
            brk                ; $a186: 00        
            brk                ; $a187: 00        
            brk                ; $a188: 00        
            brk                ; $a189: 00        
            brk                ; $a18a: 00        
            brk                ; $a18b: 00        
            brk                ; $a18c: 00        
            brk                ; $a18d: 00        
            brk                ; $a18e: 00        
            brk                ; $a18f: 00        
            brk                ; $a190: 00        
            brk                ; $a191: 00        
            brk                ; $a192: 00        
            brk                ; $a193: 00        
            brk                ; $a194: 00        
            brk                ; $a195: 00        
            brk                ; $a196: 00        
            brk                ; $a197: 00        
            brk                ; $a198: 00        
            brk                ; $a199: 00        
__a19a:     lda #$a8           ; $a19a: a9 a8     
            .hex 85            ; $a19c: 85        Suspected data
__a19d:     stx $a9            ; $a19d: 86 a9     
            lda ($85,x)        ; $a19f: a1 85     
            .hex 87 a2         ; $a1a1: 87 a2     Invalid Opcode - SAX $a2
            brk                ; $a1a3: 00        
            jsr __9ad9         ; $a1a4: 20 d9 9a  
            rts                ; $a1a7: 60        

;-------------------------------------------------------------------------------
            beq __a179         ; $a1a8: f0 cf     
            brk                ; $a1aa: 00        
            bvc __a19d         ; $a1ab: 50 f0     
            ora ($00,x)        ; $a1ad: 01 00     
            brk                ; $a1af: 00        
            beq __a1bb         ; $a1b0: f0 09     
            brk                ; $a1b2: 00        
            brk                ; $a1b3: 00        
            beq __a1bf         ; $a1b4: f0 09     
            brk                ; $a1b6: 00        
            brk                ; $a1b7: 00        
            beq __a1c3         ; $a1b8: f0 09     
            rti                ; $a1ba: 40        

;-------------------------------------------------------------------------------
__a1bb:     brk                ; $a1bb: 00        
            beq __a1c7         ; $a1bc: f0 09     
            rti                ; $a1be: 40        

;-------------------------------------------------------------------------------
__a1bf:     brk                ; $a1bf: 00        
            beq __a1c3         ; $a1c0: f0 01     
            rti                ; $a1c2: 40        

;-------------------------------------------------------------------------------
__a1c3:     brk                ; $a1c3: 00        
            beq __a1c6         ; $a1c4: f0 00     
__a1c6:     brk                ; $a1c6: 00        
__a1c7:     brk                ; $a1c7: 00        
            beq __a1ca         ; $a1c8: f0 00     
__a1ca:     brk                ; $a1ca: 00        
            brk                ; $a1cb: 00        
            beq __a1ce         ; $a1cc: f0 00     
__a1ce:     brk                ; $a1ce: 00        
            brk                ; $a1cf: 00        
            beq __a1d2         ; $a1d0: f0 00     
__a1d2:     brk                ; $a1d2: 00        
            brk                ; $a1d3: 00        
            beq __a1f4         ; $a1d4: f0 1e     
            .hex 02            ; $a1d6: 02        Invalid Opcode - KIL 
            brk                ; $a1d7: 00        
            beq __a1f8         ; $a1d8: f0 1e     
            .hex 02            ; $a1da: 02        Invalid Opcode - KIL 
            brk                ; $a1db: 00        
            beq __a1fc         ; $a1dc: f0 1e     
            .hex 02            ; $a1de: 02        Invalid Opcode - KIL 
            brk                ; $a1df: 00        
            beq __a1ff         ; $a1e0: f0 1d     
            .hex 02            ; $a1e2: 02        Invalid Opcode - KIL 
            brk                ; $a1e3: 00        
            beq __a203         ; $a1e4: f0 1d     
            .hex 42            ; $a1e6: 42        Invalid Opcode - KIL 
            brk                ; $a1e7: 00        
            beq __a207         ; $a1e8: f0 1d     
            .hex 02            ; $a1ea: 02        Invalid Opcode - KIL 
            brk                ; $a1eb: 00        
            beq __a20b         ; $a1ec: f0 1d     
            .hex 42            ; $a1ee: 42        Invalid Opcode - KIL 
            brk                ; $a1ef: 00        
            beq __a1f2         ; $a1f0: f0 00     
__a1f2:     brk                ; $a1f2: 00        
            brk                ; $a1f3: 00        
__a1f4:     beq __a1f6         ; $a1f4: f0 00     
__a1f6:     brk                ; $a1f6: 00        
            brk                ; $a1f7: 00        
__a1f8:     beq __a218         ; $a1f8: f0 1e     
            .hex 02            ; $a1fa: 02        Invalid Opcode - KIL 
            brk                ; $a1fb: 00        
__a1fc:     beq __a1fe         ; $a1fc: f0 00     
__a1fe:     .hex 42            ; $a1fe: 42        Invalid Opcode - KIL 
__a1ff:     brk                ; $a1ff: 00        
            beq __a202         ; $a200: f0 00     
__a202:     .hex 42            ; $a202: 42        Invalid Opcode - KIL 
__a203:     brk                ; $a203: 00        
            beq __a206         ; $a204: f0 00     
__a206:     .hex 42            ; $a206: 42        Invalid Opcode - KIL 
__a207:     brk                ; $a207: 00        
            beq __a20a         ; $a208: f0 00     
__a20a:     .hex 02            ; $a20a: 02        Invalid Opcode - KIL 
__a20b:     brk                ; $a20b: 00        
            beq __a20e         ; $a20c: f0 00     
__a20e:     .hex 02            ; $a20e: 02        Invalid Opcode - KIL 
            brk                ; $a20f: 00        
            beq __a212         ; $a210: f0 00     
__a212:     .hex 02            ; $a212: 02        Invalid Opcode - KIL 
            brk                ; $a213: 00        
            beq __a216         ; $a214: f0 00     
__a216:     .hex 42            ; $a216: 42        Invalid Opcode - KIL 
            brk                ; $a217: 00        
__a218:     beq __a21a         ; $a218: f0 00     
__a21a:     .hex 42            ; $a21a: 42        Invalid Opcode - KIL 
            brk                ; $a21b: 00        
            beq __a21e         ; $a21c: f0 00     
__a21e:     .hex 42            ; $a21e: 42        Invalid Opcode - KIL 
            brk                ; $a21f: 00        
            beq __a222         ; $a220: f0 00     
__a222:     .hex 02            ; $a222: 02        Invalid Opcode - KIL 
            brk                ; $a223: 00        
            beq __a226         ; $a224: f0 00     
__a226:     .hex 02            ; $a226: 02        Invalid Opcode - KIL 
            brk                ; $a227: 00        
            beq __a22a         ; $a228: f0 00     
__a22a:     .hex 02            ; $a22a: 02        Invalid Opcode - KIL 
            brk                ; $a22b: 00        
            beq __a22e         ; $a22c: f0 00     
__a22e:     .hex 42            ; $a22e: 42        Invalid Opcode - KIL 
            brk                ; $a22f: 00        
            beq __a232         ; $a230: f0 00     
__a232:     .hex 42            ; $a232: 42        Invalid Opcode - KIL 
            brk                ; $a233: 00        
            beq __a236         ; $a234: f0 00     
__a236:     .hex 42            ; $a236: 42        Invalid Opcode - KIL 
            brk                ; $a237: 00        
            beq __a23a         ; $a238: f0 00     
__a23a:     .hex 02            ; $a23a: 02        Invalid Opcode - KIL 
            brk                ; $a23b: 00        
            beq __a23e         ; $a23c: f0 00     
__a23e:     .hex 02            ; $a23e: 02        Invalid Opcode - KIL 
            brk                ; $a23f: 00        
            beq __a242         ; $a240: f0 00     
__a242:     .hex 02            ; $a242: 02        Invalid Opcode - KIL 
            brk                ; $a243: 00        
            beq __a246         ; $a244: f0 00     
__a246:     ora ($00,x)        ; $a246: 01 00     
            beq __a24a         ; $a248: f0 00     
__a24a:     ora ($00,x)        ; $a24a: 01 00     
            beq __a24e         ; $a24c: f0 00     
__a24e:     ora ($00,x)        ; $a24e: 01 00     
            beq __a252         ; $a250: f0 00     
__a252:     ora ($00,x)        ; $a252: 01 00     
            beq __a256         ; $a254: f0 00     
__a256:     ora ($00,x)        ; $a256: 01 00     
            beq __a25a         ; $a258: f0 00     
__a25a:     ora ($00,x)        ; $a25a: 01 00     
            beq __a25e         ; $a25c: f0 00     
__a25e:     ora ($00,x)        ; $a25e: 01 00     
            beq __a262         ; $a260: f0 00     
__a262:     ora ($00,x)        ; $a262: 01 00     
            beq __a266         ; $a264: f0 00     
__a266:     ora ($00,x)        ; $a266: 01 00     
            .hex f0            ; $a268: f0        Suspected data
__a269:     brk                ; $a269: 00        
            ora ($00,x)        ; $a26a: 01 00     
            beq __a26e         ; $a26c: f0 00     
__a26e:     ora ($00,x)        ; $a26e: 01 00     
            beq __a272         ; $a270: f0 00     
__a272:     ora ($00,x)        ; $a272: 01 00     
            beq __a276         ; $a274: f0 00     
__a276:     brk                ; $a276: 00        
            bvc __a269         ; $a277: 50 f0     
            brk                ; $a279: 00        
            brk                ; $a27a: 00        
            brk                ; $a27b: 00        
            beq __a27e         ; $a27c: f0 00     
__a27e:     brk                ; $a27e: 00        
            brk                ; $a27f: 00        
            beq __a282         ; $a280: f0 00     
__a282:     brk                ; $a282: 00        
            brk                ; $a283: 00        
            beq __a286         ; $a284: f0 00     
__a286:     brk                ; $a286: 00        
            brk                ; $a287: 00        
            beq __a28a         ; $a288: f0 00     
__a28a:     brk                ; $a28a: 00        
            brk                ; $a28b: 00        
            beq __a28e         ; $a28c: f0 00     
__a28e:     brk                ; $a28e: 00        
            brk                ; $a28f: 00        
            beq __a292         ; $a290: f0 00     
__a292:     brk                ; $a292: 00        
            brk                ; $a293: 00        
            beq __a296         ; $a294: f0 00     
__a296:     brk                ; $a296: 00        
            brk                ; $a297: 00        
            beq __a29a         ; $a298: f0 00     
__a29a:     brk                ; $a29a: 00        
            brk                ; $a29b: 00        
            beq __a29e         ; $a29c: f0 00     
__a29e:     brk                ; $a29e: 00        
            brk                ; $a29f: 00        
            beq __a2a2         ; $a2a0: f0 00     
__a2a2:     brk                ; $a2a2: 00        
            brk                ; $a2a3: 00        
            beq __a2a6         ; $a2a4: f0 00     
__a2a6:     brk                ; $a2a6: 00        
            brk                ; $a2a7: 00        
__a2a8:     sty $012e          ; $a2a8: 8c 2e 01  
            lda #$08           ; $a2ab: a9 08     
            sta $86            ; $a2ad: 85 86     
            lda #$a3           ; $a2af: a9 a3     
            sta $87            ; $a2b1: 85 87     
            cpy #$20           ; $a2b3: c0 20     
            beq __a2bf         ; $a2b5: f0 08     
            lda #$39           ; $a2b7: a9 39     
            sta $86            ; $a2b9: 85 86     
            lda #$a3           ; $a2bb: a9 a3     
            sta $87            ; $a2bd: 85 87     
__a2bf:     lda $18            ; $a2bf: a5 18     
            bne __a2d0         ; $a2c1: d0 0d     
            clc                ; $a2c3: 18        
            lda $86            ; $a2c4: a5 86     
            adc #$1c           ; $a2c6: 69 1c     
            sta $86            ; $a2c8: 85 86     
            lda $87            ; $a2ca: a5 87     
            adc #$00           ; $a2cc: 69 00     
            sta $87            ; $a2ce: 85 87     
__a2d0:     jsr __a3c3         ; $a2d0: 20 c3 a3  
            lda #$70           ; $a2d3: a9 70     
            sta $86            ; $a2d5: 85 86     
            lda #$03           ; $a2d7: a9 03     
            sta $87            ; $a2d9: 85 87     
            ldy $012e          ; $a2db: ac 2e 01  
            ldx #$62           ; $a2de: a2 62     
            jsr __a36a         ; $a2e0: 20 6a a3  
            lda #$66           ; $a2e3: a9 66     
            sta $86            ; $a2e5: 85 86     
            lda #$03           ; $a2e7: a9 03     
            sta $87            ; $a2e9: 85 87     
            ldy $012e          ; $a2eb: ac 2e 01  
            ldx #$6d           ; $a2ee: a2 6d     
            jsr __a36a         ; $a2f0: 20 6a a3  
            lda $18            ; $a2f3: a5 18     
            beq __a307         ; $a2f5: f0 10     
            lda #$76           ; $a2f7: a9 76     
            sta $86            ; $a2f9: 85 86     
            lda #$03           ; $a2fb: a9 03     
            sta $87            ; $a2fd: 85 87     
            ldy $012e          ; $a2ff: ac 2e 01  
            ldx #$77           ; $a302: a2 77     
            jsr __a36a         ; $a304: 20 6a a3  
__a307:     rts                ; $a307: 60        

;-------------------------------------------------------------------------------
            .hex 20 44 18

            ;     1  U  P              H  I  G  H     S  C  O  R  E               
            .hex 2e 1e 19 2d 2d 2d 2d 11 12 10 11 2d 1c 0c 18 1b 0e 2d 2d 2d 2d
            
            .hex 2f 1e 19

            .hex ff 20 44      ; $a323: ff 20 44  Invalid Opcode - ISC $4420,x
            .hex 11            ; $a326: 11        Suspected data
__a327:     rol $191e          ; $a327: 2e 1e 19  
            and $2d2d          ; $a32a: 2d 2d 2d  
            and $1211          ; $a32d: 2d 11 12  
            bpl __a343         ; $a330: 10 11     
            and $0c1c          ; $a332: 2d 1c 0c  
            clc                ; $a335: 18        
            .hex 1b 0e ff      ; $a336: 1b 0e ff  Invalid Opcode - SLO __ff0e,y
            plp                ; $a339: 28        
            .hex 44 18         ; $a33a: 44 18     Invalid Opcode - NOP $18
            rol $191e          ; $a33c: 2e 1e 19  
            and $2d2d          ; $a33f: 2d 2d 2d  
            .hex 2d            ; $a342: 2d        Suspected data
__a343:     ora ($12),y        ; $a343: 11 12     
            bpl __a358         ; $a345: 10 11     
            and $0c1c          ; $a347: 2d 1c 0c  
            clc                ; $a34a: 18        
            .hex 1b 0e 2d      ; $a34b: 1b 0e 2d  Invalid Opcode - SLO $2d0e,y
            and $2d2d          ; $a34e: 2d 2d 2d  
            .hex 2f 1e 19      ; $a351: 2f 1e 19  Invalid Opcode - RLA $191e
            .hex ff 28 44      ; $a354: ff 28 44  Invalid Opcode - ISC $4428,x
            .hex 11            ; $a357: 11        Suspected data
__a358:     rol $191e          ; $a358: 2e 1e 19  
            and $2d2d          ; $a35b: 2d 2d 2d  
            and $1211          ; $a35e: 2d 11 12  
            bpl __a374         ; $a361: 10 11     
            and $0c1c          ; $a363: 2d 1c 0c  
            clc                ; $a366: 18        
            .hex 1b 0e ff      ; $a367: 1b 0e ff  Invalid Opcode - SLO __ff0e,y
__a36a:     tya                ; $a36a: 98        
            sta $2006          ; $a36b: 8d 06 20  
            txa                ; $a36e: 8a        
            sta $2006          ; $a36f: 8d 06 20  
            ldy #$00           ; $a372: a0 00     
__a374:     lda ($86),y        ; $a374: b1 86     
            sta $0382,y        ; $a376: 99 82 03  
            cmp #$00           ; $a379: c9 00     
            bne __a387         ; $a37b: d0 0a     
            lda #$2d           ; $a37d: a9 2d     
            sta $0382,y        ; $a37f: 99 82 03  
            iny                ; $a382: c8        
            cpy #$04           ; $a383: c0 04     
            bne __a374         ; $a385: d0 ed     
__a387:     lda ($86),y        ; $a387: b1 86     
            sta $0382,y        ; $a389: 99 82 03  
            iny                ; $a38c: c8        
            cpy #$06           ; $a38d: c0 06     
            bne __a387         ; $a38f: d0 f6     
            ldx #$00           ; $a391: a2 00     
__a393:     lda $0382,x        ; $a393: bd 82 03  
            sta $2007          ; $a396: 8d 07 20  
            inx                ; $a399: e8        
            cpx #$06           ; $a39a: e0 06     
            bne __a393         ; $a39c: d0 f5     
            lda #$00           ; $a39e: a9 00     
            sta $2005          ; $a3a0: 8d 05 20  
            sta $2005          ; $a3a3: 8d 05 20  
            rts                ; $a3a6: 60        

;-------------------------------------------------------------------------------
__a3a7:     lda _VScrollOffset ; $a3a7: a5 16     
            cmp #$ef           ; $a3a9: c9 ef     
            beq __a3c2         ; $a3ab: f0 15     
            lda #$0e           ; $a3ad: a9 0e     
            sta $2001          ; $a3af: 8d 01 20  
            sta _PPU_Ctrl2_Mirror ; $a3b2: 85 15     
            inc _VScrollOffset ; $a3b4: e6 16     
            inc _VScrollOffset ; $a3b6: e6 16     
            lda _VScrollOffset ; $a3b8: a5 16     
            cmp #$f0           ; $a3ba: c9 f0     
            bcc __a3c2         ; $a3bc: 90 04     
            lda #$ef           ; $a3be: a9 ef     
            sta _VScrollOffset ; $a3c0: 85 16     
__a3c2:     rts                ; $a3c2: 60        

;-------------------------------------------------------------------------------
__a3c3:     ldy #$00           ; $a3c3: a0 00     
__a3c5:     lda ($86),y        ; $a3c5: b1 86     
            cmp #$ff           ; $a3c7: c9 ff     
            bne __a3cc         ; $a3c9: d0 01     
            rts                ; $a3cb: 60        

;-------------------------------------------------------------------------------
__a3cc:     sta $2006          ; $a3cc: 8d 06 20  
            iny                ; $a3cf: c8        
            lda ($86),y        ; $a3d0: b1 86     
            sta $2006          ; $a3d2: 8d 06 20  
            iny                ; $a3d5: c8        
            lda ($86),y        ; $a3d6: b1 86     
            tax                ; $a3d8: aa        
            iny                ; $a3d9: c8        
__a3da:     lda ($86),y        ; $a3da: b1 86     
            sta $2007          ; $a3dc: 8d 07 20  
            iny                ; $a3df: c8        
            dex                ; $a3e0: ca        
            bne __a3da         ; $a3e1: d0 f7     
            lda #$00           ; $a3e3: a9 00     
            sta $2005          ; $a3e5: 8d 05 20  
            sta $2005          ; $a3e8: 8d 05 20  
            jmp __a3c5         ; $a3eb: 4c c5 a3  

;-------------------------------------------------------------------------------
__a3ee:     tya                ; $a3ee: 98        
            sta $2006          ; $a3ef: 8d 06 20  
            txa                ; $a3f2: 8a        
            sta $2006          ; $a3f3: 8d 06 20  
            ldy #$00           ; $a3f6: a0 00     
            ldx #$00           ; $a3f8: a2 00     
            lda #$2d           ; $a3fa: a9 2d     
__a3fc:     sta $2007          ; $a3fc: 8d 07 20  
            inx                ; $a3ff: e8        
            cpx #$00           ; $a400: e0 00     
            bne __a3fc         ; $a402: d0 f8     
            iny                ; $a404: c8        
            cpy #$04           ; $a405: c0 04     
            bne __a3fc         ; $a407: d0 f3     
            lda #$00           ; $a409: a9 00     
            sta $2005          ; $a40b: 8d 05 20  
            sta $2005          ; $a40e: 8d 05 20  
            rts                ; $a411: 60        

;-------------------------------------------------------------------------------
__a412:     lda #$3f           ; $a412: a9 3f     
            sta $2006          ; $a414: 8d 06 20  
            lda #$00           ; $a417: a9 00     
            sta $2006          ; $a419: 8d 06 20  
            ldy #$00           ; $a41c: a0 00     
__a41e:     lda $0146,y        ; $a41e: b9 46 01  
            sta $2007          ; $a421: 8d 07 20  
            iny                ; $a424: c8        
            cpy #$10           ; $a425: c0 10     
            bne __a41e         ; $a427: d0 f5     
            lda #$3f           ; $a429: a9 3f     
            sta $2006          ; $a42b: 8d 06 20  
            lda #$00           ; $a42e: a9 00     
            sta $2006          ; $a430: 8d 06 20  
            sta $2006          ; $a433: 8d 06 20  
            sta $2006          ; $a436: 8d 06 20  
            rts                ; $a439: 60        

;-------------------------------------------------------------------------------
SetSpritePalette:
            lda #$3f           ; $a43a: a9 3f     .
            sta $2006          ; $a43c: 8d 06 20  |
            lda #$10           ; $a43f: a9 10     |
            sta $2006          ; $a441: 8d 06 20  | set PPU memory address $3f10 (sprite palette)
            ldy #$00           ; $a444: a0 00     . for y = 0..0xf,
Loop_a446:  lda $0156,y        ; $a446: b9 56 01    .
            sta $2007          ; $a449: 8d 07 20    | Copy $0156-$0165 values into PPU memory
            iny                ; $a44c: c8        .
            cpy #$10           ; $a44d: c0 10     |
            bne Loop_a446      ; $a44f: d0 f5     | loop
            lda #$3f           ; $a451: a9 3f     .
            sta $2006          ; $a453: 8d 06 20  |
            lda #$00           ; $a456: a9 00     |
            sta $2006          ; $a458: 8d 06 20  | set PPU memory address $3f00
            sta $2006          ; $a45b: 8d 06 20  .
            sta $2006          ; $a45e: 8d 06 20  | set PPU memory address $0000
            rts                ; $a461: 60        . return

;-------------------------------------------------------------------------------
__a462:     sta $2006          ; $a462: 8d 06 20  
            lda #$c0           ; $a465: a9 c0     
            sta $2006          ; $a467: 8d 06 20  
            ldy #$00           ; $a46a: a0 00     
__a46c:     lda ($86),y        ; $a46c: b1 86     
            sta $2007          ; $a46e: 8d 07 20  
            iny                ; $a471: c8        
            cpy #$40           ; $a472: c0 40     
            bne __a46c         ; $a474: d0 f6     
            lda #$00           ; $a476: a9 00     
            sta $2005          ; $a478: 8d 05 20  
            sta $2005          ; $a47b: 8d 05 20  
            rts                ; $a47e: 60        

;-------------------------------------------------------------------------------
            sta $2006          ; $a47f: 8d 06 20  
            lda #$c0           ; $a482: a9 c0     
            sta $2006          ; $a484: 8d 06 20  
            ldy #$00           ; $a487: a0 00     
            lda #$00           ; $a489: a9 00     
__a48b:     sta $2007          ; $a48b: 8d 07 20  
            iny                ; $a48e: c8        
            cpy #$40           ; $a48f: c0 40     
            bne __a48b         ; $a491: d0 f8     
            lda #$00           ; $a493: a9 00     
            sta $2005          ; $a495: 8d 05 20  
            sta $2005          ; $a498: 8d 05 20  
            rts                ; $a49b: 60        

;-------------------------------------------------------------------------------
            and ($08,x)        ; $a49c: 21 08     
            bpl __a4d0         ; $a49e: 10 30     
            and ($32),y        ; $a4a0: 31 32     
__a4a2:     .hex 33 34         ; $a4a2: 33 34     Invalid Opcode - RLA ($34),y
            and $36,x          ; $a4a4: 35 36     
            .hex 37 38         ; $a4a6: 37 38     Invalid Opcode - RLA $38,x
            and $3b3a,y        ; $a4a8: 39 3a 3b  
            .hex 3c 3d 3e      ; $a4ab: 3c 3d 3e  Invalid Opcode - NOP $3e3d,x
            .hex 3f 21 28      ; $a4ae: 3f 21 28  Invalid Opcode - RLA $2821,x
            .hex 10 40         ; $a4b1: 10 40     
            eor ($42,x)        ; $a4b3: 41 42     
            .hex 43 44         ; $a4b5: 43 44     Invalid Opcode - SRE ($44,x)
            eor $46            ; $a4b7: 45 46     
            .hex 47 48         ; $a4b9: 47 48     Invalid Opcode - SRE $48
            eor #$4a           ; $a4bb: 49 4a     
            .hex 4b 4c         ; $a4bd: 4b 4c     Invalid Opcode - ALR #$4c
            eor $4f4e          ; $a4bf: 4d 4e 4f  
            and ($48,x)        ; $a4c2: 21 48     
            .hex 10 50         ; $a4c4: 10 50     
            eor ($52),y        ; $a4c6: 51 52     
            .hex 53 54         ; $a4c8: 53 54     Invalid Opcode - SRE ($54),y
            eor $56,x          ; $a4ca: 55 56     
            .hex 57 58         ; $a4cc: 57 58     Invalid Opcode - SRE $58,x
            .hex 59 5a         ; $a4ce: 59 5a     Suspected data
__a4d0:     .hex 5b 5c 5d      ; $a4d0: 5b 5c 5d  Invalid Opcode - SRE $5d5c,y
            lsr $225f,x        ; $a4d3: 5e 5f 22  
            .hex 0c 08 01      ; $a4d6: 0c 08 01  Invalid Opcode - NOP $0108
            and $1519          ; $a4d9: 2d 19 15  
            asl                ; $a4dc: 0a        
            .hex 22            ; $a4dd: 22        Invalid Opcode - KIL 
            asl $221b          ; $a4de: 0e 1b 22  
            jmp $0209          ; $a4e1: 4c 09 02  

;-------------------------------------------------------------------------------
            and $1519          ; $a4e4: 2d 19 15  
            asl                ; $a4e7: 0a        
            .hex 22            ; $a4e8: 22        Invalid Opcode - KIL 
            asl $1c1b          ; $a4e9: 0e 1b 1c  
            .hex 22            ; $a4ec: 22        Invalid Opcode - KIL 
            .hex cb 0a         ; $a4ed: cb 0a     Invalid Opcode - AXS #$0a
            rts                ; $a4ef: 60        

;-------------------------------------------------------------------------------
Text_a4f0:  .hex 61 62 63 64 65 66 67 68 69
            .hex 22 eb 0a
            .hex 70 71 72 73 74 75 76 77 78 79
            

Text_a506   .hex 23 24 18

            ;    (c)    T  A  I  T  O     C  O  R  P  O  R  A  T  I  O  N     1  9  8  7
Text_a509:  .hex 28 2d 1d 0a 12 1d 18 2d 0c 18 1b 19 18 1b 0a 1d 12 18 17 2d 01 09 08 07

Text_a522:  .hex 23 44 18

            ;                       L  I  C  E  N  S  E  D     B  Y                     
Text_a525:  .hex 2d 2d 2d 2d 2d 2d 15 12 0c 0e 17 1c 0e 0d 2d 0b 22 2d 2d 2d 2d 2d 2d 2d

Text_a53d:  .hex 23 64 18

            ;     N  I  N  T  E  N  D  O     O  F     A  M  E  R  I  C  A     I  N  C  .
Text_a540:  .hex 17 12 17 1d 0e 17 0d 18 2d 18 0f 2d 0a 16 0e 1b 12 0c 0a 2d 12 17 0c 27
            
Text_a558:  .hex ff
            
Text_a559:  .hex 28 e3 13

            ;     T  H  E     E  R  A     A  N  D     T  I  M  E     O  F
Text_a55c   .hex 1d 11 0e 2d 0e 1b 0a 2d 0a 17 0d 2d 1d 12 16 0e 2d 18 0f

            .hex 29 23 16

            ;     T  H  I  S     S  T  O  R  Y     I  S     U  N  K  N  O  W  N  .
            .hex 1d 11 12 1c 2d 1c 1d 18 1b 22 2d 12 1c 2d 1e 17 14 17 18 20 17 27

            .hex 29 83 15
            
            ;     A  F  T  E  R     T  H  E     M  O  T  H  E  R     S  H  I  P
            .hex 0a 0f 1d 0e 1b 2d 1d 11 0e 2d 16 18 1d 11 0e 1b 2d 1c 11 12 19
            
            .hex 29 c3 19
            
            ;     "  A  R  K  A  N  O  I  D  "     W  A  S     D  E  S  T  R  O  Y  E  D  ,
            .hex 2a 0a 1b 14 0a 17 18 12 0d 24 2d 20 0a 1c 2d 0d 0e 1c 1d 1b 18 22 0e 0d 25

            .hex 2a 03 13

            ;     A     S  P  A  C  E  C  R  A  F  T     "  V  A  U  S  "
            .hex 0a 2d 1c 19 0a 0c 0e 0c 1b 0a 0f 1d 2d 2a 1f 0a 1e 1c 24
            
            .hex 2a 43 17

            ;     S  C  R  A  M  B  L  E  D     A  W  A  Y     F  R  O  M     I  T  .
            .hex 1c 0c 1b 0a 16 0b 15 0e 0d 2d 0a 20 0a 22 2d 0f 1b 18 16 2d 12 1d 27
            
            .hex 2a a3 0e

            ;     B  U  T     O  N  L  Y     T  O     B  E
            .hex 0b 1e 1d 2d 18 17 15 22 2d 1d 18 2d 0b 0e

            .hex 2a e3 17

            ;     T  R  A  P  P  E  D     I  N     S  P  A  C  E     W  A  R  P  E  D
            .hex 1d 1b 0a 19 19 0e 0d 2d 12 17 2d 1c 19 0a 0c 0e 2d 20 0a 1b 19 0e 0d

            .hex 2b 23 10
            
            ;     B  Y     S  O  M  E  O  N  E  .  .  .  .  .  .
            .hex 0b 22 2d 1c 18 16 0e 18 17 0e 27 27 27 27 27 27

            .hex ff
            
            .hex 28 e3 1a

            ;     D  I  M  E  N  S  I  O  N  -  C  O  N  T  R  O  L  L  I  N  G     F  O  R  T 
            .hex 0d 12 16 0e 17 1c 12 18 17 26 0c 18 17 1d 1b 18 15 15 12 17 10 2d 0f 18 1b 1d
            
            .hex 29 23 12

            ;     "  D  O  H  "     H  A  S     N  O  W     B  E  E  N
            .hex 2a 0d 18 11 24 2d 11 0a 1c 2d 17 18 20 2d 0b 0e 0e 17
            
            .hex 29 63 14
            
            ;     D  E  M  O  L  I  S  H  E  D  ,     A  N  D     T  I  M  E
            .hex 0d 0e 16 18 15 12 1c 11 0e 0d 25 2d 0a 17 0d 2d 1d 12 16 0e
            
            .hex 29 a3 19

            ;     S  T  A  R  T  E  D     F  L  O  W  I  N  G     R  E  V  E  R  S  L  Y  .
            .hex 1c 1d 0a 1b 1d 0e 0d 2d 0f 15 18 20 12 17 10 2d 1b 0e 1f 0e 1b 1c 15 22 27
            
            .hex 2a 03 18

            ;     "  V  A  U  S  "     M  A  N  A  G  E  D     T  O     E  S  C  A  P  E
            .hex 2a 1f 0a 1e 1c 24 2d 16 0a 17 0a 10 0e 0d 2d 1d 18 2d 0e 1c 0c 0a 19 0e
            
            .hex 2a 43 19

            ;     F  R  O  M     T  H  E     D  I  S  T  O  R  T  E  D     S  P  A  C  E  .
            .hex 0f 1b 18 16 2d 1d 11 0e 2d 0d 12 1c 1d 18 1b 1d 0e 0d 2d 1c 19 0a 0c 0e 27
            
            .hex 2a a3 16

            ;     B  U  T     T  H  E     R  E  A  L     V  O  Y  A  G  E     O  F
            .hex 0b 1e 1d 2d 1d 11 0e 2d 1b 0e 0a 15 2d 1f 18 22 0a 10 0e 2d 18 0f
            
            .hex 2a e3 18
            
            ;     "  A  R  K  A  N  O  I  D  "     I  N     T  H  E     G  A  L  A  X  Y
            .hex 2a 0a 1b 14 0a 17 18 12 0d 24 2d 12 17 2d 1d 11 0e 2d 10 0a 15 0a 21 22
            
            .hex 2b 23 16
            
            ;     H  A  S     O  N  L  Y     S  T  A  R  T  E  D  .  .  .  .  .  .
            .hex 11 0a 1c 2d 18 17 15 22 2d 1c 1d 0a 1b 1d 0e 0d 27 27 27 27 27 27
            
            .hex ff

UpdateActiveBalls:
            lda #$00           ; $a714: a9 00     .
            sta BlockCollisFlag; $a716: 8d 45 01  | Reset block collision flag
            lda GameState      ; $a719: a5 0a     .
            cmp #$10           ; $a71b: c9 10     |
            bne Ret_a72f       ; $a71d: d0 10     | if game state != 0x10 (active ball), return
            lda CurrentBlocks  ; $a71f: a5 0f     .
            cmp #$00           ; $a721: c9 00     |
            beq Ret_a72f       ; $a723: f0 0a     | if current blocks == 0, return
            lda BallSpeedReduction ; $a725: ad 05 01 .
            cmp #$00           ; $a728: c9 00        |
            beq Next_a730      ; $a72a: f0 04        | if there's no speed reduction or it's finished this frame, go update the ball
            dec BallSpeedReduction ; $a72c: ce 05 01 . else decrement the speed reduction value
Ret_a72f:   rts                ; $a72f: 60        . return

;-------------------------------------------------------------------------------
Next_a730:  lda ActiveBalls    ; $a730: a5 81     .
            sta BallUpdateItr  ; $a732: 85 82     |
            lda #$03           ; $a734: a9 03     |
            sta ActiveBallItr  ; $a736: 85 83     | init iterators
            ldy #$00           ; $a738: a0 00     . Init y 
OuterLoop_a73a:
            tya                ; $a73a: 98        .
            pha                ; $a73b: 48        | Save y on the stack for later
            lda BallUpdateItr  ; $a73c: a5 82     .
            ror                ; $a73e: 6a        |
            sta BallUpdateItr  ; $a73f: 85 82     |
            bcc Next_a79d      ; $a741: 90 5a     | If this ball exists,
            ldx #$00           ; $a743: a2 00         . Init x
Loop_a745:  lda $0033,y        ; $a745: b9 33 00      .
            sta $0131          ; $a748: 8d 31 01      |
            lda $33,x          ; $a74b: b5 33         |
            sta $0033,y        ; $a74d: 99 33 00      |
            lda $0131          ; $a750: ad 31 01      |
            sta $33,x          ; $a753: 95 33         | Copy ball N data into the ball 1 struct space
            inx                ; $a755: e8            .
            iny                ; $a756: c8            |
            cpx #BallStructSize ; $a757: e0 1a        |
            bne Loop_a745      ; $a759: d0 ea         | Loop for each byte in the struct
Loop_a75b:  jsr UpdateBallSpeedData ; $a75b: 20 a7 a7 .
            jsr AdvanceOneBall ; $a75e: 20 fa a7      |
            jsr UpdatePosComps ; $a761: 20 8f a8      |
            jsr CheckBlockBossCollis; $a764: 20 8d af |
            jsr CheckPaddleCollis ; $a767: 20 b7 a8   |
            jsr CheckEnemyCollis ; $a76a: 20 aa ab    |
            jsr UpdateCeilCollisVSign; $a76d: 20 6f a9|
            jsr HandleBlockCollis ; $a770: 20 ec a9   |
            jsr CheckBallLost  ; $a773: 20 10 ab      | Update this ball N times based on the speed multiplier
            lda BallCycle      ; $a776: a5 45         .
            cmp #$00           ; $a778: c9 00         |
            beq Next_a782      ; $a77a: f0 06         | if cycle timer > 0
            dec BallSpeedMult  ; $a77c: c6 46           . decrement speed multiplier
            bne Loop_a75b      ; $a77e: d0 db           . if the value is still set, go update the ball again
            dec BallCycle      ; $a780: c6 45           . else update the cycle timer
Next_a782:  pla                ; $a782: 68            . grab y from the stack
            pha                ; $a783: 48            | put it back on the stack
            tay                ; $a784: a8            | transfer it to [y]
            ldx #$00           ; $a785: a2 00         . init x
Loop_a787:  lda $0033,y        ; $a787: b9 33 00      .
            sta $0131          ; $a78a: 8d 31 01      |
            lda $33,x          ; $a78d: b5 33         |
            sta $0033,y        ; $a78f: 99 33 00      |
            lda $0131          ; $a792: ad 31 01      |
            sta $33,x          ; $a795: 95 33         | Copy ball data back into the ball N struct space
            inx                ; $a797: e8            .
            iny                ; $a798: c8            |
            cpx #BallStructSize; $a799: e0 1a         |
            bne Loop_a787      ; $a79b: d0 ea         | loop
Next_a79d:  pla                ; $a79d: 68            . grab y from the stack
            clc                ; $a79e: 18            .
            adc #BallStructSize; $a79f: 69 1a         |
            tay                ; $a7a1: a8            | add the ball struct stride for the next iteration
            dec ActiveBallItr  ; $a7a2: c6 83         .
            bne OuterLoop_a73a ; $a7a4: d0 94         | continue loop until the iter == 0
            rts                ; $a7a6: 60        . return

;-------------------------------------------------------------------------------
UpdateBallSpeedData:
            lda BallCycle      ; $a7a7: a5 45     .
            bne Next_a7e0      ; $a7a9: d0 35     | if cycle timer == 0,
            lda #$5d           ; $a7ab: a9 5d       .
            sta SpeedTablePtrLo; $a7ad: 85 43       |
            lda #$ac           ; $a7af: a9 ac       |
            sta SpeedTablePtrHi; $a7b1: 85 44       | Set init speed table pointer = $ac5d
            clc                ; $a7b3: 18          .
            lda Ball_1_Angle   ; $a7b4: a5 48       |
            adc SpeedTablePtrHi; $a7b6: 65 44       |
            sta SpeedTablePtrHi; $a7b8: 85 44       | Adjust speed table pointer based on angle: $ac5d (steep angle), $ad5d (normal), or $ae5d (shallow)
            clc                ; $a7ba: 18          .
            lda BallSpeedStage ; $a7bb: a5 49       |
            asl                ; $a7bd: 0a          |
            asl                ; $a7be: 0a          |
            asl                ; $a7bf: 0a          |
            asl                ; $a7c0: 0a          |
            adc SpeedTablePtrLo; $a7c1: 65 43       |
            sta SpeedTablePtrLo; $a7c3: 85 43       | index into the appropriate row for the speed stage ($aX5d + speed stage * 16)
            lda SpeedTablePtrHi; $a7c5: a5 44       .
            adc #$00           ; $a7c7: 69 00       |
            sta SpeedTablePtrHi; $a7c9: 85 44       | no-op??
            ldy #$00           ; $a7cb: a0 00       .
            lda ($43),y        ; $a7cd: b1 43       |
            sta BallCycle      ; $a7cf: 85 45       | load cycle = byte 0
            lda #$00           ; $a7d1: a9 00       .
            sta BallSpeedMult  ; $a7d3: 85 46       | Reset speed multiplier
            ldy #$02           ; $a7d5: a0 02       .
            lda ($43),y        ; $a7d7: b1 43       | 
            sta BallSpeedReduction ; $a7d9: 8d 05 01| load speed reduction = byte 2
            lda #$04           ; $a7dc: a9 04       .
            sta SpeedTableIdx  ; $a7de: 85 47       | reset speed table index to 4
Next_a7e0:  lda BallSpeedMult  ; $a7e0: a5 46     .
            bne Next_a7ea      ; $a7e2: d0 06     | if the speed multiplier isn't set,
            ldy #$01           ; $a7e4: a0 01       .
            lda ($43),y        ; $a7e6: b1 43       |
            sta BallSpeedMult  ; $a7e8: 85 46       | load the initial speed multiplier from the table
Next_a7ea:  ldy SpeedTableIdx  ; $a7ea: a4 47     .
            lda ($43),y        ; $a7ec: b1 43     |
            sta Ball_1_Vel_Y   ; $a7ee: 85 35     | load vy = byte [4 + 2N]
            iny                ; $a7f0: c8        .
            lda ($43),y        ; $a7f1: b1 43     |
            sta Ball_1_Vel_X   ; $a7f3: 85 36     | load vx = byte [4 + 2N + 1]
            inc SpeedTableIdx  ; $a7f5: e6 47     .
            inc SpeedTableIdx  ; $a7f7: e6 47     | increase speed table index by 2 for next frame
            rts                ; $a7f9: 60        . return

;-------------------------------------------------------------------------------
AdvanceOneBall:
            lda #$00           ; $a7fa: a9 00     .
            sta $012e          ; $a7fc: 8d 2e 01  | Set iterator = 0
            sta BallCollisType ; $a7ff: 85 34     .    
            sta CeilCollisFlag ; $a801: 8d 04 01  | Clear out collision flags
Loop_a804:  lda BallVelSign    ; $a804: a5 33     .
            and #$01           ; $a806: 29 01     |
            bne Next_a82b      ; $a808: d0 21     | if vy sign is negative,
            sec                ; $a80a: 38          .
            lda Ball_1_Y       ; $a80b: a5 37       |
            sbc Ball_1_Vel_Y   ; $a80d: e5 35       |
            sta Ball_1_Y       ; $a80f: 85 37       | Subtract ball vy from y
            cmp #$10           ; $a811: c9 10       .
            bcs Next_a819      ; $a813: b0 04       |
            lda #$10           ; $a815: a9 10       |
            sta Ball_1_Y       ; $a817: 85 37       | Clamp ball y to 0x10
Next_a819:  lda Ball_1_Y       ; $a819: a5 37       .
            cmp #$10           ; $a81b: c9 10       |
            bne Next_a832      ; $a81d: d0 13       | if ball y == 0x10,
            lda BallCollisType ; $a81f: a5 34         .
            ora #$01           ; $a821: 09 01         |
            sta CeilCollisFlag ; $a823: 8d 04 01      | Set ceiling collision flag
            sta BallCollisType  ; $a826: 85 34        . Set y-collision bit
            jmp Next_a832      ; $a828: 4c 32 a8      . Move on to x-pos update

;-------------------------------------------------------------------------------
Next_a82b:  clc                ; $a82b: 18        .
            lda Ball_1_Y       ; $a82c: a5 37     |
            adc Ball_1_Vel_Y   ; $a82e: 65 35     |
            sta Ball_1_Y       ; $a830: 85 37     | Add ball vy to y
Next_a832:  lda BallVelSign    ; $a832: a5 33     .
            and #$02           ; $a834: 29 02     |
            beq Next_a856      ; $a836: f0 1e     | vx sign = positive? Go to pos-vx-update
            sec                ; $a838: 38        .
            lda Ball_1_X       ; $a839: a5 38     |
            sbc Ball_1_Vel_X   ; $a83b: e5 36     |
            sta Ball_1_X       ; $a83d: 85 38     | else subtract ball vx from x
            cmp #$10           ; $a83f: c9 10     .
            bcs Next_a847      ; $a841: b0 04     |
            lda #$10           ; $a843: a9 10     |
            sta Ball_1_X       ; $a845: 85 38     | Clamp ball x to 0x10
Next_a847:  lda Ball_1_X       ; $a847: a5 38     .
            cmp #$10           ; $a849: c9 10     |
            bne Next_a853      ; $a84b: d0 06     | if ball y == 0x10,
            lda BallCollisType ; $a84d: a5 34       .
            ora #$02           ; $a84f: 09 02       |
            sta BallCollisType ; $a851: 85 34       | Set x-collision bit
Next_a853:  jmp Next_a871      ; $a853: 4c 71 a8    . Move on to loop conditions

;-------------------------------------------------------------------------------
Next_a856:  clc                ; $a856: 18        .
            lda Ball_1_X       ; $a857: a5 38     |
            adc Ball_1_Vel_X   ; $a859: 65 36     |
            sta Ball_1_X       ; $a85b: 85 38     | Add ball vx to x
            cmp #$bc           ; $a85d: c9 bc     .
            bcc Next_a865      ; $a85f: 90 04     |
            lda #$bc           ; $a861: a9 bc     |
            sta Ball_1_X       ; $a863: 85 38     | clamp ball x to 0xbc
Next_a865:  lda Ball_1_X       ; $a865: a5 38     .
            cmp #$bc           ; $a867: c9 bc     |
            bne Next_a871      ; $a869: d0 06     | if ball x == 0xbc,
            lda BallCollisType ; $a86b: a5 34       .
            ora #$02           ; $a86d: 09 02       |
            sta BallCollisType ; $a86f: 85 34       | Set x-collision bit
Next_a871:  lda BallCollisType ; $a871: a5 34     . 
            bne Ret_a88e       ; $a873: d0 19     | if there aren't any collisions,
            lda BallVelSign    ; $a875: a5 33       .
            and #$01           ; $a877: 29 01       | 
            bne Ret_a88e       ; $a879: d0 13       | if vy sign is negative (the ball's moving up),
            lda $012e          ; $a87b: ad 2e 01      .
            cmp #$01           ; $a87e: c9 01         |
            beq Ret_a88e       ; $a880: f0 0c         | if we haven't already done the double-update,
            lda Ball_1_Y       ; $a882: a5 37           .
            cmp #$cd           ; $a884: c9 cd           |
            bcc Ret_a88e       ; $a886: 90 06           | if y >= 0xcd,
            inc $012e          ; $a888: ee 2e 01          .
            jmp Loop_a804      ; $a88b: 4c 04 a8          | increment iterator, update the ball again

;-------------------------------------------------------------------------------
Ret_a88e:   rts                ; $a88e: 60        . return

;-------------------------------------------------------------------------------
UpdatePosComps:
            sec                ; $a88f: 38        .
            lda Ball_1_Y       ; $a890: a5 37     |
            sbc #$10           ; $a892: e9 10     |
            lsr                ; $a894: 4a        |
            lsr                ; $a895: 4a        |
            lsr                ; $a896: 4a        |
            sta BallYHiBits    ; $a897: 85 39     | Set y high bit val to ((y - 0x10) / 8)
            sec                ; $a899: 38        .
            lda Ball_1_Y       ; $a89a: a5 37     |
            sbc #$10           ; $a89c: e9 10     |
            and #$07           ; $a89e: 29 07     |
            sta BallYLoBits    ; $a8a0: 85 3a     | Set y low bit val to ((y - 0x10) % 8)
            sec                ; $a8a2: 38        .
            lda Ball_1_X       ; $a8a3: a5 38     |
            sbc #$10           ; $a8a5: e9 10     |
            lsr                ; $a8a7: 4a        |
            lsr                ; $a8a8: 4a        |
            lsr                ; $a8a9: 4a        |
            lsr                ; $a8aa: 4a        |
            sta BallXHiBits    ; $a8ab: 85 3b     | Set x high bit val to ((x - 0x10) / 16)
            sec                ; $a8ad: 38        .
            lda Ball_1_X       ; $a8ae: a5 38     |
            sbc #$10           ; $a8b0: e9 10     |
            and #$0f           ; $a8b2: 29 0f     |
            sta BallXLoBits    ; $a8b4: 85 3c     | Set x low bit val to ((x - 0x10) % 16)
            rts                ; $a8b6: 60        . return

;-------------------------------------------------------------------------------
CheckPaddleCollis:
            lda #$00           ; $a8b7: a9 00     .
            sta PaddleCollisFlag ; $a8b9: 8d 12 01| Clear paddle collision flag
            lda BallVelSign    ; $a8bc: a5 33     .
            and #$01           ; $a8be: 29 01     |
            beq Ret_a913       ; $a8c0: f0 51     | If vy is negative (ball moving upwards), return
            clc                ; $a8c2: 18        .
            lda Ball_1_Y       ; $a8c3: a5 37     |
            adc #$04           ; $a8c5: 69 04     |
            cmp PaddleTop_A    ; $a8c7: cd 14 01  |     (if ball isn't at paddle top edge yet)
            bcc Ret_a913       ; $a8ca: 90 47     | If (ball y + 4) < paddle top edge, return
            clc                ; $a8cc: 18        .
            lda PaddleTop_A    ; $a8cd: ad 14 01  |
            adc #$03           ; $a8d0: 69 03     |
            cmp Ball_1_Y       ; $a8d2: c5 37     |     (if ball is too far below paddle)
            bcc Ret_a913       ; $a8d4: 90 3d     | If (paddle top edge + 3) < ball y, return
            clc                ; $a8d6: 18        .
            lda Ball_1_X       ; $a8d7: a5 38     |
            adc #$04           ; $a8d9: 69 04     |
            cmp PaddleLeftEdge ; $a8db: cd 1a 01  |
            bcc Ret_a913       ; $a8de: 90 33     | If (ball x + 4) < paddle left edge, return
            ldx #$00           ; $a8e0: a2 00     .
            lda Ball_1_X       ; $a8e2: a5 38     |
            cmp PaddleLeftEdge ; $a8e4: cd 1a 01  |
            bcc Next_a914      ; $a8e7: 90 2b     | If ball x < paddle left edge, go to sub(0)
            ldx #$02           ; $a8e9: a2 02     .
            cmp PaddleLeftCenter ; $a8eb: cd 1b 01|
            bcc Next_a914      ; $a8ee: 90 24     | If ball x < paddle left-center, go to sub(2)
            ldx #$04           ; $a8f0: a2 04     .
            clc                ; $a8f2: 18        |
            adc #$01           ; $a8f3: 69 01      .
            cmp PaddleRightCenter ; $a8f5: cd 1d 01|
            bcc Next_a914      ; $a8f8: 90 1a      | If (ballX+1) < paddle right-center, go to sub(4)
            ldx #$06           ; $a8fa: a2 06     .
            lda Ball_1_X       ; $a8fc: a5 38     |
            cmp PaddleRightEdge ; $a8fe: cd 1f 01 |
            bcc Next_a914      ; $a901: 90 11     | If ball x < paddle right edge, go to sub(6)
            ldx #$08           ; $a903: a2 08     .
            sec                ; $a905: 38        |
            sbc PaddleRightEdge ; $a906: ed 1f 01 |
            cmp #$05           ; $a909: c9 05     |
            bcc Next_a914      ; $a90b: 90 07     | If (ballX - paddle right edge) < 5, go to sub(8)
            ldx #$0a           ; $a90d: a2 0a     .
            cmp #$08           ; $a90f: c9 08     |
            bcc Next_a914      ; $a911: 90 01     | If (ballX - paddle right edge) < 8, go to sub(0xa)
Ret_a913:   rts                ; $a913: 60        . else return

;-------------------------------------------------------------------------------
Next_a914:  lda __a963,x       ; $a914: bd 63 a9  .
            sta BallVelSign    ; $a917: 85 33     |
            lda __a964,x       ; $a919: bd 64 a9  |
            sta Ball_1_Angle   ; $a91c: 85 48     | Load appropriate sign + angle for bounce loc
            lda SpeedStage     ; $a91e: ad 00 01  .
            sta BallSpeedStage ; $a921: 85 49     |
            lda SpeedStageM    ; $a923: ad 01 01  |
            sta BallSpeedStageM; $a926: 85 4a     | Copy overall speed stage to ball speed stage
            lda #$00           ; $a928: a9 00       .
            sta BallSpeedReduction; $a92a: 8d 05 01 | Reset speed reduction value (to immediately move the ball next frame?)
            sta BallCycle      ; $a92d: 85 45      . Reset cycle timer
            lda #$01           ; $a92f: a9 01      .
            sta PaddleCollisFlag ; $a931: 8d 12 01 | Set paddle collision flag
            lda #$15           ; $a934: a9 15     
            sta $0126          ; $a936: 8d 26 01  
            lda #$18           ; $a939: a9 18     
            sta $0127          ; $a93b: 8d 27 01  
            lda IsStickyPaddle ; $a93e: ad 28 01  .
            cmp #$00           ; $a941: c9 00     |
            beq Next_a958      ; $a943: f0 13     | if the paddle is sticky,
            sec                ; $a945: 38           .
            lda PaddleTop_A    ; $a946: ad 14 01     |
            sbc #$04           ; $a949: e9 04        |
            sta Ball_1_Y       ; $a94b: 85 37        | Set ball y to paddle top - 4
            lda MuteSoundEffectsTimer ; $a94d: ad 0e 01 .
            bne Ret_a962       ; $a950: d0 10           | if we're not muting sound effects,
            lda #$04           ; $a952: a9 04             .
            jsr PlaySoundEffect; $a954: 20 c6 f3          |play sound effect 4
            rts                ; $a957: 60        . return

;-------------------------------------------------------------------------------
Next_a958:  lda MuteSoundEffectsTimer ; $a958: ad 0e 01 .
            bne Ret_a962       ; $a95b: d0 05           | if we're not muting sound effects,
            lda #$01           ; $a95d: a9 01             .
            jsr PlaySoundEffect; $a95f: 20 c6 f3          | play sound effect 1
Ret_a962:   rts                ; $a962: 60              . return

;-------------------------------------------------------------------------------
__a963:     .hex 02       ; First byte = new sign bits
__a964:     .hex    02    ; Second byte = angle
            .hex 02 01
            .hex 02 00
            .hex 00 00
            .hex 00 01
            .hex 00 02

UpdateCeilCollisVSign:
            lda PaddleCollisFlag ; $a96f: ad 12 01  .
            cmp #$00           ; $a972: c9 00       |
            beq Next_a977      ; $a974: f0 01       |
            rts                ; $a976: 60          | if there isn't a paddle collision, continue

;-------------------------------------------------------------------------------
Next_a977:  lda CeilCollisFlag ; $a977: ad 04 01  .
            cmp #$00           ; $a97a: c9 00     |
            beq Next_a9b6      ; $a97c: f0 38     | if there's a ceiling collision,
            ldx CurrentLevel   ; $a97e: a6 1a           .
            lda __CeilBounceSpdStage,x ; $a980: bd c4 99|
            cmp #$00           ; $a983: c9 00           |
            beq Next_a9af      ; $a985: f0 28           | if there's a ceiling-bounce speed stage value set for this level,
            cmp SpeedStage     ; $a987: cd 00 01          .
            beq Next_a9af      ; $a98a: f0 23             |
            bcc Next_a9af      ; $a98c: 90 21             | if it's > the current speed stage
            sta SpeedStage     ; $a98e: 8d 00 01            .
            sta SpeedStageM    ; $a991: 8d 01 01            |
            sta BallSpeedStage ; $a994: 85 49               |
            sta $63            ; $a996: 85 63               |
            sta $7d            ; $a998: 85 7d               |
            sta BallSpeedStageM; $a99a: 85 4a               |
            sta $64            ; $a99c: 85 64               |
            sta $7e            ; $a99e: 85 7e               | apply it to all speed stage values
            tax                ; $a9a0: aa                  .
            lda __SpeedStageThresholds,x ; $a9a1: bd 8f 99  |
            sta SpeedStageCounter ; $a9a4: 8d 02 01         | load the appropriate counter value for the speed stage
            lda #$00           ; $a9a7: a9 00               .
            sta BallCycle      ; $a9a9: 85 45               |
            sta $5f            ; $a9ab: 85 5f               |
            sta $79            ; $a9ad: 85 79               | Reset cycle timer for all three balls
Next_a9af:  lda BallVelSign    ; $a9af: a5 33       .
            eor BallCollisType ; $a9b1: 45 34       |
            sta BallVelSign    ; $a9b3: 85 33       |
            rts                ; $a9b5: 60          | Adjust velocity signs based on collision dir

;-------------------------------------------------------------------------------
Next_a9b6:  lda BallCollisType ; $a9b6: a5 34     .
            cmp #$00           ; $a9b8: c9 00     |
            beq Ret_a9e8       ; $a9ba: f0 2c     | if there are any collisions,
            lda #$00           ; $a9bc: a9 00       .
            sta BallCycle      ; $a9be: 85 45       | Reset cycle timer
            lda BallVelSign    ; $a9c0: a5 33       .
            eor BallCollisType ; $a9c2: 45 34       |
            sta BallVelSign    ; $a9c4: 85 33       | Flip velocity signs based on collision(s)
            and #$01           ; $a9c6: 29 01       .
            bne Ret_a9e8       ; $a9c8: d0 1e       | y-velocity positive? Return
            lda SpeedStage     ; $a9ca: ad 00 01    .
            cmp BallSpeedStage ; $a9cd: c5 49       |
            beq Next_a9d8      ; $a9cf: f0 07       | if the ball speed and overall speed stages aren't in sync,
            sta BallSpeedStage ; $a9d1: 85 49         .
            sta BallSpeedStageM; $a9d3: 85 4a         | set ball speed stage
            jmp Next_a9e1      ; $a9d5: 4c e1 a9    . else

;-------------------------------------------------------------------------------
Next_a9d8:  lda SpeedStageM    ; $a9d8: ad 01 01      .
            cmp BallSpeedStageM; $a9db: c5 4a         |
            beq Ret_a9e8       ; $a9dd: f0 09         | if the ball speed and overall speed stage mirrors aren't in sync,
            sta BallSpeedStageM; $a9df: 85 4a           . set ball speed stage mirror
Next_a9e1:  ldy Ball_1_Angle   ; $a9e1: a4 48       .
            lda __a9e9,y       ; $a9e3: b9 e9 a9    |
            sta Ball_1_Angle   ; $a9e6: 85 48       | the speed stage was updated, so reset the angle to 0 or 1 (?)
Ret_a9e8:   rts                ; $a9e8: 60        . return

;-------------------------------------------------------------------------------
__a9e9:     .hex 01 00 01

HandleBlockCollis:
            lda CalculatedCellY; $a9ec: ad 0c 01  .
            sta $012e          ; $a9ef: 8d 2e 01  |
            lda CalculatedCellX; $a9f2: ad 0d 01  |
            sta $012f          ; $a9f5: 8d 2f 01  | Put the cell coordinates into temporary variables
            lda BlockCollisSide; $a9f8: ad 07 01  .
            cmp #$00           ; $a9fb: c9 00     |
            bne Next_aa00      ; $a9fd: d0 01     |
            rts                ; $a9ff: 60        | return if there's no block collision

;-------------------------------------------------------------------------------
Next_aa00:  tya                ; $aa00: 98          .
            pha                ; $aa01: 48          | store y for later
            inc SpeedStageCounter ; $aa02: ee 02 01 . bump the speed stage counter
            ldx #$ff           ; $aa05: a2 ff              .
            lda SpeedStageCounter ; $aa07: ad 02 01        |
Loop_aa0a:  inx                ; $aa0a: e8                 |
            cmp __SpeedStageThresholds,x ; $aa0b: dd 8f 99 |
            beq Next_aa13      ; $aa0e: f0 03              | if we're exactly at a speed stage threshold, go set the new speed stage
            bcs Loop_aa0a      ; $aa10: b0 f8              . else move on
            dex                ; $aa12: ca                 . loop
Next_aa13:  cpx #$00           ; $aa13: e0 00         .
            beq InspectCollisionType ; $aa15: f0 0d   | if the new speed stage is > 0,
            stx SpeedStageM    ; $aa17: 8e 01 01        . set the new speed stage (to the mirror)
            lda SpeedStage     ; $aa1a: ad 00 01        .
            cmp #$0f           ; $aa1d: c9 0f           |
            beq InspectCollisionType ; $aa1f: f0 03     | if the speed stage is <= 0xf,
            stx SpeedStage     ; $aa21: 8e 00 01          . set the new speed stage (for real)
InspectCollisionType:
            lda BlockCollisSide; $aa24: ad 07 01  .
            cmp #$08           ; $aa27: c9 08     |
            bne Next_aa30      ; $aa29: d0 05     |
            ldy #$00           ; $aa2b: a0 00     |
            jmp Next_aa54      ; $aa2d: 4c 54 aa  | if it's an "8" block collision, load y = 0

;-------------------------------------------------------------------------------
Next_aa30:  cmp #$04           ; $aa30: c9 04     .
            bne Next_aa3c      ; $aa32: d0 08     |
            ldy #$01           ; $aa34: a0 01     | if it's a "4" block collision, load y = 1
            inc $012f          ; $aa36: ee 2f 01  | and bump the active cell x right by 1
            jmp Next_aa54      ; $aa39: 4c 54 aa  | 

;-------------------------------------------------------------------------------
Next_aa3c:  cmp #$02           ; $aa3c: c9 02     .
            bne Next_aa48      ; $aa3e: d0 08     |
            ldy #$0b           ; $aa40: a0 0b     | if it's a "2" block collision, load y = 0xb
            inc $012e          ; $aa42: ee 2e 01  | and bump the active cell y down by 1
            jmp Next_aa54      ; $aa45: 4c 54 aa  | 

;-------------------------------------------------------------------------------
Next_aa48:  cmp #$01           ; $aa48: c9 01     .
            bne InspectCollisionType; $aa4a: d0 d8|
            ldy #$0c           ; $aa4c: a0 0c     | if it's a "1" block collision, load y = 0xc
            inc $012e          ; $aa4e: ee 2e 01  | and bump the active cell x / y right and down by 1
            inc $012f          ; $aa51: ee 2f 01  |
Next_aa54:  lda #$f0           ; $aa54: a9 f0     .
            sta $0133          ; $aa56: 8d 33 01  | initialize the temporary register with 0xf0 (no block broken)
            lda ($41),y        ; $aa59: b1 41     . Load the block val at the collision index
            cmp #$f0           ; $aa5b: c9 f0     .
            beq Next_aa73      ; $aa5d: f0 14     | if it's not a golden block (unbreakable),
            lda ($41),y        ; $aa5f: b1 41       .
            sec                ; $aa61: 38          |
            sbc #$01           ; $aa62: e9 01       |
            sta ($41),y        ; $aa64: 91 41       | subtract a hit point from the block
            and #$07           ; $aa66: 29 07       .
            bne Next_aa73      ; $aa68: d0 09       | if it's down to 0 hit points,
            lda ($41),y        ; $aa6a: b1 41         .
            sta $0133          ; $aa6c: 8d 33 01      | store it in the temporary register
            lda #$00           ; $aa6f: a9 00         .
            sta ($41),y        ; $aa71: 91 41         | remove the block
Next_aa73:  lda $06b0          ; $aa73: ad b0 06  .
            sta $0131          ; $aa76: 8d 31 01  |
            lda #$00           ; $aa79: a9 00     
            sta $0132          ; $aa7b: 8d 32 01  
            lda #$20           ; $aa7e: a9 20     
            sta $86            ; $aa80: 85 86     
            lda #$42           ; $aa82: a9 42     
            sta $87            ; $aa84: 85 87     
            ldx $012e          ; $aa86: ae 2e 01  
Loop_aa89:  cpx #$00           ; $aa89: e0 00     
            beq Next_aaa9      ; $aa8b: f0 1c     
            clc                ; $aa8d: 18        
            lda $0132          ; $aa8e: ad 32 01  
            adc #$10           ; $aa91: 69 10     
            and #$30           ; $aa93: 29 30     
            sta $0132          ; $aa95: 8d 32 01  
            clc                ; $aa98: 18        
            lda $87            ; $aa99: a5 87     
            adc #$20           ; $aa9b: 69 20     
            sta $87            ; $aa9d: 85 87     
            lda $86            ; $aa9f: a5 86     
            adc #$00           ; $aaa1: 69 00     
            sta $86            ; $aaa3: 85 86     
            dex                ; $aaa5: ca        
            jmp Loop_aa89      ; $aaa6: 4c 89 aa  

;-------------------------------------------------------------------------------
Next_aaa9:  lda $012f          ; $aaa9: ad 2f 01  
            asl                ; $aaac: 0a        
            clc                ; $aaad: 18        
            adc $87            ; $aaae: 65 87     
            sta $87            ; $aab0: 85 87     
            lda $86            ; $aab2: a5 86     
            adc #$00           ; $aab4: 69 00     
            sta $86            ; $aab6: 85 86     
            lda $012f          ; $aab8: ad 2f 01  
            and #$01           ; $aabb: 29 01     
            asl                ; $aabd: 0a        
            clc                ; $aabe: 18        
            adc $0132          ; $aabf: 6d 32 01  
            adc $0131          ; $aac2: 6d 31 01  
            sta $0131          ; $aac5: 8d 31 01  
            lda BlockCollisFlag; $aac8: ad 45 01  
            asl                ; $aacb: 0a        
            clc                ; $aacc: 18        
            adc BlockCollisFlag; $aacd: 6d 45 01  
            tax                ; $aad0: aa        
            lda $86            ; $aad1: a5 86     
            sta $0698,x        ; $aad3: 9d 98 06  
            lda $87            ; $aad6: a5 87     
            sta $0699,x        ; $aad8: 9d 99 06  
            lda $0131          ; $aadb: ad 31 01  .
            sta $069a,x        ; $aade: 9d 9a 06  | set the destroyed-block val to the hit-block val
            lda $0133          ; $aae1: ad 33 01  .
            cmp #$f0           ; $aae4: c9 f0     |
            bne Next_aaed      ; $aae6: d0 05     | if the hit-block val == 0xf0,
            lda #$00           ; $aae8: a9 00       .
            sta $069a,x        ; $aaea: 9d 9a 06    | clear the destroyed-block val
Next_aaed:  lda BlockCollisFlag; $aaed: ad 45 01  
            asl                ; $aaf0: 0a        
            clc                ; $aaf1: 18        
            adc BlockCollisFlag; $aaf2: 6d 45 01  
            tax                ; $aaf5: aa        .
            lda $012e          ; $aaf6: ad 2e 01  |
            sta $0680,x        ; $aaf9: 9d 80 06  | set last-hit-block-y-index = current ball cell y
            inx                ; $aafc: e8        .
            lda $012f          ; $aafd: ad 2f 01  |
            sta $0680,x        ; $ab00: 9d 80 06  | set last-hit-block-x-index = current ball cell x
            inx                ; $ab03: e8        .
            lda $0133          ; $ab04: ad 33 01  |
            sta $0680,x        ; $ab07: 9d 80 06  | set last-hit-block-type = current block type
            inc BlockCollisFlag; $ab0a: ee 45 01  . Bump block collision flag
            pla                ; $ab0d: 68        
            tay                ; $ab0e: a8        
            rts                ; $ab0f: 60        

;-------------------------------------------------------------------------------
CheckBallLost:
            lda Ball_1_Y       ; $ab10: a5 37     .
            cmp #$f0           ; $ab12: c9 f0     |
            bcc Ret_ab35       ; $ab14: 90 1f     | If ball y >= 0xf0
            lda ActiveBallItr  ; $ab16: a5 83       .
            cmp #$03           ; $ab18: c9 03       |
            bne Next_ab1e      ; $ab1a: d0 02       |
            ldx #$01           ; $ab1c: a2 01       | if updating ball 1, load x = 1
Next_ab1e:  cmp #$02           ; $ab1e: c9 02       .
            bne Next_ab24      ; $ab20: d0 02       |
            ldx #$02           ; $ab22: a2 02       | if updating ball 2, load x = 2
Next_ab24:  cmp #$01           ; $ab24: c9 01       .
            bne Next_ab2a      ; $ab26: d0 02       |
            ldx #$04           ; $ab28: a2 04       | if updating ball 3, load x = 4
Next_ab2a:  txa                ; $ab2a: 8a          .
            eor #$ff           ; $ab2b: 49 ff       |
            and ActiveBalls    ; $ab2d: 25 81       |
            sta ActiveBalls    ; $ab2f: 85 81       | remove ball [x] from the active set
            lda #$00           ; $ab31: a9 00       .
            sta BallCycle      ; $ab33: 85 45       | reset the ball cycle
Ret_ab35:   rts                ; $ab35: 60        . return

;-------------------------------------------------------------------------------
; precondition: y contains CalculatedCellY, x contains CalculatedCellX
CheckBlockProximity:
            tya                ; $ab36: 98        .
            pha                ; $ab37: 48        | push y onto the stack
            lda BlockRamAddrLo ; $ab38: a5 84     .
            sta $41            ; $ab3a: 85 41     |
            lda BlockRamAddrHi ; $ab3c: a5 85     |
            sta $42            ; $ab3e: 85 42     | copy block memory addr to $41 / $42
Loop_ab40:  cpy #$00           ; $ab40: c0 00     .
            beq Next_ab56      ; $ab42: f0 12     |
            clc                ; $ab44: 18        |
            lda $41            ; $ab45: a5 41     |
            adc BlocksPerRow   ; $ab47: 6d 0b 01  |
            sta $41            ; $ab4a: 85 41     |
            lda $42            ; $ab4c: a5 42     |
            adc #$00           ; $ab4e: 69 00     |
            sta $42            ; $ab50: 85 42     |
            dey                ; $ab52: 88        |
            jmp Loop_ab40      ; $ab53: 4c 40 ab  | advance pointer to the correct block row
Next_ab56:  clc                ; $ab56: 18        .
            txa                ; $ab57: 8a        |
            adc $41            ; $ab58: 65 41     |
            sta $41            ; $ab5a: 85 41     | advance pointer to the correct block column
            lda #$00           ; $ab5c: a9 00     .
            adc $42            ; $ab5e: 65 42     |
            sta $42            ; $ab60: 85 42     | no-op
            lda #$00           ; $ab62: a9 00     .
            sta BlockProximity ; $ab64: 8d 06 01  | reset block proximity data
            ldy #$00           ; $ab67: a0 00     .
            lda ($41),y        ; $ab69: b1 41     | Load the block addressed by the pointer
            cmp #$00           ; $ab6b: c9 00     .
            beq Next_ab77      ; $ab6d: f0 08     | if the block exists,
            lda BlockProximity ; $ab6f: ad 06 01    .
            ora #$08           ; $ab72: 09 08       |
            sta BlockProximity ; $ab74: 8d 06 01    | set proximity bit 4
Next_ab77:  ldy #$01           ; $ab77: a0 01     .
            lda ($41),y        ; $ab79: b1 41     | Load the block immediately to the right
            cmp #$00           ; $ab7b: c9 00     .
            beq Next_ab87      ; $ab7d: f0 08     | if the block exists,
            lda BlockProximity ; $ab7f: ad 06 01    .
            ora #$04           ; $ab82: 09 04       |
            sta BlockProximity ; $ab84: 8d 06 01    | set proximity bit 3
Next_ab87:  ldy #$0b           ; $ab87: a0 0b     .
            lda ($41),y        ; $ab89: b1 41     | Load the block immediately below
            cmp #$00           ; $ab8b: c9 00     .
            beq Next_ab97      ; $ab8d: f0 08     | if the block exists,
            lda BlockProximity ; $ab8f: ad 06 01    .
            ora #$02           ; $ab92: 09 02       |
            sta BlockProximity ; $ab94: 8d 06 01    | set proximity bit 2
Next_ab97:  ldy #$0c           ; $ab97: a0 0c     .
            lda ($41),y        ; $ab99: b1 41     | Load the block one down and to the right
            cmp #$00           ; $ab9b: c9 00     .
            beq Next_aba7      ; $ab9d: f0 08     | if the block exists,
            lda BlockProximity ; $ab9f: ad 06 01     .
            ora #$01           ; $aba2: 09 01        |
            sta BlockProximity ; $aba4: 8d 06 01     | set proximity bit 1
Next_aba7:  pla                ; $aba7: 68        .
            tay                ; $aba8: a8        | pop the stack into y (restore y = CalculatedCellY)
            rts                ; $aba9: 60        . return

;-------------------------------------------------------------------------------
CheckEnemyCollis:
            ldx #$00           ; $abaa: a2 00      . x = 0
            lda BallCollisType ; $abac: a5 34      .
            beq Loop_abb1      ; $abae: f0 01      | If no collisions already, enter loop
            rts                ; $abb0: 60         . Return

;-------------------------------------------------------------------------------
Loop_abb1:  lda EnemyActive,x  ; $abb1: b5 95     .
            beq Next_abf3      ; $abb3: f0 3e     | if this enemy is active,
            lda EnemyExiting,x ; $abb5: b5 9b     .
            bne Next_abf3      ; $abb7: d0 3a     | and the enemy isn't exiting,
            lda EnemyY,x       ; $abb9: b5 ae     .
            cmp #$e0           ; $abbb: c9 e0     |
            bcs Next_abf3      ; $abbd: b0 34     | and enemy y < 0xe0 (i.e. on the field)
            lda Ball_1_X       ; $abbf: a5 38     .
            cmp EnemyX,x       ; $abc1: d5 b7     |
            bcc Next_abf3      ; $abc3: 90 2e     | and ball x >= enemy x
            clc                ; $abc5: 18        .
            lda EnemyX,x       ; $abc6: b5 b7     |
            adc #$0c           ; $abc8: 69 0c     |
            cmp Ball_1_X       ; $abca: c5 38     |
            bcc Next_abf3      ; $abcc: 90 25     | and enemy x + 0xc >= ball x
            lda Ball_1_Y       ; $abce: a5 37     .
            cmp EnemyY,x       ; $abd0: d5 ae     |
            bcc Next_abf3      ; $abd2: 90 1f     | and ball y >= enemy y
            clc                ; $abd4: 18        .
            lda EnemyY,x       ; $abd5: b5 ae     |
            adc #$0c           ; $abd7: 69 0c     |
            cmp Ball_1_Y       ; $abd9: c5 37     |
            bcc Next_abf3      ; $abdb: 90 16     | and enemy y + 0xc >= ball y
            lda #$5f           ; $abdd: a9 5f       .
            sta $88            ; $abdf: 85 88       |
            lda #$8e           ; $abe1: a9 8e       |
            sta $89            ; $abe3: 85 89       | grab the score value from $8e5f
            jsr AddPendingScore; $abe5: 20 56 90    . add the score to the pending total
            lda #$00           ; $abe8: a9 00       .
            sta EnemyActive,x  ; $abea: 95 95       | mark enemy as inactive
            lda #$01           ; $abec: a9 01       .
            sta EnemyDestrFrame,x ; $abee: 95 98    | set destruction frame = 1
            jsr __abf9         ; $abf0: 20 f9 ab  
Next_abf3:  inx                ; $abf3: e8        .
            cpx #$03           ; $abf4: e0 03     |
            bne Loop_abb1      ; $abf6: d0 b9     | for x = 0..2 
            rts                ; $abf8: 60        . return

;-------------------------------------------------------------------------------
__abf9:     lda BallVelSign    ; $abf9: a5 33     .
            cmp #$00           ; $abfb: c9 00     |
            bne __ac12         ; $abfd: d0 13     | if vx = positive and vy = negative,
            clc                ; $abff: 18        .
            lda EnemyY,x       ; $ac00: b5 ae     |
            adc #$08           ; $ac02: 69 08     |
            cmp Ball_1_Y       ; $ac04: c5 37     |
            bcc __ac0d         ; $ac06: 90 05     | if enemy y + 8 < ball y, go set y-collis flag
            lda #$02           ; $ac08: a9 02      .
            sta BallCollisType ; $ac0a: 85 34      | else set x-collision flag
            rts                ; $ac0c: 60        . return

;-------------------------------------------------------------------------------
__ac0d:     lda #$01           ; $ac0d: a9 01      .
            sta BallCollisType ; $ac0f: 85 34      |   
            rts                ; $ac11: 60         | Set y-collision flag

;-------------------------------------------------------------------------------
__ac12:     lda BallVelSign    ; $ac12: a5 33     .
            cmp #$02           ; $ac14: c9 02     |
            bne __ac2b         ; $ac16: d0 13     | if vx = negative and vy = negative,
            clc                ; $ac18: 18        .
            lda EnemyY,x       ; $ac19: b5 ae     |
            adc #$08           ; $ac1b: 69 08     |
            cmp Ball_1_Y       ; $ac1d: c5 37     |
            bcc __ac26         ; $ac1f: 90 05     | if enemy y + 8 < ball y, go set y-collis flag
            lda #$02           ; $ac21: a9 02      .
            sta BallCollisType ; $ac23: 85 34      |
            rts                ; $ac25: 60         | else set x-collision flag

;-------------------------------------------------------------------------------
__ac26:     lda #$01           ; $ac26: a9 01      .
            sta BallCollisType ; $ac28: 85 34      |   
            rts                ; $ac2a: 60         | Set y-collision flag

;-------------------------------------------------------------------------------
__ac2b:     lda BallVelSign    ; $ac2b: a5 33     .
            cmp #$01           ; $ac2d: c9 01     |
            bne __ac44         ; $ac2f: d0 13     | if vx = positive and vy = positive,
            clc                ; $ac31: 18        .
            lda EnemyY,x       ; $ac32: b5 ae     |
            adc #$08           ; $ac34: 69 08     |
            cmp Ball_1_Y       ; $ac36: c5 37     |
            bcc __ac3f         ; $ac38: 90 05     | if enemy y + 8 < ball y, go set x-collis flag
            lda #$01           ; $ac3a: a9 01      .
            sta BallCollisType ; $ac3c: 85 34      |
            rts                ; $ac3e: 60         | else set y-collision flag

;-------------------------------------------------------------------------------
__ac3f:     lda #$02           ; $ac3f: a9 02      .
            sta BallCollisType ; $ac41: 85 34      |   
            rts                ; $ac43: 60         | Set x-collision flag

;-------------------------------------------------------------------------------
__ac44:     lda BallVelSign    ; $ac44: a5 33     .
            cmp #$03           ; $ac46: c9 03     |
            bne Ret_ac5c       ; $ac48: d0 12     | if vx = negative and vy = positive,
            clc                ; $ac4a: 18        .
            lda EnemyY,x       ; $ac4b: b5 ae     |
            adc #$08           ; $ac4d: 69 08     |
            cmp Ball_1_Y       ; $ac4f: c5 37     |
            bcc Next_ac58      ; $ac51: 90 05     | if enemy y + 8 < ball y, go set x-collis flag
            lda #$01           ; $ac53: a9 01      .
            sta BallCollisType ; $ac55: 85 34      |   
            rts                ; $ac57: 60         | Set y-collision flag

;-------------------------------------------------------------------------------
Next_ac58:  lda #$02           ; $ac58: a9 02      .
            sta BallCollisType ; $ac5a: 85 34      |   
Ret_ac5c:   rts                ; $ac5c: 60         | Set x-collision flag

;-------------------------------------------------------------------------------

; Speed table format:
;
;                 cycle length
;                 |
;                 |  speed multiplier
;                 |  |
;                 |  |  number of delay frames
;                 |  |  |
;                 |  |  |     vy (repeating)
;                 |  |  |     |     |     |
;                 |  |  |     |     v     v ...
;                 |  |  |     |  vx (repeating)
;                 |  |  |     |  |     |     | ...
;                 v  v  v     v  v     v     v
;           .hex 04 01 00 00 02 01 02 01 03 01 03 02 00 00 00 00

__SteepSpeedTable:
___ac5d:    .hex 01 01 05 00 02 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 04 00 02 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 03 00 02 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 02 00 02 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 01 00 02 01 00 00 00 00 00 00 00 00 00 00
            .hex 02 01 00 00 02 01 01 00 00 00 00 00 00 00 00 00
            .hex 01 01 00 00 02 01 00 00 00 00 00 00 00 00 00 00
            .hex 04 01 00 00 02 01 02 01 03 01 03 02 00 00 00 00
            .hex 02 01 00 00 03 01 03 02 00 00 00 00 00 00 00 00
            .hex 01 02 00 00 02 01 02 01 00 00 00 00 00 00 00 00
            .hex 02 02 00 00 02 01 02 01 02 01 03 01 00 00 00 00
            .hex 02 02 00 00 02 01 02 01 03 01 03 02 00 00 00 00
            .hex 02 02 00 00 03 01 03 02 02 01 03 02 00 00 00 00
            .hex 01 03 00 00 02 01 02 01 02 01 00 00 00 00 00 00
            .hex 02 03 00 00 02 01 03 01 03 02 02 01 02 01 02 01
            .hex 02 03 00 00 02 01 03 01 03 02 02 01 02 01 02 01

__NormalSpeedTable:
___ad5d:    .hex 01 01 05 00 01 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 04 00 01 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 03 00 01 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 02 00 01 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 01 00 01 01 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 00 00 01 01 00 00 00 00 00 00 00 00 00 00
            .hex 02 01 00 00 01 01 02 02 00 00 00 00 00 00 00 00
            .hex 01 01 00 00 02 02 00 00 00 00 00 00 00 00 00 00
            .hex 02 01 00 00 02 02 03 03 00 00 00 00 00 00 00 00
            .hex 01 01 00 00 03 03 00 00 00 00 00 00 00 00 00 00
            .hex 02 02 00 00 03 03 00 00 02 02 02 02 00 00 00 00
            .hex 01 02 00 00 02 02 02 02 00 00 00 00 00 00 00 00
            .hex 02 02 00 00 02 02 02 02 02 02 03 03 00 00 00 00
            .hex 01 02 00 00 02 02 03 03 00 00 00 00 00 00 00 00
            .hex 02 02 00 00 02 02 03 03 03 03 03 03 00 00 00 00
            .hex 02 02 00 00 02 02 03 03 03 03 03 03 00 00 00 00

__ShallowSpeedTable:
___ae5d:    .hex 01 01 05 00 01 02 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 04 00 01 02 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 03 00 01 02 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 02 00 01 02 00 00 00 00 00 00 00 00 00 00
            .hex 01 01 01 00 01 02 00 00 00 00 00 00 00 00 00 00
            .hex 02 01 00 00 01 02 00 01 00 00 00 00 00 00 00 00
            .hex 01 01 00 00 01 02 00 00 00 00 00 00 00 00 00 00
            .hex 04 01 00 00 01 02 01 02 01 03 02 03 00 00 00 00
            .hex 02 01 00 00 01 03 02 03 00 00 00 00 00 00 00 00
            .hex 01 02 00 00 01 02 01 02 00 00 00 00 00 00 00 00
            .hex 02 02 00 00 01 02 01 02 01 02 01 03 00 00 00 00
            .hex 02 02 00 00 01 02 01 02 01 03 02 03 00 00 00 00
            .hex 02 02 00 00 01 03 02 03 01 02 02 03 00 00 00 00
            .hex 01 03 00 00 01 02 01 02 01 02 00 00 00 00 00 00
            .hex 02 03 00 00 01 02 01 03 02 03 01 02 01 02 01 02
            .hex 02 03 00 00 01 02 01 03 02 03 01 02 01 02 01 02
            .hex 01 04 00 00 02 01 02 01 02 01 02 01 00 00 00 00
            .hex 01 02 00 00 03 03 03 03 00 00 00 00 00 00 00 00
            .hex 01 04 00 00 01 02 01 02 01 02 01 02 00 00 00 00

CheckBlockBossCollis:
            lda #$00           ; $af8d: a9 00     .
            sta BlockCollisSide; $af8f: 8d 07 01  | Reset block-collision info
            sta BallCellOverlap; $af92: 8d 08 01  . Reset ball cell overlap flags
            lda Ball_1_Vel_Y   ; $af95: a5 35     .
            ora Ball_1_Vel_X   ; $af97: 05 36     |
            bne Next_af9c      ; $af99: d0 01     |
            rts                ; $af9b: 60        | if there's no ball velocity set, return

;-------------------------------------------------------------------------------
Next_af9c:  lda CurrentLevel   ; $af9c: a5 1a     .
            cmp #$24           ; $af9e: c9 24     |
            bcc CheckBlockCollis ; $afa0: 90 65   | if this isn't the boss level, go check for block collisions
            clc                ; $afa2: 18        .
            lda Ball_1_Y       ; $afa3: a5 37     |
            adc #$03           ; $afa5: 69 03     |
            cmp #$28           ; $afa7: c9 28     |
            bcs CheckBossCollis; $afa9: b0 01     |
            rts                ; $afab: 60        | if ball y + 3 < 0x28, return

;-------------------------------------------------------------------------------
CheckBossCollis:
            lda Ball_1_Y       ; $afac: a5 37     .
            cmp #$88           ; $afae: c9 88     |
            bcc Next_afb3      ; $afb0: 90 01     |
            rts                ; $afb2: 60        | if ball y >= 0x88, return

;-------------------------------------------------------------------------------
Next_afb3:  clc                ; $afb3: 18        .
            lda Ball_1_X       ; $afb4: a5 38     |
            adc #$03           ; $afb6: 69 03     |
            cmp #$50           ; $afb8: c9 50     |
            bcs Next_afbd      ; $afba: b0 01     |
            rts                ; $afbc: 60        | if ball x + 3 < 0x50, return

;-------------------------------------------------------------------------------
Next_afbd:  lda Ball_1_X       ; $afbd: a5 38     .
            cmp #$80           ; $afbf: c9 80     |
            bcc Next_afc4      ; $afc1: 90 01     |
            rts                ; $afc3: 60        | if ball x >= 0x80, return

;-------------------------------------------------------------------------------
Next_afc4:  inc BossHealth     ; $afc4: ee 66 01  . decrease boss health by one
            lda BallVelSign    ; $afc7: a5 33     .
            and #$01           ; $afc9: 29 01     |
            bne Next_afd9      ; $afcb: d0 0c     | if ball vy is negative
            clc                ; $afcd: 18           .
            lda Ball_1_Y       ; $afce: a5 37        |
            adc #$04           ; $afd0: 69 04        | 
            cmp #$88           ; $afd2: c9 88        |
            bcs __afdf         ; $afd4: b0 09        | if ball y + 4 >= 0x88, go set y-collision flag below
            jmp __aff3         ; $afd6: 4c f3 af     | else skip to x-collis check

;-------------------------------------------------------------------------------
Next_afd9:  lda Ball_1_Y       ; $afd9: a5 37     .
            cmp #$28           ; $afdb: c9 28     |
            bcs __aff3         ; $afdd: b0 14     | if ball y < 0x28
__afdf:     lda #$01           ; $afdf: a9 01        .
            sta BallCollisType ; $afe1: 85 34        | Set y-collision flag
            lda Ball_1_Y       ; $afe3: a5 37        .
            cmp #$50           ; $afe5: c9 50        |
            bcs __afee         ; $afe7: b0 05        | if ball y < 0x50
            lda #$24           ; $afe9: a9 24           .
            sta Ball_1_Y       ; $afeb: 85 37           | 
            rts                ; $afed: 60              |  ball y = 0x24   -> clamp y-pos to 0x24

;-------------------------------------------------------------------------------
__afee:     lda #$88           ; $afee: a9 88     .
            sta Ball_1_Y       ; $aff0: 85 37     |
            rts                ; $aff2: 60        | ball y = 0x88    -> clamp y-pos to 0x88

;-------------------------------------------------------------------------------
__aff3:     lda #$02           ; $aff3: a9 02     .
            sta BallCollisType ; $aff5: 85 34     | Set x-collision flag   
            lda Ball_1_X       ; $aff7: a5 38     .
            cmp #$60           ; $aff9: c9 60     |
            bcs __b002         ; $affb: b0 05     | if ball x < 60
            lda #$4c           ; $affd: a9 4c     .
__afff:     sta Ball_1_X       ; $afff: 85 38     |
            rts                ; $b001: 60        |  ball x = 0x4c   -> clamp x-pos to 0x4c

;-------------------------------------------------------------------------------
__b002:     lda #$80           ; $b002: a9 80     .
            sta Ball_1_X       ; $b004: 85 38     |
            rts                ; $b006: 60        | ball x = 0x80   -> clamp x-pos to 0x80

;-------------------------------------------------------------------------------
CheckBlockCollis:
            lda CalculatedCellY; $b007: ad 0c 01  .
            sta BallCellY      ; $b00a: 85 3d     |
            lda CalculatedCellX; $b00c: ad 0d 01  |
            sta BallCellX      ; $b00f: 85 3e     | Copy calculated cell values to ball struct
            lda BallYLoBits    ; $b011: a5 3a     .
            sta BallYLoBitsM   ; $b013: 85 3f     |
            lda BallXLoBits    ; $b015: a5 3c     |
            sta BallXLoBitsM   ; $b017: 85 40     | Copy position low-bit values
            lda BallCollisType ; $b019: a5 34     .
            cmp #$03           ; $b01b: c9 03     |
            bne Next_b020      ; $b01d: d0 01     |
            rts                ; $b01f: 60        . if both an x-collision and y-collision are already active, return

;-------------------------------------------------------------------------------
Next_b020:  clc                ; $b020: 18        .
            lda BallYHiBits    ; $b021: a5 39     |
            adc #$01           ; $b023: 69 01     |
            cmp BlocksPerColumn; $b025: cd 0a 01  |
            bcc Next_b02b      ; $b028: 90 01     |
            rts                ; $b02a: 60        | if the ball y is below the lowest possible block, return

;-------------------------------------------------------------------------------
Next_b02b:  lda BallVelSign    ; $b02b: a5 33     .
            cmp #$02           ; $b02d: c9 02     |
            beq Next_b034      ; $b02f: f0 03     | if vy and vx are both negative, jump to Next_b034
            jmp Next_b254      ; $b031: 4c 54 b2  . else move on to the next check
            
;-------------------------------------------------------------------------------
; == vx negative, vy negative ==
Next_b034:  ldy BallYHiBits    ; $b034: a4 39     . load y = high bits of ball y-pos
            ldx BallXHiBits    ; $b036: a6 3b     . load x = high bits of ball x-pos
            lda BallCollisType ; $b038: a5 34     .
            and #$01           ; $b03a: 29 01     |
            bne Next_b055      ; $b03c: d0 17     | if there's no y-collision active,
            lda BallYLoBits    ; $b03e: a5 3a       .
            cmp #$00           ; $b040: c9 00       |
            bne Next_b04a      ; $b042: d0 06       | if ball y-pos low bits == 0,
            dey                ; $b044: 88            . decrement y (high bits)
            lda #$01           ; $b045: a9 01         .
            sta BallCellOverlap; $b047: 8d 08 01      | set cell y-overlap flag
Next_b04a:  lda BallYLoBits    ; $b04a: a5 3a       .
            cmp #$05           ; $b04c: c9 05       |
            bcc Next_b055      ; $b04e: 90 05       | if ball y-pos low bits >= 5,
            lda #$01           ; $b050: a9 01         .
            sta BallCellOverlap; $b052: 8d 08 01      | set cell y-overlap flag
Next_b055:  lda BallCollisType ; $b055: a5 34     .
            and #$02           ; $b057: 29 02     |
            bne Next_b078      ; $b059: d0 1d     | if there's no x-collision active,
            lda BallXLoBits    ; $b05b: a5 3c       .
            cmp #$00           ; $b05d: c9 00       |
            bne Next_b06a      ; $b05f: d0 09       | if ball x-pos low bits == 0,
            dex                ; $b061: ca            . decrement x (high bits)
            lda BallCellOverlap; $b062: ad 08 01      .
            ora #$02           ; $b065: 09 02         |
            sta BallCellOverlap; $b067: 8d 08 01      | set cell x-overlap flag
Next_b06a:  lda BallXLoBits    ; $b06a: a5 3c       .
            cmp #$0d           ; $b06c: c9 0d       |
            bcc Next_b078      ; $b06e: 90 08       | if ball x-pos low bits >= 0xd,
            lda BallCellOverlap; $b070: ad 08 01      .
            ora #$02           ; $b073: 09 02         |
            sta BallCellOverlap; $b075: 8d 08 01      | set cell x-overlap flag
Next_b078:  sty CalculatedCellY; $b078: 8c 0c 01   .
            stx CalculatedCellX; $b07b: 8e 0d 01   | store the fixed-up position high bits as cell values
            jsr CheckBlockProximity;$b07e:20 36 ab . go update block proximity data
            lda BallCellOverlap; $b081: ad 08 01   .
            cmp #$01           ; $b084: c9 01      |
            bne Next_b0ac      ; $b086: d0 24      | if the ball overlaps the cell above (and only the cell above),
            lda BlockProximity ; $b088: ad 06 01     .
            and #$08           ; $b08b: 29 08        |
            beq Ret_b0a9       ; $b08d: f0 1a        | if proximity bit 4 is set (there's a block in this cell),
            lda BallYLoBits    ; $b08f: a5 3a          .
            cmp #$00           ; $b091: c9 00          |
            beq Next_b09b      ; $b093: f0 06          | if the ball y low bits aren't 0 (it's not flat against a cell),
            lda #$00           ; $b095: a9 00            .
            sta BallYLoBits    ; $b097: 85 3a            |
            inc BallYHiBits    ; $b099: e6 39            | bump the position down so it's flat against the block
Next_b09b:  lda BallCollisType ; $b09b: a5 34          .
            ora #$01           ; $b09d: 09 01          |
            sta BallCollisType ; $b09f: 85 34          | set y-collision flag
            lda BlockProximity ; $b0a1: ad 06 01       .
            and #$08           ; $b0a4: 29 08          |
            sta BlockCollisSide; $b0a6: 8d 07 01       | add "collision with this block" to block-collision set
Ret_b0a9:   jmp Ret_b24f       ; $b0a9: 4c 4f b2       . return

;-------------------------------------------------------------------------------
Next_b0ac:  lda BallCellOverlap; $b0ac: ad 08 01  .
            cmp #$02           ; $b0af: c9 02     |
            bne Next_b0d7      ; $b0b1: d0 24     | if the ball overlaps the cell to the left (and only the cell to the left)
            lda BlockProximity ; $b0b3: ad 06 01    .
            and #$08           ; $b0b6: 29 08       |
            beq Ret_b0d4       ; $b0b8: f0 1a       | if proximity bit 4 is set (there's a block in this cell),
            lda BallXLoBits    ; $b0ba: a5 3c         .
            cmp #$00           ; $b0bc: c9 00         |
            beq Next_b0c6      ; $b0be: f0 06         | if the ball x low bits aren't 0 (it's not flat against a cell),
            lda #$00           ; $b0c0: a9 00           .
            sta BallXLoBits    ; $b0c2: 85 3c           |
            inc BallXHiBits    ; $b0c4: e6 3b           | bump the position to the right so it's flat against the block
Next_b0c6:  lda BallCollisType ; $b0c6: a5 34         .
            ora #$02           ; $b0c8: 09 02         |
            sta BallCollisType ; $b0ca: 85 34         | Set x-collision flag   
            lda BlockProximity ; $b0cc: ad 06 01      .
            and #$08           ; $b0cf: 29 08         |
            sta BlockCollisSide; $b0d1: 8d 07 01      | add "collision with this block" to block-collision set
Ret_b0d4:   jmp Ret_b24f       ; $b0d4: 4c 4f b2      . return

;-------------------------------------------------------------------------------
Next_b0d7:  lda BallCellOverlap; $b0d7: ad 08 01  .
            cmp #$03           ; $b0da: c9 03     |
            bne Ret_b0d4       ; $b0dc: d0 f6     | if the ball overlaps the cell to the left and above,
            lda BlockProximity ; $b0de: ad 06 01    .
            cmp #$08           ; $b0e1: c9 08       |
            beq Next_b0e8      ; $b0e3: f0 03       | if there's only a block here (and not above or to the right), go handle collision with it
            jmp Next_b16c      ; $b0e5: 4c 6c b1    . else go check if there's a block above (only) or left (only)

;-------------------------------------------------------------------------------
; handling collision with the block corner
Next_b0e8:  lda BallYLoBits    ; $b0e8: a5 3a     .
            cmp BallXLoBits    ; $b0ea: c5 3c     |
            bne __b0f4         ; $b0ec: d0 06     |
            lda Ball_1_Vel_Y   ; $b0ee: a5 35     |
            cmp Ball_1_Vel_X   ; $b0f0: c5 36     |
            beq CornerBounce_b142; $b0f2: f0 4e   | if the position bits are equal, and the x/y velocities are equal, do a corner bounce
__b0f4:     lda BallYLoBits    ; $b0f4: a5 3a     .
            cmp #$00           ; $b0f6: c9 00     |
            beq VertBounce_b118; $b0f8: f0 1e     | if the ball y low bits == 0, do a vertical bounce
            lda BallXLoBits    ; $b0fa: a5 3c     .
            cmp #$00           ; $b0fc: c9 00     |
            beq HorizBounce_b12d; $b0fe: f0 2d    | if the ball x low bits == 0, do a horizontal bounce
            lda BallYHiBits    ; $b100: a5 39     .
            cmp BallCellY      ; $b102: c5 3d     |
            beq HorizBounce_b12d; $b104: f0 27    | if the modified y high bits are the same as the ball cell, do a horizontal bounce
            lda #$3f           ; $b106: a9 3f     .
            cmp #$00           ; $b108: c9 00     |
            beq HorizBounce_b12d; $b10a: f0 21    | (no-op)
            lda BallXHiBits    ; $b10c: a5 3b     .
            cmp BallCellX      ; $b10e: c5 3e     |
            beq VertBounce_b118; $b110: f0 06     | if the modified x high bits are the same as before, do a vertical bounce
            lda #$40           ; $b112: a9 40     .
            cmp #$00           ; $b114: c9 00     |
            bne CornerBounce_b142; $b116: d0 2a   | else do a corner bounce
VertBounce_b118: lda BallYLoBits    ; $b118: a5 3a.
            cmp #$00           ; $b11a: c9 00     |
            beq __b124         ; $b11c: f0 06     | if the ball y low bits are > 0,
            lda #$00           ; $b11e: a9 00       .
            sta BallYLoBits    ; $b120: 85 3a       |
            inc BallYHiBits    ; $b122: e6 39       | snap the position to the bottom of the block
__b124:     lda BallCollisType ; $b124: a5 34     .
            ora #$01           ; $b126: 09 01     |
            sta BallCollisType ; $b128: 85 34     | Set y-collision flag
            jmp __b163         ; $b12a: 4c 63 b1  . go to final cleanup
            
;-------------------------------------------------------------------------------
HorizBounce_b12d:
            lda BallXLoBits    ; $b12d: a5 3c     .
            cmp #$00           ; $b12f: c9 00     |
            beq __b139         ; $b131: f0 06     | if the ball x low bits are set,
            lda #$00           ; $b133: a9 00       .
            sta BallXLoBits    ; $b135: 85 3c       |
            inc BallXHiBits    ; $b137: e6 3b       | snap them to the block edge
__b139:     lda BallCollisType ; $b139: a5 34     .
            ora #$02           ; $b13b: 09 02     |
            sta BallCollisType ; $b13d: 85 34     | Set x-collision flag
            jmp __b163         ; $b13f: 4c 63 b1  . go to final cleanup
            
;-------------------------------------------------------------------------------
CornerBounce_b142:
            lda BallYLoBits    ; $b142: a5 3a     .
            cmp #$00           ; $b144: c9 00     |
            beq __b14e         ; $b146: f0 06     | if the ball y low bits are set,
            lda #$00           ; $b148: a9 00       .
            sta BallYLoBits    ; $b14a: 85 3a       |
            inc BallYHiBits    ; $b14c: e6 39       | snap them to the block edge
__b14e:     lda BallXLoBits    ; $b14e: a5 3c     .
            cmp #$00           ; $b150: c9 00     |
            beq __b15a         ; $b152: f0 06     | if the ball x low bits are set,
            lda #$00           ; $b154: a9 00       .
            sta BallXLoBits    ; $b156: 85 3c       |
            inc BallXHiBits    ; $b158: e6 3b       | snap them to the block edge
__b15a:     lda BallCollisType ; $b15a: a5 34     .
            ora #$03           ; $b15c: 09 03     |
            sta BallCollisType ; $b15e: 85 34     | Set x- and y-collision flags
            jmp __b163         ; $b160: 4c 63 b1  . go to final cleanup

;-------------------------------------------------------------------------------
__b163:     lda BlockProximity ; $b163: ad 06 01  .
            sta BlockCollisSide; $b166: 8d 07 01  |
            jmp Ret_b24f       ; $b169: 4c 4f b2  | transfer proximity to collision side indicator

;-------------------------------------------------------------------------------
Next_b16c:  lda BlockProximity ; $b16c: ad 06 01  .
            cmp #$04           ; $b16f: c9 04     |
            bne __b18e         ; $b171: d0 1b     | if there's only a block to the right,
            lda BallYLoBits    ; $b173: a5 3a       .
            cmp #$00           ; $b175: c9 00       |
            beq __b17f         ; $b177: f0 06       | if the ball y low bits are set,
            lda #$00           ; $b179: a9 00         .
            sta BallYLoBits    ; $b17b: 85 3a         |
            inc BallYHiBits    ; $b17d: e6 39         | snap them to the block edge
__b17f:     lda BallCollisType ; $b17f: a5 34       .
            ora #$01           ; $b181: 09 01       |
            sta BallCollisType ; $b183: 85 34       | set y-collision flag
            lda BlockProximity ; $b185: ad 06 01    .
            sta BlockCollisSide; $b188: 8d 07 01    |
            jmp Ret_b24f       ; $b18b: 4c 4f b2    | transfer proximity to collision side indicator

;-------------------------------------------------------------------------------
__b18e:     lda BlockProximity ; $b18e: ad 06 01  .
            cmp #$02           ; $b191: c9 02     |
            bne __b1b0         ; $b193: d0 1b     | if there's only a block below,
            lda BallXLoBits    ; $b195: a5 3c       .
            cmp #$00           ; $b197: c9 00       |
            beq __b1a1         ; $b199: f0 06       | if the ball x low bits are set,
            lda #$00           ; $b19b: a9 00         .
            sta BallXLoBits    ; $b19d: 85 3c         |
            inc BallXHiBits    ; $b19f: e6 3b         | snap to the block edge
__b1a1:     lda BallCollisType ; $b1a1: a5 34       .
            ora #$02           ; $b1a3: 09 02       |
            sta BallCollisType ; $b1a5: 85 34       | set x-collision flag
            lda BlockProximity ; $b1a7: ad 06 01    .
            sta BlockCollisSide; $b1aa: 8d 07 01    |
            jmp Ret_b24f       ; $b1ad: 4c 4f b2    | transfer proximity to collision side indicator

;-------------------------------------------------------------------------------
__b1b0:     lda BlockProximity ; $b1b0: ad 06 01  .
            cmp #$0c           ; $b1b3: c9 0c     |
            bne __b1d9         ; $b1b5: d0 22     | if there's a block here and also to the right,
            lda BallYLoBits    ; $b1b7: a5 3a       .
            cmp #$00           ; $b1b9: c9 00       |
            beq __b1c3         ; $b1bb: f0 06       |
            lda #$00           ; $b1bd: a9 00       |
            sta BallYLoBits    ; $b1bf: 85 3a       |
            inc BallYHiBits    ; $b1c1: e6 39       | snap down
__b1c3:     ldx #$08           ; $b1c3: a2 08       .
            lda BallXLoBits    ; $b1c5: a5 3c       |
            cmp #$0f           ; $b1c7: c9 0f       |
            bne __b1cd         ; $b1c9: d0 02       |
            ldx #$04           ; $b1cb: a2 04       |
__b1cd:     stx BlockCollisSide; $b1cd: 8e 07 01    | set collision side = [one right] if ball x low bits == 0xf, else [this block]
            lda BallCollisType ; $b1d0: a5 34       .
            ora #$01           ; $b1d2: 09 01       |
            sta BallCollisType ; $b1d4: 85 34       | set y-collision flag
            jmp Ret_b24f       ; $b1d6: 4c 4f b2    . return

;-------------------------------------------------------------------------------
__b1d9:     lda BlockProximity ; $b1d9: ad 06 01  .
            cmp #$0a           ; $b1dc: c9 0a     |
            bne __b202         ; $b1de: d0 22     | if there's a block here and also below,
            lda BallXLoBits    ; $b1e0: a5 3c       .
            cmp #$00           ; $b1e2: c9 00       |
            beq __b1ec         ; $b1e4: f0 06       |
            lda #$00           ; $b1e6: a9 00       |
            sta BallXLoBits    ; $b1e8: 85 3c       |
            inc BallXHiBits    ; $b1ea: e6 3b       | snap right
__b1ec:     ldx #$08           ; $b1ec: a2 08       .
            lda BallYLoBits    ; $b1ee: a5 3a       |
            cmp #$07           ; $b1f0: c9 07       |
            bne __b1f6         ; $b1f2: d0 02       |
            ldx #$02           ; $b1f4: a2 02       |
__b1f6:     stx BlockCollisSide; $b1f6: 8e 07 01    | set collision side = [one down] if ball y low bits == 7, else [this block]
            lda BallCollisType ; $b1f9: a5 34       .
            ora #$02           ; $b1fb: 09 02       |
            sta BallCollisType ; $b1fd: 85 34       | set x-collision flag
            jmp Ret_b24f       ; $b1ff: 4c 4f b2    .return

;-------------------------------------------------------------------------------
__b202:     lda BlockProximity ; $b202: ad 06 01  .
            cmp #$00           ; $b205: c9 00     |
            beq Ret_b24f       ; $b207: f0 46     | if no blocks around at all, return
            cmp #$06           ; $b209: c9 06     .
            beq __b211         ; $b20b: f0 04     | if the blocks around are one-down and one-right,
            cmp #$0e           ; $b20d: c9 0e     .
            bne Ret_b24f       ; $b20f: d0 3e     | or they're this-block, one-down, and one-right,
__b211:     lda BallYLoBits    ; $b211: a5 3a       .
            cmp #$00           ; $b213: c9 00       |
            beq __b21d         ; $b215: f0 06       |
            lda #$00           ; $b217: a9 00       |
            sta BallYLoBits    ; $b219: 85 3a       |
            inc BallYHiBits    ; $b21b: e6 39       | snap down
__b21d:     lda BallXLoBits    ; $b21d: a5 3c       .
            cmp #$00           ; $b21f: c9 00       |
            beq __b229         ; $b221: f0 06       |
            lda #$00           ; $b223: a9 00       |
            sta BallXLoBits    ; $b225: 85 3c       |
            inc BallXHiBits    ; $b227: e6 3b       | snap right
__b229:     lda BallCollisType ; $b229: a5 34       .
            ora #$03           ; $b22b: 09 03       |
            sta BallCollisType ; $b22d: 85 34       | set x- and y-collision flags
            lda #$02           ; $b22f: a9 02       .
            sta BlockCollisSide; $b231: 8d 07 01    | set collision side = [one below]
            ldx #$00           ; $b234: a2 00       .
Loop_b236:  ldy __b250,x       ; $b236: bc 50 b2    |
            lda ($41),y        ; $b239: b1 41       |
            cmp #$00           ; $b23b: c9 00       |
            beq __b243         ; $b23d: f0 04       |
            cmp #$f0           ; $b23f: c9 f0       |
            bne __b249         ; $b241: d0 06       |
__b243:     inx                ; $b243: e8          |
            cpx #$02           ; $b244: e0 02       |
            bne Loop_b236      ; $b246: d0 ee       | if the one-right block exists and it's not gold, set collision side oneRight
            rts                ; $b248: 60          | else set collision side oneDown

;-------------------------------------------------------------------------------
__b249:     lda __b252,x       ; $b249: bd 52 b2  
            sta BlockCollisSide; $b24c: 8d 07 01  
Ret_b24f:   rts                ; $b24f: 60        . return

;-------------------------------------------------------------------------------
__b250:     .hex 01 0b
__b252:     .hex 04 02

; == vx positive, vy negative ==
Next_b254:  lda BallVelSign    ; $b254: a5 33     .
            cmp #$00           ; $b256: c9 00     |
            beq Next_b25d      ; $b258: f0 03     | if vy is negative and vx is positive, jump to Next_b25d
            jmp Next_b435      ; $b25a: 4c 35 b4  . else move to the next check

;-------------------------------------------------------------------------------
Next_b25d:  ldy BallYHiBits    ; $b25d: a4 39     .
            ldx BallXHiBits    ; $b25f: a6 3b     | load initial cell values
            lda BallCollisType ; $b261: a5 34     .
            and #$01           ; $b263: 29 01     |
            bne __b27e         ; $b265: d0 17     | if y-collision flag isn't set,
            lda BallYLoBits    ; $b267: a5 3a       .
            cmp #$00           ; $b269: c9 00       |
            bne __b273         ; $b26b: d0 06       | if ball y low bits are 0,
            dey                ; $b26d: 88            . decrement cell y-position
            lda #$01           ; $b26e: a9 01         .
            sta BallCellOverlap; $b270: 8d 08 01      | set y-overlap flag
__b273:     lda BallYLoBits    ; $b273: a5 3a       .
            cmp #$05           ; $b275: c9 05       |
            bcc __b27e         ; $b277: 90 05       | if ball y low bits are >= 5,
            lda #$01           ; $b279: a9 01         .
            sta BallCellOverlap; $b27b: 8d 08 01      | set y-overlap flag
__b27e:     lda BallCollisType ; $b27e: a5 34     .
            and #$02           ; $b280: 29 02     |
            bne __b292         ; $b282: d0 0e     | if x-collision flag isn't set
            lda BallXLoBits    ; $b284: a5 3c       .
            cmp #$0c           ; $b286: c9 0c       |
            bcc __b292         ; $b288: 90 08       | if ball x low bits are >= 0xc
            lda BallCellOverlap; $b28a: ad 08 01      .
            ora #$02           ; $b28d: 09 02         |
            sta BallCellOverlap; $b28f: 8d 08 01      | set x-overlap flag
__b292:     sty CalculatedCellY; $b292: 8c 0c 01  .
            stx CalculatedCellX; $b295: 8e 0d 01  |
            jsr CheckBlockProximity; $b298: 20 36 ab| go grab proximity info for the fixed-up cell position
            lda BallCellOverlap; $b29b: ad 08 01  .
            cmp #$01           ; $b29e: c9 01     |
            bne __b2c6         ; $b2a0: d0 24     | if there's only a vertical overlap,
            lda BlockProximity ; $b2a2: ad 06 01    .
            and #$08           ; $b2a5: 29 08       |
            beq Ret_b2c3       ; $b2a7: f0 1a       | if there's no block here, nothing to do, so return.
            lda BallYLoBits    ; $b2a9: a5 3a       .
            cmp #$00           ; $b2ab: c9 00       |
            beq Next_b2b5      ; $b2ad: f0 06       |
            inc BallYHiBits    ; $b2af: e6 39       |
            lda #$00           ; $b2b1: a9 00       |
            sta BallYLoBits    ; $b2b3: 85 3a       | snap down
Next_b2b5:  lda BallCollisType ; $b2b5: a5 34       .
            ora #$01           ; $b2b7: 09 01       |
            sta BallCollisType ; $b2b9: 85 34       | Set y-collision flag
            lda BlockProximity ; $b2bb: ad 06 01    .
            and #$08           ; $b2be: 29 08       |
            sta BlockCollisSide; $b2c0: 8d 07 01    | set block collision = "this block"
Ret_b2c3:   jmp Ret_b430       ; $b2c3: 4c 30 b4    . return

;-------------------------------------------------------------------------------
__b2c6:     lda BallCellOverlap; $b2c6: ad 08 01  .
            cmp #$02           ; $b2c9: c9 02     |
            bne __b2e9         ; $b2cb: d0 1c     | if there's only a horizontal overlap,
            lda BlockProximity ; $b2cd: ad 06 01    .
            and #$04           ; $b2d0: 29 04       |
            beq Ret_b2e6       ; $b2d2: f0 12       | if there's no block to the right, nothing to do, so return.
            lda #$0c           ; $b2d4: a9 0c       .
            sta BallXLoBits    ; $b2d6: 85 3c       | snap left
            lda BallCollisType ; $b2d8: a5 34       .
            ora #$02           ; $b2da: 09 02       |
            sta BallCollisType ; $b2dc: 85 34       | set x-collision flag
            lda BlockProximity ; $b2de: ad 06 01    .
            and #$04           ; $b2e1: 29 04       |
            sta BlockCollisSide; $b2e3: 8d 07 01    | set block collision = "one right"
Ret_b2e6:   jmp Ret_b430       ; $b2e6: 4c 30 b4    . return

;-------------------------------------------------------------------------------
__b2e9:     lda BallCellOverlap; $b2e9: ad 08 01  .
            cmp #$03           ; $b2ec: c9 03     |
            bne Ret_b2e6       ; $b2ee: d0 f6     | if there's both a horizontal and vertical overlap
            lda BlockProximity ; $b2f0: ad 06 01    .
            cmp #$04           ; $b2f3: c9 04       |
            bne __b365         ; $b2f5: d0 6e       | if there's only a block to the right,
            lda BallYLoBits    ; $b2f7: a5 3a         .
            cmp BallXLoBits    ; $b2f9: c5 3c         |
            bne __b303         ; $b2fb: d0 06         | if ball x low bits == ball y low bits
            lda Ball_1_Vel_Y   ; $b2fd: a5 35         |
            cmp Ball_1_Vel_X   ; $b2ff: c5 36         | and ball vx == ball vy,
            beq CornerBounce_b343; $b301: f0 40         . do corner bounce
__b303:     lda BallYLoBits    ; $b303: a5 3a         .
            cmp #$00           ; $b305: c9 00         |
            beq VertBounce_b321; $b307: f0 18         | if ball y low bits are > 0,
            lda BallXLoBits    ; $b309: a5 3c           .
            cmp #$0c           ; $b30b: c9 0c           |
            beq HorizBounce_b336; $b30d: f0 27          | if ball x low bits == 0xc, do horizontal bounce
            lda BallYLoBits    ; $b30f: a5 3a           .
            cmp BallCellY      ; $b311: c5 3d           |
            beq HorizBounce_b336; $b313: f0 21          | if ball y low bits == cell y, do horizontal bounce (possible bug?? should be high bits)
            lda BallYLoBitsM   ; $b315: a5 3f           .
            cmp #$00           ; $b317: c9 00           |
            beq HorizBounce_b336; $b319: f0 1b          | if ORIG ball y low bits == 0, do horizontal bounce
            lda BallXLoBitsM   ; $b31b: a5 40           .
            cmp #$0c           ; $b31d: c9 0c           |
            bcc CornerBounce_b343; $b31f: 90 22         | if ORIG ball x low bits < 0xc, do corner bounce
VertBounce_b321: lda BallYLoBits ; $b321: a5 3a       .
            cmp #$00           ; $b323: c9 00         |
            beq __b32d         ; $b325: f0 06         |
            lda #$00           ; $b327: a9 00         |
            sta BallYLoBits    ; $b329: 85 3a         |
            inc BallYHiBits    ; $b32b: e6 39         | snap down
__b32d:     lda BallCollisType ; $b32d: a5 34         .
            ora #$01           ; $b32f: 09 01         |
            sta BallCollisType ; $b331: 85 34         | set y-collision flag
            jmp __b35c         ; $b333: 4c 5c b3      . go to final steps

;-------------------------------------------------------------------------------
HorizBounce_b336:
            lda #$0c           ; $b336: a9 0c     .
            sta BallXLoBits    ; $b338: 85 3c     | snap left
            lda BallCollisType ; $b33a: a5 34     .
            ora #$02           ; $b33c: 09 02     |
            sta BallCollisType ; $b33e: 85 34     | set x-collision flag
            jmp __b35c         ; $b340: 4c 5c b3  . go to final steps

;-------------------------------------------------------------------------------
CornerBounce_b343:
            lda BallYLoBits    ; $b343: a5 3a     .
            cmp #$00           ; $b345: c9 00     |
            beq __b34f         ; $b347: f0 06     |
            lda #$00           ; $b349: a9 00     |
            sta BallYLoBits    ; $b34b: 85 3a     |
            inc BallYHiBits    ; $b34d: e6 39     | snap down
__b34f:     lda #$0c           ; $b34f: a9 0c     .
            sta BallXLoBits    ; $b351: 85 3c     |
            lda BallCollisType ; $b353: a5 34     | snap left
            ora #$03           ; $b355: 09 03     .
            sta BallCollisType ; $b357: 85 34     | set x and y collision flags
            jmp __b35c         ; $b359: 4c 5c b3  . go to final steps

;-------------------------------------------------------------------------------
__b35c:     lda BlockProximity ; $b35c: ad 06 01  .
            sta BlockCollisSide; $b35f: 8d 07 01  |
            jmp Ret_b430       ; $b362: 4c 30 b4  | apply proximity to collision side

;-------------------------------------------------------------------------------
__b365:     lda BlockProximity ; $b365: ad 06 01  .
            cmp #$08           ; $b368: c9 08     |
            bne __b387         ; $b36a: d0 1b     | if only "this block" exists,
            lda BallYLoBits    ; $b36c: a5 3a       .
            cmp #$00           ; $b36e: c9 00       |
            beq __b378         ; $b370: f0 06       |
            lda #$00           ; $b372: a9 00       |
            sta BallYLoBits    ; $b374: 85 3a       |
            inc BallYHiBits    ; $b376: e6 39       | snap down
__b378:     lda BallCollisType ; $b378: a5 34       .
            ora #$01           ; $b37a: 09 01       |
            sta BallCollisType ; $b37c: 85 34       | set y-collision flag
            lda BlockProximity ; $b37e: ad 06 01    .
            sta BlockCollisSide; $b381: 8d 07 01    |
            jmp Ret_b430       ; $b384: 4c 30 b4    | transfer proximity to collision side

;-------------------------------------------------------------------------------
__b387:     lda BlockProximity ; $b387: ad 06 01  .
            cmp #$01           ; $b38a: c9 01     |
            bne __b3a1         ; $b38c: d0 13     | if only the block down and to the right exists,
            lda #$0c           ; $b38e: a9 0c       .
            sta BallXLoBits    ; $b390: 85 3c       | snap left
            lda BallCollisType ; $b392: a5 34       .
            ora #$02           ; $b394: 09 02       |
            sta BallCollisType ; $b396: 85 34       | set x-collision flag
            lda BlockProximity ; $b398: ad 06 01    .
            sta BlockCollisSide; $b39b: 8d 07 01    |
            jmp Ret_b430       ; $b39e: 4c 30 b4    | transfer proximity to collision side

;-------------------------------------------------------------------------------
__b3a1:     lda BlockProximity ; $b3a1: ad 06 01  .
            cmp #$0c           ; $b3a4: c9 0c     |
            bne __b3ca         ; $b3a6: d0 22     | if this block and the one to the right exist,
            lda BallYLoBits    ; $b3a8: a5 3a       .
            cmp #$00           ; $b3aa: c9 00       |
            beq __b3b4         ; $b3ac: f0 06       |
            lda #$00           ; $b3ae: a9 00       |
            sta BallYLoBits    ; $b3b0: 85 3a       |
            inc BallYHiBits    ; $b3b2: e6 39       | snap down
__b3b4:     ldx #$08           ; $b3b4: a2 08       .
            lda BallXLoBits    ; $b3b6: a5 3c       |
            cmp #$0f           ; $b3b8: c9 0f       |
            bne __b3be         ; $b3ba: d0 02       |
            ldx #$04           ; $b3bc: a2 04       |
__b3be:     stx BlockCollisSide; $b3be: 8e 07 01    | set collision side = [one right] if ball x low bits == 0xf, else [this block]
            lda BallCollisType ; $b3c1: a5 34       .
            ora #$01           ; $b3c3: 09 01       |
            sta BallCollisType ; $b3c5: 85 34       | set y-collision flag
            jmp Ret_b430       ; $b3c7: 4c 30 b4    . return

;-------------------------------------------------------------------------------
__b3ca:     lda BlockProximity ; $b3ca: ad 06 01  .
            cmp #$05           ; $b3cd: c9 05     |
            bne __b3eb         ; $b3cf: d0 1a     | if one-right and one-down-right blocks exist,
            lda #$0c           ; $b3d1: a9 0c       .
            sta BallXLoBits    ; $b3d3: 85 3c       | snap left
            ldx #$04           ; $b3d5: a2 04       .
            lda BallYLoBits    ; $b3d7: a5 3a       |
            cmp #$07           ; $b3d9: c9 07       |
            bne __b3df         ; $b3db: d0 02       |
            ldx #$01           ; $b3dd: a2 01       |
__b3df:     stx BlockCollisSide; $b3df: 8e 07 01    | set collision side = [one down right] if ball y low bits == 7, else [one right]
            lda BallCollisType ; $b3e2: a5 34       .
            ora #$02           ; $b3e4: 09 02       |
            sta BallCollisType ; $b3e6: 85 34       | set x-collision flag
            jmp Ret_b430       ; $b3e8: 4c 30 b4    . return

;-------------------------------------------------------------------------------
__b3eb:     lda BlockProximity ; $b3eb: ad 06 01  .
            cmp #$00           ; $b3ee: c9 00     |
            beq Ret_b430       ; $b3f0: f0 3e     | if no blocks at all, return
            cmp #$09           ; $b3f2: c9 09     .
            beq __b3fa         ; $b3f4: f0 04     |
            cmp #$0d           ; $b3f6: c9 0d     |
            bne Ret_b430       ; $b3f8: d0 36     | if it's "this block" + "one down right" or "this block" + "one right" + "one down right"
__b3fa:     lda BallYLoBits    ; $b3fa: a5 3a       .
            cmp #$00           ; $b3fc: c9 00       |
            beq __b406         ; $b3fe: f0 06       |
__b400:     lda #$00           ; $b400: a9 00       |
            sta BallYLoBits    ; $b402: 85 3a       |
            inc BallYHiBits    ; $b404: e6 39       | snap down
__b406:     lda #$0c           ; $b406: a9 0c       .
            sta BallXLoBits    ; $b408: 85 3c       | snap left
            lda BallCollisType ; $b40a: a5 34       .
            ora #$03           ; $b40c: 09 03       |
            sta BallCollisType ; $b40e: 85 34       | set x and y collision flags
            lda #$01           ; $b410: a9 01       .
            sta BlockCollisSide; $b412: 8d 07 01    | set collision side = one down right by default
            ldx #$00           ; $b415: a2 00       . for x = 0..1,
__b417:     ldy __b431,x       ; $b417: bc 31 b4    .
            lda ($41),y        ; $b41a: b1 41       | grab the block at the index (this block, then one down right)
            cmp #$00           ; $b41c: c9 00       .
            beq __b424         ; $b41e: f0 04       | if there's no block there, move on
            cmp #$f0           ; $b420: c9 f0       .
            bne __b42a         ; $b422: d0 06       | if it's not a gold block, go store a new block collision side
__b424:     inx                ; $b424: e8          .
            cpx #$02           ; $b425: e0 02       |
            bne __b417         ; $b427: d0 ee       | loop
            rts                ; $b429: 60          . return

;-------------------------------------------------------------------------------
__b42a:     lda __b433,x       ; $b42a: bd 33 b4  
            sta BlockCollisSide; $b42d: 8d 07 01  
Ret_b430:   rts                ; $b430: 60        

;-------------------------------------------------------------------------------
__b431:     .hex 00 0c
__b433:     .hex 08 01

; == vx negative, vy positive ==
Next_b435:  lda BallVelSign    ; $b435: a5 33     .
            cmp #$03           ; $b437: c9 03     |
            beq Next_b43e      ; $b439: f0 03     | if vy is positive and vx is negative, jump to Next_b43e
__b43b:     jmp Next_b61d      ; $b43b: 4c 1d b6  . else move on to the next check

;-------------------------------------------------------------------------------
Next_b43e:  clc                ; $b43e: 18        .
            lda BallYHiBits    ; $b43f: a5 39     |
            adc #$01           ; $b441: 69 01     |
            cmp BlocksPerColumn; $b443: cd 0a 01  |
            beq __b43b         ; $b446: f0 f3     | if the ball cell y + 1 == blocks-per-column, move on to the next check
            ldy BallYHiBits    ; $b448: a4 39     
            ldx BallXHiBits    ; $b44a: a6 3b     
            lda BallYLoBits    ; $b44c: a5 3a     .
            cmp #$04           ; $b44e: c9 04     |
            bcc Next_b457      ; $b450: 90 05     | if ball y low bits are >= 4,
            lda #$01           ; $b452: a9 01       .
            sta BallCellOverlap; $b454: 8d 08 01    | set y-overlap flag
Next_b457:  lda BallCollisType ; $b457: a5 34     .
            and #$02           ; $b459: 29 02     |
            bne Next_b47a      ; $b45b: d0 1d     | if there's no x-collision,
            lda BallXLoBits    ; $b45d: a5 3c       .
            cmp #$00           ; $b45f: c9 00       |
            bne __b46c         ; $b461: d0 09       | if ball x low bits == 0,
            dex                ; $b463: ca            . decrement x high bits
            lda BallCellOverlap; $b464: ad 08 01      .
            ora #$02           ; $b467: 09 02         |
            sta BallCellOverlap; $b469: 8d 08 01      | set x-overlap flag 
__b46c:     lda BallXLoBits    ; $b46c: a5 3c       .
            cmp #$0d           ; $b46e: c9 0d       |
            bcc Next_b47a      ; $b470: 90 08       | if ball x low bits >= 0xd,
            lda BallCellOverlap; $b472: ad 08 01      .
            ora #$02           ; $b475: 09 02         |
            sta BallCellOverlap; $b477: 8d 08 01      | set x-overlap flag
Next_b47a:  sty CalculatedCellY; $b47a: 8c 0c 01  .
            stx CalculatedCellX; $b47d: 8e 0d 01  |
            jsr CheckBlockProximity; $b480: 20 36 ab| grab block proximity
            lda BallCellOverlap; $b483: ad 08 01  .
            cmp #$01           ; $b486: c9 01     |
            bne Next_b4a6      ; $b488: d0 1c     | if there's a y-overlap only,
            lda BlockProximity ; $b48a: ad 06 01    .
            and #$02           ; $b48d: 29 02       |
            beq Ret_b4a3       ; $b48f: f0 12       | if there's no one-down block, return
            lda #$04           ; $b491: a9 04       .
            sta BallYLoBits    ; $b493: 85 3a       | snap up
            lda BallCollisType ; $b495: a5 34       .
            ora #$01           ; $b497: 09 01       |
            sta BallCollisType ; $b499: 85 34       | set y-collision flag
            lda BlockProximity ; $b49b: ad 06 01    .
            and #$02           ; $b49e: 29 02       |
            sta BlockCollisSide; $b4a0: 8d 07 01    | set one-down collision side
Ret_b4a3:   jmp Ret_b618       ; $b4a3: 4c 18 b6    . return

;-------------------------------------------------------------------------------
Next_b4a6:  lda BallCellOverlap; $b4a6: ad 08 01  .
            cmp #$02           ; $b4a9: c9 02     |
            bne Next_b4d1      ; $b4ab: d0 24     | if there's an x-overlap only,
            lda BlockProximity ; $b4ad: ad 06 01    .
            and #$08           ; $b4b0: 29 08       |
            beq Ret_b4ce       ; $b4b2: f0 1a       | if there's no block here, return
            lda BallXLoBits    ; $b4b4: a5 3c       .
            cmp #$00           ; $b4b6: c9 00       |
            beq __b4c0         ; $b4b8: f0 06       | if the ball x low bits are != 0,
            lda #$00           ; $b4ba: a9 00         .
            sta BallXLoBits    ; $b4bc: 85 3c         |
            inc BallXHiBits    ; $b4be: e6 3b         | snap right
__b4c0:     lda BallCollisType ; $b4c0: a5 34       .
            ora #$02           ; $b4c2: 09 02       |
            sta BallCollisType ; $b4c4: 85 34       | set x-collision flag
            lda BlockProximity ; $b4c6: ad 06 01    .
            and #$08           ; $b4c9: 29 08       |
            sta BlockCollisSide; $b4cb: 8d 07 01    | set this-block collision side
Ret_b4ce:   jmp Ret_b618       ; $b4ce: 4c 18 b6    . return

;-------------------------------------------------------------------------------
Next_b4d1:  lda BallCellOverlap; $b4d1: ad 08 01  .
            cmp #$03           ; $b4d4: c9 03     |
            bne Ret_b4ce       ; $b4d6: d0 f6     | if there's no x- and y-overlap, return
            lda BlockProximity ; $b4d8: ad 06 01  .
            cmp #$02           ; $b4db: c9 02     |
            bne __b54d         ; $b4dd: d0 6e     | if only the one-down block exists,
            lda BallYLoBits    ; $b4df: a5 3a       .
            cmp BallXLoBits    ; $b4e1: c5 3c       |
            bne __b4eb         ; $b4e3: d0 06       | if ball x low bits == ball y low bits,
            lda Ball_1_Vel_Y   ; $b4e5: a5 35         .
            cmp Ball_1_Vel_X   ; $b4e7: c5 36         |
            beq CornerBounce_b52b ; $b4e9: f0 40      | if ball vx == ball vy, corner bounce
__b4eb:     lda BallYLoBits    ; $b4eb: a5 3a       .
            cmp #$04           ; $b4ed: c9 04       |
            beq BounceUp_b509  ; $b4ef: f0 18       | if ball y low bits == 4, bounce up
            lda BallXLoBits    ; $b4f1: a5 3c       .
            cmp #$00           ; $b4f3: c9 00       |
            beq BounceRight_b516; $b4f5: f0 1f      | if ball x low bits == 0, bounce right
            lda BallYLoBitsM   ; $b4f7: a5 3f       .
            cmp #$3d           ; $b4f9: c9 3d       |
            bcs BounceRight_b516; $b4fb: b0 19      | no-op (bug / removed code?)
            lda BallXHiBits    ; $b4fd: a5 3b       .
            cmp BallCellX      ; $b4ff: c5 3e       |
            beq BounceUp_b509  ; $b501: f0 06       | if ball x high bits == cell x, bounce up
            lda #$40           ; $b503: a9 40       .
            cmp #$00           ; $b505: c9 00       |
            bne CornerBounce_b52b; $b507: d0 22     | do corner bounce
BounceUp_b509:
            lda #$04           ; $b509: a9 04       .
            sta BallYLoBits    ; $b50b: 85 3a       | snap up
            lda BallCollisType ; $b50d: a5 34       .
            ora #$01           ; $b50f: 09 01       |
            sta BallCollisType ; $b511: 85 34       | set y-collision flag
            jmp __b544         ; $b513: 4c 44 b5    . continue

;-------------------------------------------------------------------------------
BounceRight_b516:
            lda BallXLoBits    ; $b516: a5 3c     .
            cmp #$00           ; $b518: c9 00     |
            beq __b522         ; $b51a: f0 06     |
            lda #$00           ; $b51c: a9 00     |
            sta BallXLoBits    ; $b51e: 85 3c     |
            inc BallXHiBits    ; $b520: e6 3b     | snap right
__b522:     lda BallCollisType ; $b522: a5 34     .
            ora #$02           ; $b524: 09 02     |
            sta BallCollisType ; $b526: 85 34     | set x-collision flag
            jmp __b544         ; $b528: 4c 44 b5  . continue

;-------------------------------------------------------------------------------
CornerBounce_b52b:
            lda #$04           ; $b52b: a9 04     .
            sta BallYLoBits    ; $b52d: 85 3a     | snap up
            lda BallXLoBits    ; $b52f: a5 3c     .
            cmp #$00           ; $b531: c9 00     |
            beq __b53b         ; $b533: f0 06     |
            lda #$00           ; $b535: a9 00     |
            sta BallXLoBits    ; $b537: 85 3c     |
            inc BallXHiBits    ; $b539: e6 3b     | snap right
__b53b:     lda BallCollisType ; $b53b: a5 34     .
            ora #$03           ; $b53d: 09 03     |
            sta BallCollisType ; $b53f: 85 34     | set x- and y-collision flags
            jmp __b544         ; $b541: 4c 44 b5  . continue

;-------------------------------------------------------------------------------
__b544:     lda BlockProximity ; $b544: ad 06 01  .
            sta BlockCollisSide; $b547: 8d 07 01  |
            jmp Ret_b618       ; $b54a: 4c 18 b6  | copy proximity values to collision-side data

;-------------------------------------------------------------------------------
__b54d:     lda BlockProximity ; $b54d: ad 06 01  .
            cmp #$08           ; $b550: c9 08     |
            bne __b56f         ; $b552: d0 1b     | if the only block around is this one,
            lda BallXLoBits    ; $b554: a5 3c       .
            cmp #$00           ; $b556: c9 00       |
            beq __b560         ; $b558: f0 06       |
            lda #$00           ; $b55a: a9 00       |
            sta BallXLoBits    ; $b55c: 85 3c       |
            inc BallXHiBits    ; $b55e: e6 3b       | snap right
__b560:     lda BallCollisType ; $b560: a5 34       .
            ora #$02           ; $b562: 09 02       |
            sta BallCollisType ; $b564: 85 34       | set x-collision flag
            lda BlockProximity ; $b566: ad 06 01    .
            sta BlockCollisSide; $b569: 8d 07 01    | store block proximity in collis-side data
            jmp Ret_b618       ; $b56c: 4c 18 b6    . return

;-------------------------------------------------------------------------------
__b56f:     lda BlockProximity ; $b56f: ad 06 01  .
            cmp #$01           ; $b572: c9 01     |
            bne __b589         ; $b574: d0 13     | if the only block around is down-right,
            lda #$04           ; $b576: a9 04       .
            sta BallYLoBits    ; $b578: 85 3a       | snap up
            lda BallCollisType ; $b57a: a5 34       .
            ora #$01           ; $b57c: 09 01       |
            sta BallCollisType ; $b57e: 85 34       | set y-collision flag
            lda BlockProximity ; $b580: ad 06 01    .
            sta BlockCollisSide; $b583: 8d 07 01    | store block proximity in collis-side data
            jmp Ret_b618       ; $b586: 4c 18 b6    . return

;-------------------------------------------------------------------------------
__b589:     lda BlockProximity ; $b589: ad 06 01  .
            cmp #$0a           ; $b58c: c9 0a     |
            bne __b5b2         ; $b58e: d0 22     | if only this block and the one below exist,
            lda BallXLoBits    ; $b590: a5 3c       .
            cmp #$00           ; $b592: c9 00       |
            beq __b59c         ; $b594: f0 06       |
            lda #$00           ; $b596: a9 00       |
            sta BallXLoBits    ; $b598: 85 3c       |
            inc BallXHiBits    ; $b59a: e6 3b       | snap right
__b59c:     ldx #$08           ; $b59c: a2 08       .
            lda BallYLoBits    ; $b59e: a5 3a       |
            cmp #$07           ; $b5a0: c9 07       |
            bne __b5a6         ; $b5a2: d0 02       | if ball y low bits == 7,
            ldx #$02           ; $b5a4: a2 02         .
__b5a6:     stx BlockCollisSide; $b5a6: 8e 07 01      | set collis side = one down, else this-block
            lda BallCollisType ; $b5a9: a5 34       .
            ora #$02           ; $b5ab: 09 02       |
            sta BallCollisType ; $b5ad: 85 34       | set x-collision flag
            jmp Ret_b618       ; $b5af: 4c 18 b6    . return

;-------------------------------------------------------------------------------
__b5b2:     lda BlockProximity ; $b5b2: ad 06 01  .
            cmp #$03           ; $b5b5: c9 03     |
            bne __b5d3         ; $b5b7: d0 1a     | if only one-down and one-down-right blocks exist,
            lda #$04           ; $b5b9: a9 04       .
            sta BallYLoBits    ; $b5bb: 85 3a       | snap up
            ldx #$02           ; $b5bd: a2 02       .
            lda BallXLoBits    ; $b5bf: a5 3c       |
            cmp #$0f           ; $b5c1: c9 0f       |
            bne __b5c7         ; $b5c3: d0 02       | if ball x low bits == 0xf,
            ldx #$01           ; $b5c5: a2 01         .
__b5c7:     stx BlockCollisSide; $b5c7: 8e 07 01      | set collis side = one-down-right, else one-down
            lda BallCollisType ; $b5ca: a5 34       .
            ora #$01           ; $b5cc: 09 01       |
            sta BallCollisType ; $b5ce: 85 34       | set y-collision flag
            jmp Ret_b618       ; $b5d0: 4c 18 b6    . return

;-------------------------------------------------------------------------------
__b5d3      lda BlockProximity ; $b5d3: ad 06 01  .
            cmp #$00           ; $b5d6: c9 00     |
            beq Ret_b618       ; $b5d8: f0 3e     | if no blocks at all, return
            cmp #$09           ; $b5da: c9 09     .
            beq __b5e2         ; $b5dc: f0 04     |
            cmp #$0b           ; $b5de: c9 0b     |
            bne Ret_b618       ; $b5e0: d0 36     | else if it's one-down-right and this-block, or one-down and one-down-right and this-block,
__b5e2:     lda #$04           ; $b5e2: a9 04       .
            sta BallYLoBits    ; $b5e4: 85 3a       | snap up
            lda BallXLoBits    ; $b5e6: a5 3c       .
            cmp #$00           ; $b5e8: c9 00       |
            beq __b5f2         ; $b5ea: f0 06       |
            lda #$00           ; $b5ec: a9 00       |
            sta BallXLoBits    ; $b5ee: 85 3c       |
            inc BallXHiBits    ; $b5f0: e6 3b       | snap right
__b5f2:     lda BallCollisType ; $b5f2: a5 34       .
            ora #$03           ; $b5f4: 09 03       |
            sta BallCollisType ; $b5f6: 85 34       | set x- and y-collision flags
            lda #$08           ; $b5f8: a9 08       .
            sta BlockCollisSide; $b5fa: 8d 07 01    | set collision side = this-block
            ldx #$00           ; $b5fd: a2 00       .
__b5ff:     ldy __b619,x       ; $b5ff: bc 19 b6    |
            lda ($41),y        ; $b602: b1 41       |
__b604:     cmp #$00           ; $b604: c9 00       |
            beq __b60c         ; $b606: f0 04       |
            cmp #$f0           ; $b608: c9 f0       |
            bne __b612         ; $b60a: d0 06       |
__b60c:     inx                ; $b60c: e8          |
            cpx #$02           ; $b60d: e0 02       |
            bne __b5ff         ; $b60f: d0 ee       | if this-block exists and it's not gold, set collision side = thisBlock
            rts                ; $b611: 60          | else set one-down-right

;-------------------------------------------------------------------------------
__b612:     lda __b61b,x       ; $b612: bd 1b b6  
            sta BlockCollisSide; $b615: 8d 07 01  
Ret_b618:   rts                ; $b618: 60        

;-------------------------------------------------------------------------------
__b619:     .hex 00 0c
__b61b:     .hex 08 01

; == vx positive, vy positive ==
Next_b61d:  lda BallVelSign    ; $b61d: a5 33     .
            cmp #$01           ; $b61f: c9 01     |
            beq Next_b624      ; $b621: f0 01     | if vy and vx are both positive, jump to Next_b624
Ret_b623:   rts                ; $b623: 60        . else return

;-------------------------------------------------------------------------------
Next_b624:  clc                ; $b624: 18        .
            lda BallYHiBits    ; $b625: a5 39     |
            adc #$01           ; $b627: 69 01     |
            cmp BlocksPerColumn; $b629: cd 0a 01  |
            beq Ret_b623       ; $b62c: f0 f5     | if the ball is too low to hit any blocks, return
            ldy BallYHiBits    ; $b62e: a4 39     
            ldx BallXHiBits    ; $b630: a6 3b     
            lda BallYLoBits    ; $b632: a5 3a     .
            cmp #$04           ; $b634: c9 04     |
            bcc __b63d         ; $b636: 90 05     | if ball y low bits >= 4,
            lda #$01           ; $b638: a9 01       .
            sta BallCellOverlap; $b63a: 8d 08 01    | set y-overlap flag
__b63d:     lda BallCollisType ; $b63d: a5 34     .
            and #$02           ; $b63f: 29 02     |
            bne __b651         ; $b641: d0 0e     | if there's no x-collision already,
            lda BallXLoBits    ; $b643: a5 3c       .
            cmp #$0c           ; $b645: c9 0c       |
            bcc __b651         ; $b647: 90 08       | if ball x low bits >= 0xc,
            lda BallCellOverlap; $b649: ad 08 01      .
            ora #$02           ; $b64c: 09 02         |
            sta BallCellOverlap; $b64e: 8d 08 01      | set x-overlap flag
__b651:     sty CalculatedCellY; $b651: 8c 0c 01   .
            stx CalculatedCellX; $b654: 8e 0d 01    |
            jsr CheckBlockProximity ; $b657: 20 36 ab| grab block proximity
            lda BallCellOverlap; $b65a: ad 08 01  .
            cmp #$01           ; $b65d: c9 01     |
            bne __b67d         ; $b65f: d0 1c     | if there's y-overlap only,
            lda BlockProximity ; $b661: ad 06 01    .
            and #$02           ; $b664: 29 02       |
            beq Ret_b67a         ; $b666: f0 12     | if the one-down block doesn't exist, return
            lda #$04           ; $b668: a9 04       .
            sta BallYLoBits    ; $b66a: 85 3a       | snap up
            lda BallCollisType ; $b66c: a5 34       .
            ora #$01           ; $b66e: 09 01       |
            sta BallCollisType ; $b670: 85 34       | set y-collision flag
            lda BlockProximity ; $b672: ad 06 01    .
            and #$02           ; $b675: 29 02       |
            sta BlockCollisSide; $b677: 8d 07 01    | set collision side = one-down
Ret_b67a:   jmp Ret_b7b9       ; $b67a: 4c b9 b7    . return

;-------------------------------------------------------------------------------
__b67d:     lda BallCellOverlap; $b67d: ad 08 01  .
            cmp #$02           ; $b680: c9 02     |
            bne __b6a0         ; $b682: d0 1c     | if there's an x-overlap only,
            lda BlockProximity ; $b684: ad 06 01    .
            and #$04           ; $b687: 29 04       |
            beq Ret_b69d       ; $b689: f0 12       | if the one-right block doesn't exist, return
            lda #$0c           ; $b68b: a9 0c       .
            sta BallXLoBits    ; $b68d: 85 3c       | snap left
            lda BallCollisType ; $b68f: a5 34       .
            ora #$02           ; $b691: 09 02       |
            sta BallCollisType ; $b693: 85 34       | set x-collision flag
            lda BlockProximity ; $b695: ad 06 01    .
            and #$04           ; $b698: 29 04       |
            sta BlockCollisSide; $b69a: 8d 07 01    | set collision side = one-right
Ret_b69d:   jmp Ret_b7b9       ; $b69d: 4c b9 b7    . return

;-------------------------------------------------------------------------------
__b6a0:     lda BallCellOverlap; $b6a0: ad 08 01  .
            cmp #$03           ; $b6a3: c9 03     |
            bne Ret_b69d       ; $b6a5: d0 f6     | if there's not both an x- and y-overlap, return
            lda BlockProximity ; $b6a7: ad 06 01  .
            cmp #$01           ; $b6aa: c9 01     |
            bne __b706         ; $b6ac: d0 58     | if the only block is one-down-right,
            lda BallYLoBits    ; $b6ae: a5 3a       .
            cmp BallXLoBits    ; $b6b0: c5 3c       |
            bne __b6ba         ; $b6b2: d0 06       |
            lda Ball_1_Vel_Y   ; $b6b4: a5 35       |
            cmp Ball_1_Vel_X   ; $b6b6: c5 36       |
            beq CornerBounce_b6ec; $b6b8: f0 32     | if ball x low bits == y low bits, and vy == vx, do corner bounce
__b6ba:     lda BallYLoBits    ; $b6ba: a5 3a       .
            cmp #$04           ; $b6bc: c9 04       |
            beq VertBounce_b6d2; $b6be: f0 12       | if ball y low bits == 4, vertical bounce
            lda BallXLoBits    ; $b6c0: a5 3c       .
            cmp #$0c           ; $b6c2: c9 0c       |
            beq HorizBounce_b6df; $b6c4: f0 19      | if ball x low bits == 0xc, horizontal bounce
            lda BallYLoBitsM   ; $b6c6: a5 3f       .
            cmp #$04           ; $b6c8: c9 04       |
            bcs HorizBounce_b6df; $b6ca: b0 13      | if original y low bits >= 4, horizontal bounce
            lda BallXLoBitsM   ; $b6cc: a5 40       .
            cmp #$0c           ; $b6ce: c9 0c       |
            bcc CornerBounce_b6ec; $b6d0: 90 1a     | if original x low bits < 0xc, corner bounce
VertBounce_b6d2: lda #$04      ; $b6d2: a9 04     
            sta BallYLoBits    ; $b6d4: 85 3a     
            lda BallCollisType ; $b6d6: a5 34     
            ora #$01           ; $b6d8: 09 01     
            sta BallCollisType ; $b6da: 85 34     
            jmp __b6fd         ; $b6dc: 4c fd b6  

;-------------------------------------------------------------------------------
HorizBounce_b6df:
            lda #$0c           ; $b6df: a9 0c     
            sta BallXLoBits    ; $b6e1: 85 3c     
            lda BallCollisType ; $b6e3: a5 34     
            ora #$02           ; $b6e5: 09 02     
            sta BallCollisType ; $b6e7: 85 34     
            jmp __b6fd         ; $b6e9: 4c fd b6  

;-------------------------------------------------------------------------------
CornerBounce_b6ec:
            lda #$04           ; $b6ec: a9 04     
            sta BallYLoBits    ; $b6ee: 85 3a     
            lda #$0c           ; $b6f0: a9 0c     
            sta BallXLoBits    ; $b6f2: 85 3c     
            lda BallCollisType ; $b6f4: a5 34     
            ora #$03           ; $b6f6: 09 03     
            sta BallCollisType ; $b6f8: 85 34     
            jmp __b6fd         ; $b6fa: 4c fd b6  

;-------------------------------------------------------------------------------
__b6fd:     lda BlockProximity ; $b6fd: ad 06 01  
            sta BlockCollisSide; $b700: 8d 07 01  
            jmp Ret_b7b9       ; $b703: 4c b9 b7  

;-------------------------------------------------------------------------------
__b706:     lda BlockProximity ; $b706: ad 06 01  .
            cmp #$04           ; $b709: c9 04     |
            bne __b720         ; $b70b: d0 13     | if the only block around is one-right,
            lda #$0c           ; $b70d: a9 0c       .
            sta BallXLoBits    ; $b70f: 85 3c       | snap left
            lda BallCollisType ; $b711: a5 34       .
            ora #$02           ; $b713: 09 02       |
            sta BallCollisType ; $b715: 85 34       | set x-collision flag
            lda BlockProximity ; $b717: ad 06 01    .
            sta BlockCollisSide; $b71a: 8d 07 01    | set collision side = one-right
            jmp Ret_b7b9       ; $b71d: 4c b9 b7    . return

;-------------------------------------------------------------------------------
__b720:     lda BlockProximity ; $b720: ad 06 01  .
            cmp #$02           ; $b723: c9 02     |
            bne __b73a         ; $b725: d0 13     | if the only block around is one-down,
            lda #$04           ; $b727: a9 04     
            sta BallYLoBits    ; $b729: 85 3a     
            lda BallCollisType ; $b72b: a5 34     
            ora #$01           ; $b72d: 09 01     
            sta BallCollisType ; $b72f: 85 34     ; bounce down
            lda BlockProximity ; $b731: ad 06 01  
            sta BlockCollisSide; $b734: 8d 07 01  
            jmp Ret_b7b9       ; $b737: 4c b9 b7  

;-------------------------------------------------------------------------------
__b73a:     lda BlockProximity ; $b73a: ad 06 01  .
            cmp #$05           ; $b73d: c9 05     |
            bne __b75b         ; $b73f: d0 1a     | if the blocks one-right and one-down-right are around,
            lda #$0c           ; $b741: a9 0c     
            sta BallXLoBits    ; $b743: 85 3c     
            ldx #$04           ; $b745: a2 04     
            lda BallYLoBits    ; $b747: a5 3a     
            cmp #$07           ; $b749: c9 07     
            bne __b74f         ; $b74b: d0 02     
            ldx #$01           ; $b74d: a2 01     
__b74f:     stx BlockCollisSide; $b74f: 8e 07 01  
            lda BallCollisType ; $b752: a5 34     
            ora #$02           ; $b754: 09 02     
            sta BallCollisType ; $b756: 85 34     
            jmp Ret_b7b9       ; $b758: 4c b9 b7  

;-------------------------------------------------------------------------------
__b75b:     lda BlockProximity ; $b75b: ad 06 01  .
            cmp #$03           ; $b75e: c9 03     |
            bne __b77c         ; $b760: d0 1a     | if the blocks one-down and one-down-right are around,
            lda #$04           ; $b762: a9 04     .
            sta BallYLoBits    ; $b764: 85 3a     | snap up
            ldx #$02           ; $b766: a2 02     .
            lda BallXLoBits    ; $b768: a5 3c     |
            cmp #$0f           ; $b76a: c9 0f     |
            bne __b770         ; $b76c: d0 02     |
            ldx #$01           ; $b76e: a2 01     |
__b770:     stx BlockCollisSide; $b770: 8e 07 01  | if x low bits == 0xf, set collis side = one-down-right, else one-down
            lda BallCollisType ; $b773: a5 34     .
            ora #$01           ; $b775: 09 01     |
            sta BallCollisType ; $b777: 85 34     | set y-collision flag
            jmp Ret_b7b9       ; $b779: 4c b9 b7  . return

;-------------------------------------------------------------------------------
__b77c:     lda BlockProximity ; $b77c: ad 06 01  .
            cmp #$00           ; $b77f: c9 00     |
            beq Ret_b7b9       ; $b781: f0 36     |
            cmp #$06           ; $b783: c9 06     |
            beq __b78b         ; $b785: f0 04     |
            cmp #$07           ; $b787: c9 07     |
            bne Ret_b7b9       ; $b789: d0 2e     | if it's one-down and one-right, or it's one-down / one-right / one-down-right,
__b78b:     lda #$04           ; $b78b: a9 04     .
            sta BallYLoBits    ; $b78d: 85 3a     | snap up
            lda #$0c           ; $b78f: a9 0c     .
            sta BallXLoBits    ; $b791: 85 3c     | snap left
            lda BallCollisType ; $b793: a5 34     .
            ora #$03           ; $b795: 09 03     |
            sta BallCollisType ; $b797: 85 34     | set x- and y-collision flags
            lda #$04           ; $b799: a9 04     .
            sta BlockCollisSide; $b79b: 8d 07 01  | set collision side = one-right
            ldx #$00           ; $b79e: a2 00     
__b7a0:     ldy __b7ba,x       ; $b7a0: bc ba b7  
            lda ($41),y        ; $b7a3: b1 41     
            cmp #$00           ; $b7a5: c9 00     
            beq __b7ad         ; $b7a7: f0 04     
            cmp #$f0           ; $b7a9: c9 f0     
            bne __b7b3         ; $b7ab: d0 06     
__b7ad:     inx                ; $b7ad: e8        
            cpx #$02           ; $b7ae: e0 02     
            bne __b7a0         ; $b7b0: d0 ee     
            rts                ; $b7b2: 60        

;-------------------------------------------------------------------------------
__b7b3:     lda __b7bc,x       ; $b7b3: bd bc b7  
            sta BlockCollisSide; $b7b6: 8d 07 01  
Ret_b7b9:   rts                ; $b7b9: 60        

;-------------------------------------------------------------------------------
__b7ba:     .hex 01 0b
__b7bc:     .hex 04 02

__b7be:     lda JustSpawnedPowerup ; $b7be: ad 3e 01 .
            cmp #$00           ; $b7c1: c9 00        |
            bne Ret_b7f2       ; $b7c3: d0 2d        | if we just spawned a powerup, return
            lda IsDemo         ; $b7c5: a5 10     .
            cmp #$00           ; $b7c7: c9 00     |
            bne Ret_b7f2       ; $b7c9: d0 27     | if this is the demo, return
            lda BlockCollisFlag; $b7cb: ad 45 01  .
            cmp #$00           ; $b7ce: c9 00     |
            bne Ret_b7f2       ; $b7d0: d0 20     | if there was just a block collision, return
            lda IsScorePending ; $b7d2: ad 34 01  .
            cmp #$00           ; $b7d5: c9 00     |
            beq Ret_b7f2       ; $b7d7: f0 19     | if there's no pending score, return
            lda $19            ; $b7d9: a5 19     
            cmp #$00           ; $b7db: c9 00     
            bne __b7e5         ; $b7dd: d0 06     
            jsr __b803         ; $b7df: 20 03 b8  
            jmp __b7e8         ; $b7e2: 4c e8 b7  

;-------------------------------------------------------------------------------
__b7e5:     jsr __b813         ; $b7e5: 20 13 b8  
__b7e8:     lda IsHighScore    ; $b7e8: ad 35 01  .
            cmp #$00           ; $b7eb: c9 00     |
            beq Ret_b7f2       ; $b7ed: f0 03     | if we're actively setting a high score,
            jsr __b7f3         ; $b7ef: 20 f3 b7    . call sub
Ret_b7f2:   rts                ; $b7f2: 60        . return

;-------------------------------------------------------------------------------
__b7f3:     lda #$66           ; $b7f3: a9 66     
            sta $86            ; $b7f5: 85 86     
            lda #$03           ; $b7f7: a9 03     
            sta $87            ; $b7f9: 85 87     
            ldy #$20           ; $b7fb: a0 20     
            ldx #$b9           ; $b7fd: a2 b9     
            jsr __a36a         ; $b7ff: 20 6a a3  
            rts                ; $b802: 60        

;-------------------------------------------------------------------------------
__b803:     lda #$70           ; $b803: a9 70     
            sta $86            ; $b805: 85 86     
            lda #$03           ; $b807: a9 03     
            sta $87            ; $b809: 85 87     
            ldy #$21           ; $b80b: a0 21     
            ldx #$19           ; $b80d: a2 19     
            jsr __a36a         ; $b80f: 20 6a a3  
            rts                ; $b812: 60        

;-------------------------------------------------------------------------------
__b813:     lda #$76           ; $b813: a9 76     
            sta $86            ; $b815: 85 86     
            lda #$03           ; $b817: a9 03     
            sta $87            ; $b819: 85 87     
            ldy #$21           ; $b81b: a0 21     
            ldx #$79           ; $b81d: a2 79     
            jsr __a36a         ; $b81f: 20 6a a3  
            rts                ; $b822: 60        

;-------------------------------------------------------------------------------
__b823:     lda NumLives       ; $b823: a5 0d     
            ora $0e            ; $b825: 05 0e     
            beq Ret_b888       ; $b827: f0 5f     
            clc                ; $b829: 18        
            lda NumLives       ; $b82a: a5 0d     
            sbc $0e            ; $b82c: e5 0e     
            beq Ret_b888       ; $b82e: f0 58     
            bcc Ret_b888       ; $b830: 90 56     
            lda $0e            ; $b832: a5 0e     
            inc $0e            ; $b834: e6 0e     
            cmp #$06           ; $b836: c9 06     
            bcs Ret_b888       ; $b838: b0 4e     
            asl                ; $b83a: 0a        
            tax                ; $b83b: aa        
            lda __b889,x       ; $b83c: bd 89 b8  
            sta $2006          ; $b83f: 8d 06 20  
            lda __b88a,x       ; $b842: bd 8a b8  
            sta $2006          ; $b845: 8d 06 20  
            lda #$b0           ; $b848: a9 b0     
            sta $2007          ; $b84a: 8d 07 20  
            lda #$b1           ; $b84d: a9 b1     
            sta $2007          ; $b84f: 8d 07 20  
            lda #$00           ; $b852: a9 00     
            sta $2005          ; $b854: 8d 05 20  
            sta $2005          ; $b857: 8d 05 20  
            jmp __b823         ; $b85a: 4c 23 b8  

;-------------------------------------------------------------------------------
            dec $0e            ; $b85d: c6 0e     
            lda $0e            ; $b85f: a5 0e     
            cmp #$06           ; $b861: c9 06     
            bcs Ret_b888       ; $b863: b0 23     
            asl                ; $b865: 0a        
            tax                ; $b866: aa        
            lda __b889,x       ; $b867: bd 89 b8  
            sta $2006          ; $b86a: 8d 06 20  
            lda __b88a,x       ; $b86d: bd 8a b8  
            sta $2006          ; $b870: 8d 06 20  
            lda #$2d           ; $b873: a9 2d     
            sta $2007          ; $b875: 8d 07 20  
            lda #$2d           ; $b878: a9 2d     
            sta $2007          ; $b87a: 8d 07 20  
            lda #$00           ; $b87d: a9 00     
            sta $2005          ; $b87f: 8d 05 20  
            sta $2005          ; $b882: 8d 05 20  
            jmp __b823         ; $b885: 4c 23 b8  

;-------------------------------------------------------------------------------
Ret_b888:   rts                ; $b888: 60        

;-------------------------------------------------------------------------------
__b889:     .hex 21            ; $b889: 21        
__b88a:     .hex    d9         ; $b88a: d9
            .hex 21 db         ; $b88b: 21 db
            .hex 21 dd         ; $b88d: 21 dd     
            .hex 21 f9         ; $b88f: 21 f9     
            .hex 21 fb         ; $b891: 21 fb     
            .hex 21 fd         ; $b893: 21 fd     

__b895:     lda JustSpawnedPowerup ; $b895: ad 3e 01 .
            cmp #$00           ; $b898: c9 00        |
            bne Ret_b8d7       ; $b89a: d0 3b        | if we just spawned a powerup, return
            lda GameState      ; $b89c: a5 0a        .
            cmp #$20           ; $b89e: c9 20        |
            bne Next_b8ba      ; $b8a0: d0 18        | if game state == paused, do inner stuff here
            lda $013c          ; $b8a2: ad 3c 01  
            cmp #$01           ; $b8a5: c9 01     
            bne Ret_b8d7       ; $b8a7: d0 2e     
            lda #$d8           ; $b8a9: a9 d8     
            sta $86            ; $b8ab: 85 86     
            lda #$b8           ; $b8ad: a9 b8     
            sta $87            ; $b8af: 85 87     
            jsr __a3c3         ; $b8b1: 20 c3 a3  
            lda #$00           ; $b8b4: a9 00     
            sta $013c          ; $b8b6: 8d 3c 01  
            rts                ; $b8b9: 60        

;-------------------------------------------------------------------------------
Next_b8ba:  lda GameState      ; $b8ba: a5 0a     .
            cmp #$10           ; $b8bc: c9 10     |
            bne Ret_b8d7       ; $b8be: d0 17     | if game state != ball moving, return
            lda $013c          ; $b8c0: ad 3c 01  
            cmp #$01           ; $b8c3: c9 01     
            bne Ret_b8d7       ; $b8c5: d0 10     
            lda #$e1           ; $b8c7: a9 e1     
            sta $86            ; $b8c9: 85 86     
            lda #$b8           ; $b8cb: a9 b8     
            sta $87            ; $b8cd: 85 87     
            jsr __a3c3         ; $b8cf: 20 c3 a3  
            lda #$00           ; $b8d2: a9 00     
            sta $013c          ; $b8d4: 8d 3c 01  
Ret_b8d7:   rts                ; $b8d7: 60        . return

;-------------------------------------------------------------------------------
            .hex 22 9a 05 19 0a 1e 1c 0e ff
            .hex 22 9a 05 2d 2d 2d 2d 2d ff

UpdateWarpGate:
            lda WarpState      ; $b8ea: ad 24 01  .
            cmp #$00           ; $b8ed: c9 00     |
            beq Ret_b944       ; $b8ef: f0 53     | if the warp gate isn't open, return
            lda WarpGateAnimTimer ; $b8f1: ad 25 01 .
            cmp #$00           ; $b8f4: c9 00       |
            beq Next_b8fc      ; $b8f6: f0 04       | if the warp timer has cycled, go update the animation frame
            dec WarpGateAnimTimer ; $b8f8: ce 25 01 .
            rts                ; $b8fb: 60          | else decrement the timer

;-------------------------------------------------------------------------------
Next_b8fc:  ldx #$00           ; $b8fc: a2 00     .
            lda WarpState      ; $b8fe: ad 24 01  |
            cmp #$01           ; $b901: c9 01     |
            bne Next_b907      ; $b903: d0 02     |
            ldx #$03           ; $b905: a2 03     
Next_b907:  lda _PPU_Ctrl1_Mirror ; $b907: a5 14  
            ora #$04           ; $b909: 09 04     
            sta $2000          ; $b90b: 8d 00 20  
            lda #$23           ; $b90e: a9 23     
            sta $2006          ; $b910: 8d 06 20  
            lda #$38           ; $b913: a9 38     
            sta $2006          ; $b915: 8d 06 20  
            lda __b945,x       ; $b918: bd 45 b9  
            sta $2007          ; $b91b: 8d 07 20  
            lda __b946,x       ; $b91e: bd 46 b9  
            sta $2007          ; $b921: 8d 07 20  
            lda __b947,x       ; $b924: bd 47 b9  
            sta $2007          ; $b927: 8d 07 20  
            lda #$00           ; $b92a: a9 00     
            sta $2005          ; $b92c: 8d 05 20  
            sta $2005          ; $b92f: 8d 05 20  
            lda #$02           ; $b932: a9 02       .
            sta WarpGateAnimTimer ; $b934: 8d 25 01 | reset warp timer to 2 for next time
            lda WarpState      ; $b937: ad 24 01    .
            eor #$03           ; $b93a: 49 03       |
            sta WarpState      ; $b93c: 8d 24 01    | flip the warp state between 1 <--> 2
            lda _PPU_Ctrl1_Mirror ; $b93f: a5 14    
            sta $2000          ; $b941: 8d 00 20  
Ret_b944:   rts                ; $b944: 60          . return

;-------------------------------------------------------------------------------
__b945:     .db $8d
__b946:     .db $9d
__b947:     .db $ad, $8f, $9f, $af

__b94b:     lda $d8            ; $b94a: a5 d8
            cmp #$00           ; $b94d: c9 00     
            bne Next_b955      ; $b94f: d0 04     
            lda #$00           ; $b951: a9 00     
            sta $d9            ; $b953: 85 d9     
Next_b955:  lda $d9            ; $b955: a5 d9     
            and #$03           ; $b957: 29 03     
            bne Next_b95f      ; $b959: d0 04     
            lda #$f0           ; $b95b: a9 f0     
            sta $dc            ; $b95d: 85 dc     
Next_b95f:  lda $dc            ; $b95f: a5 dc     
            sta $0238          ; $b961: 8d 38 02  
            sta $023c          ; $b964: 8d 3c 02  
            lda $dd            ; $b967: a5 dd     
            sta $023b          ; $b969: 8d 3b 02  
            clc                ; $b96c: 18        
            adc #$08           ; $b96d: 69 08     
            sta $023f          ; $b96f: 8d 3f 02  
            lda $d9            ; $b972: a5 d9     
            and #$0c           ; $b974: 29 0c     
            bne Next_b97c      ; $b976: d0 04     
            lda #$f0           ; $b978: a9 f0     
            sta $de            ; $b97a: 85 de     
Next_b97c:  lda $de            ; $b97c: a5 de     
            sta $0240          ; $b97e: 8d 40 02  
            sta $0244          ; $b981: 8d 44 02  
            lda $df            ; $b984: a5 df     
            sta $0243          ; $b986: 8d 43 02  
            clc                ; $b989: 18        
            adc #$08           ; $b98a: 69 08     
            sta $0247          ; $b98c: 8d 47 02  
            rts                ; $b98f: 60        

;-------------------------------------------------------------------------------
UpdateBallSprites:
            lda ActiveBalls    ; $b990: a5 81     .
            and #$01           ; $b992: 29 01     |
            bne Next_b99a      ; $b994: d0 04     | if ball 1 isn't active,
            lda #$f0           ; $b996: a9 f0       .
            sta Ball_1_Y       ; $b998: 85 37       | Set ball 1 y to 0xf0
Next_b99a:  lda Ball_1_Y       ; $b99a: a5 37     .
            sta $022c          ; $b99c: 8d 2c 02  |
            lda Ball_1_X       ; $b99f: a5 38     |
            sta $022f          ; $b9a1: 8d 2f 02  | Update ball 1 sprite position
            lda #$f0           ; $b9a4: a9 f0     
            sta $0250          ; $b9a6: 8d 50 02  
            lda SpawnedPowerup ; $b9a9: a5 8c     
            cmp #$00           ; $b9ab: c9 00     
            beq Next_b9db      ; $b9ad: f0 2c     
            lda WarpState      ; $b9af: ad 24 01  
            cmp #$00           ; $b9b2: c9 00     
            beq Next_b9db      ; $b9b4: f0 25     
            lda Powerup_Y      ; $b9b6: a5 91     
            cmp #$d0           ; $b9b8: c9 d0     
            bcc Next_b9db      ; $b9ba: 90 1f     
            cmp #$d9           ; $b9bc: c9 d9     
            bcs Next_b9db      ; $b9be: b0 1b     
            lda $0142          ; $b9c0: ad 42 01  
            eor #$01           ; $b9c3: 49 01     
            sta $0142          ; $b9c5: 8d 42 01  
            cmp #$00           ; $b9c8: c9 00     
            beq Next_b9db      ; $b9ca: f0 0f     
            lda Ball_1_Y       ; $b9cc: a5 37     
            sta $0250          ; $b9ce: 8d 50 02  
            lda Ball_1_X       ; $b9d1: a5 38     
            sta $0253          ; $b9d3: 8d 53 02  
            lda #$f0           ; $b9d6: a9 f0     
            sta $022c          ; $b9d8: 8d 2c 02  
Next_b9db:  ldy #BallStructSize ; $b9db: a0 1a    . Prepare ball 2 data
            lda ActiveBalls    ; $b9dd: a5 81     |
            and #$02           ; $b9df: 29 02     |
            bne Next_b9e8      ; $b9e1: d0 05     | if ball 2 isn't active,
            lda #$f0           ; $b9e3: a9 f0       .
            sta $0037,y        ; $b9e5: 99 37 00    | Set ball 2 y to 0xf0
Next_b9e8:  lda $0037,y        ; $b9e8: b9 37 00  .
            sta $0230          ; $b9eb: 8d 30 02  |
            lda $0038,y        ; $b9ee: b9 38 00  |
            sta $0233          ; $b9f1: 8d 33 02  | Update ball 2 sprite position
            ldy #BallStructSizeDouble; $b9f4: a0 34 . Prepare ball 3 data
            lda ActiveBalls    ; $b9f6: a5 81     .
            and #$04           ; $b9f8: 29 04     |
            bne Next_ba01      ; $b9fa: d0 05     | if ball 3 isn't active,
            lda #$f0           ; $b9fc: a9 f0       .
            sta $0037,y        ; $b9fe: 99 37 00    | Set ball 3 y to 0xf0
Next_ba01:  lda $0037,y        ; $ba01: b9 37 00  .
            sta $0234          ; $ba04: 8d 34 02  |
            lda $0038,y        ; $ba07: b9 38 00  |
            sta $0237          ; $ba0a: 8d 37 02  | Update ball 3 sprite position
            rts                ; $ba0d: 60        . return

;-------------------------------------------------------------------------------
UpdatePaddleSprites:
            lda GameState      ; $ba0e: a5 0a     .
            cmp #$10           ; $ba10: c9 10     |
            beq Next_ba44      ; $ba12: f0 30     |
            cmp #$08           ; $ba14: c9 08     |
            beq Next_ba44      ; $ba16: f0 2c     |
            cmp #$18           ; $ba18: c9 18     |
            beq Next_ba44      ; $ba1a: f0 28     |
            cmp #$20           ; $ba1c: c9 20     |
            beq Next_ba44      ; $ba1e: f0 24     |
            cmp #$30           ; $ba20: c9 30     |
            beq Next_ba44      ; $ba22: f0 20     |
            cmp #$31           ; $ba24: c9 31     |
            beq Next_ba44      ; $ba26: f0 1c     |
            cmp #$32           ; $ba28: c9 32     |
            beq Next_ba44      ; $ba2a: f0 18     |
            cmp #$80           ; $ba2c: c9 80     |
            beq Next_ba44      ; $ba2e: f0 14     | if the game state isn't one where we're showing a paddle,
            lda #$f0           ; $ba30: a9 f0       .
            sta PaddleTop_A    ; $ba32: 8d 14 01    |
            sta PaddleTop_B    ; $ba35: 8d 15 01    |
            sta PaddleTop_C    ; $ba38: 8d 16 01    |
            sta PaddleTop_D    ; $ba3b: 8d 17 01    |
            sta PaddleTop_E    ; $ba3e: 8d 18 01    |
            sta PaddleTop_F    ; $ba41: 8d 19 01    | Set paddle top edge to 0xf0 (offscreen)
Next_ba44:  lda PaddleTop_A    ; $ba44: ad 14 01  .
            sta $0204          ; $ba47: 8d 04 02  |
            lda $0120          ; $ba4a: ad 20 01  |
            sta $0205          ; $ba4d: 8d 05 02  |
            lda PaddleLeftEdge ; $ba50: ad 1a 01  |
            sta $0207          ; $ba53: 8d 07 02  | Copy paddle left edge data into sprite table
            lda PaddleTop_B    ; $ba56: ad 15 01  .
            sta $0208          ; $ba59: 8d 08 02  |
            lda $0121          ; $ba5c: ad 21 01  |
            sta $0209          ; $ba5f: 8d 09 02  |
            lda PaddleLeftCenter ; $ba62: ad 1b 01| 
            sta $020b          ; $ba65: 8d 0b 02  | Copy paddle left center data into sprite table
            lda PaddleTop_C    ; $ba68: ad 16 01  .
            sta $020c          ; $ba6b: 8d 0c 02  |
            lda $0121          ; $ba6e: ad 21 01  |
            sta $020d          ; $ba71: 8d 0d 02  |
            lda PaddleLeftCenterM; $ba74: ad 1c 01|
            sta $020f          ; $ba77: 8d 0f 02  | Copy mirrored paddle left center data into sprite table
            lda PaddleTop_D    ; $ba7a: ad 17 01  .
            sta $0210          ; $ba7d: 8d 10 02  |
            lda $0121          ; $ba80: ad 21 01  |
            sta $0211          ; $ba83: 8d 11 02  |
            lda PaddleRightCenter; $ba86: ad 1d 01|
            sta $0213          ; $ba89: 8d 13 02  | Copy paddle right center data into sprite table
            lda PaddleTop_E    ; $ba8c: ad 18 01   .
            sta $0214          ; $ba8f: 8d 14 02   |
            lda $0121          ; $ba92: ad 21 01   |
            sta $0215          ; $ba95: 8d 15 02   |
            lda PaddleRightCenterM; $ba98: ad 1e 01|
            sta $0217          ; $ba9b: 8d 17 02   | Copy mirrored paddle right center data into sprite table
            lda PaddleTop_F    ; $ba9e: ad 19 01  .
            sta $0218          ; $baa1: 8d 18 02  |
            lda $0120          ; $baa4: ad 20 01  |
            sta $0219          ; $baa7: 8d 19 02  |
            lda PaddleRightEdge ; $baaa: ad 1f 01 |
            sta $021b          ; $baad: 8d 1b 02  | Copy paddle right edge data into sprite table
            rts                ; $bab0: 60        . return

;-------------------------------------------------------------------------------
UpdatePowerup:
            lda GameState      ; $bab1: a5 0a     .
            cmp #$20           ; $bab3: c9 20     |
            bne Next_bab8      ; $bab5: d0 01     | if the game isn't paused, go update the powerup
            rts                ; $bab7: 60        . return

;-------------------------------------------------------------------------------
Next_bab8:  lda SpawnedPowerup ; $bab8: a5 8c     .
            cmp #$00           ; $baba: c9 00     |
            beq Next_bac8      ; $babc: f0 0a     | 
            lda GameState      ; $babe: a5 0a     |
            cmp #$08           ; $bac0: c9 08     |
            beq Next_bacc      ; $bac2: f0 08     |
            cmp #$10           ; $bac4: c9 10     |
            beq Next_bacc      ; $bac6: f0 04     | if there's no powerup on the field or if we're not actively in a level,
Next_bac8:  lda #$f0           ; $bac8: a9 f0        .
            sta Powerup_Y      ; $baca: 85 91        | Put the powerup offscreen
Next_bacc:  lda Powerup_Y      ; $bacc: a5 91     .
            cmp #$f0           ; $bace: c9 f0     |
            bcc Next_badd      ; $bad0: 90 0b     | if the powerup's offscreen
            lda #$00           ; $bad2: a9 00       .
            sta SpawnedPowerup ; $bad4: 85 8c       | Clear spawned powerup
            lda #$f0           ; $bad6: a9 f0       .
            sta Powerup_Y      ; $bad8: 85 91       | make sure it's still at 0xf0 (since it's advanced downward each frame)
            jmp Next_baef      ; $bada: 4c ef ba    . continue

;-------------------------------------------------------------------------------
Next_badd:  ldy PowerupAnimFrame ; $badd: a4 8d   .
            lda ($8f),y        ; $badf: b1 8f     |
            sta PowerupTileId  ; $bae1: 85 92     |
            cmp #$ff           ; $bae3: c9 ff     |
            bne Next_baef      ; $bae5: d0 08     |
            ldy #$00           ; $bae7: a0 00     |
            sty PowerupAnimFrame ; $bae9: 84 8d   | 
            lda ($8f),y        ; $baeb: b1 8f     |
            sta PowerupTileId  ; $baed: 85 92     | Pick the appropriate tile ID based on the animation frame
Next_baef:  lda Powerup_Y      ; $baef: a5 91     .
            sta $0248          ; $baf1: 8d 48 02  |
            lda PowerupTileId  ; $baf4: a5 92     |
            sta $0249          ; $baf6: 8d 49 02  |
            lda PowerupSprFlags; $baf9: a5 93     |
            sta $024a          ; $bafb: 8d 4a 02  |
            lda Powerup_X      ; $bafe: a5 94     |
            sta $024b          ; $bb00: 8d 4b 02  | Update the left-half powerup sprite data
            lda Powerup_Y      ; $bb03: a5 91     .
            sta $024c          ; $bb05: 8d 4c 02  |
            lda PowerupTileId  ; $bb08: a5 92     |
            clc                ; $bb0a: 18        |
            adc #$01           ; $bb0b: 69 01     |
            sta $024d          ; $bb0d: 8d 4d 02  |
            lda PowerupSprFlags; $bb10: a5 93     |
            sta $024e          ; $bb12: 8d 4e 02  |
            lda Powerup_X      ; $bb15: a5 94     |
            clc                ; $bb17: 18        |
            adc #$08           ; $bb18: 69 08     |
            sta $024f          ; $bb1a: 8d 4f 02  | Update the right-half powerup sprite data
            inc Powerup_Y      ; $bb1d: e6 91     . Advance the powerup down one tick
            lda PowerupAnimTimer ; $bb1f: a5 8e   .
            cmp #$00           ; $bb21: c9 00     |
            beq AdvPowerupFrame; $bb23: f0 03     | if the timer's reached 0, go advance the animation frame
            dec PowerupAnimTimer ; $bb25: c6 8e   . else advance powerup animation timer
            rts                ; $bb27: 60        . return

;-------------------------------------------------------------------------------
AdvPowerupFrame:
            inc PowerupAnimFrame ; $bb28: e6 8d   . Update the animation frame
            lda #$03           ; $bb2a: a9 03     .
            sta PowerupAnimTimer ; $bb2c: 85 8e   | reset the timer 
            rts                ; $bb2e: 60        . return

;-------------------------------------------------------------------------------
__bb2f:     lda GameState      ; $bb2f: a5 0a     .
            cmp #$10           ; $bb31: c9 10     |
            beq Next_bb39      ; $bb33: f0 04     |
            cmp #$18           ; $bb35: c9 18     |
            bne Next_bb4b      ; $bb37: d0 12     | if game state == 0x10 (ball active) or 0x18 (ball lost),
Next_bb39:  lda CurrentLevel   ; $bb39: a5 1a       .
            cmp #$24           ; $bb3b: c9 24       |
            bne Next_bb4b      ; $bb3d: d0 0c       | if this is the boss level,
            jsr __bb4f         ; $bb3f: 20 4f bb      
            jsr __bbd7         ; $bb42: 20 d7 bb      
            jsr __bc18         ; $bb45: 20 18 bc      
            jsr __bc5b         ; $bb48: 20 5b bc      
Next_bb4b:  jsr __be5a         ; $bb4b: 20 5a be    
            rts                ; $bb4e: 60        . return

;-------------------------------------------------------------------------------
__bb4f:     lda ActiveBalls    ; $bb4f: a5 81     
            beq Ret_bbc1       ; $bb51: f0 6e     
            lda $0169          ; $bb53: ad 69 01  
            cmp #$00           ; $bb56: c9 00     
            beq Next_bb5e      ; $bb58: f0 04     
            dec $0169          ; $bb5a: ce 69 01  
            rts                ; $bb5d: 60        

;-------------------------------------------------------------------------------
Next_bb5e:  lda $0182          ; $bb5e: ad 82 01  
            cmp #$01           ; $bb61: c9 01     
            bne Ret_bbc1       ; $bb63: d0 5c     
            ldx $0168          ; $bb65: ae 68 01  
            lda #$01           ; $bb68: a9 01     
            sta $016a,x        ; $bb6a: 9d 6a 01  
            lda #$58           ; $bb6d: a9 58     
            sta $016d,x        ; $bb6f: 9d 6d 01  
            lda #$64           ; $bb72: a9 64     
            sta $0170,x        ; $bb74: 9d 70 01  
            lda #$1e           ; $bb77: a9 1e     
            sta $0169          ; $bb79: 8d 69 01  
            ldy #$ff           ; $bb7c: a0 ff     
Loop_bb7e:  iny                ; $bb7e: c8        
            lda PaddleLeftEdge ; $bb7f: ad 1a 01  
            cmp __bbc2,y       ; $bb82: d9 c2 bb  
            bcs Loop_bb7e      ; $bb85: b0 f7     
            tya                ; $bb87: 98        
            asl                ; $bb88: 0a        
            tay                ; $bb89: a8        
            lda __bbc9,y       ; $bb8a: b9 c9 bb  
            sta $0179,x        ; $bb8d: 9d 79 01  
            lda __bbca,y       ; $bb90: b9 ca bb  
            sta $017c,x        ; $bb93: 9d 7c 01  
            lda #$00           ; $bb96: a9 00     
            sta $0185,x        ; $bb98: 9d 85 01  
            lda $0187,x        ; $bb9b: bd 87 01  
            lda #$01           ; $bb9e: a9 01     
            sta $017f          ; $bba0: 8d 7f 01  
            inc $0168          ; $bba3: ee 68 01  
            lda $0168          ; $bba6: ad 68 01  
            cmp #$03           ; $bba9: c9 03     
            bne Ret_bbc1       ; $bbab: d0 14     
            lda #$00           ; $bbad: a9 00     
            sta $0168          ; $bbaf: 8d 68 01  
            lda #$02           ; $bbb2: a9 02     
            sta $0182          ; $bbb4: 8d 82 01  
            lda #$00           ; $bbb7: a9 00     
            sta $0183          ; $bbb9: 8d 83 01
            lda #$08           ; $bbbc: a9 08     
            sta $0184          ; $bbbe: 8d 84 01  
Ret_bbc1:   rts                ; $bbc1: 60        

;-------------------------------------------------------------------------------
__bbc2:     jsr $5038          ; $bbc2: 20 38 50  
            pla                ; $bbc5: 68        
            .hex 80 98         ; $bbc6: 80 98     Invalid Opcode - NOP #$98
            .hex b0            ; $bbc8: b0        Suspected data
__bbc9:     .hex 05            ; $bbc9: 05        Suspected data
__bbca:     sbc __fe05,x       ; $bbca: fd 05 fe  
            ora $ff            ; $bbcd: 05 ff     
            ora $00            ; $bbcf: 05 00     
            ora $01            ; $bbd1: 05 01     
            ora $02            ; $bbd3: 05 02     
            ora $03            ; $bbd5: 05 03     
__bbd7:     ldx #$00           ; $bbd7: a2 00     
__bbd9:     lda $017f,x        ; $bbd9: bd 7f 01  
            cmp #$00           ; $bbdc: c9 00     
            beq __bbe6         ; $bbde: f0 06     
            dec $017f,x        ; $bbe0: de 7f 01  
            jmp __bc12         ; $bbe3: 4c 12 bc  

;-------------------------------------------------------------------------------
__bbe6:     lda $016a,x        ; $bbe6: bd 6a 01  
            cmp #$00           ; $bbe9: c9 00     
            beq __bc12         ; $bbeb: f0 25     
            lda #$02           ; $bbed: a9 02     
            sta $017f,x        ; $bbef: 9d 7f 01  
            clc                ; $bbf2: 18        
            lda $016d,x        ; $bbf3: bd 6d 01  
            adc $0179,x        ; $bbf6: 7d 79 01  
            sta $016d,x        ; $bbf9: 9d 6d 01  
            cmp #$f0           ; $bbfc: c9 f0     
            bcc __bc08         ; $bbfe: 90 08     
            lda #$00           ; $bc00: a9 00     
            sta $016a,x        ; $bc02: 9d 6a 01  
            sta $017f,x        ; $bc05: 9d 7f 01  
__bc08:     clc                ; $bc08: 18        
            lda $0170,x        ; $bc09: bd 70 01  
            adc $017c,x        ; $bc0c: 7d 7c 01  
            sta $0170,x        ; $bc0f: 9d 70 01  
__bc12:     inx                ; $bc12: e8        
            cpx #$03           ; $bc13: e0 03     
            bne __bbd9         ; $bc15: d0 c2     
            rts                ; $bc17: 60        

;-------------------------------------------------------------------------------
__bc18:     ldx #$00           ; $bc18: a2 00     
__bc1a:     lda $0185,x        ; $bc1a: bd 85 01  
            cmp #$00           ; $bc1d: c9 00     
            beq __bc27         ; $bc1f: f0 06     
            dec $0185,x        ; $bc21: de 85 01  
            jmp __bc4c         ; $bc24: 4c 4c bc  

;-------------------------------------------------------------------------------
__bc27:     lda $016a,x        ; $bc27: bd 6a 01  
            cmp #$00           ; $bc2a: c9 00     
            beq __bc4c         ; $bc2c: f0 1e     
            lda #$05           ; $bc2e: a9 05     
            sta $0185,x        ; $bc30: 9d 85 01  
            ldy $0187,x        ; $bc33: bc 87 01  
            lda __bc52,y       ; $bc36: b9 52 bc  
            cmp #$ff           ; $bc39: c9 ff     
            bne __bc46         ; $bc3b: d0 09     
            lda #$00           ; $bc3d: a9 00     
            sta $0187,x        ; $bc3f: 9d 87 01  
            tay                ; $bc42: a8        
            lda __bc52,y       ; $bc43: b9 52 bc  
__bc46:     sta $0173,x        ; $bc46: 9d 73 01  
            inc $0187,x        ; $bc49: fe 87 01  
__bc4c:     inx                ; $bc4c: e8        
            cpx #$03           ; $bc4d: e0 03     
            bne __bc1a         ; $bc4f: d0 c9     
            rts                ; $bc51: 60        

;-------------------------------------------------------------------------------
__bc52:     jsr $2221          ; $bc52: 20 21 22  
            .hex 23 24         ; $bc55: 23 24     Invalid Opcode - RLA ($24,x)
            and $26            ; $bc57: 25 26     
            .hex 27 ff         ; $bc59: 27 ff     Invalid Opcode - RLA $ff
__bc5b:     ldx #$00           ; $bc5b: a2 00     
__bc5d:     lda $016a,x        ; $bc5d: bd 6a 01  
            cmp #$00           ; $bc60: c9 00     
            beq __bca1         ; $bc62: f0 3d     
            clc                ; $bc64: 18        
            lda $016d,x        ; $bc65: bd 6d 01  
            adc #$06           ; $bc68: 69 06     
            cmp PaddleTop_A    ; $bc6a: cd 14 01  
            bcc __bca1         ; $bc6d: 90 32     
            clc                ; $bc6f: 18        
            lda PaddleTop_A    ; $bc70: ad 14 01  
            adc #$06           ; $bc73: 69 06     
            cmp $016d,x        ; $bc75: dd 6d 01  
            bcc __bca1         ; $bc78: 90 27     
            clc                ; $bc7a: 18        
            lda $0170,x        ; $bc7b: bd 70 01  
            adc #$06           ; $bc7e: 69 06     
            cmp PaddleLeftEdge ; $bc80: cd 1a 01  
            bcc __bca1         ; $bc83: 90 1c     
            clc                ; $bc85: 18        
            lda PaddleRightEdge ; $bc86: ad 1f 01  
            adc #$06           ; $bc89: 69 06     
            cmp $0170,x        ; $bc8b: dd 70 01  
            bcc __bca1         ; $bc8e: 90 11     
            lda #$00           ; $bc90: a9 00     .
            sta ActiveBalls    ; $bc92: 85 81     | Clear active balls
            sta $0182          ; $bc94: 8d 82 01  
            sta $016a          ; $bc97: 8d 6a 01  
            sta $016b          ; $bc9a: 8d 6b 01  
            sta $016c          ; $bc9d: 8d 6c 01  
            rts                ; $bca0: 60        

;-------------------------------------------------------------------------------
__bca1:     inx                ; $bca1: e8        
            cpx #$03           ; $bca2: e0 03     
            bne __bc5d         ; $bca4: d0 b7     
            rts                ; $bca6: 60        

;-------------------------------------------------------------------------------
__bca7:     lda GameState      ; $bca7: a5 0a     
            cmp #$10           ; $bca9: c9 10     
            beq __bcae         ; $bcab: f0 01     
            rts                ; $bcad: 60        

;-------------------------------------------------------------------------------
__bcae:     lda $018b          ; $bcae: ad 8b 01  
            cmp #$00           ; $bcb1: c9 00     
            beq __bcb9         ; $bcb3: f0 04     
            dec $018b          ; $bcb5: ce 8b 01  
            rts                ; $bcb8: 60        

;-------------------------------------------------------------------------------
__bcb9:     lda $018a          ; $bcb9: ad 8a 01  
            cmp #$00           ; $bcbc: c9 00     
            bne __bcf7         ; $bcbe: d0 37     
            lda BossHealth     ; $bcc0: ad 66 01  
            cmp BossHealthM    ; $bcc3: cd 67 01  
            bne __bcc9         ; $bcc6: d0 01     
            rts                ; $bcc8: 60        

;-------------------------------------------------------------------------------
__bcc9:     lda #$eb           ; $bcc9: a9 eb     
            sta $88            ; $bccb: 85 88     
            lda #$83           ; $bccd: a9 83     
            sta $89            ; $bccf: 85 89     
            jsr AddPendingScore; $bcd1: 20 56 90  
            lda BossHealth     ; $bcd4: ad 66 01  
            sta BossHealthM    ; $bcd7: 8d 67 01  
            cmp #$10           ; $bcda: c9 10     
            bne __bced         ; $bcdc: d0 0f     
            lda #$30           ; $bcde: a9 30     
            sta GameState      ; $bce0: 85 0a     
            lda #$00           ; $bce2: a9 00     
            sta $018e          ; $bce4: 8d 8e 01  
            lda #$32           ; $bce7: a9 32     
            sta $018f          ; $bce9: 8d 8f 01  
            rts                ; $bcec: 60        

;-------------------------------------------------------------------------------
__bced:     lda MuteSoundEffectsTimer ; $bced: ad 0e 01 .
            bne __bcf7         ; $bcf0: d0 05           | if we're not muting sound effects,
            lda #$06           ; $bcf2: a9 06             .
            jsr PlaySoundEffect; $bcf4: 20 c6 f3          | play sound effect 6
__bcf7:     ldx #$00           ; $bcf7: a2 00     
__bcf9:     lda $014a,x        ; $bcf9: bd 4a 01  
            sta $0131          ; $bcfc: 8d 31 01  
            lda $014e,x        ; $bcff: bd 4e 01  
            sta $014a,x        ; $bd02: 9d 4a 01  
            lda $0131          ; $bd05: ad 31 01  
            sta $014e,x        ; $bd08: 9d 4e 01  
            inx                ; $bd0b: e8        
            cpx #$04           ; $bd0c: e0 04     
            bne __bcf9         ; $bd0e: d0 e9     
            jsr __a412         ; $bd10: 20 12 a4  
            lda $018a          ; $bd13: ad 8a 01  
            eor #$01           ; $bd16: 49 01     
            sta $018a          ; $bd18: 8d 8a 01  
            lda #$05           ; $bd1b: a9 05     
            sta $018b          ; $bd1d: 8d 8b 01  
            rts                ; $bd20: 60        

;-------------------------------------------------------------------------------
__bd21:     lda $018d          ; $bd21: ad 8d 01  
            cmp #$00           ; $bd24: c9 00     
            beq __bd2c         ; $bd26: f0 04     
            dec $018d          ; $bd28: ce 8d 01  
            rts                ; $bd2b: 60        

;-------------------------------------------------------------------------------
__bd2c:     lda $018c          ; $bd2c: ad 8c 01  
            cmp #$00           ; $bd2f: c9 00     
            bne __bd34         ; $bd31: d0 01     
            rts                ; $bd33: 60        

;-------------------------------------------------------------------------------
__bd34:     lda $018c          ; $bd34: ad 8c 01  
            cmp #$0d           ; $bd37: c9 0d     
            bne __bd4f         ; $bd39: d0 14     
            lda #$00           ; $bd3b: a9 00     
            sta $018c          ; $bd3d: 8d 8c 01  
            lda #$31           ; $bd40: a9 31     
            sta GameState      ; $bd42: 85 0a     
            lda #$00           ; $bd44: a9 00     
            sta $018e          ; $bd46: 8d 8e 01  
            lda #$3c           ; $bd49: a9 3c     
            sta $018f          ; $bd4b: 8d 8f 01  
            rts                ; $bd4e: 60        

;-------------------------------------------------------------------------------
__bd4f:     cmp #$01           ; $bd4f: c9 01     
            bne __bd58         ; $bd51: d0 05     
            lda #$07           ; $bd53: a9 07     .
            jsr PlaySoundEffect; $bd55: 20 c6 f3  | play sound effect 7
__bd58:     sec                ; $bd58: 38        
            lda $018c          ; $bd59: ad 8c 01  
            sbc #$01           ; $bd5c: e9 01     
            asl                ; $bd5e: 0a        
            tax                ; $bd5f: aa        
            lda __bd91,x       ; $bd60: bd 91 bd  
            sta $2006          ; $bd63: 8d 06 20  
            lda __bd92,x       ; $bd66: bd 92 bd  
            sta $2006          ; $bd69: 8d 06 20  
            lda #$06           ; $bd6c: a9 06     
            sta $2001          ; $bd6e: 8d 01 20  
            ldx #$08           ; $bd71: a2 08     
            lda #$2d           ; $bd73: a9 2d     
__bd75:     sta $2007          ; $bd75: 8d 07 20  
            dex                ; $bd78: ca        
            bne __bd75         ; $bd79: d0 fa     
            lda #$00           ; $bd7b: a9 00     
            sta $2005          ; $bd7d: 8d 05 20  
            sta $2005          ; $bd80: 8d 05 20  
            lda _PPU_Ctrl2_Mirror ; $bd83: a5 15     
            sta $2001          ; $bd85: 8d 01 20  
            lda #$15           ; $bd88: a9 15     
            sta $018d          ; $bd8a: 8d 8d 01  
            inc $018c          ; $bd8d: ee 8c 01  
            rts                ; $bd90: 60        

;-------------------------------------------------------------------------------
__bd91:     .hex 20            ; $bd91: 20        Suspected data
__bd92:     lda #$20           ; $bd92: a9 20     
            cmp #$20           ; $bd94: c9 20     
            sbc #$21           ; $bd96: e9 21     
            ora #$21           ; $bd98: 09 21     
            and #$21           ; $bd9a: 29 21     
            eor #$21           ; $bd9c: 49 21     
            adc #$21           ; $bd9e: 69 21     
            .hex 89 21         ; $bda0: 89 21     Invalid Opcode - NOP #$21
            lda #$21           ; $bda2: a9 21     
            cmp #$21           ; $bda4: c9 21     
            sbc #$22           ; $bda6: e9 22     
            .hex 09            ; $bda8: 09        Suspected data
__bda9:     lda GameState      ; $bda9: a5 0a     
            cmp #$10           ; $bdab: c9 10     
            bne __be15         ; $bdad: d0 66     
            lda CurrentLevel   ; $bdaf: a5 1a     
            cmp #$24           ; $bdb1: c9 24     
            bne __be15         ; $bdb3: d0 60     
            lda $018c          ; $bdb5: ad 8c 01  
            cmp #$00           ; $bdb8: c9 00     
            bne __be15         ; $bdba: d0 59     
            lda $0183          ; $bdbc: ad 83 01  
            ora $0184          ; $bdbf: 0d 84 01  
            beq __bdd2         ; $bdc2: f0 0e     
            dec $0184          ; $bdc4: ce 84 01  
            lda $0184          ; $bdc7: ad 84 01  
            cmp #$ff           ; $bdca: c9 ff     
            bne __be15         ; $bdcc: d0 47     
            dec $0183          ; $bdce: ce 83 01  
            rts                ; $bdd1: 60        

;-------------------------------------------------------------------------------
__bdd2:     lda $018b          ; $bdd2: ad 8b 01  
            bne __be15         ; $bdd5: d0 3e     
            lda $0182          ; $bdd7: ad 82 01  
            cmp #$00           ; $bdda: c9 00     
            bne __bdf4         ; $bddc: d0 16     
            lda #$16           ; $bdde: a9 16     
            sta $86            ; $bde0: 85 86     
            lda #$be           ; $bde2: a9 be     
            sta $87            ; $bde4: 85 87     
            jsr __a3c3         ; $bde6: 20 c3 a3  
            lda #$01           ; $bde9: a9 01     
            sta $0182          ; $bdeb: 8d 82 01  
            lda #$02           ; $bdee: a9 02     
            sta $0169          ; $bdf0: 8d 69 01  
            rts                ; $bdf3: 60        

;-------------------------------------------------------------------------------
__bdf4:     lda $0182          ; $bdf4: ad 82 01  
            cmp #$02           ; $bdf7: c9 02     
            bne __be15         ; $bdf9: d0 1a     
            lda #$38           ; $bdfb: a9 38     
            sta $86            ; $bdfd: 85 86     
            lda #$be           ; $bdff: a9 be     
            sta $87            ; $be01: 85 87     
            jsr __a3c3         ; $be03: 20 c3 a3  
            lda #$00           ; $be06: a9 00     
            sta $0182          ; $be08: 8d 82 01  
            lda #$01           ; $be0b: a9 01     
            sta $0183          ; $be0d: 8d 83 01  
            lda #$00           ; $be10: a9 00     
            sta $0184          ; $be12: 8d 84 01  
__be15:     rts                ; $be15: 60        

;-------------------------------------------------------------------------------
            and ($49,x)        ; $be16: 21 49     
            php                ; $be18: 08        
            rti                ; $be19: 40        

;-------------------------------------------------------------------------------
            eor ($42,x)        ; $be1a: 41 42     
            .hex 43 44         ; $be1c: 43 44     Invalid Opcode - SRE ($44,x)
            eor $46            ; $be1e: 45 46     
            .hex 47 21         ; $be20: 47 21     Invalid Opcode - SRE $21
            adc #$08           ; $be22: 69 08     
            bvc __be77         ; $be24: 50 51     
            .hex 52            ; $be26: 52        Invalid Opcode - KIL 
            .hex 53 54         ; $be27: 53 54     Invalid Opcode - SRE ($54),y
            eor $56,x          ; $be29: 55 56     
            .hex 57 21         ; $be2b: 57 21     Invalid Opcode - SRE $21,x
            .hex 89 08         ; $be2d: 89 08     Invalid Opcode - NOP #$08
            rts                ; $be2f: 60        

;-------------------------------------------------------------------------------
            adc ($62,x)        ; $be30: 61 62     
            .hex 63 64         ; $be32: 63 64     Invalid Opcode - RRA ($64,x)
            adc $66            ; $be34: 65 66     
            .hex 67 ff         ; $be36: 67 ff     Invalid Opcode - RRA $ff
            and ($49,x)        ; $be38: 21 49     
            php                ; $be3a: 08        
            tya                ; $be3b: 98        
            sta __9b9a,y       ; $be3c: 99 9a 9b  
            .hex 9c 9d 9e      ; $be3f: 9c 9d 9e  Invalid Opcode - SHY __9e9d,x
            .hex 9f 21 69      ; $be42: 9f 21 69  Invalid Opcode - AHX $6921,y
            php                ; $be45: 08        
            tay                ; $be46: a8        
            lda #$aa           ; $be47: a9 aa     
            .hex ab ac         ; $be49: ab ac     Invalid Opcode - LAX #$ac
            .hex ad ae af      ; $be4b: ad ae af  
            and ($89,x)        ; $be4e: 21 89     
            php                ; $be50: 08        
            clv                ; $be51: b8        
            .hex b9 ba bb      ; $be52: b9 ba bb  
            .hex bc bd be      ; $be55: bc bd be  
            .hex bf ff         ; $be58: bf ff     Suspected data
__be5a:     ldx #$00           ; $be5a: a2 00     
            ldy #$00           ; $be5c: a0 00     
__be5e:     lda $016a,x        ; $be5e: bd 6a 01  
            cmp #$00           ; $be61: c9 00     
            bne __be6a         ; $be63: d0 05     
            lda #$f0           ; $be65: a9 f0     
            sta $016d,x        ; $be67: 9d 6d 01  
__be6a:     lda $016d,x        ; $be6a: bd 6d 01  
            sta $0220,y        ; $be6d: 99 20 02  
            lda $0173,x        ; $be70: bd 73 01  
            sta $0221,y        ; $be73: 99 21 02  
            .hex bd            ; $be76: bd        Suspected data
__be77:     ror $01,x          ; $be77: 76 01     
            sta $0222,y        ; $be79: 99 22 02  
            lda $0170,x        ; $be7c: bd 70 01  
            sta $0223,y        ; $be7f: 99 23 02  
            tya                ; $be82: 98        
            clc                ; $be83: 18        
            adc #$04           ; $be84: 69 04     
            tay                ; $be86: a8        
            inx                ; $be87: e8        
            cpx #$03           ; $be88: e0 03     
            bne __be5e         ; $be8a: d0 d2     
            rts                ; $be8c: 60        

;-------------------------------------------------------------------------------
UpdateEnemies:
            lda CurrentLevel   ; $be8d: a5 1a     .
            cmp #$24           ; $be8f: c9 24     |
            beq Ret_beac       ; $be91: f0 19     | if this is the boss level, return
            lda GameState      ; $be93: a5 0a     .
            cmp #$08           ; $be95: c9 08     |
            beq __be9d         ; $be97: f0 04     |
            cmp #$10           ; $be99: c9 10     |
            bne Next_bea9      ; $be9b: d0 0c     | if game state == 8 or 0x10,
__be9d:     jsr UpdateEnemyAnimTimers ; $be9d: 20 29 c3  .
            jsr AdvanceEnemies ; $bea0: 20 77 bf         |
            jsr UpdateEnemyStatus ; $bea3: 20 ad be      |
            jsr HandleEnemyDestruction ; $bea6: 20 a1 c3 | update a bunch of enemy state
Next_bea9:  jsr UpdateEnemySprites ; $bea9: 20 98 c4  . update sprites (regardless of the game state)
Ret_beac:   rts                ; $beac: 60        . return

;-------------------------------------------------------------------------------
UpdateEnemyStatus:
            lda EnemyGateState ; $bead: ad 0f 01  .
            cmp #$05           ; $beb0: c9 05     |
            beq SpawnEnemy     ; $beb2: f0 37     | if the gate state is 5, go spawn the enemy itself
            cmp #$00           ; $beb4: c9 00     .
            bne Ret_beea       ; $beb6: d0 32     | if the state is 0,
            ldx #$00           ; $beb8: a2 00       .
            ldy #$00           ; $beba: a0 00       | for each enemy,
Loop_bebc:  lda EnemyActive,x  ; $bebc: b5 95       .
            ora EnemyDestrFrame,x ; $f893: 15 98    |
            bne __beca         ; $bec0: d0 08       | if the enemy isn't alive or being destroyed,
            lda EnemySpawnTimerHi,y ; $bec2: b9 c0 00 .
            ora EnemySpawnTimerLo,y ; $bec5: 19 c1 00 |
            beq BeginSpawnEnemy; $bec8: f0 08         | if we're allowed to spawn an enemy, get ready to spawn a new one
__beca:     iny                ; $beca: c8          .
            iny                ; $becb: c8          |
            inx                ; $becc: e8          |
            cpx #$03           ; $becd: e0 03       |
            bne Loop_bebc      ; $becf: d0 eb       | loop x = 0 1 2, y = 0 2 4
            rts                ; $bed1: 60          . return

;-------------------------------------------------------------------------------
BeginSpawnEnemy:
            stx EnemySpawnIndex; $bed2: 86 ad     . store index of the enemy to spawn for later
            lda #$01           ; $bed4: a9 01     .
            sta EnemyGateState ; $bed6: 8d 0f 01  | initialize gate state = 1
            ldx #$00           ; $bed9: a2 00     .
            stx EnemyGateIndex ; $bedb: 8e 10 01  | start with gate index = 0
            lda PaddleLeftEdge ; $bede: ad 1a 01  .
            cmp #$68           ; $bee1: c9 68     |
            bcc Ret_beea       ; $bee3: 90 05     | if the paddle left edge >= 0x68,
            ldx #$01           ; $bee5: a2 01       .
            stx EnemyGateIndex ; $bee7: 8e 10 01    | set gate index = 1
Ret_beea:   rts                ; $beea: 60        . return

;-------------------------------------------------------------------------------
SpawnEnemy: inc EnemyGateState ; $beeb: ee 0f 01  . advance the gate state
            ldx EnemySpawnIndex; $beee: a6 ad     . load index of the enemy to spawn
            lda #$00           ; $bef0: a9 00     .
            sta EnemyMovementType,x; $bef2: 95 9e | set movement type = normal   
            lda #$01           ; $bef4: a9 01     .
            sta EnemyActive,x  ; $bef6: 95 95     | mark the enemy active
            lda #$01           ; $bef8: a9 01     .
            sta EnemyExiting,x ; $befa: 95 9b     | set the enemy-exiting flag
            lda #$03           ; $befc: a9 03     .
            sta EnemyMoveTimer,x ; $befe: 95 bd   | set movement timer = 3
            lda #$06           ; $bf00: a9 06     .
            sta EnemyAnimTimer,x; $bf02: 95 d5    | set animation timer = 6
            lda #$00           ; $bf04: a9 00     
            sta $d2,x          ; $bf06: 95 d2     
            lda CurrentLevel   ; $bf08: a5 1a     
            sec                ; $bf0a: 38        
            sbc #$01           ; $bf0b: e9 01     
            and #$03           ; $bf0d: 29 03     
            sta $0131          ; $bf0f: 8d 31 01  
            asl                ; $bf12: 0a        
            tay                ; $bf13: a8        
            txa                ; $bf14: 8a        
            asl                ; $bf15: 0a        
            tax                ; $bf16: aa        
            lda __c5b2,y       ; $bf17: b9 b2 c5   .
            sta EnemyCircleAddrLo,x ; $bf1a: 95 cc |
            lda __c5b3,y       ; $bf1c: b9 b3 c5   |
            sta EnemyCircleAddrHi,x ; $bf1f: 95 cd | set up circling-movement table address
            lda $0131          ; $bf21: ad 31 01  
            asl                ; $bf24: 0a        
            asl                ; $bf25: 0a        
            clc                ; $bf26: 18        
            adc $0131          ; $bf27: 6d 31 01  
            asl                ; $bf2a: 0a        
            sta $0132          ; $bf2b: 8d 32 01  
            lda #$80           ; $bf2e: a9 80     
            sta $c6,x          ; $bf30: 95 c6     
            lda #$c5           ; $bf32: a9 c5     
            sta $c7,x          ; $bf34: 95 c7     
            clc                ; $bf36: 18        
            lda $c6,x          ; $bf37: b5 c6     
            adc $0132          ; $bf39: 6d 32 01  
            sta $c6,x          ; $bf3c: 95 c6     
            lda $c7,x          ; $bf3e: b5 c7     
            adc #$00           ; $bf40: 69 00     
            sta $c7,x          ; $bf42: 95 c7     
            lda ($c6,x)        ; $bf44: a1 c6     
            sta $0131          ; $bf46: 8d 31 01  
            ldx EnemySpawnIndex; $bf49: a6 ad     .
            lda #$02           ; $bf4b: a9 02     |
            sta EnemyMoveDir,x ; $bf4d: 95 ba     |
            lda #$34           ; $bf4f: a9 34     |
            sta $0132          ; $bf51: 8d 32 01  |
            lda EnemyGateIndex ; $bf54: ad 10 01  |
            cmp #$00           ; $bf57: c9 00     |
            beq __bf64         ; $bf59: f0 09     | if spawning from the left gate, set move dir = 2 and spawn x = 0x34
            lda #$00           ; $bf5b: a9 00     .
            sta EnemyMoveDir,x ; $bf5d: 95 ba     |
            lda #$8c           ; $bf5f: a9 8c     |
            sta $0132          ; $bf61: 8d 32 01  | else set move dir = 0 and spawn x = 0x8c
__bf64:     lda #$00           ; $bf64: a9 00     .
            sta EnemyY,x       ; $bf66: 95 ae     | set spawn y = 0
            lda $0131          ; $bf68: ad 31 01  
            sta EnemyAnimFrame,x; $bf6b: 95 b1    
            lda #$01           ; $bf6d: a9 01     
            sta $b4,x          ; $bf6f: 95 b4     
            lda $0132          ; $bf71: ad 32 01  .
            sta EnemyX,x       ; $bf74: 95 b7     | assign previously-calculated spawn x
            rts                ; $bf76: 60        . return

;-------------------------------------------------------------------------------
AdvanceEnemies:
            ldx #$00           ; $bf77: a2 00     . for enemies 0..2
Loop_bf79:  lda EnemyActive,x  ; $bf79: b5 95     .
            cmp #$00           ; $bf7b: c9 00     |
            beq Next_bf97      ; $bf7d: f0 18     | if the enemy is active,
            lda EnemyMoveTimer,x ; $bf7f: b5 bd     .
            cmp #$00           ; $bf81: c9 00       |
            beq AdvanceOneEnemy; $bf83: f0 05       | if the enemy move timer is > 0,
            dec EnemyMoveTimer,x ; $bf85: d6 bd       . decrement timer value
            jmp Next_bf97      ; $bf87: 4c 97 bf      . move on to the next iteration

;-------------------------------------------------------------------------------
AdvanceOneEnemy:
            lda #$03           ; $bf8a: a9 03       .
            sta EnemyMoveTimer,x ; $bf8c: 95 bd     | else set enemy timer = 3
            jsr CheckNormalMovement ; $bf8e: 20 9d bf   .
            jsr CheckCirclingMovement ; $bf91: 20 0d c0 |
            jsr CheckDownMovement ; $bf94: 20 b0 c0     | advance the enemy's position
Next_bf97:  inx                ; $bf97: e8        .
            cpx #$03           ; $bf98: e0 03     |
            bne Loop_bf79      ; $bf9a: d0 dd     | loop 0..2
            rts                ; $bf9c: 60        . return

;-------------------------------------------------------------------------------
CheckNormalMovement:
            lda EnemyMovementType,x; $bf9d: b5 9e .
            cmp #$00           ; $bf9f: c9 00     |
            beq Next_bfa4      ; $bfa1: f0 01     |
            rts                ; $bfa3: 60        | if the enemy movement pattern is 0 (normal movement),

;-------------------------------------------------------------------------------
Next_bfa4:  lda EnemyExiting,x ; $bfa4: b5 9b     .
            beq Next_bfb9      ; $bfa6: f0 11     | if the enemy is exiting,
            inc EnemyY,x       ; $bfa8: f6 ae       . bump it down by a pixel
            lda EnemyY,x       ; $bfaa: b5 ae       .
            cmp #$10           ; $bfac: c9 10       |
            bcs Next_bfb1      ; $bfae: b0 01       | if it's >= 0x10, activate it in the field
            rts                ; $bfb0: 60          . else return

;-------------------------------------------------------------------------------
Next_bfb1:  lda #$00           ; $bfb1: a9 00     .
            sta EnemyExiting,x ; $bfb3: 95 9b     | reset exiting flag
            inc EnemyGateState ; $bfb5: ee 0f 01  . move to next gate state
            rts                ; $bfb8: 60        . return

;-------------------------------------------------------------------------------
Next_bfb9:  jsr DoNormalEnemyMove ; $bfb9: 20 c6 c0  . go move the enemy
            lda EnemyY,x       ; $bfbc: b5 ae     .
            cmp #$b0           ; $bfbe: c9 b0     |
            bcc __bfc7         ; $bfc0: 90 05     | if the enemy y is >= 0xb0,
            lda #$02           ; $bfc2: a9 02       .
            sta EnemyMovementType,x; $bfc4: 95 9e   | set enemy movement pattern = 2
            rts                ; $bfc6: 60          . return

;-------------------------------------------------------------------------------
__bfc7:     cmp #$60           ; $bfc7: c9 60     .
            bcc Ret_c00c       ; $bfc9: 90 41     | else if the enemy y is >= 0x60,
            sec                ; $bfcb: 38          .
            sbc #$10           ; $bfcc: e9 10       |
            lsr                ; $bfce: 4a          |
            lsr                ; $bfcf: 4a          |
            lsr                ; $bfd0: 4a          |
            sta $0131          ; $bfd1: 8d 31 01    |
            asl                ; $bfd4: 0a          |
            asl                ; $bfd5: 0a          |
            clc                ; $bfd6: 18          |
            adc $0131          ; $bfd7: 6d 31 01    |
            asl                ; $bfda: 0a          |
            clc                ; $bfdb: 18          |
            adc $0131          ; $bfdc: 6d 31 01    |
            adc BlockRamAddrLo ; $bfdf: 65 84       |
            sta $86            ; $bfe1: 85 86       |
            lda BlockRamAddrHi ; $bfe3: a5 85       |
            adc #$00           ; $bfe5: 69 00       |
            sta $87            ; $bfe7: 85 87       | calculate address of the first block in the top row the enemy's occupying
            ldy #$00           ; $bfe9: a0 00       .
Loop_bfeb:  lda ($86),y        ; $bfeb: b1 86       |
            cmp #$00           ; $bfed: c9 00       |
            bne Ret_c00c       ; $bfef: d0 1b       | if there are any blocks from [index -> index + 0x23] inclusive, return
            iny                ; $bff1: c8          .
            cpy #$24           ; $bff2: c0 24       |
            bne Loop_bfeb      ; $bff4: d0 f5       | for y = 0..35
            lda #$01           ; $bff6: a9 01       .
            sta EnemyMovementType,x; $bff8: 95 9e   | there are no blocks in the range; set enemy movement pattern = 1
            lda #$00           ; $bffa: a9 00       .
            sta EnemyCircleHalf,x ; $bffc: 95 a4    |
            sta EnemyCircleStage,x ; $bffe: 95 a1   |
            sta EnemyCircleDir,x ; $c000: 95 a7     | set circle stage = 0, circle half = 0 (bottom), circle dir = 0 (clockwise)
            lda EnemyX,x       ; $c002: b5 b7       .
            cmp #$68           ; $c004: c9 68       |
            bcs Ret_c00c       ; $c006: b0 04       | if enemy x < 0x68,
            lda #$01           ; $c008: a9 01         .
            sta EnemyCircleDir,x ; $c00a: 95 a7       | set circle dir = 1 (counterclockwise)
Ret_c00c:   rts                ; $c00c: 60        . return

;-------------------------------------------------------------------------------
CheckCirclingMovement:
            lda EnemyMovementType,x; $c00d: b5 9e .
            cmp #$01           ; $c00f: c9 01     |
            beq __c014         ; $c011: f0 01     |
            rts                ; $c013: 60        | if the movement pattern is "circling", continue

;-------------------------------------------------------------------------------
__c014:     txa                ; $c014: 8a        .
            pha                ; $c015: 48        | save x for later
            asl                ; $c016: 0a        .
            tax                ; $c017: aa        | set x *= 2
            lda EnemyCircleAddrLo,x ; $c018: b5 cc  .
            sta $86            ; $c01a: 85 86       |
            lda EnemyCircleAddrHi,x ; $c01c: b5 cd  |
            sta $87            ; $c01e: 85 87       | copy circling movement table[x] to $86 / $87
            pla                ; $c020: 68        .
            tax                ; $c021: aa        | restore x
            ldy EnemyCircleStage,x ; $c022: b4 a1 .
            lda ($86),y        ; $c024: b1 86     |
            cmp #$80           ; $c026: c9 80     |
            bne __c034         ; $c028: d0 0a     | if circle stage val == 0x80,
            dey                ; $c02a: 88          .
            dey                ; $c02b: 88          |
            sty EnemyCircleStage,x ; $c02c: 94 a1   | start decrementing the circling stage
            lda EnemyCircleHalf,x ; $c02e: b5 a4    .
            eor #$01           ; $c030: 49 01       |
            sta EnemyCircleHalf,x ; $c032: 95 a4    | flip circle-half value
__c034:     lda ($86),y        ; $c034: b1 86     .
            clc                ; $c036: 18        |
            adc EnemyY,x       ; $c037: 75 ae     |
            sta EnemyY,x       ; $c039: 95 ae     | set enemy y += circle table_y[stage]
            iny                ; $c03b: c8        .
            lda EnemyCircleDir,x ; $c03c: b5 a7   |
            eor EnemyCircleHalf,x ; $c03e: 55 a4  | if we're on the top semicircle moving counterclockwise
            bne __c04c         ; $c040: d0 0a     | or we're on the bottom semicircle moving clockwise (i.e. moving left),
            lda ($86),y        ; $c042: b1 86       .
            clc                ; $c044: 18          |
            adc EnemyX,x       ; $c045: 75 b7       |
            sta EnemyX,x       ; $c047: 95 b7       | set enemy x += circle table_x[stage]
            jmp __c057         ; $c049: 4c 57 c0  . else

;-------------------------------------------------------------------------------
__c04c:     lda ($86),y        ; $c04c: b1 86       .
            eor #$ff           ; $c04e: 49 ff       |
            clc                ; $c050: 18          |
            adc #$01           ; $c051: 69 01       | flip the bits and add one (negate the value)
            adc EnemyX,x       ; $c053: 75 b7       .
            sta EnemyX,x       ; $c055: 95 b7       | set enemy x -= circle table_x[stage]
__c057:     lda EnemyCircleHalf,x ; $c057: b5 a4  .
            cmp #$00           ; $c059: c9 00     |
            bne __c064         ; $c05b: d0 07     | if we're on the bottom semicircle,
            inc EnemyCircleStage,x ; $c05d: f6 a1   .
            inc EnemyCircleStage,x ; $c05f: f6 a1   | set stage += 2
            jmp __c06e         ; $c061: 4c 6e c0  . else

;-------------------------------------------------------------------------------
__c064:     dec EnemyCircleStage,x ; $c064: d6 a1   .
            dec EnemyCircleStage,x ; $c066: d6 a1   | set stage -= 2
            bne __c06e         ; $c068: d0 04       . if stage == 0,
            lda #$00           ; $c06a: a9 00         .
            sta EnemyCircleHalf,x ; $c06c: 95 a4      | set circle half = 0 (bottom)
__c06e:     lda EnemyX,x       ; $c06e: b5 b7     .
            cmp #$11           ; $c070: c9 11     |
            bcs __c08d         ; $c072: b0 19     | if enemy x < 0x11,
            lda #$10           ; $c074: a9 10       .
            sta EnemyX,x       ; $c076: 95 b7       | set enemy x = 0x10
            lda EnemyCircleDir,x ; $c078: b5 a7     .
            beq __c080         ; $c07a: f0 04       |
            lda EnemyCircleHalf,x ; $c07c: b5 a4    |
            beq __c0a5         ; $c07e: f0 25       | if !(circle dir == 1 and circle half == 0),
__c080:     lda #$00           ; $c080: a9 00         .
            sta EnemyCircleStage,x ; $c082: 95 a1     |
            sta EnemyCircleHalf,x ; $c084: 95 a4      | set circle stage = 0 and half = 0 (bottom)
            lda #$01           ; $c086: a9 01         .
            sta EnemyCircleDir,x ; $c088: 95 a7       | set circle dir = 1 (counterclockwise)
            jmp __c0a5         ; $c08a: 4c a5 c0  .

;-------------------------------------------------------------------------------
__c08d:     cmp #$b0           ; $c08d: c9 b0     | else if enemy x >= 0xb0,
            bcc __c0a5         ; $c08f: 90 14       .
            lda #$b0           ; $c091: a9 b0       |
            sta EnemyX,x       ; $c093: 95 b7       | set enemy x = 0xb0
            lda EnemyCircleDir,x ; $c095: b5 a7     .
            bne __c09d         ; $c097: d0 04       |
            lda EnemyCircleHalf,x ; $c099: b5 a4    |
            beq __c0a5         ; $c09b: f0 08       | if !(circle dir == 0 and circle half == 0),
__c09d:     lda #$00           ; $c09d: a9 00         .
            sta EnemyCircleStage,x ; $c09f: 95 a1     |
            sta EnemyCircleHalf,x ; $c0a1: 95 a4      |
            sta EnemyCircleDir,x ; $c0a3: 95 a7       | set circle stage = 0, half = 0 (bottom), and dir = 0 (clockwise)
__c0a5:     lda EnemyY,x       ; $c0a5: b5 ae     .
            cmp #$b0           ; $c0a7: c9 b0     |
            bcc Ret_c0af       ; $c0a9: 90 04     | if enemy y >= 0xb0,
            lda #$02           ; $c0ab: a9 02       .
            sta EnemyMovementType,x ; $c0ad: 95 9e  | set movement pattern = 2 (downward only)
Ret_c0af:   rts                ; $c0af: 60        . return

;-------------------------------------------------------------------------------
CheckDownMovement:
            lda EnemyMovementType,x; $c0b0: b5 9e .
            cmp #$02           ; $c0b2: c9 02     |
            beq Next_c0b7      ; $c0b4: f0 01     |
            rts                ; $c0b6: 60        | if the enemy movement pattern is 2 (move down only),

;-------------------------------------------------------------------------------
Next_c0b7:  inc EnemyY,x       ; $c0b7: f6 ae       . move down
            lda EnemyY,x       ; $c0b9: b5 ae       .
            cmp #$f0           ; $c0bb: c9 f0       |
            bcc Ret_c0c5       ; $c0bd: 90 06       | if the enemy y is >= 0xf0,
            lda #$00           ; $c0bf: a9 00         .
            sta EnemyActive,x  ; $c0c1: 95 95         | mark the enemy as inactive
            sta EnemyMovementType,x; $c0c3: 95 9e     | clear the movement pattern
Ret_c0c5:   rts                ; $c0c5: 60          . return

;-------------------------------------------------------------------------------
DoNormalEnemyMove:
            lda EnemyMoveDir,x ; $c0c6: b5 ba     .
            cmp #$00           ; $c0c8: c9 00     |
            bne Next_c103      ; $c0ca: d0 37     | if enemy move dir == 0,
            inc EnemyY,x       ; $c0cc: f6 ae       . move down
            jsr CheckVertBlockCollis ; $c0ce: 20 b4 c1 . check for y-collisions
            bcs Next_c0d7      ; $c0d1: b0 04       . if collided, go to Next_c0d7
            jsr CheckEnemyCollisGoingDown ; $c0d3: 20 3d c2 . else do sub CheckEnemyCollisGoingDown
            rts                ; $c0d6: 60          . return

;-------------------------------------------------------------------------------
Next_c0d7:  dec EnemyY,x       ; $c0d7: d6 ae       .
            inc EnemyX,x       ; $c0d9: f6 b7       | cancel previous y-movement and go right instead
            jsr CheckHorizBlockCollis ; $c0db: 20 ee c1 . check for x-collisions
            bcs Next_c0e4      ; $c0de: b0 04       . if collided, go to Next_c0e4
            jsr CheckEnemyCollisGoingRight ; $c0e0: 20 99 c2    . else do sub CheckEnemyCollisGoingRight
            rts                ; $c0e3: 60          . return

;-------------------------------------------------------------------------------
Next_c0e4:  dec EnemyX,x       ; $c0e4: d6 b7       . cancel previous x-movement
            lda EnemyX,x       ; $c0e6: b5 b7       .
            cmp #$b0           ; $c0e8: c9 b0       |
            beq Next_c0fe      ; $c0ea: f0 12       | if the enemy x == 0xb0, go set move dir = 2
            stx $012f          ; $c0ec: 8e 2f 01    . save x for later
            jsr _RandNum       ; $c0ef: 20 59 92    . grab a random number
            ldx $012f          ; $c0f2: ae 2f 01    . restore x
            and #$01           ; $c0f5: 29 01       .
            beq Next_c0fe      ; $c0f7: f0 05       | if the rn is even, go set move dir = 2
            lda #$01           ; $c0f9: a9 01       .
            sta EnemyMoveDir,x ; $c0fb: 95 ba       | else switch to move dir = 1
            rts                ; $c0fd: 60          . return

;-------------------------------------------------------------------------------
Next_c0fe:  lda #$02           ; $c0fe: a9 02       .
            sta EnemyMoveDir,x ; $c100: 95 ba       | switch to move dir = 2
            rts                ; $c102: 60          . return

;-------------------------------------------------------------------------------
Next_c103:  lda EnemyMoveDir,x ; $c103: b5 ba     .
            cmp #$01           ; $c105: c9 01     |
            bne __c12c         ; $c107: d0 23     | if move dir == 1,
            inc EnemyX,x       ; $c109: f6 b7       . move right
            jsr CheckHorizBlockCollis ; $c10b: 20 ee c1 . check for collisions
            bcs Next_c118      ; $c10e: b0 08       . if collided, go to Next_c118
            lda #$00           ; $c110: a9 00       .
            sta EnemyMoveDir,x ; $c112: 95 ba       | set move dir = 0
            jsr CheckEnemyCollisGoingRight         ; $c114: 20 99 c2    . else do sub CheckEnemyCollisGoingRight
            rts                ; $c117: 60          . return

;-------------------------------------------------------------------------------
Next_c118:  dec EnemyX,x       ; $c118: d6 b7       .
            dec EnemyY,x       ; $c11a: d6 ae       | cancel previous x-movement and go up instead
            jsr CheckVertBlockCollis ; $c11c: 20 b4 c1  . check for collisions
            bcs Next_c125      ; $c11f: b0 04     . if collided, go to Next_c125
            jsr CheckEnemyCollisGoingUp; $c121: 20 6d c2  . else do sub CheckEnemyCollisGoingUp
            rts                ; $c124: 60        . return

;-------------------------------------------------------------------------------
Next_c125:  inc EnemyY,x       ; $c125: f6 ae     . cancel previous y-movement
            lda #$02           ; $c127: a9 02     .
            sta EnemyMoveDir,x ; $c129: 95 ba     | set move dir = 2
            rts                ; $c12b: 60        . return

;-------------------------------------------------------------------------------
__c12c:     lda EnemyMoveDir,x ; $c12c: b5 ba     .
            cmp #$02           ; $c12e: c9 02     |
            bne __c169         ; $c130: d0 37     | if move dir == 2,
            inc EnemyY,x       ; $c132: f6 ae       . move down
            jsr CheckVertBlockCollis ; $c134: 20 b4 c1  . check for collisions
            bcs Next_c13d      ; $c137: b0 04       . if collided, go to Next_c13d
            jsr CheckEnemyCollisGoingDown ; $c139: 20 3d c2    . else do sub CheckEnemyCollisGoingDown
            rts                ; $c13c: 60          . return

;-------------------------------------------------------------------------------
Next_c13d:  dec EnemyY,x       ; $c13d: d6 ae       .
            dec EnemyX,x       ; $c13f: d6 b7       | cancel previous y-movement and go left instead
            jsr CheckHorizBlockCollis ; $c141: 20 ee c1  . check for collisions
            bcs Next_c14a      ; $c144: b0 04       . if collided, go to Next_c14a
            jsr CheckEnemyCollisGoingLeft ; $c146: 20 81 c2    . else do sub CheckEnemyCollisGoingLeft
            rts                ; $c149: 60          . return

;-------------------------------------------------------------------------------
Next_c14a:  inc EnemyX,x       ; $c14a: f6 b7       . cancel previous x-movement
            lda EnemyX,x       ; $c14c: b5 b7       .
            cmp #$10           ; $c14e: c9 10       |
            beq __c164         ; $c150: f0 12       | if enemy x == 0x10, go set move dir = 3
            stx $012f          ; $c152: 8e 2f 01    . save x
            jsr _RandNum       ; $c155: 20 59 92    . get a random number
            ldx $012f          ; $c158: ae 2f 01    . restore x
            and #$01           ; $c15b: 29 01       .
            beq __c164         ; $c15d: f0 05       | if rn is even, go set move dir = 3
            lda #$00           ; $c15f: a9 00       .
            sta EnemyMoveDir,x ; $c161: 95 ba       | else set move dir = 0
            rts                ; $c163: 60          . return

;-------------------------------------------------------------------------------
__c164:     lda #$03           ; $c164: a9 03       .
            sta EnemyMoveDir,x ; $c166: 95 ba       | set move dir = 3
            rts                ; $c168: 60          . return

;-------------------------------------------------------------------------------
__c169:     lda EnemyMoveDir,x ; $c169: b5 ba     .
            cmp #$03           ; $c16b: c9 03     |
            bne __c192         ; $c16d: d0 23     | if enemy movement dir == 3,
            dec EnemyX,x       ; $c16f: d6 b7       . move left
            jsr CheckHorizBlockCollis ; $c171: 20 ee c1  . check for collisions
            bcs Next_c17e      ; $c174: b0 08       . if collided, go to Next_c17e
            lda #$02           ; $c176: a9 02       .
            sta EnemyMoveDir,x ; $c178: 95 ba       | else set move dir = 2
            jsr CheckEnemyCollisGoingLeft ; $c17a: 20 81 c2    . do sub CheckEnemyCollisGoingLeft
            rts                ; $c17d: 60          . return

;-------------------------------------------------------------------------------
Next_c17e:  inc EnemyX,x       ; $c17e: f6 b7       .
            dec EnemyY,x       ; $c180: d6 ae       | cancel x-movement and go up instead
            jsr CheckVertBlockCollis ; $c182: 20 b4 c1  . check for collisions
            bcs Next_c18b      ; $c185: b0 04       . if collided, go to Next_c18b
            jsr CheckEnemyCollisGoingUp ; $c187: 20 6d c2    . else do sub CheckEnemyCollisGoingUp
            rts                ; $c18a: 60          . return

;-------------------------------------------------------------------------------
Next_c18b:  inc EnemyY,x       ; $c18b: f6 ae       . cancel y-movement
            lda #$00           ; $c18d: a9 00       .
            sta EnemyMoveDir,x ; $c18f: 95 ba       | set move dir = 2
            rts                ; $c191: 60          . return

;-------------------------------------------------------------------------------
__c192:     lda EnemyMoveDir,x ; $c192: b5 ba     .
            cmp #$04           ; $c194: c9 04     |
            bne Next_c1ad      ; $c196: d0 15     | if enemy movement dir == 4,
            lda EnemyDescendTimer,x; $c198: b5 aa   .
            cmp #$00           ; $c19a: c9 00       |
            beq Next_c1ad      ; $c19c: f0 0f       | if the descent timer has finished, go reset move dir to 0
            dec EnemyDescendTimer,x; $c19e: d6 aa   . else decrement descent timer
            dec EnemyY,x       ; $c1a0: d6 ae       . move up
            jsr CheckVertBlockCollis ; $c1a2: 20 b4 c1  . check for collisions
            bcs Next_c1ab      ; $c1a5: b0 04       . if collided, go to Next_c1ab
            jsr CheckEnemyCollisGoingUp ; $c1a7: 20 6d c2    . else do sub CheckEnemyCollisGoingUp
            rts                ; $c1aa: 60          . return

;-------------------------------------------------------------------------------
Next_c1ab:  inc EnemyY,x       ; $c1ab: f6 ae     . move down
Next_c1ad:  lda #$00           ; $c1ad: a9 00     .
            sta EnemyMoveDir,x ; $c1af: 95 ba     | set move dir = 0
            sta EnemyDescendTimer,x; $c1b1: 95 aa . set descent timer = 0
            rts                ; $c1b3: 60        . return

;-------------------------------------------------------------------------------
CheckVertBlockCollis:
            lda EnemyY,x       ; $c1b4: b5 ae     .
            cmp #$0f           ; $c1b6: c9 0f     |
            beq Ret1_c1ea      ; $c1b8: f0 30     | if enemy y == 0xf, return 1
            ldy #$00           ; $c1ba: a0 00     . prepare y = 0 (this block)
            lda EnemyY,x       ; $c1bc: b5 ae     .
            and #$07           ; $c1be: 29 07     |
            cmp #$07           ; $c1c0: c9 07     |
            beq Next_c1ce      ; $c1c2: f0 0a     | if (enemy y & 7) != 7,
            ldy #$16           ; $c1c4: a0 16       . prepare y = 0x16 (two blocks down)
            lda EnemyY,x       ; $c1c6: b5 ae       .
            and #$07           ; $c1c8: 29 07       |
            cmp #$01           ; $c1ca: c9 01       |
            bne Ret0_c1ec      ; $c1cc: d0 1e       | if (enemy y & 7) != 1, return 0
Next_c1ce:  sty $0131          ; $c1ce: 8c 31 01  . move y to $0131
            jsr CalcBlockAddrAtEnemyIndex ; $c1d1: 20 ef c2 . set up the block address corresponding to the enemy cell
            ldy $0131          ; $c1d4: ac 31 01  . restore y from $0131
            lda ($86),y        ; $c1d7: b1 86     . load the block at the calculated address (or the one two rows down)
            cmp #$00           ; $c1d9: c9 00     .
            bne Ret1_c1ea      ; $c1db: d0 0d     | if there's a block there, return 1
            lda EnemyX,x       ; $c1dd: b5 b7     .
            and #$0f           ; $c1df: 29 0f     |
            beq Ret0_c1ec      ; $c1e1: f0 09     | if (enemy x & 0xf == 0), return 0
            iny                ; $c1e3: c8        .
            lda ($86),y        ; $c1e4: b1 86     | else grab the block one to the right
            cmp #$00           ; $c1e6: c9 00     .
            beq Ret0_c1ec      ; $c1e8: f0 02     | if there's no block there, return 0
Ret1_c1ea:  sec                ; $c1ea: 38        .
            rts                ; $c1eb: 60        | return 1

;-------------------------------------------------------------------------------
Ret0_c1ec:  clc                ; $c1ec: 18        .
            rts                ; $c1ed: 60        | return 0

;-------------------------------------------------------------------------------
CheckHorizBlockCollis:
            lda EnemyX,x       ; $c1ee: b5 b7     .
            cmp #$10           ; $c1f0: c9 10     |
            bcc Ret1_c1f8      ; $c1f2: 90 04     | if enemy x < 0x10, return 1
            cmp #$b1           ; $c1f4: c9 b1     .
            bcc Next_c1fa      ; $c1f6: 90 02     | if enemy x >= 0xb1, return 1
Ret1_c1f8:  sec                ; $c1f8: 38        .
            rts                ; $c1f9: 60        | return 1

;-------------------------------------------------------------------------------
Next_c1fa:  ldy #$00           ; $c1fa: a0 00     . prepare y = 0 (this block)
            lda EnemyX,x       ; $c1fc: b5 b7     .
            and #$0f           ; $c1fe: 29 0f     |
            cmp #$0f           ; $c200: c9 0f     |
            beq Next_c20e      ; $c202: f0 0a     | if (enemy x & 0xf) != 0xf,
            ldy #$01           ; $c204: a0 01       . prepare y = 1 (one right)
            lda EnemyX,x       ; $c206: b5 b7       .
            and #$0f           ; $c208: 29 0f       |
            cmp #$01           ; $c20a: c9 01       |
            bne Ret0_c23b      ; $c20c: d0 2d       | if (enemy x & 0xf) != 1, return 0
Next_c20e:  sty $0131          ; $c20e: 8c 31 01  . store y for later
            jsr CalcBlockAddrAtEnemyIndex ; $c211: 20 ef c2  . grab the block in the enemy cell
            ldy $0131          ; $c214: ac 31 01  . restore y
            lda ($86),y        ; $c217: b1 86     .
            cmp #$00           ; $c219: c9 00     |
            bne Ret1_c239      ; $c21b: d0 1c     | if there's a block in the cell (this one or one right), return 1
            clc                ; $c21d: 18        .
            tya                ; $c21e: 98        |
            adc #$0b           ; $c21f: 69 0b     |
            tay                ; $c221: a8        | bump the index down by a row
            lda ($86),y        ; $c222: b1 86     .
            cmp #$00           ; $c224: c9 00     |
            bne Ret1_c239      ; $c226: d0 11     | if there's a block in the cell (one down or one down right), return 1
            lda EnemyY,x       ; $c228: b5 ae     .
            and #$07           ; $c22a: 29 07     |
            beq Ret0_c23b      ; $c22c: f0 0d     | if (enemy y & 7) == 0, return 0
            clc                ; $c22e: 18        .
            tya                ; $c22f: 98        |
            adc #$0b           ; $c230: 69 0b     | (the enemy overlaps the next row)
            tay                ; $c232: a8        | bump the index down by another row
            lda ($86),y        ; $c233: b1 86     .
            cmp #$00           ; $c235: c9 00     |
            beq Ret0_c23b      ; $c237: f0 02     | if there's no block in the cell (two down or two down one right), return 0
Ret1_c239:  sec                ; $c239: 38        .
            rts                ; $c23a: 60        | return 1

;-------------------------------------------------------------------------------
Ret0_c23b:  clc                ; $c23b: 18        .
            rts                ; $c23c: 60        | return 0

;-------------------------------------------------------------------------------
CheckEnemyCollisGoingDown:
            jsr CheckOtherEnemyCollis; $c23d: 20 ad c2  .
            bcc Ret_c26b       ; $c240: 90 29     | if there's a collision with another enemy,
            lda EnemyY,x       ; $c242: b5 ae       .
            cmp EnemyY,y        ; $c244: d9 ae 00   |
            bcs Ret_c26b       ; $c247: b0 22       | if (enemy[x].y < enemy[y].y),
            txa                ; $c249: 8a            .
            pha                ; $c24a: 48            | save x for later
            jsr _RandNum       ; $c24b: 20 59 92      . grab a random number
            and #$03           ; $c24e: 29 03         .
            cmp #$00           ; $c250: c9 00         |
            beq Next_c25f      ; $c252: f0 0b         |
            cmp #$02           ; $c254: c9 02         .
            beq Next_c25f      ; $c256: f0 07         | if rn % 4 == 0 or 2, go set move dir = 4 
            tay                ; $c258: a8            .
            pla                ; $c259: 68            |
            tax                ; $c25a: aa            |
            sty EnemyMoveDir,x ; $c25b: 94 ba         | else set move dir = rn (1 or 3)
            sec                ; $c25d: 38            .
            rts                ; $c25e: 60            | return 1

;-------------------------------------------------------------------------------
Next_c25f:  pla                ; $c25f: 68            .
            tax                ; $c260: aa            |
            lda #$04           ; $c261: a9 04         |
            sta EnemyMoveDir,x ; $c263: 95 ba         | set move dir = 4
            lda #$20           ; $c265: a9 20         .
            sta EnemyDescendTimer,x ; $c267: 95 aa    | set descent timer = 0x20
            sec                ; $c269: 38            .
            rts                ; $c26a: 60            | return 1

;-------------------------------------------------------------------------------
Ret_c26b:   clc                ; $c26b: 18        .
            rts                ; $c26c: 60        | return 0

;-------------------------------------------------------------------------------
CheckEnemyCollisGoingUp:
            jsr CheckOtherEnemyCollis; $c26d: 20 ad c2  .
            bcc Ret_c27f       ; $c270: 90 0d     | if there's a collision with another enemy,
            lda EnemyY,x       ; $c272: b5 ae       .
            cmp EnemyY,y       ; $c274: d9 ae 00    |
            bcc Ret_c27f       ; $c277: 90 06       | if (enemy[x].y >= enemy[y].y),
            lda #$00           ; $c279: a9 00         .
            sta EnemyMoveDir,x ; $c27b: 95 ba         | set move dir = 0
            sec                ; $c27d: 38            .
            rts                ; $c27e: 60            | return 1

;-------------------------------------------------------------------------------
Ret_c27f:   clc                ; $c27f: 18        .
            rts                ; $c280: 60        | return 0

;-------------------------------------------------------------------------------
CheckEnemyCollisGoingLeft:
            jsr CheckOtherEnemyCollis; $c281: 20 ad c2  .
            bcc __c297         ; $c284: 90 11     | if there's a collision with another enemy,
            lda EnemyX,x       ; $c286: b5 b7       .
            cmp EnemyX,y       ; $c288: d9 b7 00    |
            bcc __c297         ; $c28b: 90 0a       | if (enemy[x].x >= enemy[y].x),
            lda #$04           ; $c28d: a9 04         .
            sta EnemyMoveDir,x ; $c28f: 95 ba         | set move dir = 4
            lda #$20           ; $c291: a9 20         .
            sta EnemyDescendTimer,x ; $c293: 95 aa    | set descent timer = 0x20
            sec                ; $c295: 38            .
            rts                ; $c296: 60            | return 1

;-------------------------------------------------------------------------------
__c297:     clc                ; $c297: 18        .
            rts                ; $c298: 60        | return 0

;-------------------------------------------------------------------------------
CheckEnemyCollisGoingRight:
            jsr CheckOtherEnemyCollis; $c299: 20 ad c2  .
            bcc __c2ab         ; $c29c: 90 0d     | if there's a collision with another enemy,
            lda EnemyX,x       ; $c29e: b5 b7       .
            cmp EnemyX,y       ; $c2a0: d9 b7 00    |
            bcs __c2ab         ; $c2a3: b0 06       | if (enemy[x].x < enemy[y].x),
            lda #$02           ; $c2a5: a9 02         .
            sta EnemyMoveDir,x ; $c2a7: 95 ba         | set move dir = 2
            sec                ; $c2a9: 38            .
            rts                ; $c2aa: 60            | return 1

;-------------------------------------------------------------------------------
__c2ab:     clc                ; $c2ab: 18        .
            rts                ; $c2ac: 60        | return 0

;-------------------------------------------------------------------------------
CheckOtherEnemyCollis:
            ldy #$00           ; $c2ad: a0 00     . for each enemy,
Loop_c2af:  sty $0131          ; $c2af: 8c 31 01  .
            cpx $0131          ; $c2b2: ec 31 01  |
            beq Next_c2e8      ; $c2b5: f0 31     | if x != y,
            lda EnemyActive,y  ; $c2b7: b9 95 00  .
            cmp #$00           ; $c2ba: c9 00     |
            beq Next_c2e8      ; $c2bc: f0 2a     | and enemy[y] is active,
            clc                ; $c2be: 18        .
            lda EnemyX,y       ; $c2bf: b9 b7 00  |
            adc #$0f           ; $c2c2: 69 0f     |
            cmp EnemyX,x       ; $c2c4: d5 b7     |
            bcc Next_c2e8      ; $c2c6: 90 20     | and (enemy[y].x + 0xf) >= enemy[x].x,
            clc                ; $c2c8: 18        .
            lda EnemyX,x       ; $c2c9: b5 b7     |
            adc #$0f           ; $c2cb: 69 0f     |
            cmp EnemyX,y       ; $c2cd: d9 b7 00  |
            bcc Next_c2e8      ; $c2d0: 90 16     | and (enemy[x].x + 0xf) >= enemy[y].x,
            lda EnemyY,y       ; $c2d2: b9 ae 00  .
            clc                ; $c2d5: 18        |
            adc #$0f           ; $c2d6: 69 0f     |
            cmp EnemyY,x       ; $c2d8: d5 ae     |
            bcc Next_c2e8      ; $c2da: 90 0c     | and (enemy[y].y + 0xf) >= enemy[x].y,
            lda EnemyY,x       ; $c2dc: b5 ae     .
            clc                ; $c2de: 18        |
            adc #$0f           ; $c2df: 69 0f     |
            cmp EnemyY,y       ; $c2e1: d9 ae 00  |
            bcc Next_c2e8      ; $c2e4: 90 02     | and (enemy[x].y + 0xf) >= enemy[y].y,
            sec                ; $c2e6: 38          .
            rts                ; $c2e7: 60          | return 1

;-------------------------------------------------------------------------------
Next_c2e8:  iny                ; $c2e8: c8        .
            cpy #$03           ; $c2e9: c0 03     |
            bne Loop_c2af      ; $c2eb: d0 c2     | loop 0..2
            clc                ; $c2ed: 18        .
            rts                ; $c2ee: 60        | return 0

;-------------------------------------------------------------------------------
CalcBlockAddrAtEnemyIndex:
            lda BlockRamAddrLo ; $c2ef: a5 84     .
            sta $86            ; $c2f1: 85 86     |
            lda BlockRamAddrHi ; $c2f3: a5 85     |
            sta $87            ; $c2f5: 85 87     | set up initial block address
            sec                ; $c2f7: 38        .
            lda EnemyY,x       ; $c2f8: b5 ae     |
            sbc #$10           ; $c2fa: e9 10     | normalize enemy y
            lsr                ; $c2fc: 4a        .
            lsr                ; $c2fd: 4a        |
            lsr                ; $c2fe: 4a        | calculate enemy y cell
            sta $0132          ; $c2ff: 8d 32 01  . store it in $0132
            asl                ; $c302: 0a        .
            asl                ; $c303: 0a        |
            clc                ; $c304: 18        |
            adc $0132          ; $c305: 6d 32 01  |
            asl                ; $c308: 0a        |
            clc                ; $c309: 18        |
            adc $0132          ; $c30a: 6d 32 01  |
            sta $0132          ; $c30d: 8d 32 01  | multiply it by 11 (calculates index of block row)
            sec                ; $c310: 38        .
            lda EnemyX,x       ; $c311: b5 b7     | 
            sbc #$10           ; $c313: e9 10     | normalize enemy x
            lsr                ; $c315: 4a        .
            lsr                ; $c316: 4a        |
            lsr                ; $c317: 4a        |
            lsr                ; $c318: 4a        | calculate enemy x cell
            clc                ; $c319: 18        .
            adc $0132          ; $c31a: 6d 32 01  | add it to $0132 (calculates final block index)
            clc                ; $c31d: 18        .
            adc $86            ; $c31e: 65 86     |
            sta $86            ; $c320: 85 86     |
            lda $87            ; $c322: a5 87     |
            adc #$00           ; $c324: 69 00     |
            sta $87            ; $c326: 85 87     | set address values to block at index
            rts                ; $c328: 60        . return

;-------------------------------------------------------------------------------
UpdateEnemyAnimTimers:
            ldy #$00           ; $c329: a0 00     
            lda EnemyActive    ; $c32b: a5 95     .
            cmp #$00           ; $c32d: c9 00     |
            beq Next_c352      ; $c32f: f0 21     | if enemy 1 active,
            lda EnemyAnimTimer ; $c331: a5 d5       .
            cmp #$00           ; $c333: c9 00       |
            beq __c33c         ; $c335: f0 05       | if anim timer > 0,
            dec EnemyAnimTimer ; $c337: c6 d5         . decrement the timer
            jmp Next_c352      ; $c339: 4c 52 c3    . else

;-------------------------------------------------------------------------------
__c33c:     lda #$0a           ; $c33c: a9 0a         .
            sta EnemyAnimTimer ; $c33e: 85 d5         | set anim timer = 0xa
            inc $d2            ; $c340: e6 d2     
            ldy $d2            ; $c342: a4 d2     
            lda ($c6),y        ; $c344: b1 c6     
            cmp #$ff           ; $c346: c9 ff     
            bne __c350         ; $c348: d0 06     
            ldy #$00           ; $c34a: a0 00     
            sty $d2            ; $c34c: 84 d2     
            lda ($c6),y        ; $c34e: b1 c6     
__c350:     sta $b1            ; $c350: 85 b1     
Next_c352:  lda $96            ; $c352: a5 96     .
            cmp #$00           ; $c354: c9 00     |
            beq __c379         ; $c356: f0 21     | if enemy 2 active,
            lda Enemy2AnimTimer; $c358: a5 d6       .
            cmp #$00           ; $c35a: c9 00       |
            beq __c363         ; $c35c: f0 05       | if anim timer > 0,
            dec Enemy2AnimTimer; $c35e: c6 d6         . decrement timer
            jmp __c379         ; $c360: 4c 79 c3    . else

;-------------------------------------------------------------------------------
__c363:     lda #$06           ; $c363: a9 06         .
            sta $d6            ; $c365: 85 d6         | set timer = 6
            inc $d3            ; $c367: e6 d3     
            ldy $d3            ; $c369: a4 d3     
            lda ($c8),y        ; $c36b: b1 c8     
            cmp #$ff           ; $c36d: c9 ff     
            bne __c377         ; $c36f: d0 06     
            ldy #$00           ; $c371: a0 00     
            sty $d3            ; $c373: 84 d3     
            lda ($c8),y        ; $c375: b1 c8     
__c377:     sta $b2            ; $c377: 85 b2     
__c379:     lda $97            ; $c379: a5 97     
            cmp #$00           ; $c37b: c9 00     
            beq __c3a0         ; $c37d: f0 21     
            lda Enemy3AnimTimer; $c37f: a5 d7     
            cmp #$00           ; $c381: c9 00     
            beq __c38a         ; $c383: f0 05     
            dec Enemy3AnimTimer; $c385: c6 d7     
            jmp __c3a0         ; $c387: 4c a0 c3  

;-------------------------------------------------------------------------------
__c38a:     lda #$06           ; $c38a: a9 06     
            sta Enemy3AnimTimer; $c38c: 85 d7     
            inc $d4            ; $c38e: e6 d4     
            ldy $d4            ; $c390: a4 d4     
            lda ($ca),y        ; $c392: b1 ca     
            cmp #$ff           ; $c394: c9 ff     
            bne __c39e         ; $c396: d0 06     
            ldy #$00           ; $c398: a0 00     
            sty $d4            ; $c39a: 84 d4     
            lda ($ca),y        ; $c39c: b1 ca     
__c39e:     sta $b3            ; $c39e: 85 b3     
__c3a0:     rts                ; $c3a0: 60        

;-------------------------------------------------------------------------------
HandleEnemyDestruction:
            ldx #$00           ; $c3a1: a2 00     . for each enemy
Loop_c3a3:  ldy EnemyDestrFrame,x ; $c3a3: b4 98  .
            cpy #$00           ; $c3a5: c0 00     |
            beq __c3e6         ; $c3a7: f0 3d     | if destr frame == 0, skip this iteration
            lda EnemyAnimTimer,x; $c3a9: b5 d5      .
            cmp #$00           ; $c3ab: c9 00       |
            beq __c3b4         ; $c3ad: f0 05       | if anim timer > 0,
            dec EnemyAnimTimer,x; $c3af: d6 d5        . decrement the timer
            jmp __c3e6         ; $c3b1: 4c e6 c3    . else

;-------------------------------------------------------------------------------
__c3b4:     cpy #$01           ; $c3b4: c0 01         .
            bne __c3ce         ; $c3b6: d0 16         | if destr frame == 1,
            lda MuteSoundEffectsTimer ; $c3b8: ad 0e 01 .
            bne __c3ce         ; $c3bb: d0 11           | if we're not muting sound effects,
            sty $0131          ; $c3bd: 8c 31 01          
            stx $0132          ; $c3c0: 8e 32 01          
            lda #$09           ; $c3c3: a9 09             .
            jsr PlaySoundEffect; $c3c5: 20 c6 f3          | play sound effect 9
            ldy $0131          ; $c3c8: ac 31 01  
            ldx $0132          ; $c3cb: ae 32 01  
__c3ce:     lda #$06           ; $c3ce: a9 06         .
            sta EnemyAnimTimer,x; $c3d0: 95 d5        | set anim timer = 6
            inc EnemyDestrFrame,x ; $c3d2: f6 98      . increment destr frame
            dey                ; $c3d4: 88            .
            lda __c3ec,y       ; $c3d5: b9 ec c3      |
            sta EnemyAnimFrame,x; $c3d8: 95 b1        | set new animation frame
            cmp #$00           ; $c3da: c9 00         .
            bne __c3e6         ; $c3dc: d0 08         | if it's 0,
            lda #$f0           ; $c3de: a9 f0           .
            sta EnemyY,x       ; $c3e0: 95 ae           | reset enemy y to 0xf0
            lda #$00           ; $c3e2: a9 00           .
            sta EnemyDestrFrame,x ; $c3e4: 95 98        | clear enemy destruction state  
__c3e6:     inx                ; $c3e6: e8        .
            cpx #$03           ; $c3e7: e0 03     |
            bne Loop_c3a3      ; $c3e9: d0 b8     | loop 0..2
            rts                ; $c3eb: 60        . return

;-------------------------------------------------------------------------------
__EnemyDestrAnimFrames:
__c3ec:     .hex e0 e2 e4 e6 00

UpdateEnemyGate:
            lda IsPaddleWarping; $c3f1: ad 23 01  .
            bne Ret_c46a       ; $c3f4: d0 74     | if the paddle's warping, return
            lda GameState      ; $c3f6: a5 0a     .
            cmp #$08           ; $c3f8: c9 08     |
            beq __c400         ; $c3fa: f0 04     |
            cmp #$10           ; $c3fc: c9 10     |
            bne Ret_c46a       ; $c3fe: d0 6a     | if the game state isn't ball inactive / ball active, return
__c400:     lda EnemyGateTimer ; $c400: ad 11 01  .
            cmp #$00           ; $c403: c9 00     |
            beq __c40b         ; $c405: f0 04     | if the gate timer's up, go update the state
            dec EnemyGateTimer ; $c406: ce 11 01  . else decrement the timer
            rts                ; $c40a: 60        . return

;-------------------------------------------------------------------------------
__c40b:     lda EnemyGateState ; $c40b: ad 0f 01  .
            cmp #$00           ; $c40e: c9 00     |
            beq Ret_c46a       ; $c410: f0 58     | if there isn't any active enemy gate state, return
            asl                ; $c412: 0a        .
            asl                ; $c413: 0a        |
            tax                ; $c414: aa        |
            lda __c46f,x       ; $c415: bd 6f c4  | load __c46f[gate state * 4];
            cmp #$00           ; $c418: c9 00     .
            beq Ret_c46a       ; $c41a: f0 4e     | if it's 0, return (do nothing)
            cmp #$ff           ; $c41c: c9 ff     .
            bne __c426         ; $c41e: d0 06     |
            lda #$00           ; $c420: a9 00     |
__c422:     sta EnemyGateState ; $c422: 8d 0f 01  |
            rts                ; $c425: 60        | if it's 0xff, set gate state = 0 and return

;-------------------------------------------------------------------------------
__c426:     ldy #$00           ; $c426: a0 00     
            lda EnemyGateIndex ; $c428: ad 10 01  
            cmp #$00           ; $c42b: c9 00     
            beq __c431         ; $c42d: f0 02     
            ldy #$02           ; $c42f: a0 02     
__c431:     lda #$06           ; $c431: a9 06     ; update sprite data for gates
            sta $2001          ; $c433: 8d 01 20  
            lda __c46b,y       ; $c436: b9 6b c4  
            sta $2006          ; $c439: 8d 06 20  
            lda __c46c,y       ; $c43c: b9 6c c4  
            sta $2006          ; $c43f: 8d 06 20  
            lda __c46f,x       ; $c442: bd 6f c4  
            sta $2007          ; $c445: 8d 07 20  
            lda __c470,x       ; $c448: bd 70 c4  
            sta $2007          ; $c44b: 8d 07 20  
            lda __c471,x       ; $c44e: bd 71 c4  
            sta $2007          ; $c451: 8d 07 20  
            lda #$00           ; $c454: a9 00     
            sta $2005          ; $c456: 8d 05 20  
            sta $2005          ; $c459: 8d 05 20  
            lda _PPU_Ctrl2_Mirror ; $c45c: a5 15     
            sta $2001          ; $c45e: 8d 01 20  
            lda __c472,x       ; $c461: bd 72 c4  .
            sta EnemyGateTimer ; $c464: 8d 11 01  | load timer value for the next state transition
            inc EnemyGateState ; $c467: ee 0f 01  . advance to next gate state
Ret_c46a:   rts                ; $c46a: 60        . return

;-------------------------------------------------------------------------------
__c46b:     .hex 20            ; $c46b: 20        Suspected data
__c46c:     rol $20            ; $c46c: 26 20     
            .hex 31            ; $c46e: 31        Suspected data

__c46f:     .hex 00
__c470:     .hex    00        
__c471:     .hex       00        
__c472:     .hex          00 ; enemy gate state = 0
            .hex 90 91 92 08 ; 1
            .hex a0 a1 a2 08 ; 2
            .hex 2d 2d 2d 08 ; 3
            .hex 2d 2d 2d 02 ; 4
            .hex 00 00 00 00 ; (5)
            .hex 00 00 00 00 ; (6)
            .hex a0 a1 a2 08 ; 7
            .hex 90 91 92 08 ; 8
            .hex 80 81 82 10 ; 9
            .hex ff

UpdateEnemySprites:
            ldx #$00           ; $c498: a2 00     
            ldy #$00           ; $c49a: a0 00     
__c49c:     lda $81            ; $c49c: a5 81     
            cmp #$00           ; $c49e: c9 00     
            beq __c4aa         ; $c4a0: f0 08     
            lda EnemyActive,y  ; $c4a2: b9 95 00     .
            ora EnemyDestrFrame,y ; $c4a5: 19 98 00  |
            bne __c4af         ; $c4a8: d0 05        | if the enemy isn't active or being destroyed,
__c4aa:     lda #$f0           ; $c4aa: a9 f0          .
            sta EnemyY,y       ; $c4ac: 99 ae 00       | set enemy y = 0xf0
__c4af:     lda EnemyY,y       ; $c4af: b9 ae 00     .
            sta $029c,x        ; $c4b2: 9d 9c 02     |
            lda EnemyAnimFrame,y ; $c4b5: b9 b1 00   |
            sta $029d,x        ; $c4b8: 9d 9d 02     |
            lda $00b4,y        ; $c4bb: b9 b4 00     |
            sta $029e,x        ; $c4be: 9d 9e 02     |
            lda EnemyX,y        ; $c4c1: b9 b7 00    |
            sta $029f,x        ; $c4c4: 9d 9f 02     |
            lda EnemyY,y        ; $c4c7: b9 ae 00    | copy a bunch of enemy data to the sprite staging area
            clc                ; $c4ca: 18        
            adc #$00           ; $c4cb: 69 00     
            sta $02a0,x        ; $c4cd: 9d a0 02  
            lda $00b1,y        ; $c4d0: b9 b1 00  
            clc                ; $c4d3: 18        
            adc #$01           ; $c4d4: 69 01     
            sta $02a1,x        ; $c4d6: 9d a1 02  
            lda $00b4,y        ; $c4d9: b9 b4 00  
            sta $02a2,x        ; $c4dc: 9d a2 02  
            lda EnemyX,y        ; $c4df: b9 b7 00  
            clc                ; $c4e2: 18        
            adc #$08           ; $c4e3: 69 08     
            sta $02a3,x        ; $c4e5: 9d a3 02  
            lda EnemyY,y        ; $c4e8: b9 ae 00  
            clc                ; $c4eb: 18        
            adc #$08           ; $c4ec: 69 08     
            sta $02a4,x        ; $c4ee: 9d a4 02  
            lda $00b1,y        ; $c4f1: b9 b1 00  
            clc                ; $c4f4: 18        
            adc #$10           ; $c4f5: 69 10     
            sta $02a5,x        ; $c4f7: 9d a5 02  
            lda $00b4,y        ; $c4fa: b9 b4 00  
            sta $02a6,x        ; $c4fd: 9d a6 02  
            lda EnemyX,y        ; $c500: b9 b7 00  
            clc                ; $c503: 18        
__c504:     adc #$00           ; $c504: 69 00     
            sta $02a7,x        ; $c506: 9d a7 02  
            lda EnemyY,y        ; $c509: b9 ae 00  
            clc                ; $c50c: 18        
            adc #$08           ; $c50d: 69 08     
            sta $02a8,x        ; $c50f: 9d a8 02  
            lda $00b1,y        ; $c512: b9 b1 00  
            clc                ; $c515: 18        
            adc #$11           ; $c516: 69 11     
            sta $02a9,x        ; $c518: 9d a9 02  
            lda $00b4,y        ; $c51b: b9 b4 00  
            sta $02aa,x        ; $c51e: 9d aa 02  
            lda EnemyX,y        ; $c521: b9 b7 00  
            clc                ; $c524: 18        
            adc #$08           ; $c525: 69 08     
            sta $02ab,x        ; $c527: 9d ab 02  
            lda $0098,y        ; $c52a: b9 98 00  
            cmp #$02           ; $c52d: c9 02     
            bcc __c53f         ; $c52f: 90 0e     
            lda #$02           ; $c531: a9 02     
            sta $029e,x        ; $c533: 9d 9e 02  
            sta $02a2,x        ; $c536: 9d a2 02  
            sta $02a6,x        ; $c539: 9d a6 02  
            sta $02aa,x        ; $c53c: 9d aa 02  
__c53f:     lda $00b1,y        ; $c53f: b9 b1 00  
            and #$01           ; $c542: 29 01     
            beq __c572         ; $c544: f0 2c     
            dec $02a1,x        ; $c546: de a1 02  
            dec $02a1,x        ; $c549: de a1 02  
            dec $02a9,x        ; $c54c: de a9 02  
            dec $02a9,x        ; $c54f: de a9 02  
            lda $029e,x        ; $c552: bd 9e 02  
            ora #$40           ; $c555: 09 40     
            sta $029e,x        ; $c557: 9d 9e 02  
            lda $02a2,x        ; $c55a: bd a2 02  
            ora #$40           ; $c55d: 09 40     
            sta $02a2,x        ; $c55f: 9d a2 02  
            lda $02a6,x        ; $c562: bd a6 02  
            ora #$40           ; $c565: 09 40     
            sta $02a6,x        ; $c567: 9d a6 02  
            lda $02aa,x        ; $c56a: bd aa 02  
            ora #$40           ; $c56d: 09 40     
            sta $02aa,x        ; $c56f: 9d aa 02  
__c572:     txa                ; $c572: 8a        
            clc                ; $c573: 18        
            adc #$10           ; $c574: 69 10     
            tax                ; $c576: aa        
            iny                ; $c577: c8        
            cpy #$03           ; $c578: c0 03     
            beq Ret_c57f       ; $c57a: f0 03     
            jmp __c49c         ; $c57c: 4c 9c c4  

;-------------------------------------------------------------------------------
Ret_c57f:   rts                ; $c57f: 60        

;-------------------------------------------------------------------------------
            
__c580:
            .hex 60 62 64 66 68 6a 6c 6e ff ff
            .hex 80 82 84 86 81 83 85 ff ff ff
            .hex a6 a8 aa ac ae c0 ff ff ff ff
            .hex 88 8a 8c 8e a0 8d 88 8a 8c 8e
            .hex a0 8d a2 a4 a4 a2 a0 ff ff ff

__EnemyCircleLookupAddresses:
__c5b2:     .hex ba
__c5b3:     .hex    c5
            .hex fa c5
            .hex 3a c6
            .hex 7a c6
            
__c5ba:
            .hex 02 00 02 ff 02 00 02 ff 02 00 02 ff 02 ff 02 ff
            .hex 02 ff 02 fe 02 fe 02 fe 02 fd 02 fd 01 fd 01 fe
            .hex 01 fd 01 fc ff fd ff fd fe fd fe fd fe fd fe fe
            .hex fe fe fe ff fe ff fe ff fe ff fe 00 fe ff 80 00

__c5fa:
            .hex 02 00 02 ff 02 00 02 ff 02 00 02 ff 02 ff 02 ff
            .hex 02 ff 02 fe 02 fe 02 fe 02 fd 02 fd 01 fd 01 fe
            .hex 01 fd 01 fc ff fd ff fd fe fd fe fd fe fd fe fe
            .hex fe fe fe ff fe ff fe ff fe ff fe 00 fe ff 80 00

__c63a:
            .hex 02 00 02 ff 02 00 02 ff 02 00 02 ff 02 ff 02 ff
            .hex 02 ff 02 fe 02 fe 02 fe 02 fd 02 fd 01 fd 01 fe
            .hex 01 fd 01 fc ff fd ff fd fe fd fe fd fe fd fe fe
            .hex fe fe fe ff fe ff fe ff fe ff fe 00 fe ff 80 00

__c67a:
            .hex 02 00 02 ff 02 00 02 ff 02 00 02 ff 02 ff 02 ff
            .hex 02 ff 02 fe 02 fe 02 fe 02 fd 02 fd 01 fd 01 fe
            .hex 01 fd 01 fc ff fd ff fd fe fd fe fd fe fd fe fe
            .hex fe fe fe ff fe ff fe ff fe ff fe 00 fe ff 80 00
            
            .hex ff ff ff      ; $c6ba: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $c6bd: ff ff ff  Invalid Opcode - ISC $ffff,x

            ; Level 1 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex e2 e2 e2 e2 e2 e2 e2 e2 e2 e2 e2
            .hex 51 59 59 51 59 51 59 51 59 51 59
            .hex 81 89 89 81 89 89 81 89 81 89 89
            .hex 69 61 69 61 69 61 69 69 61 69 61
            .hex 71 79 71 79 71 79 79 71 79 79 71
            .hex 49 49 41 49 49 41 41 41 49 41 49
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 16 0f 01 11
            .hex 27 0f 01 25 29 00 00 00 00 6e 6e
            .hex 6e 6c 6c 00 00 00 00 00 7c 00 42 ; <-- block count

            ; level 2 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 29 00 00 00 00 00 00 00 00 00 00
            .hex 21 31 00 00 00 00 00 00 00 00 00
            .hex 21 31 41 00 00 00 00 00 00 00 00
            .hex 21 31 49 61 00 00 00 00 00 00 00
            .hex 29 39 41 61 51 00 00 00 00 00 00
            .hex 21 31 41 61 51 29 00 00 00 00 00
            .hex 21 31 41 69 51 21 39 00 00 00 00
            .hex 21 31 49 61 51 21 31 41 00 00 00
            .hex 29 31 41 69 59 21 31 49 61 00 00
            .hex 21 31 41 61 51 21 31 41 69 51 00
            .hex e2 e2 e2 e2 e2 e2 e2 e2 e2 e2 29
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            
            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 10 26 0f 09 21
            .hex 29 0f 09 11 16 00 00 6e 6c 6e 6e
            .hex 6c 00 00 00 00 00 00 00 7c 00 42

            ; level 3 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 41 49 41 49 41 41 49 41 41 41 49
            .hex 00 00 00 00 00 00 00 00 00 00 00 
            .hex 11 19 11 f0 f0 f0 f0 f0 f0 f0 f0
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 51 51 59 51 51 51 59 51 51 51 59
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex f0 f0 f0 f0 f0 f0 f0 f0 11 11 11
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 79 71 71 79 71 71 79 71 79 71 71
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 61 61 61 f0 f0 f0 f0 f0 f0 f0 f0
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 61 61 69 61 69 61 61 61 61 69 61
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 61 61 61 61 61 61 61 61 61 61 61
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            
            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 29 28 0f 01 30
            .hex 16 0f 01 25 11 00 6c 00 00 6c 6e
            .hex 6e 6c 00 00 00 00 00 00 00 7e 40

            ; Level 4 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 e2 81 41 71 00 89 41 69 e2 00
            .hex 00 61 49 81 51 00 41 81 e2 61 00
            .hex 00 41 71 59 81 00 61 e2 81 41 00
            .hex 00 81 51 71 41 00 e2 61 41 89 00
            .hex 00 51 81 41 61 00 81 41 71 51 00
            .hex 00 71 41 81 e2 00 41 81 51 71 00
            .hex 00 41 61 e2 81 00 71 51 81 41 00
            .hex 00 89 e2 61 41 00 51 71 41 81 00
            .hex 00 e2 81 49 71 00 81 41 61 e2 00
            .hex 00 61 41 81 51 00 41 81 e2 61 00
            .hex 00 41 71 51 89 00 69 e2 81 41 00
            .hex 00 81 51 71 41 00 e2 61 41 81 00
            .hex 00 51 81 41 61 00 89 41 71 59 00
            .hex 00 71 41 81 e2 00 41 81 51 71 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 10 11 0f 16 27
            .hex 29 0f 16 16 25 00 00 00 00 6e 6c
            .hex 6e 6e 6c 00 00 00 00 00 7c 00 70

            ; Level 5 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 89 00 00 00 89 00 00 00
            .hex 00 00 00 00 81 00 89 00 00 00 00
            .hex 00 00 00 00 89 00 89 00 00 00 00
            .hex 00 00 00 e2 e2 e2 e2 e2 00 00 00
            .hex 00 00 00 e2 e2 e2 e2 e2 00 00 00
            .hex 00 00 e2 e2 59 e2 59 e2 e2 00 00
            .hex 00 00 e2 e2 59 e2 51 e2 e2 00 00
            .hex 00 e2 e2 e2 e2 e2 e2 e2 e2 e2 00
            .hex 00 e2 e2 e2 e2 e2 e2 e2 e2 e2 00
            .hex 00 e2 00 e2 e2 e2 e2 e2 00 e2 00
            .hex 00 e2 00 e2 00 00 00 e2 00 e2 00
            .hex 00 e2 00 e2 00 00 00 e2 00 e2 00
            .hex 00 00 00 00 e2 00 e2 00 00 00 00
            .hex 00 00 00 00 e2 00 e2 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 16 0f 01 10
            .hex 27 0f 01 00 00 00 00 00 00 00 6e
            .hex 00 00 6e 00 00 00 00 00 7c 00 43

            ; Level 6 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 61 00 51 00 41 00 41 00 51 00 61
            .hex 69 00 59 00 49 00 49 00 59 00 69
            .hex 61 00 51 00 41 00 41 00 51 00 61
            .hex 61 00 f0 29 f0 29 f0 29 f0 00 69
            .hex 61 00 51 00 41 00 49 00 59 00 61
            .hex 61 00 51 00 41 00 41 00 51 00 61
            .hex 69 00 51 00 41 00 41 00 51 00 61
            .hex 61 00 51 00 41 00 41 00 51 00 61
            .hex 61 00 59 00 41 00 41 00 51 00 61
            .hex 29 00 f0 00 f0 00 f0 00 f0 00 29
            .hex 61 00 51 00 41 00 41 00 51 00 61
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00
            
            .hex 0f 30 16 10 0f 09 11 26 0f 09 28
            .hex 16 0f 09 28 29 00 00 6e 00 6e 6e
            .hex 6c 00 00 00 00 00 00 00 00 7c 3d
            
            ; Level 7 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 81 31 61 00 00 00 00
            .hex 00 00 00 81 41 69 31 81 00 00 00
            .hex 00 00 00 31 61 41 81 21 00 00 00
            .hex 00 00 41 61 39 81 41 59 21 00 00
            .hex 00 00 61 41 81 21 51 41 81 00 00
            .hex 00 00 31 89 41 59 21 81 41 00 00
            .hex 00 00 81 21 51 49 89 31 61 00 00
            .hex 00 00 41 51 21 81 41 61 31 00 00
            .hex 00 00 51 41 81 31 61 41 81 00 00
            .hex 00 00 00 81 49 61 31 89 00 00 00
            .hex 00 00 00 31 61 41 81 21 00 00 00
            .hex 00 00 00 00 31 81 41 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            
            .hex 00 00 00
            
            .hex 0f 30 16 10 0f 01 27 29 0f 01 16
            .hex 26 0f 01 11 21 00 00 6e 6e 6e 6c
            .hex 6c 00 6c 00 00 00 00 00 00 00 44
            
            ; Level 8 blocks
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 00 f0 00 f0 00 00 f0 00
            .hex 00 f0 f0 00 00 00 00 00 f0 f0 00
            .hex 00 00 00 00 00 29 00 00 00 00 00
            .hex 00 00 00 00 f0 41 f0 00 00 00 00
            .hex 00 00 f0 00 00 89 00 00 f0 00 00
            .hex 00 00 00 00 00 69 00 00 00 00 00
            .hex 00 00 f0 00 00 51 00 00 f0 00 00
            .hex 00 00 00 00 f0 41 f0 00 00 00 00
            .hex 00 00 00 00 00 89 00 00 00 00 00
            .hex 00 f0 f0 00 00 00 00 00 f0 f0 00
            .hex 00 f0 00 00 f0 00 f0 00 00 f0 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 28 26 0f 16 27
            .hex 29 0f 16 16 11 00 00 6e 00 6e 6c
            .hex 6e 00 6c 00 00 00 00 00 00 7c 07
            
            ; Level 9 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 f0 00 00 00 f0 00 f0 00
            .hex 00 f0 49 f0 00 00 00 f0 49 f0 00
            .hex 00 f0 69 f0 00 00 00 f0 69 f0 00
            .hex 00 f0 f0 f0 00 00 00 f0 f0 f0 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 79 69 61 69 89 00 00 00
            .hex 00 00 00 79 41 39 41 89 00 00 00
            .hex 00 00 00 71 39 49 31 89 00 00 00
            .hex 00 00 00 79 41 31 49 81 00 00 00
            .hex 00 00 00 71 39 41 39 81 00 00 00
            .hex 00 00 00 79 61 69 69 89 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 28 11 0f 01 29
            .hex 21 0f 01 25 27 00 00 00 6e 6c 00
            .hex 6e 6c 6e 00 00 00 00 00 00 7c 22

            ; Level 10 data
            .hex 00 f0 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 00 00 00 69 00 00 00 00
            .hex 00 f0 00 00 00 61 39 61 00 00 00
            .hex 00 f0 00 00 69 31 69 31 69 00 00
            .hex 00 f0 00 69 39 69 e3 69 39 69 00
            .hex 00 f0 00 00 61 31 69 31 61 00 00
            .hex 00 f0 00 00 00 69 39 69 00 00 00
            .hex 00 f0 00 00 00 00 69 00 00 00 00
            .hex 00 f0 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 00 00 00 00 00 00 00 00
            .hex 00 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 28 10 0f 09 11
            .hex 21 0f 09 11 10 00 00 00 6e 00 00
            .hex 6c 00 00 00 00 00 00 00 7e 7c 19
            

            ; Level 11 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 e3 e3 e3 e3 e3 e3 e3 e3 e3 00
            .hex 00 e3 00 00 00 00 00 00 00 e3 00
            .hex 00 e3 00 e3 e3 e3 e3 e3 00 e3 00
            .hex 00 e3 00 e3 00 00 00 e3 00 e3 00
            .hex 00 e3 00 e3 00 e3 00 e3 00 e3 00
            .hex 00 e3 00 e3 00 00 00 e3 00 e3 00
            .hex 00 e3 00 e3 e3 e3 e3 e3 00 e3 00
            .hex 00 e3 00 00 00 00 00 00 00 e3 00
            .hex 00 e3 e3 e3 e3 e3 e3 e3 e3 e3 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 00 0f 01 00
            .hex 00 0f 01 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 7c 00 31


            ; Level 12 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
            .hex 00 00 00 00 f0 00 00 00 f0 29 00
            .hex 00 f0 49 00 f0 00 00 00 f0 00 00
            .hex 00 f0 00 00 f0 00 f0 00 f0 00 00
            .hex 00 f0 00 00 f0 00 f0 00 f0 00 00
            .hex 00 f0 00 00 f0 49 f0 00 f0 00 00
            .hex 00 f0 00 29 f0 00 f0 69 f0 00 00
            .hex 00 f0 00 00 f0 59 f0 00 f0 00 00
            .hex 00 f0 00 00 f0 00 f0 00 f0 00 00
            .hex 00 f0 00 00 f0 00 f0 00 f0 00 00
            .hex 00 f0 39 00 00 00 f0 00 00 00 00
            .hex 00 f0 00 00 00 00 f0 00 00 00 29
            .hex 00 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 28 26 0f 16 21
            .hex 16 0f 16 29 11 00 00 6e 6c 6c 6e
            .hex 6e 00 00 00 00 00 00 00 00 7c 08


            ; Level 13 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 81 81 00 11 11 11 00 81 81 00
            .hex 00 11 11 00 81 81 81 00 11 11 00
            .hex 00 61 61 00 51 59 51 00 61 69 00
            .hex 00 71 79 00 41 41 41 00 71 71 00
            .hex 00 41 41 00 71 71 71 00 41 41 00
            .hex 00 51 51 00 61 69 61 00 51 51 00
            .hex 00 89 81 00 11 11 11 00 89 81 00
            .hex 00 11 11 00 81 81 81 00 11 11 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 27 30 0f 01 11
            .hex 25 0f 01 16 29 00 6e 00 00 6e 6c
            .hex 6c 6e 6c 00 00 00 00 00 00 00 38


            ; Level 14 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 59 e3 e3 e3 e3 e3 e3 e3 e3 e3 59
            .hex f0 00 00 00 00 00 00 00 00 00 f0
            .hex 69 61 61 61 61 61 61 61 61 61 61
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 29 e3 e3 e3 e3 e3 e3 e3 e3 e3 29
            .hex f0 00 00 00 00 00 00 00 00 00 f0
            .hex 61 61 61 61 61 61 61 61 61 61 69
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 69 e3 e3 e3 e3 e3 e3 e3 e3 e3 69
            .hex f0 00 00 00 00 00 00 00 00 00 f0
            .hex 59 51 51 51 51 51 51 51 51 51 59
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 59 51 51 51 51 51 51 51 51 51 59
            .hex f0 00 00 00 00 00 00 00 00 00 f0
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 28 11 0f 09 28
            .hex 16 0f 09 10 26 00 00 6e 00 00 6e
            .hex 6e 00 00 00 00 00 00 00 7c 7c 4d


            ; Level 15 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 31 e3 e3 31 31 31 31 31 e3 e3 39
            .hex 31 e3 81 e3 31 31 31 e3 41 e3 31
            .hex 31 e3 81 81 e3 e3 e3 49 41 e3 31
            .hex 39 e3 81 89 81 e3 41 41 41 e3 31
            .hex 31 e3 81 81 89 e3 41 49 41 e3 31
            .hex 31 e3 81 81 81 e3 41 41 49 e3 31
            .hex 31 e3 89 81 81 e3 41 41 41 e3 31
            .hex 31 e3 81 81 81 e3 41 41 49 e3 39
            .hex 31 e3 81 81 81 e3 49 41 41 e3 31
            .hex 39 31 e3 81 81 e3 41 41 e3 39 31
            .hex 31 31 39 e3 81 e3 41 e3 31 31 31
            .hex 31 31 31 31 e3 e3 e3 31 31 31 31
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 21 0f 01 10
            .hex 27 0f 01 10 29 00 00 00 6e 6e 00
            .hex 00 00 6e 00 00 00 00 00 7c 00 84


            ; Level 16 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 f0 00 00 00 00 00
            .hex 00 00 00 11 19 00 19 11 00 00 00
            .hex 00 19 19 00 00 f0 00 00 19 19 00
            .hex 11 00 00 89 89 00 89 89 00 00 11
            .hex 00 81 81 00 00 f0 00 00 81 81 00
            .hex 89 00 00 41 41 00 41 41 00 00 89
            .hex 00 49 49 00 00 f0 00 00 41 41 00
            .hex 41 00 00 51 59 00 59 59 00 00 49
            .hex 00 51 51 00 00 f0 00 00 51 59 00
            .hex 51 00 00 69 69 00 61 61 00 00 51
            .hex 00 69 69 00 00 f0 00 00 69 69 00
            .hex 69 00 00 41 49 00 49 49 00 00 69
            .hex 00 49 41 00 00 00 00 00 41 49 00
            .hex 49 00 00 00 00 00 00 00 00 00 49
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 28 30 0f 16 27
            .hex 29 0f 16 16 11 00 6e 00 00 6e 6c
            .hex 6e 00 6c 00 00 00 00 00 00 7c 3c


            ; Level 17 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 e4 00 00 00 00 00
            .hex 00 00 00 61 61 e4 41 41 00 00 00
            .hex 00 00 69 61 11 11 11 49 41 00 00
            .hex 00 61 61 11 11 11 11 11 41 49 00
            .hex 00 61 61 11 11 11 11 11 41 41 00
            .hex 00 61 69 11 19 19 11 19 41 49 00
            .hex 00 e4 00 e4 00 e4 00 e4 00 e4 00
            .hex 00 00 00 00 00 e4 00 00 00 00 00
            .hex 00 00 00 00 00 e4 00 00 00 00 00
            .hex 00 00 00 f0 00 f0 00 00 00 00 00
            .hex 00 00 00 f0 f0 f0 00 00 00 00 00
            .hex 00 00 00 00 f0 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 28 10 0f 01 11
            .hex 30 0f 01 29 30 00 6e 00 00 6c 00
            .hex 6c 00 00 00 00 00 00 00 7e 7c 2f


            ; Level 18 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 21 00 f0 81 89 89 81 81 f0 00 21
            .hex 29 00 f0 f0 81 81 89 f0 f0 00 21
            .hex 21 00 f0 00 f0 81 f0 00 f0 00 29
            .hex 21 00 f0 00 49 e4 41 00 f0 00 21
            .hex 21 00 f0 00 41 00 49 00 f0 00 21
            .hex 21 00 f0 00 41 00 41 00 f0 00 21
            .hex 21 00 f0 00 49 00 41 00 f0 00 21
            .hex 29 00 f0 00 41 00 49 00 f0 00 21
            .hex 21 00 f0 00 49 00 49 00 f0 00 29
            .hex 21 f0 f0 f0 41 00 41 f0 f0 f0 21
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 28 27 0f 09 26
            .hex 29 0f 09 10 00 00 00 6c 00 6e 00
            .hex 00 00 6e 00 00 00 00 00 7c 7c 2c


            ; Level 19 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 f0 f0 f0 f0 f0 f0 f0 00 00
            .hex 00 00 41 59 69 f0 61 59 49 00 00
            .hex 00 00 49 51 61 f0 69 59 41 00 00
            .hex 00 00 41 51 69 f0 61 51 41 00 00
            .hex 00 00 49 59 61 f0 69 51 49 00 00
            .hex 00 00 41 51 61 f0 61 51 41 00 00
            .hex 00 00 41 59 61 f0 61 59 41 00 00
            .hex 00 00 49 51 69 f0 69 51 49 00 00
            .hex 00 00 f0 f0 f0 f0 f0 f0 f0 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 28 29 0f 01 28
            .hex 16 0f 01 28 11 00 00 00 00 6e 6e
            .hex 6e 00 00 00 00 00 00 00 00 7c 2a


            ; Level 20 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 41 f0 29 f0 31 f0 49 f0 71 f0 29
            .hex 79 f0 e4 f0 e4 f0 e4 f0 e4 f0 39
            .hex 00 00 71 00 00 00 00 00 00 00 00
            .hex 00 f0 00 f0 71 f0 00 f0 00 f0 00
            .hex 00 f0 00 f0 00 f0 79 f0 00 f0 00
            .hex 00 f0 00 f0 00 f0 00 f0 79 f0 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 f0 00 f0 00 f0 71 f0 00 f0 00
            .hex 00 f0 00 f0 79 f0 00 f0 00 f0 00
            .hex 00 00 79 f0 00 f0 00 f0 00 00 00
            .hex 79 00 00 00 00 f0 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 28 29 0f 16 10
            .hex 25 0f 16 21 26 00 00 6e 6c 6e 00
            .hex 00 6e 00 00 00 00 00 00 7c 7c 14


            ; Level 21 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 f0 29 21 21 21 21 29 21 f0 00
            .hex 00 f0 00 00 00 00 00 00 00 f0 00
            .hex 00 f0 00 f0 f0 f0 f0 f0 00 f0 00
            .hex 00 f0 00 f0 61 61 61 f0 00 f0 00
            .hex 00 f0 00 f0 79 71 71 f0 00 f0 00
            .hex 00 f0 00 f0 41 49 41 f0 00 f0 00
            .hex 00 f0 00 f0 21 21 21 f0 00 f0 00
            .hex 00 f0 00 f0 31 31 39 f0 00 f0 00
            .hex 00 f0 00 00 00 00 00 00 00 f0 00
            .hex 00 f0 00 00 00 00 00 00 00 f0 00
            .hex 00 f0 f0 f0 f0 f0 f0 f0 f0 f0 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 28 21 0f 01 26
            .hex 29 0f 01 25 11 00 00 6c 6e 6e 00
            .hex 6e 6c 00 00 00 00 00 00 00 7c 16


            ; Level 22 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 89 81 81 81 89 81 81 81 81 81 81
            .hex 81 81 81 81 81 81 89 81 81 81 89
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 51 f0 00 f0 51 59 51 f0 00 f0 51
            .hex 51 f0 00 f0 51 51 51 f0 00 f0 51
            .hex 59 f0 00 f0 51 51 59 f0 00 f0 59
            .hex 51 f0 00 f0 59 51 51 f0 00 f0 51
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 11 11 19 11 11 11 11 11 11 19 11
            .hex 11 11 11 11 11 19 11 11 11 11 11
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 28 27 0f 09 16
            .hex 30 0f 09 00 00 00 6e 00 00 00 6c
            .hex 00 00 6e 00 00 00 00 00 00 7c 40


            ; Level 23 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 69 69 61 61 61 61 61 69 61 61 61
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex e4 e4 e4 00 e4 e4 e4 00 e4 e4 e4
            .hex e4 49 e4 00 e4 49 e4 00 e4 49 e4
            .hex e4 e4 e4 00 e4 e4 e4 00 e4 e4 e4
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 e4 e4 e4 00 e4 e4 e4 00 00
            .hex 00 00 e4 59 e4 00 e4 59 e4 00 00
            .hex 00 00 e4 e4 e4 00 e4 e4 e4 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex e4 e4 e4 00 e4 e4 e4 00 e4 e4 e4
            .hex e4 69 e4 00 e4 69 e4 00 e4 69 e4
            .hex e4 e4 e4 00 e4 e4 e4 00 e4 e4 e4
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 16 0f 01 10
            .hex 29 0f 01 10 11 00 00 00 00 6e 6e
            .hex 6e 00 00 00 00 00 00 00 7c 00 53


            ; Level 24 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 19 19 11 00 00 00 00
            .hex 00 00 00 00 11 19 19 00 00 00 00
            .hex 00 00 00 00 19 11 19 00 00 00 00
            .hex 00 00 00 19 61 11 61 19 00 00 00
            .hex 00 00 00 61 61 61 61 61 00 00 00
            .hex 00 00 61 61 61 61 61 61 61 00 00
            .hex 00 00 61 61 61 61 61 61 61 00 00
            .hex 00 61 61 61 61 61 61 61 61 61 00
            .hex 61 61 61 61 61 61 61 61 61 61 61
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 11 30 0f 16 00
            .hex 00 0f 16 00 00 00 6e 00 00 00 00
            .hex 6c 00 00 00 00 00 00 00 00 00 35


            ; Level 25 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 59 51 51 51 51 59 51 51 51 51 51
            .hex 41 41 41 41 41 41 41 41 49 41 41
            .hex 61 69 61 69 61 61 61 61 61 61 69
            .hex f0 f0 f0 f0 51 51 51 f0 f0 f0 f0
            .hex f0 41 49 f0 e5 e5 e5 f0 41 49 f0
            .hex f0 51 51 f0 00 00 00 f0 61 61 f0
            .hex f0 00 00 00 00 00 00 00 00 00 f0
            .hex f0 00 00 00 00 00 00 00 00 00 f0
            .hex f0 00 00 00 00 00 00 00 00 00 f0
            .hex f0 00 00 f0 41 41 41 f0 00 00 f0
            .hex f0 e5 e5 f0 f0 f0 f0 f0 e5 e5 f0
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 28 29 0f 01 10
            .hex 16 0f 01 11 29 00 00 00 00 6e 6e
            .hex 6c 00 00 00 00 00 00 00 7c 7c 36


            ; Level 26 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 f0 e5 e5 f0 00 00 00 00 00
            .hex 00 f0 00 00 00 00 f0 00 00 00 00
            .hex f0 00 00 31 39 00 00 f0 00 00 00
            .hex f0 00 69 69 69 69 00 f0 00 00 00
            .hex f0 00 00 79 79 00 00 f0 00 00 00
            .hex 00 f0 00 00 00 00 f0 00 00 00 00
            .hex 00 00 f0 f0 f0 f0 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 28 10 0f 09 21
            .hex 11 0f 09 25 00 00 00 00 6c 00 00
            .hex 6e 6c 00 00 00 00 00 00 7e 7c 0a


            ; Level 27 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex e5 e5 e5 e5 e5 e5 e5 e5 e5 e5 e5
            .hex 81 89 81 81 89 81 81 81 81 81 89
            .hex e5 e5 e5 e5 e5 e5 e5 e5 e5 e5 e5
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex e5 e5 e5 e5 e5 e5 e5 e5 e5 e5 e5
            .hex 59 59 59 59 59 51 59 59 59 59 59
            .hex e5 e5 e5 e5 e5 e5 e5 e5 e5 e5 e5
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 27 0f 01 10
            .hex 16 0f 01 00 00 00 00 00 00 00 6e
            .hex 00 00 6e 00 00 00 00 00 7c 00 42


            ; Level 28 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 61 61 61 61 61 61 61 61 69 61 69
            .hex 61 f0 f0 f0 79 f0 79 f0 f0 f0 69
            .hex 69 f0 00 00 00 00 00 00 00 f0 61
            .hex 61 f0 71 00 00 00 00 00 79 f0 61
            .hex 69 f0 79 71 00 00 00 71 71 f0 61
            .hex 00 61 f0 71 71 00 71 71 f0 61 00
            .hex 00 00 61 f0 79 71 71 f0 61 00 00
            .hex 00 00 00 61 f0 71 f0 61 00 00 00
            .hex 00 00 00 00 61 71 61 00 00 00 00
            .hex 00 00 00 00 00 61 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 28 11 0f 16 28
            .hex 25 0f 16 00 00 00 00 00 00 00 00
            .hex 6e 6e 00 00 00 00 00 00 00 7c 2d


            ; Level 29 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 61 61 61 61 f0 00 f0 69 61 61 61
            .hex 49 41 41 49 f0 00 f0 41 41 41 49
            .hex f0 f0 f0 f0 f0 00 f0 f0 f0 f0 f0
            .hex 71 71 71 79 f0 00 f0 71 71 71 71
            .hex 21 21 21 21 f0 00 f0 29 21 21 21
            .hex 69 61 61 61 f0 00 f0 61 61 61 69
            .hex e5 e5 e5 e5 f0 00 f0 e5 e5 e5 e5
            .hex 21 21 29 21 f0 00 f0 21 21 21 29
            .hex 71 71 71 71 f0 00 f0 71 71 71 71
            .hex 41 41 41 41 f0 00 f0 41 41 41 41
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 28 29 0f 01 10
            .hex 11 0f 01 25 26 00 00 6e 00 6e 00
            .hex 6e 6c 00 00 00 00 00 00 7c 7c 48


            ; Level 30 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 21 79 00 00 00 00 00 00 00 00 00
            .hex 21 71 31 49 00 00 00 00 00 00 00
            .hex 21 71 39 41 21 79 00 00 00 00 00
            .hex 29 71 31 41 21 71 31 49 00 00 00
            .hex e5 79 39 41 21 79 31 41 21 71 00
            .hex 00 f0 e5 49 29 71 31 41 21 79 39
            .hex 00 00 00 f0 e5 79 39 41 21 71 31
            .hex 00 00 00 00 00 f0 e5 49 29 71 31
            .hex 00 00 00 00 00 00 00 f0 e5 79 39
            .hex 00 00 00 00 00 00 00 00 00 f0 e5
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 28 25 0f 09 10
            .hex 21 0f 09 26 29 00 00 6c 6e 6e 00
            .hex 00 6e 00 00 00 00 00 00 7c 7c 37


            ; Level 31 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 69 00 59 00 41 00 79 00 69 00 59
            .hex e5 00 e5 00 e5 00 e5 00 e5 00 e5
            .hex 00 49 00 59 00 69 00 21 00 49 00
            .hex 00 e5 00 e5 00 e5 00 e5 00 e5 00
            .hex 29 00 61 00 59 00 49 00 79 00 69
            .hex e5 00 e5 00 e5 00 e5 00 e5 00 e5
            .hex 00 79 00 49 00 59 00 69 00 21 00
            .hex 00 e5 00 e5 00 e5 00 e5 00 e5 00
            .hex 49 00 21 00 69 00 59 00 49 00 79
            .hex e5 00 e5 00 e5 00 e5 00 e5 00 e5
            .hex 00 69 00 79 00 49 00 59 00 61 00
            .hex 00 e5 00 e5 00 e5 00 e5 00 e5 00
            .hex 59 00 49 00 29 00 69 00 59 00 49
            .hex e5 00 e5 00 e5 00 e5 00 e5 00 e5
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 16 0f 01 11
            .hex 29 0f 01 26 25 00 00 6c 00 6e 6e
            .hex 6c 6e 00 00 00 00 00 00 7c 00 4e


            ; Level 32 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 f0 00 f0 00 f0 00 f0 00 00
            .hex 00 00 f0 00 f0 00 f0 00 f0 00 00
            .hex 00 00 f0 00 f0 00 f0 00 f0 00 00
            .hex 00 00 f0 00 f0 00 f0 59 51 00 00
            .hex 00 00 f0 00 f0 00 f0 00 f0 00 00
            .hex 00 00 f0 00 f0 61 61 61 61 00 00
            .hex 00 00 f0 00 f0 00 f0 00 f0 00 00
            .hex 00 00 f0 51 51 51 59 51 51 00 00
            .hex 00 00 f0 00 f0 00 f0 00 f0 00 00
            .hex 00 00 89 81 81 89 89 81 81 00 00
            .hex 00 00 e5 e5 e5 e5 e5 e5 e5 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 16 28 16 0f 16 28
            .hex 11 0f 16 10 27 00 00 00 00 00 6e
            .hex 6e 00 6e 00 00 00 00 00 7c 7c 1a


            ; Level 33 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 51 51 00 00 00 00
            .hex 00 00 00 00 51 e6 e6 51 00 00 00
            .hex 00 00 00 00 51 e6 59 51 00 00 00
            .hex 00 00 00 00 51 59 59 51 00 00 00
            .hex 00 00 00 00 51 59 51 51 00 00 00
            .hex 00 00 00 00 51 51 51 51 00 00 00
            .hex 00 00 00 41 41 51 51 51 61 00 00
            .hex 00 00 41 e6 e6 51 51 e6 e6 61 00
            .hex 00 00 41 e6 49 41 61 e6 69 61 00
            .hex 00 00 41 49 49 41 61 69 69 61 00
            .hex 00 00 41 49 41 41 61 69 61 61 00
            .hex 00 00 41 41 41 41 61 61 61 61 00
            .hex 00 00 41 41 41 41 61 61 61 61 00
            .hex 00 00 00 41 41 00 00 41 41 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 10 16 0f 01 10
            .hex 11 0f 01 10 29 00 00 00 00 6e 6e
            .hex 6e 00 00 00 00 00 00 00 7c 00 50


            ; Level 34 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 31 31 31 00 00
            .hex 00 00 00 00 00 00 31 31 79 00 00
            .hex 00 00 00 00 00 31 31 79 79 79 00
            .hex 00 00 00 00 00 31 31 31 79 61 00
            .hex 00 00 00 00 00 31 31 31 31 61 00
            .hex 00 00 00 00 f0 31 31 31 31 61 00
            .hex 00 00 00 00 29 61 31 31 61 61 00
            .hex 00 00 00 00 21 21 61 61 61 00 00
            .hex 00 00 00 f0 29 f0 61 61 61 00 00
            .hex 00 00 00 21 29 21 21 00 00 00 00
            .hex 00 00 f0 21 f0 21 00 00 00 00 00
            .hex 00 00 21 21 21 21 00 00 00 00 00
            .hex 00 00 21 21 21 00 00 00 00 00 00
            .hex 00 21 21 21 00 00 00 00 00 00 00
            .hex 00 21 21 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 09 28 26 0f 09 21
            .hex 11 0f 09 21 25 00 00 6e 6c 00 00
            .hex 6e 6e 00 00 00 00 00 00 00 7c 3b


            ; Level 35 data
            .hex 00 00 00 00 00 00 00 00 00 11 00
            .hex 00 00 00 00 00 00 00 00 00 11 11
            .hex 00 00 00 11 11 11 11 00 00 00 00
            .hex 00 00 00 00 11 19 19 19 00 00 00
            .hex 00 00 00 00 00 f0 f0 f0 00 00 00
            .hex 00 00 11 00 00 00 00 00 00 00 00
            .hex 00 11 29 11 00 00 00 00 00 00 00
            .hex 11 29 f0 29 11 00 00 00 00 00 00
            .hex 00 11 29 11 00 00 00 00 00 00 00
            .hex 00 00 11 00 00 00 00 00 00 00 29
            .hex 00 00 71 00 00 f0 00 41 41 41 00
            .hex 41 00 71 00 41 00 41 00 41 79 41
            .hex f0 41 71 41 00 79 41 f0 41 00 00
            .hex f0 49 71 41 00 41 00 29 41 41 00
            .hex f0 f0 41 f0 41 00 00 41 41 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 01 28 26 0f 01 30
            .hex 26 0f 01 25 29 00 6c 6e 00 6e 00
            .hex 00 6c 00 00 00 00 00 00 00 7c 34


            ; Level 36 data
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 00

            .hex 00 00 00

            .hex 0f 30 16 10 0f 06 06 16 0f 06 30
            .hex 30 0f 0f 0f 0f 00 00 00 00 00 00
            .hex 00 00 00 00 00 00 00 00 00 00 42




            rti                ; $eac0: 40        

;-------------------------------------------------------------------------------
            bvc __eb13         ; $eac1: 50 50     
            bvc __eb15         ; $eac3: 50 50     
            bvc __eac7         ; $eac5: 50 00     
__eac7:     brk                ; $eac7: 00        
            .hex 44 55         ; $eac8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eaca: 55 55     
            eor $55,x          ; $eacc: 55 55     
            brk                ; $eace: 00        
            brk                ; $eacf: 00        
            iny                ; $ead0: c8        
            .hex fa            ; $ead1: fa        Invalid Opcode - NOP 
            .hex fa            ; $ead2: fa        Invalid Opcode - NOP 
            .hex fa            ; $ead3: fa        Invalid Opcode - NOP 
            .hex fa            ; $ead4: fa        Invalid Opcode - NOP 
            .hex fa            ; $ead5: fa        Invalid Opcode - NOP 
            brk                ; $ead6: 00        
            brk                ; $ead7: 00        
            .hex 44 55         ; $ead8: 44 55     Invalid Opcode - NOP $55
__eada:     eor $55,x          ; $eada: 55 55     
            eor $55,x          ; $eadc: 55 55     
            brk                ; $eade: 00        
            brk                ; $eadf: 00        
            .hex 44 55         ; $eae0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eae2: 55 55     
            eor $55,x          ; $eae4: 55 55     
            brk                ; $eae6: 00        
            brk                ; $eae7: 00        
            .hex 44 55         ; $eae8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eaea: 55 55     
            eor $55,x          ; $eaec: 55 55     
            brk                ; $eaee: 00        
            brk                ; $eaef: 00        
            .hex 44 55         ; $eaf0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eaf2: 55 55     
            eor $55,x          ; $eaf4: 55 55     
            brk                ; $eaf6: 00        
            brk                ; $eaf7: 00        
            .hex 44 55         ; $eaf8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eafa: 55 55     
            eor $55,x          ; $eafc: 55 55     
            brk                ; $eafe: 00        
            brk                ; $eaff: 00        
            rti                ; $eb00: 40        

;-------------------------------------------------------------------------------
            bvc __eb53         ; $eb01: 50 50     
            bvc __eb55         ; $eb03: 50 50     
            bvc __eb07         ; $eb05: 50 00     
__eb07:     brk                ; $eb07: 00        
            .hex 44 aa         ; $eb08: 44 aa     Invalid Opcode - NOP $aa
            .hex ff 55 55      ; $eb0a: ff 55 55  Invalid Opcode - ISC $5555,x
            eor $00,x          ; $eb0d: 55 00     
            brk                ; $eb0f: 00        
            .hex 44 aa         ; $eb10: 44 aa     Invalid Opcode - NOP $aa
            .hex ff            ; $eb12: ff        Suspected data
__eb13:     sta $65,x          ; $eb13: 95 65     
__eb15:     eor $00,x          ; $eb15: 55 00     
            brk                ; $eb17: 00        
            .hex 44 5a         ; $eb18: 44 5a     Invalid Opcode - NOP $5a
            .hex 5f 59 5e      ; $eb1a: 5f 59 5e  Invalid Opcode - SRE $5e59,x
            .hex 57 00         ; $eb1d: 57 00     Invalid Opcode - SRE $00,x
            brk                ; $eb1f: 00        
            .hex 44 55         ; $eb20: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eb22: 55 55     
            eor $55,x          ; $eb24: 55 55     
            brk                ; $eb26: 00        
            brk                ; $eb27: 00        
            .hex 44 55         ; $eb28: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eb2a: 55 55     
            eor $55,x          ; $eb2c: 55 55     
            brk                ; $eb2e: 00        
            brk                ; $eb2f: 00        
            .hex 44 55         ; $eb30: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eb32: 55 55     
            eor $55,x          ; $eb34: 55 55     
            brk                ; $eb36: 00        
            brk                ; $eb37: 00        
            .hex 44 55         ; $eb38: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eb3a: 55 55     
            eor $55,x          ; $eb3c: 55 55     
            brk                ; $eb3e: 00        
            brk                ; $eb3f: 00        
            rti                ; $eb40: 40        

;-------------------------------------------------------------------------------
            bvc __eb93         ; $eb41: 50 50     
            bvc __eb95         ; $eb43: 50 50     
            bvc __eb47         ; $eb45: 50 00     
__eb47:     brk                ; $eb47: 00        
            sty $a5            ; $eb48: 84 a5     
            eor $55,x          ; $eb4a: 55 55     
            eor $55,x          ; $eb4c: 55 55     
            brk                ; $eb4e: 00        
            brk                ; $eb4f: 00        
            pha                ; $eb50: 48        
            .hex 5a            ; $eb51: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $eb52: 5a        Invalid Opcode - NOP 
__eb53:     .hex 5a            ; $eb53: 5a        Invalid Opcode - NOP 
            txs                ; $eb54: 9a        
__eb55:     tax                ; $eb55: aa        
            brk                ; $eb56: 00        
            brk                ; $eb57: 00        
            cpy $5fff          ; $eb58: cc ff 5f  
            .hex 5f 5f 5f      ; $eb5b: 5f 5f 5f  Invalid Opcode - SRE $5f5f,x
            brk                ; $eb5e: 00        
            brk                ; $eb5f: 00        
            .hex 8c af af      ; $eb60: 8c af af  
            .hex af af af      ; $eb63: af af af  Invalid Opcode - LAX __afaf
            brk                ; $eb66: 00        
            brk                ; $eb67: 00        
            .hex 44 55         ; $eb68: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eb6a: 55 55     
            eor $55,x          ; $eb6c: 55 55     
            brk                ; $eb6e: 00        
            brk                ; $eb6f: 00        
            .hex 44 55         ; $eb70: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eb72: 55 55     
            eor $55,x          ; $eb74: 55 55     
            brk                ; $eb76: 00        
            brk                ; $eb77: 00        
            .hex 44 55         ; $eb78: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eb7a: 55 55     
            eor $55,x          ; $eb7c: 55 55     
            brk                ; $eb7e: 00        
            brk                ; $eb7f: 00        
            rti                ; $eb80: 40        

;-------------------------------------------------------------------------------
            bvc __ebd3         ; $eb81: 50 50     
            bvc __ebd5         ; $eb83: 50 50     
            bvc __eb87         ; $eb85: 50 00     
__eb87:     brk                ; $eb87: 00        
            .hex 44 95         ; $eb88: 44 95     Invalid Opcode - NOP $95
            sbc $95            ; $eb8a: e5 95     
            adc $55            ; $eb8c: 65 55     
            brk                ; $eb8e: 00        
            brk                ; $eb8f: 00        
            .hex 44 be         ; $eb90: 44 be     Invalid Opcode - NOP $be
            .hex 6b            ; $eb92: 6b        Suspected data
__eb93:     sta $e9,x          ; $eb93: 95 e9     
__eb95:     ror $00,x          ; $eb95: 76 00     
            brk                ; $eb97: 00        
            .hex 44 96         ; $eb98: 44 96     Invalid Opcode - NOP $96
            sbc #$9d           ; $eb9a: e9 9d     
            .hex 6b 56         ; $eb9c: 6b 56     Invalid Opcode - ARR #$56
            brk                ; $eb9e: 00        
            brk                ; $eb9f: 00        
            .hex 44 be         ; $eba0: 44 be     Invalid Opcode - NOP $be
            .hex 6b 95         ; $eba2: 6b 95     Invalid Opcode - ARR #$95
            sbc #$76           ; $eba4: e9 76     
            brk                ; $eba6: 00        
            brk                ; $eba7: 00        
            .hex 44 55         ; $eba8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebaa: 55 55     
            eor $55,x          ; $ebac: 55 55     
            brk                ; $ebae: 00        
            brk                ; $ebaf: 00        
            .hex 44 55         ; $ebb0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebb2: 55 55     
            eor $55,x          ; $ebb4: 55 55     
            brk                ; $ebb6: 00        
            brk                ; $ebb7: 00        
            .hex 44 55         ; $ebb8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebba: 55 55     
            eor $55,x          ; $ebbc: 55 55     
            brk                ; $ebbe: 00        
            brk                ; $ebbf: 00        
            rti                ; $ebc0: 40        

;-------------------------------------------------------------------------------
            bvc __ec13         ; $ebc1: 50 50     
            bvc __ec15         ; $ebc3: 50 50     
            bvc __ebc7         ; $ebc5: 50 00     
__ebc7:     brk                ; $ebc7: 00        
            .hex 44 55         ; $ebc8: 44 55     Invalid Opcode - NOP $55
            txs                ; $ebca: 9a        
            sta $5556,y        ; $ebcb: 99 56 55  
            brk                ; $ebce: 00        
            brk                ; $ebcf: 00        
            .hex 44 55         ; $ebd0: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $ebd2: 55        Suspected data
__ebd3:     eor $55,x          ; $ebd3: 55 55     
__ebd5:     eor $00,x          ; $ebd5: 55 00     
            brk                ; $ebd7: 00        
            .hex 44 55         ; $ebd8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebda: 55 55     
            eor $55,x          ; $ebdc: 55 55     
            brk                ; $ebde: 00        
            brk                ; $ebdf: 00        
            .hex 44 55         ; $ebe0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebe2: 55 55     
            eor $55,x          ; $ebe4: 55 55     
            brk                ; $ebe6: 00        
            brk                ; $ebe7: 00        
            .hex 44 55         ; $ebe8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebea: 55 55     
__ebec:     eor $55,x          ; $ebec: 55 55     
            brk                ; $ebee: 00        
            brk                ; $ebef: 00        
            .hex 44 55         ; $ebf0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebf2: 55 55     
            eor $55,x          ; $ebf4: 55 55     
            brk                ; $ebf6: 00        
            brk                ; $ebf7: 00        
            .hex 44 55         ; $ebf8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ebfa: 55 55     
            eor $55,x          ; $ebfc: 55 55     
            brk                ; $ebfe: 00        
            brk                ; $ebff: 00        
            rti                ; $ec00: 40        

;-------------------------------------------------------------------------------
            bvc __ec53         ; $ec01: 50 50     
            bvc __ec55         ; $ec03: 50 50     
            bvc __ec07         ; $ec05: 50 00     
__ec07:     brk                ; $ec07: 00        
            .hex 44 99         ; $ec08: 44 99     Invalid Opcode - NOP $99
            .hex dd dd 99      ; $ec0a: dd dd 99  
            eor $00,x          ; $ec0d: 55 00     
            brk                ; $ec0f: 00        
            .hex 44 99         ; $ec10: 44 99     Invalid Opcode - NOP $99
            .hex dd            ; $ec12: dd        Suspected data
__ec13:     .hex dd 99         ; $ec13: dd 99     Suspected data
__ec15:     eor $00,x          ; $ec15: 55 00     
            brk                ; $ec17: 00        
            .hex 44 99         ; $ec18: 44 99     Invalid Opcode - NOP $99
            .hex dd dd 99      ; $ec1a: dd dd 99  
            eor $00,x          ; $ec1d: 55 00     
            brk                ; $ec1f: 00        
            .hex 44 55         ; $ec20: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec22: 55 55     
            eor $55,x          ; $ec24: 55 55     
            brk                ; $ec26: 00        
            brk                ; $ec27: 00        
            .hex 44 55         ; $ec28: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec2a: 55 55     
            eor $55,x          ; $ec2c: 55 55     
            brk                ; $ec2e: 00        
            brk                ; $ec2f: 00        
            .hex 44 55         ; $ec30: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec32: 55 55     
            eor $55,x          ; $ec34: 55 55     
            brk                ; $ec36: 00        
            brk                ; $ec37: 00        
            .hex 44 55         ; $ec38: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec3a: 55 55     
            eor $55,x          ; $ec3c: 55 55     
            brk                ; $ec3e: 00        
            brk                ; $ec3f: 00        
            rti                ; $ec40: 40        

;-------------------------------------------------------------------------------
            bvc __ec93         ; $ec41: 50 50     
            bvc __ec95         ; $ec43: 50 50     
            bvc __ec47         ; $ec45: 50 00     
__ec47:     brk                ; $ec47: 00        
            .hex 44 55         ; $ec48: 44 55     Invalid Opcode - NOP $55
            eor $f5,x          ; $ec4a: 55 f5     
            eor $55,x          ; $ec4c: 55 55     
            brk                ; $ec4e: 00        
            brk                ; $ec4f: 00        
            .hex 44 d5         ; $ec50: 44 d5     Invalid Opcode - NOP $d5
            .hex 5f            ; $ec52: 5f        Suspected data
__ec53:     lda $5a            ; $ec53: a5 5a     
__ec55:     eor $00,x          ; $ec55: 55 00     
            brk                ; $ec57: 00        
            .hex 44 95         ; $ec58: 44 95     Invalid Opcode - NOP $95
            .hex 5a            ; $ec5a: 5a        Invalid Opcode - NOP 
            sbc $5f,x          ; $ec5b: f5 5f     
            eor $00,x          ; $ec5d: 55 00     
            brk                ; $ec5f: 00        
            .hex 44 55         ; $ec60: 44 55     Invalid Opcode - NOP $55
            .hex 5f 55 56      ; $ec62: 5f 55 56  Invalid Opcode - SRE $5655,x
            eor $00,x          ; $ec65: 55 00     
            brk                ; $ec67: 00        
            .hex 44 55         ; $ec68: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec6a: 55 55     
            eor $55,x          ; $ec6c: 55 55     
            brk                ; $ec6e: 00        
            brk                ; $ec6f: 00        
            .hex 44 55         ; $ec70: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec72: 55 55     
            eor $55,x          ; $ec74: 55 55     
            brk                ; $ec76: 00        
            brk                ; $ec77: 00        
            .hex 44 55         ; $ec78: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec7a: 55 55     
            eor $55,x          ; $ec7c: 55 55     
            brk                ; $ec7e: 00        
            brk                ; $ec7f: 00        
            rti                ; $ec80: 40        

;-------------------------------------------------------------------------------
            bvc __ecd3         ; $ec81: 50 50     
            bvc __ecd5         ; $ec83: 50 50     
            bvc __ec87         ; $ec85: 50 00     
__ec87:     brk                ; $ec87: 00        
            .hex 44 55         ; $ec88: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ec8a: 55 55     
            eor $55,x          ; $ec8c: 55 55     
            brk                ; $ec8e: 00        
            brk                ; $ec8f: 00        
            .hex 44 55         ; $ec90: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $ec92: 55        Suspected data
__ec93:     ror $55,x          ; $ec93: 76 55     
__ec95:     eor $00,x          ; $ec95: 55 00     
            brk                ; $ec97: 00        
            .hex 44 55         ; $ec98: 44 55     Invalid Opcode - NOP $55
            eor $56,x          ; $ec9a: 55 56     
            eor $55,x          ; $ec9c: 55 55     
            brk                ; $ec9e: 00        
            brk                ; $ec9f: 00        
            .hex 44 55         ; $eca0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eca2: 55 55     
            eor $55,x          ; $eca4: 55 55     
            brk                ; $eca6: 00        
            brk                ; $eca7: 00        
            .hex 44 55         ; $eca8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ecaa: 55 55     
            eor $55,x          ; $ecac: 55 55     
            brk                ; $ecae: 00        
            brk                ; $ecaf: 00        
            .hex 44 55         ; $ecb0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ecb2: 55 55     
            eor $55,x          ; $ecb4: 55 55     
            brk                ; $ecb6: 00        
            brk                ; $ecb7: 00        
            .hex 44 55         ; $ecb8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ecba: 55 55     
            eor $55,x          ; $ecbc: 55 55     
            brk                ; $ecbe: 00        
            brk                ; $ecbf: 00        
            rti                ; $ecc0: 40        

;-------------------------------------------------------------------------------
            bvc __ed13         ; $ecc1: 50 50     
            bvc __ed15         ; $ecc3: 50 50     
            bvc __ecc7         ; $ecc5: 50 00     
__ecc7:     brk                ; $ecc7: 00        
            .hex 44 59         ; $ecc8: 44 59     Invalid Opcode - NOP $59
            eor $55,x          ; $ecca: 55 55     
            eor $0055,y        ; $eccc: 59 55 00  
            brk                ; $eccf: 00        
            .hex 44 55         ; $ecd0: 44 55     Invalid Opcode - NOP $55
            .hex b7            ; $ecd2: b7        Suspected data
__ecd3:     lda $77            ; $ecd3: a5 77     
__ecd5:     eor $00,x          ; $ecd5: 55 00     
            brk                ; $ecd7: 00        
            .hex 44 55         ; $ecd8: 44 55     Invalid Opcode - NOP $55
            .hex 7b 5a 77      ; $ecda: 7b 5a 77  Invalid Opcode - RRA $775a,y
            eor $00,x          ; $ecdd: 55 00     
            brk                ; $ecdf: 00        
            .hex 44 55         ; $ece0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ece2: 55 55     
            eor $55,x          ; $ece4: 55 55     
            brk                ; $ece6: 00        
            brk                ; $ece7: 00        
            .hex 44 55         ; $ece8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ecea: 55 55     
            eor $55,x          ; $ecec: 55 55     
            brk                ; $ecee: 00        
            brk                ; $ecef: 00        
            .hex 44 55         ; $ecf0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ecf2: 55 55     
            eor $55,x          ; $ecf4: 55 55     
            brk                ; $ecf6: 00        
            brk                ; $ecf7: 00        
            .hex 44 55         ; $ecf8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ecfa: 55 55     
            eor $55,x          ; $ecfc: 55 55     
            brk                ; $ecfe: 00        
            brk                ; $ecff: 00        
            rti                ; $ed00: 40        

;-------------------------------------------------------------------------------
            bvc __ed53         ; $ed01: 50 50     
            bvc __ed55         ; $ed03: 50 50     
            bvc __ed07         ; $ed05: 50 00     
__ed07:     brk                ; $ed07: 00        
            .hex 44 55         ; $ed08: 44 55     Invalid Opcode - NOP $55
            eor $a5,x          ; $ed0a: 55 a5     
            adc $55            ; $ed0c: 65 55     
            brk                ; $ed0e: 00        
            brk                ; $ed0f: 00        
            .hex 44 55         ; $ed10: 44 55     Invalid Opcode - NOP $55
            txs                ; $ed12: 9a        
__ed13:     .hex ae aa         ; $ed13: ae aa     Suspected data
__ed15:     lsr $00,x          ; $ed15: 56 00     
            brk                ; $ed17: 00        
            .hex 44 55         ; $ed18: 44 55     Invalid Opcode - NOP $55
            eor $59,x          ; $ed1a: 55 59     
            eor $55,x          ; $ed1c: 55 55     
            brk                ; $ed1e: 00        
            brk                ; $ed1f: 00        
            .hex 44 55         ; $ed20: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed22: 55 55     
            eor $55,x          ; $ed24: 55 55     
            brk                ; $ed26: 00        
            brk                ; $ed27: 00        
            .hex 44 55         ; $ed28: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed2a: 55 55     
            eor $55,x          ; $ed2c: 55 55     
            brk                ; $ed2e: 00        
            brk                ; $ed2f: 00        
            .hex 44 55         ; $ed30: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed32: 55 55     
            eor $55,x          ; $ed34: 55 55     
            brk                ; $ed36: 00        
            brk                ; $ed37: 00        
            .hex 44 55         ; $ed38: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed3a: 55 55     
            eor $55,x          ; $ed3c: 55 55     
            brk                ; $ed3e: 00        
            brk                ; $ed3f: 00        
            rti                ; $ed40: 40        

;-------------------------------------------------------------------------------
            bvc __ed93         ; $ed41: 50 50     
            bvc __ed95         ; $ed43: 50 50     
            bvc __ed47         ; $ed45: 50 00     
__ed47:     brk                ; $ed47: 00        
            .hex 44 55         ; $ed48: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed4a: 55 55     
            eor $55,x          ; $ed4c: 55 55     
            brk                ; $ed4e: 00        
            brk                ; $ed4f: 00        
            .hex 44 55         ; $ed50: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $ed52: 55        Suspected data
__ed53:     eor $55,x          ; $ed53: 55 55     
__ed55:     eor $00,x          ; $ed55: 55 00     
            brk                ; $ed57: 00        
            .hex 44 55         ; $ed58: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed5a: 55 55     
            eor $55,x          ; $ed5c: 55 55     
            brk                ; $ed5e: 00        
            brk                ; $ed5f: 00        
            .hex 44 55         ; $ed60: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed62: 55 55     
            eor $55,x          ; $ed64: 55 55     
            brk                ; $ed66: 00        
            brk                ; $ed67: 00        
            .hex 44 55         ; $ed68: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed6a: 55 55     
            eor $55,x          ; $ed6c: 55 55     
            brk                ; $ed6e: 00        
            brk                ; $ed6f: 00        
            .hex 44 55         ; $ed70: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed72: 55 55     
            eor $55,x          ; $ed74: 55 55     
            brk                ; $ed76: 00        
            brk                ; $ed77: 00        
            .hex 44 55         ; $ed78: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ed7a: 55 55     
            eor $55,x          ; $ed7c: 55 55     
            brk                ; $ed7e: 00        
            brk                ; $ed7f: 00        
            rti                ; $ed80: 40        

;-------------------------------------------------------------------------------
            bvc __edd3         ; $ed81: 50 50     
            bvc __edd5         ; $ed83: 50 50     
            bvc __ed87         ; $ed85: 50 00     
__ed87:     brk                ; $ed87: 00        
            .hex 44 d5         ; $ed88: 44 d5     Invalid Opcode - NOP $d5
            eor $55,x          ; $ed8a: 55 55     
            eor $55,x          ; $ed8c: 55 55     
            brk                ; $ed8e: 00        
            brk                ; $ed8f: 00        
            .hex 44 55         ; $ed90: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $ed92: 55        Suspected data
__ed93:     .hex 67 75         ; $ed93: 67 75     Invalid Opcode - RRA $75
__ed95:     eor $00,x          ; $ed95: 55 00     
            brk                ; $ed97: 00        
            .hex 44 95         ; $ed98: 44 95     Invalid Opcode - NOP $95
            eor $55,x          ; $ed9a: 55 55     
            eor $55,x          ; $ed9c: 55 55     
            brk                ; $ed9e: 00        
            brk                ; $ed9f: 00        
            .hex 44 55         ; $eda0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eda2: 55 55     
            eor $55,x          ; $eda4: 55 55     
            brk                ; $eda6: 00        
            brk                ; $eda7: 00        
            .hex 44 55         ; $eda8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edaa: 55 55     
            eor $55,x          ; $edac: 55 55     
            brk                ; $edae: 00        
            brk                ; $edaf: 00        
            .hex 44 55         ; $edb0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edb2: 55 55     
            eor $55,x          ; $edb4: 55 55     
            brk                ; $edb6: 00        
            brk                ; $edb7: 00        
            .hex 44 55         ; $edb8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edba: 55 55     
            eor $55,x          ; $edbc: 55 55     
            brk                ; $edbe: 00        
            brk                ; $edbf: 00        
            rti                ; $edc0: 40        

;-------------------------------------------------------------------------------
            bvc __ee13         ; $edc1: 50 50     
            bvc __ee15         ; $edc3: 50 50     
            bvc __edc7         ; $edc5: 50 00     
__edc7:     brk                ; $edc7: 00        
            .hex 44 55         ; $edc8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edca: 55 55     
            eor $55,x          ; $edcc: 55 55     
            brk                ; $edce: 00        
            brk                ; $edcf: 00        
            .hex 44 fa         ; $edd0: 44 fa     Invalid Opcode - NOP $fa
            .hex 9d            ; $edd2: 9d        Suspected data
__edd3:     .hex af d9         ; $edd3: af d9     Suspected data
__edd5:     ror $00,x          ; $edd5: 76 00     
            brk                ; $edd7: 00        
            .hex 44 55         ; $edd8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edda: 55 55     
            eor $55,x          ; $eddc: 55 55     
            brk                ; $edde: 00        
            brk                ; $eddf: 00        
            .hex 44 55         ; $ede0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ede2: 55 55     
            eor $55,x          ; $ede4: 55 55     
            brk                ; $ede6: 00        
            brk                ; $ede7: 00        
            .hex 44 55         ; $ede8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edea: 55 55     
            eor $55,x          ; $edec: 55 55     
            brk                ; $edee: 00        
            brk                ; $edef: 00        
            .hex 44 55         ; $edf0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edf2: 55 55     
            eor $55,x          ; $edf4: 55 55     
            brk                ; $edf6: 00        
            brk                ; $edf7: 00        
            .hex 44 55         ; $edf8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $edfa: 55 55     
            eor $55,x          ; $edfc: 55 55     
            brk                ; $edfe: 00        
            brk                ; $edff: 00        
            rti                ; $ee00: 40        

;-------------------------------------------------------------------------------
            bvc __ee53         ; $ee01: 50 50     
            bvc __ee55         ; $ee03: 50 50     
            bvc __ee07         ; $ee05: 50 00     
__ee07:     brk                ; $ee07: 00        
            pha                ; $ee08: 48        
            .hex 5f 5f 5f      ; $ee09: 5f 5f 5f  Invalid Opcode - SRE $5f5f,x
            .hex 5f 5b 00      ; $ee0c: 5f 5b 00  Bad Addr Mode - SRE $005b,x
            brk                ; $ee0f: 00        
            jmp $5f5f          ; $ee10: 4c 5f 5f  

;-------------------------------------------------------------------------------
__ee13:     .hex 5f 5f         ; $ee13: 5f 5f     Suspected data
__ee15:     .hex 5f 00 00      ; $ee15: 5f 00 00  Bad Addr Mode - SRE $0000,x
            sty $af            ; $ee18: 84 af     
            .hex af af af      ; $ee1a: af af af  Invalid Opcode - LAX __afaf
            .hex a7 00         ; $ee1d: a7 00     Invalid Opcode - LAX $00
            brk                ; $ee1f: 00        
            pha                ; $ee20: 48        
            .hex 5a            ; $ee21: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $ee22: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $ee23: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $ee24: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $ee25: 5a        Invalid Opcode - NOP 
            brk                ; $ee26: 00        
            brk                ; $ee27: 00        
            .hex 44 55         ; $ee28: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ee2a: 55 55     
            eor $55,x          ; $ee2c: 55 55     
            brk                ; $ee2e: 00        
            brk                ; $ee2f: 00        
            .hex 44 55         ; $ee30: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ee32: 55 55     
            eor $55,x          ; $ee34: 55 55     
            brk                ; $ee36: 00        
            brk                ; $ee37: 00        
            .hex 44 55         ; $ee38: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ee3a: 55 55     
            eor $55,x          ; $ee3c: 55 55     
            brk                ; $ee3e: 00        
            brk                ; $ee3f: 00        
            rti                ; $ee40: 40        

;-------------------------------------------------------------------------------
            bvc __ee93         ; $ee41: 50 50     
            bvc __ee95         ; $ee43: 50 50     
            bvc __ee47         ; $ee45: 50 00     
__ee47:     brk                ; $ee47: 00        
            .hex 44 95         ; $ee48: 44 95     Invalid Opcode - NOP $95
            adc $55            ; $ee4a: 65 55     
            sbc $55,x          ; $ee4c: f5 55     
            brk                ; $ee4e: 00        
            brk                ; $ee4f: 00        
            .hex 44 99         ; $ee50: 44 99     Invalid Opcode - NOP $99
            tax                ; $ee52: aa        
__ee53:     .hex dd ff         ; $ee53: dd ff     Suspected data
__ee55:     eor $00,x          ; $ee55: 55 00     
            brk                ; $ee57: 00        
            .hex 44 59         ; $ee58: 44 59     Invalid Opcode - NOP $59
            tax                ; $ee5a: aa        
            cmp $557f,x        ; $ee5b: dd 7f 55  
            brk                ; $ee5e: 00        
            brk                ; $ee5f: 00        
            .hex 44 55         ; $ee60: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ee62: 55 55     
            eor $55,x          ; $ee64: 55 55     
            brk                ; $ee66: 00        
            brk                ; $ee67: 00        
            .hex 44 55         ; $ee68: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ee6a: 55 55     
            eor $55,x          ; $ee6c: 55 55     
            brk                ; $ee6e: 00        
            brk                ; $ee6f: 00        
            .hex 44 55         ; $ee70: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ee72: 55 55     
            eor $55,x          ; $ee74: 55 55     
            brk                ; $ee76: 00        
            brk                ; $ee77: 00        
            .hex 44 55         ; $ee78: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ee7a: 55 55     
            eor $55,x          ; $ee7c: 55 55     
            brk                ; $ee7e: 00        
            brk                ; $ee7f: 00        
            rti                ; $ee80: 40        

;-------------------------------------------------------------------------------
            bvc __eed3         ; $ee81: 50 50     
            bvc __eed5         ; $ee83: 50 50     
            bvc __ee87         ; $ee85: 50 00     
__ee87:     brk                ; $ee87: 00        
            .hex 44 55         ; $ee88: 44 55     Invalid Opcode - NOP $55
            lda $95            ; $ee8a: a5 95     
            adc $55            ; $ee8c: 65 55     
            brk                ; $ee8e: 00        
            brk                ; $ee8f: 00        
            dey                ; $ee90: 88        
            tax                ; $ee91: aa        
            .hex fa            ; $ee92: fa        Invalid Opcode - NOP 
__ee93:     .hex d9 ba         ; $ee93: d9 ba     Suspected data
__ee95:     tax                ; $ee95: aa        
            brk                ; $ee96: 00        
            brk                ; $ee97: 00        
            cpy __afff         ; $ee98: cc ff af  
            .hex 9d ef ff      ; $ee9b: 9d ef ff  
            brk                ; $ee9e: 00        
            brk                ; $ee9f: 00        
            pha                ; $eea0: 48        
            .hex 5a            ; $eea1: 5a        Invalid Opcode - NOP 
            eor $55,x          ; $eea2: 55 55     
            eor $005a,y        ; $eea4: 59 5a 00  
            brk                ; $eea7: 00        
            .hex 44 55         ; $eea8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eeaa: 55 55     
            eor $55,x          ; $eeac: 55 55     
            brk                ; $eeae: 00        
            brk                ; $eeaf: 00        
            .hex 44 55         ; $eeb0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eeb2: 55 55     
            eor $55,x          ; $eeb4: 55 55     
            brk                ; $eeb6: 00        
            brk                ; $eeb7: 00        
            .hex 44 55         ; $eeb8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eeba: 55 55     
            eor $55,x          ; $eebc: 55 55     
            brk                ; $eebe: 00        
            brk                ; $eebf: 00        
            rti                ; $eec0: 40        

;-------------------------------------------------------------------------------
            bvc __ef13         ; $eec1: 50 50     
            bvc __ef15         ; $eec3: 50 50     
            bvc __eec7         ; $eec5: 50 00     
__eec7:     brk                ; $eec7: 00        
            .hex 44 a5         ; $eec8: 44 a5     Invalid Opcode - NOP $a5
            tax                ; $eeca: aa        
            lda $75f7          ; $eecb: ad f7 75  
            brk                ; $eece: 00        
            brk                ; $eecf: 00        
            .hex 44 5a         ; $eed0: 44 5a     Invalid Opcode - NOP $5a
            .hex 5a            ; $eed2: 5a        Invalid Opcode - NOP 
__eed3:     .hex 5a            ; $eed3: 5a        Invalid Opcode - NOP 
            .hex 5e            ; $eed4: 5e        Suspected data
__eed5:     .hex 57 00         ; $eed5: 57 00     Invalid Opcode - SRE $00,x
            brk                ; $eed7: 00        
            .hex 44 55         ; $eed8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eeda: 55 55     
            eor $55,x          ; $eedc: 55 55     
            brk                ; $eede: 00        
            brk                ; $eedf: 00        
            .hex 44 55         ; $eee0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eee2: 55 55     
            eor $55,x          ; $eee4: 55 55     
            brk                ; $eee6: 00        
            brk                ; $eee7: 00        
            .hex 44 55         ; $eee8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eeea: 55 55     
            eor $55,x          ; $eeec: 55 55     
            brk                ; $eeee: 00        
            brk                ; $eeef: 00        
            .hex 44 55         ; $eef0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eef2: 55 55     
            eor $55,x          ; $eef4: 55 55     
            brk                ; $eef6: 00        
            brk                ; $eef7: 00        
            .hex 44 55         ; $eef8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eefa: 55 55     
            eor $55,x          ; $eefc: 55 55     
            brk                ; $eefe: 00        
            brk                ; $eeff: 00        
            rti                ; $ef00: 40        

;-------------------------------------------------------------------------------
            bvc __ef53         ; $ef01: 50 50     
            bvc __ef55         ; $ef03: 50 50     
            bvc __ef07         ; $ef05: 50 00     
__ef07:     brk                ; $ef07: 00        
            dey                ; $ef08: 88        
            eor $55,x          ; $ef09: 55 55     
            eor $55,x          ; $ef0b: 55 55     
            sta $0000,y        ; $ef0d: 99 00 00  
            dey                ; $ef10: 88        
            eor $99,x          ; $ef11: 55 99     
__ef13:     .hex 9b            ; $ef13: 9b        Invalid Opcode - TAS 
            .hex 55            ; $ef14: 55        Suspected data
__ef15:     sta $0000,y        ; $ef15: 99 00 00  
            dey                ; $ef18: 88        
            eor $99,x          ; $ef19: 55 99     
            .hex 99 55 99      ; $ef1b: 99 55 99  
            brk                ; $ef1e: 00        
            brk                ; $ef1f: 00        
            .hex 44 55         ; $ef20: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef22: 55 55     
            eor $55,x          ; $ef24: 55 55     
            brk                ; $ef26: 00        
            brk                ; $ef27: 00        
            .hex 44 55         ; $ef28: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef2a: 55 55     
            eor $55,x          ; $ef2c: 55 55     
            brk                ; $ef2e: 00        
            brk                ; $ef2f: 00        
            .hex 44 55         ; $ef30: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef32: 55 55     
            eor $55,x          ; $ef34: 55 55     
            brk                ; $ef36: 00        
            brk                ; $ef37: 00        
            .hex 44 55         ; $ef38: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef3a: 55 55     
            eor $55,x          ; $ef3c: 55 55     
            brk                ; $ef3e: 00        
            brk                ; $ef3f: 00        
            rti                ; $ef40: 40        

;-------------------------------------------------------------------------------
            bvc __ef93         ; $ef41: 50 50     
            bvc __ef95         ; $ef43: 50 50     
            bvc __ef47         ; $ef45: 50 00     
__ef47:     brk                ; $ef47: 00        
            .hex 44 55         ; $ef48: 44 55     Invalid Opcode - NOP $55
            .hex e5 d5         ; $ef4a: e5 d5     
            adc $55            ; $ef4c: 65 55     
            brk                ; $ef4e: 00        
            brk                ; $ef4f: 00        
            .hex 44 55         ; $ef50: 44 55     Invalid Opcode - NOP $55
            .hex ee            ; $ef52: ee        Suspected data
__ef53:     .hex dd 66         ; $ef53: dd 66     Suspected data
__ef55:     eor $00,x          ; $ef55: 55 00     
            brk                ; $ef57: 00        
            .hex 44 55         ; $ef58: 44 55     Invalid Opcode - NOP $55
            lsr $565d,x        ; $ef5a: 5e 5d 56  
            eor $00,x          ; $ef5d: 55 00     
            brk                ; $ef5f: 00        
            .hex 44 55         ; $ef60: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef62: 55 55     
            eor $55,x          ; $ef64: 55 55     
            brk                ; $ef66: 00        
            brk                ; $ef67: 00        
            .hex 44 55         ; $ef68: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef6a: 55 55     
            eor $55,x          ; $ef6c: 55 55     
            brk                ; $ef6e: 00        
            brk                ; $ef6f: 00        
            .hex 44 55         ; $ef70: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef72: 55 55     
            eor $55,x          ; $ef74: 55 55     
            brk                ; $ef76: 00        
            brk                ; $ef77: 00        
            .hex 44 55         ; $ef78: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $ef7a: 55 55     
            eor $55,x          ; $ef7c: 55 55     
            brk                ; $ef7e: 00        
            brk                ; $ef7f: 00        
            rti                ; $ef80: 40        

;-------------------------------------------------------------------------------
            bvc __efd3         ; $ef81: 50 50     
            bvc __efd5         ; $ef83: 50 50     
            bvc __ef87         ; $ef85: 50 00     
__ef87:     brk                ; $ef87: 00        
            sty $9d            ; $ef88: 84 9d     
            .hex 9d 95 99      ; $ef8a: 9d 95 99  
            .hex dd 00 00      ; $ef8d: dd 00 00  Bad Addr Mode - CMP $0000,x
            .hex 44 55         ; $ef90: 44 55     Invalid Opcode - NOP $55
            .hex 59            ; $ef92: 59        Suspected data
__ef93:     .hex 59 95         ; $ef93: 59 95     Suspected data
__ef95:     eor $00,x          ; $ef95: 55 00     
            brk                ; $ef97: 00        
            sty $95            ; $ef98: 84 95     
            eor $5559,y        ; $ef9a: 59 59 55  
            eor $00,x          ; $ef9d: 55 00     
            brk                ; $ef9f: 00        
            .hex 44 55         ; $efa0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $efa2: 55 55     
            eor $55,x          ; $efa4: 55 55     
            brk                ; $efa6: 00        
            brk                ; $efa7: 00        
            .hex 44 55         ; $efa8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $efaa: 55 55     
            eor $55,x          ; $efac: 55 55     
            brk                ; $efae: 00        
            brk                ; $efaf: 00        
            .hex 44 55         ; $efb0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $efb2: 55 55     
            eor $55,x          ; $efb4: 55 55     
            brk                ; $efb6: 00        
            brk                ; $efb7: 00        
            .hex 44 55         ; $efb8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $efba: 55 55     
            eor $55,x          ; $efbc: 55 55     
            brk                ; $efbe: 00        
            brk                ; $efbf: 00        
            rti                ; $efc0: 40        

;-------------------------------------------------------------------------------
            bvc __f013         ; $efc1: 50 50     
            bvc __f015         ; $efc3: 50 50     
            bvc __efc7         ; $efc5: 50 00     
__efc7:     brk                ; $efc7: 00        
            .hex 44 59         ; $efc8: 44 59     Invalid Opcode - NOP $59
            .hex 5a            ; $efca: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $efcb: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $efcc: 5a        Invalid Opcode - NOP 
            eor $00,x          ; $efcd: 55 00     
            brk                ; $efcf: 00        
            .hex 44 55         ; $efd0: 44 55     Invalid Opcode - NOP $55
            .hex 9d            ; $efd2: 9d        Suspected data
__efd3:     .hex af 55         ; $efd3: af 55     Suspected data
__efd5:     eor $00,x          ; $efd5: 55 00     
            brk                ; $efd7: 00        
            .hex 44 55         ; $efd8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $efda: 55 55     
            eor $55,x          ; $efdc: 55 55     
            brk                ; $efde: 00        
            brk                ; $efdf: 00        
            .hex 44 55         ; $efe0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $efe2: 55 55     
            eor $55,x          ; $efe4: 55 55     
            brk                ; $efe6: 00        
            brk                ; $efe7: 00        
            .hex 44 55         ; $efe8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $efea: 55 55     
            eor $55,x          ; $efec: 55 55     
            brk                ; $efee: 00        
            brk                ; $efef: 00        
            .hex 44 55         ; $eff0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $eff2: 55 55     
            eor $55,x          ; $eff4: 55 55     
            brk                ; $eff6: 00        
            brk                ; $eff7: 00        
            .hex 44 55         ; $eff8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $effa: 55 55     
            eor $55,x          ; $effc: 55 55     
            brk                ; $effe: 00        
            brk                ; $efff: 00        
            rti                ; $f000: 40        

;-------------------------------------------------------------------------------
            bvc __f053         ; $f001: 50 50     
            bvc __f055         ; $f003: 50 50     
            bvc __f007         ; $f005: 50 00     
__f007:     brk                ; $f007: 00        
            .hex 44 55         ; $f008: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f00a: 55 55     
            eor $55,x          ; $f00c: 55 55     
            brk                ; $f00e: 00        
            brk                ; $f00f: 00        
            dey                ; $f010: 88        
            eor $99,x          ; $f011: 55 99     
__f013:     tax                ; $f013: aa        
            .hex 55            ; $f014: 55        Suspected data
__f015:     sta $0000,y        ; $f015: 99 00 00  
            dey                ; $f018: 88        
            tax                ; $f019: aa        
            tax                ; $f01a: aa        
            tax                ; $f01b: aa        
            tax                ; $f01c: aa        
            tax                ; $f01d: aa        
            brk                ; $f01e: 00        
            brk                ; $f01f: 00        
            .hex 44 55         ; $f020: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f022: 55 55     
            eor $55,x          ; $f024: 55 55     
            brk                ; $f026: 00        
            brk                ; $f027: 00        
            .hex 44 55         ; $f028: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f02a: 55 55     
            eor $55,x          ; $f02c: 55 55     
            brk                ; $f02e: 00        
            brk                ; $f02f: 00        
            .hex 44 55         ; $f030: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f032: 55 55     
            eor $55,x          ; $f034: 55 55     
            brk                ; $f036: 00        
            brk                ; $f037: 00        
            .hex 44 55         ; $f038: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f03a: 55 55     
            eor $55,x          ; $f03c: 55 55     
            brk                ; $f03e: 00        
            brk                ; $f03f: 00        
            rti                ; $f040: 40        

;-------------------------------------------------------------------------------
__f041:     bvc __f093         ; $f041: 50 50     
            bvc __f095         ; $f043: 50 50     
            bvc __f047         ; $f045: 50 00     
__f047:     brk                ; $f047: 00        
            jmp $5f6f          ; $f048: 4c 6f 5f  

;-------------------------------------------------------------------------------
            .hex 6f 5f 6f      ; $f04b: 6f 5f 6f  Invalid Opcode - RRA $6f5f
            brk                ; $f04e: 00        
            brk                ; $f04f: 00        
            .hex 44            ; $f050: 44        Suspected data
__f051:     eor $55,x          ; $f051: 55 55     
__f053:     eor $55,x          ; $f053: 55 55     
__f055:     eor $00,x          ; $f055: 55 00     
            brk                ; $f057: 00        
            .hex 44 75         ; $f058: 44 75     Invalid Opcode - NOP $75
            eor $75,x          ; $f05a: 55 75     
            eor $75,x          ; $f05c: 55 75     
            brk                ; $f05e: 00        
            brk                ; $f05f: 00        
            .hex 44 55         ; $f060: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f062: 55 55     
            eor $55,x          ; $f064: 55 55     
            brk                ; $f066: 00        
            brk                ; $f067: 00        
            .hex 44 55         ; $f068: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f06a: 55 55     
            eor $55,x          ; $f06c: 55 55     
            brk                ; $f06e: 00        
            brk                ; $f06f: 00        
            .hex 44 55         ; $f070: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f072: 55 55     
            eor $55,x          ; $f074: 55 55     
            brk                ; $f076: 00        
            brk                ; $f077: 00        
            .hex 44 55         ; $f078: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f07a: 55 55     
            eor $55,x          ; $f07c: 55 55     
            brk                ; $f07e: 00        
            brk                ; $f07f: 00        
            rti                ; $f080: 40        

;-------------------------------------------------------------------------------
            bvc __f0d3         ; $f081: 50 50     
            bvc __f0d5         ; $f083: 50 50     
            bvc __f087         ; $f085: 50 00     
__f087:     brk                ; $f087: 00        
            .hex 44 55         ; $f088: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f08a: 55 55     
            eor $55,x          ; $f08c: 55 55     
            brk                ; $f08e: 00        
            brk                ; $f08f: 00        
            .hex 44 55         ; $f090: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $f092: 55        Suspected data
__f093:     eor $55,x          ; $f093: 55 55     
__f095:     eor $00,x          ; $f095: 55 00     
            brk                ; $f097: 00        
            .hex 44 55         ; $f098: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f09a: 55 55     
            eor $55,x          ; $f09c: 55 55     
            brk                ; $f09e: 00        
            brk                ; $f09f: 00        
            .hex 44 55         ; $f0a0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0a2: 55 55     
            eor $55,x          ; $f0a4: 55 55     
            brk                ; $f0a6: 00        
            brk                ; $f0a7: 00        
            .hex 44 55         ; $f0a8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0aa: 55 55     
            eor $55,x          ; $f0ac: 55 55     
            brk                ; $f0ae: 00        
            brk                ; $f0af: 00        
            .hex 44 55         ; $f0b0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0b2: 55 55     
            eor $55,x          ; $f0b4: 55 55     
            brk                ; $f0b6: 00        
            brk                ; $f0b7: 00        
            .hex 44 55         ; $f0b8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0ba: 55 55     
            eor $55,x          ; $f0bc: 55 55     
            brk                ; $f0be: 00        
            brk                ; $f0bf: 00        
            rti                ; $f0c0: 40        

;-------------------------------------------------------------------------------
            bvc __f113         ; $f0c1: 50 50     
            bvc __f115         ; $f0c3: 50 50     
            bvc __f0c7         ; $f0c5: 50 00     
__f0c7:     brk                ; $f0c7: 00        
            iny                ; $f0c8: c8        
            .hex fa            ; $f0c9: fa        Invalid Opcode - NOP 
            .hex fa            ; $f0ca: fa        Invalid Opcode - NOP 
            .hex fa            ; $f0cb: fa        Invalid Opcode - NOP 
            .hex fa            ; $f0cc: fa        Invalid Opcode - NOP 
            .hex fa            ; $f0cd: fa        Invalid Opcode - NOP 
            brk                ; $f0ce: 00        
            brk                ; $f0cf: 00        
            .hex 44 a5         ; $f0d0: 44 a5     Invalid Opcode - NOP $a5
            .hex 59            ; $f0d2: 59        Suspected data
__f0d3:     .hex 5a            ; $f0d3: 5a        Invalid Opcode - NOP 
            .hex d5            ; $f0d4: d5        Suspected data
__f0d5:     adc $00,x          ; $f0d5: 75 00     
            brk                ; $f0d7: 00        
            .hex 44 a5         ; $f0d8: 44 a5     Invalid Opcode - NOP $a5
            eor $55,x          ; $f0da: 55 55     
            sta $65,x          ; $f0dc: 95 65     
            brk                ; $f0de: 00        
            brk                ; $f0df: 00        
            .hex 44 55         ; $f0e0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0e2: 55 55     
            eor $55,x          ; $f0e4: 55 55     
            brk                ; $f0e6: 00        
            brk                ; $f0e7: 00        
            .hex 44 55         ; $f0e8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0ea: 55 55     
            eor $55,x          ; $f0ec: 55 55     
            brk                ; $f0ee: 00        
            brk                ; $f0ef: 00        
            .hex 44 55         ; $f0f0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0f2: 55 55     
            eor $55,x          ; $f0f4: 55 55     
            brk                ; $f0f6: 00        
            brk                ; $f0f7: 00        
            .hex 44 55         ; $f0f8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f0fa: 55 55     
            eor $55,x          ; $f0fc: 55 55     
            brk                ; $f0fe: 00        
            brk                ; $f0ff: 00        
            rti                ; $f100: 40        

;-------------------------------------------------------------------------------
            bvc __f153         ; $f101: 50 50     
            bvc __f155         ; $f103: 50 50     
            bvc __f107         ; $f105: 50 00     
__f107:     brk                ; $f107: 00        
            .hex 44 55         ; $f108: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f10a: 55 55     
            eor $55,x          ; $f10c: 55 55     
            brk                ; $f10e: 00        
            brk                ; $f10f: 00        
            .hex 44 59         ; $f110: 44 59     Invalid Opcode - NOP $59
            .hex fa            ; $f112: fa        Invalid Opcode - NOP 
__f113:     lsr $55,x          ; $f113: 56 55     
__f115:     eor $00,x          ; $f115: 55 00     
            brk                ; $f117: 00        
            .hex 44 55         ; $f118: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f11a: 55 55     
            eor $55,x          ; $f11c: 55 55     
            brk                ; $f11e: 00        
            brk                ; $f11f: 00        
            .hex 44 55         ; $f120: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f122: 55 55     
            eor $55,x          ; $f124: 55 55     
            brk                ; $f126: 00        
            brk                ; $f127: 00        
            .hex 44 55         ; $f128: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f12a: 55 55     
            eor $55,x          ; $f12c: 55 55     
            brk                ; $f12e: 00        
            brk                ; $f12f: 00        
            .hex 44 55         ; $f130: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f132: 55 55     
            eor $55,x          ; $f134: 55 55     
            brk                ; $f136: 00        
            brk                ; $f137: 00        
            .hex 44 55         ; $f138: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f13a: 55 55     
            eor $55,x          ; $f13c: 55 55     
            brk                ; $f13e: 00        
            brk                ; $f13f: 00        
            rti                ; $f140: 40        

;-------------------------------------------------------------------------------
            bvc __f193         ; $f141: 50 50     
            bvc __f195         ; $f143: 50 50     
            bvc __f147         ; $f145: 50 00     
__f147:     brk                ; $f147: 00        
            .hex 44 55         ; $f148: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f14a: 55 55     
            eor $55,x          ; $f14c: 55 55     
            brk                ; $f14e: 00        
            brk                ; $f14f: 00        
            .hex 44 55         ; $f150: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $f152: 55        Suspected data
__f153:     eor $55,x          ; $f153: 55 55     
__f155:     eor $00,x          ; $f155: 55 00     
            brk                ; $f157: 00        
            dey                ; $f158: 88        
            tax                ; $f159: aa        
            tax                ; $f15a: aa        
            tax                ; $f15b: aa        
            tax                ; $f15c: aa        
            tax                ; $f15d: aa        
            brk                ; $f15e: 00        
            brk                ; $f15f: 00        
            .hex 44 55         ; $f160: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f162: 55 55     
            eor $55,x          ; $f164: 55 55     
            brk                ; $f166: 00        
            brk                ; $f167: 00        
            .hex 44 55         ; $f168: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f16a: 55 55     
            eor $55,x          ; $f16c: 55 55     
            brk                ; $f16e: 00        
            brk                ; $f16f: 00        
            .hex 44 55         ; $f170: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f172: 55 55     
            eor $55,x          ; $f174: 55 55     
            brk                ; $f176: 00        
            brk                ; $f177: 00        
            .hex 44 55         ; $f178: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f17a: 55 55     
            eor $55,x          ; $f17c: 55 55     
            brk                ; $f17e: 00        
            brk                ; $f17f: 00        
            rti                ; $f180: 40        

;-------------------------------------------------------------------------------
            bvc __f1d3         ; $f181: 50 50     
            bvc __f1d5         ; $f183: 50 50     
            bvc __f187         ; $f185: 50 00     
__f187:     brk                ; $f187: 00        
            .hex 44 55         ; $f188: 44 55     Invalid Opcode - NOP $55
            sta $95,x          ; $f18a: 95 95     
            eor $55,x          ; $f18c: 55 55     
            brk                ; $f18e: 00        
            brk                ; $f18f: 00        
            .hex 44 59         ; $f190: 44 59     Invalid Opcode - NOP $59
            .hex a6            ; $f192: a6        Suspected data
__f193:     lda $6a            ; $f193: a5 6a     
__f195:     eor $00,x          ; $f195: 55 00     
            brk                ; $f197: 00        
            .hex 44 55         ; $f198: 44 55     Invalid Opcode - NOP $55
            eor $56,x          ; $f19a: 55 56     
            eor $55,x          ; $f19c: 55 55     
            brk                ; $f19e: 00        
            brk                ; $f19f: 00        
            .hex 44 55         ; $f1a0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1a2: 55 55     
            eor $55,x          ; $f1a4: 55 55     
            brk                ; $f1a6: 00        
            brk                ; $f1a7: 00        
            .hex 44 55         ; $f1a8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1aa: 55 55     
            eor $55,x          ; $f1ac: 55 55     
            brk                ; $f1ae: 00        
            brk                ; $f1af: 00        
            .hex 44 55         ; $f1b0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1b2: 55 55     
            eor $55,x          ; $f1b4: 55 55     
            brk                ; $f1b6: 00        
            brk                ; $f1b7: 00        
            .hex 44 55         ; $f1b8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1ba: 55 55     
            eor $55,x          ; $f1bc: 55 55     
            brk                ; $f1be: 00        
            brk                ; $f1bf: 00        
            rti                ; $f1c0: 40        

;-------------------------------------------------------------------------------
            bvc __f213         ; $f1c1: 50 50     
            bvc __f215         ; $f1c3: 50 50     
            bvc __f1c7         ; $f1c5: 50 00     
__f1c7:     brk                ; $f1c7: 00        
            pha                ; $f1c8: 48        
            .hex 5a            ; $f1c9: 5a        Invalid Opcode - NOP 
            lsr $55,x          ; $f1ca: 56 55     
            .hex 5a            ; $f1cc: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $f1cd: 5a        Invalid Opcode - NOP 
            brk                ; $f1ce: 00        
            brk                ; $f1cf: 00        
            sty $67af          ; $f1d0: 8c af 67  
__f1d3:     eor $af,x          ; $f1d3: 55 af     
__f1d5:     .hex af 00 00      ; $f1d5: af 00 00  Bad Addr Mode - LAX $0000
            jmp $575f          ; $f1d8: 4c 5f 57  

;-------------------------------------------------------------------------------
            eor $5f,x          ; $f1db: 55 5f     
            .hex 5f 00 00      ; $f1dd: 5f 00 00  Bad Addr Mode - SRE $0000,x
            .hex 44 55         ; $f1e0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1e2: 55 55     
            eor $55,x          ; $f1e4: 55 55     
            brk                ; $f1e6: 00        
            brk                ; $f1e7: 00        
            .hex 44 55         ; $f1e8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1ea: 55 55     
            eor $55,x          ; $f1ec: 55 55     
            brk                ; $f1ee: 00        
            brk                ; $f1ef: 00        
            .hex 44 55         ; $f1f0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1f2: 55 55     
            eor $55,x          ; $f1f4: 55 55     
            brk                ; $f1f6: 00        
            brk                ; $f1f7: 00        
            .hex 44 55         ; $f1f8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f1fa: 55 55     
            eor $55,x          ; $f1fc: 55 55     
            brk                ; $f1fe: 00        
            brk                ; $f1ff: 00        
            rti                ; $f200: 40        

;-------------------------------------------------------------------------------
            bvc __f253         ; $f201: 50 50     
            bvc __f255         ; $f203: 50 50     
            bvc __f207         ; $f205: 50 00     
__f207:     brk                ; $f207: 00        
            cpy $95            ; $f208: c4 95     
            adc $55,x          ; $f20a: 75 55     
            eor $55,x          ; $f20c: 55 55     
            brk                ; $f20e: 00        
            brk                ; $f20f: 00        
            sty __ff99         ; $f210: 8c 99 ff  
__f213:     .hex 99 f7         ; $f213: 99 f7     Suspected data
__f215:     sta $00,x          ; $f215: 95 00     
            brk                ; $f217: 00        
            .hex 44 55         ; $f218: 44 55     Invalid Opcode - NOP $55
            .hex 59 59 9f      ; $f21a: 59 59 9f  
            sta $0000,y        ; $f21d: 99 00 00  
            .hex 44 55         ; $f220: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f222: 55 55     
            eor $55,x          ; $f224: 55 55     
            brk                ; $f226: 00        
            brk                ; $f227: 00        
            .hex 44 55         ; $f228: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f22a: 55 55     
            eor $55,x          ; $f22c: 55 55     
            brk                ; $f22e: 00        
            brk                ; $f22f: 00        
            .hex 44 55         ; $f230: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f232: 55 55     
            eor $55,x          ; $f234: 55 55     
            brk                ; $f236: 00        
            brk                ; $f237: 00        
            .hex 44 55         ; $f238: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f23a: 55 55     
            eor $55,x          ; $f23c: 55 55     
            brk                ; $f23e: 00        
            brk                ; $f23f: 00        
            rti                ; $f240: 40        

;-------------------------------------------------------------------------------
            bvc __f293         ; $f241: 50 50     
            bvc __f295         ; $f243: 50 50     
            bvc __f247         ; $f245: 50 00     
__f247:     brk                ; $f247: 00        
            pha                ; $f248: 48        
            adc $59            ; $f249: 65 59     
            adc $6579          ; $f24b: 6d 79 65  
            brk                ; $f24e: 00        
            brk                ; $f24f: 00        
            jmp $6579          ; $f250: 4c 79 65  

;-------------------------------------------------------------------------------
__f253:     .hex 59 6d         ; $f253: 59 6d     Suspected data
__f255:     adc $0000,y        ; $f255: 79 00 00  
            pha                ; $f258: 48        
            adc $6579          ; $f259: 6d 79 65  
            eor $006d,y        ; $f25c: 59 6d 00  
            brk                ; $f25f: 00        
            .hex 44 59         ; $f260: 44 59     Invalid Opcode - NOP $59
            eor $5559,x        ; $f262: 5d 59 55  
            eor $0000,y        ; $f265: 59 00 00  
            .hex 44 55         ; $f268: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f26a: 55 55     
            eor $55,x          ; $f26c: 55 55     
            brk                ; $f26e: 00        
            brk                ; $f26f: 00        
            .hex 44 55         ; $f270: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f272: 55 55     
            eor $55,x          ; $f274: 55 55     
            brk                ; $f276: 00        
            brk                ; $f277: 00        
            .hex 44 55         ; $f278: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f27a: 55 55     
            eor $55,x          ; $f27c: 55 55     
            brk                ; $f27e: 00        
            brk                ; $f27f: 00        
            rti                ; $f280: 40        

;-------------------------------------------------------------------------------
            bvc __f2d3         ; $f281: 50 50     
            bvc __f2d5         ; $f283: 50 50     
            bvc __f287         ; $f285: 50 00     
__f287:     brk                ; $f287: 00        
            .hex 44 55         ; $f288: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f28a: 55 55     
            eor $55,x          ; $f28c: 55 55     
            brk                ; $f28e: 00        
            brk                ; $f28f: 00        
            .hex 44 55         ; $f290: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $f292: 55        Suspected data
__f293:     lda $a5            ; $f293: a5 a5     
__f295:     eor $00,x          ; $f295: 55 00     
            brk                ; $f297: 00        
            .hex 44 d5         ; $f298: 44 d5     Invalid Opcode - NOP $d5
            sbc $f5,x          ; $f29a: f5 f5     
            sbc $55,x          ; $f29c: f5 55     
            brk                ; $f29e: 00        
            brk                ; $f29f: 00        
            .hex 44 55         ; $f2a0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2a2: 55 55     
            eor $55,x          ; $f2a4: 55 55     
            brk                ; $f2a6: 00        
            brk                ; $f2a7: 00        
            .hex 44 55         ; $f2a8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2aa: 55 55     
            eor $55,x          ; $f2ac: 55 55     
            brk                ; $f2ae: 00        
            brk                ; $f2af: 00        
            .hex 44 55         ; $f2b0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2b2: 55 55     
            eor $55,x          ; $f2b4: 55 55     
            brk                ; $f2b6: 00        
            brk                ; $f2b7: 00        
            .hex 44 55         ; $f2b8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2ba: 55 55     
            eor $55,x          ; $f2bc: 55 55     
            brk                ; $f2be: 00        
            brk                ; $f2bf: 00        
            rti                ; $f2c0: 40        

;-------------------------------------------------------------------------------
            bvc __f313         ; $f2c1: 50 50     
            bvc __f315         ; $f2c3: 50 50     
            bvc __f2c7         ; $f2c5: 50 00     
__f2c7:     brk                ; $f2c7: 00        
            .hex 44 55         ; $f2c8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2ca: 55 55     
            eor $55,x          ; $f2cc: 55 55     
            brk                ; $f2ce: 00        
            brk                ; $f2cf: 00        
            .hex 44 d5         ; $f2d0: 44 d5     Invalid Opcode - NOP $d5
            .hex f5            ; $f2d2: f5        Suspected data
__f2d3:     eor $95,x          ; $f2d3: 55 95     
__f2d5:     adc $00            ; $f2d5: 65 00     
            brk                ; $f2d7: 00        
            .hex 44 dd         ; $f2d8: 44 dd     Invalid Opcode - NOP $dd
            .hex ff bb aa      ; $f2da: ff bb aa  Invalid Opcode - ISC __aabb,x
            ror $00            ; $f2dd: 66 00     
            brk                ; $f2df: 00        
            .hex 44 5d         ; $f2e0: 44 5d     Invalid Opcode - NOP $5d
            .hex 5f 5b 5a      ; $f2e2: 5f 5b 5a  Invalid Opcode - SRE $5a5b,x
            lsr $00,x          ; $f2e5: 56 00     
            brk                ; $f2e7: 00        
            .hex 44 55         ; $f2e8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2ea: 55 55     
            eor $55,x          ; $f2ec: 55 55     
            brk                ; $f2ee: 00        
            brk                ; $f2ef: 00        
            .hex 44 55         ; $f2f0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2f2: 55 55     
            eor $55,x          ; $f2f4: 55 55     
            brk                ; $f2f6: 00        
            brk                ; $f2f7: 00        
            .hex 44 55         ; $f2f8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f2fa: 55 55     
            eor $55,x          ; $f2fc: 55 55     
            brk                ; $f2fe: 00        
            brk                ; $f2ff: 00        
            rti                ; $f300: 40        

;-------------------------------------------------------------------------------
            bvc __f353         ; $f301: 50 50     
            bvc __f355         ; $f303: 50 50     
            bvc __f307         ; $f305: 50 00     
__f307:     brk                ; $f307: 00        
            .hex 44 55         ; $f308: 44 55     Invalid Opcode - NOP $55
            eor $a9,x          ; $f30a: 55 a9     
            .hex fa            ; $f30c: fa        Invalid Opcode - NOP 
            adc $00,x          ; $f30d: 75 00     
            brk                ; $f30f: 00        
            .hex 44 55         ; $f310: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $f312: 55        Suspected data
__f313:     tax                ; $f313: aa        
            .hex ae            ; $f314: ae        Suspected data
__f315:     ror $00            ; $f315: 66 00     
            brk                ; $f317: 00        
            .hex 44 55         ; $f318: 44 55     Invalid Opcode - NOP $55
            eor $59,x          ; $f31a: 55 59     
            .hex 5a            ; $f31c: 5a        Invalid Opcode - NOP 
            eor $00,x          ; $f31d: 55 00     
            brk                ; $f31f: 00        
            .hex 44 55         ; $f320: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f322: 55 55     
            eor $55,x          ; $f324: 55 55     
            brk                ; $f326: 00        
            brk                ; $f327: 00        
            .hex 44 55         ; $f328: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f32a: 55 55     
            eor $55,x          ; $f32c: 55 55     
            brk                ; $f32e: 00        
            brk                ; $f32f: 00        
            .hex 44 55         ; $f330: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f332: 55 55     
            eor $55,x          ; $f334: 55 55     
            brk                ; $f336: 00        
            brk                ; $f337: 00        
            .hex 44 55         ; $f338: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f33a: 55 55     
            eor $55,x          ; $f33c: 55 55     
            brk                ; $f33e: 00        
            brk                ; $f33f: 00        
            rti                ; $f340: 40        

;-------------------------------------------------------------------------------
            bvc __f393         ; $f341: 50 50     
            bvc __f395         ; $f343: 50 50     
            ldy #$00           ; $f345: a0 00     
            brk                ; $f347: 00        
            .hex 44 95         ; $f348: 44 95     Invalid Opcode - NOP $95
            .hex 5a            ; $f34a: 5a        Invalid Opcode - NOP 
            .hex 5a            ; $f34b: 5a        Invalid Opcode - NOP 
            lsr $55,x          ; $f34c: 56 55     
            brk                ; $f34e: 00        
            brk                ; $f34f: 00        
            pha                ; $f350: 48        
            ldx $6a            ; $f351: a6 6a     
__f353:     eor $55,x          ; $f353: 55 55     
__f355:     eor $00,x          ; $f355: 55 00     
            brk                ; $f357: 00        
            jmp $7dfd          ; $f358: 4c fd 7d  

;-------------------------------------------------------------------------------
            sbc $7fdf,x        ; $f35b: fd df 7f  
            brk                ; $f35e: 00        
            brk                ; $f35f: 00        
            .hex 44 5d         ; $f360: 44 5d     Invalid Opcode - NOP $5d
            eor $5f55,x        ; $f362: 5d 55 5f  
            eor $00,x          ; $f365: 55 00     
            brk                ; $f367: 00        
            .hex 44 55         ; $f368: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f36a: 55 55     
            eor $55,x          ; $f36c: 55 55     
            brk                ; $f36e: 00        
            brk                ; $f36f: 00        
            .hex 44 55         ; $f370: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f372: 55 55     
            eor $55,x          ; $f374: 55 55     
            brk                ; $f376: 00        
            brk                ; $f377: 00        
            .hex 44 55         ; $f378: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f37a: 55 55     
            eor $55,x          ; $f37c: 55 55     
            brk                ; $f37e: 00        
            brk                ; $f37f: 00        
            rti                ; $f380: 40        

;-------------------------------------------------------------------------------
            .db $50, $50, $50, $50, $50, $0
            
__f387:     brk                ; $f387: 00        
            .hex 44 55         ; $f388: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f38a: 55 55     
            eor $55,x          ; $f38c: 55 55     
            brk                ; $f38e: 00        
            brk                ; $f38f: 00        
            .hex 44 55         ; $f390: 44 55     Invalid Opcode - NOP $55
            .hex 55            ; $f392: 55        Suspected data
__f393:     eor $55,x          ; $f393: 55 55     
__f395:     eor $00,x          ; $f395: 55 00     
            brk                ; $f397: 00        
            .hex 44 55         ; $f398: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f39a: 55 55     
            eor $55,x          ; $f39c: 55 55     
            brk                ; $f39e: 00        
            brk                ; $f39f: 00        
            .hex 44 55         ; $f3a0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f3a2: 55 55     
            eor $55,x          ; $f3a4: 55 55     
            brk                ; $f3a6: 00        
            brk                ; $f3a7: 00        
            .hex 44 55         ; $f3a8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f3aa: 55 55     
            eor $55,x          ; $f3ac: 55 55     
            brk                ; $f3ae: 00        
            brk                ; $f3af: 00        
            .hex 44 55         ; $f3b0: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f3b2: 55 55     
            eor $55,x          ; $f3b4: 55 55     
            brk                ; $f3b6: 00        
            brk                ; $f3b7: 00        
            .hex 44 55         ; $f3b8: 44 55     Invalid Opcode - NOP $55
            eor $55,x          ; $f3ba: 55 55     
            eor $55,x          ; $f3bc: 55 55     
            brk                ; $f3be: 00        
            brk                ; $f3bf: 00        
SetupSound: jmp SetupSound_i   ; $f3c0: 4c cc f3  

;-------------------------------------------------------------------------------
__f3c3:     jmp __f420         ; $f3c3: 4c 20 f4  

;-------------------------------------------------------------------------------
PlaySoundEffect:
            jmp PlaySoundEffect_i ; $f3c6: 4c 22 f4  

;-------------------------------------------------------------------------------
__f3c9:     jmp __f486         ; $f3c9: 4c 86 f4  

;-------------------------------------------------------------------------------
SetupSound_i: lda #$1f           ; $f3cc: a9 1f     .
            sta $4015          ; $f3ce: 8d 15 40  | Enable sound on all 5 channels
            lda #$c0           ; $f3d1: a9 c0     .
            sta $4017          ; $f3d3: 8d 17 40  | Set up joystick 2
            lda #$f0           ; $f3d6: a9 f0     .
            sta $4000          ; $f3d8: 8d 00 40  | 
            sta $4004          ; $f3db: 8d 04 40  |
            sta $400c          ; $f3de: 8d 0c 40  | Sound registers 0, 4, c = 0xf0
            lda #$80           ; $f3e1: a9 80     .
            sta $4008          ; $f3e3: 8d 08 40  | Sound register 8 = 0x80
            lda #$78           ; $f3e6: a9 78     .
            sta $4001          ; $f3e8: 8d 01 40  |
            sta $4005          ; $f3eb: 8d 05 40  |
            sta $4009          ; $f3ee: 8d 09 40  |
            sta $400d          ; $f3f1: 8d 0d 40  | Sound registers 1, 5, 9, d = 0x78
            lda #$f0           ; $f3f4: a9 f0     .
            sta $4002          ; $f3f6: 8d 02 40  |
            sta $4006          ; $f3f9: 8d 06 40  |
            sta $400a          ; $f3fc: 8d 0a 40  |
            sta $400e          ; $f3ff: 8d 0e 40  | Sound registers 2, 6, a, e = 0xf0
            lda #$08           ; $f402: a9 08     .
            sta $4003          ; $f404: 8d 03 40  |
            sta $4007          ; $f407: 8d 07 40  |
            sta $400b          ; $f40a: 8d 0b 40  |
            sta $400f          ; $f40d: 8d 0f 40  | Sound registers 3, 7, b, f = 0x8
            lda #$00           ; $f410: a9 00     .
            sta $4010          ; $f412: 8d 10 40  | Sound register 10 = 0
            ldx #$03           ; $f415: a2 03     . 
            lda #$7c           ; $f417: a9 7c     | (write 0x7c to $034a - $034b)
Loop_f419:  sta $034a,x        ; $f419: 9d 4a 03  | for x = 3..0
            dex                ; $f41c: ca        |  $34a + x = 0x7c
            bpl Loop_f419      ; $f41d: 10 fa     | 
            rts                ; $f41f: 60        . return

;-------------------------------------------------------------------------------
__f420:     lda #$00           ; $f420: a9 00     
PlaySoundEffect_i:
            ldx #$ff           ; $f422: a2 ff     
            stx $0300          ; $f424: 8e 00 03  
            asl                ; $f427: 0a        
            tax                ; $f428: aa        
            lda __f8eb,x       ; $f429: bd eb f8  
            sta $f3            ; $f42c: 85 f3     
            inx                ; $f42e: e8        
            lda __f8eb,x       ; $f42f: bd eb f8  
            sta $f4            ; $f432: 85 f4     
            ldy #$00           ; $f434: a0 00     
__f436:     lda ($f3),y        ; $f436: b1 f3     
            bmi __f480         ; $f438: 30 46     
            sta $f5            ; $f43a: 85 f5     
            asl                ; $f43c: 0a        
            sta $f6            ; $f43d: 85 f6     
            lda ($f3),y        ; $f43f: b1 f3     
            tax                ; $f441: aa        
            lda __f8a3,x       ; $f442: bd a3 f8  
            ora $0301          ; $f445: 0d 01 03  
            sta $0301          ; $f448: 8d 01 03  
            ldx $f5            ; $f44b: a6 f5     
            lda #$00           ; $f44d: a9 00     
            sta $0346,x        ; $f44f: 9d 46 03  
            sta $031a,x        ; $f452: 9d 1a 03  
            sta $033e,x        ; $f455: 9d 3e 03  
            sta $0316,x        ; $f458: 9d 16 03  
            sta $0342,x        ; $f45b: 9d 42 03  
            sta $0326,x        ; $f45e: 9d 26 03  
            ldx $f6            ; $f461: a6 f6     
            iny                ; $f463: c8        
            lda ($f3),y        ; $f464: b1 f3     
            sta $032e,x        ; $f466: 9d 2e 03  
            iny                ; $f469: c8        
            lda ($f3),y        ; $f46a: b1 f3     
            sta $032f,x        ; $f46c: 9d 2f 03  
            iny                ; $f46f: c8        
            lda #$00           ; $f470: a9 00     
            sta $0302,x        ; $f472: 9d 02 03  
            sta $0303,x        ; $f475: 9d 03 03  
            sta $030a,x        ; $f478: 9d 0a 03  
            sta $030b,x        ; $f47b: 9d 0b 03  
            beq __f436         ; $f47e: f0 b6     
__f480:     ldx #$00           ; $f480: a2 00     
            stx $0300          ; $f482: 8e 00 03  
__f485:     rts                ; $f485: 60        

;-------------------------------------------------------------------------------
__f486:     lda $0300          ; $f486: ad 00 03  
            bne __f485         ; $f489: d0 fa     
            lda #$10           ; $f48b: a9 10     
            sta $eb            ; $f48d: 85 eb     
            lda $0301          ; $f48f: ad 01 03  
            ldx #$00           ; $f492: a2 00     
            jsr __f49d         ; $f494: 20 9d f4  
            sta $0301          ; $f497: 8d 01 03  
            jmp __f692         ; $f49a: 4c 92 f6  

;-------------------------------------------------------------------------------
__f49d:     sta $e1            ; $f49d: 85 e1     
            lda #$01           ; $f49f: a9 01     
__f4a1:     stx $e3            ; $f4a1: 86 e3     
            sta $ea            ; $f4a3: 85 ea     
            sta $0322,x        ; $f4a5: 9d 22 03  
            bit $e1            ; $f4a8: 24 e1     
            beq __f4b5         ; $f4aa: f0 09     
            pha                ; $f4ac: 48        
            txa                ; $f4ad: 8a        
            asl                ; $f4ae: 0a        
            sta $e2            ; $f4af: 85 e2     
            jsr __f4c0         ; $f4b1: 20 c0 f4  
            pla                ; $f4b4: 68        
__f4b5:     ldx $e3            ; $f4b5: a6 e3     
            inx                ; $f4b7: e8        
            asl                ; $f4b8: 0a        
            cmp $eb            ; $f4b9: c5 eb     
            bne __f4a1         ; $f4bb: d0 e4     
            lda $e1            ; $f4bd: a5 e1     
            rts                ; $f4bf: 60        

;-------------------------------------------------------------------------------
__f4c0:     lda $0342,x        ; $f4c0: bd 42 03  
            beq __f4cd         ; $f4c3: f0 08     
            dec $0342,x        ; $f4c5: de 42 03  
            beq __f4cd         ; $f4c8: f0 03     
            jmp __f4ed         ; $f4ca: 4c ed f4  

;-------------------------------------------------------------------------------
__f4cd:     ldx $e2            ; $f4cd: a6 e2     
            lda $032e,x        ; $f4cf: bd 2e 03  
            sta $e4            ; $f4d2: 85 e4     
            lda $032f,x        ; $f4d4: bd 2f 03  
            sta $e5            ; $f4d7: 85 e5     
            ldx $e3            ; $f4d9: a6 e3     
            jsr __f4ee         ; $f4db: 20 ee f4  
            jsr __f685         ; $f4de: 20 85 f6  
            ldx $e2            ; $f4e1: a6 e2     
            lda $e4            ; $f4e3: a5 e4     
            sta $032e,x        ; $f4e5: 9d 2e 03  
            lda $e5            ; $f4e8: a5 e5     
            sta $032f,x        ; $f4ea: 9d 2f 03  
__f4ed:     rts                ; $f4ed: 60        

;-------------------------------------------------------------------------------
__f4ee:     lda $033e,x        ; $f4ee: bd 3e 03  
            and #$df           ; $f4f1: 29 df     
            sta $033e,x        ; $f4f3: 9d 3e 03  
            lda #$ff           ; $f4f6: a9 ff     
            sta $0322,x        ; $f4f8: 9d 22 03  
            ldy #$00           ; $f4fb: a0 00     
__f4fd:     ldx $e3            ; $f4fd: a6 e3     
            lda $0342,x        ; $f4ff: bd 42 03  
            bne __f50f         ; $f502: d0 0b     
            lda ($e4),y        ; $f504: b1 e4     
            iny                ; $f506: c8        
            ora #$00           ; $f507: 09 00     
            bpl __f537         ; $f509: 10 2c     
            cmp #$c0           ; $f50b: c9 c0     
            bcs __f510         ; $f50d: b0 01     
__f50f:     rts                ; $f50f: 60        

;-------------------------------------------------------------------------------
__f510:     and #$0f           ; $f510: 29 0f     
            asl                ; $f512: 0a        
            sta $e6            ; $f513: 85 e6     
            lda __f7d1         ; $f515: ad d1 f7  
            adc $e6            ; $f518: 65 e6     
            sta $e6            ; $f51a: 85 e6     
            lda __f7d2         ; $f51c: ad d2 f7  
            adc #$00           ; $f51f: 69 00     
            sta $e7            ; $f521: 85 e7     
            tya                ; $f523: 98        
            pha                ; $f524: 48        
            ldy #$00           ; $f525: a0 00     
            lda ($e6),y        ; $f527: b1 e6     
            pha                ; $f529: 48        
            iny                ; $f52a: c8        
            lda ($e6),y        ; $f52b: b1 e6     
            sta $e7            ; $f52d: 85 e7     
            pla                ; $f52f: 68        
            sta $e6            ; $f530: 85 e6     
            pla                ; $f532: 68        
            tay                ; $f533: a8        
            jmp ($00e6)        ; $f534: 6c e6 00  

;-------------------------------------------------------------------------------
__f537:     pha                ; $f537: 48        
            txa                ; $f538: 8a        
            and #$03           ; $f539: 29 03     
            cmp #$03           ; $f53b: c9 03     
            bne __f543         ; $f53d: d0 04     
            pla                ; $f53f: 68        
            jmp __f56e         ; $f540: 4c 6e f5  

;-------------------------------------------------------------------------------
__f543:     pla                ; $f543: 68        
            cmp #$7c           ; $f544: c9 7c     
            beq __f56e         ; $f546: f0 26     
            pha                ; $f548: 48        
            and #$0f           ; $f549: 29 0f     
            sta $e6            ; $f54b: 85 e6     
            lda $0346,x        ; $f54d: bd 46 03  
            and #$0f           ; $f550: 29 0f     
            clc                ; $f552: 18        
            adc $e6            ; $f553: 65 e6     
            and #$1f           ; $f555: 29 1f     
            cmp #$0c           ; $f557: c9 0c     
            bcc __f55e         ; $f559: 90 03     
            clc                ; $f55b: 18        
            adc #$04           ; $f55c: 69 04     
__f55e:     sta $e6            ; $f55e: 85 e6     
            pla                ; $f560: 68        
            and #$f0           ; $f561: 29 f0     
            adc $e6            ; $f563: 65 e6     
            sta $e6            ; $f565: 85 e6     
            lda $0346,x        ; $f567: bd 46 03  
            and #$f0           ; $f56a: 29 f0     
            adc $e6            ; $f56c: 65 e6     
__f56e:     sta $034a,x        ; $f56e: 9d 4a 03  
            lda #$00           ; $f571: a9 00     
            cpx #$08           ; $f573: e0 08     
            bne __f57d         ; $f575: d0 06     
            sta $0333          ; $f577: 8d 33 03  
            sta $032f          ; $f57a: 8d 2f 03  
__f57d:     sta $032a,x        ; $f57d: 9d 2a 03  
            sta $0326,x        ; $f580: 9d 26 03  
            lda ($e4),y        ; $f583: b1 e4     
            iny                ; $f585: c8        
            ora #$00           ; $f586: 09 00     
            bpl __f59c         ; $f588: 10 12     
            cmp #$c0           ; $f58a: c9 c0     
            bcs __f59c         ; $f58c: b0 0e     
            and #$3f           ; $f58e: 29 3f     
            tax                ; $f590: aa        
            lda __f8ab,x       ; $f591: bd ab f8  
            ldx $e3            ; $f594: a6 e3     
            sta $0312,x        ; $f596: 9d 12 03  
            jmp __f5a0         ; $f599: 4c a0 f5  

;-------------------------------------------------------------------------------
__f59c:     lda $0312,x        ; $f59c: bd 12 03  
            dey                ; $f59f: 88        
__f5a0:     sta $0342,x        ; $f5a0: 9d 42 03  
            jmp __f4fd         ; $f5a3: 4c fd f4  

;-------------------------------------------------------------------------------
            lda #$00           ; $f5a6: a9 00     
            sta $032a,x        ; $f5a8: 9d 2a 03  
            sta $0326,x        ; $f5ab: 9d 26 03  
            lda ($e4),y        ; $f5ae: b1 e4     
            iny                ; $f5b0: c8        
            asl                ; $f5b1: 0a        
            tax                ; $f5b2: aa        
            lda __f90f,x       ; $f5b3: bd 0f f9  
            pha                ; $f5b6: 48        
            inx                ; $f5b7: e8        
            lda __f90f,x       ; $f5b8: bd 0f f9  
            ldx $e2            ; $f5bb: a6 e2     
            sta $0337,x        ; $f5bd: 9d 37 03  
            pla                ; $f5c0: 68        
            sta $0336,x        ; $f5c1: 9d 36 03  
            jmp __f4fd         ; $f5c4: 4c fd f4  

;-------------------------------------------------------------------------------
            lda ($e4),y        ; $f5c7: b1 e4     
            iny                ; $f5c9: c8        
            sta $031e,x        ; $f5ca: 9d 1e 03  
            lda $033e,x        ; $f5cd: bd 3e 03  
            ora #$20           ; $f5d0: 09 20     
            sta $033e,x        ; $f5d2: 9d 3e 03  
            lda ($e4),y        ; $f5d5: b1 e4     
            iny                ; $f5d7: c8        
            jmp __f537         ; $f5d8: 4c 37 f5  

;-------------------------------------------------------------------------------
            lda ($e4),y        ; $f5db: b1 e4     
            iny                ; $f5dd: c8        
            and #$c0           ; $f5de: 29 c0     
            sta $e6            ; $f5e0: 85 e6     
            lda $033e,x        ; $f5e2: bd 3e 03  
            and #$3f           ; $f5e5: 29 3f     
            ora $e6            ; $f5e7: 05 e6     
            sta $033e,x        ; $f5e9: 9d 3e 03  
            jmp __f4fd         ; $f5ec: 4c fd f4  

;-------------------------------------------------------------------------------
            lda ($e4),y        ; $f5ef: b1 e4     
            iny                ; $f5f1: c8        
            sta $031a,x        ; $f5f2: 9d 1a 03  
            jmp __f4fd         ; $f5f5: 4c fd f4  

;-------------------------------------------------------------------------------
            lda ($e4),y        ; $f5f8: b1 e4     
            iny                ; $f5fa: c8        
            sta $0346,x        ; $f5fb: 9d 46 03  
            jmp __f4fd         ; $f5fe: 4c fd f4  

;-------------------------------------------------------------------------------
__f601:     lda ($e4),y        ; $f601: b1 e4     
            iny                ; $f603: c8        
            sta $0316,x        ; $f604: 9d 16 03  
            jsr __f685         ; $f607: 20 85 f6  
            ldx $e2            ; $f60a: a6 e2     
            lda $e4            ; $f60c: a5 e4     
            sta $0302,x        ; $f60e: 9d 02 03  
            lda $e5            ; $f611: a5 e5     
            sta $0303,x        ; $f613: 9d 03 03  
            jmp __f4fd         ; $f616: 4c fd f4  

;-------------------------------------------------------------------------------
            lda ($e4),y        ; $f619: b1 e4     
            iny                ; $f61b: c8        
            pha                ; $f61c: 48        
            lda ($e4),y        ; $f61d: b1 e4     
            iny                ; $f61f: c8        
            sta $e5            ; $f620: 85 e5     
            pla                ; $f622: 68        
            sta $e4            ; $f623: 85 e4     
            ldy #$00           ; $f625: a0 00     
            jmp __f4fd         ; $f627: 4c fd f4  

;-------------------------------------------------------------------------------
            lda ($e4),y        ; $f62a: b1 e4     
            iny                ; $f62c: c8        
            pha                ; $f62d: 48        
            lda ($e4),y        ; $f62e: b1 e4     
            iny                ; $f630: c8        
            pha                ; $f631: 48        
            jsr __f685         ; $f632: 20 85 f6  
            ldx $e2            ; $f635: a6 e2     
            lda $e4            ; $f637: a5 e4     
            sta $030a,x        ; $f639: 9d 0a 03  
            lda $e5            ; $f63c: a5 e5     
            sta $030b,x        ; $f63e: 9d 0b 03  
            pla                ; $f641: 68        
            sta $e5            ; $f642: 85 e5     
            pla                ; $f644: 68        
            sta $e4            ; $f645: 85 e4     
            jmp __f4fd         ; $f647: 4c fd f4  

;-------------------------------------------------------------------------------
            lda $0316,x        ; $f64a: bd 16 03  
            beq __f665         ; $f64d: f0 16     
            dec $0316,x        ; $f64f: de 16 03  
            beq __f662         ; $f652: f0 0e     
            ldx $e2            ; $f654: a6 e2     
            lda $0302,x        ; $f656: bd 02 03  
            sta $e4            ; $f659: 85 e4     
            lda $0303,x        ; $f65b: bd 03 03  
            sta $e5            ; $f65e: 85 e5     
            ldy #$00           ; $f660: a0 00     
__f662:     jmp __f4fd         ; $f662: 4c fd f4  

;-------------------------------------------------------------------------------
__f665:     ldx $e2            ; $f665: a6 e2     
            lda $030b,x        ; $f667: bd 0b 03  
            beq __f67c         ; $f66a: f0 10     
            sta $e5            ; $f66c: 85 e5     
            lda $030a,x        ; $f66e: bd 0a 03  
            sta $e4            ; $f671: 85 e4     
            lda #$00           ; $f673: a9 00     
            sta $030b,x        ; $f675: 9d 0b 03  
            tay                ; $f678: a8        
            jmp __f4fd         ; $f679: 4c fd f4  

;-------------------------------------------------------------------------------
__f67c:     ldx $e3            ; $f67c: a6 e3     
            lda $e1            ; $f67e: a5 e1     
            eor $ea            ; $f680: 45 ea     
            sta $e1            ; $f682: 85 e1     
            rts                ; $f684: 60        

;-------------------------------------------------------------------------------
__f685:     tya                ; $f685: 98        
            clc                ; $f686: 18        
            adc $e4            ; $f687: 65 e4     
            sta $e4            ; $f689: 85 e4     
            bcc __f68f         ; $f68b: 90 02     
            inc $e5            ; $f68d: e6 e5     
__f68f:     ldy #$00           ; $f68f: a0 00     
            rts                ; $f691: 60        

;-------------------------------------------------------------------------------
__f692:     lda #$00           ; $f692: a9 00     
            sta $ef            ; $f694: 85 ef     
            sta $f1            ; $f696: 85 f1     
            lda #$01           ; $f698: a9 01     
            sta $ea            ; $f69a: 85 ea     
__f69c:     lda $ea            ; $f69c: a5 ea     
            and $0301          ; $f69e: 2d 01 03  
            bne __f6a6         ; $f6a1: d0 03     
            jmp __f76e         ; $f6a3: 4c 6e f7  

;-------------------------------------------------------------------------------
__f6a6:     ldx $ef            ; $f6a6: a6 ef     
            lda $ea            ; $f6a8: a5 ea     
            cmp #$04           ; $f6aa: c9 04     
            beq __f6b5         ; $f6ac: f0 07     
            lda $033e,x        ; $f6ae: bd 3e 03  
            and #$20           ; $f6b1: 29 20     
            bne __f6c1         ; $f6b3: d0 0c     
__f6b5:     ldy #$78           ; $f6b5: a0 78     
            lda $034a,x        ; $f6b7: bd 4a 03  
            cmp #$7c           ; $f6ba: c9 7c     
            bne __f6c4         ; $f6bc: d0 06     
            jmp __f76e         ; $f6be: 4c 6e f7  

;-------------------------------------------------------------------------------
__f6c1:     ldy $031e,x        ; $f6c1: bc 1e 03  
__f6c4:     sty $ec            ; $f6c4: 84 ec     
            jsr __f784         ; $f6c6: 20 84 f7  
            bcc __f6fe         ; $f6c9: 90 33     
            lda $ea            ; $f6cb: a5 ea     
            cmp #$04           ; $f6cd: c9 04     
            bne __f6dd         ; $f6cf: d0 0c     
            lda ($e6),y        ; $f6d1: b1 e6     
            sta $eb            ; $f6d3: 85 eb     
            lda #$ff           ; $f6d5: a9 ff     
            sta $0322,x        ; $f6d7: 9d 22 03  
            jmp __f6fe         ; $f6da: 4c fe f6  

;-------------------------------------------------------------------------------
__f6dd:     lda ($e6),y        ; $f6dd: b1 e6     
            sec                ; $f6df: 38        
            sbc $031a,x        ; $f6e0: fd 1a 03  
            bcs __f6e7         ; $f6e3: b0 02     
            lda #$00           ; $f6e5: a9 00     
__f6e7:     and #$0f           ; $f6e7: 29 0f     
            ora #$10           ; $f6e9: 09 10     
            sta $e8            ; $f6eb: 85 e8     
            lda $033e,x        ; $f6ed: bd 3e 03  
            and #$f0           ; $f6f0: 29 f0     
            ora $e8            ; $f6f2: 05 e8     
            sta $033e,x        ; $f6f4: 9d 3e 03  
            ora #$20           ; $f6f7: 09 20     
            ldy $f1            ; $f6f9: a4 f1     
            sta $4000,y        ; $f6fb: 99 00 40  
__f6fe:     lda $ea            ; $f6fe: a5 ea     
            cmp #$04           ; $f700: c9 04     
            beq __f726         ; $f702: f0 22     
            lda $033e,x        ; $f704: bd 3e 03  
            ora #$20           ; $f707: 09 20     
            sta $eb            ; $f709: 85 eb     
            lda $ea            ; $f70b: a5 ea     
            cmp #$08           ; $f70d: c9 08     
            bne __f71c         ; $f70f: d0 0b     
            lda $034a,x        ; $f711: bd 4a 03  
            and #$0f           ; $f714: 29 0f     
            sta $ed            ; $f716: 85 ed     
            lda #$18           ; $f718: a9 18     
            bne __f734         ; $f71a: d0 18     
__f71c:     lda $034a,x        ; $f71c: bd 4a 03  
            cmp #$7f           ; $f71f: c9 7f     
            bne __f726         ; $f721: d0 03     
            jmp __f759         ; $f723: 4c 59 f7  

;-------------------------------------------------------------------------------
__f726:     jsr __f7b8         ; $f726: 20 b8 f7  
            lda __f7fb,y       ; $f729: b9 fb f7  
            sta $ed            ; $f72c: 85 ed     
            iny                ; $f72e: c8        
            lda __f7fb,y       ; $f72f: b9 fb f7  
            ora #$08           ; $f732: 09 08     
__f734:     sta $ee            ; $f734: 85 ee     
            lda $0322,x        ; $f736: bd 22 03  
            bpl __f74b         ; $f739: 10 10     
            ldx $f1            ; $f73b: a6 f1     
            ldy #$00           ; $f73d: a0 00     
__f73f:     lda $00eb,y        ; $f73f: b9 eb 00  
            sta $4000,x        ; $f742: 9d 00 40  
            inx                ; $f745: e8        
            iny                ; $f746: c8        
            cpy #$04           ; $f747: c0 04     
            bne __f73f         ; $f749: d0 f4     
__f74b:     ldx $ef            ; $f74b: a6 ef     
            lda $033e,x        ; $f74d: bd 3e 03  
            and #$20           ; $f750: 29 20     
            beq __f759         ; $f752: f0 05     
            lda #$7f           ; $f754: a9 7f     
            sta $034a,x        ; $f756: 9d 4a 03  
__f759:     lda $f1            ; $f759: a5 f1     
            clc                ; $f75b: 18        
            adc #$04           ; $f75c: 69 04     
            sta $f1            ; $f75e: 85 f1     
            inc $ef            ; $f760: e6 ef     
            asl $ea            ; $f762: 06 ea     
            lda $ea            ; $f764: a5 ea     
            cmp #$10           ; $f766: c9 10     
            beq __f76d         ; $f768: f0 03     
            jmp __f69c         ; $f76a: 4c 9c f6  

;-------------------------------------------------------------------------------
__f76d:     rts                ; $f76d: 60        

;-------------------------------------------------------------------------------
__f76e:     lda $ea            ; $f76e: a5 ea     
            cmp #$04           ; $f770: c9 04     
            bne __f77b         ; $f772: d0 07     
            lda #$80           ; $f774: a9 80     
            sta $4008          ; $f776: 8d 08 40  
            bne __f759         ; $f779: d0 de     
__f77b:     ldy $f1            ; $f77b: a4 f1     
            lda #$f0           ; $f77d: a9 f0     
            sta $4000,y        ; $f77f: 99 00 40  
            bne __f759         ; $f782: d0 d5     
__f784:     lda $0326,x        ; $f784: bd 26 03  
            beq __f78e         ; $f787: f0 05     
            dec $0326,x        ; $f789: de 26 03  
            clc                ; $f78c: 18        
            rts                ; $f78d: 60        

;-------------------------------------------------------------------------------
__f78e:     txa                ; $f78e: 8a        
            asl                ; $f78f: 0a        
            tax                ; $f790: aa        
            lda $0336,x        ; $f791: bd 36 03  
            sta $e6            ; $f794: 85 e6     
            lda $0337,x        ; $f796: bd 37 03  
            sta $e7            ; $f799: 85 e7     
            ldx $ef            ; $f79b: a6 ef     
            ldy $032a,x        ; $f79d: bc 2a 03  
            lda ($e6),y        ; $f7a0: b1 e6     
            .hex d0            ; $f7a2: d0        Suspected data
__f7a3:     .hex 04 9d         ; $f7a3: 04 9d     Invalid Opcode - NOP $9d
            rol                ; $f7a5: 2a        
            .hex 03 a8         ; $f7a6: 03 a8     Invalid Opcode - SLO ($a8,x)
            inc $032a,x        ; $f7a8: fe 2a 03  
            inc $032a,x        ; $f7ab: fe 2a 03  
            lda ($e6),y        ; $f7ae: b1 e6     
            sta $0326,x        ; $f7b0: 9d 26 03  
            iny                ; $f7b3: c8        
            lda ($e6),y        ; $f7b4: b1 e6     
            sec                ; $f7b6: 38        
            rts                ; $f7b7: 60        

;-------------------------------------------------------------------------------
__f7b8:     lda $034a,x        ; $f7b8: bd 4a 03  
            lsr                ; $f7bb: 4a        
            lsr                ; $f7bc: 4a        
            lsr                ; $f7bd: 4a        
            lsr                ; $f7be: 4a        
            and #$0f           ; $f7bf: 29 0f     
            tay                ; $f7c1: a8        
            lda __f7f3,y       ; $f7c2: b9 f3 f7  
            sta $e0            ; $f7c5: 85 e0     
            lda $034a,x        ; $f7c7: bd 4a 03  
            and #$0f           ; $f7ca: 29 0f     
            asl                ; $f7cc: 0a        
            adc $e0            ; $f7cd: 65 e0     
            tay                ; $f7cf: a8        
            rts                ; $f7d0: 60        

;-------------------------------------------------------------------------------
__f7d1:     .hex d3            ; $f7d1: d3        Suspected data
__f7d2:     .hex f7 a6         ; $f7d2: f7 a6     Invalid Opcode - ISC $a6,x
            sbc $c7,x          ; $f7d4: f5 c7     
            sbc $db,x          ; $f7d6: f5 db     
            sbc $ef,x          ; $f7d8: f5 ef     
            sbc $f8,x          ; $f7da: f5 f8     
            sbc $4a,x          ; $f7dc: f5 4a     
            inc $4a,x          ; $f7de: f6 4a     
            inc $4a,x          ; $f7e0: f6 4a     
            inc $01,x          ; $f7e2: f6 01     
            inc $19,x          ; $f7e4: f6 19     
            inc $2a,x          ; $f7e6: f6 2a     
            inc $4a,x          ; $f7e8: f6 4a     
            inc $4a,x          ; $f7ea: f6 4a     
            inc $4a,x          ; $f7ec: f6 4a     
            inc $4a,x          ; $f7ee: f6 4a     
            inc $4a,x          ; $f7f0: f6 4a     
            .hex f6            ; $f7f2: f6        Suspected data
__f7f3:     brk                ; $f7f3: 00        
            clc                ; $f7f4: 18        
            bmi __f83f         ; $f7f5: 30 48     
            rts                ; $f7f7: 60        

;-------------------------------------------------------------------------------
            sei                ; $f7f8: 78        
            bcc __f7a3         ; $f7f9: 90 a8     
__f7fb:     ldx $4e06          ; $f7fb: ae 06 4e  
            asl $f4            ; $f7fe: 06 f4     
            ora $9e            ; $f800: 05 9e     
            ora $4d            ; $f802: 05 4d     
            ora $01            ; $f804: 05 01     
            ora $b9            ; $f806: 05 b9     
            .hex 04 75         ; $f808: 04 75     Invalid Opcode - NOP $75
            .hex 04 35         ; $f80a: 04 35     Invalid Opcode - NOP $35
            .hex 04 f9         ; $f80c: 04 f9     Invalid Opcode - NOP $f9
            .hex 03 c0         ; $f80e: 03 c0     Invalid Opcode - SLO ($c0,x)
            .hex 03 8a         ; $f810: 03 8a     Invalid Opcode - SLO ($8a,x)
            .hex 03 57         ; $f812: 03 57     Invalid Opcode - SLO ($57,x)
            .hex 03 27         ; $f814: 03 27     Invalid Opcode - SLO ($27,x)
            .hex 03 fa         ; $f816: 03 fa     Invalid Opcode - SLO ($fa,x)
            .hex 02            ; $f818: 02        Invalid Opcode - KIL 
            .hex cf 02 a7      ; $f819: cf 02 a7  Invalid Opcode - DCP __a702
            .hex 02            ; $f81c: 02        Invalid Opcode - KIL 
            sta ($02,x)        ; $f81d: 81 02     
            eor $3b02,x        ; $f81f: 5d 02 3b  
            .hex 02            ; $f822: 02        Invalid Opcode - KIL 
            .hex 1b 02 fc      ; $f823: 1b 02 fc  Invalid Opcode - SLO __fc02,y
            ora ($e0,x)        ; $f826: 01 e0     
            ora ($c5,x)        ; $f828: 01 c5     
            ora ($ac,x)        ; $f82a: 01 ac     
            ora ($94,x)        ; $f82c: 01 94     
            ora ($7d,x)        ; $f82e: 01 7d     
            ora ($68,x)        ; $f830: 01 68     
            ora ($53,x)        ; $f832: 01 53     
            ora ($40,x)        ; $f834: 01 40     
            ora ($2e,x)        ; $f836: 01 2e     
            ora ($1d,x)        ; $f838: 01 1d     
            ora ($0d,x)        ; $f83a: 01 0d     
            ora ($fe,x)        ; $f83c: 01 fe     
            brk                ; $f83e: 00        
__f83f:     beq __f841         ; $f83f: f0 00     
__f841:     .hex e2 00         ; $f841: e2 00     Invalid Opcode - NOP #$00
            dec $00,x          ; $f843: d6 00     
            dex                ; $f845: ca        
            brk                ; $f846: 00        
            ldx __b400,y       ; $f847: be 00 b4  
            brk                ; $f84a: 00        
            tax                ; $f84b: aa        
            brk                ; $f84c: 00        
            ldy #$00           ; $f84d: a0 00     
            .hex 97 00         ; $f84f: 97 00     Invalid Opcode - SAX $00,y
            .hex 8f 00 87      ; $f851: 8f 00 87  Invalid Opcode - SAX __8700
            brk                ; $f854: 00        
            .hex 7f 00 78      ; $f855: 7f 00 78  Invalid Opcode - RRA $7800,x
            brk                ; $f858: 00        
            adc ($00),y        ; $f859: 71 00     
            .hex 6b 00         ; $f85b: 6b 00     Invalid Opcode - ARR #$00
            adc $00            ; $f85d: 65 00     
            .hex 5f 00 5a      ; $f85f: 5f 00 5a  Invalid Opcode - SRE $5a00,x
            brk                ; $f862: 00        
            eor $00,x          ; $f863: 55 00     
            bvc __f867         ; $f865: 50 00     
__f867:     jmp $4700          ; $f867: 4c 00 47  

;-------------------------------------------------------------------------------
            brk                ; $f86a: 00        
            .hex 43 00         ; $f86b: 43 00     Invalid Opcode - SRE ($00,x)
            rti                ; $f86d: 40        

;-------------------------------------------------------------------------------
            brk                ; $f86e: 00        
            .hex 3c 00 39      ; $f86f: 3c 00 39  Invalid Opcode - NOP $3900,x
            brk                ; $f872: 00        
            and $00,x          ; $f873: 35 00     
            .hex 32            ; $f875: 32        Invalid Opcode - KIL 
            brk                ; $f876: 00        
            bmi __f879         ; $f877: 30 00     
__f879:     .hex 2d            ; $f879: 2d        Suspected data
__f87a:     brk                ; $f87a: 00        
            rol                ; $f87b: 2a        
            brk                ; $f87c: 00        
            plp                ; $f87d: 28        
            brk                ; $f87e: 00        
            rol $00            ; $f87f: 26 00     
            bit $00            ; $f881: 24 00     
            .hex 22            ; $f883: 22        Invalid Opcode - KIL 
            brk                ; $f884: 00        
            jsr $1e00          ; $f885: 20 00 1e  
            brk                ; $f888: 00        
            .hex 1c 00 1b      ; $f889: 1c 00 1b  Invalid Opcode - NOP $1b00,x
            brk                ; $f88c: 00        
            ora $1800,y        ; $f88d: 19 00 18  
            brk                ; $f890: 00        
            asl $00,x          ; $f891: 16 00     
            ora $00,x          ; $f893: 15 00     
            .hex 14 00         ; $f895: 14 00     Invalid Opcode - NOP $00,x
            .hex 13 00         ; $f897: 13 00     Invalid Opcode - SLO ($00),y
            .hex 12            ; $f899: 12        Invalid Opcode - KIL 
            brk                ; $f89a: 00        
            ora ($00),y        ; $f89b: 11 00     
            bpl __f89f         ; $f89d: 10 00     
__f89f:     .hex 0f 00 0e      ; $f89f: 0f 00 0e  Invalid Opcode - SLO $0e00
            brk                ; $f8a2: 00        
__f8a3:     ora ($02,x)        ; $f8a3: 01 02     
            .hex 04 08         ; $f8a5: 04 08     Invalid Opcode - NOP $08
            bpl __f8c9         ; $f8a7: 10 20     
            rti                ; $f8a9: 40        

;-------------------------------------------------------------------------------
            .hex 80            ; $f8aa: 80        Suspected data
__f8ab:     ora ($02,x)        ; $f8ab: 01 02     
            .hex 03 04         ; $f8ad: 03 04     Invalid Opcode - SLO ($04,x)
            asl $09            ; $f8af: 06 09     
            .hex 0c 12 18      ; $f8b1: 0c 12 18  Invalid Opcode - NOP $1812
            bit $30            ; $f8b4: 24 30     
            pha                ; $f8b6: 48        
            rts                ; $f8b7: 60        

;-------------------------------------------------------------------------------
            bcc __f87a         ; $f8b8: 90 c0     
            .hex 14 07         ; $f8ba: 14 07     Invalid Opcode - NOP $07,x
            .hex 02            ; $f8bc: 02        Invalid Opcode - KIL 
            brk                ; $f8bd: 00        
            .hex 03 05         ; $f8be: 03 05     Invalid Opcode - SLO ($05,x)
            brk                ; $f8c0: 00        
            asl                ; $f8c1: 0a        
            .hex 0f 14 1e      ; $f8c2: 0f 14 1e  Invalid Opcode - SLO $1e14
            plp                ; $f8c5: 28        
            .hex 3c 50 78      ; $f8c6: 3c 50 78  Invalid Opcode - NOP $7850,x
__f8c9:     ldy #$00           ; $f8c9: a0 00     
            brk                ; $f8cb: 00        
            .hex 02            ; $f8cc: 02        Invalid Opcode - KIL 
            .hex 04 06         ; $f8cd: 04 06     Invalid Opcode - NOP $06
            php                ; $f8cf: 08        
            .hex 0c 10 18      ; $f8d0: 0c 10 18  Invalid Opcode - NOP $1810
            jsr $4030          ; $f8d3: 20 30 40  
            rts                ; $f8d6: 60        

;-------------------------------------------------------------------------------
            .hex 80 c0         ; $f8d7: 80 c0     Invalid Opcode - NOP #$c0
            beq __f8db         ; $f8d9: f0 00     
__f8db:     .hex 1c 00 00      ; $f8db: 1c 00 00  Bad Addr Mode - NOP $0000,x
            brk                ; $f8de: 00        
            ora #$00           ; $f8df: 09 00     
            .hex 12            ; $f8e1: 12        Invalid Opcode - KIL 
            .hex 1b 24 36      ; $f8e2: 1b 24 36  Invalid Opcode - SLO $3624,y
            pha                ; $f8e5: 48        
            .hex 6c 90 d8      ; $f8e6: 6c 90 d8  

;-------------------------------------------------------------------------------
            brk                ; $f8e9: 00        
            brk                ; $f8ea: 00        

__f8eb:     .hex 13 fa
            .hex 20 fa
            .hex 2d fa
            .hex 3a fa
            .hex 47 fa
            .hex 54 fa
            .hex 92 fa
            .hex ec fa
            
            .hex 99 fb bf fb d3 fb f9 fb
            .hex 15 fc 8d fc e5 fc 0a fd
            .hex 35 fd ce fd

__f90f:     .hex 25 f9
            .hex 27 f9         ; $f911: 27 f9
            .hex 29 f9         ; $f913: 29 f9     
            .hex 59 f9 83      ; $f915: 59 f9 83  
            sbc __f9a3,y       ; $f918: f9 a3 f9  
            .hex bb f9 bf      ; $f91b: bb f9 bf  Invalid Opcode - LAS __bff9,y
            sbc __f9dd,y       ; $f91e: f9 dd f9  
            .hex ef f9 f3      ; $f921: ef f9 f3  Invalid Opcode - ISC __f3f9
            sbc $0fff,y        ; $f924: f9 ff 0f  
            .hex ff ff 01      ; $f927: ff ff 01  Invalid Opcode - ISC $01ff,x
            .hex 0f 01 00      ; $f92a: 0f 01 00  Bad Addr Mode - SLO $0001
            ora ($0d,x)        ; $f92d: 01 0d     
            ora ($00,x)        ; $f92f: 01 00     
            ora ($0b,x)        ; $f931: 01 0b     
            ora ($00,x)        ; $f933: 01 00     
            ora ($09,x)        ; $f935: 01 09     
            ora ($00,x)        ; $f937: 01 00     
            ora ($07,x)        ; $f939: 01 07     
            ora ($00,x)        ; $f93b: 01 00     
            ora ($06,x)        ; $f93d: 01 06     
            ora ($00,x)        ; $f93f: 01 00     
            ora ($05,x)        ; $f941: 01 05     
            ora ($00,x)        ; $f943: 01 00     
            ora ($04,x)        ; $f945: 01 04     
            ora ($00,x)        ; $f947: 01 00     
            ora ($03,x)        ; $f949: 01 03     
            ora ($00,x)        ; $f94b: 01 00     
            ora ($02,x)        ; $f94d: 01 02     
            ora ($00,x)        ; $f94f: 01 00     
            ora ($01,x)        ; $f951: 01 01     
            ora ($00,x)        ; $f953: 01 00     
            ora ($01,x)        ; $f955: 01 01     
            .hex ff 00 01      ; $f957: ff 00 01  Invalid Opcode - ISC $0100,x
            .hex 0c 03 0f      ; $f95a: 0c 03 0f  Invalid Opcode - NOP $0f03
            ora ($0d,x)        ; $f95d: 01 0d     
            ora ($0b,x)        ; $f95f: 01 0b     
            ora ($09,x)        ; $f961: 01 09     
            ora ($07,x)        ; $f963: 01 07     
            ora ($05,x)        ; $f965: 01 05     
            ora ($03,x)        ; $f967: 01 03     
            ora ($01,x)        ; $f969: 01 01     
            ora ($08,x)        ; $f96b: 01 08     
            .hex 02            ; $f96d: 02        Invalid Opcode - KIL 
            asl                ; $f96e: 0a        
            ora ($09,x)        ; $f96f: 01 09     
            ora ($08,x)        ; $f971: 01 08     
            ora ($07,x)        ; $f973: 01 07     
            ora ($06,x)        ; $f975: 01 06     
            .hex 02            ; $f977: 02        Invalid Opcode - KIL 
            ora $02            ; $f978: 05 02     
            .hex 04 02         ; $f97a: 04 02     Invalid Opcode - NOP $02
            .hex 03 02         ; $f97c: 03 02     Invalid Opcode - SLO ($02,x)
            .hex 02            ; $f97e: 02        Invalid Opcode - KIL 
            .hex 02            ; $f97f: 02        Invalid Opcode - KIL 
            ora ($ff,x)        ; $f980: 01 ff     
            brk                ; $f982: 00        
            .hex 02            ; $f983: 02        Invalid Opcode - KIL 
            .hex 0f 01 0e      ; $f984: 0f 01 0e  Invalid Opcode - SLO $0e01
            ora ($0d,x)        ; $f987: 01 0d     
            ora ($0c,x)        ; $f989: 01 0c     
            .hex 02            ; $f98b: 02        Invalid Opcode - KIL 
            .hex 0b 02         ; $f98c: 0b 02     Invalid Opcode - ANC #$02
            asl                ; $f98e: 0a        
            .hex 02            ; $f98f: 02        Invalid Opcode - KIL 
            ora #$02           ; $f990: 09 02     
            php                ; $f992: 08        
            .hex 03 07         ; $f993: 03 07     Invalid Opcode - SLO ($07,x)
            .hex 03 06         ; $f995: 03 06     Invalid Opcode - SLO ($06,x)
            .hex 03 05         ; $f997: 03 05     Invalid Opcode - SLO ($05,x)
            .hex 03 04         ; $f999: 03 04     Invalid Opcode - SLO ($04,x)
            .hex 03 03         ; $f99b: 03 03     Invalid Opcode - SLO ($03,x)
            .hex 03 02         ; $f99d: 03 02     Invalid Opcode - SLO ($02,x)
            .hex 03 01         ; $f99f: 03 01     Invalid Opcode - SLO ($01,x)
            .hex ff 00         ; $f9a1: ff 00     Suspected data
__f9a3:     .hex 03 0f         ; $f9a3: 03 0f     Invalid Opcode - SLO ($0f,x)
            .hex 07 00         ; $f9a5: 07 00     Invalid Opcode - SLO $00
            ora ($06,x)        ; $f9a7: 01 06     
            .hex 02            ; $f9a9: 02        Invalid Opcode - KIL 
            php                ; $f9aa: 08        
            ora ($07,x)        ; $f9ab: 01 07     
            ora ($06,x)        ; $f9ad: 01 06     
            ora ($05,x)        ; $f9af: 01 05     
            .hex 02            ; $f9b1: 02        Invalid Opcode - KIL 
            .hex 04 02         ; $f9b2: 04 02     Invalid Opcode - NOP $02
            .hex 03 02         ; $f9b4: 03 02     Invalid Opcode - SLO ($02,x)
__f9b6:     .hex 02            ; $f9b6: 02        Invalid Opcode - KIL 
            .hex 02            ; $f9b7: 02        Invalid Opcode - KIL 
            ora ($ff,x)        ; $f9b8: 01 ff     
            brk                ; $f9ba: 00        
            ora ($0c,x)        ; $f9bb: 01 0c     
            .hex ff 0f 01      ; $f9bd: ff 0f 01  Invalid Opcode - ISC $010f,x
            .hex 0c 02 0f      ; $f9c0: 0c 02 0f  Invalid Opcode - NOP $0f02
            ora ($0d,x)        ; $f9c3: 01 0d     
            ora ($0b,x)        ; $f9c5: 01 0b     
            ora ($0a,x)        ; $f9c7: 01 0a     
            ora ($09,x)        ; $f9c9: 01 09     
            ora ($08,x)        ; $f9cb: 01 08     
            ora ($07,x)        ; $f9cd: 01 07     
            .hex 01            ; $f9cf: 01        Suspected data
__f9d0:     asl $01            ; $f9d0: 06 01     
            ora $01            ; $f9d2: 05 01     
__f9d4:     .hex 04 01         ; $f9d4: 04 01     Invalid Opcode - NOP $01
            .hex 03 01         ; $f9d6: 03 01     Invalid Opcode - SLO ($01,x)
            .hex 02            ; $f9d8: 02        Invalid Opcode - KIL 
            ora ($01,x)        ; $f9d9: 01 01     
            .hex ff 00         ; $f9db: ff 00     Suspected data
__f9dd:     ora ($0f,x)        ; $f9dd: 01 0f     
            ora ($0d,x)        ; $f9df: 01 0d     
            ora ($0b,x)        ; $f9e1: 01 0b     
            ora ($09,x)        ; $f9e3: 01 09     
            ora ($07,x)        ; $f9e5: 01 07     
            ora ($05,x)        ; $f9e7: 01 05     
            ora ($03,x)        ; $f9e9: 01 03     
            ora ($01,x)        ; $f9eb: 01 01     
            .hex ff 00 01      ; $f9ed: ff 00 01  Invalid Opcode - ISC $0100,x
            .hex 0f ff 00      ; $f9f0: 0f ff 00  Bad Addr Mode - SLO $00ff
            php                ; $f9f3: 08        
            .hex 0f 08 0e      ; $f9f4: 0f 08 0e  Invalid Opcode - SLO $0e08
            php                ; $f9f7: 08        
            ora $0c08          ; $f9f8: 0d 08 0c  
            php                ; $f9fb: 08        
            .hex 0b 08         ; $f9fc: 0b 08     Invalid Opcode - ANC #$08
            asl                ; $f9fe: 0a        
            php                ; $f9ff: 08        
            ora #$08           ; $fa00: 09 08     
            php                ; $fa02: 08        
            php                ; $fa03: 08        
            .hex 07 08         ; $fa04: 07 08     Invalid Opcode - SLO $08
            asl $08            ; $fa06: 06 08     
            ora $08            ; $fa08: 05 08     
            .hex 04 08         ; $fa0a: 04 08     Invalid Opcode - NOP $08
            .hex 03 08         ; $fa0c: 03 08     Invalid Opcode - SLO ($08,x)
            .hex 02            ; $fa0e: 02        Invalid Opcode - KIL 
            php                ; $fa0f: 08        
            ora ($ff,x)        ; $fa10: 01 ff     
            brk                ; $fa12: 00        
            brk                ; $fa13: 00        
            .hex 1f fa 01      ; $fa14: 1f fa 01  Invalid Opcode - SLO $01fa,x
            .hex 1f fa 02      ; $fa17: 1f fa 02  Invalid Opcode - SLO $02fa,x
            .hex 1f fa 03      ; $fa1a: 1f fa 03  Invalid Opcode - SLO $03fa,x
            .hex 1f fa ff      ; $fa1d: 1f fa ff  Invalid Opcode - SLO vectors,x
            brk                ; $fa20: 00        
            bit $fa            ; $fa21: 24 fa     
            .hex ff f0 02      ; $fa23: ff f0 02  Invalid Opcode - ISC $02f0,x
__fa26:     .hex f2            ; $fa26: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fa27: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fa29: 00        
            bmi __f9b6         ; $fa2a: 30 8a     
            .hex ff 00 31      ; $fa2c: ff 00 31  Invalid Opcode - ISC $3100,x
            .hex fa            ; $fa2f: fa        Invalid Opcode - NOP 
            .hex ff f0 02      ; $fa30: ff f0 02  Invalid Opcode - ISC $02f0,x
            .hex f2            ; $fa33: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fa34: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fa36: 00        
            .hex 37 8a         ; $fa37: 37 8a     Invalid Opcode - RLA $8a,x
            .hex ff 00 3e      ; $fa39: ff 00 3e  Invalid Opcode - ISC $3e00,x
            .hex fa            ; $fa3c: fa        Invalid Opcode - NOP 
            .hex ff f0 02      ; $fa3d: ff f0 02  Invalid Opcode - ISC $02f0,x
            .hex f2            ; $fa40: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fa41: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fa43: 00        
            bvc __f9d0         ; $fa44: 50 8a     
            .hex ff 00 4b      ; $fa46: ff 00 4b  Invalid Opcode - ISC $4b00,x
            .hex fa            ; $fa49: fa        Invalid Opcode - NOP 
            .hex ff f0 00      ; $fa4a: ff f0 00  Bad Addr Mode - ISC $00f0,x
            .hex f2            ; $fa4d: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fa4e: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fa50: 00        
            bmi __f9d4         ; $fa51: 30 81     
            .hex ff 00 5e      ; $fa53: ff 00 5e  Invalid Opcode - ISC $5e00,x
            .hex fa            ; $fa56: fa        Invalid Opcode - NOP 
            ora ($8d,x)        ; $fa57: 01 8d     
            .hex fa            ; $fa59: fa        Invalid Opcode - NOP 
            .hex 02            ; $fa5a: 02        Invalid Opcode - KIL 
            .hex 1f fa ff      ; $fa5b: 1f fa ff  Invalid Opcode - SLO vectors,x
__fa5e:     beq __fa60         ; $fa5e: f0 00     
__fa60:     .hex f2            ; $fa60: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fa61: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fa63: 00        
            .hex fa            ; $fa64: fa        Invalid Opcode - NOP 
            stx $fa            ; $fa65: 86 fa     
            .hex f3 04         ; $fa67: f3 04     Invalid Opcode - ISC ($04),y
            .hex fa            ; $fa69: fa        Invalid Opcode - NOP 
            stx $fa            ; $fa6a: 86 fa     
            .hex f3 06         ; $fa6c: f3 06     Invalid Opcode - ISC ($06),y
            .hex fa            ; $fa6e: fa        Invalid Opcode - NOP 
            stx $fa            ; $fa6f: 86 fa     
            .hex f3 08         ; $fa71: f3 08     Invalid Opcode - ISC ($08),y
            .hex fa            ; $fa73: fa        Invalid Opcode - NOP 
            stx $fa            ; $fa74: 86 fa     
            .hex f3 0a         ; $fa76: f3 0a     Invalid Opcode - ISC ($0a),y
            .hex fa            ; $fa78: fa        Invalid Opcode - NOP 
            stx $fa            ; $fa79: 86 fa     
            .hex f3 0c         ; $fa7b: f3 0c     Invalid Opcode - ISC ($0c),y
            .hex fa            ; $fa7d: fa        Invalid Opcode - NOP 
            stx $fa            ; $fa7e: 86 fa     
            .hex f3 0e         ; $fa80: f3 0e     Invalid Opcode - ISC ($0e),y
            .hex fa            ; $fa82: fa        Invalid Opcode - NOP 
            stx $fa            ; $fa83: 86 fa     
            .hex ff f1 82      ; $fa85: ff f1 82  Invalid Opcode - ISC __82f1,x
            plp                ; $fa88: 28        
            bcc __fb07         ; $fa89: 90 7c     
            sta ($ff,x)        ; $fa8b: 81 ff     
            .hex f4 01         ; $fa8d: f4 01     Invalid Opcode - NOP $01,x
            sbc __fa5e,y       ; $fa8f: f9 5e fa  
            brk                ; $fa92: 00        
            sta $01fa,y        ; $fa93: 99 fa 01  
            .hex 9b            ; $fa96: 9b        Invalid Opcode - TAS 
            .hex fa            ; $fa97: fa        Invalid Opcode - NOP 
            .hex ff f4 fb      ; $fa98: ff f4 fb  Invalid Opcode - ISC __fbf4,x
            beq __fa9d         ; $fa9b: f0 00     
__fa9d:     .hex f2            ; $fa9d: f2        Invalid Opcode - KIL 
            rti                ; $fa9e: 40        

;-------------------------------------------------------------------------------
            .hex f3 00         ; $fa9f: f3 00     Invalid Opcode - ISC ($00),y
            sbc ($8f),y        ; $faa1: f1 8f     
__faa3:     bvc __fa26         ; $faa3: 50 81     
            .hex f3 01         ; $faa5: f3 01     Invalid Opcode - ISC ($01),y
            sbc ($87),y        ; $faa7: f1 87     
            eor ($f3),y        ; $faa9: 51 f3     
            .hex 02            ; $faab: 02        Invalid Opcode - KIL 
            .hex f1            ; $faac: f1        Suspected data
__faad:     .hex 8f 50 f3      ; $faad: 8f 50 f3  Invalid Opcode - SAX __f350
            .hex 03 f1         ; $fab0: 03 f1     Invalid Opcode - SLO ($f1,x)
            .hex 87 51         ; $fab2: 87 51     Invalid Opcode - SAX $51
            .hex f3 04         ; $fab4: f3 04     Invalid Opcode - ISC ($04),y
            .hex f1            ; $fab6: f1        Suspected data
__fab7:     .hex 8f 50 f3      ; $fab7: 8f 50 f3  Invalid Opcode - SAX __f350
            ora $f1            ; $faba: 05 f1     
            .hex 87 51         ; $fabc: 87 51     Invalid Opcode - SAX $51
            .hex f3 06         ; $fabe: f3 06     Invalid Opcode - ISC ($06),y
            .hex f1            ; $fac0: f1        Suspected data
__fac1:     .hex 8f 50 f3      ; $fac1: 8f 50 f3  Invalid Opcode - SAX __f350
            .hex 07 f1         ; $fac4: 07 f1     Invalid Opcode - SLO $f1
            .hex 87 51         ; $fac6: 87 51     Invalid Opcode - SAX $51
            .hex f3 08         ; $fac8: f3 08     Invalid Opcode - ISC ($08),y
            sbc ($8f),y        ; $faca: f1 8f     
            bvc __fac1         ; $facc: 50 f3     
            ora #$f1           ; $face: 09 f1     
            .hex 87 51         ; $fad0: 87 51     Invalid Opcode - SAX $51
            .hex f3 0a         ; $fad2: f3 0a     Invalid Opcode - ISC ($0a),y
            .hex f1            ; $fad4: f1        Suspected data
__fad5:     .hex 8f 50 f3      ; $fad5: 8f 50 f3  Invalid Opcode - SAX __f350
            .hex 0b f1         ; $fad8: 0b f1     Invalid Opcode - ANC #$f1
            .hex 87 51         ; $fada: 87 51     Invalid Opcode - SAX $51
            .hex f3 0c         ; $fadc: f3 0c     Invalid Opcode - ISC ($0c),y
            sbc ($8f),y        ; $fade: f1 8f     
            bvc __fad5         ; $fae0: 50 f3     
            .hex 0d f1 87      ; $fae2: 0d f1 87  
            eor ($f3),y        ; $fae5: 51 f3     
            asl __8ff1         ; $fae7: 0e f1 8f  
            .hex 50            ; $faea: 50        Suspected data
__faeb:     .hex ff 00 f3      ; $faeb: ff 00 f3  Invalid Opcode - ISC __f300,x
            .hex fa            ; $faee: fa        Invalid Opcode - NOP 
            ora ($f5,x)        ; $faef: 01 f5     
            .hex fa            ; $faf1: fa        Invalid Opcode - NOP 
            .hex ff f4 fb      ; $faf2: ff f4 fb  Invalid Opcode - ISC __fbf4,x
            beq __faf7         ; $faf5: f0 00     
__faf7:     .hex f2            ; $faf7: f2        Invalid Opcode - KIL 
            rti                ; $faf8: 40        

;-------------------------------------------------------------------------------
            .hex f3 0e         ; $faf9: f3 0e     Invalid Opcode - ISC ($0e),y
            .hex fa            ; $fafb: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fafc: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0d         ; $fafe: f3 0d     Invalid Opcode - ISC ($0d),y
            .hex fa            ; $fb00: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb01: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0c         ; $fb03: f3 0c     Invalid Opcode - ISC ($0c),y
            .hex fa            ; $fb05: fa        Invalid Opcode - NOP 
            .hex 8b            ; $fb06: 8b        Suspected data
__fb07:     .hex fb f3 0b      ; $fb07: fb f3 0b  Invalid Opcode - ISC $0bf3,y
            .hex fa            ; $fb0a: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb0b: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0a         ; $fb0d: f3 0a     Invalid Opcode - ISC ($0a),y
            .hex fa            ; $fb0f: fa        Invalid Opcode - NOP 
__fb10:     .hex 8b fb         ; $fb10: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 09         ; $fb12: f3 09     Invalid Opcode - ISC ($09),y
            .hex fa            ; $fb14: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb15: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 08         ; $fb17: f3 08     Invalid Opcode - ISC ($08),y
            .hex fa            ; $fb19: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb1a: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 07         ; $fb1c: f3 07     Invalid Opcode - ISC ($07),y
            .hex fa            ; $fb1e: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb1f: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 06         ; $fb21: f3 06     Invalid Opcode - ISC ($06),y
            .hex fa            ; $fb23: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb24: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3            ; $fb26: f3        Suspected data
__fb27:     ora $fa            ; $fb27: 05 fa     
            .hex 8b fb         ; $fb29: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 04         ; $fb2b: f3 04     Invalid Opcode - ISC ($04),y
            .hex fa            ; $fb2d: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb2e: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 03         ; $fb30: f3 03     Invalid Opcode - ISC ($03),y
            .hex fa            ; $fb32: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb33: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 02         ; $fb35: f3 02     Invalid Opcode - ISC ($02),y
            .hex fa            ; $fb37: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb38: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 01         ; $fb3a: f3 01     Invalid Opcode - ISC ($01),y
            .hex fa            ; $fb3c: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb3d: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 00         ; $fb3f: f3 00     Invalid Opcode - ISC ($00),y
            .hex fa            ; $fb41: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb42: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 01         ; $fb44: f3 01     Invalid Opcode - ISC ($01),y
            .hex fa            ; $fb46: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb47: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 02         ; $fb49: f3 02     Invalid Opcode - ISC ($02),y
            .hex fa            ; $fb4b: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb4c: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 03         ; $fb4e: f3 03     Invalid Opcode - ISC ($03),y
            .hex fa            ; $fb50: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb51: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 04         ; $fb53: f3 04     Invalid Opcode - ISC ($04),y
            .hex fa            ; $fb55: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb56: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 05         ; $fb58: f3 05     Invalid Opcode - ISC ($05),y
            .hex fa            ; $fb5a: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb5b: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 06         ; $fb5d: f3 06     Invalid Opcode - ISC ($06),y
            .hex fa            ; $fb5f: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb60: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 07         ; $fb62: f3 07     Invalid Opcode - ISC ($07),y
            .hex fa            ; $fb64: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb65: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 08         ; $fb67: f3 08     Invalid Opcode - ISC ($08),y
__fb69:     .hex fa            ; $fb69: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb6a: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 09         ; $fb6c: f3 09     Invalid Opcode - ISC ($09),y
            .hex fa            ; $fb6e: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb6f: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0a         ; $fb71: f3 0a     Invalid Opcode - ISC ($0a),y
            .hex fa            ; $fb73: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb74: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0b         ; $fb76: f3 0b     Invalid Opcode - ISC ($0b),y
            .hex fa            ; $fb78: fa        Invalid Opcode - NOP 
__fb79:     .hex 8b fb         ; $fb79: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0c         ; $fb7b: f3 0c     Invalid Opcode - ISC ($0c),y
            .hex fa            ; $fb7d: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb7e: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0d         ; $fb80: f3 0d     Invalid Opcode - ISC ($0d),y
            .hex fa            ; $fb82: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb83: 8b fb     Invalid Opcode - XAA #$fb
            .hex f3 0e         ; $fb85: f3 0e     Invalid Opcode - ISC ($0e),y
            .hex fa            ; $fb87: fa        Invalid Opcode - NOP 
            .hex 8b fb         ; $fb88: 8b fb     Invalid Opcode - XAA #$fb
            .hex ff f1 8f      ; $fb8a: ff f1 8f  Invalid Opcode - ISC __8ff1,x
            bvc __fb10         ; $fb8d: 50 81     
            sbc ($87),y        ; $fb8f: f1 87     
            eor ($f1),y        ; $fb91: 51 f1     
            .hex 8f 50 f1      ; $fb93: 8f 50 f1  Invalid Opcode - SAX __f150
            .hex 87 51         ; $fb96: 87 51     Invalid Opcode - SAX $51
            .hex ff 02 a0      ; $fb98: ff 02 a0  Invalid Opcode - ISC __a002,x
            .hex fb 01 b4      ; $fb9b: fb 01 b4  Invalid Opcode - ISC __b401,y
            .hex fb ff f0      ; $fb9e: fb ff f0  Invalid Opcode - ISC __f0ff,y
            ora ($f4,x)        ; $fba1: 01 f4     
            brk                ; $fba3: 00        
            bpl __fb27         ; $fba4: 10 81     
            ora ($12),y        ; $fba6: 11 12     
            .hex 13 14         ; $fba8: 13 14     Invalid Opcode - SLO ($14),y
            ora $16,x          ; $fbaa: 15 16     
            .hex 17 19         ; $fbac: 17 19     Invalid Opcode - SLO $19,x
            .hex 1a            ; $fbae: 1a        Invalid Opcode - NOP 
            .hex 1b 20 21      ; $fbaf: 1b 20 21  Invalid Opcode - SLO $2120,y
            .hex 22            ; $fbb2: 22        Invalid Opcode - KIL 
            .hex ff f0 00      ; $fbb3: ff f0 00  Bad Addr Mode - ISC $00f0,x
            .hex f2            ; $fbb6: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fbb7: 80 f3     Invalid Opcode - NOP #$f3
            php                ; $fbb9: 08        
            sbc ($8f),y        ; $fbba: f1 8f     
            brk                ; $fbbc: 00        
            .hex b0            ; $fbbd: b0        Suspected data
__fbbe:     .hex ff 00 c6      ; $fbbe: ff 00 c6  Invalid Opcode - ISC __c600,x
            .hex fb 01 c8      ; $fbc1: fb 01 c8  Invalid Opcode - ISC __c801,y
            .hex fb ff f4      ; $fbc4: fb ff f4  Invalid Opcode - ISC __f4ff,y
            ora ($f0,x)        ; $fbc7: 01 f0     
            asl                ; $fbc9: 0a        
            .hex f2            ; $fbca: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fbcb: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fbcd: 00        
            sbc ($83),y        ; $fbce: f1 83     
            .hex 22            ; $fbd0: 22        Invalid Opcode - KIL 
            stx $ff            ; $fbd1: 86 ff     
            brk                ; $fbd3: 00        
            .hex da            ; $fbd4: da        Invalid Opcode - NOP 
            .hex fb 01 dc      ; $fbd5: fb 01 dc  Invalid Opcode - ISC __dc01,y
            .hex fb ff f4      ; $fbd8: fb ff f4  Invalid Opcode - ISC __f4ff,y
            ora ($f0,x)        ; $fbdb: 01 f0     
            brk                ; $fbdd: 00        
            .hex f2            ; $fbde: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fbdf: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fbe1: 00        
            sbc ($83),y        ; $fbe2: f1 83     
            bmi __fb69         ; $fbe4: 30 83     
            .hex 7c 81 f3      ; $fbe6: 7c 81 f3  Invalid Opcode - NOP __f381,x
            asl $f1            ; $fbe9: 06 f1     
            .hex 83 30         ; $fbeb: 83 30     Invalid Opcode - SAX ($30,x)
            .hex 83 7c         ; $fbed: 83 7c     Invalid Opcode - SAX ($7c,x)
            sta ($f3,x)        ; $fbef: 81 f3     
            asl                ; $fbf1: 0a        
            sbc ($83),y        ; $fbf2: f1 83     
            bmi __fb79         ; $fbf4: 30 83     
            .hex 7c 81 ff      ; $fbf6: 7c 81 ff  Invalid Opcode - NOP __ff81,x
            brk                ; $fbf9: 00        
            brk                ; $fbfa: 00        
            .hex fc 01 02      ; $fbfb: fc 01 02  Invalid Opcode - NOP $0201,x
            .hex fc ff f4      ; $fbfe: fc ff f4  Invalid Opcode - NOP __f4ff,x
            .hex fb f0 00      ; $fc01: fb f0 00  Invalid Opcode - ISC $00f0,y
            .hex f2            ; $fc04: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fc05: 80 f3     Invalid Opcode - NOP #$f3
            brk                ; $fc07: 00        
            sbc ($86),y        ; $fc08: f1 86     
            bit $8b            ; $fc0a: 24 8b     
            beq __fc18         ; $fc0c: f0 0a     
            .hex f3 08         ; $fc0e: f3 08     Invalid Opcode - ISC ($08),y
            sbc ($8f),y        ; $fc10: f1 8f     
            ora $ae            ; $fc12: 05 ae     
            .hex ff 00 1f      ; $fc14: ff 00 1f  Invalid Opcode - ISC $1f00,x
            .hex fc            ; $fc17: fc        Suspected data
__fc18:     ora ($46,x)        ; $fc18: 01 46     
            .hex fc 02 6d      ; $fc1a: fc 02 6d  Invalid Opcode - NOP $6d02,x
            .hex fc ff f0      ; $fc1d: fc ff f0  Invalid Opcode - NOP __f0ff,x
            .hex 03 f2         ; $fc20: 03 f2     Invalid Opcode - SLO ($f2,x)
            .hex 80 f3         ; $fc22: 80 f3     Invalid Opcode - NOP #$f3
            asl $f4            ; $fc24: 06 f4     
            brk                ; $fc26: 00        
            jsr $7c86          ; $fc27: 20 86 7c  
            sta ($20,x)        ; $fc2a: 81 20     
            sty $27            ; $fc2c: 84 27     
            txs                ; $fc2e: 9a        
            rol $90            ; $fc2f: 26 90     
            .hex 27 29         ; $fc31: 27 29     Invalid Opcode - RLA $29
            sty $27            ; $fc33: 84 27     
            .hex 9c 20 86      ; $fc35: 9c 20 86  Invalid Opcode - SHY __8620,x
            .hex 7c 81 20      ; $fc38: 7c 81 20  Invalid Opcode - NOP $2081,x
            sty $27            ; $fc3b: 84 27     
            txs                ; $fc3d: 9a        
            and #$94           ; $fc3e: 29 94     
            .hex 27 26         ; $fc40: 27 26     Invalid Opcode - RLA $26
            and #$27           ; $fc42: 29 27     
            .hex 9c ff f0      ; $fc44: 9c ff f0  Invalid Opcode - SHY __f0ff,x
            .hex 03 f2         ; $fc47: 03 f2     Invalid Opcode - SLO ($f2,x)
            .hex 80 f3         ; $fc49: 80 f3     Invalid Opcode - NOP #$f3
            asl $f4            ; $fc4b: 06 f4     
            brk                ; $fc4d: 00        
            .hex 17 86         ; $fc4e: 17 86     Invalid Opcode - SLO $86,x
            .hex 7c 81 17      ; $fc50: 7c 81 17  Invalid Opcode - NOP $1781,x
            sty $20            ; $fc53: 84 20     
            txs                ; $fc55: 9a        
            .hex 23 90         ; $fc56: 23 90     Invalid Opcode - RLA ($90,x)
            bit $25            ; $fc58: 24 25     
            sty $24            ; $fc5a: 84 24     
            .hex 9c 17 86      ; $fc5c: 9c 17 86  Invalid Opcode - SHY __8617,x
            .hex 7c 81 17      ; $fc5f: 7c 81 17  Invalid Opcode - NOP $1781,x
            sty $20            ; $fc62: 84 20     
            txs                ; $fc64: 9a        
            and $94            ; $fc65: 25 94     
            bit $23            ; $fc67: 24 23     
            and $24            ; $fc69: 25 24     
            .hex 9c ff f0      ; $fc6b: 9c ff f0  Invalid Opcode - SHY __f0ff,x
            ora ($f4,x)        ; $fc6e: 01 f4     
__fc70:     brk                ; $fc70: 00        
            sed                ; $fc71: f8        
            .hex 03 20         ; $fc72: 03 20     Invalid Opcode - SLO ($20,x)
            stx $7c,y          ; $fc74: 96 7c     
            .hex 17 7c         ; $fc76: 17 7c     Invalid Opcode - SLO $7c,x
            .hex ff 20 94      ; $fc78: ff 20 94  Invalid Opcode - ISC __9420,x
            .hex 7c 17 7c      ; $fc7b: 7c 17 7c  Invalid Opcode - NOP $7c17,x
            ora $1b7c,y        ; $fc7e: 19 7c 1b  
            .hex 7c 20 96      ; $fc81: 7c 20 96  Invalid Opcode - NOP __9620,x
            .hex 7c 17 7c      ; $fc84: 7c 17 7c  Invalid Opcode - NOP $7c17,x
            jsr $177c          ; $fc87: 20 7c 17  
            .hex 7c 20 ff      ; $fc8a: 7c 20 ff  Invalid Opcode - NOP __ff20,x
            brk                ; $fc8d: 00        
            .hex 97 fc         ; $fc8e: 97 fc     Invalid Opcode - SAX $fc,y
            ora ($ad,x)        ; $fc90: 01 ad     
            .hex fc 02 c3      ; $fc92: fc 02 c3  Invalid Opcode - NOP __c302,x
            .hex fc ff f0      ; $fc95: fc ff f0  Invalid Opcode - NOP __f0ff,x
            .hex 03 f2         ; $fc98: 03 f2     Invalid Opcode - SLO ($f2,x)
            .hex 80 f3         ; $fc9a: 80 f3     Invalid Opcode - NOP #$f3
            asl $27            ; $fc9c: 06 27     
            stx $7c            ; $fc9e: 86 7c     
            sta ($27,x)        ; $fca0: 81 27     
            sty $2a            ; $fca2: 84 2a     
            txs                ; $fca4: 9a        
            and #$96           ; $fca5: 29 96     
            .hex 27 25         ; $fca7: 27 25     Invalid Opcode - RLA $25
            and #$27           ; $fca9: 29 27     
            .hex 9b            ; $fcab: 9b        Invalid Opcode - TAS 
            .hex ff f0 03      ; $fcac: ff f0 03  Invalid Opcode - ISC $03f0,x
            .hex f2            ; $fcaf: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fcb0: 80 f3     Invalid Opcode - NOP #$f3
            asl $20            ; $fcb2: 06 20     
            stx $7c            ; $fcb4: 86 7c     
            sta ($20,x)        ; $fcb6: 81 20     
            sty $27            ; $fcb8: 84 27     
            txs                ; $fcba: 9a        
            and $96            ; $fcbb: 25 96     
            .hex 22            ; $fcbd: 22        Invalid Opcode - KIL 
            jsr $2025          ; $fcbe: 20 25 20  
            .hex 9b            ; $fcc1: 9b        Invalid Opcode - TAS 
            .hex ff 7c 98      ; $fcc2: ff 7c 98  Invalid Opcode - ISC __987c,x
            beq __fcc8         ; $fcc5: f0 01     
            .hex 24            ; $fcc7: 24        Suspected data
__fcc8:     sty $7c            ; $fcc8: 84 7c     
            .hex 80 24         ; $fcca: 80 24     Invalid Opcode - NOP #$24
            sty $7c            ; $fccc: 84 7c     
            .hex 80 24         ; $fcce: 80 24     Invalid Opcode - NOP #$24
            sty $7c,x          ; $fcd0: 94 7c     
            .hex 80 24         ; $fcd2: 80 24     Invalid Opcode - NOP #$24
            stx $7c,y          ; $fcd4: 96 7c     
            and $7c            ; $fcd6: 25 7c     
            and #$7c           ; $fcd8: 29 7c     
            bmi __fc70         ; $fcda: 30 94     
            .hex 7c 27 7c      ; $fcdc: 7c 27 7c  Invalid Opcode - NOP $7c27,x
            bmi __fd5d         ; $fcdf: 30 7c     
            .hex 27 7c         ; $fce1: 27 7c     Invalid Opcode - RLA $7c
            .hex 30            ; $fce3: 30        Suspected data
__fce4:     .hex ff 00 ef      ; $fce4: ff 00 ef  Invalid Opcode - ISC __ef00,x
            .hex fc 01 00      ; $fce7: fc 01 00  Bad Addr Mode - NOP $0001,x
            sbc $0902,x        ; $fcea: fd 02 09  
            sbc $7cff,x        ; $fced: fd ff 7c  
            sty $f0,x          ; $fcf0: 94 f0     
            .hex 03 f2         ; $fcf2: 03 f2     Invalid Opcode - SLO ($f2,x)
            .hex 80 f3         ; $fcf4: 80 f3     Invalid Opcode - NOP #$f3
            .hex 06            ; $fcf6: 06        Suspected data
__fcf7:     .hex 27 90         ; $fcf7: 27 90     Invalid Opcode - RLA $90
            and ($32),y        ; $fcf9: 31 32     
            rol $37,x          ; $fcfb: 36 37     
__fcfd:     .hex 3b 42 ff      ; $fcfd: 3b 42 ff  Invalid Opcode - RLA __ff42,y
            .hex f0            ; $fd00: f0        Suspected data
__fd01:     brk                ; $fd01: 00        
__fd02:     .hex f2            ; $fd02: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fd03: 80 f3     Invalid Opcode - NOP #$f3
            .hex 02            ; $fd05: 02        Invalid Opcode - KIL 
            sbc __fcf7,y       ; $fd06: f9 f7 fc  
            .hex ff 00 14      ; $fd09: ff 00 14  Invalid Opcode - ISC $1400,x
            sbc $1d01,x        ; $fd0c: fd 01 1d  
            sbc $1f02,x        ; $fd0f: fd 02 1f  
            .hex fa            ; $fd12: fa        Invalid Opcode - NOP 
            .hex ff 7c a4      ; $fd13: ff 7c a4  Invalid Opcode - ISC __a47c,x
            .hex f2            ; $fd16: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fd17: 80 f3     Invalid Opcode - NOP #$f3
            asl $f9            ; $fd19: 06 f9     
            .hex 23 fd         ; $fd1b: 23 fd     Invalid Opcode - RLA ($fd,x)
            beq __fd1f         ; $fd1d: f0 00     
__fd1f:     .hex f2            ; $fd1f: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fd20: 80 f3     Invalid Opcode - NOP #$f3
            .hex 02            ; $fd22: 02        Invalid Opcode - KIL 
            rol                ; $fd23: 2a        
            ldy $26            ; $fd24: a4 26     
            .hex 27 22         ; $fd26: 27 22     Invalid Opcode - RLA $22
            and $21            ; $fd28: 25 21     
            .hex 22            ; $fd2a: 22        Invalid Opcode - KIL 
            .hex 1a            ; $fd2b: 1a        Invalid Opcode - NOP 
            .hex 17 a2         ; $fd2c: 17 a2     Invalid Opcode - SLO $a2,x
            .hex 7c 17 7c      ; $fd2e: 7c 17 7c  Invalid Opcode - NOP $7c17,x
            .hex 17 7c         ; $fd31: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 17 ff         ; $fd33: 17 ff     Invalid Opcode - SLO $ff,x
__fd35:     brk                ; $fd35: 00        
            .hex 3f fd 01      ; $fd36: 3f fd 01  Invalid Opcode - RLA $01fd,x
            adc $fd,x          ; $fd39: 75 fd     
            .hex 02            ; $fd3b: 02        Invalid Opcode - KIL 
            ldy $fd,x          ; $fd3c: b4 fd     
            .hex ff f0 04      ; $fd3e: ff f0 04  Invalid Opcode - ISC $04f0,x
            .hex f2            ; $fd41: f2        Invalid Opcode - KIL 
            rti                ; $fd42: 40        

;-------------------------------------------------------------------------------
            .hex f3 06         ; $fd43: f3 06     Invalid Opcode - ISC ($06),y
            .hex 27 96         ; $fd45: 27 96     Invalid Opcode - RLA $96
            rol $23            ; $fd47: 26 23     
            and $98            ; $fd49: 25 98     
            rol $96            ; $fd4b: 26 96     
            .hex 27 98         ; $fd4d: 27 98     Invalid Opcode - RLA $98
            rol $96            ; $fd4f: 26 96     
            rol $98            ; $fd51: 26 98     
            rol $96            ; $fd53: 26 96     
            rol $98            ; $fd55: 26 98     
            rol $96            ; $fd57: 26 96     
            rol $98            ; $fd59: 26 98     
            .hex f2            ; $fd5b: f2        Invalid Opcode - KIL 
            .hex 80            ; $fd5c: 80        Suspected data
__fd5d:     rol $94,x          ; $fd5d: 36 94     
            .hex 33 30         ; $fd5f: 33 30     Invalid Opcode - RLA ($30),y
            and #$26           ; $fd61: 29 26     
            .hex 23 20         ; $fd63: 23 20     Invalid Opcode - RLA ($20,x)
            ora $1916,y        ; $fd65: 19 16 19  
            jsr $2623          ; $fd68: 20 23 26  
            and #$30           ; $fd6b: 29 30     
            .hex 33 f2         ; $fd6d: 33 f2     Invalid Opcode - RLA ($f2),y
            rti                ; $fd6f: 40        

;-------------------------------------------------------------------------------
            rol $94            ; $fd70: 26 94     
            rol $9a            ; $fd72: 26 9a     
            .hex ff f0 04      ; $fd74: ff f0 04  Invalid Opcode - ISC $04f0,x
            .hex f2            ; $fd77: f2        Invalid Opcode - KIL 
            rti                ; $fd78: 40        

;-------------------------------------------------------------------------------
            .hex f3 06         ; $fd79: f3 06     Invalid Opcode - ISC ($06),y
            .hex 1b 96 1b      ; $fd7b: 1b 96 1b  Invalid Opcode - SLO $1b96,y
            .hex 1b 1b 98      ; $fd7e: 1b 1b 98  Invalid Opcode - SLO __981b,y
            .hex 1b 96 1b      ; $fd81: 1b 96 1b  Invalid Opcode - SLO $1b96,y
            tya                ; $fd84: 98        
            .hex 1b 96 1b      ; $fd85: 1b 96 1b  Invalid Opcode - SLO $1b96,y
            tya                ; $fd88: 98        
            .hex 1b 96 1b      ; $fd89: 1b 96 1b  Invalid Opcode - SLO $1b96,y
            tya                ; $fd8c: 98        
            .hex 1b 96 1b      ; $fd8d: 1b 96 1b  Invalid Opcode - SLO $1b96,y
            tya                ; $fd90: 98        
            beq __fd96         ; $fd91: f0 03     
            .hex f2            ; $fd93: f2        Invalid Opcode - KIL 
            .hex 80 f3         ; $fd94: 80 f3     Invalid Opcode - NOP #$f3
__fd96:     asl                ; $fd96: 0a        
            .hex 7c 94 36      ; $fd97: 7c 94 36  Invalid Opcode - NOP $3694,x
            sty $33,x          ; $fd9a: 94 33     
            .hex 30            ; $fd9c: 30        Suspected data
__fd9d:     and #$26           ; $fd9d: 29 26     
            .hex 23 20         ; $fd9f: 23 20     Invalid Opcode - RLA ($20,x)
            ora $1916,y        ; $fda1: 19 16 19  
            jsr $2623          ; $fda4: 20 23 26  
            and #$30           ; $fda7: 29 30     
            beq __fdaf         ; $fda9: f0 04     
            .hex f2            ; $fdab: f2        Invalid Opcode - KIL 
            rti                ; $fdac: 40        

;-------------------------------------------------------------------------------
            .hex f3 06         ; $fdad: f3 06     Invalid Opcode - ISC ($06),y
__fdaf:     .hex 1b 94 1b      ; $fdaf: 1b 94 1b  Invalid Opcode - SLO $1b94,y
            txs                ; $fdb2: 9a        
            .hex ff f0 01      ; $fdb3: ff f0 01  Invalid Opcode - ISC $01f0,x
            sed                ; $fdb6: f8        
            .hex 04 20         ; $fdb7: 04 20     Invalid Opcode - NOP $20
            sty $7c,x          ; $fdb9: 94 7c     
            bmi __fe39         ; $fdbb: 30 7c     
            .hex ff f8 04      ; $fdbd: ff f8 04  Invalid Opcode - ISC $04f8,x
            .hex 17 7c         ; $fdc0: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 27 7c         ; $fdc2: 27 7c     Invalid Opcode - RLA $7c
            .hex ff 7c 9c      ; $fdc4: ff 7c 9c  Invalid Opcode - ISC __9c7c,x
            .hex 7c 96 17      ; $fdc7: 7c 96 17  Invalid Opcode - NOP $1796,x
            sta ($7c,x)        ; $fdca: 81 7c     
            .hex 17 ff         ; $fdcc: 17 ff     Invalid Opcode - SLO $ff,x
            brk                ; $fdce: 00        
            cld                ; $fdcf: d8        
            sbc $7c01,x        ; $fdd0: fd 01 7c  
            inc $2202,x        ; $fdd3: fe 02 22  
            .hex ff ff f2      ; $fdd6: ff ff f2  Invalid Opcode - ISC __f2ff,x
            .hex 80 f3         ; $fdd9: 80 f3     Invalid Opcode - NOP #$f3
            asl $f4            ; $fddb: 06 f4     
            .hex 02            ; $fddd: 02        Invalid Opcode - KIL 
            .hex fa            ; $fdde: fa        Invalid Opcode - NOP 
            adc #$fe           ; $fddf: 69 fe     
            .hex 29            ; $fde1: 29        Suspected data
__fde2:     ldx $2b            ; $fde2: a6 2b     
            ldy $30            ; $fde4: a4 30     
            beq __fdef         ; $fde6: f0 07     
            .hex 2b a6         ; $fde8: 2b a6     Invalid Opcode - ANC #$a6
            and #$29           ; $fdea: 29 29     
            plp                ; $fdec: 28        
            beq __fdf5         ; $fded: f0 06     
__fdef:     and #$a6           ; $fdef: 29 a6     
            .hex 2b fa         ; $fdf1: 2b fa     Invalid Opcode - ANC #$fa
            adc #$fe           ; $fdf3: 69 fe     
__fdf5:     bmi __fd9d         ; $fdf5: 30 a6     
            .hex 32            ; $fdf7: 32        Invalid Opcode - KIL 
            ldy $34            ; $fdf8: a4 34     
            beq __fe03         ; $fdfa: f0 07     
            .hex 32            ; $fdfc: 32        Invalid Opcode - KIL 
            .hex a6            ; $fdfd: a6        Suspected data
__fdfe:     bmi __fe32         ; $fdfe: 30 32     
            .hex 37 f0         ; $fe00: 37 f0     Invalid Opcode - RLA $f0,x
__fe02:     .hex 06            ; $fe02: 06        Suspected data
__fe03:     .hex 32            ; $fe03: 32        Invalid Opcode - KIL 
            tay                ; $fe04: a8        
__fe05:     sed                ; $fe05: f8        
            .hex 02            ; $fe06: 02        Invalid Opcode - KIL 
            beq __fe11         ; $fe07: f0 08     
            .hex f2            ; $fe09: f2        Invalid Opcode - KIL 
            rti                ; $fe0a: 40        

;-------------------------------------------------------------------------------
            .hex 3b a4 3b      ; $fe0b: 3b a4 3b  Invalid Opcode - RLA $3ba4,y
            .hex 7c 7c 3b      ; $fe0e: 7c 7c 3b  Invalid Opcode - NOP $3b7c,x
__fe11:     .hex 3b 7c 7c      ; $fe11: 3b 7c 7c  Invalid Opcode - RLA $7c7c,y
            .hex 3b 3b 7c      ; $fe14: 3b 3b 7c  Invalid Opcode - RLA $7c3b,y
            .hex 7c 3b f0      ; $fe17: 7c 3b f0  Invalid Opcode - NOP __f03b,x
            asl $f2            ; $fe1a: 06 f2     
__fe1c:     .hex 80 39         ; $fe1c: 80 39     Invalid Opcode - NOP #$39
            .hex 37 32         ; $fe1e: 37 32     Invalid Opcode - RLA $32,x
            .hex 34 ac         ; $fe20: 34 ac     Invalid Opcode - NOP $ac,x
            .hex ff fa 69      ; $fe22: ff fa 69  Invalid Opcode - ISC $69fa,x
            .hex fe 29 a6      ; $fe25: fe 29 a6  
            .hex 2b a4         ; $fe28: 2b a4     Invalid Opcode - ANC #$a4
            bmi __fe1c         ; $fe2a: 30 f0     
            .hex 07 2b         ; $fe2c: 07 2b     Invalid Opcode - SLO $2b
            ldx $29            ; $fe2e: a6 29     
            and #$28           ; $fe30: 29 28     
__fe32:     beq __fe3a         ; $fe32: f0 06     
            and #$a6           ; $fe34: 29 a6     
            .hex 2b fa         ; $fe36: 2b fa     Invalid Opcode - ANC #$fa
            .hex 69            ; $fe38: 69        Suspected data
__fe39:     .hex fe            ; $fe39: fe        Suspected data
__fe3a:     bmi __fde2         ; $fe3a: 30 a6     
            .hex 32            ; $fe3c: 32        Invalid Opcode - KIL 
            ldy $34            ; $fe3d: a4 34     
            beq __fe48         ; $fe3f: f0 07     
            .hex 32            ; $fe41: 32        Invalid Opcode - KIL 
            ldx $30            ; $fe42: a6 30     
            .hex 32            ; $fe44: 32        Invalid Opcode - KIL 
            .hex 37 f0         ; $fe45: 37 f0     Invalid Opcode - RLA $f0,x
            .hex 06            ; $fe47: 06        Suspected data
__fe48:     .hex 32            ; $fe48: 32        Invalid Opcode - KIL 
            tay                ; $fe49: a8        
            sed                ; $fe4a: f8        
            .hex 02            ; $fe4b: 02        Invalid Opcode - KIL 
            beq __fe56         ; $fe4c: f0 08     
            .hex f2            ; $fe4e: f2        Invalid Opcode - KIL 
            rti                ; $fe4f: 40        

;-------------------------------------------------------------------------------
            .hex 3b a4 3b      ; $fe50: 3b a4 3b  Invalid Opcode - RLA $3ba4,y
            .hex 7c 7c 3b      ; $fe53: 7c 7c 3b  Invalid Opcode - NOP $3b7c,x
__fe56:     .hex 3b 7c 7c      ; $fe56: 3b 7c 7c  Invalid Opcode - RLA $7c7c,y
            .hex 3b 3b 7c      ; $fe59: 3b 3b 7c  Invalid Opcode - RLA $7c3b,y
            .hex 7c 3b f0      ; $fe5c: 7c 3b f0  Invalid Opcode - NOP __f03b,x
            asl $f2            ; $fe5f: 06 f2     
            .hex 80 39         ; $fe61: 80 39     Invalid Opcode - NOP #$39
            .hex 37 32         ; $fe63: 37 32     Invalid Opcode - RLA $32,x
            .hex 34 ac         ; $fe65: 34 ac     Invalid Opcode - NOP $ac,x
            .hex ff ff f0      ; $fe67: ff ff f0  Invalid Opcode - ISC __f0ff,x
            asl $29            ; $fe6a: 06 29     
            ldx $2b            ; $fe6c: a6 2b     
            ldy $30            ; $fe6e: a4 30     
            beq __fe79         ; $fe70: f0 07     
            .hex 2b a6         ; $fe72: 2b a6     Invalid Opcode - ANC #$a6
            and #$2b           ; $fe74: 29 2b     
            .hex 34 f0         ; $fe76: 34 f0     Invalid Opcode - NOP $f0,x
            .hex 06            ; $fe78: 06        Suspected data
__fe79:     .hex 2b a8         ; $fe79: 2b a8     Invalid Opcode - ANC #$a8
            .hex ff f2 80      ; $fe7b: ff f2 80  Invalid Opcode - ISC __80f2,x
            .hex f3 08         ; $fe7e: f3 08     Invalid Opcode - ISC ($08),y
            .hex f4 02         ; $fe80: f4 02     Invalid Opcode - NOP $02,x
            .hex fa            ; $fe82: fa        Invalid Opcode - NOP 
            .hex 0f ff 25      ; $fe83: 0f ff 25  Invalid Opcode - SLO $25ff
            ldx $27            ; $fe86: a6 27     
            ldy $29            ; $fe88: a4 29     
            beq __fe93         ; $fe8a: f0 07     
            .hex 27 a6         ; $fe8c: 27 a6     Invalid Opcode - RLA $a6
            and $24            ; $fe8e: 25 24     
            bit $f0            ; $fe90: 24 f0     
            .hex 06            ; $fe92: 06        Suspected data
__fe93:     bit $a6            ; $fe93: 24 a6     
            .hex 27 fa         ; $fe95: 27 fa     Invalid Opcode - RLA $fa
            .hex 0f ff 29      ; $fe97: 0f ff 29  Invalid Opcode - SLO $29ff
            ldx $2b            ; $fe9a: a6 2b     
            ldy $30            ; $fe9c: a4 30     
            beq __fea7         ; $fe9e: f0 07     
            .hex 2b a6         ; $fea0: 2b a6     Invalid Opcode - ANC #$a6
            and #$2b           ; $fea2: 29 2b     
            .hex 32            ; $fea4: 32        Invalid Opcode - KIL 
            beq __fead         ; $fea5: f0 06     
__fea7:     .hex 2b a8         ; $fea7: 2b a8     Invalid Opcode - ANC #$a8
            sed                ; $fea9: f8        
            .hex 02            ; $feaa: 02        Invalid Opcode - KIL 
            beq __feb6         ; $feab: f0 09     
__fead:     .hex f2            ; $fead: f2        Invalid Opcode - KIL 
            rti                ; $feae: 40        

;-------------------------------------------------------------------------------
            .hex 3b a4 3b      ; $feaf: 3b a4 3b  Invalid Opcode - RLA $3ba4,y
            .hex 7c 7c 3b      ; $feb2: 7c 7c 3b  Invalid Opcode - NOP $3b7c,x
            .hex 3b            ; $feb5: 3b        Suspected data
__feb6:     .hex 7c 7c 3b      ; $feb6: 7c 7c 3b  Invalid Opcode - NOP $3b7c,x
            .hex 3b 7c 7c      ; $feb9: 3b 7c 7c  Invalid Opcode - RLA $7c7c,y
            .hex 3b f0 06      ; $febc: 3b f0 06  Invalid Opcode - RLA $06f0,y
            .hex f2            ; $febf: f2        Invalid Opcode - KIL 
            .hex 80 34         ; $fec0: 80 34     Invalid Opcode - NOP #$34
            .hex 32            ; $fec2: 32        Invalid Opcode - KIL 
            .hex 2b 30         ; $fec3: 2b 30     Invalid Opcode - ANC #$30
            tax                ; $fec5: aa        
            .hex 2b ff         ; $fec6: 2b ff     Invalid Opcode - ANC #$ff
            .hex fa            ; $fec8: fa        Invalid Opcode - NOP 
            .hex 0f ff 25      ; $fec9: 0f ff 25  Invalid Opcode - SLO $25ff
            ldx $27            ; $fecc: a6 27     
            ldy $29            ; $fece: a4 29     
            beq __fed9         ; $fed0: f0 07     
            .hex 27 a6         ; $fed2: 27 a6     Invalid Opcode - RLA $a6
            and $24            ; $fed4: 25 24     
            bit $f0            ; $fed6: 24 f0     
            .hex 06            ; $fed8: 06        Suspected data
__fed9:     bit $a6            ; $fed9: 24 a6     
            .hex 27 fa         ; $fedb: 27 fa     Invalid Opcode - RLA $fa
            .hex 0f ff 29      ; $fedd: 0f ff 29  Invalid Opcode - SLO $29ff
            ldx $2b            ; $fee0: a6 2b     
            ldy $30            ; $fee2: a4 30     
            beq __feed         ; $fee4: f0 07     
            .hex 2b a6         ; $fee6: 2b a6     Invalid Opcode - ANC #$a6
            and #$2b           ; $fee8: 29 2b     
            .hex 32            ; $feea: 32        Invalid Opcode - KIL 
            beq __fef3         ; $feeb: f0 06     
__feed:     .hex 2b a8         ; $feed: 2b a8     Invalid Opcode - ANC #$a8
            sed                ; $feef: f8        
            .hex 02            ; $fef0: 02        Invalid Opcode - KIL 
            beq __fefc         ; $fef1: f0 09     
__fef3:     .hex f2            ; $fef3: f2        Invalid Opcode - KIL 
            rti                ; $fef4: 40        

;-------------------------------------------------------------------------------
            .hex 3b a4 3b      ; $fef5: 3b a4 3b  Invalid Opcode - RLA $3ba4,y
            .hex 7c 7c 3b      ; $fef8: 7c 7c 3b  Invalid Opcode - NOP $3b7c,x
            .hex 3b            ; $fefb: 3b        Suspected data
__fefc:     .hex 7c            ; $fefc: 7c        Suspected data
__fefd:     .hex 7c            ; $fefd: 7c        Suspected data
__fefe:     .hex 3b            ; $fefe: 3b        Suspected data
__feff:     .hex 3b 7c 7c      ; $feff: 3b 7c 7c  Invalid Opcode - RLA $7c7c,y
            .hex 3b f0 06      ; $ff02: 3b f0 06  Invalid Opcode - RLA $06f0,y
            .hex f2            ; $ff05: f2        Invalid Opcode - KIL 
            .hex 80 34         ; $ff06: 80 34     Invalid Opcode - NOP #$34
            .hex 32            ; $ff08: 32        Invalid Opcode - KIL 
            .hex 2b 30         ; $ff09: 2b 30     Invalid Opcode - ANC #$30
            tax                ; $ff0b: aa        
            .hex 2b ff         ; $ff0c: 2b ff     Invalid Opcode - ANC #$ff
            .hex ff f0 06      ; $ff0e: ff f0 06  Invalid Opcode - ISC $06f0,x
            bit $a6            ; $ff11: 24 a6     
            .hex 27 a4         ; $ff13: 27 a4     Invalid Opcode - RLA $a4
            and #$f0           ; $ff15: 29 f0     
            .hex 07 27         ; $ff17: 07 27     Invalid Opcode - SLO $27
__ff19:     ldx $24            ; $ff19: a6 24     
__ff1b:     .hex 27 2b         ; $ff1b: 27 2b     Invalid Opcode - RLA $2b
            beq __ff25         ; $ff1d: f0 06     
__ff1f:     .hex 27 a8         ; $ff1f: 27 a8     Invalid Opcode - RLA $a8
            .hex ff f0 01      ; $ff21: ff f0 01  Invalid Opcode - ISC $01f0,x
            .hex f4            ; $ff24: f4        Suspected data
__ff25:     .hex 02            ; $ff25: 02        Invalid Opcode - KIL 
            .hex fa            ; $ff26: fa        Invalid Opcode - NOP 
            .hex 57 ff         ; $ff27: 57 ff     Invalid Opcode - SRE $ff,x
            .hex fa            ; $ff29: fa        Invalid Opcode - NOP 
            .hex 89 ff         ; $ff2a: 89 ff     Invalid Opcode - NOP #$ff
            .hex fa            ; $ff2c: fa        Invalid Opcode - NOP 
__ff2d:     .hex 57 ff         ; $ff2d: 57 ff     Invalid Opcode - SRE $ff,x
            .hex fa            ; $ff2f: fa        Invalid Opcode - NOP 
            txs                ; $ff30: 9a        
            .hex ff fa 57      ; $ff31: ff fa 57  Invalid Opcode - ISC $57fa,x
            .hex ff fa 89      ; $ff34: ff fa 89  Invalid Opcode - ISC __89fa,x
            .hex ff fa 57      ; $ff37: ff fa 57  Invalid Opcode - ISC $57fa,x
            .hex ff fa 89      ; $ff3a: ff fa 89  Invalid Opcode - ISC __89fa,x
            .hex ff fa 57      ; $ff3d: ff fa 57  Invalid Opcode - ISC $57fa,x
            .hex ff fa 89      ; $ff40: ff fa 89  Invalid Opcode - ISC __89fa,x
            .hex ff fa 57      ; $ff43: ff fa 57  Invalid Opcode - ISC $57fa,x
            .hex ff fa 9a      ; $ff46: ff fa 9a  Invalid Opcode - ISC __9afa,x
            .hex ff fa 57      ; $ff49: ff fa 57  Invalid Opcode - ISC $57fa,x
            .hex ff fa 89      ; $ff4c: ff fa 89  Invalid Opcode - ISC __89fa,x
            .hex ff fa 57      ; $ff4f: ff fa 57  Invalid Opcode - ISC $57fa,x
            .hex ff fa 89      ; $ff52: ff fa 89  Invalid Opcode - ISC __89fa,x
            .hex ff ff 19      ; $ff55: ff ff 19  Invalid Opcode - ISC $19ff,x
            ldx #$7c           ; $ff58: a2 7c     
            ora $297c,y        ; $ff5a: 19 7c 29  
            .hex 7c 29 7c      ; $ff5d: 7c 29 7c  Invalid Opcode - NOP $7c29,x
            ora $197c,y        ; $ff60: 19 7c 19  
            .hex 7c 29 7c      ; $ff63: 7c 29 7c  Invalid Opcode - NOP $7c29,x
            and #$7c           ; $ff66: 29 7c     
            .hex 17 7c         ; $ff68: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 17 7c         ; $ff6a: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 27 7c         ; $ff6c: 27 7c     Invalid Opcode - RLA $7c
__ff6e:     .hex 27 7c         ; $ff6e: 27 7c     Invalid Opcode - RLA $7c
            .hex 17 7c         ; $ff70: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 17 7c         ; $ff72: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 27 7c         ; $ff74: 27 7c     Invalid Opcode - RLA $7c
            .hex 27 7c         ; $ff76: 27 7c     Invalid Opcode - RLA $7c
            ora $7c,x          ; $ff78: 15 7c     
            ora $7c,x          ; $ff7a: 15 7c     
            and $7c            ; $ff7c: 25 7c     
            and $7c            ; $ff7e: 25 7c     
            ora $7c,x          ; $ff80: 15 7c     
            ora $7c,x          ; $ff82: 15 7c     
            and $7c            ; $ff84: 25 7c     
            and $7c            ; $ff86: 25 7c     
            .hex ff 14 7c      ; $ff88: ff 14 7c  Invalid Opcode - ISC $7c14,x
            .hex 14 7c         ; $ff8b: 14 7c     Invalid Opcode - NOP $7c,x
            bit $7c            ; $ff8d: 24 7c     
            bit $7c            ; $ff8f: 24 7c     
            .hex 14 7c         ; $ff91: 14 7c     Invalid Opcode - NOP $7c,x
            .hex 14 7c         ; $ff93: 14 7c     Invalid Opcode - NOP $7c,x
            bit $7c            ; $ff95: 24 7c     
            bit $7c            ; $ff97: 24 7c     
__ff99:     .hex ff 17 7c      ; $ff99: ff 17 7c  Invalid Opcode - ISC $7c17,x
            .hex 17 7c         ; $ff9c: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 27 7c         ; $ff9e: 27 7c     Invalid Opcode - RLA $7c
            .hex 27 7c         ; $ffa0: 27 7c     Invalid Opcode - RLA $7c
            .hex 17 7c         ; $ffa2: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 17 7c         ; $ffa4: 17 7c     Invalid Opcode - SLO $7c,x
            .hex 27 7c         ; $ffa6: 27 7c     Invalid Opcode - RLA $7c
            .hex 27 7c         ; $ffa8: 27 7c     Invalid Opcode - RLA $7c
            .hex ff ff ff      ; $ffaa: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffad: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffb0: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffb3: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffb6: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffb9: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffbc: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffbf: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffc2: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffc5: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffc8: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffcb: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffce: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffd1: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffd4: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffd7: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffda: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffdd: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffe0: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffe3: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffe6: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffe9: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffec: ff ff ff  Invalid Opcode - ISC $ffff,x
__ffef:     .hex ff ff ff      ; $ffef: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $fff2: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $fff5: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff         ; $fff8: ff ff     Suspected data

;-------------------------------------------------------------------------------
; Vector Table
;-------------------------------------------------------------------------------
vectors:    .dw nmi                        ; $fffa: a0 80     Vector table
            .dw reset                      ; $fffc: 00 80     Vector table
            .dw irq                        ; $fffe: 9b 80     Vector table
