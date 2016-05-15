//
//  MSRefreshBase.h
//  MusicStory
//
//  Created by sys on 16/3/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 刷新回调的Block
typedef void (^beginRefreshingBlock)();

// 控件的方向
typedef NS_ENUM(NSInteger, MSRefreashDirection)  {
    MSRefreshDirectionHorizontal,        // 水平
    MSRefreshDirectionVertical           // 竖直
};
//控件的刷新状态
typedef NS_ENUM(NSInteger, MSRefreshState) {
    RefreshStateNormal,                // 普通状态
    RefreshStatePulling,               // 松开就可以进行刷新的状态
    RefreshStateRefreshing,            // 正在刷新中的状态
    WillRefreshing,
};

//控件的类型
typedef NS_ENUM(NSInteger, MSRefreshViewType) {
    RefreshViewTypeHeader,             // 头部控件
    RefreshViewTypeFooter,             // 尾部控件
};

@interface MSRefreshBase : UIView

// 父控件
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;
// 箭头图片
@property (nonatomic, strong) UIImageView *arrowImage;
// 刷新后回调
@property (nonatomic, copy) beginRefreshingBlock beginRefreshingCallback;
// 交给子类去实现和调用
@property (nonatomic, assign) MSRefreshState oldState;
// 默认水平方向
@property (nonatomic, assign) MSRefreashDirection viewDirection;
@property (nonatomic, assign) MSRefreshState State;

- (BOOL) isRefreshing;
- (void) beginRefreshing;
- (void) endRefreshing;

@end
