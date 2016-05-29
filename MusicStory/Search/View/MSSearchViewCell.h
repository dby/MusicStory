//
//  MSSearchViewCell.h
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMusicModel.h"
#import "MSImageView.h"

@interface MSSearchViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MSImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerNameLable;
+ (MSSearchViewCell *)cellWithTableView:(UITableView *)tableview;

- (void)loadData:(MSMusicModel *)model;

@end
