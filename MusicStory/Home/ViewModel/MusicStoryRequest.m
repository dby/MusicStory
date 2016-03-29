//
//  MusicStoryRequest.m
//  MusicStory
//
//  Created by sys on 16/3/22.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MusicStoryRequest.h"

#import "APIConfig.h"

@interface MusicStoryRequest()

@property (nonatomic, strong) NSDictionary *para;
@property (nonatomic, assign) MusicStoryType type;

@end

@implementation MusicStoryRequest

-(instancetype)initWithType:(MusicStoryType)type withPara:(NSDictionary *)para
{
    self = [super init];
    if (self) {
        _para = para;
        _type = type;
    }
    
    return self;
}

-(NSString *)requestUrl
{
    NSString *url = @"";
    switch (_type) {
        case MusicStoryTypeSpecific:
            url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"/apps/app/daily/?", API_appVersion,API_openUDID,  API_resolution, API_systemVersion, API_pageSize, API_platform];
            break;
            
        default:
            break;
    }
    
    return url;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

-(id)requestArgument
{
    switch (_type) {
        case MusicStoryTypeSpecific:
            return _para;
            break;
            
        default:
            break;
    }
    
    return NULL;
}

@end
