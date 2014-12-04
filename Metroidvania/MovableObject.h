//
//  MovableObject.h
//  Metroidvania
//
//  Created by Ryan Macey on 12/4/14.
//  Copyright 2014 Ryan Macey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MovableObject : CCNode {
    
}

//collision boxes
//@property(nonatomic,assign)BoundingBox hurtBox;
//@property(nonatomic,strong)CCDrawNode *debugHurtBox;


@property(nonatomic,assign)CGPoint velocity;
@property(nonatomic,assign)CGPoint desiredPosition;
@property(nonatomic, assign)double friction;
@property(nonatomic, assign)double gravityForce;

@property(nonatomic,assign) BOOL moveRight;
@property(nonatomic,assign) BOOL moveLeft;
@property(nonatomic,assign) BOOL obeysGravity;
@property(nonatomic,assign) BOOL obeysFriction;
@property(nonatomic,assign) BOOL collidable;

-(void)moveWithSpeed:(double)speed andTime:(CCTime)dt;
-(void)applyImpulseWithKnockback:(float)knockback andDirection:(float)direction;
-(void)applyImpulse: (CGPoint)impulse;

//-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size;


@end
