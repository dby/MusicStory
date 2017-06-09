//
//  MSHomeViewModel.h
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConfig.h"
#import "APIConfig.h"

#import "MSMusicModel.h"

#import "UIScrollView+MS.h"

#import <AVOSCloud/AVOSCloud.h>


#import "MSHomeHeaderView.h"
#import "MSHomeBottomitemView.h"
#import "MSHomeBottomCollectView.h"
#import "MSHomeCenterItemView.h"

typedef void (^MSHomeViewModelSuccessBack)(NSArray *datasource);
typedef void (^MSHomeViewModelErrorCallBack)(NSError *error);

@interface MSHomeViewModel : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) MSHomeHeaderView *headerView;
@property (nonatomic, weak) UICollectionView *centerView;
@property (nonatomic, weak) UICollectionView *bottomView;
@property (nonatomic, copy) MSHomeViewModelSuccessBack successCallBack ;
@property (nonatomic, copy) MSHomeViewModelErrorCallBack errorCallBack   ;

- (instancetype)initWithHeaderView:(MSHomeHeaderView *)regiHeaderView
                    withCenterView:(UICollectionView *)centerView
                    withBottomView:(UICollectionView*) bottomView;

- (void)getData:(NSInteger)page withSuccessBack:(MSHomeViewModelSuccessBack )successCallBack withErrorCallBack:(MSHomeViewModelErrorCallBack )errorCallBack;

@end
