//
//  Ghost.h
//  Metroidvania
//
//  Created by Ryan Macey on 6/2/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "ActionSprite.h"

@interface Ghost : ActionSprite

@property(nonatomic, assign)int stepTimer;

@property(nonatomic,strong)id disappearAction;
@property(nonatomic,strong)id appearAction;


@end
