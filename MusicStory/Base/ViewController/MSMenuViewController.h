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

- (instancetype)initWithCenterController:(MSBaseNavController *)centerController leftController:(UIViewController *)leftController;

@end
