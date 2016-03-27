//
//  UIColor+MS.m
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIColor+MS.h"

@implementation UIColor (MS)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    // 默认颜色
    UIColor *DEFAULT_VOID_COLOR = [UIColor whiteColor];
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return DEFAULT_VOID_COLOR;
    }
    
    if ([cString hasPrefix:@"0x"]) {
        cString = [(NSString *)cString substringFromIndex:2];
    } else if ([cString hasPrefix:@"#"]) {
        cString = [(NSString *)cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return DEFAULT_VOID_COLOR;
    }
    
    NSRange range = NSMakeRange(0, 12);
    NSString *rString = [(NSString *)cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [(NSString *)cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [(NSString *)cString substringWithRange:range];
    
    UInt32 r = 0;
    UInt32 g = 0;
    UInt32 b = 0;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
