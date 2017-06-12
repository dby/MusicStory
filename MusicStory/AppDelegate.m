//
//  AppDelegate.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "AppDelegate.h"

#import "MSBaseNavController.h"
#import "MSHomeViewController.h"
#import "MSMenuViewController.h"
#import "MSSlideViewController.h"

#import "AFNetworking.h"
#import "ErrorPromptUtil.h"

@import Firebase;

#import "musicStory-Common-Header.h"

@interface AppDelegate ()

@property (nonatomic, strong) dispatch_source_t timer;

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
    
    [AVOSCloud setApplicationId:@"xJVf4uf6o6dV0zJAX9d8JOK1-gzGzoHsz"
                      clientKey:@"p1aMdhAX9b3AnJSOxXOrcodl"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Create content and menu controllers
    MSHomeViewController   *contentViewController = [[MSHomeViewController alloc] init];
    MSSlideViewController *leftMenuViewController = [[MSSlideViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    // Make it a root controller
    self.window.rootViewController = [[MSMenuViewController alloc]
                                      initWithCenterController:[[MSBaseNavController alloc] initWithRootViewController:contentViewController]
                                      leftController:[[MSBaseNavController alloc] initWithRootViewController:leftMenuViewController]];
    
    [FIRApp configure];
    [self updateConfigInfo];
    [self configureShareSDK];
    [self configureWeiboSNSSDK];
    [self monitorNetWorkStatus];
    
    return YES;
}

- (void)configureWeiboSNSSDK {
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo
                     withAppKey:@"3976740434"
                   andAppSecret:@"454d1fad0ddba01e61e7e0ace2ec49f0"
                 andRedirectURI:@"http://wanpaiapp.com/oauth/callback/sina"];
    
    [AVOSCloud setAllLogsEnabled:YES];
    [AVOSCloud setLastModifyEnabled:YES];
}

- (void)configureShareSDK {
    
    [OpenShare connectWeixinWithAppId:@"wx26eb788e8c352845"];
    [OpenShare connectWeiboWithAppKey:@"3976740434"];
//    [ShareSDK registerApp:@"150733cdd42da"
//     
//          activePlatforms:@[@(SSDKPlatformTypeWechat)]
//                 onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wx26eb788e8c352845"
//                                       appSecret:@"bb511342fc3e95486fcecc6a57e8cceb"];
//                 break;
//             default:
//                 break;
//         }
//     }];
}

- (void)monitorNetWorkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                MSInterf.shareInstance.isNetWorkConnected = true;
                [ErrorPromptUtil hideErrorPrompt];
                NSLog(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                MSInterf.shareInstance.isNetWorkConnected = false;
                [ErrorPromptUtil showErrorPrompt:@"网络未连接，请检查当前网络状态..."];
                NSLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                MSInterf.shareInstance.isNetWorkConnected = true;
                [ErrorPromptUtil hideErrorPrompt];
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                MSInterf.shareInstance.isNetWorkConnected = true;
                [ErrorPromptUtil hideErrorPrompt];
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}

- (void)showGoogleAds {
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)([MSInterf shareInstance].googleAdsStart * NSEC_PER_SEC));
    dispatch_time_t interval = (uint64_t)([MSInterf shareInstance].googleAdsInterval * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"调用回调函数");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWING_GOOGLE_ADS" object:nil];
    });
    
    dispatch_resume(self.timer);
}

- (void)updateConfigInfo{
    AVQuery *query = [AVQuery queryWithClassName:@"Config"];
    [query getObjectInBackgroundWithId:@"593e5efe128fe1006af2411b" block:^(AVObject *object, NSError *error) {
        if (!error) {
            [MSInterf shareInstance].appId = [object objectForKey:@"appId"];
            [MSInterf shareInstance].applicationId = [object objectForKey:@"applicationId"];
            [MSInterf shareInstance].cellId = [object objectForKey:@"cellId"];
            [MSInterf shareInstance].googleAdsStart = [[object objectForKey:@"googleAdsStart"] integerValue];
            [MSInterf shareInstance].googleAdsInterval = [[object objectForKey:@"googleAdsInterval"] integerValue];
        }
        [self showGoogleAds];
    }];
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
    
    dispatch_source_cancel(self.timer);
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    return [AVOSCloudSNS handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [AVOSCloudSNS handleOpenURL:url];
}

// For application on system equals or larger ios 9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [AVOSCloudSNS handleOpenURL:url];
}

@end
