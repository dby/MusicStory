//
//  ShareUtil.h
//  MusicStory
//
//  Created by sys on 16/8/14.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MSShareView.h"
#import "MusicStory-Common-Header.h"

@interface ShareUtil : NSObject

@property (nonatomic, strong) MSShareView *shareView;
@property (nonatomic, strong) UIView *shadowView;

+(instancetype)shareInstance;

- (void)hiddenShareView;
- (void)showShareView;

- (void)shareToFriend:(NSString *)shareContent
        shareImageUrl:(NSString *)shareImageUrl
             shareUrl:(NSString *)shareUrl
           shareTitle:(NSString *)shareTitle
           shareMusic:(NSString *)shareMusic
          shareLyrics:(NSString *)shareLyrics;

- (void)shareToFriendsCircle:(NSString *)shareContent
                  shareTitle:(NSString *)shareTitle
                    shareUrl:(NSString *)shareUrl
               shareImageUrl:(NSString *)shareImageUrl;

@end
