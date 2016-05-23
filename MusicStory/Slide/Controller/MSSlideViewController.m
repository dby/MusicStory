//
//  MSSlideViewController.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSlideViewController.h"

#import "UIColor+MS.h"

#import <RESideMenu/RESideMenu.h>

#import "AppConfig.h"
#import "MSSlideCenterView.h"

#import "MSBaseNavController.h"
#import "MSHomeViewController.h"
#import "MSLoginViewController.h"
#import "MSHomeDetailViewController.h"

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

- (void)setContentViewController:(UIViewController *)viewController
{
    MSBaseNavController *nav = (MSBaseNavController *)self.sideMenuViewController.contentViewController;
    
    debugLog(@"sideMenuViewController: %@", self.sideMenuViewController);
    debugLog(@"contentViewController : %@", self.sideMenuViewController.contentViewController);
    
    [nav pushViewController:viewController animated:NO];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - MSSlideCenterViewDelegate

-(void)slideCenterViewLoginViewDidClick {
    debugMethod();
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"LoginStoryBoard" bundle:[NSBundle mainBundle]];
    UIViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginView"];
    [self.sideMenuViewController setContentViewController:loginViewController];
    [self.sideMenuViewController hideMenuViewController];
    //[self setContentViewController:loginViewController];
}

-(void)slideCenterViewSearchViewDidClick {
    debugMethod();
}

-(void)slideCenterViewAboutUsViewDidClick {
    debugMethod();
}

-(void)slideCenterViewCollectViewDidClick {
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETUPHOMEVIEWTYPE object:NOTIFY_OBJ_COLLECTION];
    [self.sideMenuViewController hideMenuViewController];
}

-(void)slideCenterViewFeedbackViewDidClick {
    debugMethod();
}
-(void)slideCenterViewMusicStoryViewDidClick {
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETUPHOMEVIEWTYPE object:NOTIFY_OBJ_HOME];
    //MSHomeViewController *hvc = [[MSHomeViewController alloc] init];
    //[self.sideMenuViewController setContentViewController: [[MSBaseNavController alloc] initWithRootViewController:hvc] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

@end
