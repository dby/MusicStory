//
//  MSPlayView.m
//  MusicStory
//
//  Created by sys on 16/5/4.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSPlayView.h"

#import <BlocksKit/BlocksKit.h>
#import "UIControl+BlocksKit.h"

#import "DOUAudioFile.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"

#import "Track.h"

#import "MusicStory-Common-Header.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface MSPlayView ()
{
    DOUAudioStreamer *_streamer;
}
// 设置一个私有的定时器
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic, strong) Track *track;
@end

//宏定义   角度转弧度
#define angleToRadian(x) (x/180.0*M_PI)
@implementation MSPlayView

#pragma mark - Life Cycle
- (instancetype)init {
    debugMethod();
    if (self = [super init]) {
        
        [self.circleIV    addSubview:self.contentIV];
        [self.backgoundIV addSubview:self.circleIV];
        [self addSubview:self.backgoundIV];
        [self addSubview:self.playButton];
        
        self.userInteractionEnabled         = YES;
        [self setupLayout];
    }
    return self;
}

- (void)dealloc {
    debugLog(@"dealloc");
    [_streamer removeObserver:self forKeyPath:@"status" context:kStatusKVOKey];
    [_streamer removeObserver:self forKeyPath:@"duration" context:kDurationKVOKey];
    [_streamer removeObserver:self forKeyPath:@"bufferingRatio" context:kBufferingRatioKVOKey];
}

#pragma mark - Private Function
- (void)setupLayout {
    [self.backgoundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.circleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(2);
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-8);
    }];
    [self.contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(2);
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-7);
    }];
}

- (void)play {
    debugMethod();
    if ([_streamer status] == DOUAudioStreamerPaused || [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.track setAudioFileURL:[NSURL URLWithString:self.model.music_url]];
            _streamer = [DOUAudioStreamer streamerWithAudioFile:self.track];
            [_streamer addObserver:self forKeyPath:@"status"
                           options:NSKeyValueObservingOptionNew
                           context:kStatusKVOKey];
            
            [_streamer addObserver:self
                        forKeyPath:@"duration"
                           options:NSKeyValueObservingOptionNew
                           context:kDurationKVOKey];
            
            [_streamer addObserver:self
                        forKeyPath:@"bufferingRatio"
                           options:NSKeyValueObservingOptionNew
                           context:kBufferingRatioKVOKey];
        
            [_streamer play];
        });
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    debugMethod();
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    } else if (context == kDurationKVOKey) {
        
    } else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(updateBufferingRate) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    } else {
        
    }
}

- (void)updateBufferingRate {
    [JDStatusBarNotification showProgress:[_streamer bufferingRatio]];
}

- (void)updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying: {
            debugLog(@"playing");
            break;
        }
        case DOUAudioStreamerPaused: {
            debugLog(@"paused");
            break;
        }
        case DOUAudioStreamerIdle: {
            debugLog(@"idle");
            break;
        }
        case DOUAudioStreamerFinished: {
            debugLog(@"Finished");
            [_streamer stop];
            if ([self.delegate respondsToSelector:@selector(playButtonDidClick:)]) {
                self.playButton.selected = !self.playButton.selected;
                self.link.paused         = !self.playButton.selected;
                [self.delegate playButtonDidClick:self.playButton.selected];
            }
            break;
        }
        case DOUAudioStreamerBuffering: {
            debugLog(@"buffering");
            break;
        }
        case DOUAudioStreamerError: {
            debugLog(@"error");
            break;
        }
    }
}

- (void)pause {
    [_streamer pause];
}

- (void)stop {
    [_streamer stop];
}

/**  背景图rotation滚动 */
- (void)rotation {
    self.circleIV.layer.transform = CATransform3DRotate(self.circleIV.layer.transform, angleToRadian(72/60.0), 0, 0, 1);
}

#pragma mark - Setter Getter
-(UIImageView *)circleIV {
    if (!_circleIV) {
        _circleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_loop"]];
        _circleIV.contentMode = UIViewContentModeScaleAspectFit;
        _circleIV.userInteractionEnabled = YES;
    }
    return _circleIV;
}

-(UIImageView *)backgoundIV {
    if (!_backgoundIV) {
        _backgoundIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_normal"]];
        _backgoundIV.width  = 50;
        _backgoundIV.height = 50;
        _backgoundIV.contentMode = UIViewContentModeScaleAspectFit;
        _backgoundIV.userInteractionEnabled = YES;
    }
    return _backgoundIV;
}

- (UIImageView *)contentIV {
    debugMethod();
    if (!_contentIV) {
        _contentIV = [[UIImageView alloc] init];
        _contentIV.userInteractionEnabled = YES;
        _contentIV.contentMode = UIViewContentModeScaleAspectFit;
        
        // KVO观察image变化, 变化了就初始化定时器, 值变化则执行task, BlockKit框架对通知的一个拓展
//        [_contentIV bk_addObserverForKeyPath:@"image" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
//            // 启动定时器
//            self.link.paused = NO;
//            self.playButton.selected = YES;
//        }];
        
        // 作圆内容视图背景
        _contentIV.layer.cornerRadius = 25;
        _contentIV.clipsToBounds = YES;
    }
    return _contentIV;
}

- (CADisplayLink *)link {
    debugMethod();
    if (!_link) {
        // 创建定时器, 一秒钟调用rotation方法60次
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation)];
        // 手动将定时器加入到事件循环中
        // NSRunLoopCommonModes会使得RunLoop会随着界面切换扔继续使用, 不然如果使用Default的话UI交互没问题, 但滑动TableView就会出现不转问题, 因为RunLoop模式改变会影响定时器调度
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

- (UIButton *)playButton {
    debugMethod();
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 去掉长按高亮
        [_playButton setHighlighted:NO];
        
        // 被点击后 "avatar_bg" 透明
        [_playButton setBackgroundImage:[UIImage imageNamed:@"avatar_bg"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"toolbar_pause_h_p"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"tabbar_np_play"] forState:UIControlStateNormal];
        
        // 按钮点击后做的方法
        [_playButton bk_addEventHandler:^(UIButton* sender) {
            // 点击图和不点击图交换
            if ([self.delegate respondsToSelector:@selector(playButtonDidClick:)]) {
                sender.selected     = !sender.selected;
                self.link.paused    = !sender.selected;
                [self.delegate playButtonDidClick:sender.selected];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

-(Track *)track {
    if (!_track) {
        _track = [[Track alloc] init];
    }
    return _track;
}

@end