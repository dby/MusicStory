//
//  LrcParser.m
//  MusicStory
//
//  Created by sys on 16/8/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "LrcParser.h"

@interface LrcParser ()

-(void) parseLrc:(NSString *)word;
@property (nonatomic, strong) NSString *lyrics;

@end

@implementation LrcParser

- (instancetype)initWithLyrics: (NSString *)lyrics{
    self = [super init];
    if(self != nil){
        self.timerArray = [[NSMutableArray alloc] init];
        self.wordArray  = [[NSMutableArray alloc] init];
        self.lyrics = lyrics;
    }
    return self;
}

- (NSString *)getLrcFile:(NSString *)lrc{
    NSString* filePath=[[NSBundle mainBundle] pathForResource:lrc ofType:@"lrc"];
    return  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)parseLrc{
    [self parseLrc: self.lyrics];
}

- (void)parseLrc:(NSString *)lrc{
    
    if(![lrc isEqual:nil]){
        NSArray *sepArray=[lrc componentsSeparatedByString:@"["];
        NSArray *lineArray=[[NSArray alloc] init];
        for(int i=0;i<sepArray.count;i++){
            if([sepArray[i] length]>0){
                lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
                if(![lineArray[0] isEqualToString:@"\n"]){
                    [self.timerArray addObject:lineArray[0]];
                    [self.wordArray addObject:lineArray.count>1?lineArray[1]:@""];
                }
            }
        }
    }
}

@end