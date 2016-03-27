//
//  MSHomeCenterItemView.h
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSHomeCenterItemView : UICollectionViewCell
// 大标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 子标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *centerImgView;
// 详情
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *fovView;
@property (weak, nonatomic) IBOutlet UILabel *fovCountLabel;

// 作者
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;


+ (MSHomeCenterItemView *) itemWithCollectionView:(UICollectionView *)collection :(NSIndexPath*)indexPath; 
    
@end
