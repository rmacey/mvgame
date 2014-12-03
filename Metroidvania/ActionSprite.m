//
//  ActionSprite.m
//  PompaDroid
//
//  Created by Allen Benson G Tan on 10/21/12.
//  Copyright 2012 WhiteWidget Inc. All rights reserved.
//

#import "ActionSprite.h"
#import "OALSimpleAudio.h"

@implementation ActionSprite

-(void)update:(CCTime)dt
{
    [self adjustNoInputFrames];
    [self regenerateMana];
    
//    CGPoint gravity = ccp(0.0, -self.gravityForce);
//    CGPoint gravityStep = ccpMult(gravity, dt);
//    self.velocity = ccpAdd(self.velocity, gravityStep);
    
    //in each frame you apply damping, reducing overall horizontal force. 0.90 friction eqauls 2 percent reduction in force per frame
    if (self.onGround)
    {
        self.velocity = ccp(self.velocity.x * self.friction, self.velocity.y);
    }
    else if (!self.onGround) //later on make seperate force for wind resistance so we don't use friction here
    {
        self.velocity = ccp(self.velocity.x * self.friction, self.velocity.y);
    }
    
    if(self.moveRight == NO && self.moveLeft == NO && self.onGround && self.statusState == statusStateNone && self.noInputFrames == 0)
        [self makeIdle];
    
    
    if (self.moveRight || self.moveLeft)
        [self moveWithTime:dt];

//    CGPoint stepVelocity = ccpMult(self.velocity, dt);
//    self.desiredPosition = ccpAdd(self.position, stepVelocity);
    
    if (self.isIntangible)
        self.opacity = .45f;
    else
        self.opacity = 1.0f;
    
    
    for(Attack *activeAttack in self.activeAttacks)
        [activeAttack update:dt];
    
    
    if([self.activeAttacks count] == 0)
        self.attackState = attackStateNone;
    
    //self.position = self.desiredPosition;
    [self orientSprite];
}
-(void)fixedUpdate:(CCTime)dt
{
   // NSLog(@"player fixedUpdate - velocityY: %f", self.velocity.y);
    CGPoint gravity = ccp(0.0, -self.gravityForce);
    CGPoint gravityStep = ccpMult(gravity, dt);
    self.velocity = ccpAdd(self.velocity, gravityStep);
        
    //in each frame you apply damping, reducing overall horizontal force. 0.90 friction eqauls 2 percent reduction in force per frame
//    if (self.onGround)
//    {
//       self.velocity = ccp(self.velocity.x * self.friction, self.velocity.y);
//    }
//    else if (!self.onGround) //later on make seperate force for wind resistance so we don't use friction here
//    {
//        self.velocity = ccp(self.velocity.x * self.friction, self.velocity.y);
//    }
    
//    if (self.moveRight || self.moveLeft)
//    {
//        [self moveWithTime:dt];
//    }
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    self.desiredPosition = ccpAdd(self.position, stepVelocity);

}
-(void)moveWithTime:(CCTime)dt
{
    if (_movementState == movementStateIdle)
    {
        [self stopAllActions];
        [self runAction:_runAction];
        _movementState = movementStateRun;
    }

    CGPoint stepMovement;
    if (self.onGround)
        stepMovement = ccp(self.runSpeed + self.acceleration, 0.0);
    else
       stepMovement = ccp(self.airSpeed + self.acceleration, 0.0);
    
    if(self.moveLeft) //reverse sign of movement if going left
        stepMovement = ccp(stepMovement.x*-1, stepMovement.y);
    
    stepMovement = ccpMult(stepMovement, dt);
    self.velocity = ccpAdd(self.velocity, stepMovement);

    //first value is maximum speed going left, second is maximum falling speed
    CGPoint minMovement = ccp(0 - self.maxRunSpeed, self.maxFallSpeed - self.weight*2);
   
    //first value is maximum speed going right, second is maximum jump speed
    CGPoint maxMovement = ccp(self.maxRunSpeed, self.maxJumpSpeed);
  
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement); //4
    
    //[self orientSprite];
}
-(void)landingDetectedWithYVelocity:(float)velocity
{


}

