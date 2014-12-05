//
//  Attack.m
//  Metroidvania
//
//  Created by Ryan Macey on 10/15/14.
//  Copyright (c) 2014 Ryan Macey. All rights reserved.
//

#import "Attack.h"

@implementation Attack

-(id)init
{
    self.knockback = 0.0;
    self.damage = 0.0;
    self.stun = 0.0;
    self.isPlayerAttack = NO;
    self.totalFrames = 0;
    self.element = @"";
    self.attackSoundName = @"";
    self.animationSpriteName = @"";
    self.animationFramesCount = 0;
    self.totalPossibleSounds = 0;
    self.currentFrame = 0;
    self.attackType = attackTypeNone;
    self.hitBoxTransformations = [[NSMutableDictionary alloc] init];
    self.specialProperties = [[NSMutableDictionary alloc] init];
    self.ownerSizeAdjustment = [[NSMutableArray alloc] init];

    if(DISPLAY_DEBUG_HURTBOXES)
    {
        self.debugHitBox = [[CCDrawNode alloc] init];
        self.debugHitBox.contentSize = CGSizeMake(self.hitBox.actual.size.width, self.hitBox.actual.size.height);
    }
    
    return self;
}


-(id)mutableCopyWithZone:(NSZone *)zone
{
    Attack *copy = [[Attack allocWithZone:zone] init];
    copy.knockback = self.knockback;
    copy.damage = self.damage;
    copy.stun = self.stun;
    copy.isPlayerAttack = self.isPlayerAttack;
    copy.totalFrames = self.totalFrames;
   
    copy.attackSoundName = self.attackSoundName;
    copy.animationSpriteName = self.animationSpriteName;
    copy.animationFramesCount = self.animationFramesCount;
    copy.totalPossibleSounds = self.totalPossibleSounds;
    copy.currentFrame = self.currentFrame;
    copy.attackType = self.attackType;
    copy.hitBoxTransformations = [NSMutableDictionary dictionaryWithDictionary:self.hitBoxTransformations];
    copy.specialProperties = [NSMutableDictionary  dictionaryWithDictionary:self.specialProperties];
    copy.ownerSizeAdjustment = [NSMutableArray arrayWithArray:self.ownerSizeAdjustment];
   
    return copy;
}

-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size
{
    BoundingBox boundingBox;
    boundingBox.original.origin = origin;
    boundingBox.original.size = size;

    boundingBox.actual.origin = ccpAdd(_parent.position, ccp(boundingBox.original.origin.x, boundingBox.original.origin.y));
    boundingBox.actual.size = size;
    return boundingBox;
}

-(void)update:(CCTime)dt
{
    if(self.currentFrame == 0)
        self.hitBox = [self createBoundingBoxWithOrigin:CGPointZero size:CGSizeZero];

    NSEnumerator *enumerator = [self.hitBoxTransformations keyEnumerator];
    for(NSString *key in enumerator)
    {
        if(self.currentFrame == [key intValue])
            [self adjustHitboxForFrame:key];
    }
    
    [self transformActualHitbox];
    
    self.currentFrame++;
    
    if(self.currentFrame == self.totalFrames)
    {
        [_delegate attackEnded:self];
    }
}

-(void)adjustHitboxForFrame:(NSString *)key
{
    NSArray *newPositionInfo = [self.hitBoxTransformations objectForKey:key];
    NSArray *moveByInfo = newPositionInfo[0];
    int moveX = [moveByInfo[0] intValue];
    int moveY = [moveByInfo[1] intValue];
    CGPoint moveBy = ccp(moveX, moveY);
    _hitBox.original.origin = ccpAdd(moveBy, _hitBox.original.origin);
    
    NSArray *newSizeInfo = newPositionInfo[1];
    int sizeX = [newSizeInfo[0] intValue];
    int sizeY = [newSizeInfo[1] intValue];
    _hitBox.original.size = CGSizeMake(sizeX, sizeY);
    
    //NSLog(@"hitbox Moved");
}
-(void)transformActualHitbox
{
    CCSprite *owner = self.delegate;
    _hitBox.actual.origin = ccpAdd(owner.position, ccp(_hitBox.original.origin.x * owner.scaleX, _hitBox.original.origin.y * owner.scaleY));
    _hitBox.actual.size = CGSizeMake(_hitBox.original.size.width * owner.scaleX, _hitBox.original.size.height * owner.scaleY);
}
-(void)playSound
{
    int randomSound = random_range(1, self.totalPossibleSounds);
    [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%@-%d.wav", self.attackSoundName, randomSound]];
}
-(void)applySpecialProperties
{

}


@end
