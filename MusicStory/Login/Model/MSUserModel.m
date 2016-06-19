//
//  MSUserModel.m
//  MusicStory
//
//  Created by sys on 16/5/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSUserModel.h"

@implementation MSUserModel

-(instancetype)initWithAVO:(AVObject *)avo {
    self = [super init];
    if (self) {
        self.objectId = avo.objectId;
        self.username = [avo objectForKey:@"username"];
        self.portrait = [avo objectForKey:@"portrait"];
        
        self.hasLikedMusic      = [avo objectForKey:@"hasLikedMusic"];
        self.music_collections  = [avo objectForKey:@"music_collections"];
        self.mobilePhoneNumber  = [avo objectForKey:@"mobilePhoneNumber"];
        self.email              = [avo objectForKey:@"username"];
    }
    return self;
}

@end
