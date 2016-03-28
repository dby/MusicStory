//
//  MSHomeBottomitemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeBottomitemView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface MSHomeBottomitemView()

@end

@implementation MSHomeBottomitemView

@synthesize iconUrl = _iconUrl;

-(NSString *)iconUrl {
    return _iconUrl;
}

-(void)setIconUrl:(NSString *)iconUrl {
    _iconUrl = iconUrl;
    [self.iconView setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"ic_launcher"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(void)awakeFromNib
{
    [self awakeFromNib];
    
    self.layer.cornerRadius             = 8;
    self.iconView.layer.cornerRadius    = 8;
    self.layer.masksToBounds            = YES;
    self.iconView.layer.masksToBounds   = YES;
}

@end
