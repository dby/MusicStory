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
func headerViewPullToRefresh(direction : XMRefreashDirection, callback:(() -> Void)?) {
    // 创建headerview
    let headerView : XMRefreshHeaderView = XMRefreshHeaderView.headerView()
    headerView.viewDirection = direction
    self.addSubview(headerView)
    headerView.beginRefreshingCallback = callback
    headerView.State = .RefreshStateNormal
}

/**
 开始下拉刷新
 */
func headerViewBeginRefreshing() {
    for object : AnyObject in self.subviews {
        if object is XMRefreshHeaderView{
            object.beginRefreshing()
        }
    }
}

/**
 *  结束下拉刷新
 */
func headerViewStopPullToRefresh() {
    for object : AnyObject in self.subviews{
        if object is XMRefreshHeaderView{
            object.endRefreshing()
        }
    }
}

/**
 移除下拉刷新
 */
func removeHeaderView() {
    for view : AnyObject in self.subviews{
        if view is XMRefreshHeaderView{
            view.removeFromSuperview()
        }
    }
}

func setHeaderHidden(hidden:Bool)
{
    for object : AnyObject in self.subviews{
        if object is XMRefreshHeaderView{
            let view:UIView  = object as! UIView
            view.hidden = hidden
        }
    }
    
}

func isHeaderHidden()
{
    for object : AnyObject in self.subviews{
        if object is XMRefreshHeaderView{
            let view:UIView  = object as! UIView
            view.hidden = hidden
        }
    }
    
}

/**
 上拉加载更多
 */
func footerViewPullToRefresh(direction : XMRefreashDirection, callback : (()->Void)?) {
    var footView : XMRefreshFooterView!
    if direction == .XMRefreshDirectionHorizontal {
        footView = XMRefreshFooterView(frame: CGRectMake(0, 0, XMRefreshViewHeight, SCREEN_HEIGHT))
    } else {
        footView = XMRefreshFooterView(frame: CGRectMake(0, 0, SCREEN_WIDTH, XMRefreshViewHeight))
    }
    footView.viewDirection = direction
    self.addSubview(footView)
    footView.beginRefreshingCallback = callback
    footView.State = .RefreshStateNormal
}

/**
 开始上拉加载更多
 */
func footerBeginRefreshing() {
    for object : AnyObject in self.subviews {
        if object is XMRefreshFooterView {
            object.beginRefreshing()
        }
    }
}


/**
 结束上拉加载更多
 */
func footerEndRefreshing()
{
    for object : AnyObject in self.subviews{
        if object is XMRefreshFooterView{
            object.endRefreshing()
        }
    }
}

/**
 移除脚步
 */
func removeFooterView()
{
    for view : AnyObject in self.subviews{
        if view is XMRefreshFooterView{
            view.removeFromSuperview()
        }
    }
}

func setFooterHidden(hidden:Bool)
{
    for object : AnyObject in self.subviews{
        if object is XMRefreshFooterView{
            let view:UIView  = object as! UIView
            view.hidden = hidden
        }
    }
    
}

func isFooterHidden()
{
    for object : AnyObject in self.subviews{
        if object is XMRefreshFooterView{
            let view:UIView  = object as! UIView
            view.hidden = hidden
        }
    }
    
}

@end
