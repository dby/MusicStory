//
//  MSHomeCenterItemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeCenterItemView.h"

#import "MSHomeDataModel.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface MSHomeCenterItemView()

@property (nonatomic, strong) MSHomeDataModel *homeModel;

@end

@implementation MSHomeCenterItemView
@synthesize homeModel = _homeModel;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 5;
}

#pragma mark - Setter Getter
-(void)setHomeModel:(MSHomeDataModel *)homeModel
{
    self.homeModel = homeModel;
    
    // 设置数据
    self.titleLabel.text = homeModel.title;
    self.subTitleLabel.text = homeModel.sub_title;
    [self.centerImgView setImageWithURL:[NSURL URLWithString:homeModel.cover_image] placeholderImage:[UIImage imageNamed:@"home_logo_pressed"] usingActivityIndicatorStyle:YES];
    self.detailLabel.text = homeModel.digest;
    //            self.detailLabel.sizeToFit()
    
    /*
    if (homeModel.info.fav == nil) {
        self.fovCountLabel.text = @"0";
    } else {
        self.fovCountLabel.text = homeModel.info.fav;
    }
     */
    self.authorLabel.text = homeModel.author_username;
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
