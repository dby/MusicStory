//
//  MSHomeCenterCollectionView.m
//  MusicStory
//
//  Created by sys on 16/6/3.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeCenterCollectionView.h"

#import "AppConfig.h"

#import "UIView+MS.h"

@interface MSHomeCenterCollectionView()

@property (nonatomic, assign) CGPoint touchedPoint;
@property (nonatomic, assign) CGFloat originY;

@end

@implementation MSHomeCenterCollectionView

-(instancetype)initWithFrame:(CGRect)frame {
    debugMethod();
    NSLog(@"initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = true;
    }
    return self;
}

#pragma mark - Touch

/*
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    debugMethod();
    NSLog(@"touchesBegan");
    UITouch *touch = (UITouch *)touches.anyObject;
    _touchedPoint = [touch locationInView:self];
    _originY = self.y;
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    debugMethod();
    NSLog(@"touchesMoved");
    UITouch *touch = (UITouch *)touches.anyObject;
    
    NSLog(@"x: %f, y:%f", [touch locationInView:self].x, [touch locationInView:self].y);
    
    //self.y += 5;//(_originY - [touch locationInView:self].y);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    debugMethod();
    NSLog(@"touchesEnded");
    self.y = _originY;
}
 */

@end
