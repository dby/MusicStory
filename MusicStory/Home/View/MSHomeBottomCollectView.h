//
//  MSHomeBottomCollectView.h
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSHomeBottomCollectViewDelegate

- (void)homeBottomCollectView:(UICollectionView *)bottomView touchIndexDidChangeWithIndexPath: (NSIndexPath *)indexPath cellArrayCount:(NSUInteger)cellArrayCount;

@end

@interface MSHomeBottomCollectView : UICollectionView

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) CGFloat maxItemY;
// 保存当前index
@property (nonatomic, strong) UICollectionViewCell *indexCell;
// 上一个index
@property (nonatomic, strong) UICollectionViewCell *lastCell;

@property (assign, nonatomic) id<MSHomeBottomCollectViewDelegate> bottomViewDelegate;

@end
