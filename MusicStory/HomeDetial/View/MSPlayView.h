//
//  MSPlayView.h
//  MusicStory
//
//  Created by sys on 16/5/4.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMusicModel.h"

@protocol PlayViewDelegate <NSObject>

- (void)playButtonDidClick:(BOOL)selected;

@end

@interface MSPlayView : UIView

@property (nonatomic, strong) UIImageView *circleIV;
@property (nonatomic, strong) UIImageView *contentIV;
@property (nonatomic, strong) UIImageView *backgoundIV;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) MSMusicModel *model;
@property (nonatomic, weak) id<PlayViewDelegate> delegate;

- (void)play;
- (void)pause;
- (void)stop;

@end
