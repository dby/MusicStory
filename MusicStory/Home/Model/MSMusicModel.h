//
//  MSMusicModel.h
//  MusicStory
//
//  Created by sys on 16/4/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MusicStory-Common-Header.h"

@interface MSMusicModel : NSObject

// id
@property (nonatomic, strong) NSString *objectId;
// 中间照片
@property (nonatomic, strong) NSString *music_imgs;
// 底部的照片
@property (nonatomic, strong) NSString *icon_image;
// 音乐的名字
@property (nonatomic, strong) NSString *music_name;
// 音乐背后的故事
@property (nonatomic, strong) NSString *music_story;
// 歌词
@property (nonatomic, strong) NSString *music_lyrics;
// 公开时间
@property (nonatomic, strong) NSString *publish_date;
// 点赞数
@property (nonatomic, assign) NSString *like_count;
// 音乐链接
@property (nonatomic, strong) NSString *music_url;

// 故事 作者id
@property (nonatomic, strong) NSString *author_id;
// 故事 作者名字
@property (nonatomic, strong) NSString *author_name;
// 头像
@property (nonatomic, strong) NSString *author_portrait;

// 歌手id
@property (nonatomic, strong) NSString *singer_id;
// 歌手名字
@property (nonatomic, strong) NSString *singer_name;
// 歌手简介
@property (nonatomic, strong) NSString *singer_brief;
// 歌手头像
@property (nonatomic, strong) NSString *singer_portrait;

// 背景色
@property (nonatomic, strong) UIColor *recommanded_background_color;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) AVACL *ACL;

-(instancetype)initWithAVO :(AVObject *)avo;
+ (AVObject *)MusicModelToAVObject :(MSMusicModel *)model;

@end
