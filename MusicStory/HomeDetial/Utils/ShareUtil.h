//
//  ShareUtil.h
//  MusicStory
//
//  Created by sys on 16/8/14.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"

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
           shareMusic:(NSString *)shareMusic;

- (void)shareToFriendsCircle:(NSString *)shareContent
                  shareTitle:(NSString *)shareTitle
                    shareUrl:(NSString *)shareUrl
               shareImageUrl:(NSString *)shareImageUrl
                  shareMusic:(NSString *)shareMusic;

@end
