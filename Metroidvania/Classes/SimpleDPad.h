//
//  SimpleDPad.h
//  PompaDroid
//
//  Created by Allen Benson G Tan on 10/21/12.
//  Copyright 2012 WhiteWidget Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SimpleDPad;

@protocol SimpleDPadDelegate <NSObject>

-(void)simpleDPad:(SimpleDPad *)simpleDPad didChangeDirectionTo:(CGPoint)direction;
-(void)simpleDPad:(SimpleDPad *)simpleDPad isHoldingDirection:(CGPoint)direction;
-(void)simpleDPadTouchEnded:(SimpleDPad *)simpleDPad;
-(void)simpleDPad:(SimpleDPad *)simpleDPad beganTouchWithDirection:(CGPoint)direction;

@end


@interface SimpleDPad : CCSprite {
    CGPoint _direction;
    float _radius;
}

@property(nonatomic,weak)id <SimpleDPadDelegate> delegate;
@property(nonatomic,assign)BOOL isHeld;

+(id)dPadWithFile:(NSString *)fileName radius:(float)radius;
-(id)initWithFile:(NSString *)filename radius:(float)radius;

@end
