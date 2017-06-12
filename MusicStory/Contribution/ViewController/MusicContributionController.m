//
//  MusicContributionController.m
//  MusicStory
//
//  Created by sys on 2017/6/9.
//  Copyright © 2017年 sys. All rights reserved.
//

#import "MusicContributionController.h"

#import "musicStory-Common-Header.h"
#import "SettingHeaderView.h"

@interface MusicContributionController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *musicNameTextField;
@property (nonatomic, strong) UITextField *singerNameTextField;
@property (nonatomic, strong) UILabel *contentHintLabel;
@property (nonatomic, strong) UITextView *conttentTextView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) SettingHeaderView *headerView;

@end

@implementation MusicContributionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.musicNameTextField];
    [self.view addSubview:self.singerNameTextField];
    [self.view addSubview:self.contentHintLabel];
    [self.view addSubview:self.conttentTextView];
    [self.view addSubview:self.confirmButton];
    
    [self setupLayout];
}

#pragma mark - Function
- (void)cancelButtonDidClicked {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)updateContribution {
    if ([self.musicNameTextField.text isEqual: @""] || [self.singerNameTextField.text isEqual: @""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入歌曲名称、歌手名称"];
        return;
    }
    
    AVObject *todo = [AVObject objectWithClassName:@"feedback"];
    [todo setObject:self.musicNameTextField.text forKey:@"music_name"];
    [todo setObject:self.singerNameTextField.text forKey:@"singer_name"];
    [todo setObject:self.conttentTextView.text forKey:@"music_story"];
    
    AVUser *author = [AVUser currentUser];
    if (author) {
        [todo setObject:[author objectForKey:@"username"] forKey:@"author_name"];
    }
    
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            [SVProgressHUD showInfoWithStatus:@"提交失败!!"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"提交成功!!"];
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)setupLayout {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(60));
    }];
    
    [self.musicNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.singerNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.musicNameTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.contentHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.singerNameTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.conttentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentHintLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Getter Setter
-(UITextField *)musicNameTextField {
    if (!_musicNameTextField) {
        _musicNameTextField = [UITextField new];
        _musicNameTextField.placeholder = @"音乐名称";
        _musicNameTextField.delegate = self;
        _musicNameTextField.returnKeyType = UIReturnKeyDone;
        //_musicNameTextField.layer.borderWidth = 1;
        //_musicNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //_musicNameTextField.backgroundColor = [UIColor redColor];
    }
    return _musicNameTextField;
}

-(UITextField *)singerNameTextField {
    if (!_singerNameTextField) {
        _singerNameTextField = [UITextField new];
        _singerNameTextField.placeholder = @"歌手名称";
        _singerNameTextField.delegate = self;
        _singerNameTextField.returnKeyType = UIReturnKeyDone;
        //_singerNameTextField.layer.borderWidth = 1;
        //_singerNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //_singerNameTextField.backgroundColor = [UIColor orangeColor];
    }
    return _singerNameTextField;
}

-(UILabel *)contentHintLabel {
    if (!_contentHintLabel) {
        _contentHintLabel = [UILabel new];
        _contentHintLabel.text   = @"音乐背后的故事：";
        _contentHintLabel.hidden = true;
        _contentHintLabel.font   = [UIFont systemFontOfSize:16];
        //_contentHintLabel.backgroundColor = [UIColor yellowColor];
    }
    return _contentHintLabel;
}

-(UITextView *)conttentTextView {
    if (!_conttentTextView) {
        _conttentTextView = [UITextView new];
        _conttentTextView.layer.borderWidth = 1;
        _conttentTextView.hidden = true;
        _conttentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _conttentTextView.returnKeyType = UIReturnKeyDone;
        //_conttentTextView.backgroundColor = [UIColor blueColor];
    }
    return _conttentTextView;
}

-(UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton new];
        [_confirmButton setTitle:@"提  交" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor blackColor];
        [_confirmButton addTarget:self action:@selector(updateContribution) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (SettingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [SettingHeaderView headerView];
        _headerView.title.text = @"音乐投稿";
        __weak typeof(self) weakSelf = self;
        _headerView.block = ^{
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        };
    }
    return _headerView;
}

@end
