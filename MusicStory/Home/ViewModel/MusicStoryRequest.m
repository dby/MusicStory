//
//  MusicStoryRequest.m
//  MusicStory
//
//  Created by sys on 16/3/22.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MusicStoryRequest.h"

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
