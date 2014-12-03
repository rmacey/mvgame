//
//  Utility.m
//  Metroidvania
//
//  Created by Ryan Macey on 11/2/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(CCSprite *) rectangleSpriteWithSize:(CGSize)cgsize color:(CCColor*) c andOrigin:(CGPoint)origin
{
    CCSprite *sg = [CCSprite spriteWithImageNamed:@"blank.png"];
    [sg setTextureRect:CGRectMake( origin.x, origin.y, cgsize.width, cgsize.height)];
    sg.color = c;
    return sg;
}

+(CGFloat) RadiansToDegrees:(CGFloat) radians
{
    return radians * 180 / M_PI;
}

+(CGFloat) CGPointToDegree:(CGPoint) point
{
    // Provides a directional bearing from (0,0) to the given point.
    // standard cartesian plain coords: X goes up, Y goes right
    // result returns degrees, -180 to 180 ish: 0 degrees = up, -90 = left, 90 = right
    CGFloat bearingRadians = atan2f(point.y, point.x);
    CGFloat bearingDegrees = bearingRadians * (180. / M_PI);
    return bearingDegrees;
}

+(void)drawDebugBox:(CCDrawNode *)node forBoundingBox:(BoundingBox)boundingBox fillColor:(CCColor*)fillColor borderColor:(CCColor *)borderColor
{
    [node clear];
    
    CGPoint verts[4];
    verts[0] = ccp(0.0f, 0.0f);
    verts[1] = ccp(0.0f, boundingBox.actual.size.height);
    verts[2] = ccp(boundingBox.actual.size.width, boundingBox.actual.size.height);
    verts[3] = ccp(boundingBox.actual.size.width, 0.0f);
    
    [node drawPolyWithVerts:verts
                      count:4
                  fillColor:fillColor
                borderWidth:1.0
                borderColor:borderColor];
}


@end
