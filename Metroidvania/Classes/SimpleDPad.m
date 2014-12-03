//
//  SimpleDPad.m
//  PompaDroid
//
//  Created by Allen Benson G Tan on 10/21/12.
//  Copyright 2012 WhiteWidget Inc. All rights reserved.
//

#import "SimpleDPad.h"


@implementation SimpleDPad

-(id)initWithImageNamed:(NSString *)imageName
{
    _radius = 108.8;
    _direction = CGPointZero;
    _isHeld = NO;
    return [self initWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:imageName]];
}

//+(id)dPadWithFile:(NSString *)fileName radius:(float)radius
//{
//    return [[self alloc] initWithFile:fileName radius:radius];
//}
//
//-(id)initWithFile:(NSString *)filename radius:(float)radius
//{
//   // if ((self = [super initWithFile:filename]))
//   // {
//        _radius = radius;
//        _direction = CGPointZero;
//        _isHeld = NO;
//    self.spriteFrame = [CCSpriteFrame frameWithImageNamed:filename];
//       // [self scheduleUpdate];
//    //}
//    return self;
//}

//-(void)onEnterTransitionDidFinish
//{
//    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
//}
//
//-(void) onExit
//{
//    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
//}

-(void)update:(CCTime)dt
{
    if (_isHeld == YES)
    {
        [_delegate simpleDPad:self isHoldingDirection:_direction];
    }
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
   // CGPoint location = [touch locationInNode:self];
    
//    if (location.x > self.spriteFrame.rect.size.width/2)
//        [_delegate simpleDPad:self beganTouchWithDirection:ccp(1.0,0.0)];
//    else if (location.x < self.spriteFrame.rect.size.width/2)
//        [_delegate simpleDPad:self beganTouchWithDirection:ccp(-1.0,0.0)];
//    
//    _isHeld = YES;
//    [self updateDirectionForTouchLocation:location];
    
    float distanceSQ = ccpDistanceSQ(location, _position);
    if (distanceSQ <= _radius * _radius)
    {
        //get angle 8 directions
        _direction = [self directionForTouchLocation:location];
        _isHeld = YES;
        [_delegate simpleDPad:self beganTouchWithDirection:_direction];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    //[self updateDirectionForTouchLocation:location];
    
    _direction = [self directionForTouchLocation:location];
     [_delegate simpleDPad:self didChangeDirectionTo:_direction];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _direction = CGPointZero;
    _isHeld = NO;
    [_delegate simpleDPadTouchEnded:self];
}


-(CGPoint)directionForTouchLocation:(CGPoint)location
{
    float radians = ccpToAngle(ccpSub(location, _position));
    float degrees = -1 * CC_RADIANS_TO_DEGREES(radians);
    
    if (degrees <= 22.5 && degrees >= -22.5)
    {
        //right
        _direction = ccp(1.0, 0.0);
    }
    else if (degrees > 22.5 && degrees < 67.5)
    {
        //bottomright
        _direction = ccp(1.0, -1.0);
    }
    else if (degrees >= 67.5 && degrees <= 112.5)
    {
        //bottom
        _direction = ccp(0.0, -1.0);
    }
    else if (degrees > 112.5 && degrees < 157.5)
    {
        //bottomleft
        _direction = ccp(-1.0, -1.0);
    }
    else if (degrees >= 157.5 || degrees <= -157.5)
    {
        //left
        _direction = ccp(-1.0, 0.0);
    }
    else if (degrees < -22.5 && degrees > -67.5)
    {
        //topright
        _direction = ccp(1.0, 1.0);
    }
    else if (degrees <= -67.5 && degrees >= -112.5)
    {
        //top
        _direction = ccp(0.0, 1.0);
    }
    else if (degrees < -112.5 && degrees > -157.5)
    {
        //topleft
        _direction = ccp(-1.0, 1.0);
    }
    return _direction;
}

@end
