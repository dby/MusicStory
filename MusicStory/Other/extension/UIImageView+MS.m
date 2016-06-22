//
//  UIImageView+MS.m
//  MusicStory
//
//  Created by sys on 16/6/22.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIImageView+MS.h"

#import "UIImage+MS.h"

@implementation UIImageView (MS)

- (void) kt_addCorner:(CGFloat)radius {
    self.image = [self.image kt_drawRectWithRoundedCornerWithRadius:radius sizetoFit:self.bounds.size];
}

@end
