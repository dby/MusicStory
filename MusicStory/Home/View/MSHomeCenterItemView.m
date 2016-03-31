//
//  MSHomeCenterItemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "MSHomeCenterItemView.h"

@interface MSHomeCenterItemView()

@end

@implementation MSHomeCenterItemView
@synthesize homeModel = _homeModel;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //self.backgroundColor        = [UIColor clearColor];
    self.layer.cornerRadius     = 5;
    self.layer.masksToBounds    = YES;
}

#pragma mark - Setter Getter
-(void)setHomeModel:(MSHomeDataModel *)homeModel
{
    _homeModel = homeModel;
    
    // 设置数据
    _titleLabel.text = homeModel.title;
    _subTitleLabel.text = homeModel.sub_title;
    [_centerImgView setImageWithURL:[NSURL URLWithString:homeModel.cover_image] placeholderImage:[UIImage imageNamed:@"home_logo_pressed"] usingActivityIndicatorStyle:YES];
    _detailLabel.text = homeModel.digest;
    //            self.detailLabel.sizeToFit()
    
    /*
    if (homeModel.info.fav == nil) {
        self.fovCountLabel.text = @"0";
    } else {
        self.fovCountLabel.text = homeModel.info.fav;
    }
     */
    _authorLabel.text = homeModel.author_username;
}

// 加载cell
+(MSHomeCenterItemView *)itemWithCollectionView:(UICollectionView *)collection :(NSIndexPath *)indexPath
{
    
    MSHomeCenterItemView *cell = [collection dequeueReusableCellWithReuseIdentifier:@"MSHomeCenterItemViewID" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSHomeCenterItemView" owner:self options:nil] firstObject];
    }
    return cell;
}

@end
