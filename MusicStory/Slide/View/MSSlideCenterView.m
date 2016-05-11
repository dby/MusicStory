//
//  MSSlideCenterView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "AppConfig.h"
#import "UIView+MS.h"
#import "MSSlideCenterView.h"

@implementation MSSlideCenterView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.loginview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(loginViewDidClick)]];
    [self.musicStoryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(musicStoryDidClick)]];
    [self.collectView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(collectViewDidClick)]];
    [self.searchBtnDidClick addTarget:self action:@selector(searchBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.aboutUsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(aboutUsDidClick)]];
    [self.feedBackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(feedbackDidClick)]];
    
    // 默认选择音乐故事
    self.curView = self.musicStoryView;
    self.indexView.y = self.musicStoryView.center.y;
    debugMethod();
    
}

+(MSSlideCenterView *)centerView {
    
    debugMethod();
    return [[[NSBundle mainBundle] loadNibNamed:@"MSSlideCenterView" owner:nil options:nil] firstObject];
}

#pragma mark -- Click Event

- (void)loginViewDidClick {
    debugMethod();
    [self.delegate slideCenterViewLoginViewDidClick];
}

- (void)musicStoryDidClick {
    debugMethod();
    if (_curView == self.musicStoryView)
        return;
    self.curView        = self.musicStoryView;
    self.indexView.y    = self.musicStoryView.center.y;
    [self.delegate slideCenterViewLoginViewDidClick];
}

- (void)collectViewDidClick {
    debugMethod();
    if (_curView == self.collectView)
        return;
    self.curView        = self.collectView;
    self.indexView.y    = self.collectView.center.y;
    [self.delegate slideCenterViewCollectViewDidClick];
}

- (void)searchDidClick {
    debugMethod();
    [self.delegate slideCenterViewSearchViewDidClick];
}

- (void)aboutUsDidClick {
    debugMethod();
    if (_curView == self.aboutUsView)
        return;
    self.curView        = self.aboutUsView;
    self.indexView.y    = self.aboutUsView.center.y;
    [self.delegate slideCenterViewAboutUsViewDidClick];
}

- (void)feedbackDidClick {
    debugMethod();
    if (_curView == self.feedBackView)
        return;
    self.curView        = self.feedBackView;
    self.indexView.y    = self.feedBackView.center.y;
    //[self.delegate slideCenterViewFeedbackViewDidClick:self feedbackView:self.feedBackView];
}

@end
