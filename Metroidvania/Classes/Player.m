//
//  Player.m
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.
//  Copyright 2012 Interrobang Software LLC. All rights reserved.
//

#import "Player.h"
#import "CCAnimation.h"

@implementation Player

-(id)init
{
    
    self.currentAttackSequence = 0;
    [self initWeapons];
    self.rightItem.groundAttack.attackType = attackTypeGround;
    self.rightItem.groundAttack2.attackType = attackTypeGround;
    self.rightItem.groundAttack3.attackType = attackTypeGround;
    self.rightItem.dashAttack.attackType = attackTypeDash;
    //self.rightItem.dashAttack2.attackType = attackTypeDash;
    self.rightItem.airAttack.attackType = attackTypeAir;
    self.activeAttacks = [[NSMutableArray alloc] init];
    
    self.velocity = ccp(0.0, 0.0);
    self.runSpeed = 3500.0f;
    self.airSpeed = 3000.0f;
    self.groundJumpStrength = 1000.0f;
    self.airJumpStrength = 1000.0f;
    self.weight = 0.0f;
    self.acceleration = 0.0f;
    self.gravityForce = 1500;
    self.friction = 0.90;
    
    self.maxHealth = 100.0;
    self.health = self.maxHealth;
    self.maxMana = 100.0;
    self.mana = self.maxMana;
    self.manaRegen = 0.1;
    self.airJumpMana = 0;
    self.airJumps = 1;
    
    self.XScale = 1.5;
    self.YScale = 1.5;
    self.centerToBottomOriginal = 45;
    self.centerToSidesOriginal = 23;
    self.centerToBottom = self.centerToBottomOriginal;
    self.centerToSides = self.centerToSidesOriginal;
    self.hurtBox = [self createBoundingBoxWithOrigin:ccp(-self.centerToSides, -self.centerToBottom) size:CGSizeMake(self.centerToSides * 2, self.centerToBottom * 2)];
    
    self.movementState = movementStateIdle;
    self.isIntangible = NO;
    
    //safety clamps
    self.maxFallSpeed = -2700.0f;
    self.maxJumpSpeed = 2700.0f;
    self.maxRunSpeed = 2700.0f;
    
    [self prepareAnimations];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                         spriteFrameByName:@"ninjaIdle-1.png"];
  
    if(DISPLAY_DEBUG_HURTBOXES)
    {
        self.debugHurtBox = [[CCDrawNode alloc] init];
        self.debugHurtBox.contentSize = CGSizeMake(self.hurtBox.actual.size.width, self.hurtBox.actual.size.height);
    }
    
    return [self initWithSpriteFrame:initialSpriteFrame];
}

-(void)initWeapons
{
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SimpleSword.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"SimpleSword" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    else
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"SimpleSword" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *itemInfo = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    self.rightItem = [[Weapon alloc] init];
    self.rightItem.name = [itemInfo objectForKey:@"Name"];
    self.rightItem.description = [itemInfo objectForKey:@"Description"];
    self.rightItem.value = [[itemInfo objectForKey:@"Value"] intValue];
    self.rightItem.dashAttackCount = [[itemInfo objectForKey:@"DashAttacks"] count];
    self.rightItem.groundAttackCount = [[itemInfo objectForKey:@"GroundAttacks"] count];
    self.rightItem.airAttackCount = [[itemInfo objectForKey:@"AirAttacks"] count];
    self.rightItem.crouchAttackCount = [[itemInfo objectForKey:@"CrouchAttacks"] count];
    
    NSArray *groundAttacks = [itemInfo objectForKey:@"GroundAttacks"];
    for (int i=0; i<groundAttacks.count; i++)
        [self initAttack:[itemInfo objectForKey:@"GroundAttacks"][i] forItem:self.rightItem withType:@"GroundAttacks" atIndex:i];
    
    NSArray *airAttacks = [itemInfo objectForKey:@"AirAttacks"];
    for (int i=0; i<airAttacks.count; i++)
        [self initAttack:[itemInfo objectForKey:@"AirAttacks"][i] forItem:self.rightItem withType:@"AirAttacks" atIndex:i];
    
    NSArray *dashAttacks = [itemInfo objectForKey:@"DashAttacks"];
    for (int i=0; i<dashAttacks.count; i++)
        [self initAttack:[itemInfo objectForKey:@"DashAttacks"][i] forItem:self.rightItem withType:@"DashAttacks" atIndex:i];
    
    NSArray *crouchAttacks = [itemInfo objectForKey:@"CrouchAttacks"];
    for (int i=0; i<crouchAttacks.count; i++)
        [self initAttack:[itemInfo objectForKey:@"CrouchAttacks"][i] forItem:self.rightItem withType:@"CrouchAttacks" atIndex:i];
}

