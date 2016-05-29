//
//  MSSearchViewModel.h
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MSMusicModel.h"
#import "UIScrollView+MS.h"
#import <AVOSCloud/AVOSCloud.h>

typedef void (^MSHomeViewModelSuccessBack)(NSArray *datasource);
typedef void (^MSHomeViewModelErrorCallBack)(NSError *error);

@interface MSSearchViewModel : NSObject

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) MSHomeViewModelSuccessBack successCallBack;
@property (nonatomic, copy) MSHomeViewModelErrorCallBack errorCallBack;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)getData:(NSString *)condition withSuccessBack:(MSHomeViewModelSuccessBack )successCallBack withErrorCallBack:(MSHomeViewModelErrorCallBack )errorCallBack;

@end
