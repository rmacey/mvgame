//
//  MJTools.h
//  TMAACore
//
//  Created by Bob Macey on 8/5/14.
//  Copyright (c) 2014 Meijer. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const SUMMARY_THEMES_CACHE = @"summary_themes";

@interface SaveUtility : NSObject

+ (BOOL)saveDictionary:(NSDictionary *)dictionary withName:(NSString *)name;

+ (NSDictionary *)getDictionaryFromFileWithName:(NSString *)fileName;

+ (void)showVpnError;

@end
