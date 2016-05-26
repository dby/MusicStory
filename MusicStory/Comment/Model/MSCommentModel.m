//
//  MSCommentModel.m
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSCommentModel.h"

@implementation MSCommentModel

-(instancetype)initWithAVO:(AVObject *)avo {
    self = [super init];
    if (self) {
        
        self.objectId           = avo.objectId;
        self.author_id          = [avo objectForKey:@"author_id"];
        self.author_name        = [avo objectForKey:@"author_name"];
        self.author_portrait    = [avo objectForKey:@"author_portrait"];
        self.music_id           = [avo objectForKey:@"music_id"];
        
        self.content   = [avo objectForKey:@"content"];
        self.createdAt = avo.createdAt;
    }
    
    return self;
}

@end
