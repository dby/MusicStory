//
//  UIViewController+Menu.h
//  MusicStory
//
//  Created by sys on 16/6/15.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMenuViewController.h"

@class MSMenuViewController;

@interface UIViewController (Menu)

@property (strong, readonly, nonatomic) MSMenuViewController *sideMenuViewController;

@end
