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

#import "MusicStory-Common-Header.h"

@interface MSRegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *smsVeriTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) UIButton *returnBtn;
@end

@implementation MSRegisterViewController

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    [self buildReturnBtn];
    [self setupLayout];
    
    self.phoneNumLabel.text = self.phoneNumber;
    //[self.smsVeriTextField becomeFirstResponder];
    [self.loginButton addTarget:self action:@selector(registerDidClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setupLayout {
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_leftMargin).offset(10);
        make.topMargin.equalTo(self.view.mas_topMargin).offset(40);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
}

- (void)registerDidClick {
    debugMethod();
    NSString *smsC = _smsVeriTextField.text;
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:_phoneNumber smsCode:smsC block:^(AVUser *user, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
            debugLog(@"SmsCode: %@", [error description]);
        }
    }];
}

@end