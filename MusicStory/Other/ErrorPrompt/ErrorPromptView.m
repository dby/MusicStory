//
//  ErrorPromptView.m
//  MusicStory
//
//  Created by sys on 2017/6/9.
//  Copyright © 2017年 sys. All rights reserved.
//

#import "ErrorPromptView.h"
#import "musicStory-Common-Header.h"

@interface ErrorPromptView()

@property (nonatomic, strong) UIImageView *errorImg;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ErrorPromptView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.errorImg];
        [self addSubview:self.textLabel];
        
        self.backgroundColor = MS_PINK;
        [self setupLayout];
    }
    return self;
}

#pragma mark - Function
- (void)setupLayout {
    [self.errorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@25);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.errorImg.mas_right).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.bottom.equalTo(self);
    }];
}

#pragma mark - getter setter
-(void)setText:(NSString *)text {
    self.textLabel.text = text;
}

- (UIImageView *)errorImg {
    if (!_errorImg) {
        _errorImg = [UIImageView new];
        [_errorImg setImage:[UIImage imageNamed:@"ic_alert_red"]];
    }
    return _errorImg;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.textColor = [UIColor darkGrayColor];
    }
    return _textLabel;
}

@end
