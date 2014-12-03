//
//  Weapon.h
//  Metroidvania
//
//  Created by Ryan Macey on 10/22/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attack.h"
#import "Item.h"

@interface Weapon : Item

@property(nonatomic,assign)int airAttackCount;
@property(nonatomic,retain)Attack *airAttack;
@property(nonatomic,retain)Attack *airAttack2;
@property(nonatomic,retain)Attack *airAttack3;

@property(nonatomic,assign)int dashAttackCount;
@property(nonatomic,retain)Attack *dashAttack;
@property(nonatomic,retain)Attack *dashAttack2;
@property(nonatomic,retain)Attack *dashAttack3;

@property(nonatomic,assign)int groundAttackCount;
@property(nonatomic,retain)Attack *groundAttack;
@property(nonatomic,retain)Attack *groundAttack2;
@property(nonatomic,retain)Attack *groundAttack3;

@property(nonatomic,assign)int crouchAttackCount;
@property(nonatomic,retain)Attack *crouchAttack;


@end
