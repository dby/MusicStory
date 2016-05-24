//
//  MSLoginViewController.m
//  MusicStory
//
//  Created by sys on 16/5/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSLoginViewController.h"

#import "AppConfig.h"
#import "MSUserModel.h"

#import "MSBaseNavController.h"
#import "MSHomeViewController.h"
#import "MSVerifyPwdViewController.h"

#import <AVOSCloud/AVOSCloud.h>
#import <RESideMenu/RESideMenu.h>

@interface MSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation MSLoginViewController

#pragma mark - Life Cycle

-(void)viewWillDisappear:(BOOL)animated {
    debugMethod();
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    //[self isHaveLogined];
    //[self buildComponent];
}

- (void)buildComponent {
    
}

#pragma mark - Custom Function

- (void)isHaveLogined {
    debugMethod();
    AVUser *user = [AVUser currentUser];
    if (user) {
        MSHomeViewController *hvc = [[MSHomeViewController alloc] init];
        [self.sideMenuViewController setContentViewController: [[MSBaseNavController alloc] initWithRootViewController:hvc] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}

- (IBAction)login:(id)sender {
    debugMethod();
    [_indicatorView startAnimating];
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneNumTextField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSArray<AVObject *> *users = objects;
            if ([users count] == 0) {
                // 数据库中没有用户名，
                [AVOSCloud requestSmsCodeWithPhoneNumber:@"15529316035" callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                       //跳转到注册界面-->验证码
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"LoginStoryBoard" bundle:[NSBundle mainBundle]];
                        MSVerifyPwdViewController *vc = [story instantiateViewControllerWithIdentifier:@"msregisterviewcontroller"];
                        vc.phoneNumber = self.phoneNumTextField.text;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    } else {
                        debugLog(@"%@", [error description]);
                    }
                }];
                
            } else {
                // 数据库中有此用户名，跳转到登陆界面
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"LoginStoryBoard" bundle:[NSBundle mainBundle]];
                MSVerifyPwdViewController *vc = [story instantiateViewControllerWithIdentifier:@"verifypwdviewcontroller"];
                vc.phoneNumber = self.phoneNumTextField.text;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            debugLog(@"error");
        }
        [_indicatorView stopAnimating];
    }];
}

@end
