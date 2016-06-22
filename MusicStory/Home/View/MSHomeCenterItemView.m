//
//  MSHomeCenterItemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeCenterItemView.h"

#import "MusicStory-Common-Header.h"

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
    self.userInteractionEnabled = YES;
    
    [self.centerImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.centerImgView.alpha            = 1;
    self.centerImgView.opaque           = true;
    self.centerImgView.layer.opaque     = true;
    self.centerImgView.backgroundColor  = [UIColor whiteColor];
    self.centerImgView.clipsToBounds = YES;
    
    self.iconFlowerButton.userInteractionEnabled = YES;
    self.fovView.layer.cornerRadius = 5;
    
    [self.titleLabel    setBackgroundColor:[UIColor whiteColor]];
    [self.subTitleLabel setBackgroundColor:[UIColor whiteColor]];
    [self.detailLabel   setBackgroundColor:[UIColor whiteColor]];
    [self.authorLabel   setBackgroundColor:[UIColor whiteColor]];
    
}

#pragma mark - Setter Getter
-(void)setHomeModel:(MSMusicModel *)homeModel
{
    debugMethod();
    _homeModel = homeModel;
    
    // 设置数据
    self.titleLabel.text        = homeModel.music_name;
    self.subTitleLabel.text     = homeModel.singer_name;
    
    [_centerImgView setImageWithURL:[NSURL URLWithString:homeModel.music_imgs]
                   placeholderImage:[UIImage imageNamed:@"home_logo_pressed"] usingActivityIndicatorStyle:YES];
    
    self.detailLabel.text   = homeModel.music_story;
    self.authorLabel.text   = homeModel.author_name;
    self.fovCountLabel.text = homeModel.like_count;
    
    AVUser *user = [AVUser currentUser];
    NSArray *likedMusicsArr = [user objectForKey:@"hasLikedMusic"];
    if ([likedMusicsArr containsObject:_homeModel.objectId]) {
        [self.iconFlowerButton setHighlighted:YES];
    } else {
        [self.iconFlowerButton setHighlighted:NO];
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