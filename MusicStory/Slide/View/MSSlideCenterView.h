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
// 音乐乐评
- (void)slideCenterViewMusicColumnViewDidClick;
// 有声小说
- (void)slideCenterViewSoundFictionViewDidClick;
// 音乐榜单
- (void)slideCenterViewMusicRankListViewDidClik;
// 赞我一下
-(void)slideCenterViewPraiseUsViewDidClick;
// 我的收藏
-(void)slideCenterViewCollectViewDidClick;
// Settings
-(void)slideCenterViewSettingsViewDidClick;
// 搜索
-(void)slideCenterViewSearchViewDidClick;
@end

@interface MSSlideCenterView : UIView
// 用户登录
@property (weak, nonatomic) IBOutlet UILabel *username;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
// 用户登录所在的View
@property (weak, nonatomic) IBOutlet UIView *loginview;
// 音乐故事
@property (weak, nonatomic) IBOutlet UIView *musicStoryView;
// 音乐乐评
@property (weak, nonatomic) IBOutlet UIView *musicColumnView;
// 有声小说
@property (weak, nonatomic) IBOutlet UIView *soundFictionView;
// 音乐榜单
@property (weak, nonatomic) IBOutlet UIView *musicRankList;
// 我的收藏
@property (weak, nonatomic) IBOutlet UIView *collectView;
// 赞我一下
@property (weak, nonatomic) IBOutlet UIView *praiseUsView;
// 搜索按钮
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
// 小白点
@property (weak, nonatomic) IBOutlet UIImageView *indexView;
// settings
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;

@property (assign, nonatomic) id<MSSlideCenterViewDelegate> delegate;

@property (strong, nonatomic) UIView* curView;

+(MSSlideCenterView *)centerView;

@end
