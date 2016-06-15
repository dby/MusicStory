//
//  MSVerifyPwdViewController.m
//  MusicStory
//
//  Created by sys on 16/5/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSVerifyPwdViewController.h"

#import "MSBaseNavController.h"
#import "MSHomeViewController.h"

#import "MSUserModel.h"

#import "MusicStory-Common-Header.h"


@interface MSVerifyPwdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@end

@implementation MSVerifyPwdViewController

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    _phoneNumberLabel.text = _phoneNumber;
    [_loginButton addTarget:self action:@selector(loginWithPwd) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginWithPwd {
    debugMethod();
    [_indicatorView startAnimating];
    [AVUser logInWithMobilePhoneNumberInBackground:self.phoneNumber password:_pwdTextField.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            debugLog(@"SUCCESS");
            [_indicatorView stopAnimating];
            [AVUser changeCurrentUser:user save:YES];
            //MSHomeViewController *hvc = [[MSHomeViewController alloc] init];
            //[self.sideMenuViewController setContentViewController: [[MSBaseNavController alloc] initWithRootViewController:hvc] animated:YES];
            //[self.sideMenuViewController hideMenuViewController];
            
        } else {
            [_indicatorView stopAnimating];
            [SVProgressHUD setMinimumDismissTimeInterval:0.2];
            [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:@"error"]];
            debugLog(@"FAIL: %@", [error.userInfo objectForKey:@"error"]);
        }
    }];
}

@end
