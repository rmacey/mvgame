//
//  Platform.h
//  Metroidvania
//
//  Created by Ryan Macey on 11/4/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "cocos2d.h"
#import "MovableObject.h"

@interface Platform : MovableObject

//@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint previousPos;
@property (nonatomic, assign) CGFloat distance;

- (id)initWithImageNamed:(NSString *)name forPlatformType:(NSString*)platformType withSpeed:(CGFloat)speed andDistance:(CGFloat)distanceToMove;

- (CGRect)boundingBox;

@end
