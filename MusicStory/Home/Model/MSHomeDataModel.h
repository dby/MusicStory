//
//  MSHomeDataModel.h
//  MusicStory
//
//  Created by sys on 16/3/22.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHomeDataModel : NSObject

@property(nonatomic, strong) NSString *id;

// 背景色
@property(nonatomic, strong) NSString *recommanded_background_color;
// 标题
@property(nonatomic, strong) NSString *title;
// 子标题
@property(nonatomic, strong) NSString *sub_title;
// 中间图片
@property(nonatomic, strong) NSString *cover_image;
// 详情
@property(nonatomic, strong) NSString *digest;
// 底部图片
@property(nonatomic, strong) NSString *icon_image;
// 更新时间
@property(nonatomic, strong) NSString *update_time;
// 公开时间
@property(nonatomic, strong) NSString *publish_date;
// 作者
@property(nonatomic, strong) NSString *author_username;
// 作者id
@property(nonatomic, strong) NSString *author_id;
// 作者背景
@property(nonatomic, strong) NSString *author_bgcolor;
// 内容
@property(nonatomic, strong) NSString *content;
// 分类
@property(nonatomic, strong) NSString *tags;
// 二维码
@property(nonatomic, strong) NSString *qrcode_image;
// 下载地址
@property(nonatomic, strong) NSString *download_url;

// up_users 模型
//var up_users : Array<XMUpUserDataModel> = Array()

// comments 模型
//var comments : Array<XMCommentsDataModel> = Array()

// info 模型
//var info : XMInfoDataModel?

-(instancetype)initWithDic :(NSDictionary *)dic;


@end
