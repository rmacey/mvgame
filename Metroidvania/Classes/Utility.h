//
//  Utility.h
//  Metroidvania
//
//  Created by Ryan Macey on 11/2/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Utility : NSObject

+(CCSprite *) rectangleSpriteWithSize:(CGSize)cgsize color:(CCColor*) c andOrigin:(CGPoint)origin;
+(CGFloat) RadiansToDegrees:(CGFloat) radians;
+(CGFloat) CGPointToDegree:(CGPoint) point;

+(void)drawDebugBox:(CCDrawNode *)node forBoundingBox:(BoundingBox)boundingBox fillColor:(CCColor*)fillColor borderColor:(CCColor *)borderColor;

@end
