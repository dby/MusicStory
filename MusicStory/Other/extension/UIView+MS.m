//
//  UIView+MS.m
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIView+MS.h"

@implementation UIView (MS)

-(void)viewAddTarget:(NSObject *)target :(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = true;
    //[self addGestureRecognizer:tap];
}

#pragma mark - Setter Getter
-(CGFloat)x {
    return self.frame.origin.x;
}
-(void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)y {
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)width {
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)height {
    return self.frame.size.width;
}
-(void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGSize)size {
    return self.frame.size;
}
-(void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGPoint)origin {
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
@end
