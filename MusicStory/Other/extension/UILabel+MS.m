//
//  UILabel+MS.m
//  MusicStory
//
//  Created by sys on 2017/6/5.
//  Copyright © 2017年 sys. All rights reserved.
//

#import "UILabel+MS.h"

@implementation UILabel (MS)

-(void)setAttributText:(NSString *)content lineSpace:(CGFloat)lineSpace isCenter:(BOOL)isCenter
{
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.firstLineHeadIndent    = 0.0;
    paragraphStyle.hyphenationFactor      = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    
    if (isCenter) {
        paragraphStyle.alignment = NSTextAlignmentCenter;
    }
    
    [attrs addAttribute:NSParagraphStyleAttributeName
                  value:paragraphStyle
                  range:NSMakeRange(0, content.length)];
    
    self.attributedText = attrs;
}

@end
