//
//  MSPlayMusicView.h
//  MusicStory
//
//  Created by sys on 16/4/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMusicModel.h"

@interface MSPlayMusicView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *singer_portrait;
@property (weak, nonatomic) IBOutlet UILabel *singer_name;
@property (weak, nonatomic) IBOutlet UILabel *singer_brief;
@property (weak, nonatomic) IBOutlet UILabel *music_name;
@property (weak, nonatomic) IBOutlet UILabel *update_time;
@property (weak, nonatomic) IBOutlet UIButton *play_music;

@property (nonatomic, strong) MSMusicModel *model;


@end
