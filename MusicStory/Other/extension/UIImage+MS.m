//
//  UIImage+MS.m
//  MusicStory
//
//  Created by sys on 16/6/22.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIImage+MS.h"

@implementation UIImage (MS)

- (UIImage *)kt_drawRectWithRoundedCornerWithRadius:(CGFloat)radius sizetoFit:(CGSize)sizetoFit {
    
    CGRect rect = CGRectMake(0, 0, sizetoFit.width, sizetoFit.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect
                                           byRoundingCorners:UIRectCornerAllCorners
                                                 cornerRadii:CGSizeMake(radius, radius)].CGPath);
    
    [self drawInRect:rect];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}

@end
