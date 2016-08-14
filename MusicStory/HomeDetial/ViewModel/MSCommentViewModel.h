//
//  MSCommentViewModel.h
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConfig.h"
#import <AVOSCloud/AVOSCloud.h>

typedef void (^MSHomeViewModelSuccessBack)(NSArray *datasource);
typedef void (^MSHomeViewModelErrorCallBack)(NSError *error);

@interface MSCommentViewModel : NSObject

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, copy) MSHomeViewModelSuccessBack successCallBack;
@property (nonatomic, copy) MSHomeViewModelErrorCallBack errorCallBack;

- (void)getCommentData:(NSInteger)num withSuccessBack:(MSHomeViewModelSuccessBack )successCallBack withErrorCallBack:(MSHomeViewModelErrorCallBack )errorCallBack;

-(instancetype)initWithCommentTableView : (UITableView *)tableView;

@end
