//
//  MSHomeBottomitemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeBottomitemView.h"

@implementation MSHomeBottomitemView

-(void)awakeFromNib
{
    [self awakeFromNib];
    
    self.layer.cornerRadius             = 8;
    self.iconView.layer.cornerRadius    = 8;
    self.layer.masksToBounds            = YES;
    self.iconView.layer.masksToBounds   = YES;
}

@end
