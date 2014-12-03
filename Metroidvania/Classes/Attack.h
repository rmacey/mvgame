//
//  Attack.h
//  Metroidvania
//
//  Created by Ryan Macey on 10/15/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Utility.h"

@class Attack;

@protocol AttackDelegate <NSObject>
-(void)attackEnded:(Attack *)attack;
@end

@interface Attack : CCNode <NSMutableCopying>

@property(nonatomic,assign)BoundingBox hitBox;
@property(nonatomic,strong)CCDrawNode *debugHitBox;

@property(nonatomic,assign)double knockback;
@property(nonatomic,assign)double damage;
@property(nonatomic,assign)double stun;
@property(nonatomic,assign)BOOL isPlayerAttack;

@property(nonatomic,assign)int totalFrames; //total frames of the attack before initiator becomes idle again
@property(nonatomic,assign)int IASA; //interruptable-as-soon-as: first frame (out of total) that the attack can be interrupted by new input
@property(nonatomic,assign)NSString *element;
@property(nonatomic,retain)NSString *attackSoundName;
@property(nonatomic,retain)NSString *animationSpriteName;

@property(nonatomic,assign)int animationFramesCount;
@property(nonatomic,assign)int totalPossibleSounds;
@property(nonatomic,assign)int currentFrame;

@property(nonatomic,assign)AttackType *attackType;
@property(nonatomic,retain)NSMutableDictionary *hitBoxTransformations;
@property(nonatomic,retain)NSMutableDictionary *specialProperties;
@property(nonatomic,retain)NSMutableArray *ownerSizeAdjustment;

-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size;

@property(nonatomic,weak)id <AttackDelegate> delegate;

-(void)playSound;
-(void)applySpecialProperties;


@end
