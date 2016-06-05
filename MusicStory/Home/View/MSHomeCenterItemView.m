//
//  MSHomeCenterItemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "AppConfig.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "MSHomeCenterItemView.h"

#import "UIView+MS.h"


@interface MSHomeCenterItemView()

@end

@implementation MSHomeCenterItemView
@synthesize homeModel = _homeModel;

-(void)awakeFromNib
{
    debugMethod();
    [super awakeFromNib];
    
    self.backgroundColor        = [UIColor whiteColor];
    self.layer.cornerRadius     = 5;
    self.layer.masksToBounds    = YES;
    self.userInteractionEnabled = YES;
    
    [self.centerImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.centerImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.centerImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.centerImgView.clipsToBounds = YES;
    
    self.iconFlowerButton.userInteractionEnabled = YES;
}

#pragma mark - Setter Getter
-(void)setHomeModel:(MSMusicModel *)homeModel
{
    debugMethod();
    _homeModel = homeModel;
    
    // 设置数据
    _titleLabel.text        = homeModel.music_name;
    _subTitleLabel.text     = homeModel.singer_name;
    
    [_centerImgView setImageWithURL:[NSURL URLWithString:homeModel.music_imgs]
                   placeholderImage:[UIImage imageNamed:@"home_logo_pressed"] usingActivityIndicatorStyle:YES];
    
    _detailLabel.text   = homeModel.music_story;
    _authorLabel.text   = homeModel.author_name;
    _fovCountLabel.text = homeModel.like_count;
    
    AVUser *user = [AVUser currentUser];
    NSArray *likedMusicsArr = [user objectForKey:@"hasLikedMusic"];
    if ([likedMusicsArr containsObject:_homeModel.objectId]) {
        [_iconFlowerButton setHighlighted:YES];
    } else {
        [_iconFlowerButton setHighlighted:NO];
    }
}

// 加载cell
+(MSHomeCenterItemView *)itemWithCollectionView:(UICollectionView *)collection :(NSIndexPath *)indexPath
{
    debugMethod();
    MSHomeCenterItemView *cell = [collection dequeueReusableCellWithReuseIdentifier:@"MSHomeCenterItemViewID" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSHomeCenterItemView" owner:self options:nil] firstObject];
    }
    return cell;
}
@end