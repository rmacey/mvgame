//
//  Player.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.
//  Copyright 2012 Interrobang Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ActionSprite.h"
#import "Item.h"
#import "Weapon.h"
#import "Inventory.h"

@interface Player : ActionSprite
{

}

@property(nonatomic,assign) int currentAttackSequence;
@property(nonatomic,assign) int currentJumpCount;
@property(nonatomic,assign) int airJumpMana;

-(void)executeRightButtonAction;
-(void)executeLeftButtonAction;
-(void)executeJumpButtonAction;

@property(nonatomic,retain)Weapon *rightItem;
@property(nonatomic,retain)Weapon *leftItem;




@property (nonatomic, strong) id<ALSoundSource> doubleJumpSound;
@property (nonatomic, strong) id<ALSoundSource> runningSound;

@property(nonatomic,retain) Inventory *inventory;


@end
