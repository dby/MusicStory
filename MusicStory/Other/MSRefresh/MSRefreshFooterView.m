//
//  MSRefreshFooterView.m
//  MusicStory
//
//  Created by sys on 16/5/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSRefreshFooterView.h"

#import "AppConfig.h"
#import "MSRefreshConst.h"

#import "UIView+MS.h"

@implementation MSRefreshFooterView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lastRefreshCount = 0;
    }
    return self;
}

#pragma mark - Setter Getter

-(void)setState:(MSRefreshState)State {
    self.oldState = self.State;
    [super setState:State];
    switch (self.State)
    {
        case RefreshStateNormal: {
            if (self.oldState == RefreshStateRefreshing) {
                self.arrowImage.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
                [UIView animateWithDuration:MSRefreshSlowAnimationDuration animations:^{
                    UIEdgeInsets inset  = self.scrollView.contentInset;
                    inset.bottom        = self.scrollViewOriginalInset.bottom;
                    self.scrollView.contentInset = inset;
                }];
            } else {
                [UIView animateWithDuration:MSRefreshSlowAnimationDuration  animations: ^{
                    self.arrowImage.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
                }];
            }
            
            CGFloat deltaH  = [self heightForContentBreakView];
            NSInteger currentCount = [self totalDataCountInScrollView];
            
            /*
            if (RefreshStateRefreshing == self.oldState && deltaH > 0  && currentCount != self.lastRefreshCount) {
                if (self.viewDirection == MSRefreshDirectionHorizontal) {
                    CGPoint offset  = self.scrollView.contentOffset;
                    offset.x        = self.scrollView.contentOffset.x - self.width + SCREEN_WIDTH;
                    [self.scrollView setContentOffset:offset animated:true];
                } else {
                    CGPoint offset  = self.scrollView.contentOffset;
                    offset.y        = self.scrollView.contentOffset.y;
                    self.scrollView.contentOffset = offset;
                }
            }
             */
            break;
        }
        case RefreshStatePulling: {
            [UIView animateWithDuration:MSRefreshSlowAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        case RefreshStateRefreshing: {
            if (self.viewDirection == MSRefreshDirectionHorizontal) {
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-SCREEN_WIDTH+self.width, 0) animated:true];
            } else {
                self.lastRefreshCount = [self totalDataCountInScrollView];
                [UIView animateWithDuration:MSRefreshSlowAnimationDuration animations:^{
                    CGFloat bottom = self.height + self.scrollViewOriginalInset.bottom;
                    CGFloat deltaH = [self heightForContentBreakView];
                    if (deltaH < 0) {
                        bottom = bottom - deltaH;
                    }
                    UIEdgeInsets inset  = self.scrollView.contentInset;
                    inset.bottom        = bottom;
                    self.scrollView.contentInset = inset;
                }];
            }
            break;
        }
        default:{
            break;
        }
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (self.superview != nil){
        [self.superview removeObserver:self forKeyPath:MSRefreshContentSize];
    }
    
    if (newSuperview != nil)  {
        // 监听contentsize
        [newSuperview addObserver:self forKeyPath:MSRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        // 重新调整frame
        [self resetFrameWithContentSize];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.hidden)
        return;
    
    // 这里分两种情况 1.contentSize 2.contentOffset
    
    if ([MSRefreshContentSize  isEqual: keyPath]) {
        [self resetFrameWithContentSize];
    }
    else if ([MSRefreshContentOffset  isEqual: keyPath]) {
        // 如果不是刷新状态
        if (self.State == RefreshStateRefreshing)
            return;
        }
        
        if (self.viewDirection == MSRefreshDirectionHorizontal) {
            
            CGFloat currentOffsetX  = self.scrollView.contentOffset.x;
            CGFloat happenOffsetX  = [self happenOffsetX];
            
            if (currentOffsetX <= happenOffsetX) {
                return;
            }
            
            if (self.scrollView.dragging) {
                CGFloat normal2pullingOffsetY =  happenOffsetX + self.width;
                if (self.State == RefreshStateNormal && currentOffsetX > normal2pullingOffsetY) {
                    self.State = RefreshStatePulling;
                } else if (self.State == RefreshStatePulling && currentOffsetX <= normal2pullingOffsetY) {
                    self.State = RefreshStateNormal;
                }
            } else if (self.State == RefreshStatePulling) {
                self.State = RefreshStateRefreshing;
            }
        } else {
            CGFloat currentOffsetY = self.scrollView.contentOffset.y;
            CGFloat happenOffsetY  = [self happenOffsetX];
            
            if (currentOffsetY <= happenOffsetY) {
                return;
            }
            
            if (self.scrollView.dragging) {
                CGFloat normal2pullingOffsetY =  happenOffsetY + self.frame.size.height;
                if (self.State == RefreshStateNormal && currentOffsetY > normal2pullingOffsetY) {
                    self.State = RefreshStatePulling;
                } else if (self.State == RefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
                    self.State = RefreshStateNormal;
                }
            } else if (self.State == RefreshStatePulling) {
                self.State = RefreshStateRefreshing;
            }
        }
}

/**
 重新设置frame
 */
- (void)resetFrameWithContentSize {
    if (self.viewDirection == MSRefreshDirectionHorizontal) {
        CGFloat contentHeight = self.scrollView.contentSize.width;
        CGFloat scrollHeight = self.scrollView.width  - self.scrollViewOriginalInset.left - self.scrollViewOriginalInset.right;
        
        CGRect rect = self.frame;
        rect.origin.x =  contentHeight > scrollHeight ? contentHeight : scrollHeight;
        self.frame = rect;
    } else {
        CGFloat contentHeight = self.scrollView.contentSize.height;
        CGFloat scrollHeight  = self.scrollView.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
        
        CGRect rect = self.frame;
        rect.origin.y =  contentHeight > scrollHeight ? contentHeight : scrollHeight;
        self.frame = rect;
    }
}

- (CGFloat) heightForContentBreakView {
    if (self.viewDirection == MSRefreshDirectionHorizontal) {
        CGFloat h = self.scrollView.width - self.scrollViewOriginalInset.right - self.scrollViewOriginalInset.left;
        return self.scrollView.contentSize.width - h;
    } else {
        CGFloat h = self.scrollView.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
        return self.scrollView.contentSize.height - h;
    }
}

- (CGFloat) happenOffsetX {
    
    if (self.viewDirection == MSRefreshDirectionHorizontal) {
        CGFloat deltaH = [self heightForContentBreakView];
        if (deltaH > 0) {
            return  deltaH - self.scrollViewOriginalInset.left;
        } else {
            return  -1 * self.scrollViewOriginalInset.left;
        }
    } else {
        CGFloat deltaH = [self heightForContentBreakView];
        if (deltaH > 0) {
            return deltaH - self.scrollViewOriginalInset.top;
        } else {
            return  -self.scrollViewOriginalInset.top;
        }
    }
}

/**
 获取cell的总个数
 */
-(NSInteger) totalDataCountInScrollView {
    NSInteger totalCount = 0;
    if ([self.scrollView isKindOfClass: [UITableView class]]){
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (int i = 0 ; i <  tableView.numberOfSections ; i++){
            totalCount = totalCount + [tableView numberOfRowsInSection:i];
        }
    } else if ([self.scrollView isKindOfClass: [UICollectionView class]]){
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        for (int i = 0 ; i <  [collectionView numberOfSections] ; i++){
            totalCount = totalCount + [collectionView numberOfItemsInSection:i];
        }
    }
    return totalCount;
}

-(void)deinit {
    [self endRefreshing];
}

@end