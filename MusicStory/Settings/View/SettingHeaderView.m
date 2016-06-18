//
//  SettingHeaderView.m
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "SettingHeaderView.h"

@implementation SettingHeaderView

+(SettingHeaderView *) headerView {
    return [[NSBundle mainBundle] loadNibNamed:@"SettingHeaderView" owner:nil options:nil].firstObject;
}

- (IBAction)backBtnDidClick:(id)sender {
    if (self.block) {
        self.block();
    }
}

-(void) backBtnDidClickWithBlock:(backBtnClickBlock)block {
    self.block = block;
}

@end
