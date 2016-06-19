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
#import "MSSlideViewController.h"

#import "MSUserModel.h"

#import "MusicStory-Common-Header.h"


@interface MSVerifyPwdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) UIButton *returnBtn;
@end

@implementation MSVerifyPwdViewController

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self buildReturnBtn];
    [self setupLayout];
    
    _phoneNumberLabel.text = _phoneNumber;
    [_loginButton addTarget:self action:@selector(loginWithPwd) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - custom function

- (Boolean)validatePwd {
    
    if ([self.pwdTextField.text isEqualToString:@""] == 1) {
        NSLog(@"%@", [SVProgressHUD class]);
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return false;
    }
    return true;
}

- (void)buildReturnBtn {
    debugMethod();
    _returnBtn = [[UIButton alloc] init];
    [_returnBtn addTarget:self action:@selector(returnBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_pressed"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:_returnBtn];
}

- (void)returnBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setupLayout {
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_leftMargin).offset(10);
        make.topMargin.equalTo(self.view.mas_topMargin).offset(40);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
}

- (void)loginWithPwd {
    debugMethod();
    if (![self validatePwd]) {
        return;
    }
    [self showProgress];
    [AVUser logInWithMobilePhoneNumberInBackground:self.phoneNumber password:_pwdTextField.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            debugLog(@"SUCCESS");
            [self hiddenProgress];
            [AVUser changeCurrentUser:user save:YES];
            NSLog(@"sideViewController: %@", self.sideMenuViewController);
            if (self.sideMenuViewController.leftController) {
                MSSlideViewController *sliderController = self.sideMenuViewController.leftController.childViewControllers.firstObject;
                [sliderController.centerView.portrait setImageWithURL:[NSURL URLWithString:[user objectForKey:@"portrait"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [self hiddenProgress];
            [SVProgressHUD setMinimumDismissTimeInterval:0.2];
            [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:@"error"]];
            debugLog(@"FAIL: %@", [error.userInfo objectForKey:@"error"]);
        }
    }];
}

@end
