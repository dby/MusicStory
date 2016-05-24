//
//  MSBaseNavController.m
//  MusicStory
//
//  Created by sys on 16/4/23.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSBaseNavController.h"

#import "AppConfig.h"

@interface MSBaseNavController ()

@end

@implementation MSBaseNavController

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    debugMethod();
    if ([self.viewControllers count] > 0)
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    debugMethod();
    if ([self.viewControllers count] == 2) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    return [super popViewControllerAnimated:animated];
}

@end
