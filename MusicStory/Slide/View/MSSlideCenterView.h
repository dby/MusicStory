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
// 音乐专栏
- (void)slideCenterViewMusicColumnViewDidClick;
// 我的收藏
-(void)slideCenterViewCollectViewDidClick;
// 赞我一下
-(void)slideCenterViewPraiseUsViewDidClick;
// Settings
-(void)slideCenterViewSettingsViewDidClick;
// 搜索
-(void)slideCenterViewSearchViewDidClick;
@end

@interface MSSlideCenterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UIView *loginview;
@property (weak, nonatomic) IBOutlet UIView *musicStoryView;
@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *praiseUsView;
@property (weak, nonatomic) IBOutlet UIView *musicColumnView;
@property (weak, nonatomic) IBOutlet UIImageView *indexView;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (assign, nonatomic) id<MSSlideCenterViewDelegate> delegate;

@property (strong, nonatomic) UIView* curView;

+(MSSlideCenterView *)centerView;

@end