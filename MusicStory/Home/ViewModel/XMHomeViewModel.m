//
//  XMHomeViewModel.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "XMHomeViewModel.h"

#import "AppConfig.h"

#import "MSHomeHeaderView.h"
#import "MSHomeBottomitemView.h"
#import "MSHomeCenterItemView.h"

@interface XMHomeViewModel ()

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, weak) MSHomeHeaderView *headerView;
@property (nonatomic, weak) UICollectionView *centerView;
@property (nonatomic, weak) UICollectionView *bottonView;
@property (nonatomic, copy) void (^successCallBack)(NSArray *datasource);
@property (nonatomic, copy) void (^errorCallBack)(NSError *error);

@end

@implementation XMHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = @"homeViewTodayType";
        _dataSource = [[NSArray alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNotify_success:) name:NOTIFY_SETUPHOMEVIEWTYPE object:nil];
    }
    
    return self;
}

- (instancetype)initWithHeaderView:(MSHomeHeaderView *)regiHeaderView withCenterView:(UICollectionView *)centerView withBottomView:(UICollectionView*) bottomView {

    self = [self init];
    
    if (self) {
        self.headerView = regiHeaderView;
        self.centerView = centerView;
        self.bottonView = bottomView;
    }
    return self;
}

- (void)sendNotify_success:(NSNotification *)notify
{
    self.type = notify.object;
    //[self.centerView headerViewBeginRefreshing];
}

@end
