//
//  NSDate+MS.h
//  MusicStory
//
//  Created by sys on 16/3/24.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MS)

+ (NSString *)today;
+ (BOOL)isToDay: (NSString *)dateString;
+ (BOOL)isLastDay: (NSString *)dateString;
+ (NSTimeInterval)getTimestamp: (NSString *)dateString;
+ (NSString *)weekWithDateString: (NSString *)dateString;

@end
