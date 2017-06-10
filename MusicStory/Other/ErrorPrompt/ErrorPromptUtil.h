//
//  ErrorPromptUtil.h
//  MusicStory
//
//  Created by sys on 2017/6/9.
//  Copyright © 2017年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorPromptUtil : NSObject

+ (void)showErrorPrompt: (NSString*)msg;
+ (void)hideErrorPrompt;

@end
