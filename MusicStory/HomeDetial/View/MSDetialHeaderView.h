//
//  MSDetialHeaderView.h
//  MusicStory
//
//  Created by sys on 16/4/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMusicModel.h"

@protocol MSDetailHeaderViewDelegate

- (void)backButtonDidClick;
- (void)commentDidClick;
- (void)collectDidClick;

@end

@interface MSDetialHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (nonatomic, strong) MSMusicModel *model;
@property (assign, nonatomic) id<MSDetailHeaderViewDelegate> delegate;

@end
