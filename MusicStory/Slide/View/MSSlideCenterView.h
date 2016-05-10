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
-(void)slideCenterViewLoginViewDidClick         :(MSSlideCenterView *)centerView loginView:(UIView *) loginView;
// 音乐故事
-(void)slideCenterViewMusicStoryViewDidClick    :(MSSlideCenterView *)centerView musicStoryView:(UIView *)musicStoryView;
// 我的收藏
-(void)slideCenterViewCollectViewDidClick       :(MSSlideCenterView *)centerView collectView:(UIView *)collectView;
// 搜索
-(void)slideCenterViewSearchViewDidClick        :(MSSlideCenterView *)centerView searchView:(UIView *)searchView;
// 关于我们
-(void)slideCenterViewAboutUsViewDidClick       :(MSSlideCenterView *)centerView aboutUsView:(UIView *)aboutUsView;
// 意见反馈
-(void)slideCenterViewFeedbackViewDidClick      :(MSSlideCenterView *)centerView feedbackView:(UIView *)feedbackView;
@end

@interface MSSlideCenterView : UIView

@property (weak, nonatomic) IBOutlet UIView *loginview;
@property (weak, nonatomic) IBOutlet UIView *musicStoryView;
@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtnDidClick;
@property (weak, nonatomic) IBOutlet UIView *aboutUsView;
@property (weak, nonatomic) IBOutlet UIView *feedBackView;
@property (weak, nonatomic) IBOutlet UIImageView *indexView;
@property (assign, nonatomic) id<MSSlideCenterViewDelegate> delegate;

@property (weak, nonatomic) UIView* curView;

+(MSSlideCenterView *)centerView;

@end
