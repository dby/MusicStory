//
//  MSPlayMusicView.m
//  MusicStory
//
//  Created by sys on 16/4/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSPlayMusicView.h"

#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface MSPlayMusicView()

@end

@implementation MSPlayMusicView

@synthesize model = _model;

#pragma mark - Life Cycle

-(instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSPlayMusicView" owner:nil options:nil].firstObject;
        
        _singer_portrait.frame = CGRectMake(0, 0, 50, 50);
        _singer_portrait.layer.cornerRadius     = 25;
        _singer_portrait.layer.masksToBounds    = YES;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSPlayMusicView" owner:nil options:nil].firstObject;
        
        _singer_portrait.frame = CGRectMake(0, 0, 50, 50);
        _singer_portrait.layer.cornerRadius     = 25;
        _singer_portrait.layer.masksToBounds    = YES;
    }
    return self;
}
#pragma mark - Setter Getter

-(MSMusicModel *)model {
    return _model;
}

-(void)setModel:(MSMusicModel *)model {
    
    _model              = model;
    _singer_name.text   = model.singer_name;
    _singer_brief.text  = model.singer_brief;
    _music_name.text    = model.music_name;
    _update_time.text   = model.publish_date;
    
    [_singer_portrait setImageWithURL:[NSURL URLWithString:model.singer_portrait] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - Custom Function

@end
