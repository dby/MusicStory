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
-(void)slideCenterViewLoginViewDidClick;
// 音乐故事
-(void)slideCenterViewMusicStoryViewDidClick;
// 我的收藏
-(void)slideCenterViewCollectViewDidClick;
// 搜索
-(void)slideCenterViewSearchViewDidClick;
// 关于我们
-(void)slideCenterViewAboutUsViewDidClick;
// 意见反馈
-(void)slideCenterViewFeedbackViewDidClick;
@end

@interface MSSlideCenterView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UIView *loginview;
@property (weak, nonatomic) IBOutlet UIView *musicStoryView;
@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *aboutUsView;
@property (weak, nonatomic) IBOutlet UIView *feedBackView;
@property (weak, nonatomic) IBOutlet UIImageView *indexView;
@property (assign, nonatomic) id<MSSlideCenterViewDelegate> delegate;

@property (weak, nonatomic) UIView* curView;

+(MSSlideCenterView *)centerView;

@end