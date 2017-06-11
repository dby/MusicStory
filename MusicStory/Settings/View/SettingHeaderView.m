//
//  SettingHeaderView.m
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "SettingHeaderView.h"
#import "AppConfig.h"

@implementation SettingHeaderView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.font = [UIFont boldSystemFontOfSize:18];
    self.title.textColor = MS_BLACK;
}

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
