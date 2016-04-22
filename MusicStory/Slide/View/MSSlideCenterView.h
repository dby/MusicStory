//
//  MSSlideCenterView.h
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSSlideCenterView;

@protocol MSSlideCenterViewDelegate
// 点击登陆
- (void)slideCenterViewLoginViewDidClick :(MSSlideCenterView *)centerView loginView:(UIView *) loginView;
// 推荐
- (void)slideCenterViewRecommendViewDidClick :(MSSlideCenterView *)centerViews recommendView:(UIView *)recommendView;
// 收藏
- (void)slideCenterViewCollectViewDidClick :(MSSlideCenterView *)centerView collectView:(UIView *)collectView;
// 搜索
- (void)slideCenterViewSearchViewDidClick :(MSSlideCenterView *)centerView searchView:(UIView *)searchView;
// 设置
- (void)slideCenterViewSettingViewDidClick :(MSSlideCenterView *)centerView settingView:(UIView *)settingView;
@end

@interface MSSlideCenterView : UIView

@property (weak, nonatomic) IBOutlet UIView *loginview;
@property (weak, nonatomic) IBOutlet UIView *recommandView;
@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtnDidClick;
@property (assign, nonatomic) id<MSSlideCenterViewDelegate> delegate;

@property (weak, nonatomic) UIView* curView;

+(MSSlideCenterView *)centerView;

@end
