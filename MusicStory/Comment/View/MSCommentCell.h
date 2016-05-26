//
//  CommentCell.h
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MSCommentModel.h"

@interface MSCommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userDetailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *commentBg;
@property (nonatomic, strong) UILabel *commentLabel;

- (void)setCellData :(MSCommentModel *)model;

@end
