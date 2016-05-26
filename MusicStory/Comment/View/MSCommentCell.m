//
//  CommentCell.m
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSCommentCell.h"

#import "UIView+MS.h"
#import "AppConfig.h"

@implementation MSCommentCell

-(instancetype)init {
    debugMethod();
    self = [super init];
    if (self) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_MARGIN_10, 0, 30, 30)];
        [self addSubview:_userImageView];
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userImageView.frame)+UI_MARGIN_10,0,150,15)];
        [self addSubview:_userNameLabel];
        _userDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.x,CGRectGetMaxY(_userNameLabel.frame),120, 15)];
        [self addSubview:_userDetailLabel];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-UI_MARGIN_10, 0, 120, 15)];
        [self addSubview:_timeLabel];
        _commentBg = [[UIImageView alloc] init];
        _commentBg.frame = CGRectMake(UI_MARGIN_10,
                                      CGRectGetMaxY(_userImageView.frame) + UI_MARGIN_5,
                                      SCREEN_WIDTH - 2 * UI_MARGIN_10,
                                      20);
        [self addSubview:_commentBg];
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_MARGIN_10, 15, _commentBg.width - 2 * UI_MARGIN_10, 20)];
        [_commentBg addSubview:_commentLabel];
        
        self.userInteractionEnabled = true;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    debugMethod();
    self = [super initWithFrame:frame];
    if (self) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_MARGIN_10, 0, 30, 30)];
        [self addSubview:_userImageView];
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userImageView.frame)+UI_MARGIN_10,0,150,15)];
        [self addSubview:_userNameLabel];
        _userDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.x,CGRectGetMaxY(_userNameLabel.frame),120, 15)];
        [self addSubview:_userDetailLabel];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-UI_MARGIN_10, 0, 120, 15)];
        [self addSubview:_timeLabel];
        _commentBg = [[UIImageView alloc] init];
        _commentBg.frame = CGRectMake(UI_MARGIN_10,
                                      CGRectGetMaxY(_userImageView.frame) + UI_MARGIN_5,
                                      SCREEN_WIDTH - 2 * UI_MARGIN_10,
                                      20);
        [self addSubview:_commentBg];
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_MARGIN_10, 15, _commentBg.width - 2 * UI_MARGIN_10, 20)];
        [_commentBg addSubview:_commentLabel];
        
        self.userInteractionEnabled = true;
    }
    return self;
}

- (void)setCellData :(MSCommentModel *)model {
    self.userNameLabel.text     = model.author_name;
    self.userDetailLabel.text   = @"";
    self.timeLabel.text         = [NSString stringWithFormat:@"%@", model.createdAt];
    self.commentLabel.text      = model.content;
}

#pragma mark - lazy get

-(UIImageView *)userImageView {
    
    UIImageView *userImgView        = [[UIImageView alloc] init];
    userImgView.layer.cornerRadius  = 15;
    userImgView.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    userImgView.layer.borderWidth   = 1;
    userImgView.layer.masksToBounds = true;
    
    return userImgView;
}

-(UILabel *)userNameLabel {
    UILabel *userNameLabel  = [[UILabel alloc] init];
    userNameLabel.font      = [UIFont systemFontOfSize:12];
    userNameLabel.textColor = [UIColor blackColor];
    return userNameLabel;
}

-(UILabel *)userDetailLabel {
    UILabel *label  = [[UILabel alloc] init];
    label.font      = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

-(UILabel *)timeLabel {
    UILabel *timeLabel  = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font      = [UIFont systemFontOfSize:10];
    timeLabel.textAlignment = NSTextAlignmentRight;
    return timeLabel;
}

-(UIImageView *)commentBg {
    UIImageView *commentBg = [[UIImageView alloc] init];
    UIImage *bgImg = [UIImage imageNamed:@"detail_comment_bg"];
    CGFloat stretchWidth = bgImg.size.width*0.8;
    CGFloat stretchHeight = bgImg.size.height*0.4;
    commentBg.image = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(stretchHeight, stretchWidth, stretchHeight, bgImg.size.width*0.1) resizingMode:UIImageResizingModeStretch];
    
    return commentBg;
}

-(UILabel *)commentLabel {
    UILabel *commentLabel   = [[UILabel alloc] init];
    commentLabel.font       = [UIFont systemFontOfSize:10];
    commentLabel.textColor  = [UIColor darkGrayColor];
    commentLabel.numberOfLines = 0;
    return commentLabel;
}

@end
