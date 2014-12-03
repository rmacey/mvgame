//
//  GameLevelLayer.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "SimpleDPad.h"
#import "Hud.h"
#import "CCAnimation.h"
#import "OALSimpleAudio.h"
#import "Utility.h"
#import "Inventory.h"

@interface GameLevelLayer : CCScene <HudDelegate, SimpleDPadDelegate>
{
    Hud *hud;
    Inventory *inventory;
}

+ (instancetype)scene;
- (id)init;


@end
