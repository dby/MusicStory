//
//  MSSlideViewController.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSlideViewController.h"

#import "MusicStory-Common-Header.h"

#import "MSBaseNavController.h"
#import "MSHomeViewController.h"
#import "MSLoginViewController.h"
#import "MSSearchViewController.h"
#import "MSSettingViewController.h"
#import "MSUserInfoViewController.h"

@interface MSSlideViewController () < MSSlideCenterViewDelegate>


@end

@implementation MSSlideViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.centerView];
    [self setLayout];
    self.view.backgroundColor = UI_COLOR_APPNORMAL;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftMenuSetupBackColor:) name:NOTIFY_SETUPBG object:nil];
}

#pragma mark - Private Function
- (void)setLayout {
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (void)leftMenuSetupBackColor:(NSNotification *)notify {

    UIColor *bg = notify.object;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = bg;
    }];
}

- (void)setContentViewController:(UIViewController *)viewController
{
    MSBaseNavController *nav = (MSBaseNavController *)self.sideMenuViewController.centerController;
    [nav pushViewController:viewController animated:NO];
}

#pragma mark - MSSlideCenterViewDelegate
-(void)slideCenterViewLoginViewDidClick {
    debugMethod();
    AVUser *user = [AVUser currentUser];
    if (user) {
        MSUserInfoViewController *infoController = [[MSUserInfoViewController alloc] init];
        [self.navigationController presentViewController:[[MSBaseNavController alloc] initWithRootViewController:infoController] animated:YES completion:nil];
    } else {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"LoginStoryBoard" bundle:[NSBundle mainBundle]];
        UIViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginView"];
        [self.navigationController presentViewController:
         [[MSBaseNavController alloc] initWithRootViewController:loginViewController]
                                                animated:YES
                                              completion:nil];
    }
}

// 音乐故事
-(void)slideCenterViewMusicStoryViewDidClick {
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HIDDEMENU object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETUPHOMEVIEWTYPE object:NOTIFY_OBJ_HOME];
}

// 音乐专栏
-(void)slideCenterViewMusicColumnViewDidClick {
    debugMethod();
}

// 我的收藏
-(void)slideCenterViewCollectViewDidClick {
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HIDDEMENU object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETUPHOMEVIEWTYPE object:NOTIFY_OBJ_COLLECTION];
}

// 赞我们一下
-(void)slideCenterViewPraiseUsViewDidClick {
    debugMethod();
}

// 搜索
-(void)slideCenterViewSearchViewDidClick {
    debugMethod();
    [self.navigationController presentViewController:[[MSBaseNavController alloc] initWithRootViewController:[[MSSearchViewController alloc] init]] animated:YES completion:nil];
}

// setting
-(void)slideCenterViewSettingsViewDidClick {
    debugMethod();
    MSSettingViewController *settingController = [[MSSettingViewController alloc] init];
    [self.navigationController presentViewController:[[MSBaseNavController alloc] initWithRootViewController:settingController] animated:YES completion:nil];
}

#pragma mark - Setter Getter
-(MSSlideCenterView *)centerView {
    
    if (!_centerView) {
        _centerView = [MSSlideCenterView centerView];
        _centerView.delegate = self;
        
        _centerView.curView = [[UIView alloc] init];
        _centerView.curView = self.centerView.musicStoryView;
        _centerView.indexView.y = self.centerView.musicStoryView.center.y;
    }
    return _centerView;
}

@end