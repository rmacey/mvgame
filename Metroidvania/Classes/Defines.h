//
//  Defines.h
//  PompaDroid
//
//  Created by Allen Benson G Tan on 10/21/12.
//
//

#ifndef PompaDroid_Defines_h
#define PompaDroid_Defines_h

//convenience measurements
#define SCREEN [[CCDirector sharedDirector] winSize]
#define CENTER ccp(SCREEN.width/2, SCREEN.height/2)
#define CURTIME CACurrentMediaTime()

//convenience functions
#define random_range(low,high) (arc4random()%(high-low+1))+low
#define frandom (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low


#define DISPLAY_DEBUG_HITBOXES 0
#define DISPLAY_DEBUG_HURTBOXES 0

//enumerations
typedef enum _MovementState
{
    movementStateIdle = 0,
    movementStateRun,
    movementStateJump,
    movementStateFall,
} MovementState;

typedef enum _AttackState
{
    attackStateNone = 0,
    attackStateGroundAttack,
    attackStateDashAttack,
    attackStateAirAttack,
    attackStateFallingAttack,
    attackStateSpecialAttack,
    attackStateCrouchingAttack,
} AttackState;

typedef enum _StatusState
{
    statusStateNone = 0,
    statusStateCrouch,
    statusStateBlock,
    statusStateHurt,
    statusStateDeath,
} StatusState;

typedef enum _AttackType
{
    attackTypeNone = 0,
    attackTypeDash = 1,
    attackTypeGround = 2,
    attackTypeAir = 3,
    attackTypeProjectile = 4,
    attackTypeGrab = 5,
} AttackType;

//structures
typedef struct _BoundingBox
{
    CGRect actual;
    CGRect original;
} BoundingBox;

#endif
