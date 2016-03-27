//
//  UIViewController+MS.m
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIViewController+MS.h"

#import "AppConfig.h"

@implementation UIViewController (MS)

-(void)showNetWorkErrorView {
    UIButton *errorView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 145)];
    errorView.center = self.view.center;
    [errorView setImage:[UIImage imageNamed:@"not_network_icon_unpre"] forState:UIControlStateNormal];
    [errorView setImage:[UIImage imageNamed:@"not_network_icon_pre"] forState:UIControlStateNormal];
    [errorView addTarget:self action:@selector(errorViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:errorView];
    // 让他处在view的最上层
    [self.view bringSubviewToFront:errorView];
}

- (void)errorViewDidClick:(UIButton *)errorView {
    [errorView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ERRORBTNCLICK object:nil];
}

-(void)showProgress {
    UIImageView *progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    progressView.tag = 500;
    progressView.center = self.view.center;
    [self.view addSubview:progressView];
    
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    // 添加图片
    for (int i = 0; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:@"loading_\(i+1)"];
        [imgArray addObject:image];
    }
    progressView.animationImages = imgArray;
    progressView.animationDuration = 0.5;
    progressView.animationRepeatCount = 999;
    [progressView startAnimating];
}

-(void)hiddenProgress {
    for (UIView *view in self.view.subviews) {
        if (view.tag == 500) {
            UIImageView *imgView = (UIImageView *)view;
            [imgView stopAnimating];
            [imgView performSelector:@selector(setAnimationImages:) withObject:nil];
        }
    }
}

@end
