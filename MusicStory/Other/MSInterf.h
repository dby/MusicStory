//
//  MSInterf.h
//  MusicStory
//
//  Created by sys on 16/8/8.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MSInterf : NSObject

// 网络是否可达
@property (nonatomic, assign) BOOL isNetWorkConnected;
@property (nonatomic, strong) NSMutableArray *backGroundColors;

// 打开应用之后，多长时间第一次显示广告
@property (nonatomic, assign) NSInteger googleAdsStart;
// 显示广告的间隔
@property (nonatomic, assign) NSInteger googleAdsInterval;
// admob 应用 id
@property (nonatomic, strong) NSString *applicationId;
// admob 广告单元 id
@property (nonatomic, strong) NSString *cellId;
// app上传App Store之后 id
@property (nonatomic, strong) NSString *appId;
// 是否上传到App Store
@property (nonatomic, assign) Boolean hasPassedAppStore;
// 是否显示歌词
@property (nonatomic, assign) Boolean dosShowLyrics;

+(instancetype)shareInstance;

@end
