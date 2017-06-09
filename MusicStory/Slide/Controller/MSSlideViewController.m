//
//  MSSlideViewController.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSlideViewController.h"

#import "MusicStory-Common-Header.h"

#import "MusicContributionController.h"
#import "MSBaseNavController.h"
#import "MSHomeViewController.h"
#import "MSLoginViewController.h"
#import "MSSearchViewController.h"
#import "MSSettingViewController.h"
#import "MSUserInfoViewController.h"

@interface MSSlideViewController () < MSSlideCenterViewDelegate>

@end

@implementation MSSlideViewController

#pragma mark===Life Cycle===
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.centerView];
    [self setLayout];
    self.view.backgroundColor = UI_COLOR_APPNORMAL;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftMenuSetupBackColor:) name:NOTIFY_SETUPBG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAvatar) name:NOTIFY_UPDATE_USER_AVATAR object:nil];
}

#pragma mark===Function===
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

- (void)updateUserAvatar {
    if ([AVUser currentUser]) {
        [self.centerView.portrait setImageWithURL:[NSURL URLWithString:[[AVUser currentUser] objectForKey:@"portrait"]]
                      usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.centerView.username setText:[AVUser currentUser].username];
    } else {
        [self.centerView.portrait setImage:[UIImage imageNamed:@"encourage_image"]];
        [self.centerView.username setText:@"微博登陆"];
    }
}

- (void)setContentViewController:(UIViewController *)viewController {
    MSBaseNavController *nav = (MSBaseNavController *)self.sideMenuViewController.centerController;
    [nav pushViewController:viewController animated:NO];
}

#pragma mark===MSSlideCenterViewDelegate===

- (void)alert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)filterError:(NSError *)error {
    if (error) {
        [self alert:[error localizedDescription]];
        return NO;
    }
    return YES;
}

// 登录
-(void)slideCenterViewLoginViewDidClick {
    debugMethod();
    AVUser *user = [AVUser currentUser];
    if (user) {
        MSUserInfoViewController *infoController = [[MSUserInfoViewController alloc] init];
        [self.navigationController presentViewController:[[MSBaseNavController alloc] initWithRootViewController:infoController] animated:YES completion:nil];
    } else {
        //  使用手机号+密码登陆，，
        //        UIStoryboard *story = [UIStoryboard storyboardWithName:@"LoginStoryBoard" bundle:[NSBundle mainBundle]];
        //        UIViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginView"];
        //        [self.navigationController presentViewController:
        //         [[MSBaseNavController alloc] initWithRootViewController:loginViewController]
        //                                                animated:YES
        //                                              completion:nil];
        
        // 第三方微博登陆
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (error) {
                NSLog(@"%@", error.description);
            } else {
                [self.centerView.portrait sd_setImageWithURL:[NSURL URLWithString:object[@"avatar"]]];
                [self.centerView.username setText:object[@"username"]];
                
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        // 更新用户名，头像
                        AVUser *user = [AVUser currentUser];
                        [user setObject:object[@"username"] forKey:@"username"];
                        [user setObject:object[@"avatar"] forKey:@"portrait"];
                        [user saveInBackground];
                    }
                }];
            }
        } toPlatform:AVOSCloudSNSSinaWeibo];
    }
}

// 音乐故事
-(void)slideCenterViewMusicStoryViewDidClick {
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HIDDEMENU object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETUPHOMEVIEWTYPE object:NOTIFY_OBJ_music_story];
}

// 音乐专栏
-(void)slideCenterViewMusicColumnViewDidClick {
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HIDDEMENU object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETUPHOMEVIEWTYPE object:NOTIFY_OBJ_music_article];
}

// 音乐榜单
-(void)slideCenterViewMusicRankListViewDidClik {
}

// 音乐投稿
-(void)slideCenterViewMusicContributionViewDidClick {
    MusicContributionController *controller = [MusicContributionController new];
    [self presentViewController:controller animated:true completion:nil];
}

// 我的收藏
-(void)slideCenterViewCollectViewDidClick {
    debugMethod();
    AVUser *user = [AVUser currentUser];
    if (user == NULL) {
        [SVProgressHUD showErrorWithStatus:@"温馨提示：请先登录..."];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HIDDEMENU object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETUPHOMEVIEWTYPE object:NOTIFY_OBJ_music_collection];
}

// 赞我一下
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
        _centerView.indexView.centerY = self.centerView.musicStoryView.center.y;
    }
    return _centerView;
}

@end
