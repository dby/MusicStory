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

static void *kStatusKVOKey          = &kStatusKVOKey;
static void *kDurationKVOKey        = &kDurationKVOKey;
static void *kBufferingRatioKVOKey  = &kBufferingRatioKVOKey;

@interface MSPlayMusicView()
{
      DOUAudioStreamer *_streamer;
}

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
        
        _track = [[Track alloc] init];
        
        [self.play_music addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
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
        
        _track = [[Track alloc] init];
        
        [self.play_music addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
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

-(void)playMusic {
    if (_model) {
        
        debugMethod();
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://douban.fm/j/mine/playlist?type=n&channel=1004693"]];
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:NULL
                                                             error:NULL];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            [_track setAudioFileURL:[NSURL URLWithString:@"http://ac-xjvf4uf6.clouddn.com/a45a76b04cd7ef09.mp3"]];
            
            _streamer = [DOUAudioStreamer streamerWithAudioFile:_track];
            //[_streamer addObserver:self forKeyPath:@"status"    options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
            //[_streamer addObserver:self forKeyPath:@"duration"  options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
            //[_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
            
            [_streamer play];
        });
    }
}

@end
