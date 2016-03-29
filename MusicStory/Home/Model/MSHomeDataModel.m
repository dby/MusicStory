//
//  MSHomeDataModel.m
//  MusicStory
//
//  Created by sys on 16/3/22.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDataModel.h"

@implementation MSHomeDataModel

-(instancetype)initWithDic:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        @try {
            self.id                             = [dict objectForKey:@"id"];
            self.recommanded_background_color   = dict[@"recommanded_background_color"];
            self.title                          = dict[@"title"];
            self.sub_title                      = dict[@"sub_title"];
            self.cover_image                    = dict[@"cover_image"];
            self.digest                         = dict[@"digest"];
            self.icon_image                     = dict[@"icon_image"];
            self.update_time                    = dict[@"update_time"];
            self.publish_date                   = dict[@"publish_date"];
            self.author_username                = dict[@"author_username"];
            self.author_id                      = dict[@"author_id"];
            self.author_bgcolor                 = dict[@"author_bgcolor"];
            self.content                        = dict[@"content"];
            self.tags                           = dict[@"tags"];
            self.qrcode_image                   = dict[@"qrcode_image"];
            self.download_url                   = dict[@"download_url"];
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    
    return self;
}

@end
