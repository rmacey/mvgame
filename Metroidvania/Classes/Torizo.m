//
//  Torizo.m
//  Metroidvania
//
//  Created by Ryan Macey on 6/2/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "Torizo.h"
#import "CCAnimation.h"

@implementation Torizo

-(id)init
{
    self = [super init];
    [self prepareAnimations];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                         spriteFrameByName:@"Torizo-Right-1.png"];
    
   // self.velocity = ccp(0.0, 0.0);
    self.runSpeed = 2400.0f;
    self.groundJumpStrength = 450.0f;
    self.airSpeed = 600.0f;
    self.XScale = 1.5;
    self.YScale = 1.5;
    
    //self.acceleration = 0.0f;
    
    //self.friction = 0.90;
   // self.maxJumpSpeed = 2000.0f;
   // self.maxRunSpeed = 2400.0f;
 
    self.attackState = attackStateNone;
    self.statusState = statusStateNone;
    self.movementState = movementStateRun;
    
    self.health = 200.0;
   // self.weight = 200.0f;
   // self.maxFallSpeed = -1200.0f;
    
    self.gravityForce = 650.0f;
    
    self.centerToBottom = 66.5f;
    self.centerToSides = 38.0f;
    self.hurtBox = [self createBoundingBoxWithOrigin:ccp(-self.centerToSides, -self.centerToBottom) size:CGSizeMake(self.centerToSides * 2, self.centerToBottom * 2)];

    self.stepTimer = 50;
    
    if(DISPLAY_DEBUG_HURTBOXES)
    {
        self.debugHurtBox = [[CCDrawNode alloc] init];
        self.debugHurtBox.contentSize = CGSizeMake(self.hurtBox.actual.size.width, self.hurtBox.actual.size.height);
    }

    
    return [self initWithSpriteFrame:initialSpriteFrame];
}

- (void)prepareAnimations
{
    //later on method will take in spriteframes plist. this will add the animations and old animations will be overwritten
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"Torizo.plist"];
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    //set up animation for normal horizontal ground movement
    for(int i = 1; i <= 13; ++i)
    {
        [walkFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"Torizo-Right-%d.png", i]]];
    }
    CCAnimation *walkAnimation = [CCAnimation animationWithSpriteFrames: walkFrames delay:0.06f];
    self.runAction = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:walkAnimation]];
    
    //set up animation for normal jumps
    NSMutableArray *jumpFrames = [NSMutableArray array];
    for(int i=1; i<=1; i++)
    {
        [jumpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Torizo-Right-3.png"]];
    }
    CCAnimation *jumpAnimation = [CCAnimation animationWithSpriteFrames:jumpFrames delay:0.03f];
    self.groundJumpAction = [CCActionAnimate actionWithAnimation:jumpAnimation];
    
    
    NSMutableArray *idleFrames = [NSMutableArray array];
    for(int i = 1; i <= 1; i++)
    {
        [idleFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Torizo-Right-1.png"]];
    }
    CCAnimation *idleAnimation = [CCAnimation animationWithSpriteFrames: idleFrames delay:0.01f];
    self.idleAction = [CCActionAnimate actionWithAnimation:idleAnimation];
}

-(void)update:(CCTime)dt
{
    [super update:dt];
    
    if(self.onGround && self.noInputFrames == 0)
    {
        self.movementState = movementStateRun;
    }
    
    if (self.onGround && self.movementState == movementStateRun)
        if(self.stepTimer == 0)
        {
            self.stepTimer = 50;
            int randomSound = random_range(1, 3);
            [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"MonsterStep-%d.wav", randomSound] volume:0.3 pitch:1.0 pan:0.0 loop:NO];
        }
        else
        {
            self.stepTimer--;
        }
    
    int rand = random_range(1, 400);
    if (rand == 397 || rand == 398)
    {
        [self reverseDirection];
    }
    else if (rand == 399 && self.onGround)
    {
        [self stopAllActions];
        [self runAction:self.groundJumpAction];
        self.stepTimer = 0;
        [self applyImpulse:ccp(self.velocity.x, 820.00f)];
        self.movementState = movementStateJump;
        [[OALSimpleAudio sharedInstance] playEffect:@"playerDeath.mp3" volume:0.65 pitch:0.27 pan:0.0 loop:NO];
    }
    
    if(self.movementState != movementStateJump && self.onGround)
        if(self.numberOfRunningActions == 0)
            [self runAction:self.runAction];
    
}



-(void) reverseDirection
{
    if (self.moveLeft == YES)
    {
        self.moveLeft = NO;
        self.moveRight = YES;
    }
    else if (self.moveRight == YES)
    {
        self.moveRight = NO;
        self.moveLeft = YES;
    }
}

@end
