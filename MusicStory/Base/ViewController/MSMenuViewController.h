//
//  MSMenuViewController.h
//  MusicStory
//
//  Created by sys on 16/6/14.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSBaseNavController.h"
#import "MSHomeViewController.h"

#import "MusicStory-Common-Header.h"

typedef enum : NSUInteger {
    MenuViewControllerTypeHome,
    MenuViewControllerTypeFindApp,
} MenuViewControllerType;

@interface MSMenuViewController : UIViewController

// 中间的控制器
@property (nonatomic, strong) MSBaseNavController *centerController;
@property (nonatomic, strong) MSHomeViewController *homeController;
// 左边的Menu的控制器
@property (nonatomic, strong) MSBaseNavController *leftController;

@property (nonatomic, weak) UIWindow *cover;
// 当前的控制器
@property (nonatomic, strong) UIViewController *currentController;

@property (nonatomic, assign) MenuViewControllerType type;

- (instancetype)initWithCenterController:(MSBaseNavController *)centerController leftController:(MSBaseNavController *)leftController;

@end
