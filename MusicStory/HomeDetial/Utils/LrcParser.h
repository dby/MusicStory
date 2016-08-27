//
//  LrcParser.h
//  MusicStory
//
//  Created by sys on 16/8/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcParser : NSObject

//时间
@property (nonatomic,strong) NSMutableArray *timerArray;
//歌词
@property (nonatomic,strong) NSMutableArray *wordArray;

-(instancetype) initWithLyrics: (NSString *)lyrics;

//解析歌词
-(void) parseLrc;
//解析歌词
-(void) parseLrc:(NSString*)lrc;

@end
