//
//  UIViewController+MS.h
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MS)

- (void)showNetWorkErrorView;
- (void)errorViewDidClick :(UIButton *)errorView;
- (void)showProgress;
- (void)hiddenProgress;

@end
