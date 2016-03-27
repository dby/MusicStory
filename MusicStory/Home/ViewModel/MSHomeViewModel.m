//
//  XMHomeViewModel.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeViewModel.h"

@interface MSHomeViewModel ()

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

- (void)getData:(NSInteger)page withSuccessBack:(MSHomeViewModelSuccessBack )successCallBack withErrorCallBack:(MSHomeVieModelErrorCallBack )errorCallBack {
    
    self.successCallBack = successCallBack;
    self.errorCallBack = errorCallBack;
    
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:page] forKey:@"page"];
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
    
    // 获得数据
    MusicStoryRequest *msr = [[MusicStoryRequest alloc] initWithType:MusicStoryTypeSpecific withPara:NULL];
    // 开始刷新
    [msr startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (self.successCallBack) {
            self.successCallBack([request.responseJSONObject objectForKey:@"data"]);
        }
        // 停止刷新
        // 刷新界面
        [self.centerView reloadData];
        [self.bottonView reloadData];
    } failure:^(YTKBaseRequest *request) {
        if (self.errorCallBack) {
        }
    }];
}

- (void)sendNotify_success:(NSNotification *)notify
{
    self.type = notify.object;
    //[self.centerView headerViewBeginRefreshing];
}

@end
