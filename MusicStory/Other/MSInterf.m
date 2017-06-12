//
//  MSInterf.m
//  MusicStory
//
//  Created by sys on 16/8/8.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSInterf.h"

@interface MSInterf()

@end

@implementation MSInterf

+(instancetype)shareInstance {
    
    static MSInterf *sharedMyManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
        sharedMyManager.isNetWorkConnected = false;
        sharedMyManager.applicationId       = @"";
        sharedMyManager.cellId              = @"ca-app-pub-3940256099942544/4411468910";
        sharedMyManager.googleAdsStart      = 180;
        sharedMyManager.googleAdsInterval   = 300;
        sharedMyManager.appId               = @"1236619918";
    });
    
    return sharedMyManager;
}

-(NSMutableArray *)backGroundColors {
    if (!_backGroundColors) {
        _backGroundColors = [[NSMutableArray alloc] init];
        
        [_backGroundColors addObject:[UIColor colorWithRed:42/255.0  green:163/255.0 blue:196/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:241/255.0 green:85/255.0  blue:39/255.0  alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:47/255.0  green:191/255.0 blue:179/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:122/255.0 green:139/255.0 blue:177/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:239/255.0 green:145/255.0 blue:0         alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:161/255.0 green:129/255.0 blue:187/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:237/255.0 green:98/255.0  blue:127/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:235/255.0 green:179/255.0 blue:48/255.0  alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:84/255.0  green:193/255.0 blue:216/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:42/255.0  green:158/255.0 blue:219/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:153/255.0 green:109/255.0 blue:190/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:100/255.0 green:188/255.0 blue:164/255.0 alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:206/255.0 green:48/255.0  blue:90/255.0  alpha:1.0]];
        [_backGroundColors addObject:[UIColor colorWithRed:45/255.0  green:173/255.0 blue:216/255.0 alpha:1.0]];
    }
    
    return _backGroundColors;
}



@end
