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
    debugMethod();
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
        
        self.createdAt = avo.createdAt;
        self.updatedAt = avo.updatedAt;
        self.ACL       = avo.ACL;
    }
    
    return self;
}

+ (AVObject *)MusicModelToAVObject :(MSMusicModel *)model {
    
    debugMethod();
    AVObject *avo = [[AVObject alloc] initWithClassName:@"Musics"];
    
    avo.objectId = model.objectId;
    [avo setObject:model.author_id   forKey:@"author_id"];
    [avo setObject:model.author_name forKey:@"author_name"];
    
    [avo setObject:model.singer_id       forKey:@"singer_id"];
    [avo setObject:model.singer_name     forKey:@"singer_name"];
    [avo setObject:model.singer_brief    forKey:@"singer_brief"];
    [avo setObject:model.singer_portrait forKey:@"singer_portrait"];
    
    [avo setObject:model.music_name   forKey:@"music_name"];
    [avo setObject:model.music_imgs   forKey:@"music_imgs"];
    [avo setObject:model.icon_image   forKey:@"icon_image"];
    [avo setObject:model.music_lyrics forKey:@"music_lyrics"];
    [avo setObject:model.music_story  forKey:@"music_story"];
    [avo setObject:model.music_url    forKey:@"music_url"];
    
    [avo setObject:model.recommanded_background_color forKey:@"recommanded_background_color"];
    [avo setObject:model.like_count   forKey:@"like_count"];
    [avo setObject:model.publish_date forKey:@"publish_date"];
    
    //avo.createdAt = model.createdAt;
    //[avo setObject:model.createdAt forKey:@"createdAt"];
    //[avo setObject:model.updatedAt forKey:@"updatedAt"];
    avo.ACL = model.ACL;
    
    return avo;
}

@end