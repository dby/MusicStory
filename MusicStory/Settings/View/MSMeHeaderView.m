//
//  XBMeHeaderView.m
//  xiu8iOS
//
//  Created by Scarecrow on 15/9/19.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "MSMeHeaderView.h"

#import "UIView+MS.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface MSMeHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
@implementation MSMeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupHeaderCircle];
}

- (void)setupHeaderCircle
{
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:@"http://ac-xjvf4uf6.clouddn.com/223b5c12f6efb871.jpg"]
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
