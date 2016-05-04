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
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "UIView+MS.h"
#import "AppConfig.h"
#import "MSPlayView.h"

#import "MSDetailContentView.h"
#import "MSDetialHeaderView.h"

@interface MSHomeDetailViewController ()< MSDetailHeaderViewDelegate, UIScrollViewDelegate, PlayViewDelegate>

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
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(instancetype)initWithModel:(MSMusicModel *)model {
    
    self = [super init];
    if (self) {
        [self initComponent];
        [self setupLayout];
        self.model = model;
    }
    return self;
}

#pragma mark - init

- (void)initComponent {
    
    self.headerView             = [[MSDetialHeaderView alloc] init];
    self.headerView.delegate    = self;
    [self.view addSubview:self.headerView];
    
    self.contentView = [[MSDetailContentView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             SCREEN_WIDTH,
                                                                             SCREEN_HEIGHT)];
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
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(self.view.frame.size.height - self.headerView.frame.size.height));
    }];
    
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(@(self.view.width / 2 - 30));
    }];
}

#pragma mark - Custom Delegate

-(void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commentDidClick {
    debugMethod();
}

#pragma mark - UIScrollviewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 20) {
        _lastPosition = currentPostion;
        debugLog(@"Up...");
        [UIView animateWithDuration:0.2 animations:^{
            _playView.hidden = true;
        }];
    }
    else if (_lastPosition - currentPostion > 20)
    {
        _lastPosition = currentPostion;
        debugLog(@"Down...");
        [UIView animateWithDuration:0.2 animations:^{
            _playView.hidden = false;
        }];
    }
}

#pragma mark - PlayViewDelegate

-(void)playButtonDidClick:(BOOL)selected {
    debugMethod();
}

@end