//
//  Inventory.h
//  Metroidvania
//
//  Created by Ryan Macey on 12/2/14.
//  Copyright 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Item.h"
#import "Weapon.h"


@class Inventory;

@interface Inventory : CCNode {
    
}

@property(nonatomic,retain)NSMutableArray *weapons;
@property(nonatomic,retain)NSMutableArray *helms;
@property(nonatomic,retain)NSMutableArray *chestpieces;
@property(nonatomic,retain)NSMutableArray *gloves;
@property(nonatomic,retain)NSMutableArray *boots;
@property(nonatomic,retain)NSMutableArray *trinkets;

@property(nonatomic,retain)NSMutableArray *consumables;

@property(nonatomic,retain) Weapon *equippedRightWeapon;
@property(nonatomic,retain) Weapon *equippedLeftWeapon;
@property(nonatomic,retain) Item *equippedHelm;
@property(nonatomic,retain) Item *equippedChestpiece;
@property(nonatomic,retain) Item *equippedGloves;
@property(nonatomic,retain) Item *equippedBoots;
@property(nonatomic,retain) Item *equippedTrinket1;
@property(nonatomic,retain) Item *equippedTrinket2;
@property(nonatomic,retain) Item *equippedTrinket3;

@property (nonatomic, retain)CCLabelTTF *testLabel;

@property(nonatomic,retain)CCLayoutBox *menuBox;

-(void)updateLabel:(CCLabelTTF *)label withValue:(NSString *)value;


@end
