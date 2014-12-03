////
////  AppDelegate.m
////  SuperKoalio
////
////  Created by Jacob Gundersen on 6/4/12.
//
//
//#import "cocos2d.h"
//
//#import "AppDelegate.h"
//#import "GameLevelLayer.h"
//
//@implementation AppController
//
//@synthesize window=window_, navController=navController_, director=director_;
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//	// Create the main window
//	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    
//	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
//	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
//								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
//								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
//							preserveBackbuffer:NO
//									sharegroup:nil
//								 multiSampling:NO
//							   numberOfSamples:0];
//    
//	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
//    
//	director_.wantsFullScreenLayout = YES;
//    
//	// Display FSP and SPF
//	[director_ setDisplayStats:YES];
//    
//	// set FPS at 60
//	[director_ setAnimationInterval:1.0/60];
//    
//	// attach the openglView to the director
//	[director_ setView:glView];
//    
//	// for rotation and other messages
//	[director_ setDelegate:self];
//    
//	// 2D projection
//	[director_ setProjection:CCDirectorProjection2D];
//    //	[director setProjection:kCCDirectorProjection3D];
//    
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	//if( ! [director_ enableRetinaDisplay:YES] )
//	//	CCLOG(@"Retina Display Not supported");
//    
//	// Create a Navigation Controller with the Director
//	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
//	navController_.navigationBarHidden = YES;
//    
//	// set the Navigation Controller as the root view controller
//    //	[window_ setRootViewController:rootViewController_];
//	[window_ addSubview:navController_.view];
//    
//	// make main window visible
//	[window_ makeKeyAndVisible];
//    
//	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
//	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
//	// You can change anytime.
//	[CCTexture setDefaultAlphaPixelFormat:CCTexturePixelFormat_RGBA8888];
//  
//	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
//	[director_ pushScene: [GameLevelLayer scene]];
//    
//	return YES;
//}
//
//// Supported orientations: Landscape. Customize it for your own needs
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}
//
//
//// getting a call, pause the game
//-(void) applicationWillResignActive:(UIApplication *)application
//{
//	if( [navController_ visibleViewController] == director_ )
//		[director_ pause];
//}
//
//// call got rejected
//-(void) applicationDidBecomeActive:(UIApplication *)application
//{
//	if( [navController_ visibleViewController] == director_ )
//		[director_ resume];
//}
//
//-(void) applicationDidEnterBackground:(UIApplication*)application
//{
//	if( [navController_ visibleViewController] == director_ )
//		[director_ stopAnimation];
//}
//
//-(void) applicationWillEnterForeground:(UIApplication*)application
//{
//	if( [navController_ visibleViewController] == director_ )
//		[director_ startAnimation];
//}
//
//// application will be killed
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//	//CC_DIRECTOR_END();
//}
//
//// purge memory
//- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
//{
//	[[CCDirector sharedDirector] purgeCachedData];
//}
//
//// next delta time will be zero
//-(void) applicationSignificantTimeChange:(UIApplication *)application
//{
//	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
//}
//
//@end


//
//  AppDelegate.m
//  temp
//
//  Created by Ryan Macey on 4/22/14.
//  Copyright Ryan Macey 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "GameLevelLayer.h"

@implementation AppDelegate

//
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.

	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
                                    // Show the FPS and draw call label.
                                    CCSetupShowDebugStats: @(YES),
                                    
                                    // More examples of options you might want to fiddle with:
                                    // (See CCAppDelegate.h for more information)
                                    
                                    // Use a 16 bit color buffer:
                                    //		CCSetupPixelFormat: kEAGLColorFormatRGB565,
                                    // Use a simplified coordinate system that is shared across devices.
                                    //		CCSetupScreenMode: CCScreenModeFixed,
                                    // Run in portrait mode.
                                    //		CCSetupScreenOrientation: CCScreenOrientationPortrait,
                                    // Run at a reduced framerate.
                                    //		CCSetupAnimationInterval: @(1.0/45.0),
                                    // Run the fixed timestep extra fast.
                                    		CCSetupFixedUpdateInterval: @(1.0/180.0),
                                    // Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
                                    		//CCSetupTabletScale2X: @(YES),
                                    }];
	
	return YES;
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [GameLevelLayer scene];
}

@end
