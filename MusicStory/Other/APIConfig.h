//
//  APIConfig.h
//  MusicStory
//
//  Created by sys on 16/3/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

// 服务器ip
#define API_Server  @"http://zuimeia.com/api"
// app版本
#define API_appVersion  @"&appVersion=2.2.4"
// udid
#define API_openUDID  @"&openUDID=1bf9ccab8d121135bed763089b514aff901ffc28"
// resolution
#define API_resolution  @"&resolution=%7B750%2C%201334%7D"
// 系统版本
#define API_systemVersion  @"&systemVersion=9.1"
// pageSize
#define API_pageSize  @"&page_size=10"
// platform
#define API_platform  @"&platform=1"


// 1.每日最美 pagesize20 参数 page
#define API_Today  (API_Server+@"/apps/app/daily/?"+API_appVersion+API_openUDID+API_resolution+API_systemVersion+API_pageSize+API_platform)

// 2.限免推荐 pagesize20  参数 page
#define API_Recommend  API_Server+@"/category/100/all/?type=zuimei.daily"+API_appVersion+API_systemVersion+API_openUDID+API_pageSize+API_platform+API_resolution

// 3.文章专栏
#define API_Article  API_Server+@"/media/list/?type=zhuanlan"+API_platform+API_resolution+API_appVersion+API_openUDID+API_systemVersion
// 4.发现应用 - 最热分享 page
#define API_FindApp_HotShare  API_Server+@"/community/recommend_apps/?"+API_appVersion+API_openUDID+API_pageSize+API_platform+API_systemVersion+API_resolution
// 5.发现应用 - 最新分享 参数 pos
#define API_FindAPP_LastestShare  API_Server+@"/community/apps/?"+API_appVersion+API_openUDID+API_pageSize+API_platform+API_resolution+API_systemVersion

// 6.美我一下
#define API_APPStoreComment  @"https://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8"
// 7.招聘编辑
#define API_Invite  @"http://zuimeia.com/article/100/?utm_medium=community_android&utm_source=niceapp"
// 8.搜索 参数 keyword:输入的东西
#define API_Search  API_Server+@"/search/?"+API_openUDID+API_systemVersion+API_appVersion+API_resolution+API_platform
// 9.发现应用 - 评论 参数:  app_id,comment_id:上一条评论的id
#define API_FindApp_comments  API_Server+@"/community/comments/?"+API_appVersion+API_openUDID+API_pageSize+API_platform+API_resolution+API_systemVersion
// 10.每日最美 -评论 参数 app,page
#define API_Home_Comment  API_Server+@"/apps/comment?"+API_appVersion+API_openUDID+API_pageSize+API_platform+API_resolution+API_systemVersion

#endif /* APIConfig_h */
