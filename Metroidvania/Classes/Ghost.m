//
//  TestMonster.m
//  Metroidvania
//
//  Created by Ryan Macey on 6/2/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "Ghost.h"
#import "CCAnimation.h"

@implementation Ghost

-(id)init
{
    [self prepareAnimations];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                         spriteFrameByName:@"GhostAppear-1.png"];
    
    self.velocity = ccp(0.0, 0.0);
    self.airSpeed = 75.0f; //slow because they have no gravity
    self.XScale = 2.0;
    self.YScale = 2.0;
    
    self.acceleration = 0.0f;
    
    int rand = random_range(1, 2);
    if (rand==1)
        self.moveRight = YES;
    else
        self.moveLeft = YES;
    
    self.friction = 0.90;
    self.maxJumpSpeed = 2000.0f;
    self.maxRunSpeed = 2400.0f;
    self.movementState = movementStateIdle;
    self.health = 50.0;
    self.weight = 200.0f;
    self.maxFallSpeed = -1200.0f;
    
    self.gravityForce = 0;
    
    self.centerToBottom = 25.0f;
    self.centerToSides = 22.0f;
    self.hurtBox = [self createBoundingBoxWithOrigin:ccp(-self.centerToSides, -self.centerToBottom) size:CGSizeMake(self.centerToSides * 2, self.centerToBottom * 2)];
    
    if(DISPLAY_DEBUG_HURTBOXES)
    {
        self.debugHurtBox = [[CCDrawNode alloc] init];
        self.debugHurtBox.contentSize = CGSizeMake(self.hurtBox.actual.size.width, self.hurtBox.actual.size.height);
    }
    
    self.stepTimer = 600;
    
    return [self initWithSpriteFrame:initialSpriteFrame];
}

- (void)prepareAnimations
{
    //later on method will take in spriteframes plist. this will add the animations and old animations will be overwritten
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"Ghost1.plist"];
    
    NSMutableArray *appearFrames = [NSMutableArray array];
    for(int i = 1; i <= 5; ++i)
    {
        [appearFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"GhostAppear-%d.png", i]]];
    }
    CCAnimation *appearAnimation = [CCAnimation animationWithSpriteFrames: appearFrames delay:0.06f];
    self.appearAction = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:appearAnimation]];
    
    NSMutableArray *disappearFrames = [NSMutableArray array];
    for(int i = 5; i >= 1; i--)
    {
        [disappearFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"GhostAppear-%d.png", i]]];
    }
    CCAnimation *disappearAnimation = [CCAnimation animationWithSpriteFrames: disappearFrames delay:0.06f];
    self.disappearAction = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:disappearAnimation]];
    self.hurtAction = [CCActionAnimate actionWithAnimation:disappearAnimation];
    self.deathAction = [CCActionAnimate actionWithAnimation:disappearAnimation];
    
    
    NSMutableArray *flyFrames = [NSMutableArray array];
    for(int i=1; i<=4; i++)
    {
        [flyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"GhostFly-%d.png", i]]];
    }
    CCAnimation *flyAnimation = [CCAnimation animationWithSpriteFrames:flyFrames delay:0.12f];
    self.flyAction = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:flyAnimation]];
    
    
    NSMutableArray *idleFrames = [NSMutableArray array];
    for(int i = 1; i <= 1; i++)
    {
        [idleFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"GhostIdle-1.png"]];
    }
    CCAnimation *idleAnimation = [CCAnimation animationWithSpriteFrames: idleFrames delay:0.01f];
    self.idleAction = [CCActionAnimate actionWithAnimation:idleAnimation];
    
    NSMutableArray *attackFrames = [NSMutableArray array];
    for(int i = 1; i <= 6; i++)
    {
        [attackFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"GhostAttack-%d.png", i]]];
    }
    CCAnimation *attackAnimation = [CCAnimation animationWithSpriteFrames: attackFrames delay:0.04f];
    self.airAttackAction = [CCActionAnimate actionWithAnimation:attackAnimation];
}


-(void)moveWithTime:(CCTime)dt
{
    
    
        CGPoint movementStep;
        if (self.moveRight)
        {
            CGPoint forwardMove = ccp(self.airSpeed + self.acceleration, 0.0);
            movementStep = ccpMult(forwardMove, dt);
            self.velocity = ccpAdd(self.velocity, movementStep);
        }
        if (self.moveLeft)
        {
            CGPoint backwardMove = ccp(0.0 - self.airSpeed - self.acceleration, 0.0);
            movementStep = ccpMult(backwardMove, dt); //1
            self.velocity = ccpAdd(self.velocity, movementStep);
        }

        [self orientSprite];
}

-(void)hurtWithDamage:(double)damage andStun:(double)stun
{
    [super hurtWithDamage:damage andStun:stun];
    [[OALSimpleAudio sharedInstance] playEffect:@"sizzle-1.wav"];

}

-(void)update:(CCTime)dt
{
    self.stepTimer--;
    
    if(self.stepTimer <= 480)
        self.movementState = movementStateRun;
    
    if (self.stepTimer == 50)
    {
        self.movementState = movementStateIdle;
        [self stopAllActions];
        [self runAction:self.disappearAction];
    }
    
    if(self.stepTimer == 400 || self.stepTimer == 290)
    {
        int rand = random_range(1, 2);
        if (rand==1)
        {
            self.moveRight = YES;
            self.moveLeft = NO;
        }
        else
        {
            self.moveLeft = YES;
            self.moveRight = NO;
        }
    }
    
 

    
    if(self.stepTimer == 0)
    {
        int rand = random_range(1, 2);
        if (rand==1)
        {
            self.moveRight = YES;
            self.moveLeft = NO;
        }
        else
        {
            self.moveLeft = YES;
            self.moveRight = NO;
        }
        self.stepTimer = random_range(480, 625);
        
        [self stopAllActions];
        [self runAction:self.flyAction];
    }
    
    if(self.movementState == movementStateRun)
    {
        [self moveWithTime:dt];
    }


    
    CGPoint gravity = ccp(0.0, -self.gravityForce);
    CGPoint gravityStep = ccpMult(gravity, dt);
    self.velocity = ccpAdd(self.velocity, gravityStep);
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
    
}
-(void)death
{
    [super death];
    
    if(DISPLAY_DEBUG_HURTBOXES)
    {
        [self.debugHurtBox clear];
        self.debugHurtBox = Nil;
    }
    
    [self removeFromParentAndCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
    
    
}



@end
