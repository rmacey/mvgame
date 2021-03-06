//
//  Hud.m
//  Metroidvania
//
//  Created by Ryan Macey on 4/23/14.
//  Copyright 2014 Ryan Macey. All rights reserved.
//

#import "Hud.h"
#import "Player.h"

@implementation Hud

- (id) init
{
    if (self = [super init])
    {
        self.contentSize = [self.parent contentSize];
        
        self.userInteractionEnabled = TRUE;
        [self setMultipleTouchEnabled:YES];

        _direction = CGPointZero;
        
        
        _dPad = [[SimpleDPad alloc] initWithImageNamed:@"pd_dpad-hd.png"];
        //_dPad = [SimpleDPad dPadWithFile:@"pd_dpad-hd.png" radius:110];
        _dPad.scale = 1.7f;
        _rightButton.anchorPoint = ccp(0,0);
        _dPad.position = ccp(108.8, 108.8);
        _dPad.opacity = .50;
        _dPad.userInteractionEnabled = YES;
        [self addChild:_dPad];
        
        CCSpriteFrame *buttonSpriteFrame = [CCSpriteFrame frameWithImageNamed:@"button.png"];
        _rightButton = [CCSprite spriteWithSpriteFrame:buttonSpriteFrame];
        _rightButton.scale = 0.7f;
        _rightButton.anchorPoint = ccp(0,0);
        _rightButton.position = ccp(922, 107);
        _rightButton.userInteractionEnabled = YES;
         _rightButton.opacity = .50;
        [self addChild:_rightButton];
        

        _leftButton = [CCSprite spriteWithSpriteFrame:buttonSpriteFrame];
        _leftButton.scale = 0.7f;
        _leftButton.anchorPoint = ccp(0,0);
        _leftButton.position = ccp(827, 107);
        _leftButton.userInteractionEnabled = YES;
         _leftButton.opacity = .50;
        [self addChild:_leftButton];
        
        

        _jumpButton = [CCSprite spriteWithSpriteFrame:buttonSpriteFrame];
        _jumpButton.scale = 0.7f;
        _jumpButton.anchorPoint = ccp(0,0);
        _jumpButton.position = ccp(875, 17);
        _jumpButton.userInteractionEnabled = YES;
        _jumpButton.opacity = .50;
        [self addChild:_jumpButton];
        
        _debugButton = [CCSprite spriteWithSpriteFrame:buttonSpriteFrame];
        _debugButton.scale = 0.4f;
        _debugButton.anchorPoint = ccp(0,0);
        _debugButton.position = ccp(880, 400);
        _debugButton.userInteractionEnabled = YES;
        _debugButton.opacity = 50;
        //[self addChild:_debugButton];
        
        self.testLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:24.0f];
        self.testLabel.anchorPoint = ccp(0,0);
        self.testLabel.position = ccp(450,725);
        self.testLabel.color = [CCColor greenColor];
        [self addChild:self.testLabel];
        
        
//        self.statusBars = [CCSprite spriteWithImageNamed:@"statusBars.png"];
//        self.statusBars = [[CCSprite alloc] init];
//        self.statusBars.anchorPoint = ccp(0,0);
//        self.statusBars.scale = 1.6;
//        self.statusBars.position = ccp(200,600);
//        [self addChild:self.statusBars];
        
        CCSprite *healthBarSprite = [CCSprite spriteWithImageNamed:@"healthBar.png"];
        _healthBar = [CCProgressNode progressWithSprite:healthBarSprite];
        _healthBar.type = CCProgressNodeTypeBar;
        _healthBar.midpoint = ccp(0,0);
        _healthBar.barChangeRate = ccp(1, 0);
        //_healthBar.positionType = CCPositionTypeNormalized;
        //_healthBar.position = ccp(0.613f, 0.795f);
        
        _healthBar.scale = 2.5;
        _healthBar.position = ccp(135, 750);
        [self addChild:_healthBar];
        
        
        CCSprite *energyBarSprite = [CCSprite spriteWithImageNamed:@"energyBar.png"];
        _energyBar = [CCProgressNode progressWithSprite:energyBarSprite];
        _energyBar.type = CCProgressNodeTypeBar;
        _energyBar.midpoint = ccp(0,0);
        _energyBar.barChangeRate = ccp(1, 0);
        //_energyBar.positionType = CCPositionTypeNormalized;
        //_energyBar.position = ccp(0.613f, 0.5f);
        
        _energyBar.scale = 2.5;
        _energyBar.position = ccp(135, 720);
        [self addChild:_energyBar];
        
        CCSprite *manaBarSprite = [CCSprite spriteWithImageNamed:@"manaBar.png"];
        _manaBar = [CCProgressNode progressWithSprite:manaBarSprite];
        _manaBar.type = CCProgressNodeTypeBar;
        _manaBar.midpoint = ccp(0,0);
        _manaBar.barChangeRate = ccp(1, 0);
        //_manaBar.positionType = CCPositionTypeNormalized;
        //_manaBar.position = ccp(0.613f, 0.205f);
        
        _manaBar.scale = 2.5;
        _manaBar.position = ccp(135, 690);
        [self addChild:_manaBar];
    }
    
    return self;
}

- (void)updateLabel:(CCLabelTTF *)label withValue:(NSString *)value
{
    label.string = value;
}

-(void)updateBar:(CCProgressNode*)bar ToPercentage: (double)perc
{
    bar.percentage = perc*100;
}

@end
