//
//  KEVAppDelegate.m
//  Expense
//
//  Created by Kevin Clark on 2014-03-21.
//  Copyright (c) 2014 Kevin Clark. All rights reserved.
//

#import "KEVAppDelegate.h"
#import "KEVViewController.h"

@implementation KEVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIViewController *viewController = [[KEVViewController alloc] init];
    self.window.rootViewController = viewController;
    
    return YES;
}

@end
