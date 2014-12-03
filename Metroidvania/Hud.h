//
//  Hud.h
//  Metroidvania
//
//  Created by Ryan Macey on 4/23/14.
//  Copyright 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "SimpleDPad.h"

@class Hud;

@protocol HudDelegate <NSObject>
-(void)hud:(Hud *)hud isHoldingButton:(NSString*)buttonName WithDirection:(CGPoint)direction;
-(void)controlTouchEnded:(Hud *)hud;
@end


@interface Hud : CCNode
{
    CGPoint _direction;
}

@property (nonatomic, weak)id <HudDelegate> delegate;

//player action controls
@property (nonatomic, retain)CCSprite *rightButton;
@property (nonatomic, retain)CCSprite *leftButton;
@property (nonatomic, retain)CCSprite *jumpButton;
@property (nonatomic, retain)SimpleDPad *dPad;

@property (nonatomic, retain)CCSprite *debugButton;

//interface labels
@property (nonatomic, retain)CCLabelTTF *testLabel;

@property (nonatomic, retain)CCSprite *statusBars;
@property (nonatomic, retain)CCProgressNode *healthBar;
@property (nonatomic, retain)CCProgressNode *energyBar;
@property (nonatomic, retain)CCProgressNode *manaBar;


-(void)updateLabel:(CCLabelTTF *)label withValue:(NSString *)value;
-(void)updateBar:(CCProgressNode*)bar ToPercentage: (double)perc;

@end
