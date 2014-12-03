//
//  Platform.m
//  Metroidvania
//
//  Created by Ryan Macey on 11/4/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "Platform.h"
#import "CCAnimation.h"

@interface Platform ()

@end

@implementation Platform
{
    BOOL moveUp;
    BOOL moveDown;
    BOOL moveRight;
    BOOL moveLeft;
    
    CGFloat movementSpeed;
    NSString *type;
    
}

- (id)initWithImageNamed:(NSString *)name forPlatformType:(NSString*)platformType withSpeed:(CGFloat)speed andDistance:(CGFloat)distanceToMove;
{
    CCSpriteFrame *initialSpriteFrame = [CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"%@.png", name]];
    moveLeft = nil;
    moveRight = nil;
    moveUp = nil;
    moveDown = nil;
    movementSpeed = speed;
    type = platformType;
    _distance = distanceToMove;

    if([type isEqual:@"horizontal"])
    {
        //int rand = random_range(1, 2);
        //if (rand==1)
            moveRight = YES;
        //else
          //  moveLeft = YES;
    }
    else if ([type isEqual:@"vertical"])
    {
        //int rand = random_range(1, 2);
        //if (rand==1)
            moveUp = YES;
        //else
        //    moveDown = YES;
    }
    
    return [self initWithSpriteFrame:initialSpriteFrame];
}

-(void)update:(CCTime)dt
{    
    [self moveWithTime:dt];
 
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    self.position = ccpAdd(self.position, stepVelocity);
    
    if([type isEqual:@"horizontal"])
    {
        if(fabsf(self.position.x - self.previousPos.x) >= _distance)
        {
            self.previousPos = self.position;
            [self reverseDirection];
        }
    }
    else if([type isEqual:@"vertical"])
    {
        if(fabsf(self.position.y - self.previousPos.y) >= _distance)
        {
            self.previousPos = self.position;
            [self reverseDirection];
        }
    }
}

-(void)moveWithTime:(CCTime)dt
{
    CGPoint stepMovement;
    
    if([type isEqual:@"horizontal"])
    {
        stepMovement = ccp(movementSpeed, 0.0);
        
        if(moveLeft) //reverse sign of movement if going left
            stepMovement = ccp(stepMovement.x*-1, 0.0);
    }
    else if([type isEqual:@"vertical"])
    {
        stepMovement = ccp(0.0, movementSpeed);
        
        if(moveDown) //reverse sign of movement if going down
            stepMovement = ccp(0.0, stepMovement.y*-1);
    }

    stepMovement = ccpMult(stepMovement, dt);
    self.velocity = ccpAdd(self.velocity, stepMovement);
}

- (CGRect)collisionBoundingBox {
    
    CGRect boundingBox = self.boundingBox;
    return boundingBox;
}

-(void) reverseDirection
{
    self.velocity = CGPointZero;
    
    if (moveRight == YES)
    {
        moveRight = NO;
        moveLeft = YES;
    }
    else if (moveLeft == YES)
    {
        moveLeft = NO;
        moveRight = YES;
    }
    
    if (moveUp == YES)
    {
        moveUp = NO;
        moveDown = YES;
    }
    else if (moveDown == YES)
    {
        moveDown = NO;
        moveUp = YES;
    }
}

@end
