//
//  MSHomeCenterItemView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeCenterItemView.h"

#import "MusicStory-Common-Header.h"
#import "UILabel+MS.h"

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
    self.iconFlowerButton.tag = 999;
    
    self.fovView.opaque = 0.2;
    self.fovView.userInteractionEnabled = true;
    self.fovView.backgroundColor = [UIColor colorWithRed:158/255.0 green:164/255.0 blue:170/255.0 alpha:0.5];
    self.fovView.layer.cornerRadius = 10;
    
    self.fovCountLabel.font = [UIFont boldSystemFontOfSize:12];
    
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    
    self.detailLabel.verticalAlignment = VerticalAlignmentTop;
    self.detailLabel.backgroundColor = [UIColor whiteColor];
    
    self.authorLabel.font = [UIFont boldSystemFontOfSize:16];
    self.authorLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
    self.authorLabel.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - Setter Getter
-(void)setHomeModel:(MSMusicModel *)homeModel
{
    debugMethod();
    _homeModel = homeModel;
    
    // 设置数据
    [self setTitle:homeModel.music_name singer_name:homeModel.singer_name];
    
    [_centerImgView setImageWithURL:[NSURL URLWithString:homeModel.music_imgs]
                   placeholderImage:[UIImage imageNamed:@"home_logo_pressed"] usingActivityIndicatorStyle:YES];
    
    [self.detailLabel setAttributText: homeModel.music_intro lineSpace:5.0 isCenter:false];
    
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

#pragma mark - Function
-(void)setTitle: (NSString *)music_name singer_name:(NSString *)singer_name
{
    music_name = [music_name stringByAppendingString:@"  "];
    NSString *content = [music_name stringByAppendingString:singer_name];
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:content];
    
    [attrs addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:20]
                  range:NSMakeRange(0, music_name.length)];
    [attrs addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0]
                  range:NSMakeRange(0, music_name.length)];
    
    [attrs addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:15]
                  range:NSMakeRange(music_name.length, singer_name.length)];
    
    [attrs addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
                  range:NSMakeRange(music_name.length, singer_name.length)];
    
    self.titleLabel.attributedText = attrs;
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
