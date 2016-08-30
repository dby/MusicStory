//
//  ShareUtil.m
//  MusicStory
//
//  Created by sys on 16/8/14.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "ShareUtil.h"

static ShareUtil *instance = nil;

@interface ShareUtil()

@end

@implementation ShareUtil

+(instancetype)shareInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[ShareUtil alloc] init];
        }
    }
    return instance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

// 隐藏分享的View
- (void)hiddenShareView {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.shareView.center;
        point.y += 170;
        self.shareView.center = point;
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
}

// 展现分享的View
- (void)showShareView {
    
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    self.shareView = [[MSShareView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.shadowView.alpha = 0;
    self.shadowView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareView)];
    [self.shadowView addGestureRecognizer:tapGesture];
    
    [window addSubview:self.shadowView];
    [window addSubview:self.shareView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 0.5;
        CGPoint point = self.shareView.center;
        point.y -= 170;
        self.shareView.center = point;
    }];
}

// 分享到微信好友
- (void)shareToFriend:(NSString *)shareContent
        shareImageUrl:(NSString *)shareImageUrl
             shareUrl:(NSString *)shareUrl
           shareTitle:(NSString *)shareTitle
           shareMusic:(NSString *)shareMusic {

    OSMessage *msg=[[OSMessage alloc] init];
    msg.title = shareTitle;
    msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
    msg.multimediaType = OSMultimediaTypeAudio;
    msg.desc = shareContent;
    msg.link = shareMusic;
    
    [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
        [SVProgressHUD setMinimumDismissTimeInterval:0.3];
        [SVProgressHUD showInfoWithStatus:@"分享成功"];
    } Fail:^(OSMessage *message, NSError *error) {
        
    }];
    
//    NSMutableDictionary *shareParams = [NSMutableDictionary new];
//    [shareParams SSDKSetupWeChatParamsByText:shareContent
//                                       title:shareTitle
//                                         url:[NSURL URLWithString:shareUrl]
//                                  thumbImage:nil
//                                       image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]]]
//                                musicFileURL:[NSURL URLWithString:shareMusic]
//                                     extInfo:nil
//                                    fileData:nil
//                                emoticonData:nil
//                         sourceFileExtension:nil
//                              sourceFileData:nil
//                                        type:SSDKContentTypeAuto
//                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//
//    //2.进行分享
//    
//    [ShareSDK share:SSDKPlatformTypeWechat
//         parameters:shareParams
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//         
//         switch (state) {
//             case SSDKResponseStateBegin: {
//                 break;
//             }
//             case SSDKResponseStateSuccess: {
//                 NSLog(@"分享成功");
//                 break;
//             }
//             case SSDKResponseStateFail: {
//                 NSLog(@"分享失败");
//                 break;
//             }
//             case SSDKResponseStateCancel: {
//                 NSLog(@"分享取消");
//                 break;
//             }
//         }
//     }];
}

//分享到朋友圈
- (void)shareToFriendsCircle:(NSString *)shareContent
                  shareTitle:(NSString *)shareTitle
                    shareUrl:(NSString *)shareUrl
               shareImageUrl:(NSString *)shareImageUrl
                  shareMusic:(NSString *)shareMusic {
    
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title = shareTitle;
    msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
    msg.multimediaType = OSMultimediaTypeAudio;
    msg.desc = shareContent;
    msg.link = shareMusic;
    
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
        [SVProgressHUD setMinimumDismissTimeInterval:0.3];
        [SVProgressHUD showInfoWithStatus:@"分享成功"];
    } Fail:^(OSMessage *message, NSError *error) {
        
    }];

//    NSMutableDictionary *shareParams = [NSMutableDictionary new];
//    [shareParams SSDKSetupWeChatParamsByText:shareContent
//                                       title:shareTitle
//                                         url:[NSURL URLWithString:shareUrl]
//                                  thumbImage:nil
//                                       image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]]]
//                                musicFileURL:[NSURL URLWithString:shareMusic]
//                                     extInfo:nil
//                                    fileData:nil
//                                emoticonData:nil
//                                        type:SSDKContentTypeAuto
//                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
//    
//    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
//         parameters:shareParams
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//         switch (state) {
//             case SSDKResponseStateBegin: {
//                 break;
//             }
//             case SSDKResponseStateSuccess: {
//                 NSLog(@"分享成功");
//                 break;
//             }
//             case SSDKResponseStateFail: {
//                 NSLog(@"分享失败");
//                 break;
//             }
//             case SSDKResponseStateCancel: {
//                 NSLog(@"分享取消");
//                 break;
//             }
//         }
//     }];
}

//分享到新浪微博
- (void)shareToSinaWeibo:(NSString *)shareContent
              shareTitle:(NSString *)shareTitle
                shareUrl:(NSString *)shareUrl
           shareImageUrl:(NSString *)shareImageUrl
              shareMusic:(NSString *)shareMusic {
    
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title = shareTitle;
    msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
    msg.multimediaType = OSMultimediaTypeAudio;
    msg.desc = shareContent;
    msg.link = shareMusic;
    
    [OpenShare shareToWeibo:msg Success:^(OSMessage *message) {
        [SVProgressHUD setMinimumDismissTimeInterval:0.3];
        [SVProgressHUD showInfoWithStatus:@"分享成功"];
    } Fail:^(OSMessage *message, NSError *error) {
        
    }];
}

@end
