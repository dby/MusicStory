//
//  MSHomeDetailViewController.m
//  MusicStory
//
//  Created by sys on 16/4/23.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDetailViewController.h"

#import "Masonry.h"
#import "GRMustache.h"
#import "SVProgressHUD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "UIView+MS.h"
#import "AppConfig.h"
#import "MSPlayView.h"

#import "MSDivisionView.h"
#import "MSDetailContentView.h"
#import "MSDetialHeaderView.h"

@interface MSHomeDetailViewController ()<MSDetailHeaderViewDelegate, UIScrollViewDelegate, PlayViewDelegate, DivisionDelegate>

@property (nonatomic, strong) MSDetialHeaderView    *headerView;
@property (nonatomic, strong) MSDetailContentView   *contentView;
@property (nonatomic, strong) MSPlayView *playView;

@property (nonatomic, assign) NSInteger lastPosition;

@end

@implementation MSHomeDetailViewController

@synthesize model = _model;

#pragma mark - Setter Getter

-(MSMusicModel *)model {
    return _model;
}

-(void)setModel:(MSMusicModel *)model {
    _model = model;
    _contentView.model = model;
    _playView.model = model;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    debugMethod();
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    debugMethod();
    if (_playView) {
        [_playView stop];
    }
}

#pragma mark - init

-(instancetype)initWithModel:(MSMusicModel *)model {
    
    self = [super init];
    if (self) {
        [self initComponent];
        [self setupLayout];
        self.model = model;
    }
    return self;
}

- (void)initComponent {
    
    self.headerView             = [[MSDetialHeaderView alloc] init];
    self.headerView.delegate    = self;
    [self.view addSubview:self.headerView];
    
    self.contentView = [[MSDetailContentView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             SCREEN_WIDTH,
                                                                             SCREEN_HEIGHT)];
    self.contentView.delegate = self;
    self.contentView.divisionView.delegate = self;
    [self.view addSubview:_contentView];
  
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _playView = [[MSPlayView alloc] init];
    _playView.delegate = self;
    [self.view addSubview:_playView];
    
    _lastPosition = 0;
}

#pragma mark - Custom Function

- (void)setupLayout {
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@(SCREEN_HEIGHT * 50 / IPHONE5_HEIGHT));
        make.left.right.equalTo(self.view);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(@(self.view.width / 2 - 30));
    }];
}

#pragma mark - MSDetailHeaderViewDelegate

-(void)backButtonDidClick {
    debugMethod();
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commentDidClick {
    debugMethod();
}

-(void)collectDidClick {
    debugMethod();
    AVUser *user    = [AVUser currentUser];
    AVObject *obj   = [MSMusicModel MusicModelToAVObject:_model];
    
    [AVObject saveAllInBackground:@[obj] block:^(BOOL succeeded, NSError *error) {
        if (error) {
        } else {
            // 保存成功
            AVRelation *relation = [user relationForKey:@"musics_collections"];
            [relation addObject:obj];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    
                } else {
                    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
                    [SVProgressHUD showSuccessWithStatus:error.debugDescription];
                }
            }];
            
            debugLog(@"success success...");
        }
    }];
}

#pragma mark - UIScrollviewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 20) {
        _lastPosition = currentPostion;
        
        [UIView animateWithDuration:1.0 animations:^{
            _playView.hidden = true;
        }];
    }
    else if (_lastPosition - currentPostion > 20)
    {
        _lastPosition = currentPostion;
        
        [UIView animateWithDuration:1.0 animations:^{
            _playView.hidden = false;
        }];
    }
}

#pragma mark - PlayViewDelegate
-(void)playButtonDidClick:(BOOL)selected {
    if (selected) {
        [_playView.contentIV sd_setImageWithURL:[NSURL URLWithString:_model.music_imgs]];
        [_playView play];
    } else {
        [_playView pause];
    }
}

#pragma mark - Division Delegate
-(void)lyricsBtnDidClick {
    debugMethod();
    [self.contentView updateWebView:_model.music_lyrics];
}

-(void)storyBtnDidClick {
    debugMethod();
    [self.contentView updateWebView:_model.music_story];
}
@end