//
//  MSShareView.m
//  MusicStory
//
//  Created by sys on 16/8/14.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSShareView.h"
#import "MusicStory-Common-Header.h"

@interface MSShareView()

@property (nonatomic, strong) UIButton *weixinShareButton;
@property (nonatomic, strong) UILabel *weixinShareLabel;
@property (nonatomic, strong) UIButton *friendsCircleShareButton;
@property (nonatomic, strong) UILabel *friendsCircleShareLabel;
@property (nonatomic, strong) UIButton *shareMoreButton;
@property (nonatomic, strong) UILabel *shareMoreLabel;
@property (nonatomic, strong) UIImageView *logoShareImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MSShareView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.weixinShareButton];
        [self addSubview:self.weixinShareLabel];
        [self addSubview:self.friendsCircleShareButton];
        [self addSubview:self.friendsCircleShareLabel];
        [self addSubview:self.shareMoreButton];
        [self addSubview:self.shareMoreLabel];
        [self addSubview:self.logoShareImageView];
        [self addSubview:self.titleLabel];
        
        self.backgroundColor = [UIColor colorWithRed: 250/255.0 green: 250/255.0 blue: 250/255.0 alpha: 1.0];
        
        [self setupLayout];
    }
    return self;
}

//Mark:-----Private Function-----
- (void)setupLayout {
    [self.logoShareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(20);
        make.height.width.equalTo(@13);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoShareImageView.mas_right).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.logoShareImageView);
    }];
    
    [self.weixinShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoShareImageView.mas_bottom).offset(30);
        make.left.equalTo(self).offset(30);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.friendsCircleShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoShareImageView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@50);
    }];
    
    [self.shareMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoShareImageView.mas_bottom).offset(30);
        make.right.equalTo(self).offset(-30);
        make.width.height.equalTo(@50);
    }];
    
    [self.weixinShareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weixinShareButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.weixinShareButton);
        make.width.equalTo(@150);
    }];
    
    [self.friendsCircleShareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.friendsCircleShareButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.friendsCircleShareButton);
        make.width.equalTo(@150);
    }];
    
    [self.shareMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareMoreButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.shareMoreButton);
        make.width.equalTo(@150);
    }];
}

//Mark:-----Action-----
- (void)weixinShareAction {
    [self.delegate weixinShareButtonDidClick];
}

- (void)friendsCircleShareAction {
    [self.delegate friendsCircleShareButtonDidClick];
}
    
- (void)shareMoreAction {
    [self.delegate shareMoreButtonDidClick];
}

//MARK:-----Setter Getter-----
/// 微信朋友
- (UIButton *)weixinShareButton {
    if (!_weixinShareButton) {
        _weixinShareButton = [UIButton new];
        [_weixinShareButton setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
        _weixinShareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_weixinShareButton addTarget:self action:@selector(weixinShareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinShareButton;
}

-(UILabel *)weixinShareLabel {
    if (!_weixinShareLabel) {
        _weixinShareLabel = [UILabel new];
        [_weixinShareLabel setText:@"微信朋友"];
        _weixinShareLabel.textAlignment = NSTextAlignmentCenter;
        _weixinShareLabel.textColor = [UIColor colorWithRed:82/255.0 green:78/255.0 blue:80/255.0 alpha:1.0];
        _weixinShareLabel.font = [UIFont systemFontOfSize:13];
    }
    return _weixinShareLabel;
}

/// 朋友圈
-(UIButton *)friendsCircleShareButton {
    if (!_friendsCircleShareButton) {
        _friendsCircleShareButton = [UIButton new];
        [_friendsCircleShareButton setImage:[UIImage imageNamed:@"share_wechat_moment"] forState:UIControlStateNormal];
        _friendsCircleShareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_friendsCircleShareButton addTarget:self action:@selector(friendsCircleShareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _friendsCircleShareButton;
}

-(UILabel *)friendsCircleShareLabel {
    if (!_friendsCircleShareLabel) {
        _friendsCircleShareLabel = [UILabel new];
        _friendsCircleShareLabel.text = @"朋友圈";
        _friendsCircleShareLabel.textColor = [UIColor colorWithRed:82/255.0 green:78/255.0 blue:80/255.0 alpha:1.0];
        _friendsCircleShareLabel.textAlignment = NSTextAlignmentCenter;
        _friendsCircleShareLabel.font = [UIFont systemFontOfSize:13];
    }
    return _friendsCircleShareLabel;
}

/// 分享更多
-(UIButton *)shareMoreButton {
    if (!_shareMoreButton) {
        _shareMoreButton = [UIButton new];
        [_shareMoreButton setImage:[UIImage imageNamed:@"share_more"] forState:UIControlStateNormal];
        _shareMoreButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_shareMoreButton addTarget:self action:@selector(shareMoreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareMoreButton;
}

-(UILabel *)shareMoreLabel {
    if (!_shareMoreLabel) {
        _shareMoreLabel = [UILabel new];
        _shareMoreLabel.text = @"更多";
        _shareMoreLabel.textColor = [UIColor colorWithRed:82/255.0 green:78/255.0 blue:80/255.0 alpha:1.0];
        _shareMoreLabel.textAlignment = NSTextAlignmentCenter;
        _shareMoreLabel.font = [UIFont systemFontOfSize:13];
    }
    return _shareMoreLabel;
}

/// logo
-(UIImageView *)logoShareImageView {
    if (!_logoShareImageView) {
        _logoShareImageView = [UIImageView new];
        _logoShareImageView.image = [UIImage imageNamed:@"ic_dialog_share"];
    }
    return _logoShareImageView;
}

/// titleLabel
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"分享音乐故事给朋友";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRed: 124/255.0 green: 129/255.0 blue: 142/255.0 alpha: 1.0];
    }
    return _titleLabel;
}

@end
