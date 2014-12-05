//
//  GameLevelLayer.m
//  Metroidvania
//
//  Created by Jacob Gundersen on 6/4/12.


#import "GameLevelLayer.h"
#import "Player.h"
#import "Torizo.h"
#import "Ghost.h"
#import "Platform.h"

@interface GameLevelLayer()
{
    CCTiledMap *map;
    Player *player;
    CCTiledMapLayer *walls;
    CCTiledMapLayer *meta;
    CCTiledMapLayer *foreground;
    CCTiledMapObjectGroup *enemySpawnPoints;
    CCTiledMapObjectGroup *platformSpawnPoints;
    CCTiledMapObjectGroup *mapTransitions;
    CGPoint entrancePoint;
    
    NSMutableArray *exits;
    NSMutableArray *activeEnemies;
    NSMutableArray *activeAttacks;
    NSMutableArray *activePlatforms;
    
    CCParallaxNode *parallaxBackground;
}

@end

@implementation GameLevelLayer

+(GameLevelLayer *) scene
{
	return [[self alloc] init];
}

-(id) init
{
	if( (self=[super init]) )
    {
        [self preloadAudio];
        self.userInteractionEnabled = TRUE;
        [self setMultipleTouchEnabled:YES];
        
        
        hud = [Hud node];
        [self addChild:hud z:99];
        hud.delegate = self;
        hud.dPad.delegate = self;
        hud.multipleTouchEnabled = YES;
        
        inventory = [Inventory node];
        
        player = [[Player alloc] init];
        player.scaleX = player.XScale;
        player.scaleY = player.YScale;
        entrancePoint = ccp(18*32,88*32);
        
        activeEnemies = [[NSMutableArray alloc] init];
        [self loadMapNamed:@"CryptShaft.tmx" withEntrancePoint:entrancePoint];
        
        [hud updateBar:hud.healthBar ToPercentage:player.health/player.maxHealth];
        [hud updateBar:hud.energyBar ToPercentage:1];
        [hud updateBar:hud.manaBar ToPercentage:player.mana/player.maxMana];
        
	}
	return self;
}
-(void)preloadAudio
{
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MutedStep-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MutedStep-2.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MutedStep-3.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MutedStep-4.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MutedStep-5.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MutedStep-6.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MonsterStep-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MonsterStep-2.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MonsterStep-3.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"SwordWhoosh-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"SwordWhoosh-2.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"SwordWhoosh-3.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"SwordWhoosh-4.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"jump-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"hurt-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerDeath-1.mp3"];
    [[OALSimpleAudio sharedInstance] preloadBg:@"sizzle-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"land-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadBg:@"land-2.wav"];
    [[OALSimpleAudio sharedInstance] preloadBg:@"slice-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadBg:@"menu-move2.mp3"];
}

-(void)loadMapNamed:(NSString *)mapName withEntrancePoint:(CGPoint)entrance
{
    if(map != nil)
    {
        [map removeAllChildrenWithCleanup:YES];
        [self removeChild:map cleanup:YES];
        map = nil;
    }
    
    
    
    map = [CCTiledMap tiledMapWithFile:mapName];
//    [self addChild:map];
    
    //map.scale = 1.5;
    
    walls = [map layerNamed:@"Walls"];
    meta = [map layerNamed:@"Meta"];
    meta.visible = NO;
    
    //set foreground zOrder to 98, just under HUD at 99. this ensures it will be in front of the player
    foreground = [map layerNamed:@"Foreground"];
    foreground.zOrder = 98;
    
    enemySpawnPoints = [map objectGroupNamed:@"EnemySpawn"];
    mapTransitions = [map objectGroupNamed:@"MapTransitions"];
    exits = mapTransitions.objects;
    
    [map addChild:player z:15];
    
    player.position = entrance;
    player.desiredPosition = entrance;
    
    [self loadEnemies];
    [self loadPlatforms];
    
    if(DISPLAY_DEBUG_HURTBOXES)
    {
        [map addChild:player.debugHurtBox];
        
        for(ActionSprite *enemy in activeEnemies)
            [map addChild:enemy.debugHurtBox];
    }
    
    [self addChild:map];
}

-(void)loadEnemies
{
    [activeEnemies removeAllObjects];
    
    NSDictionary *spawnPoint = [enemySpawnPoints objectNamed:@"EnemySpawn"];
    for (spawnPoint in [enemySpawnPoints objects])
    {
        int monsterType = [[spawnPoint valueForKey:@"Monster"] intValue];
        if (monsterType == 1)
        {
            Torizo *monster = [[Torizo alloc] init];
            monster.scaleX = monster.XScale;
            monster.scaleY = monster.YScale;
            CGFloat x = [spawnPoint[@"x"] floatValue];
            CGFloat y = [spawnPoint[@"y"] floatValue];
            [map addChild:monster z:15];
            monster.position = ccp(x,y);
            monster.moveRight = YES;
            [monster runAction:monster.runAction];
            [activeEnemies addObject:monster];
        }
        else if (monsterType == 2)
        {
            Ghost *ghost = [[Ghost alloc] init];
            ghost.scaleX = ghost.XScale;
            ghost.scaleY = ghost.YScale;
            CGFloat x = [spawnPoint[@"x"] floatValue];
            CGFloat y = [spawnPoint[@"y"] floatValue];
            [map addChild:ghost z:15];
            ghost.position = ccp(x,y);
            [activeEnemies addObject:ghost];
        }
    }
}
- (void)loadPlatforms
{
    [activePlatforms removeAllObjects];
    
    platformSpawnPoints = [map objectGroupNamed:@"Platforms"];
    activePlatforms = [NSMutableArray array];
    
    for (NSDictionary *platformDict in platformSpawnPoints.objects)
    {
        NSString *name = platformDict[@"name"];
        NSString *type = platformDict[@"type"];
        CGFloat speed = [platformDict[@"speed"] floatValue];
        CGFloat distanceToMove = [platformDict[@"distanceToMove"]floatValue];
        Platform *platform = [[Platform alloc] initWithImageNamed:name forPlatformType:type withSpeed:speed andDistance:distanceToMove];
        [activePlatforms addObject:platform];
        platform.position = CGPointMake([platformDict[@"x"] floatValue], [platformDict[@"y"] floatValue]);
        platform.zOrder = 15;
        [map addChild:platform];
    }
}


// Gets the coordinates of the specified map transition object
//- (CGPoint) getTransitionPointCoordinates:(NSString*) transitionPointId
//{
//    return([self getCoordinatesOfObject:transitionPointId fromObjectGroup:mapTransitions]);
//}
//
//// Gets the coordinates of the specified object from the supplied object group
- (CGPoint) getCoordinatesOfObject:(NSString*) objectId fromObjectGroup:(CCTiledMapObjectGroup*) objectGroup
{
    CGPoint point = CGPointMake(-1.0, -1.0);   // set to fall-back if no object is found
    objectId = (nil == objectId) ? @"default" : objectId;   // force to 'default' if nil
    if(nil != [objectGroup objectNamed:objectId])
    {
        // found it!
        NSDictionary* object = [objectGroup objectNamed:objectId];
        CGFloat x = [object[@"x"] floatValue];// / self.tileSize;
        CGFloat y = [object[@"y"] floatValue];// / self.tileSize;// - self.tileMap.mapSize.height);   // tile editor is 0,0 at top left of map, Cocos2D is 0,0 at bottom left of map
        return(CGPointMake(x + (map.tileSize.width / 2), y + (map.tileSize.height / 2)));
    }
    else if(![objectId isEqualToString:@"default"])   // look for the default transition point if we're not already doing so
    {
        point = [self getCoordinatesOfObject:@"default" fromObjectGroup:objectGroup];
    }
    return(point);
}

-(void)update:(CCTime)dt
{
   // NSLog(@"GLL update");
    [player update:dt];
    [hud updateBar:hud.manaBar ToPercentage:player.mana/player.maxMana];
    //should maybe call general method in HUD that updates all bars, but this way we don't need to worry about health bar unnecessarily
    
    if(player.statusState == statusStateDeath)
    {
        player.position = entrancePoint;
        player.desiredPosition = entrancePoint;
        player.velocity = ccp(0.0,0.0);
        player.isIntangible = NO;
        player.movementState = movementStateIdle;
        player.statusState = statusStateNone;
    }
    
//    [self checkForPlayerExits:player];
//    [self checkForAndResolveHorizontalCollisionsForActionSprite:player];
//    [self checkForAndResolveVerticalCollisionsForActionSprite:player];
//    [self checkObjectCollisions:player];
    
   
    NSMutableIndexSet *itemsToDiscard = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    
    for (ActionSprite *monster in activeEnemies)
    {
        [monster update:dt];
//        [self checkForAndResolveHorizontalCollisionsForActionSprite:monster];
//        [self checkForAndResolveVerticalCollisionsForActionSprite:monster];
        
        if (monster.statusState == statusStateDeath)
            [itemsToDiscard addIndex:index];

        index++;
    }
    [activeEnemies removeObjectsAtIndexes:itemsToDiscard];
    
    if(DISPLAY_DEBUG_HURTBOXES)
    {
        player.debugHurtBox.position = player.hurtBox.actual.origin;
        [Utility drawDebugBox:player.debugHurtBox forBoundingBox:player.hurtBox fillColor:[CCColor clearColor] borderColor:[CCColor blueColor]];
        
        for (ActionSprite *monster in activeEnemies)
        {
            monster.debugHurtBox.position = monster.hurtBox.actual.origin;
            [Utility drawDebugBox:monster.debugHurtBox forBoundingBox:monster.hurtBox fillColor:[CCColor clearColor] borderColor:[CCColor redColor]];
        }
    }
    if(DISPLAY_DEBUG_HITBOXES)
    {
        for(Attack *attack in player.activeAttacks)
        {
            if(![map.children containsObject:attack.debugHitBox])
                [map addChild:attack.debugHitBox];
            
            attack.debugHitBox.position = attack.hitBox.actual.origin;
            [Utility drawDebugBox:attack.debugHitBox forBoundingBox:attack.hitBox fillColor:[CCColor clearColor] borderColor:[CCColor greenColor]];
        }
    }
    
    //[self checkAttackCollisions];
    [self setViewpointCenter:player.position];
    
 //   [hud updateLabel:hud.testLabel withValue:[NSString stringWithFormat:@"velocity X = %f, velocity Y = %f", player.velocity.x, player.velocity.y]];
}

-(void)fixedUpdate:(CCTime)dt
{
  //  NSLog(@"GLL fixedUpdate");
   [player fixedUpdate:dt];
    [self checkForPlayerExits:player];
    //[self newCollisionCheckForActionSprite:player withTime:dt];
    [self checkForAndResolveHorizontalCollisionsForActionSprite:player];
    [self checkForAndResolveVerticalCollisionsForActionSprite:player];
    

    
    [self checkObjectCollisions:player];
    [self checkAttackCollisions];
    
    

    for (ActionSprite *monster in activeEnemies)
    {
        [monster fixedUpdate:dt];
        [self checkForAndResolveHorizontalCollisionsForActionSprite:monster];
        [self checkForAndResolveVerticalCollisionsForActionSprite:monster];
    }
}

-(void)setViewpointCenter:(CGPoint) position
{
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (map.mapSize.width * map.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (map.mapSize.height * map.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    map.position = viewPoint; 
}





-(void)checkForPlayerExits:(Player *)p
{
    for(NSDictionary *exit in exits)
    {
        CGRect exitRect = CGRectMake([exit[@"x"] floatValue], [exit[@"y"] floatValue],
                                     [exit[@"width"] floatValue], [exit[@"height"] floatValue]);
        if (CGRectIntersectsRect(player.hurtBox.actual, exitRect))
        {
            NSString *name = exit[@"destination"];
            int x = [[exit valueForKey:@"startx"] intValue];
            int y = [[exit valueForKey:@"destinationHeight"] intValue] - [[exit valueForKey:@"starty"] intValue];
            entrancePoint = ccp(x*32,y*32);
            [self loadMapNamed:name withEntrancePoint:entrancePoint];
            return;
        }
    }
}















-(void)newCollisionCheckForActionSprite:(ActionSprite *)sprite withTime:(CCTime)dt
{
    float xPos = sprite.hurtBox.actual.origin.x;
    float yPos = sprite.hurtBox.actual.origin.y + sprite.hurtBox.actual.size.height;
    
    int left = xPos / 32;
    int right = (xPos + sprite.hurtBox.actual.size.width) / 32;
    int top = map.mapSize.height - (yPos / 32);
    int bottom = map.mapSize.height - ((yPos - sprite.hurtBox.actual.size.height) / 32);
    
    for (int xt = left; xt <= right; xt++)
    {
        for(int yt = top; yt <= bottom; yt++)
        {
            CGPoint tileCoord = CGPointMake((float)xt, (float)yt);
            if (tileCoord.y > (map.mapSize.height - 1) || tileCoord.x > map.mapSize.width -1 || tileCoord.y < 0 || tileCoord.x < 0)
            {
                //invalid tile, warp back to entrance point
                [[OALSimpleAudio sharedInstance] playEffect:@"bubble.wav"];
                sprite.position = entrancePoint;
                return;
            }
            
            NSInteger gid = [walls tileGIDAt:tileCoord];
            
            
            
            
            
            
            
            if (gid) //is there a wall at tile
            {
                CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
                if (CGRectIntersectsRect(sprite.hurtBox.actual, tileRect))
                {
                    CGRect intersection = CGRectIntersection(sprite.hurtBox.actual, tileRect);
                    if (intersection.size.width > intersection.size.height)
                    {
                        if (sprite.velocity.y > 0)
                        {
                            //tile is diagonal & above but but resolving vertically
                            sprite.desiredPosition = ccp(sprite.desiredPosition.x, sprite.desiredPosition.y - intersection.size.height);
                            //p.onWall = YES;
                            sprite.velocity = ccp(sprite.velocity.x, 0.0);
                            sprite.position = sprite.desiredPosition;
                        }
                        else if (sprite.velocity.y < 0)
                        {
                            //tile is diagonal & below but but resolving vertically
                            sprite.desiredPosition = ccp(sprite.desiredPosition.x, sprite.desiredPosition.y + intersection.size.height);
                            //p.onWall = YES;
                            
                            if(sprite.velocity.y < -20)
                                [sprite  landingDetectedWithYVelocity:(float) sprite.velocity.y];
                            
                            sprite.velocity = ccp(sprite.velocity.x, 0.0);
                            sprite.position = sprite.desiredPosition;
                            sprite.onGround = YES;
                        }
                    }
                    else if (sprite.velocity.x > 0 && tileRect.origin.x > sprite.hurtBox.actual.origin.x)
                    {
                        //tile is right of the Character
                        sprite.desiredPosition = ccp(sprite.desiredPosition.x - intersection.size.width, sprite.desiredPosition.y);
                        //p.onWall = YES;
                        sprite.velocity = ccp(0.0, sprite.velocity.y);
                        sprite.position = sprite.desiredPosition;;
                    }
                    else if (sprite.velocity.x < 0 && tileRect.origin.x <= sprite.hurtBox.actual.origin.x)
                    {
                        //tile is left of the Character
                        sprite.desiredPosition = ccp(sprite.desiredPosition.x + intersection.size.width, sprite.desiredPosition.y);;
                        //p.onWall = YES;
                        sprite.velocity = ccp(0.0, sprite.velocity.y);
                        sprite.position = sprite.desiredPosition;
                    }
                
                
                    sprite.position = sprite.desiredPosition;
                    
                    
                    
                    if (intersection.size.height > intersection.size.width)
                    {
                        if (sprite.velocity.x > 0)
                        {
                            //tile is diagonal right but resolving horizontally
                            sprite.desiredPosition = ccp(sprite.desiredPosition.x - intersection.size.width, sprite.desiredPosition.y);
                            //p.onWall = YES;
                            sprite.velocity = ccp(0.0, sprite.velocity.y);
                            sprite.position = sprite.desiredPosition;
                        }
                        else if (sprite.velocity.x < 0)
                        {
                            //tile is diagonal left but resolving horizontally
                            sprite.desiredPosition = ccp(sprite.desiredPosition.x + intersection.size.width, sprite.desiredPosition.y);
                            //p.onWall = YES;
                            sprite.velocity = ccp(0.0, sprite.velocity.y);
                            sprite.position = sprite.desiredPosition;
                        }
                    }
                    else if (sprite.velocity.y > 0 && tileRect.origin.y > sprite.hurtBox.actual.origin.y)
                    {
                        //tile is directly above the Character
                        sprite.desiredPosition = ccp(sprite.desiredPosition.x, sprite.desiredPosition.y - intersection.size.height);
                        sprite.velocity = ccp(sprite.velocity.x, 0.0);
                        sprite.position = sprite.desiredPosition;
                    }
                    else if (sprite.velocity.y < 0 && tileRect.origin.y < sprite.hurtBox.actual.origin.y)
                    {
                        //tile is directly below the Character
                        sprite.desiredPosition = ccp(sprite.desiredPosition.x, sprite.desiredPosition.y + intersection.size.height);
                        
                        if(sprite.velocity.y < -20)
                            [sprite  landingDetectedWithYVelocity:(float) sprite.velocity.y];
                        
                        sprite.velocity = ccp(sprite.velocity.x, 0.0);
                        sprite.onGround = YES;
                        sprite.position = sprite.desiredPosition;
                    }

                    
                    
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }
    sprite.position = sprite.desiredPosition;
}



-(void)checkForAndResolveHorizontalCollisionsForActionSprite:(ActionSprite *)p
{
    float xPos = p.hurtBox.actual.origin.x;
    float yPos = p.hurtBox.actual.origin.y + p.hurtBox.actual.size.height;
    
    int left = xPos / 32;
    int right = (xPos + p.hurtBox.actual.size.width) / 32;
    int top = map.mapSize.height - (yPos / 32);
    int bottom = map.mapSize.height - ((yPos - p.hurtBox.actual.size.height) / 32);
    
    for (int xt = left; xt <= right; xt++)
    {
        for(int yt = top; yt <= bottom; yt++)
        {
            CGPoint tileCoord = CGPointMake((float)xt, (float)yt);
                if (tileCoord.y > (map.mapSize.height - 1) || tileCoord.x > map.mapSize.width -1 || tileCoord.y < 0 || tileCoord.x < 0)
                {
                    //invalid tile, warp back to entrance point
                    [[OALSimpleAudio sharedInstance] playEffect:@"bubble.wav"];
                    p.position = entrancePoint;
                    return;
                }
            
            NSInteger gid = [walls tileGIDAt:tileCoord];
            if (gid) //is there a wall at tile
            {
                CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
                if (CGRectIntersectsRect(p.hurtBox.actual, tileRect))
                {
                    CGRect intersection = CGRectIntersection(p.hurtBox.actual, tileRect);
                    if (intersection.size.width > intersection.size.height)
                    {
                        if (p.velocity.y > 0)
                        {
                            //tile is diagonal & above but but resolving vertically
                            p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.size.height);
                            //p.onWall = YES;
                            p.velocity = ccp(p.velocity.x, 0.0);
                            p.position = p.desiredPosition;
                        }
                        else if (p.velocity.y < 0)
                        {
                            //tile is diagonal & below but but resolving vertically
                            p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.size.height);
                            //p.onWall = YES;
                            
                            if(p.velocity.y < -20)
                                [p  landingDetectedWithYVelocity:(float) p.velocity.y];
                            
                            p.velocity = ccp(p.velocity.x, 0.0);
                            p.position = p.desiredPosition;
                            p.onGround = YES;
                        }
                    }
                    else if (p.velocity.x > 0 && tileRect.origin.x > p.hurtBox.actual.origin.x)
                    {
                        //tile is right of the Character
                        p.desiredPosition = ccp(p.desiredPosition.x - intersection.size.width, p.desiredPosition.y);
                        //p.onWall = YES;
                        p.velocity = ccp(0.0, p.velocity.y);
                        p.position = p.desiredPosition;;
                    }
                    else if (p.velocity.x < 0 && tileRect.origin.x <= p.hurtBox.actual.origin.x)
                    {
                        //tile is left of the Character
                        p.desiredPosition = ccp(p.desiredPosition.x + intersection.size.width, p.desiredPosition.y);;
                        //p.onWall = YES;
                        p.velocity = ccp(0.0, p.velocity.y);
                        p.position = p.desiredPosition;
                    }
                }
            }
        }
    }
    p.position = p.desiredPosition;
}

-(void)checkForAndResolveVerticalCollisionsForActionSprite:(ActionSprite *)p
{
    float xPos = p.hurtBox.actual.origin.x;
    float yPos = p.hurtBox.actual.origin.y + p.hurtBox.actual.size.height;
    
    int left = xPos / 32;
    int right = (xPos + p.hurtBox.actual.size.width) / 32;
    int top = map.mapSize.height - (yPos / 32);
    int bottom = map.mapSize.height - ((yPos - p.hurtBox.actual.size.height) / 32);
    p.onGround = NO;
    
    for(int xt = left; xt <= right; xt++)
    {
        for(int yt = top; yt <= bottom; yt++)
        {
            CGPoint tileCoord = CGPointMake((float)xt, (float)yt);
            
          
                if (tileCoord.y > (map.mapSize.height - 1) || tileCoord.x > map.mapSize.width -1 || tileCoord.y < 0 || tileCoord.x < 0)
                {
                    //invalid tile, warp back to entrance point
                    [[OALSimpleAudio sharedInstance] playEffect:@"bubble.wav"];
                    p.position = entrancePoint;
                    return;
                }
            
            NSInteger gid = [walls tileGIDAt:tileCoord];
            if (gid) //is there a wall at the specified tile
            {
                CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
                if (CGRectIntersectsRect(p.hurtBox.actual, tileRect))
                {
                    CGRect intersection = CGRectIntersection(p.hurtBox.actual, tileRect);
                    if (intersection.size.height > intersection.size.width)
                    {
                        if (p.velocity.x > 0)
                        {
                            //tile is diagonal right but resolving horizontally
                            p.desiredPosition = ccp(p.desiredPosition.x - intersection.size.width, p.desiredPosition.y);
                            //p.onWall = YES;
                            p.velocity = ccp(0.0, p.velocity.y);
                            p.position = p.desiredPosition;
                        }
                        else if (p.velocity.x < 0)
                        {
                            //tile is diagonal left but resolving horizontally
                            p.desiredPosition = ccp(p.desiredPosition.x + intersection.size.width, p.desiredPosition.y);
                            //p.onWall = YES;
                            p.velocity = ccp(0.0, p.velocity.y);
                            p.position = p.desiredPosition;
                        }
                    }
                    else if (p.velocity.y > 0 && tileRect.origin.y > p.hurtBox.actual.origin.y)
                    {
                        //tile is directly above the Character
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.size.height);
                        p.velocity = ccp(p.velocity.x, 0.0);
                        p.position = p.desiredPosition;
                    }
                    else if (p.velocity.y < 0 && tileRect.origin.y < p.hurtBox.actual.origin.y)
                    {
                        //tile is directly below the Character
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.size.height);
                        
                        if(p.velocity.y < -20)
                            [p  landingDetectedWithYVelocity:(float) p.velocity.y];
                        
                        p.velocity = ccp(p.velocity.x, 0.0);
                        p.onGround = YES;
                        p.position = p.desiredPosition;
                    }
                }
            }
        }
    }
    p.position = p.desiredPosition;
}

-(void)checkObjectCollisions:(Player *)p
{
    for (Torizo *monster in activeEnemies)
    {
        if (CGRectIntersectsRect(p.hurtBox.actual, monster.hurtBox.actual) && monster.movementState == movementStateRun)
        {
            if (p.isIntangible == NO)
            {
                [p hurtWithDamage:10 andStun:26];
                [hud updateBar:hud.healthBar ToPercentage:p.health/p.maxHealth];
 
                p.velocity = CGPointZero;
               // p.acceleration = 0.0f;
                
                CGPoint pnormal = ccpSub(p.hurtBox.actual.origin, monster.hurtBox.actual.origin);
                CGFloat direction = [Utility CGPointToDegree:pnormal];
                [p applyImpulseWithKnockback:1000.0f andDirection:direction];
                p.isIntangible = YES;
            }
        }
    }
    
    for (Platform *platform in activePlatforms)
    {
        if (CGRectIntersectsRect(p.hurtBox.actual, platform.boundingBox))
            [self handlePlatformCollisionForPlatform:platform andActionSprite:p];
    }
    
    NSInteger hazardsGid = [meta tileGIDAt:[self tileCoordForPosition:p.hurtBox.actual.origin]];
    if (hazardsGid)
    {
        {
            if ([self isProp:@"hazard" atTileCoord:[self tileCoordForPosition:p.hurtBox.actual.origin] forLayer:meta])
            {
                if(player.isIntangible == FALSE)
                {
                
                int gid = [meta tileGIDAt:[self tileCoordForPosition:p.hurtBox.actual.origin]];
                NSDictionary * properties = [map propertiesForGID:gid];
                int damage = [[properties objectForKey:@"damage"] intValue];
                [player hurtWithDamage:damage andStun:0];
                
                [hud updateBar:hud.healthBar ToPercentage:p.health/p.maxHealth];
                //player.isIntangible = YES;
                [p applyImpulse:ccp(0.0, 600)];
                }
            }
            else if ([self isProp:@"jump" atTileCoord:[self tileCoordForPosition:p.hurtBox.actual.origin] forLayer:meta])
            {
                [p applyImpulse:ccp(0.0, 1000)];
                [[OALSimpleAudio sharedInstance] playEffect:@"bubble.wav"];
            }
        }
    }
}

-(void)checkAttackCollisions
{
    for (Attack *attack in player.activeAttacks)
    {
        for (ActionSprite *monster in activeEnemies)
        {
            if (CGRectIntersectsRect(attack.hitBox.actual, monster.hurtBox.actual))
                [monster hurtWithDamage:attack.damage andStun:attack.stun];
        }
    }
}

-(void)handlePlatformCollisionForPlatform:(Platform *)platform andActionSprite: (ActionSprite *)actionSprite
{
    CGRect intersection = CGRectIntersection(actionSprite.hurtBox.actual, platform.boundingBox);
    if (intersection.size.width > intersection.size.height)
    {
        if (actionSprite.velocity.y > 0)
        {
            //tile is diagonal & above but but resolving vertically
            actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x, actionSprite.desiredPosition.y - intersection.size.height);
            //p.onWall = YES;
            actionSprite.velocity = ccp(actionSprite.velocity.x, 0.0);
            actionSprite.position = actionSprite.desiredPosition;
        }
        else if (actionSprite.velocity.y < 0)
        {
            //tile is diagonal & below but but resolving vertically
            actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x, actionSprite.desiredPosition.y + intersection.size.height);
            //p.onWall = YES;
            
            if(actionSprite.velocity.y < -20)
                [actionSprite  landingDetectedWithYVelocity:(float) actionSprite.velocity.y];
            
            actionSprite.velocity = platform.velocity;
            actionSprite.onGround = YES;
            actionSprite.onPlatform = YES;
            actionSprite.position = actionSprite.desiredPosition;
        }
    }
    else if (actionSprite.velocity.x > 0 && platform.boundingBox.origin.x > actionSprite.hurtBox.actual.origin.x)
    {
        //tile is right of the Character
        actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x - intersection.size.width, actionSprite.desiredPosition.y);
        //p.onWall = YES;
        actionSprite.velocity = ccp(0.0, actionSprite.velocity.y);
        actionSprite.position = actionSprite.desiredPosition;;
    }
    else if (actionSprite.velocity.x < 0 && platform.boundingBox.origin.x <= actionSprite.hurtBox.actual.origin.x)
    {
        //tile is left of the Character
        actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x + intersection.size.width, actionSprite.desiredPosition.y);;
        //p.onWall = YES;
        actionSprite.velocity = ccp(0.0, actionSprite.velocity.y);
        actionSprite.position = actionSprite.desiredPosition;
    }
    
    if (intersection.size.height > intersection.size.width)
    {
        if (actionSprite.velocity.x > 0)
        {
            //tile is diagonal right but resolving horizontally
            actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x - intersection.size.width, actionSprite.desiredPosition.y);
            //p.onWall = YES;
            actionSprite.velocity = ccp(0.0, actionSprite.velocity.y);
            actionSprite.position = actionSprite.desiredPosition;
        }
        else if (actionSprite.velocity.x < 0)
        {
            //tile is diagonal left but resolving horizontally
            actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x + intersection.size.width, actionSprite.desiredPosition.y);
            //p.onWall = YES;
            actionSprite.velocity = ccp(0.0, actionSprite.velocity.y);
            actionSprite.position = actionSprite.desiredPosition;
        }
    }
    else if (actionSprite.velocity.y > 0 && platform.boundingBox.origin.y > actionSprite.hurtBox.actual.origin.y)
    {
        //tile is directly above the Character
        actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x, actionSprite.desiredPosition.y - intersection.size.height);
        actionSprite.velocity = ccp(actionSprite.velocity.x, 0.0);
        actionSprite.position = actionSprite.desiredPosition;
        
    }
    else if (actionSprite.velocity.y < 0 && platform.boundingBox.origin.y < actionSprite.hurtBox.actual.origin.y)
    {
        //tile is directly below the Character
        actionSprite.desiredPosition = ccp(actionSprite.desiredPosition.x, actionSprite.desiredPosition.y + intersection.size.height);
        
        if(actionSprite.velocity.y < -20)
            [actionSprite  landingDetectedWithYVelocity:(float) actionSprite.velocity.y];
        
        actionSprite.velocity = platform.velocity;
        actionSprite.onGround = YES;
        actionSprite.onPlatform = YES;
        actionSprite.position = actionSprite.desiredPosition;
    }
}
/////////////////////////////////////////////////////////
#pragma mark GENERAL HELPER METHODS
/////////////////////////////////////////////////////////
- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    float x = floor(position.x / map.tileSize.width);
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    float y = floor((levelHeightInPixels - position.y) / map.tileSize.height);
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords
{
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    CGPoint origin = ccp(tileCoords.x * map.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * map.tileSize.height));
    return CGRectMake(origin.x, origin.y, map.tileSize.width, map.tileSize.height);
}

