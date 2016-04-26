//
//  MSMusicModel.m
//  MusicStory
//
//  Created by sys on 16/4/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSMusicModel.h"

@implementation MSMusicModel

-(instancetype)initWithAVO:(AVObject *)avo {
    
    self = [super init];
    if (self) {
        
        self.objectId       = avo.objectId;
        self.music_imgs     = [avo objectForKey:@"music_imgs"];
        self.icon_image     = [avo objectForKey:@"icon_image"];
        self.music_name     = [avo objectForKey:@"music_name"];
        self.music_story    = [avo objectForKey:@"music_story"];
        self.music_lyrics   = [avo objectForKey:@"music_lyrics"];
        self.publish_date   = [avo objectForKey:@"publish_date"];
        self.like_count     = [avo objectForKey:@"like_count"];
        self.music_url      = [avo objectForKey:@"music_url"];
        
        self.author_id      = [avo objectForKey:@"author_id"];
        self.author_name    = [avo objectForKey:@"author_name"];
        
        self.singer_id      = [avo objectForKey:@"singer_id"];
        self.singer_name    = [avo objectForKey:@"singer_name"];
        self.singer_brief   = [avo objectForKey:@"singer_brief"];
        
        self.singer_portrait                = [avo objectForKey:@"singer_portrait"];
        self.recommanded_background_color   = [avo objectForKey:@"recommanded_background_color"];
    }
    
    return self;
}

@end