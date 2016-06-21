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
    
    // 登陆
    [self.loginview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(loginViewDidClick)]];
    // 音乐故事
    [self.musicStoryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(musicStoryDidClick)]];
    // 我的收藏
    [self.collectView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(collectViewDidClick)]];
    // 赞一下
    [self.praiseUsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(praiseUsDidClick)]];
    // 音乐专栏
    [self.musicColumnView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(musicColumnDidClick)]];
    
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
    }
}

+(MSSlideCenterView *)centerView {
    
    debugMethod();
    return [[[NSBundle mainBundle] loadNibNamed:@"MSSlideCenterView" owner:nil options:nil] firstObject];
}

#pragma mark -- Click Event

- (void)loginViewDidClick {
    debugMethod();
    self.curView = self.loginview;
    self.indexView.hidden = true;
    [self.delegate slideCenterViewLoginViewDidClick];
}

- (void)musicStoryDidClick {
    debugMethod();
    if (_curView == self.musicStoryView)
        return;
    self.curView            = self.musicStoryView;
    self.indexView.hidden   = false;
    self.indexView.y        = self.musicStoryView.center.y;
    [self.delegate slideCenterViewMusicStoryViewDidClick];
}

- (void)collectViewDidClick {
    debugMethod();
    if (_curView == self.collectView)
        return;
    self.curView            = self.collectView;
    self.indexView.hidden   = false;
    self.indexView.y        = self.collectView.center.y;
    [self.delegate slideCenterViewCollectViewDidClick];
}

- (void)searchBtnDidClick {
    debugMethod();
    self.indexView.hidden = false;
    [self.delegate slideCenterViewSearchViewDidClick];
}

- (void)praiseUsDidClick {
    debugMethod();
    if (_curView == self.praiseUsView)
        return;
    self.curView            = self.praiseUsView;
    self.indexView.hidden   = false;
    self.indexView.y        = self.praiseUsView.center.y;
    [self.delegate slideCenterViewPraiseUsViewDidClick];
}

- (void)musicColumnDidClick {
    debugMethod();
    if (_curView == self.musicColumnView)
        return;
    self.curView            = self.musicColumnView;
    self.indexView.hidden   = false;
    self.indexView.y        = self.musicColumnView.center.y;
    [self.delegate slideCenterViewMusicColumnViewDidClick];
}

- (void)settingBtnDidClick {
    debugMethod();
    self.indexView.hidden = false;
    [self.delegate slideCenterViewSettingsViewDidClick];
}

@end
