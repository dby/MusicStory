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

-(instancetype)initWithSpecifiedFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    debugMethod();
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        //self.userInteractionEnabled = true;
        //UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(colletcionViewDidDrag:)];
        //panGes.cancelsTouchesInView = NO;
        //[self addGestureRecognizer:panGes];
    }
    return self;
}

- (void)colletcionViewDidDrag:(UIPanGestureRecognizer *)pan {
    debugMethod();
    // 拿到手指在屏幕中的位置
    //CGPoint point = [pan translationInView:pan.view];
    //NSLog(@"point.x: %f, point.y: %f", point.x, point.y);
    
    // 如果手指取消了或者结束
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        
    } else {
        // 正在拖拽的状态
        // 让左边控制器的x值跟手拖动
        //self.y += point.y;
        //[pan setTranslation:CGPointZero inView:self];

        // 如果拖动x的值小于0 就不让他拖了
        //if (self.centerController.view.x > _menuWith) {
        //    self.centerController.view.x = _menuWith;
        //    self.cover.hidden = false;
        //} else if (self.centerController.view.x <= 0) {
        //    self.centerController.view.x = 0;
        //    self.cover.hidden = true;
        //}
    }
}

// 允许多个手写识别器同时识别
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //return YES;
//}

@end
