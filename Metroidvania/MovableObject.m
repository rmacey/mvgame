//
//  MovableObject.m
//  Metroidvania
//
//  Created by Ryan Macey on 12/4/14.
//  Copyright 2014 Ryan Macey. All rights reserved.
//

#import "MovableObject.h"


@implementation MovableObject

-(id)init
{
    self.velocity = ccp(0,0);
    self.friction = 54; //corresponds to 2% velocity reduction per frame at 60fps
    self.gravityForce = 0;
    self.obeysGravity = YES;
    self.obeysFriction = YES;
    self.collidable = YES;
    
    return self;
}

-(void)update:(CCTime)dt
{
    if(self.obeysFriction)
        [self applyFriction:dt];
}

-(void)fixedUpdate:(CCTime)dt
{
    if(self.obeysGravity)
        [self applyGravity:dt];
    
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
}



-(void)moveWithSpeed:(double)speed andTime:(CCTime)dt
{
    CGPoint stepMovement = ccp(speed, 0.0);

    if(self.moveLeft) //reverse sign of movement if going left
        stepMovement = ccp(stepMovement.x*-1, stepMovement.y);
    
    stepMovement = ccpMult(stepMovement, dt);
    
    self.velocity = ccpAdd(self.velocity, stepMovement);
    
    [self applyVelocitySafetyClamp];
}

-(void)applyImpulseWithKnockback:(float)knockback andDirection:(float)direction
{
    //convert direction in degrees to radians
    float directionInRadians = direction * M_PI / 180;
    
    //convert direction (radians) to vector
    CGPoint directionVector = ccpForAngle(directionInRadians);
    
    //multiply it by knockback
    directionVector = ccpMult(directionVector, knockback);
    
    //add the new point to action sprite's current velocity
    self.velocity = ccpAdd(self.velocity, directionVector);
}

-(void)applyImpulse:(CGPoint)impulse
{
    self.velocity = ccpAdd(self.velocity, impulse);
}





-(void)applyGravity:(CCTime)dt
{
    CGPoint gravity = ccp(0.0, -self.gravityForce);
    CGPoint gravityStep = ccpMult(gravity, dt);
    self.velocity = ccpAdd(self.velocity, gravityStep);
}

-(void)applyFriction:(CCTime)dt

{
    self.velocity = ccp(self.velocity.x * self.friction * dt, self.velocity.y);
}

-(void)applyVelocitySafetyClamp
{
    //first value is maximum speed going left, second is maximum falling speed
    CGPoint minMovement = ccp(-4000, -4000);
    
    //first value is maximum speed going right, second is maximum jump speed
    CGPoint maxMovement = ccp(4000, 4000);
    
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement);
}

@end
