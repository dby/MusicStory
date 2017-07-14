//
//  MSHomeViewController.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeViewController.h"

#import "MSHomeHeaderView.h"
#import "MSHomeCenterItemView.h"
#import "MSHomeCenterFlowLayout.h"
#import "MSHomeBottomItemView.h"
#import "MSHomeBottomFlowLayout.h"
#import "MSHomeBottomCollectView.h"
#import "MSHomeCenterCollectionView.h"
#import "MSSlideViewController.h"

#import "MSHomeDetailController.h"

#import "MSMusicModel.h"
#import "MSRefreshBase.h"
#import "MSHomeViewModel.h"

@import GoogleMobileAds;

#import "musicStory-Common-Header.h"


@interface MSHomeViewController () <MSHomeHeaderViewDelegate, MSHomeHeaderViewDelegate,MSHomeBottomCollectViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, GADInterstitialDelegate>

// 当前评论的偏移
@property (nonatomic, assign) NSInteger pos;
@property (nonatomic, strong) NSMutableArray *homeDataArray;
// ViewModel对象
@property (nonatomic, strong) MSHomeViewModel *viewModel;
// 上一个index
@property (nonatomic, strong) NSIndexPath *lastIndex;
// 当前的index
@property (nonatomic, assign) NSInteger index;
// 是音乐故事 or 我的收藏
@property (nonatomic, assign) NSString *currentCollectionType;

@property (nonatomic, strong) MSHomeHeaderView *headerView;
@property (nonatomic, strong) MSHomeCenterCollectionView *centerCollectView;
@property (nonatomic, strong) MSHomeBottomCollectView *bottomCollectView;

@property (nonatomic, strong) MSHomeCenterItemView *currentCenterItemView;
@property (nonatomic, strong) MSMusicModel *currentModel;

@property (nonatomic, assign) NSInteger loadingThisPageNum;

// GoogleAds
@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MSHomeViewController

#pragma mark life circle

-(void)viewWillAppear:(BOOL)animated {
    debugMethod();
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    
    // 取消播放电影
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_PLAY_MUSIC" object:nil];
    
    // 显示广告
    if (self.loadingThisPageNum != 1) {
        int randomNumber = arc4random()%100 + 1;
        NSLog(@"randomNumber: %d", randomNumber);
        if (randomNumber < [MSInterf shareInstance].googleAdsStart) {
            [self showingGoogleAd];
        }
    }
    
    self.loadingThisPageNum++;
}

-(void)viewDidLoad {
    
    debugMethod();
    [super viewDidLoad];
    
    [self configureGoogleAds];
    self.interstitial = [self createAndLoadInterstitial];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorBtnDidClick)
                                                 name:NOTIFY_ERRORBTNCLICK
                                               object:nil];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomCollectView];
    [self.view addSubview:self.centerCollectView];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = UI_COLOR_APPNORMAL;
    
    [self buildRefreshView];
    [self showProgress];
    
    self.viewModel.type        = NOTIFY_OBJ_MUSIC_COLUMN;
    self.currentCollectionType = NOTIFY_OBJ_MUSIC_COLUMN;
    [self.viewModel getData:self.homeDataArray.count withSuccessBack:^(NSArray *datasource) {
        
        [self.homeDataArray addObjectsFromArray:datasource];
        [self.centerCollectView reloadData];
        [self.bottomCollectView reloadData];
        
        self.index      = 0;
        self.lastIndex  = nil;
        [self.bottomCollectView setContentOffset:CGPointZero animated:true];
        [self scrollViewDidEndDecelerating:self.centerCollectView];
        [self hiddenProgress];
    } withErrorCallBack:^(NSError *error) {
        [self showNetWorkErrorView];
        [self hiddenProgress];
    }];
    
    self.loadingThisPageNum = self.loadingThisPageNum + 1;
    
    // 适配屏幕
    [self setupLayout];
}

#pragma mark - init

