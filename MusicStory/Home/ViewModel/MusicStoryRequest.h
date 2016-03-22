//
//  MusicStoryRequest.h
//  MusicStory
//
//  Created by sys on 16/3/22.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSUInteger, MusicStoryType) {
    MusicStoryTypeSpecific = 0,
};

@interface MusicStoryRequest : YTKRequest

- (instancetype)initWithType:(MusicStoryType)type withPara:(NSDictionary *)para;

@end
