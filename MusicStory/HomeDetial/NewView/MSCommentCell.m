//
//  CommentCell.m
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSCommentCell.h"

#import "MusicStory-Common-Header.h"

@implementation MSCommentCell

@synthesize userNameLabel = _userNameLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    debugMethod();
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // set up subviews
        [self buildSubViews];
        // set styles
        [self setSubViewsOfStyle];
        // set constraints
        [self setConstraints];
    }
    return self;
}

#pragma mark - build

- (void)buildSubViews {
    _userImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_userImageView];
    
    _userNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_userNameLabel];
    
    _userDetailLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_userDetailLabel];
    
    _timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_timeLabel];
    
    _commentLabel   = [[UILabel alloc] init];
    _commentBg      = [[UIImageView alloc] init];
    [_commentBg addSubview:_commentLabel];
    [self.contentView addSubview:_commentBg];
}

- (void)setSubViewsOfStyle {
    
    _userImageView.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    _userImageView.layer.borderWidth   = 1;
    
    _userNameLabel.font      = UI_FONT_14;
    _userNameLabel.textColor = [UIColor blackColor];
    
    _userDetailLabel.font      = UI_FONT_10;
    _userDetailLabel.textColor = [UIColor lightGrayColor];
    
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font      = UI_FONT_10;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    UIImage *bgImg  = [UIImage imageNamed:@"detail_comment_bg"];
    CGFloat stretchWidth    = bgImg.size.width*0.8;
    CGFloat stretchHeight   = bgImg.size.height*0.4;
    _commentBg.image = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(stretchHeight, stretchWidth, stretchHeight, bgImg.size.width*0.1) resizingMode:UIImageResizingModeStretch];
    
    _commentLabel.font       = [UIFont systemFontOfSize:10];
    _commentLabel.textColor  = [UIColor darkGrayColor];
    _commentLabel.numberOfLines = 0;
}

- (void)setCellData :(MSCommentModel *)model {
    debugMethod();
    self.userNameLabel.text     = model.author_name;
    self.userDetailLabel.text   = @"";
    self.timeLabel.text         = [NSString stringWithFormat:@"%@", [model.createdAt.description substringToIndex:10]];
    self.commentLabel.text      = model.content;
    if (model.author_portrait && ![model.author_portrait isEqualToString:@""]) {
        [self.userImageView setImageWithURL:[NSURL URLWithString:model.author_portrait]
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    } else {
        [self.userImageView setImage:[UIImage imageNamed:@"encourage_image"]];
    }
}

#pragma mark 设置约束
#pragma mark 设置SubViews的约束
-(void)setConstraints {
    //[_userImageView setBackgroundColor:[UIColor blueColor]];
    //[_userNameLabel setBackgroundColor:[UIColor redColor]];
    //[_userDetailLabel setBackgroundColor:[UIColor greenColor]];
    //[_timeLabel setBackgroundColor:[UIColor purpleColor]];
    //[_commentLabel setBackgroundColor:[UIColor blueColor]];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        _userImageView.layer.cornerRadius  = 15;
        _userImageView.layer.masksToBounds = true;
        make.top.left.equalTo(self.contentView).offset(UI_MARGIN_10);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@15);
        make.bottom.equalTo(_userImageView.mas_centerY);
        make.left.equalTo(_userImageView.mas_right).offset(UI_MARGIN_10);
    }];
  
    [_userDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.height.equalTo(@15);
        make.left.equalTo(_userNameLabel.mas_left);
        make.top.equalTo(_userNameLabel.mas_bottom);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.height.equalTo(@15);
        make.bottom.equalTo(_userImageView.mas_centerY);
        make.left.equalTo(@(SCREEN_WIDTH-120-UI_MARGIN_10));
    }];
 
    [_commentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH - 2 * UI_MARGIN_10));
        make.height.equalTo(@50);
        make.left.equalTo(@(UI_MARGIN_10));
        make.top.equalTo(_userImageView.mas_bottom);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(@(UI_MARGIN_10));
        make.right.equalTo(_commentBg.mas_right).offset((-1 * UI_MARGIN_10));
        make.top.equalTo(@15);
    }];
}
@end