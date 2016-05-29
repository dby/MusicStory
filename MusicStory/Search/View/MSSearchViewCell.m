//
//  MSSearchViewCell.m
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSearchViewCell.h"

#import "AppConfig.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation MSSearchViewCell

static NSString *MSSearchViewCellID = @"MSSearchViewCellID";

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = true;
    debugMethod();
}

+ (MSSearchViewCell *)cellWithTableView:(UITableView *)tableview {
    debugMethod();
    MSSearchViewCell *cell = (MSSearchViewCell *)[tableview dequeueReusableCellWithIdentifier:MSSearchViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MSSearchViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

-(void)loadData:(MSMusicModel *)model {
    debugMethod();
    self.singerNameLable.text   = model.singer_name;
    self.musicNameLabel.text    = model.music_name;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.icon_image]
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

@end
