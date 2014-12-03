//
//  MJTools.m
//  TMAACore
//
//  Created by Bob Macey on 8/5/14.
//  Copyright (c) 2014 Meijer. All rights reserved.
//

#import "SaveUtility.h"
#import <UIKit/UIKit.h>

@implementation MJTools

+ (void)showVpnError
{
    [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to connect to Meijer services" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

+ (BOOL)saveString:(NSString *)string withName:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, name];
	
	return [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)saveArray:(NSArray *)array withName:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, name];
	
	return [array writeToFile: filePath  atomically:YES];
}

+ (BOOL)saveDictionary:(NSDictionary *)dictionary withName:(NSString *)name
{
	NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory   = [paths objectAtIndex:0];
	NSString *filePath         = [NSString stringWithFormat:@"%@/%@", cacheDirectory, name];
	
	return [dictionary writeToFile: filePath  atomically:YES];
}

+ (NSString *)createPathToCachedFileWithName:(NSString *)filename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
    
	return [NSString stringWithFormat:@"%@/%@", cacheDirectory, filename];
}

+ (void)openCacheAndDeleteFileNamed:(NSString *)filename
{
	NSFileManager* fm = [NSFileManager defaultManager];
	NSString *cachePath = [self searchCacheForFile:filename];
    
	if (cachePath)
    {
		[fm removeItemAtPath:cachePath error:nil];
    }
}

+ (void)openCacheAndDeleteArchiveNamed:(NSString *)archiveName
{
	NSFileManager* fm = [NSFileManager defaultManager];
	NSString *cachePath = [self searchCacheForArchive:archiveName];
    
	if (cachePath)
    {
		[fm removeItemAtPath:cachePath error:nil];
    }
}

+ (NSString *)searchCacheForArchive:(NSString *)archiveName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	NSString *archivePath = [NSString stringWithFormat:@"%@/%@.archive", cacheDirectory,
                             archiveName];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath: archivePath])
    {
		return archivePath;
    }
	else
    {
		return nil;
    }
}

+ (NSMutableDictionary *)getDictionaryFromFileWithName:(NSString *)fileName
{
	NSString *completePath = [self searchCacheForFile: fileName];
    
	if (!completePath)
	{
		return nil;
	}
	
	return [NSMutableDictionary dictionaryWithContentsOfFile:completePath];
}

+ (NSArray *)getArrayFromFileWithName:(NSString *)fileName
{
    NSString *completePath = [self searchCacheForFile:fileName];
    
    if(!completePath)
    {
        return nil;
    }
    
    return [NSArray arrayWithContentsOfFile:completePath];
}

+ (NSString *)getStringFromFileWithName:(NSString *)fileName
{
    NSString *completePath = [self searchCacheForFile:fileName];
    
    if(!completePath)
    {
        return nil;
    }
    
    return [NSString stringWithContentsOfFile:completePath encoding:NSUTF8StringEncoding error:nil];
}

+ (NSDictionary *)createDictionaryFromString:(NSString *)stringData
{
	NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
	return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

+ (NSArray *)createArrayFromString:(NSString *)stringData
{
	NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
	return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

+ (NSString *)searchCacheForFile:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, filename];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return filePath;
    }
    
    return nil;
}

@end
