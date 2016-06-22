//
//  NSDate+MS.m
//  MusicStory
//
//  Created by sys on 16/3/24.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "NSDate+MS.h"

@implementation NSDate (MS)

// 获取今天日期
+(NSString *)today
{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *now = [[NSDate alloc] init];
    return [dataFormatter stringFromDate:now];
}

// 判断是否是今天
+(BOOL)isToDay:(NSString *)dateString
{
    return [dateString isEqualToString:[self today]];
}

// 判断是否是昨天
+(BOOL)isLastDay:(NSString *)dateString
{
    NSTimeInterval todayTimestamp = [self getTimestamp:[self today]];
    NSTimeInterval lastdayTimestamp = [self getTimestamp:dateString];
    return lastdayTimestamp == todayTimestamp-(24*60*60);
}

// 根据日期获取时间戳
+(NSTimeInterval)getTimestamp:(NSString *)dateString
{
    if ([dateString length] <= 0) {
        return 0;
    }
    NSString *newDateStirng = [dateString stringByAppendingString:@" 00:00:00"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    NSDate *dateNow = [formatter dateFromString:newDateStirng];
    
    return ([dateNow timeIntervalSince1970]);
}

// 获取星期
+(NSString *)weekWithDateString:(NSString *)dateString
{
    NSTimeInterval timestamp = [NSDate getTimestamp:dateString];
    NSInteger day = INT32_C(timestamp/86400);
    
    NSArray *array  = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    return array[(day-3)%7];
    //        return "星期\((day-3)%7))"
}
@end
