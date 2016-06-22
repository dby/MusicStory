//
//  AboutCenterView.m
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "AboutCenterView.h"

@implementation AboutCenterView

-(void)awakeFromNib {
    [super awakeFromNib];
    //self.appIcon.layer.cornerRadius = 8;
    //self.appIcon.clipsToBounds = true;
}

+(AboutCenterView *) centerView {
    return (AboutCenterView *)[[NSBundle mainBundle] loadNibNamed:@"AboutCenterView" owner:nil options:nil].firstObject;
}

@end
