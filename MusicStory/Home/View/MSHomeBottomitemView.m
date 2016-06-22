//
//  MSHomeBottomitemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeBottomitemView.h"

#import "MusicStory-Common-Header.h"

@implementation MSHomeBottomitemView

@synthesize iconUrl = _iconUrl;

-(NSString *)iconUrl {
    debugMethod();
    return _iconUrl;
}

-(void)setIconUrl:(NSString *)iconUrl {
    debugMethod();
    _iconUrl = iconUrl;
    [self.iconView setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"ic_launcher"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // 使用贝塞尔曲线和Core Graphics框架画出一个圆角
    // 开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(self.iconView.bounds.size, NO, 1.0);
    // 使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:self.iconView.bounds cornerRadius:self.iconView.frame.size.width] addClip];
    [self.iconView drawRect:self.iconView.bounds];
    
    self.iconView.image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束画图
    UIGraphicsEndImageContext();
}

-(void)awakeFromNib
{
    debugMethod();
    [super awakeFromNib];
    
    self.layer.cornerRadius             = 8;
}

@end
