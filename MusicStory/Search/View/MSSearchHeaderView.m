//
//  MSSearchHeaderView.m
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSearchHeaderView.h"

#import "AppConfig.h"

@implementation MSSearchHeaderView

-(void)awakeFromNib {
    debugMethod();
    [super awakeFromNib];
    self.cancelBtn.layer.cornerRadius = 2;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.commentTextField becomeFirstResponder];
}

-(instancetype)init {
    debugMethod();
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSSearchHeaderView" owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)cancelBtnDidClick:(id)sender {
    debugMethod();
    if (self.block) {
        self.block();
    }
}
- (IBAction)textFieldDidChange:(id)sender {
    debugMethod();
    if (self.textFieldBlock) {
        NSString *info = ((UITextField *)sender).text;
        self.textFieldBlock(info);
    }
}

- (void)textfieldDidChangeWithBlock:(textFieldDidChangeBlock) block {
    debugMethod();
    self.textFieldBlock = block;
}

- (void)cancleBtnDidClickWithBlock:(cancleBtnDidClickBlock) block {
    debugMethod();
    self.block = block;
}

@end