-(void)buildRefreshView {
    
    [self.centerCollectView headerViewPullToRefresh:MSRefreshDirectionHorizontal callback:^{
        self.homeDataArray = [NSMutableArray new];
        if (![self.currentCollectionType isEqualToString:self.viewModel.type]) {
            self.currentCollectionType = self.viewModel.type;
            [self.centerCollectView reloadData];
            [self.bottomCollectView reloadData];
            [self showProgress];
        }
        debugLog(@"执行 headerViewPullToRefresh 回调函数...");
        [self.viewModel getData:0 withSuccessBack:^(NSArray *datasource) {
            if (datasource.count == 0) {
                [SVProgressHUD setMinimumDismissTimeInterval:0.3];
                [SVProgressHUD showErrorWithStatus:@"温馨提示，没有更多数据了..."];
            } else {
                [self.homeDataArray addObjectsFromArray:datasource];
                [self.centerCollectView reloadData];
                [self.bottomCollectView reloadData];
                
                self.index      = 0;
                self.lastIndex  = nil;
                [self.bottomCollectView setContentOffset:CGPointZero animated:true];
                [self scrollViewDidEndDecelerating:self.centerCollectView];
            }
            [self hiddenProgress];
            [self.centerCollectView headerViewStopPullToRefresh];
        } withErrorCallBack:^(NSError *error) {
            [self.centerCollectView headerViewStopPullToRefresh];
        }];
    }];
    
    [self.centerCollectView footerViewPullToRefresh:MSRefreshDirectionHorizontal callback:^{
        if (![self.currentCollectionType isEqualToString:self.viewModel.type]) {
            self.index = -1;
            self.lastIndex = nil;
            self.homeDataArray = [NSMutableArray new];
            self.currentCollectionType = self.viewModel.type;
        }
        debugLog(@"执行 footViewPullToRefresh 回调函数...");
        [self.viewModel getData:self.homeDataArray.count withSuccessBack:^(NSArray *datasource) {
            if (datasource.count == 0) {
                [SVProgressHUD setMinimumDismissTimeInterval:0.3];
                [SVProgressHUD showInfoWithStatus:@"温馨提示，没有数据了..."];
            } else {
                [self.homeDataArray addObjectsFromArray:datasource];
                [self.centerCollectView reloadData];
                [self.bottomCollectView reloadData];
                self.index++;
                [self scrollViewDidEndDecelerating:self.centerCollectView];
            }
            [self.centerCollectView footerViewStopPullToRefresh];
        } withErrorCallBack:^(NSError *error) {
            [self.centerCollectView footerViewStopPullToRefresh];
        }];
    }];
}

#pragma mark - Function
-(void)configureGoogleAds {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showingGoogleAd) name:@"SHOWING_GOOGLE_ADS" object:nil];
}

-(void)showingGoogleAd {
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Google ads 没有准备好...");
    }
}

