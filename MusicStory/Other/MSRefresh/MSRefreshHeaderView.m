//
//  MSRefreshHeaderView.m
//  MusicStory
//
//  Created by sys on 16/5/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSRefreshHeaderView.h"

#import "UIView+MS.h"

#import "AppConfig.h"
#import "MSRefreshConst.h"

@interface MSRefreshHeaderView()

@end

@implementation MSRefreshHeaderView

#pragma mark - Setter Getter

-(void)setState:(MSRefreshState)State {
    
    debugMethod();
    self.oldState = self.State;
    [super setState:State];
    
    switch (self.State) {
        case RefreshStateNormal: {
            // 普通状态
            if (RefreshStateRefreshing == self.oldState) {
                [UIView animateWithDuration:MSRefreshSlowAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
                }];
                [self.scrollView setContentOffset:CGPointZero animated:true];
            } else {
                [UIView animateWithDuration:MSRefreshSlowAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
                }];
            }
            self.scrollView.scrollEnabled = true;
            break;
        }
        case RefreshStatePulling: {
            // 释放状态
            [UIView animateWithDuration:MSRefreshSlowAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        case RefreshStateRefreshing: {
            // 正在刷新状态
            if (self.viewDirection == MSRefreshDirectionHorizontal) {
                [self.scrollView setContentOffset:CGPointMake(-self.width, 0) animated:false];
            } else {
                [self.scrollView setContentOffset:CGPointMake(0, -self.width) animated:false];
            }
            self.scrollView.scrollEnabled = false;
            break;
        }
        default:
            break;
    }
}

-(void)layoutSubviews {
    debugMethod();
    [super layoutSubviews];
    
    if (self.viewDirection == MSRefreshDirectionHorizontal) {
        self.frame = CGRectMake(-MSRefreshViewHeight, 0, MSRefreshViewHeight, SCREEN_HEIGHT);
    } else {
        self.frame = CGRectMake(0, -MSRefreshViewHeight, SCREEN_WIDTH, MSRefreshViewHeight);
    }
}

// 创建headerView的静态方法
+(MSRefreshHeaderView *)headerView {
    debugMethod();
    return [[MSRefreshHeaderView alloc] initWithFrame:CGRectMake(-MSRefreshViewHeight, 0, MSRefreshViewHeight, SCREEN_HEIGHT)];
}

// 设置headerView的frame
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    debugMethod();
    [super willMoveToSuperview:newSuperview];
    if (self.viewDirection == MSRefreshDirectionHorizontal) {
        self.x = -MSRefreshViewHeight;
    } else {
        self.y = -MSRefreshViewHeight;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    debugMethod();
    if (self.hidden || self.State == RefreshStateRefreshing || ![MSRefreshContentOffset isEqualToString: keyPath])
        return;
    
    if (self.viewDirection == MSRefreshDirectionHorizontal) {
        CGFloat currentOffsetY = self.scrollView.contentOffset.x;
        CGFloat happenOffsetY  = -1 * self.scrollViewOriginalInset.left;
        
        debugLog(@"currentOffsetY: %f, happenOffsetY: %f", currentOffsetY, happenOffsetY);
        
        if (currentOffsetY >= happenOffsetY)
            return;
        
        // 根据scrollview 滑动的位置设置当前状态
        if (self.scrollView.dragging) {
            CGFloat normal2pullingOffsetY = happenOffsetY - MSRefreshViewHeight;
            if (self.State == RefreshStateNormal && currentOffsetY < normal2pullingOffsetY) {
                self.State = RefreshStatePulling;
            } else if (self.State == RefreshStatePulling && currentOffsetY >= normal2pullingOffsetY) {
                self.State = RefreshStateNormal;
            }
            
        } else if (self.State == RefreshStatePulling) {
            self.State = RefreshStateRefreshing;
        }
    }
    else {
        CGFloat currentOffsetY = self.scrollView.contentOffset.y;
        CGFloat happenOffsetY  = -self.scrollViewOriginalInset.top;
        
        if (currentOffsetY >= happenOffsetY) {
            return;
        }
        // 根据scrollview 滑动的位置设置当前状态
        if (self.scrollView.dragging) {
            CGFloat normal2pullingOffsetY = happenOffsetY - MSRefreshViewHeight;
            if (self.State == RefreshStateNormal && currentOffsetY < normal2pullingOffsetY) {
                self.State = RefreshStatePulling;
            } else if (self.State == RefreshStatePulling && currentOffsetY >= normal2pullingOffsetY){
                self.State = RefreshStateNormal;
            }
            
        } else if (self.State == RefreshStatePulling) {
            self.State = RefreshStateRefreshing;
        }
    }
}

-(void)deinit
{
    debugMethod();
    [self endRefreshing];
}

@end