//
//  MSLoginViewController.m
//  MusicStory
//
//  Created by sys on 16/5/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSLoginViewController.h"

#import "MSUserModel.h"

#import "MSBaseNavController.h"
#import "MSHomeViewController.h"
#import "MSVerifyPwdViewController.h"

#import "MusicStory-Common-Header.h"

@interface MSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (nonatomic, strong) UIButton *returnBtn;

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
    
    [self isHaveLogined];
    [self buildComponent];
    [self setupLayout];
}

#pragma mark - build

- (void)buildComponent {
    [self buildReturnBtn];
}

- (void)buildReturnBtn {
    debugMethod();
    _returnBtn = [[UIButton alloc] init];
    [_returnBtn addTarget:self action:@selector(returnBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_pressed"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:_returnBtn];
}

#pragma mark - Custom Function

- (void)returnBtnDidClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupLayout {
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_leftMargin).offset(10);
        make.topMargin.equalTo(self.view.mas_topMargin).offset(40);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
}

//
// 判断是否已经登录过了，如果已经登录过了，则直接跳转到主界面，否则跳到登录界面
//
- (void)isHaveLogined {
    debugMethod();
    AVUser *user = [AVUser currentUser];
    if (user) {
        MSHomeViewController *hvc = [[MSHomeViewController alloc] init];
        [self.navigationController pushViewController:hvc animated:YES];
    }
}

- (Boolean)validatePhoneNumber {
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    if ([regextestmobile evaluateWithObject:self.phoneNumTextField.text] == NO) {
        [SVProgressHUD showInfoWithStatus:@"请检查手机号的格式"];
        return false;
    }
    return true;
}

- (IBAction)login:(id)sender {
    debugMethod();
    
    if (![self validatePhoneNumber]) {
        return;
    }
    
    [self showProgress];
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneNumTextField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSArray<AVObject *> *users = objects;
            if ([users count] == 0) {
                // 数据库中没有用户名，
                [AVOSCloud requestSmsCodeWithPhoneNumber:self.phoneNumTextField.text callback:^(BOOL succeeded, NSError *error) {
                    
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
        [self hiddenProgress];
    }];
}

@end
