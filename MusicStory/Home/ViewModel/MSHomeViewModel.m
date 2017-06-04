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
    debugMethod();
    self = [super init];
    if (self) {
        _dataSource = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendNotify_success:)
                                                     name:NOTIFY_SETUPHOMEVIEWTYPE
                                                   object:nil];
    }
    return self;
}

- (instancetype)initWithHeaderView:(MSHomeHeaderView *)regiHeaderView withCenterView:(UICollectionView *)centerView withBottomView:(UICollectionView*) bottomView {
    debugMethod();
    self = [self init];
    if (self) {
        _headerView = regiHeaderView;
        _centerView = centerView;
        _bottomView = bottomView;
    }
    return self;
}

#pragma mark - Function

/*!
 *  @brief 查询
 *
 *  @param page            每页默认为20条数据
 *  @param successCallBack 获取数据成功之后，进行的回调函数
 *  @param errorCallBack   获取数据失败之后，进行的回调函数
 *
 */
- (void)getData:(NSInteger)num withSuccessBack:(MSHomeViewModelSuccessBack )successCallBack withErrorCallBack:(MSHomeViewModelErrorCallBack )errorCallBack {
    debugMethod();
    self.successCallBack = successCallBack;
    self.errorCallBack   = errorCallBack;
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    if ([_type isEqualToString:NOTIFY_OBJ_music_story]) {
        // 音乐故事
        AVQuery *query = [AVQuery queryWithClassName:@"Musics"];
        query.limit = EVERY_DATA_NUM;
        query.skip  = num;
        [query orderByDescending:@"id"];
        [query whereKey:@"id" greaterThanOrEqualTo:@(0)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
        
                NSArray<AVObject *> *nearbyTodos = objects;
                for (AVObject *obj in nearbyTodos) {
            
                    MSMusicModel *model = [[MSMusicModel alloc] initWithAVO:obj];
                    [self.dataSource addObject:model];
                }
            
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
    } else if ([_type isEqualToString:NOTIFY_OBJ_music_collection]) {
        // 我的收藏
        AVUser *user = [AVUser currentUser];
        if (user) {
            
            AVRelation *relation    = [user relationForKey:@"musics_collections"];
            AVQuery *query          = [relation query];
            query.skip  = num;
            query.limit = EVERY_DATA_NUM;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSArray<AVObject *> *nearbyTodos = objects;
                    for (AVObject *obj in nearbyTodos) {
                        
                        MSMusicModel *model = [[MSMusicModel alloc] initWithAVO:obj];
                        [self.dataSource addObject:model];
                    }
                    
                    if (successCallBack) {
                        self.successCallBack(self.dataSource);
                    }
                } else {
                    debugLog(@"%@", [error description]);
                    if (errorCallBack) {
                        self.errorCallBack(nil);
                    }
                }
            }];
        } else {
            self.errorCallBack(nil);
        }
    }
}

- (void)sendNotify_success:(NSNotification *)notify {
    debugMethod();
    _type = notify.object;
    [self.centerView headerViewBeginRefreshing];
}

@end
