//
//  AppDelegate.m
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "AppDelegate.h"
#import "SCRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[SCRootViewController alloc] init];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
