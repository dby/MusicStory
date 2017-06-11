//
//  MSAboutViewController.m
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSAboutViewController.h"

#import "MusicStory-Common-Header.h"

#import "SettingHeaderView.h"
#import "AboutCenterView.h"

@interface MSAboutViewController ()

@property (nonatomic, strong) SettingHeaderView *headerView;
@property (nonatomic, strong) AboutCenterView *aboutView;

@end

@implementation MSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildComponent];
    [self setupLayout];
}

#pragma mark - build

- (void)buildComponent {
    [self buildAboutView];
    [self setupNavView];
}

- (void)buildAboutView {
    _aboutView = [AboutCenterView centerView];
    [self.view addSubview:_aboutView];
}

- (void)setupNavView {
    debugMethod();
    _headerView = [SettingHeaderView headerView];
    _headerView.title.text = @"关于我们";
    [self.view addSubview:_headerView];
    [_headerView backBtnDidClickWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - private function

- (void)setupLayout {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(_headerView.height));
    }];
    [self.aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

@end
