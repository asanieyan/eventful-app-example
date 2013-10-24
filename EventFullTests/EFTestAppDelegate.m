//
//  EFTestAppDelegate.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFTestAppDelegate.h"

@implementation EFTestAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
