//
//  MSSlideViewController.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSlideViewController.h"

#import "UIColor+MS.h"
#import "AppConfig.h"
#import "MSSlideCenterView.h"

@interface MSSlideViewController () < MSSlideCenterViewDelegate>

@property (nonatomic, strong) MSSlideCenterView *centerView;

@end

@implementation MSSlideViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComponents];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftMenuSetupBackColor:) name:NOTIFY_SETUPBG object:nil];
}

#pragma mark - Init

-(void)initComponents {
    self.centerView = [MSSlideCenterView centerView];
    self.centerView.delegate = self;
    
    [self.view addSubview:self.centerView];
}

#pragma mark - Private Function

- (void)leftMenuSetupBackColor:(NSNotification *)notify {

    NSString *bg = notify.object;
    self.view.backgroundColor = [UIColor colorWithHexString:bg];
}

#pragma mark - MSSlideCenterViewDelegate

-(void)slideCenterViewLoginViewDidClick {
    debugMethod();
}

-(void)slideCenterViewSearchViewDidClick {
    debugMethod();
}

-(void)slideCenterViewAboutUsViewDidClick {
    debugMethod();
}

-(void)slideCenterViewCollectViewDidClick {
    debugMethod();
}

-(void)slideCenterViewFeedbackViewDidClick {
    debugMethod();
}
-(void)slideCenterViewMusicStoryViewDidClick {
    debugMethod();
}

@end
