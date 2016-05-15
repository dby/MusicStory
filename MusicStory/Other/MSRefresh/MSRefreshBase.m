//
//  MSRefreshBase.m
//  MusicStory
//
//  Created by sys on 16/3/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSRefreshBase.h"

#import "AppConfig.h"
#import "MSRefreshConst.h"

@interface MSRefreshBase()

@end

@implementation MSRefreshBase

@synthesize State = _State;

#pragma mark Setter / Getter

-(MSRefreshState)State
{
    return _State;
}

// 当状态改变时设置状态(State)就会调用这个方法
-(void)setState:(MSRefreshState)State
{
    _State = State;
    
    if (_State == _oldState) {
        return;
    }
    
    switch (_State) {
        // 普通状态 隐藏那个菊花
        case RefreshStateNormal:
            [self.arrowImage stopAnimating];
            break;
        // 释放刷新状态
        case RefreshStatePulling:
            break;
        // 正在刷新，1隐藏箭头，2显示菊花，3回调
        case RefreshStateRefreshing:
            [self.arrowImage startAnimating];
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
            break;
        default:
            break;
    }
}
/**
    初始化控件
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewDirection = MSRefreshDirectionHorizontal;
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.arrowImage.image = [UIImage imageNamed:@"loading_1"];
        self.arrowImage.tag = 500;
        
        NSMutableArray *imgArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 8; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d", @"loading_", (i+1)]];
            [imgArray addObject:image];
        }
        
        self.arrowImage.animationImages     = imgArray;
        self.arrowImage.animationDuration   = 0.5;
        self.arrowImage.animationRepeatCount = 999;
        [self addSubview:self.arrowImage];
        
        if (self.viewDirection == MSRefreshDirectionHorizontal) {
            self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        } else {
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.viewDirection == MSRefreshDirectionHorizontal) {
        self.arrowImage.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.4);
    } else {
        self.arrowImage.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
}

//显示到屏幕上
-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.State == WillRefreshing) {
        self.State = RefreshStateRefreshing;
    }
}

// MARK: ==============================让子类去重写=======================
-(void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    
    // 移走旧的父控件
    if (self.superview != nil) {
        [self.superview removeObserver:self forKeyPath:MSRefreshContentOffset];
    }
    if (newSuperview != nil) {
        [newSuperview addObserver:self forKeyPath:MSRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        CGRect rect = self.frame;
        // 设置宽度 位置
        if (_viewDirection == MSRefreshDirectionHorizontal) {
            rect.size.height    = newSuperview.frame.size.height;
            rect.origin.y       = 0;
            //self.frame = frame;
        } else {
            rect.size.width = newSuperview.frame.size.width;
            rect.origin.x   = 0;
            //self.frame = frame;
        }

        //UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

// 判断是否正在刷新
- (BOOL) isRefreshing {
    return RefreshStateRefreshing == self.State;
}

// 开始刷新
- (void) beginRefreshing {
    // self.State = RefreshState.Refreshing;
    if (self.window != nil) {
        self.State = RefreshStateRefreshing;
    } else {
        //不能调用set方法
        _State = WillRefreshing;
        [super setNeedsDisplay];
    }
}

//结束刷新
-(void) endRefreshing {
    if (self.State == RefreshStateNormal) {
        return;
    }
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        self.State = RefreshStateNormal;
    });
}

@end
