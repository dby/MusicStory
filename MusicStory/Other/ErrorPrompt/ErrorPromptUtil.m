//
//  ErrorPromptUtil.m
//  MusicStory
//
//  Created by sys on 2017/6/9.
//  Copyright © 2017年 sys. All rights reserved.
//

#import "ErrorPromptUtil.h"

#import "ErrorPromptView.h"
#import "AppConfig.h"
#import "MusicStory-Common-Header.h"

@implementation ErrorPromptUtil

/// 从UIWindow中查找ErrorPromptView
+(ErrorPromptView *) findErrorPromptView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (window != NULL) {
        
        for (UIView *item in window.subviews) {
            if (item.tag == 1000) {
                return (ErrorPromptView *)item;
            }
        }
    }
    
    return NULL;
}

+(void)showErrorPrompt:(NSString *)msg {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == NULL) {
        return;
    }
    
    ErrorPromptView *errorPromptView = [self findErrorPromptView];
    if (errorPromptView == NULL) {
        errorPromptView = [[ErrorPromptView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        errorPromptView.alpha = 0;
        [window addSubview:errorPromptView];

        [errorPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(window);
            make.height.equalTo(@50);
        }];
    }
    
    errorPromptView.text = msg;
    errorPromptView.tag  = 1000;
    
    [UIWindow animateWithDuration:0.3 animations:^{
        errorPromptView.alpha = 1;
    }];
}

+(void)hideErrorPrompt {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *item in window.subviews) {
        if (item.tag == 1000) {
            [UIView animateWithDuration:0.3 animations:^{
                item.alpha = 0;
            }];
        }
    }
}

@end