-(void)orientSprite
{ //determines direction sprite is facing
    if (self.velocity.x > 0)
        self.scaleX = self.XScale;
    else if (self.velocity.x < 0)
        self.scaleX = -self.XScale;
}

-(void)transformSizeTo: (CGSize)newSize
{
    self.centerToBottom = newSize.height/2;
    self.centerToSides = newSize.width/2;
    //self.hurtBox = [self createBoundingBoxWithOrigin:ccp(-self.centerToSides, -self.centerToBottom) size:CGSizeMake(self.centerToSides*2, self.centerToBottom*2)];
    
    self.hurtBox = [self createBoundingBoxWithOrigin:ccp(-self.centerToSidesOriginal, -self.centerToBottomOriginal) size:CGSizeMake(self.centerToSides*2, self.centerToBottom*2)];
}

-(void)transformBoxes
{
    _hurtBox.actual.origin = ccpAdd(self.position, ccp(_hurtBox.original.origin.x, _hurtBox.original.origin.y));
    _hurtBox.actual.size = CGSizeMake(_hurtBox.original.size.width, _hurtBox.original.size.height);
}

-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size
{
    BoundingBox boundingBox;
    boundingBox.original.origin = origin;
    boundingBox.original.size = size;
    boundingBox.actual.origin = ccpAdd(self.position, ccp(boundingBox.original.origin.x, boundingBox.original.origin.y));
    boundingBox.actual.size = size;
    return boundingBox;
}

-(void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    [self transformBoxes];
}




-(void)regenerateMana
{
    if(self.maxMana > 0 && self.mana < self.maxMana)
        self.mana = self.mana + self.manaRegen;
}
-(void)adjustNoInputFrames
{
    if (self.noInputFrames > 0)
    {
        self.noInputFrames--;
        if (self.noInputFrames == 0)
        {
            if(self.statusState == statusStateHurt)
                self.statusState = statusStateNone;
            if(self.isIntangible)
                [self reverseIntangibility];
        }
    }
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

-(void)hurtWithDamage:(double)damage andStun:(double)stun
{
        [self stopAllActions];
        [self runAction:_hurtAction];
        _statusState = statusStateHurt;
        _health -= damage;
    
        if (_health <= 0.0)
            [self death];
        else
        {
            self.noInputFrames = stun;
//            self.isIntangible = YES;
//            NSTimeInterval interval = stun/120;
//            [self performSelector:@selector(reverseIntangibility:) withObject:nil afterDelay:interval];
        }
}

-(void)reverseIntangibility
{
    if(self.isIntangible)
        self.isIntangible = FALSE;
    else
        self.isIntangible = TRUE;
}
-(void) reverseDirection
{
    if (self.moveRight == YES)
    {
        self.moveRight = NO;
        self.moveLeft = YES;
    }
    else if (self.moveLeft == YES)
    {
        self.moveLeft = NO;
        self.moveRight = YES;
    }
}
-(void)makeIdle
{
    [self stopAllActions];
    self.movementState = movementStateIdle;
    self.attackState = attackStateNone;
    [self runAction:self.idleAction];
    self.acceleration = 0.0;
    
    [self transformSizeTo:CGSizeMake(self.centerToSidesOriginal*2, self.centerToBottomOriginal*2)];
}

-(void)crouch
{
    [self stopAllActions];
    [self runAction:self.crouchAction];
    [self transformSizeTo:CGSizeMake(self.centerToSidesOriginal*2, self.centerToBottomOriginal*1.2)];
    self.statusState = statusStateCrouch;
    self.moveLeft = NO;
    self.moveRight = NO;
    self.movementState = movementStateIdle;
    self.noInputFrames += 2;
}

-(void)death
{
    [self stopAllActions];
    [self runAction:_deathAction];
    self.statusState = statusStateDeath;
}
-(void)attackEnded:(Attack *)attack
{
    if(DISPLAY_DEBUG_HITBOXES)
    {
        [attack.debugHitBox clear];
        attack.debugHitBox = Nil;
    }
    
    [self.activeAttacks removeObject:attack];
    [self removeChild:attack cleanup:YES];
    attack = nil;
    attack = Nil;
}


@end