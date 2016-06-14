//
//  MSHomeDetailToolView.h
//  MusicStory
//
//  Created by sys on 16/6/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMusicModel.h"

@protocol MSHomeDetailToolViewDelegate

- (void)homeDetailToolViewCollectBtnClick;
- (void)homeDetailToolViewShareBtnClick;
- (void)homeDetailToolViewDownloadBtnClick;

@end

@interface MSHomeDetailToolView : UIView

@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@property (nonatomic, strong) MSMusicModel *model;

@property (nonatomic, assign) id <MSHomeDetailToolViewDelegate> delegate;
+ (MSHomeDetailToolView *)toolView;

@end
