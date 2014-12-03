//
//  ActionSprite.h
//  Metroidvania
//
//  Created by Ryan Macey on 5/6/14.
//  Copyright 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Attack.h"

@interface ActionSprite : CCSprite <AttackDelegate> {
    }

//actions (for animations)
@property(nonatomic,strong)id idleAction;
@property(nonatomic,strong)id runAction;
@property(nonatomic,strong)id groundJumpAction;
@property(nonatomic,strong)id airJumpAction;
@property(nonatomic,strong)id hurtAction;
@property(nonatomic,strong)id deathAction;
@property(nonatomic,strong)id flyAction;
@property(nonatomic,strong)id crouchAction;
@property(nonatomic,strong)id fallingAction;

@property(nonatomic,strong)id groundAttackAction;
@property(nonatomic,strong)id groundAttack2Action;
@property(nonatomic,strong)id groundAttack3Action;
@property(nonatomic,strong)id airAttackAction;
@property(nonatomic,strong)id airAttack2Action;
@property(nonatomic,strong)id airAttack3Action;
@property(nonatomic,strong)id dashAttackAction;
@property(nonatomic,strong)id dashAttack2Action;
@property(nonatomic,strong)id dashAttack3Action;
@property(nonatomic,strong)id crouchAttackAction;
@property(nonatomic,strong)id specialAction;
@property(nonatomic,strong)id special2Action;
@property(nonatomic,strong)id special3Action;

//collision boxes
@property(nonatomic,assign)BoundingBox hurtBox;
@property(nonatomic,strong)CCDrawNode *debugHurtBox;
@property(nonatomic,retain)NSMutableArray *activeAttacks;

//states
@property(nonatomic,assign)MovementState movementState;
@property(nonatomic,assign)AttackState attackState;
@property(nonatomic,assign)StatusState statusState;
@property (nonatomic, assign) BOOL isIntangible;
@property (nonatomic, assign) BOOL onGround;

//attributes
@property(nonatomic, assign)double runSpeed;
@property(nonatomic, assign)double airSpeed;
@property(nonatomic, assign)double groundJumpStrength;
@property(nonatomic, assign)double shortHopStrength;
@property(nonatomic, assign)double airJumpStrength;
@property(nonatomic, assign)float jumpRetainVelocity;
@property(nonatomic, assign)int airJumps;
@property(nonatomic, assign)double gravityForce;

@property(nonatomic, assign)double health;
@property(nonatomic, assign)double maxHealth;
@property(nonatomic, assign)double mana;
@property(nonatomic, assign)double maxMana;
@property(nonatomic, assign)double manaRegen;

@property(nonatomic, assign)double maxRunSpeed;
@property(nonatomic, assign)double maxJumpSpeed;
@property(nonatomic, assign)double maxFallSpeed;
@property(nonatomic, assign)double weight;
@property(nonatomic, assign)double friction;
@property(nonatomic, assign)double acceleration;
@property(nonatomic, assign)double XScale;
@property(nonatomic, assign)double YScale;

@property(nonatomic, assign)double noInputFrames;


//movement
@property(nonatomic,assign)CGPoint velocity;
@property(nonatomic,assign)CGPoint desiredPosition;
@property (nonatomic, assign) BOOL moveRight;
@property (nonatomic, assign) BOOL moveLeft;

//measurements
@property(nonatomic,assign)double centerToSides;
@property(nonatomic,assign)double centerToBottom;
@property(nonatomic,assign)double centerToSidesOriginal;
@property(nonatomic,assign)double centerToBottomOriginal;


//action methods
-(void)makeIdle;
-(void)crouch;


-(void)hurtWithDamage:(double)damage andStun:(double)stun;
-(void)death;
-(void)moveWithTime:(CCTime)dt;
-(void)applyImpulseWithKnockback:(float)knockback andDirection:(float)direction;
-(void)applyImpulse: (CGPoint)impulse;
-(void)reverseIntangibility;
-(void)reverseDirection;
-(void)orientSprite;
-(void)transformSizeTo: (CGSize)newSize;
-(void)landingDetectedWithYVelocity: (float)velocity;



//collision box factory method
-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size;

@end
