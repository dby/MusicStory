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
        _dataSource = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNotify_success:) name:NOTIFY_SETUPHOMEVIEWTYPE object:nil];
    }
    
    return self;
}

- (instancetype)initWithHeaderView:(MSHomeHeaderView *)regiHeaderView withCenterView:(UICollectionView *)centerView withBottomView:(UICollectionView*) bottomView {
    self = [self init];
    if (self) {
        self.headerView = regiHeaderView;
        self.centerView = centerView;
        self.bottomView = bottomView;
    }
    return self;
}

#pragma mark - Function

- (void)getData:(NSInteger)page withSuccessBack:(MSHomeViewModelSuccessBack )successCallBack withErrorCallBack:(MSHomeVieModelErrorCallBack )errorCallBack {
    
    self.successCallBack = successCallBack;
    self.errorCallBack = errorCallBack;
    
    if ([_type isEqualToString: NOTIFY_OBJ_TODAY]) {
        
    }
    else if ([_type isEqualToString:NOTIFY_OBJ_RECOMMEND]) {
        
    }
    else if ([_type isEqualToString:NOTIFY_OBJ_ARTICLE]) {
        
    } else {
        
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"Musics"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
        
            NSArray<AVObject *> *nearbyTodos = objects;
            for (AVObject *obj in nearbyTodos) {
            
                MSMusicModel *model = [[MSMusicModel alloc] initWithAVO:obj];
                [self.dataSource addObject:model];
            }
            [self.centerView reloadData];
            [self.bottomView reloadData];
            
            sleep(2);
            
            if (successCallBack) {
                self.successCallBack(self.dataSource);
            }
        }
        else {
            if (errorCallBack) {
                self.errorCallBack(nil);
            }
        }
    }];
}

- (void)sendNotify_success:(NSNotification *)notify
{
    self.type = notify.object;
    //[self.centerView headerViewBeginRefreshing];
}

@end
