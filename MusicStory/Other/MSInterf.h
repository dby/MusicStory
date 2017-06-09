//
//  MSInterf.h
//  MusicStory
//
//  Created by sys on 16/8/8.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MSInterf : NSObject

// 网络是否可达
@property (nonatomic, assign) BOOL isNetWorkConnected;
@property (nonatomic, strong) NSMutableArray *backGroundColors;


+(instancetype)shareInstance;

@end
