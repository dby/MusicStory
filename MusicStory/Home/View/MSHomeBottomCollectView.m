//
//  MSHomeBottomCollectView.m
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeBottomCollectView.h"

#import "UIView+MS.h"

@interface MSHomeBottomCollectView()

@end

@implementation MSHomeBottomCollectView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"MSHomeBottomItemView" bundle:nil] forCellWithReuseIdentifier:@"MSHomeBottomItemViewID"];
        self.scrollEnabled = false;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = false;
        self.tag = 101;
    }
    return self;
}

- (void)initComponent {
    self.maxItemY = 10;
}

#pragma mark - Touch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchBegan");
    // 获取显示的cell,保存cell的rect数组, 排序按cell的x从小到大
    NSMutableArray *cellArray = [[NSMutableArray alloc] init];
    UICollectionViewCell *cell;
    for (cell in self.visibleCells) {
        [cellArray addObject:cell];
    }
    [cellArray sortUsingComparator:^NSComparisonResult(UICollectionViewCell *obj1,UICollectionViewCell *obj2) {
        return obj1.x < obj2.x;
    }];
    
    self.cellArray = cellArray;
    
    // 重新设置frame
    [self resetCellFrame:touches];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchMoved");
    [self resetCellFrame:touches];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchEnded");
    [UIView animateKeyframesWithDuration:0.2 delay:0.5 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        for (int i = 0; i < [self.cellArray count]; i++) {
            UICollectionViewCell *cell = [self.cellArray objectAtIndex:i];
            if (cell != self.indexCell) {
                cell.y = 50;
            } else {
                cell.y = 15;
            }
        }
    } completion:nil];
    
    if (self.indexCell == nil || self.lastCell == self.indexCell) {
        return;
    }
    
    self.lastCell = _indexCell;
    NSIndexPath *indexPath = [self indexPathForCell:self.indexCell];
    [self.bottomViewDelegate homeBottomCollectView:self touchIndexDidChangeWithIndexPath:indexPath cellArrayCount:[self.cellArray count]];
}

- (void)resetCellFrame :(NSSet<UITouch *> *) touches {
    
    // 获取点击的位置
    UITouch *touch = (UITouch *)touches.anyObject;
    CGPoint clickPoint = [touch locationInView:self];
    // 判断点在哪个cell
    for (int index = 0; index < [_cellArray count]; index++) {
        UICollectionViewCell *cell = [self.cellArray objectAtIndex:index];
        if (CGRectContainsPoint(CGRectMake(cell.x, 0, cell.width, cell.height), clickPoint)) {
            if (self.indexCell == cell) {
                return;
            }
            self.indexCell = cell;
            // 重新设置cellframe
            [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
                    for (int i = 0; i < [self.cellArray count]; i++) {
                        UICollectionViewCell *cell = [self.cellArray objectAtIndex:i];
                        CGFloat gap = fabs((CGFloat)(i - index) * 5);
                        cell.y = self.maxItemY + gap;
                    }
                }];
                
                [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.4 animations:^{
                    
                    for (int i = 0; i < [self.cellArray count]; i++) {
                        UICollectionViewCell *cell = [self.cellArray objectAtIndex:i];
                        cell.y += 5;
                    }
                }];
                
            } completion: nil];
        }
    }
}

@end
