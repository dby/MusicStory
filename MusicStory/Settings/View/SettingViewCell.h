//
//  SettingViewCell.h
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (nonatomic, strong) NSDictionary *data;

+(SettingViewCell *) cellWithTableView:(UITableView*)tableView;

@end
