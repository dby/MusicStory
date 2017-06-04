//
//  MSSlideCenterView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "AppConfig.h"

#import "MusicStory-Common-Header.h"

#import "MSSlideCenterView.h"

@implementation MSSlideCenterView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    debugMethod();
    
    self.portrait.layer.cornerRadius    = 25;
    self.portrait.layer.masksToBounds   = YES;
    self.indexView.centerY = self.musicStoryView.centerY;
    
    // 登陆
    [self.loginview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(loginViewDidClick)]];
    // 音乐故事
    [self.musicStoryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(musicStoryDidClick)]];
    // 音乐乐评
    [self.musicColumnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(musicColumnDidClick)]];
    // 有声小说
    [self.soundFictionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(soundFictionDidClick)]];
    // 音乐榜单
    [self.musicRankList addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(musicRankListDidClick)]];
    // 我的收藏
    [self.collectView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(collectViewDidClick)]];
    // 赞一下
    [self.praiseUsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(praiseUsDidClick)]];
    // 搜索
    [self.searchBtn addTarget:self action:@selector(searchBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置
    [self.settingsBtn addTarget:self action:@selector(settingBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateUserMsg];
}

#pragma mark - updateUserInfo
-(void)updateUserMsg {
    AVUser *user = [AVUser currentUser];
    if (user) {
        [self.portrait setImageWithURL:[NSURL URLWithString:[user objectForKey:@"portrait"]]
           usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.username setText:[user objectForKey:@"username"]];
    } else {
        [self.portrait setImage:[UIImage imageNamed:@"encourage_image"]];
        [self.username setText:@"微博登陆"];
    }
}

+(MSSlideCenterView *)centerView {
    
    debugMethod();
    return [[[NSBundle mainBundle] loadNibNamed:@"MSSlideCenterView" owner:nil options:nil] firstObject];
}

#pragma mark===Click Event===
// 登录事件
- (void)loginViewDidClick {
    debugMethod();
    self.curView = self.loginview;
    self.indexView.hidden = true;
    [self.delegate slideCenterViewLoginViewDidClick];
}
// 音乐故事事件
- (void)musicStoryDidClick {
    debugMethod();
    if (_curView == self.musicStoryView)
        return;
    self.curView            = self.musicStoryView;
    self.indexView.hidden   = false;
    self.indexView.centerY  = self.musicStoryView.center.y;
    [self.delegate slideCenterViewMusicStoryViewDidClick];
}
// 音乐乐评事件
- (void)musicColumnDidClick {
    debugMethod();
    if (_curView == self.musicColumnView)
        return;
    self.curView            = self.musicColumnView;
    self.indexView.hidden   = false;
    self.indexView.centerY  = self.musicColumnView.center.y;
    [self.delegate slideCenterViewMusicColumnViewDidClick];
}
// 有声小说事件
- (void)soundFictionDidClick {
    //debugMethod();
    if (_curView == self.soundFictionView)
        return;
    self.curView            = self.soundFictionView;
    self.indexView.hidden   = false;
    self.indexView.centerY  = self.soundFictionView.center.y;
    [self.delegate slideCenterViewSoundFictionViewDidClick];
}
// 音乐榜单事件
- (void)musicRankListDidClick {
    //debugMethod()
    if (_curView == self.musicRankList)
        return;
    self.curView            = self.musicRankList;
    self.indexView.hidden   = false;
    self.indexView.centerY  = self.musicRankList.center.y;
    [self.delegate slideCenterViewMusicRankListViewDidClik];
}
// 我的收藏事件
- (void)collectViewDidClick {
    debugMethod();
    if (_curView == self.collectView)
        return;
    self.curView            = self.collectView;
    self.indexView.hidden   = false;
    self.indexView.centerY  = self.collectView.center.y;
    [self.delegate slideCenterViewCollectViewDidClick];
}
// 赞我一下事件
- (void)praiseUsDidClick {
    debugMethod();
    if (_curView == self.praiseUsView)
        return;
    self.curView            = self.praiseUsView;
    self.indexView.hidden   = false;
    self.indexView.centerY  = self.praiseUsView.center.y;
    [self.delegate slideCenterViewPraiseUsViewDidClick];
}
// 搜索按钮事件
- (void)searchBtnDidClick {
    debugMethod();
    self.indexView.hidden = false;
    [self.delegate slideCenterViewSearchViewDidClick];
}
// 设置按钮事件
- (void)settingBtnDidClick {
    debugMethod();
    self.indexView.hidden = false;
    [self.delegate slideCenterViewSettingsViewDidClick];
}

@end
