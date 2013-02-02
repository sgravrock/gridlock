//
//  AppDelegate.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "AppDelegate.h"
#import "BoardViewController.h"
#import "Game.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Save the game state so that we can restore it if we're terminated
	// while in the background.
	NSString *path = [self gameStateFilename];
	
	if (path) {
		[[self serializeGameState] writeToFile:path atomically:YES];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSData *)savedGameState {
	// If there is a saved game state file, load it.
	NSString *path = [self gameStateFilename];
	
	if (!(path && [[NSFileManager defaultManager] fileExistsAtPath:path])) {
		return nil;
	}
	
	NSError *error;
	NSData *result = [NSData dataWithContentsOfFile:path options:0 error:&error];
	
	if (!result) {
		NSLog(@"Error reading game state file: %@", [error localizedDescription]);
	}
	
	return result;
}

- (NSString *)gameStateFilename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	if (![fileMgr fileExistsAtPath:documentsDir]) {
		NSError *error;
		BOOL created = [fileMgr createDirectoryAtPath:documentsDir
						  withIntermediateDirectories:YES
										   attributes:nil
												error:&error];
		
		if (!created) {
			// Log the error, but don't report it to the user --
			// there's probably nothing they can do to resolve it.
			NSLog(@"Couldn't create documents directory: %@", [error localizedDescription]);
			return nil;
		}
	}
	
	return [documentsDir stringByAppendingPathComponent:@"gamestate"];
}

- (NSData *)serializeGameState {
	//UIWindow *window = [UIApplication sharedApplication].keyWindow;
	BoardViewController *rootController = (BoardViewController *)self.window.rootViewController;
	NSMutableData *data = [NSMutableData data];
	NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[rootController.game encodeWithCoder:coder];
	[coder finishEncoding];
	return data;
}

@end
