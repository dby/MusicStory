//
//  MSRefreshBase.h
//  MusicStory
//
//  Created by sys on 16/3/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

// 控件的方向
typedef NS_ENUM(NSInteger, MSRefreashDirection)  {
    MSRefreshDirectionHorizontal,        // 水平
    MSRefreshDirectionVertical         // 竖直
};
//控件的刷新状态
typedef NS_ENUM(NSInteger ,MSRefreshState) {
    RefreshStateNormal,               // 普通状态
    RefreshStatePulling,               // 松开就可以进行刷新的状态
    RefreshStateRefreshing,            // 正在刷新中的状态
    WillRefreshing,
};

//控件的类型
typedef NS_ENUM(NSInteger, MSRefreshViewType) {
    RefreshViewTypeHeader,             // 头部控件
    RefreshViewTypeFooter,            // 尾部控件
};

@interface MSRefreshBase : UIView

@end
