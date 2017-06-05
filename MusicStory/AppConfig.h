//
//  AppConfig.h
//  MusicStory
//
//  Created by sys on 16/3/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define IPHONE5_WIDTH  320
#define IPHONE5_HEIGHT 568
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/// 网络超时时间
#define NETWORK_TIMEOUT 7

// MARK: - 颜色
// 默认背景色
#define UI_COLOR_APPNORMAL  [UIColor colorWithRed:54/255.0 green:142/255.0 blue:198/155.0 alpha:1]
#define UI_COLOR_BORDER     [UIColor colorWithRed: 240/255.0  green: 240/255.0 blue: 240/255.0 alpha: 1]
// MARK: - 字体
#define UI_FONT_20 [UIFont systemFontOfSize:20]
#define UI_FONT_18 [UIFont systemFontOfSize:18]
#define UI_FONT_16 [UIFont systemFontOfSize:16]
#define UI_FONT_14 [UIFont systemFontOfSize:14]
#define UI_FONT_12 [UIFont systemFontOfSize:12]
#define UI_FONT_10 [UIFont systemFontOfSize:10]

// MARK: - MARGIN
#define UI_MARGIN_5 5
#define UI_MARGIN_10 10
#define UI_MARGIN_15 15
#define UI_MARGIN_20 20
// MARK: - 通知
#define NOTIFY_SHOWMENU         @"NOTIFY_SHOWMENU"
#define NOTIFY_HIDDEMENU        @"NOTIFY_HIDDEMENU"
#define NOTIFY_SETUPBG          @"NOTIFY_SETUPBG"
#define NOTIFY_ERRORBTNCLICK    @"NOTIFY_ERRORBTNCLICK"
// 设置homeview类型 - 用于请求api
#define NOTIFY_SETUPHOMEVIEWTYPE    @"NOTIFY_SETUPHOMEVIEWTYPE"
/// 音乐故事
#define NOTIFY_OBJ_music_story      @"musicStoryType"
/// 音乐乐评
#define NOTIFY_OBJ_music_criticism  @"musicCriticimsType"
/// 音乐小文
#define NOTIFY_OBJ_music_article    @"musicArticleType"
/// 音乐榜单
#define NOTIFY_OBJ_music_ranklist   @"musicRankListType"
/// 我的收藏
#define NOTIFY_OBJ_music_collection @"musicCollectionType"

// 设置menu centreview 类型 - 用于切换centerView
#define NOTIFY_SETUPCENTERVIEW      @"NOTIFY_SETUPCENTERVIEW"

// 登陆成功之后，更新个人头像和用户名
#define NOTIFY_UPDATE_USER_AVATAR   @"NOTIFY_UPDATE_USER_AVATAR"

// HomeBottomView的item的Y坐标大小
#define BOTTOM_VIEW_MAX_Y (SCREEN_HEIGHT*60/IPHONE5_HEIGHT)
#define BOTTOM_VIEW_NOR_Y (SCREEN_HEIGHT*60/IPHONE5_HEIGHT)-10
#define BOTTOM_VIEW_MIN_Y    5
#define BOTTOM_VIEW_MINEST_Y 3

//每次从数据中读取20条数据
#define EVERY_DATA_NUM 20

//
#define headerViewHeight (SCREEN_HEIGHT*50/IPHONE5_HEIGHT)
#define bottomViewHeight (SCREEN_HEIGHT*60/IPHONE5_HEIGHT)

//#define debugdebug
#ifdef debugdebug

#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)

#else

#define debugLog(...)
#define debugMethod()

#endif

#endif /* AppConfig_h */
