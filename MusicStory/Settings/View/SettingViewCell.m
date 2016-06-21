//
//  SettingViewCell.m
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell

@synthesize data = _data;


static NSString *SettingViewCellID = @"SettingViewCellID";

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    self.iconView.image = [UIImage imageNamed:[data objectForKey:@"icon"]];
    self.itemLabel.text = [data objectForKey:@"text"];
}

+ (SettingViewCell *) cellWithTableView:(UITableView*)tableView {
    SettingViewCell *cell = (SettingViewCell *)[tableView dequeueReusableCellWithIdentifier:SettingViewCellID];
    if (cell == nil) {
        cell = (SettingViewCell *)[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

@end
