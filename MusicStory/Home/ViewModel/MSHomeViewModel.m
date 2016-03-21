//
//  XMHomeViewModel.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeViewModel.h"

#import "AppConfig.h"
#import "APIConfig.h"

#import "MSHomeHeaderView.h"
#import "MSHomeBottomitemView.h"
#import "MSHomeCenterItemView.h"

typedef void (^successCallBack)(NSArray *datasource);
typedef void (^errorCallBack)(NSError *error);

@interface MSHomeViewModel ()

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, weak) MSHomeHeaderView *headerView;
@property (nonatomic, weak) UICollectionView *centerView;
@property (nonatomic, weak) UICollectionView *bottonView;
@property (nonatomic, copy) successCallBack MSHomeViewModelSuccessBack;
@property (nonatomic, copy) errorCallBack   MSHomeVieModelErrorCallBack;

@end

@implementation MSHomeViewModel

#pragma mark Init
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

#pragma mark - Function

- (void)getData:(NSNumber *)page withSuccessBack:(successCallBack )successCallBack withErrorCallBack:(errorCallBack )errorCallBack {
    
    self.MSHomeViewModelSuccessBack = successCallBack;
    self.MSHomeVieModelErrorCallBack = errorCallBack;
    
    NSDictionary *param = [NSDictionary dictionaryWithObject:page forKey:@"page"];
    NSString *httpString = @"";
    
    if ([_type isEqualToString: NOTIFY_OBJ_TODAY]) {
        httpString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", API_Server, @"/apps/app/daily/?", API_appVersion,API_openUDID,  API_resolution, API_systemVersion, API_pageSize, API_platform];
        //self.centerView.setHeaderHidden(false)
        //self.centerView.setFooterHidden(false)
        // 隐藏右标题
        //self.headerView.setRightTitleHidden(true)
    }
    else if ([_type isEqualToString:NOTIFY_OBJ_RECOMMEND]) {
        
    }
    else if ([_type isEqualToString:NOTIFY_OBJ_ARTICLE]) {
        
    } else {
        
    }
        
}

- (void)sendNotify_success:(NSNotification *)notify
{
    self.type = notify.object;
    //[self.centerView headerViewBeginRefreshing];
}

@end