-(BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayer:(CCTiledMapLayer *)layer {
    // if (![self isValidTileCoord:tileCoord]) return NO;
    int gid = [layer tileGIDAt:tileCoord];
    NSDictionary * properties = [map propertiesForGID:gid];
    if (properties == nil) return NO;
    return [properties objectForKey:prop] != nil;
}
/////////////////////////////////////////////////////////
/////////   END HELPER METHODS           ////////////////
/////////////////////////////////////////////////////////




/////////////////////////////////////////////////////////
#pragma mark - SimpleDPad Delegate Methods
/////////////////////////////////////////////////////////
-(void)simpleDPad:(SimpleDPad *)simpleDPad beganTouchWithDirection:(CGPoint)direction
{
//    NSLog(@"simpleDPad Height = %f", simpleDPad.boundingBox.size.height);
//    NSLog(@"direction.x = %f", direction.x);
    
    
    if (player.noInputFrames == 0)
    {
        if (player.onGround && direction.x == 0 && direction.y < 0)
            [player crouch];
        
       else if (player.statusState != statusStateHurt)
        {
            if (direction.x > 0)
                player.moveRight = YES;
            
            else if (direction.x < 0)
                player.moveLeft = YES;
        }
    }
    else
    {
        //check to allow buffered input
    }
}
-(void)simpleDPad:(SimpleDPad *)simpleDPad isHoldingDirection:(CGPoint)direction
{
    if (player.noInputFrames == 0)
    {
        if (player.onGround)
        {
            if (direction.x == 0 && direction.y < 0)
            {
                [player crouch];
            }
            else
            {
                //player.acceleration += 70.0;
                [player stopAction:player.groundJumpAction];
                player.movementState = movementStateRun;
            
                if ([player numberOfRunningActions] == 0)
                {
                    if (player.statusState == statusStateBlock)
                        [player runAction:player.movingBlockAction];
                    else
                        [player runAction:player.runAction];
                }
                
            }
        }
    }
}
-(void)simpleDPad:(SimpleDPad *)simpleDPad didChangeDirectionTo:(CGPoint)direction
{
    if (player.noInputFrames == 0)
    {
        if (direction.x > 0)
        {
            player.moveLeft = NO;
            player.moveRight = YES;
        }
        else if (direction.x < 0)
        {
            player.moveRight = NO;
            player.moveLeft = YES;
        }
    }
}
-(void)simpleDPadTouchEnded:(SimpleDPad *)simpleDPad
{
    if (player.moveRight)
        player.moveRight = NO;
    
    if (player.moveLeft)
        player.moveLeft = NO;
    
    if (player.statusState == statusStateCrouch)
        player.statusState = statusStateNone;
    
    if (player.movementState != movementStateJump && player.movementState != movementStateFall && player.attackState == attackStateNone)
        [player stopAllActions];
    
   // player.acceleration = 0.0;
}
/////////////////////////////////////////////////////////
/////////   END DPAD DELEGATE METHODS    ////////////////
/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
#pragma mark Button Touch Methods
/////////////////////////////////////////////////////////
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:hud];
    
    if([self.children containsObject:inventory])
    {
        [self removeChild:inventory cleanup:YES];
        hud.visible = YES;
        [[OALSimpleAudio sharedInstance] playEffect:@"menu-move2.mp3"];
    }
    else if (CGRectContainsPoint([hud.rightButton boundingBox], touchLocation))
    {
        [player executeRightButtonAction];
    }
    else if (CGRectContainsPoint([hud.leftButton boundingBox], touchLocation))
    {
        [player executeLeftButtonAction];
    }
    else if (CGRectContainsPoint([hud.jumpButton boundingBox], touchLocation))
    {
        [player executeJumpButtonAction];
    }
    else
    {
        CGPoint touchLocation2 = [touch locationInNode:map];
        if (CGRectContainsPoint([player boundingBox], touchLocation2))
        [self launchInventory];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event     //doesn't yet do anything. reserve for charge attacks/actions
{
    CGPoint touchLocation = [touch locationInNode:hud];
    
    if (CGRectContainsPoint([hud.rightButton boundingBox], touchLocation))
    {
        //right button touch ended
    }
    else if (CGRectContainsPoint([hud.leftButton boundingBox], touchLocation))
    {
        if(player.statusState == statusStateBlock)
        {
            player.statusState = statusStateNone;
            if(player.movementState == movementStateRun)
                [player stopAction:player.movingBlockAction];
            
        }
    }
    else if (CGRectContainsPoint([hud.jumpButton boundingBox], touchLocation))
    {
        //jump button touch ended
    }
}
/////////////////////////////////////////////////////////
/////////   END BUTTON TOUCH METHODS     ////////////////
/////////////////////////////////////////////////////////
-(void)launchInventory
{
    [[OALSimpleAudio sharedInstance] playEffect:@"menu-move2.mp3"];
    [self addChild:inventory z:99];
    hud.visible = NO;	
}





                                    
@end