#pragma mark - ScrollerDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    debugMethod();
    if (scrollView.tag == 100) {
        int index = (int)((scrollView.contentOffset.x + 0.5 * scrollView.width) / scrollView.width);
        if (index > [self.homeDataArray count] - 1) {
            self.index = [self.homeDataArray count] - 1;
        }
        else if (self.index != index){
            self.index = index;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    debugMethod();
    if (scrollView.tag == 100 && self.homeDataArray.count && self.index <= self.homeDataArray.count) {
        // 设置底部动画
        [self bottomAnimation: [NSIndexPath indexPathForRow:self.index inSection:0]];
        // 发送通知改变侧边栏的颜色
        MSMusicModel *model     = self.homeDataArray[self.index];
        NSNotification *noti    = [NSNotification notificationWithName:NOTIFY_SETUPBG
                                                                object:model.recommanded_background_color];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
}

#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    debugMethod();
    return [self.homeDataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    debugLog(@"viewModel: %@", self.viewModel);
    debugLog(@"viewModel len: %lu", (unsigned long)[self.homeDataArray count]);
    
    MSMusicModel *model = [self.homeDataArray objectAtIndex:indexPath.row];
    if (collectionView.tag == 100) {
        NSLog(@"center indexPath.row %ld", (long)indexPath.row);
        
        MSHomeCenterItemView *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSHomeCenterItemViewID" forIndexPath:indexPath];
        cell.homeModel              = model;
        
        self.currentCenterItemView  = cell;
        self.currentModel = [self.homeDataArray objectAtIndex:indexPath.row];
        
        cell.userInteractionEnabled = YES;
        //UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
        //                                                                                    action:@selector(addLike:)];
        //[cell.fovView addGestureRecognizer:gestureRecognizer];
        //[cell.iconFlowerButton addGestureRecognizer:gestureRecognizer];
        
        return cell;
        
    } else {
        
        MSHomeBottomitemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSHomeBottomItemViewID" forIndexPath:indexPath];
        cell.y          = BOTTOM_VIEW_NOR_Y;
        cell.iconUrl    = model.singer_portrait;
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    MSHomeDetailController *mshdc = [[MSHomeDetailController alloc] initWithModel:[self.homeDataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:mshdc animated:YES];
}

#pragma mark - Custom Delegate
-(void)homeHeaderViewMoveToFirstDidClick:(MSHomeHeaderView *)headerView :(UIButton *)moveToFirstBtn {
    debugMethod();
    [self.centerCollectView setContentOffset:CGPointZero animated:false];
    [self.bottomCollectView setContentOffset:CGPointZero animated:false];
    self.index = 0;
    [self scrollViewDidEndDecelerating:self.centerCollectView];
}

-(void)homeHeaderViewMenuDidClick:(MSHomeHeaderView *)header :(UIButton *)menuBtn {
    debugMethod();
    MSSlideViewController *slideController = self.sideMenuViewController.leftController.childViewControllers.firstObject;
    slideController.model = self.currentModel;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOWMENU object:nil];
}

-(void)homeBottomCollectView:(UICollectionView *)bottomView touchIndexDidChangeWithIndexPath:(NSIndexPath *)indexPath cellArrayCount:(NSUInteger)cellArrayCount {
    
    debugMethod();
    [self.centerCollectView scrollToItemAtIndexPath:indexPath
                                   atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                           animated:false];
    self.index = indexPath.row;
    // 执行底部横向动画
    UICollectionViewCell *cell = [self.bottomCollectView cellForItemAtIndexPath:indexPath];
    // 如果当前不够7个item就不让他滚动
    [self bottomHorizontalAnimation:cell forIndexPath:indexPath];
    // 发送通知改变侧滑菜单的颜色
    MSMusicModel *model     = [self.homeDataArray objectAtIndex:_index];
    NSNotification *noti    = [NSNotification notificationWithName:NOTIFY_SETUPBG
                                                            object:model.recommanded_background_color];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    self.lastIndex = indexPath;
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:[MSInterf shareInstance].insertUnitId];
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [interstitial loadRequest:request];
    return interstitial;
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    self.interstitial = [self createAndLoadInterstitial];
}

#pragma mark - Action
- (void) errorBtnDidClick {
    debugMethod();
    [self.centerCollectView headerViewBeginRefreshing];
}

- (void) addLike:(UITapGestureRecognizer *)gestureRecognizer {
    debugMethod();
    if (self.currentCenterItemView) {
        
        UIView *fovView = (UIView *)[gestureRecognizer view];
        UIImageView *imageView = NULL;
        
        for (UIView *item in fovView.subviews) {
            if (item.tag == 999) {
                imageView = (UIImageView *)item;
            }
        }
        debugLog(@"%d", [imageView isHighlighted]);
        
        if (![imageView isHighlighted]) {
            
            self.currentCenterItemView.fovCountLabel.text = [NSString stringWithFormat:@"%d", [self.currentModel.like_count intValue] + 1];
            AVObject *music = [AVObject objectWithClassName:@"Musics" objectId:self.currentModel.objectId];
            [music setObject:[NSString stringWithFormat:@"%d", [self.currentModel.like_count intValue] + 1] forKey:@"like_count"];
            [music saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.currentModel.like_count = [NSString stringWithFormat:@"%d", [self.currentModel.like_count intValue] + 1];
                    AVUser *user = [AVUser currentUser];
                    NSMutableArray *hasLikedMusicArr = [user objectForKey:@"hasLikedMusic"];
                    debugLog(@"%@", hasLikedMusicArr);
                    if (!hasLikedMusicArr) {
                        hasLikedMusicArr = [[NSMutableArray alloc] init];
                    } else if (![hasLikedMusicArr containsObject:self.currentModel.objectId]) {
                        // 原先没有赞过
                        [hasLikedMusicArr addObject:self.currentModel.objectId];
                        [user setObject:hasLikedMusicArr forKey:@"hasLikedMusic"];
                        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                debugLog(@"save success");
                            } else {
                                debugLog(@"save failed");
                            }
                        }];
                    }
                } else {
                }
            }];
            
            [imageView setHighlighted:YES];
        }
        else {
            self.currentCenterItemView.fovCountLabel.text = [NSString stringWithFormat:@"%d", [self.currentModel.like_count intValue] - 1];
            AVObject *music = [AVObject objectWithClassName:@"Musics" objectId:_currentModel.objectId];
            [music setObject:[NSString stringWithFormat:@"%d", [self.currentModel.like_count intValue] - 1] forKey:@"like_count"];
            [music saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.currentModel.like_count = [NSString stringWithFormat:@"%d", [self.currentModel.like_count intValue] - 1];
                } else {
                }
            }];
            
            [imageView setHighlighted:NO];
        }
    }
}

#pragma mark - Animation Method
// 底部标签动画
- (void)bottomAnimation:(NSIndexPath *)indexpath {
    debugMethod();
    
    if (self.lastIndex != nil && self.lastIndex.row == indexpath.row) {
        return;
    }
    
    MSHomeBottomitemView *cell = (MSHomeBottomitemView *)[self.bottomCollectView cellForItemAtIndexPath:indexpath];
    if (cell == nil) {
        [self.bottomCollectView layoutIfNeeded];
        cell = (MSHomeBottomitemView *)[self.bottomCollectView cellForItemAtIndexPath:indexpath];
    }
    
    if (cell != nil) {
        // 底部横向动画
        [self bottomHorizontalAnimation:cell forIndexPath:indexpath];
        // 底部纵向动画
        [self bottomVertical:cell];
        
        self.lastIndex = indexpath;
    }
}

