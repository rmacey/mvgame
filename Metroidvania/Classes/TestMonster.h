//
//  TestMonster.h
//  Metroidvania
//
//  Created by Ryan Macey on 6/2/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "ActionSprite.h"

@interface TestMonster : ActionSprite

-(void)reverseDirection;
@property(nonatomic, assign)int stepTimer;

@end