-(void)initAttack: (NSString *)attackName forItem:(Weapon *)weapon withType:(NSString *)type atIndex:(int)i
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",attackName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:attackName ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    else
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
        NSString *bundle = [[NSBundle mainBundle] pathForResource:attackName ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }

    NSMutableDictionary *attackInfo = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    Attack *attack = [[Attack alloc] init];
    
    if ([type  isEqual: @"GroundAttacks"])
    {
        if(i == 0)
            attack = weapon.groundAttack;
        else if(i == 1)
            attack = weapon.groundAttack2;
        else if(i == 2)
            attack = weapon.groundAttack3;
    }
    else if ([type  isEqual: @"DashAttacks"])
    {
        if(i == 0)
            attack = weapon.dashAttack;
        else if(i == 1)
            attack = weapon.dashAttack2;
        else if(i == 2)
            attack = weapon.dashAttack3;
    }
    else if ([type  isEqual: @"AirAttacks"])
    {
        if(i == 0)
            attack = weapon.airAttack;
        else if(i == 1)
            attack = weapon.airAttack2;
        else if(i == 2)
            attack = weapon.airAttack3;
    }
    else if ([type  isEqual: @"CrouchAttacks"])
    {
        if(i == 0)
            attack = weapon.crouchAttack;
//        else if(i == 1)
//            attack = weapon.crouchAttack2;
//        else if(i == 2)
//            attack = weapon.crouchAttack3;
    }
    
    attack.damage = [[attackInfo objectForKey:@"Damage"] doubleValue];
    attack.knockback = [[attackInfo objectForKey:@"Knockback"] doubleValue];
    attack.stun = [[attackInfo objectForKey:@"Stun"] doubleValue];
    attack.IASA = [[attackInfo objectForKey:@"IASA"] intValue];
    attack.element = [attackInfo objectForKey:@"Element"];
    attack.attackSoundName = [attackInfo objectForKey:@"AttackSoundName"];
    attack.totalPossibleSounds = [[attackInfo objectForKey:@"TotalPossibleSounds"] intValue];
    attack.animationFramesCount = [[attackInfo objectForKey:@"AnimationFramesCount"] intValue];
    attack.animationSpriteName = [attackInfo objectForKey:@"AnimationSpriteName"];
    attack.totalFrames = [[attackInfo objectForKey:@"TotalFrames"] intValue];
    attack.hitBoxTransformations = [attackInfo objectForKey:@"HitBoxTransformations"];
    attack.specialProperties = [attackInfo objectForKey:@"SpecialProperties"];
    attack.ownerSizeAdjustment = [attackInfo objectForKey:@"OwnerSizeAdjustment"];
}