// 横向动画
- (void)bottomHorizontalAnimation:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    debugMethod();
    if ([self.homeDataArray count] < 7) {
        return;
    }
    
    if (cell.x < SCREEN_WIDTH * 0.6) {
        [self.bottomCollectView setContentOffset:CGPointZero animated:true];
    } else {
        CGFloat newX = 0;
        // 判断下一个还是上一个
        if (self.lastIndex.row < indexPath.row) {
            // 下一个
            newX = self.bottomCollectView.contentOffset.x + cell.width + 2;
        } else {
            newX = self.bottomCollectView.contentOffset.x - cell.width - 2;
        }
        [self.bottomCollectView setContentOffset:CGPointMake(newX, 0) animated:true];
    }
}

// 纵向动画
- (void)bottomVertical:(UICollectionViewCell *)cell {
    
    debugMethod();
    [UIView animateWithDuration:0.2 animations:^{
        cell.y = BOTTOM_VIEW_MINEST_Y;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            cell.y = BOTTOM_VIEW_MIN_Y;
        }];
    }];
    
    UICollectionViewCell *lastBottomView = [self.bottomCollectView cellForItemAtIndexPath:self.lastIndex];
    
    if (lastBottomView != nil) {
        [UIView animateWithDuration:0.2 animations:^{
            lastBottomView.y = BOTTOM_VIEW_MAX_Y;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                lastBottomView.y = BOTTOM_VIEW_NOR_Y;
            }];
        }];
    }
}

- (void)setupLayout {
    debugMethod();
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.height.equalTo(@headerViewHeight);
        make.left.right.equalTo(self.view);
    }];
    
    [self.bottomCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@bottomViewHeight);
    }];
    
    [self.centerCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.bottomCollectView.mas_top);
    }];
}

#pragma mark - Setter Getter
-(void)setIndex:(NSInteger)index {
    
    debugMethod();
    _index = index;
    if ([self.homeDataArray count] == 0 || index < 0) {
        return;
    }
    // 获取模型
    MSMusicModel *model = self.homeDataArray[index];
    // 设置header的模型
    self.headerView.homeModel = model;
    // 设置背景动画
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = model.recommanded_background_color;
        if (self.centerCollectView) {
            self.centerCollectView.backgroundColor = model.recommanded_background_color;
        }
        if (self.bottomCollectView) {
            self.bottomCollectView.backgroundColor = model.recommanded_background_color;
        }
    }];
}

-(NSMutableArray *)homeDataArray {
    if (!_homeDataArray) {
        _homeDataArray = [[NSMutableArray alloc] init];
    }
    return _homeDataArray;
}

-(MSHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView             = [MSHomeHeaderView new];
        _headerView.delegate    = self;
    }
    return _headerView;
}

-(MSHomeCenterCollectionView *)centerCollectView {
    if (!_centerCollectView) {
        MSHomeCenterFlowLayout *collectLayout = [[MSHomeCenterFlowLayout alloc] init];
        _centerCollectView = [[MSHomeCenterCollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:collectLayout];
        
        _centerCollectView.delegate                         = self;
        _centerCollectView.dataSource                       = self;
        _centerCollectView.showsHorizontalScrollIndicator   = false;
        _centerCollectView.pagingEnabled                    = true;
        _centerCollectView.alwaysBounceHorizontal           = true;

        _centerCollectView.backgroundColor  = UI_COLOR_APPNORMAL;
        _centerCollectView.tag              = 100;
        
        [_centerCollectView registerNib:[UINib nibWithNibName:@"MSHomeCenterItemView" bundle:nil] forCellWithReuseIdentifier:@"MSHomeCenterItemViewID"];
    }
    return _centerCollectView;
}

-(MSHomeBottomCollectView *)bottomCollectView {
    if (!_bottomCollectView) {
        MSHomeBottomFlowLayout *collectionLayout = [[MSHomeBottomFlowLayout alloc] init];
        _bottomCollectView = [[MSHomeBottomCollectView alloc] initWithFrame:CGRectZero
                                                       collectionViewLayout:collectionLayout];
        _bottomCollectView.bottomViewDelegate   = self;
        _bottomCollectView.delegate             = self;
        _bottomCollectView.dataSource           = self;
        _bottomCollectView.backgroundColor      = UI_COLOR_APPNORMAL;
    }
    return _bottomCollectView;
}

-(MSHomeViewModel *)viewModel {
    if (!_viewModel) {
        // 获取ViewModel
        _viewModel = [[MSHomeViewModel alloc] initWithHeaderView:self.headerView
                                                  withCenterView:self.centerCollectView
                                                  withBottomView:self.bottomCollectView];
    }
    return _viewModel;
}
@end
