//
//  MSView.m
//  MusicStory
//
//  Created by sys on 16/5/16.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSView.h"

@interface MSView()

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;

@end

IB_DESIGNABLE
@implementation MSView

@synthesize cornerRadius = _cornerRadius;
@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

-(void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius     = cornerRadius;
    self.layer.masksToBounds    = (cornerRadius > 0);
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

-(void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end