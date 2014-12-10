//
//  Inventory.m
//  Metroidvania
//
//  Created by Ryan Macey on 12/2/14.
//  Copyright 2014 Ryan Macey. All rights reserved.
//

#import "Inventory.h"


@implementation Inventory

- (id) init
{
    if (self = [super init])
    {
        self.contentSize = [self.parent contentSize];
        
        self.userInteractionEnabled = TRUE;
        [self setMultipleTouchEnabled:YES];
        
        // Use 	CCLayoutBox to replicate the menu layout feature
        self.menuBox = [[CCLayoutBox alloc] init];
        
        // Have to set up direction and spacing before adding children
        self.menuBox.direction = CCLayoutBoxDirectionHorizontal;
        self.menuBox.spacing = 80.0f;
        self.menuBox.position = ccp(535,405);
        self.menuBox.contentSize = CGSizeMake(640,700);
        self.menuBox.anchorPoint = ccp(0.5f,0.5f);
        self.menuBox.opacity = 0.0f;
        self.menuBox.cascadeColorEnabled = YES;
        self.menuBox.cascadeOpacityEnabled = YES;
        
        
        [self addBackground];
        [self addButtons];
        
        [self addChild:self.menuBox];
    }
    return self;
}

-(void)addBackground
{
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"inventoryBackground1.png"];
    //bg.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerTopLeft);
    bg.anchorPoint = ccp(0.5f,0.5f);
    bg.position = ccp(530,400);
    [self addChild:bg];
}
-(void)addButtons
{ //add the buttons. note that they are added in reverse order as new go above old
    
    //slot names
    CCLayoutBox *slotNamesBox = [[CCLayoutBox alloc] init];
    slotNamesBox.direction = CCLayoutBoxDirectionVertical;
    slotNamesBox.spacing = 28;
    slotNamesBox.anchorPoint= ccp(0.5f,0.5f);
    
    CCLabelTTF *consumablesLabel = [CCLabelTTF labelWithString:@"Consumables" fontName:@"UraniaSerif" fontSize:24.0f];
    consumablesLabel.color = [CCColor grayColor];
    [slotNamesBox addChild:consumablesLabel];
    
    CCLabelTTF *trinket3label = [CCLabelTTF labelWithString:@"Trinket 3" fontName:@"UraniaSerif" fontSize:24.0f];
    trinket3label.color = [CCColor grayColor];
    [slotNamesBox addChild:trinket3label];
    
    CCLabelTTF *trinket2label = [CCLabelTTF labelWithString:@"Trinket 2" fontName:@"UraniaSerif" fontSize:24.0f];
    trinket2label.color = [CCColor grayColor];
    [slotNamesBox addChild:trinket2label];
    
    CCLabelTTF *trinket1label = [CCLabelTTF labelWithString:@"Trinket 1" fontName:@"UraniaSerif" fontSize:24.0f];
    trinket1label.color = [CCColor grayColor];
    [slotNamesBox addChild:trinket1label];
    
    CCLabelTTF *feetLabel = [CCLabelTTF labelWithString:@"Feet" fontName:@"UraniaSerif" fontSize:24.0f];
    feetLabel.color = [CCColor grayColor];
    [slotNamesBox addChild:feetLabel];
    
    CCLabelTTF *handsLabel = [CCLabelTTF labelWithString:@"Hands" fontName:@"UraniaSerif" fontSize:24.0f];
    handsLabel.color = [CCColor grayColor];
    [slotNamesBox addChild:handsLabel];
    
    CCLabelTTF *armorLabel = [CCLabelTTF labelWithString:@"Armor" fontName:@"UraniaSerif" fontSize:24.0f];
    armorLabel.color = [CCColor grayColor];
    [slotNamesBox addChild:armorLabel];
    
    CCLabelTTF *headLabel = [CCLabelTTF labelWithString:@"Head" fontName:@"UraniaSerif" fontSize:24.0f];
    headLabel.color = [CCColor grayColor];
    [slotNamesBox addChild:headLabel];

    CCLabelTTF *leftWeaponLabel = [CCLabelTTF labelWithString:@"Left Weapon" fontName:@"UraniaSerif" fontSize:24.0f];
    leftWeaponLabel.color = [CCColor grayColor];
    [slotNamesBox addChild:leftWeaponLabel];
    
    CCLabelTTF *rightWeaponLabel = [CCLabelTTF labelWithString:@"Right Weapon" fontName:@"UraniaSerif" fontSize:24.0f];
    rightWeaponLabel.color = [CCColor grayColor];
    [slotNamesBox addChild:rightWeaponLabel];
    
    [self.menuBox addChild:slotNamesBox];
    
    
    
    //actual item names
    CCLayoutBox *itemNamesBox = [[CCLayoutBox alloc] init];
    itemNamesBox.direction = CCLayoutBoxDirectionVertical;
    itemNamesBox.spacing = 28;
    itemNamesBox.anchorPoint= ccp(0.5f,0.5f);
    
    CCLabelTTF *consumablesName = [CCLabelTTF labelWithString:@"--" fontName:@"UraniaSerif" fontSize:24.0f];
    consumablesName.color = [CCColor whiteColor];
    [itemNamesBox addChild:consumablesName];
    
    CCLabelTTF *trinket3name = [CCLabelTTF labelWithString:@"--" fontName:@"UraniaSerif" fontSize:24.0f];
    trinket3name.color = [CCColor whiteColor];
    [itemNamesBox addChild:trinket3name];
    
    CCLabelTTF *trinket2name = [CCLabelTTF labelWithString:@"--" fontName:@"UraniaSerif" fontSize:24.0f];
    trinket2name.color = [CCColor whiteColor];
    [itemNamesBox addChild:trinket2name];
    
    CCLabelTTF *trinket1name = [CCLabelTTF labelWithString:@"--" fontName:@"UraniaSerif" fontSize:24.0f];
    trinket1name.color = [CCColor whiteColor];
    [itemNamesBox addChild:trinket1name];
    
    CCLabelTTF *feetName = [CCLabelTTF labelWithString:@"Ninja Test Foot Wrappings" fontName:@"UraniaSerif" fontSize:24.0f];
    feetName.color = [CCColor whiteColor];
    [itemNamesBox addChild:feetName];
    
    CCLabelTTF *handsName = [CCLabelTTF labelWithString:@"Ninja Test Gloves" fontName:@"UraniaSerif" fontSize:24.0f];
    handsName.color = [CCColor whiteColor];
    [itemNamesBox addChild:handsName];
    
    CCLabelTTF *armorName = [CCLabelTTF labelWithString:@"Ninja Test Robe" fontName:@"UraniaSerif" fontSize:24.0f];
    armorName.color = [CCColor whiteColor];
    [itemNamesBox addChild:armorName];
    
    CCLabelTTF *headName = [CCLabelTTF labelWithString:@"Ninja Test Mask" fontName:@"UraniaSerif" fontSize:24.0f];
    headName.color = [CCColor whiteColor];
    [itemNamesBox addChild:headName];
    
    CCLabelTTF *leftWeaponName = [CCLabelTTF labelWithString:@"(Test Sword)" fontName:@"UraniaSerif" fontSize:24.0f];
    leftWeaponName.color = [CCColor whiteColor];
    [itemNamesBox addChild:leftWeaponName];
    
    CCLabelTTF *rightWeaponName = [CCLabelTTF labelWithString:@"Test Sword" fontName:@"UraniaSerif" fontSize:24.0f];
    rightWeaponName.color = [CCColor whiteColor];
    [itemNamesBox addChild:rightWeaponName];
    
    [self.menuBox addChild:itemNamesBox];
}

- (void)updateLabel:(CCLabelTTF *)label withValue:(NSString *)value
{
    label.string = value;
}


@end
