//
//  AppDelegate.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.


#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppDelegate : CCAppDelegate
{
	CCDirectorIOS	*director_;	
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) CCDirectorIOS *director;

@end