- (void)prepareAnimations
{
    //later on method will take in spriteframes plist. this will add the animations and old animations will be overwritten
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"ninja.plist"];
    
    NSMutableArray *idleFrames = [NSMutableArray array];
    //set up animation for normal horizontal ground movement
    for(int i = 1; i <= 1; i++)
    {
        [idleFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninjaIdle-1.png"]];
    }
    CCAnimation *idleAnimation = [CCAnimation animationWithSpriteFrames: idleFrames delay:0.01f];
    self.idleAction = [CCActionAnimate actionWithAnimation:idleAnimation];
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    //set up animation for normal horizontal ground movement
    float delay = 330 / self.runSpeed; //ratio that gives roughly correct delay between animation frames for any runspeed
    for(int i = 1; i <= 6; ++i)
    {
        [walkFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"ninjaRun-%d.png", i]]];
    }
    CCAnimation *walkAnimation = [CCAnimation animationWithSpriteFrames: walkFrames delay:delay];
    self.runAction = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:walkAnimation]];
    
    NSMutableArray *groundJumpFrames = [NSMutableArray array];
   // [groundJumpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninjaCrouch-1.png"]]];
   // [groundJumpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninjaAirAttack-2.png"]]];
    for(int i=1; i<=1; i++)
    {
        [groundJumpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninjaJump-1.png", i]]];
    }
    CCAnimation *groundJumpAnimation = [CCAnimation animationWithSpriteFrames:groundJumpFrames delay:0.045f];
    self.groundJumpAction = [CCActionRepeat actionWithAction:[CCActionAnimate actionWithAnimation:groundJumpAnimation] times:1];
    
    NSMutableArray *airJumpFrames = [NSMutableArray array];
    for(int i=1; i<=4; i++)
    {
        [airJumpFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninjaSpin-%d.png", i]]];
    }
    CCAnimation *airJumpAnimation = [CCAnimation animationWithSpriteFrames:airJumpFrames delay:0.03f];
    self.airJumpAction = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:airJumpAnimation]];
    
    
    
    NSMutableArray *fallingFrames = [NSMutableArray array];
    for(int i = 1; i <= 1; i++)
    {
        [fallingFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninjaFall.png"]];
    }
    CCAnimation *fallingAnimation = [CCAnimation animationWithSpriteFrames: fallingFrames delay:0.01f];
    self.fallingAction = [CCActionAnimate actionWithAnimation:fallingAnimation];
    
    
    NSMutableArray *crouchFrames = [NSMutableArray array];
    for(int i = 1; i <= 1; i++)
    {
        [crouchFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninjaCrouch-1.png"]];
    }
    CCAnimation *crouchAnimation = [CCAnimation animationWithSpriteFrames: crouchFrames delay:0.03f];
    self.crouchAction = [CCActionAnimate actionWithAnimation:crouchAnimation];
    
    
    NSMutableArray *hurtFrames = [NSMutableArray array];
    for(int i = 1; i <= 1; i++)
    {
        [hurtFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninjaGroundHurt-1.png"]];
    }
    CCAnimation *hurtAnimation = [CCAnimation animationWithSpriteFrames: hurtFrames delay:0.01f];
    self.hurtAction = [CCActionAnimate actionWithAnimation:hurtAnimation];
    
    
    NSMutableArray *groundAttackFrames = [NSMutableArray array];
    for(int i = 1; i <= self.rightItem.groundAttack.animationFramesCount; i++)
    {
        [groundAttackFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-%d.png", self.rightItem.groundAttack.animationSpriteName, i]]];
    }
    CCAnimation *groundAttackAnimation = [CCAnimation animationWithSpriteFrames: groundAttackFrames delay:0.04f];
    self.groundAttackAction = [CCActionAnimate actionWithAnimation:groundAttackAnimation];
    
    NSMutableArray *airAttackFrames = [NSMutableArray array];
    //set up animation for normal horizontal ground movement
    for(int i = 1; i <= 5; i++)
    {
        [airAttackFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninjaAirAttack-%d.png", i]]];
    }
    CCAnimation *airAttackAnimation = [CCAnimation animationWithSpriteFrames: airAttackFrames delay:0.04f];
    self.airAttackAction = [CCActionAnimate actionWithAnimation:airAttackAnimation];
    
    
    NSMutableArray *dashAttackFrames = [NSMutableArray array];
    //set up animation for normal horizontal ground movement
    for(int i = 1; i <= 3; i++)
    {
        [dashAttackFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninjaDashAttack2-%d.png", i]]];
    }
    [dashAttackFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninjaLandLag-1.png"]];
    //[dashAttackFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninjaLandLag-2.png"]];
   // [dashAttackFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninjaStandUp-1.png"]];
    
    CCAnimation *dashAttackAnimation = [CCAnimation animationWithSpriteFrames: dashAttackFrames delay:0.04f];
    self.dashAttackAction = [CCActionAnimate actionWithAnimation:dashAttackAnimation];
    
    if (self.rightItem.dashAttackCount > 1)
    {
        NSMutableArray *dashAttack2Frames = [NSMutableArray array];
        //set up animation for normal horizontal ground movement
        for(int i = 4; i <= 7; i++)
        {
            [dashAttack2Frames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninjaDashAttack-%d.png", i]]];
        }
        CCAnimation *dashAttack2Animation = [CCAnimation animationWithSpriteFrames: dashAttack2Frames delay:0.04f];
        self.dashAttack2Action = [CCActionAnimate actionWithAnimation:dashAttack2Animation];
    }
    if (self.rightItem.groundAttackCount > 1)
    {
        NSMutableArray *groundAttack2Frames = [NSMutableArray array];
        //set up animation for normal horizontal ground movement
        for(int i = 1; i <= self.rightItem.groundAttack2.animationFramesCount; i++)
        {
            [groundAttack2Frames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-%d.png", self.rightItem.groundAttack2.animationSpriteName, i]]];
        }
        CCAnimation *groundAttack2Animation = [CCAnimation animationWithSpriteFrames: groundAttack2Frames delay:0.04f];
        self.groundAttack2Action = [CCActionAnimate actionWithAnimation:groundAttack2Animation];
        
        NSMutableArray *groundAttack3Frames = [NSMutableArray array];
        //set up animation for normal horizontal ground movement
        for(int i = 1; i <= self.rightItem.groundAttack3.animationFramesCount; i++)
        {
            [groundAttack3Frames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-%d.png", self.rightItem.groundAttack3.animationSpriteName, i]]];
        }
        CCAnimation *groundAttack3Animation = [CCAnimation animationWithSpriteFrames: groundAttack3Frames delay:0.04f];
        self.groundAttack3Action = [CCActionAnimate actionWithAnimation:groundAttack3Animation];
    }
    
    NSMutableArray *crouchAttackFrames = [NSMutableArray array];
    //set up animation for normal horizontal ground movement
    for(int i = 4; i <= 3 + self.rightItem.crouchAttack.animationFramesCount; i++)
    {
        [crouchAttackFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-%d.png", self.rightItem.crouchAttack.animationSpriteName, i]]];
    }
    CCAnimation *crouchAttackAnimation = [CCAnimation animationWithSpriteFrames: crouchAttackFrames delay:0.04f];
    self.crouchAttackAction = [CCActionAnimate actionWithAnimation:crouchAttackAnimation];
}

-(void)update:(CCTime)dt
{
    [super update:dt];
    if(self.attackState == attackStateNone)
        self.currentAttackSequence = 0;
    
    if(self.onGround)
        self.currentJumpCount = 0;
    else if (self.velocity.y < -1500 && self.attackState == attackStateNone && self.statusState == statusStateNone && self.currentJumpCount == 0)
    {
        [self stopAllActions];
        [self runAction:self.fallingAction];
    }
    
}

-(Attack *) retrieveAttackForWeapon: (Weapon *)weapon
{
    Attack *retrievedAttack;
    if (self.onGround == TRUE)
    {
        if (self.movementState == movementStateRun)
        {
            if(self.currentAttackSequence == 0)
                retrievedAttack = weapon.dashAttack;
            else if(self.currentAttackSequence == 1)
                retrievedAttack = weapon.dashAttack2;
            else if(self.currentAttackSequence == 2)
                retrievedAttack = weapon.dashAttack3;
        }
        else if (self.statusState == statusStateCrouch && self.noInputFrames == 0)
        {
            retrievedAttack = weapon.crouchAttack;
        }
        else if(self.movementState == movementStateIdle && self.statusState != statusStateCrouch)
        {
            if(self.currentAttackSequence == 0)
                retrievedAttack = weapon.groundAttack;
            else if(self.currentAttackSequence == 1)
                retrievedAttack = weapon.groundAttack2;
            else if(self.currentAttackSequence == 2)
                retrievedAttack = weapon.groundAttack3;
        }
    }
    else if (self.onGround == FALSE && self.noInputFrames == 0)
        retrievedAttack = weapon.airAttack;
    
    Attack *attackCopy = [retrievedAttack mutableCopy];
    return attackCopy;
}

#pragma mark - ACTIONS
-(void)executeRightButtonAction
{
    Attack *attack = [self retrieveAttackForWeapon:self.rightItem];
    if(attack != nil)
        [self executeAttack:attack];
}

-(void)executeLeftButtonAction
{
    //add later for shielding, two-handing etc.
}

-(void)executeJumpButtonAction
{
    if(self.noInputFrames > 0)
        return;
    
    if (self.onGround)
        [self executeGroundJump];
    else if (self.currentJumpCount < self.airJumps && self.mana > self.airJumpMana)
        [self executeAirJump];
}
-(void)executeAttack: (Attack *)attack
{
    if(self.currentAttackSequence > 0)
        [self attackEnded:[self.activeAttacks lastObject]];
    
    [self stopAllActions];
    self.currentAttackSequence++;
    
    [self.activeAttacks addObject:attack];
    [self addChild:attack];
    attack.hitBox = [attack createBoundingBoxWithOrigin:self.position size:CGSizeZero];
    attack.delegate = self;
    self.noInputFrames = attack.totalFrames;
    [attack playSound];

    [self applySpecialPropertiesForAttack:attack];
    
    if(attack.ownerSizeAdjustment.count != 0)
    {
        float adjustXPercentage = [attack.ownerSizeAdjustment[0] floatValue];
        float adjustYPercentage = [attack.ownerSizeAdjustment[1] floatValue];
        
        CGSize newSize = CGSizeMake((self.centerToSidesOriginal*2)*adjustXPercentage, (self.centerToBottomOriginal*2)*adjustYPercentage);
        [self transformSizeTo:newSize];
    }
    else
         [self transformSizeTo:CGSizeMake(self.centerToSidesOriginal*2, self.centerToBottomOriginal*2)];
        
    
    if(attack.attackType == attackTypeGround)
    {
        self.attackState = attackStateGroundAttack;
        
        if(self.currentAttackSequence == 1)
            [self runAction:self.groundAttackAction];
        if(self.currentAttackSequence == 2)
            [self runAction:self.groundAttack2Action];
        if(self.currentAttackSequence == 3)
            [self runAction:self.groundAttack3Action];
    }
    else if(attack.attackType == attackTypeDash)
    {
        self.attackState = attackStateDashAttack;
        
        if(self.currentAttackSequence == 1)
            [self runAction:self.dashAttackAction];
//        if(self.currentAttackSequence == 2)
//            [self runAction:self.dashAttack2Action];
    }
    else if(attack.attackType == attackTypeAir)
    {
        self.attackState = attackStateAirAttack;
        
        if(self.currentAttackSequence == 1)
            [self runAction:self.airAttackAction];
        
        if(self.doubleJumpSound != nil)
        {
            [self.doubleJumpSound stop];
            self.doubleJumpSound = nil;
        }
    }
    else if (self.statusState == statusStateCrouch)
        [self runAction:self.crouchAttackAction];
}

-(void)applySpecialPropertiesForAttack:(Attack *)attack
{
    if ([attack.specialProperties objectForKey:@"HorizontalImpulse"] != nil)
    {
        float impulseX = [[attack.specialProperties objectForKey:@"HorizontalImpulse"] floatValue];
        if(self.velocity.x > 0)
            [self applyImpulse:ccp(impulseX,0)];
        else
            [self applyImpulse:ccp(-impulseX,0)];
    }
    
    if ([attack.specialProperties objectForKey:@"ZeroHorizontalVelocity"] != nil)
    {
        self.velocity = ccp(0,self.velocity.y);
    }
    
    if ([attack.specialProperties objectForKey:@"NoMove"] != nil)
    {
        self.moveLeft = NO;
        self.moveRight = NO;
    }
}


-(void)executeGroundJump
{
    //self.currentJumpCount++;
    self.movementState = movementStateJump;
    [self stopAllActions];
    [self runAction:self.groundJumpAction];
    [self applyImpulse:ccp(0.0,self.groundJumpStrength)];
    self.noInputFrames = 4;
    [self transformSizeTo:CGSizeMake(self.centerToSidesOriginal*2, self.centerToBottomOriginal*1.8)];
}
-(void)executeAirJump
{
    self.currentJumpCount++;
    self.movementState = movementStateJump;
    [self stopAllActions];
    [self runAction:self.airJumpAction];
    self.velocity = ccp(self.velocity.x, 0.0);
    self.doubleJumpSound = [[OALSimpleAudio sharedInstance] playEffect:@"SpinningLoop.wav" volume:0.8 pitch:1.0 pan:0.0 loop:YES];
    [self applyImpulse:ccp(0.0,self.airJumpStrength)];
    self.mana -= self.airJumpMana;
    self.noInputFrames = 6;
    
    
    
    CGSize newSize = CGSizeMake((self.centerToSidesOriginal*2), (self.centerToBottomOriginal*2)*0.5);
    [self transformSizeTo:newSize];
   // [self transformSizeTo:CGSizeMake(40, 40)];
}
-(void)landingDetectedWithYVelocity:(float)velocity
{
    [super landingDetectedWithYVelocity:velocity];
    [self stopAllActions];
    
     [self transformSizeTo:CGSizeMake(self.centerToSidesOriginal*2, self.centerToBottomOriginal*2)];
    
    if(self.doubleJumpSound != nil)
    {
        [self.doubleJumpSound stop];
        self.doubleJumpSound = nil;
    }
    
//    if (velocity < -5000)
//        [self hurtWithDamage:velocity/10 andStun:velocity/100];
    if(velocity < -1500)
        [[OALSimpleAudio sharedInstance] playEffect:@"land-2.wav"];
    else if(velocity < -100)
        [[OALSimpleAudio sharedInstance] playEffect:@"land-1.wav"];
    
}

-(void)playRunningSound
{

}

-(void)death
{
 //   [super death];
    self.statusState = statusStateDeath;
    self.isIntangible = YES;
    self.noInputFrames = 50;
    self.velocity = ccp(0.0,0.0);
    self.desiredPosition = self.position;
    [[OALSimpleAudio sharedInstance] playEffect:@"playerDeath.mp3"];
    
    self.health = self.maxHealth;
}

@end
