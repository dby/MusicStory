//
//  UIScrollView+MS.m
//  MusicStory
//
//  Created by sys on 16/3/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIScrollView+MS.h"

@implementation UIScrollView (MS)

/**
 下拉刷新 第一个参数是方向
 */
-(void)headerViewPullToRefresh: (MSRefreashDirection) direction callback:(CallBack)callback {
    debugMethod();
    // 创建headerview
    MSRefreshHeaderView *headerView = [MSRefreshHeaderView headerView];
    headerView.viewDirection = direction;
    [self addSubview:headerView];
    headerView.beginRefreshingCallback = callback;
    headerView.State = RefreshStateNormal;
}

/**
 开始下拉刷新
 */
-(void)headerViewBeginRefreshing {
    
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshHeaderView class]]) {
            [(MSRefreshHeaderView *)object beginRefreshing];
        }
    }
}

/**
 *  结束下拉刷新
 */
-(void)headerViewStopPullToRefresh {
    
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshHeaderView class]]) {
            [(MSRefreshHeaderView *)object endRefreshing];
        }
    }
}

/**
 移除下拉刷新
 */
-(void)removeHeaderView {
    
    debugMethod();
    for (NSObject *object in self.subviews)
    {
        if ([object isKindOfClass:[MSRefreshHeaderView class]]) {
            [(MSRefreshHeaderView *)object removeFromSuperview];
        }
    }
}

-(void)setHeaderHidden :(BOOL)hidden
{
    debugMethod();
    for (NSObject *object in self.subviews)
    {
        if ([object isKindOfClass:[MSRefreshHeaderView class]]) {
            [(UIView *)object setHidden:hidden];
        }
    }
}

-(void)isHeaderHidden
{
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshHeaderView class]]) {
            //[(UIView *)object setHidden:hidden];
            //let view:UIView  = object as! UIView
            //view.hidden = hidden
        }
    }
}
/**
 上拉加载更多
 */
-(void)footerViewPullToRefresh:(MSRefreashDirection)direction callback:(CallBack)callback {
    debugMethod();
    MSRefreshFooterView *footView;
    if (direction == MSRefreshDirectionHorizontal){
        footView = [[MSRefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, MSRefreshViewHeight, SCREEN_HEIGHT)];
    } else {
        footView = [[MSRefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MSRefreshViewHeight)];
    }
    footView.viewDirection = direction;
    [self addSubview:footView];
    footView.beginRefreshingCallback = callback;
    footView.State = RefreshStateNormal;
}

/**
 开始上拉加载更多
 */
-(void)footerViewBeginRefreshing {
    
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshFooterView class]]) {
            [(MSRefreshFooterView *)object beginRefreshing];
        }
    }
}

/**
 结束上拉加载更多
 */
-(void)footerViewStopPullToRefresh
{
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshFooterView class]]) {
            [(MSRefreshFooterView *)object endRefreshing];
        }
    }
}

/**
 移除脚步
 */
             
-(void)removeFooterView
{
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshFooterView class]]) {
            [(MSRefreshFooterView *)object removeFromSuperview];
        }
    }
}

-(void)setFooterHidden :(BOOL)hidden
{
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshFooterView class]]) {
            [(UIView *)object setHidden:hidden];
        }
    }
}

-(void)isFooterHidden
{
    debugMethod();
    for (NSObject *object in self.subviews) {
        if ([object isKindOfClass:[MSRefreshFooterView class]]) {
            //let view:UIView  = object as! UIView
            //view.hidden = hidden
        }
    }
}

@end
