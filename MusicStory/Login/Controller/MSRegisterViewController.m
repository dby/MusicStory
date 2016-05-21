//
//  MSRegisterViewController.m
//  MusicStory
//
//  Created by sys on 16/5/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSRegisterViewController.h"

#import "AppConfig.h"
#import "MSUserModel.h"

@interface MSRegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *smsVeriTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@end

@implementation MSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneNumLabel.text = self.phoneNumber;
    [self.loginButton addTarget:self action:@selector(registerDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)registerDidClick {
    debugMethod();
    NSString *smsC = _smsVeriTextField.text;
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:_phoneNumber smsCode:smsC block:^(AVUser *user, NSError *error) {
        if (!error) {
            debugLog(@"register success");
        } else {
            debugLog(@"SmsCode: %@", [error description]);
        }
    }];
}

@end
