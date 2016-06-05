//
//  MSHomeBottomitemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeBottomitemView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AppConfig.h"

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
}

-(void)awakeFromNib
{
    debugMethod();
    [super awakeFromNib];
    
    self.layer.cornerRadius             = 8;
    self.iconView.layer.cornerRadius    = 8;
    self.layer.masksToBounds            = true;
    self.iconView.layer.masksToBounds   = true;
}

@end
