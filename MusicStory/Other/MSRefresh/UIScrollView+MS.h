//
//  UIScrollView+MS.h
//  MusicStory
//
//  Created by sys on 16/3/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppConfig.h"
#import "MSRefreshBase.h"
#import "MSRefreshConst.h"
#import "MSRefreshHeaderView.h"
#import "MSRefreshFooterView.h"

typedef void (^CallBack)();

@interface UIScrollView (MS)

-(void)headerViewPullToRefresh: (MSRefreashDirection) direction callback:(CallBack)callback;
-(void)headerViewBeginRefreshing;
-(void)headerViewStopPullToRefresh;
-(void)removeHeaderView;
-(void)setHeaderHidden :(BOOL)hidden;
-(void)isHeaderHidden;


-(void)footerViewPullToRefresh:(MSRefreashDirection)direction callback:(CallBack)callback;
-(void)footerViewBeginRefreshing;
-(void)footerViewStopPullToRefresh;
-(void)removeFooterView;
-(void)setFooterHidden :(BOOL)hidden;
-(void)isFooterHidden;

@end
