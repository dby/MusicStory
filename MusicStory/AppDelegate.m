//
//  AppDelegate.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "AppDelegate.h"

#import <RESideMenu/RESideMenu.h>

#import "MSSlideViewController.h"
#import "MSHomeViewController.h"
#import "MSBaseNavController.h"

#import <YTKNetworkConfig.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "musicStory-Common-Header.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Set Network
    [AFNetworkActivityIndicatorManager sharedManager].enabled   = YES;
    [YTKNetworkConfig sharedInstance].baseUrl                   = API_Server;
    
    //Set UserAgent
    NSDictionary *userAgent = @{@"UserAgent": @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12H143 Safari/600.1.4"};
    [[NSUserDefaults standardUserDefaults] registerDefaults:userAgent];
    
    // Create content and menu controllers
    //
    MSHomeViewController   *contentViewController = [[MSHomeViewController alloc] init];
    MSSlideViewController *leftMenuViewController = [[MSSlideViewController alloc] init];
    
    // Create side menu controller
    //
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:
                                          [[MSBaseNavController alloc] initWithRootViewController: contentViewController]
                                                                    leftMenuViewController:
                                          [[MSBaseNavController alloc] initWithRootViewController:leftMenuViewController]
                                                                   rightMenuViewController:nil];
    
    // Make it a root controller
    self.window.rootViewController = sideMenuViewController;
    
    [AVOSCloud setApplicationId:@"xJVf4uf6o6dV0zJAX9d8JOK1-gzGzoHsz"
                      clientKey:@"p1aMdhAX9b3AnJSOxXOrcodl"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
