//
//  MSHomeHeaderView.h
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMusicModel.h"
#import "MusicStory-Common-Header.h"

@class MSHomeHeaderView;
@protocol MSHomeHeaderViewDelegate
- (void) homeHeaderViewMoveToFirstDidClick:(MSHomeHeaderView *)headerView :(UIButton *)moveToFirstBtn;
- (void) homeHeaderViewMenuDidClick:(MSHomeHeaderView *)header :(UIButton *)menuBtn;
@end

@interface MSHomeHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *moveToFirstBtn;          // 返回第一
@property (weak, nonatomic) IBOutlet MSLabel *dateLabel;                // 日期
@property (weak, nonatomic) IBOutlet MSLabel *weakLabel;                // 星期
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;          // 右边标题
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (assign, nonatomic) id<MSHomeHeaderViewDelegate> delegate;
@property (nonatomic, strong) MSMusicModel *homeModel;
@property (strong, nonatomic) NSString *rightTitle;

- (void) setRightTitleHidden:(BOOL)flag;

@end
