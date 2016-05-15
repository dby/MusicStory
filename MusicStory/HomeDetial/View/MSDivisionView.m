//
//  MSDivisionView.m
//  MusicStory
//
//  Created by sys on 16/5/11.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSDivisionView.h"
#import "UIView+MS.h"

@implementation MSDivisionView

-(instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSDivisionView" owner:nil options:nil].firstObject;
        self.seperateLine.backgroundColor = [UIColor lightGrayColor];
        self.seperateLine.height = 2;
        
        [self.storyBtn setBackgroundImage:[UIImage imageNamed:@"music_story_selected"] forState:UIControlStateSelected];
        [self.lyricsBtn setBackgroundImage:[UIImage imageNamed:@"music_lyric_selected"] forState:UIControlStateSelected];
        
        [self.storyBtn addTarget:self action:@selector(showStory) forControlEvents:UIControlEventTouchUpInside];
        [self.lyricsBtn addTarget:self action:@selector(showLyrics) forControlEvents:UIControlEventTouchUpInside];
        
        self.storyBtn.selected  = true;
        self.lyricsBtn.selected = false;
    }
    return self;
}

-(void)showStory {
    self.infoLabel.text     = @"音乐故事";
    self.storyBtn.selected  = true;
    self.lyricsBtn.selected = false;
    [self.delegate storyBtnDidClick];
}

-(void)showLyrics {
    self.infoLabel.text     = @"歌词";
    self.lyricsBtn.selected = true;
    self.storyBtn.selected  = false;
    [self.delegate lyricsBtnDidClick];
}

@end
