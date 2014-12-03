//
//  Weapon.m
//  Metroidvania
//
//  Created by Ryan Macey on 10/22/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon

-(id)init
{
    [self initAttacks];
    
    return self;
}

-(void)initAttacks
{
    self.groundAttack = [[Attack alloc] init];
    self.groundAttack2 = [[Attack alloc] init];
    self.groundAttack3 = [[Attack alloc] init];
    self.dashAttack = [[Attack alloc] init];
    //self.dashAttack2 = [[Attack alloc] init];
    self.airAttack = [[Attack alloc] init];
    
    self.crouchAttack = [[Attack alloc] init];
}

@end
