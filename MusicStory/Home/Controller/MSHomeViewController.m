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

#import "MSHomeDetailViewController.h"

#import "MSHomeViewModel.h"
#import "MSMusicModel.h"
#import "MSRefreshBase.h"

#import "UIColor+MS.h"
#import "UIView+MS.h"
#import "UIScrollView+MS.h"
#import "UIViewController+MS.h"

#import "Masonry.h"
#import <RESideMenu/RESideMenu.h>

@interface MSHomeViewController () <MSHomeHeaderViewDelegate, MSHomeHeaderViewDelegate,MSHomeBottomCollectViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

// 页数
@property (nonatomic, assign) NSInteger page;
// ViewModel对象
@property (nonatomic, strong) MSHomeViewModel *viewModel;
// 上一个index
@property (nonatomic, strong) NSIndexPath *lastIndex;
// 当前的index
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) MSHomeHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *centerCollectView;
@property (nonatomic, strong) MSHomeBottomCollectView *bottomCollectView;
@property (nonatomic, strong) MSHomeDetailViewController *detailViewController;

@property (nonatomic, strong) MSHomeCenterItemView *currentCenterItemView;
@property (nonatomic, strong) MSMusicModel *currentModel;

@end

@implementation MSHomeViewController

@synthesize index = _index;

#pragma mark - Setter Getter
-(NSInteger)index {
    debugMethod();
    return _index;
}
-(void)setIndex:(NSInteger)index {
    
    debugMethod();
    _index = index;
    if ([_viewModel.dataSource count] == 0) {
        return;
    }
    // 获取模型
    MSMusicModel *model = self.viewModel.dataSource[index];
    // 设置header的模型
    self.headerView.homeModel = model;
    // 设置背景动画
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor colorWithHexString: model.recommanded_background_color];
    }];
}

#pragma mark life circle
- (void)viewDidLoad {
    
    debugMethod();
    [super viewDidLoad];
    
    [self initComponents];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorBtnDidClick)
                                                 name:NOTIFY_ERRORBTNCLICK
                                               object:nil];
    
    self.view.backgroundColor = UI_COLOR_APPNORMAL;
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:_headerView];
    [self.view addSubview:_centerCollectView];
    [self.view addSubview:_bottomCollectView];
    
    // 获取ViewModel
    _viewModel = [[MSHomeViewModel alloc] initWithHeaderView:_headerView
                                              withCenterView:_centerCollectView
                                              withBottomView:_bottomCollectView];
    
    [self.centerCollectView headerViewPullToRefresh:MSRefreshDirectionHorizontal callback:^{
        debugLog(@"执行 headerViewPullToRefresh 回调函数...");
        [self.viewModel getData:self.page withSuccessBack:^(NSArray *datasource) {
            
            self.index      = 0;
            self.lastIndex  = nil;
            [self.bottomCollectView setContentOffset:CGPointZero animated:true];
            [self scrollViewDidEndDecelerating:self.centerCollectView];
            [self.centerCollectView headerViewStopPullToRefresh];
            
        } withErrorCallBack:^(NSError *error) {
            
            [self.centerCollectView headerViewStopPullToRefresh];
            
        }];
    }];
    
    [self.centerCollectView footerViewPullToRefresh:MSRefreshDirectionHorizontal callback:^{
        debugLog(@"执行 footViewPullToRefresh 回调函数...");
        [self.viewModel getData:self.page withSuccessBack:^(NSArray *datasource) {
            
            [self.centerCollectView footerViewStopPullToRefresh];
            
        } withErrorCallBack:^(NSError *error) {
            [self.centerCollectView footerViewStopPullToRefresh];
        }];
    }];
    
    [self showProgress];
    self.viewModel.type = NOTIFY_OBJ_HOME;
    [self.viewModel getData:self.page withSuccessBack:^(NSArray *datasource) {
        self.index      = 0;
        self.lastIndex  = nil;
        [self.bottomCollectView setContentOffset:CGPointZero animated:true];
        [self scrollViewDidEndDecelerating:self.centerCollectView];
        [self hiddenProgress];
    } withErrorCallBack:^(NSError *error) {
        [self showNetWorkErrorView];
        [self hiddenProgress];
    }];
    // 适配屏幕
    [self setupLayout];
}

#pragma mark Init

- (void)initComponents {
    
    debugMethod();
    
    _headerView             = [[MSHomeHeaderView alloc] init];
    _headerView.delegate    = self;
    
    MSHomeCenterFlowLayout *collectLayout = [[MSHomeCenterFlowLayout alloc] init];
    self.centerCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 420)
                                                collectionViewLayout:collectLayout];
    
    self.centerCollectView.delegate                         = self;
    self.centerCollectView.dataSource                       = self;
    self.centerCollectView.showsHorizontalScrollIndicator   = false;
    self.centerCollectView.pagingEnabled                    = true;
    
    [self.centerCollectView registerNib:[UINib nibWithNibName:@"MSHomeCenterItemView" bundle:nil] forCellWithReuseIdentifier:@"MSHomeCenterItemViewID"];
    self.centerCollectView.backgroundColor  = [UIColor clearColor];
    self.centerCollectView.tag              = 100;
    
    MSHomeBottomFlowLayout *collectionLayout = [[MSHomeBottomFlowLayout alloc] init];
    self.bottomCollectView = [[MSHomeBottomCollectView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH-60, SCREEN_WIDTH, 60) collectionViewLayout:collectionLayout];
    self.bottomCollectView.bottomViewDelegate   = self;
    self.bottomCollectView.delegate             = self;
    self.bottomCollectView.dataSource           = self;
    
    [self initRESlideMenu];
}

- (void)initRESlideMenu {
    debugMethod();
    self.sideMenuViewController.scaleMenuView       = false;
    self.sideMenuViewController.scaleContentView    = false;
}

#pragma mark - scrollerDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    debugMethod();
    if (scrollView.tag == 100) {
        int index = (int)((scrollView.contentOffset.x + 0.5*scrollView.width) / scrollView.width);
        if (index > [self.viewModel.dataSource count] - 1) {
            self.index = [self.viewModel.dataSource count] - 1;
        } else {
            self.index = index;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    debugMethod();
    if (scrollView.tag == 100) {
        // 设置底部动画
        [self bottomAnimation: [NSIndexPath indexPathForRow:_index inSection:0]];
        // 发送通知改变侧边栏的颜色
        MSMusicModel *model     = self.viewModel.dataSource[_index];
        NSNotification *noti    = [NSNotification notificationWithName:NOTIFY_SETUPBG
                                                                object:model.recommanded_background_color];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
}

#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    debugMethod();
    return [self.viewModel.dataSource count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    MSMusicModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    if (collectionView.tag == 100) {
        
        MSHomeCenterItemView *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSHomeCenterItemViewID" forIndexPath:indexPath];
        cell.homeModel              = model;
        
        _currentCenterItemView = cell;
        _currentModel = [self.viewModel.dataSource objectAtIndex:indexPath.row];
        
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(addLike:)];
        [cell.iconFlowerButton addGestureRecognizer:gestureRecognizer];
        
        return cell;
        
    } else {
        
        MSHomeBottomitemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSHomeBottomItemViewID" forIndexPath:indexPath];
        cell.y          = 50;
        cell.iconUrl    = model.icon_image;
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    MSHomeDetailViewController *mshdc = [[MSHomeDetailViewController alloc] initWithModel:[self.viewModel.dataSource objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:mshdc animated:YES];
}

#pragma mark - Custom Delegate
-(void)homeHeaderViewMoveToFirstDidClick:(MSHomeHeaderView *)headerView :(UIButton *)moveToFirstBtn {
    debugMethod();
    [_centerCollectView setContentOffset:CGPointZero animated:false];
    [_bottomCollectView setContentOffset:CGPointZero animated:false];
    self.index = 0;
    [self scrollViewDidEndDecelerating:self.centerCollectView];
}

-(void)homeHeaderViewMenuDidClick:(MSHomeHeaderView *)header :(UIButton *)menuBtn {
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOWMENU object:nil];
    
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)homeBottomCollectView:(UICollectionView *)bottomView touchIndexDidChangeWithIndexPath:(NSIndexPath *)indexPath cellArrayCount:(NSUInteger)cellArrayCount {
    
    debugMethod();
    [_centerCollectView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    self.index = indexPath.row;
    // 执行底部横向动画
    UICollectionViewCell *cell = [self.bottomCollectView cellForItemAtIndexPath:indexPath];
    // 如果当前不够8个item就不让他滚动
    [self bottomHorizontalAnimation:cell forIndexPath:indexPath];
    // 发送通知改变侧滑菜单的颜色
    MSMusicModel *model = [self.viewModel.dataSource objectAtIndex:_index];
    NSNotification *noti = [NSNotification notificationWithName:NOTIFY_SETUPBG object:model.recommanded_background_color];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    self.lastIndex = indexPath;
}

#pragma mark - Action
- (void) errorBtnDidClick {
    debugMethod();
    [self.centerCollectView headerViewBeginRefreshing];
}

- (void) addLike:(UITapGestureRecognizer *)gestureRecognizer {
    debugMethod();
    if (_currentCenterItemView) {
        
        UIImageView *imageView = (UIImageView *)[gestureRecognizer view];
        debugLog(@"%d", [imageView isHighlighted]);
        
        if (![imageView isHighlighted]) {
            
            _currentCenterItemView.fovCountLabel.text = [NSString stringWithFormat:@"%d", [_currentModel.like_count intValue] + 1];
            AVObject *music = [AVObject objectWithClassName:@"Musics" objectId:_currentModel.objectId];
            [music setObject:[NSString stringWithFormat:@"%d", [_currentModel.like_count intValue] + 1] forKey:@"like_count"];
            [music saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    _currentModel.like_count = [NSString stringWithFormat:@"%d", [_currentModel.like_count intValue] + 1];
                    AVUser *user = [AVUser currentUser];
                    NSMutableArray *hasLikedMusicArr = [user objectForKey:@"hasLikedMusic"];
                    debugLog(@"%@", hasLikedMusicArr);
                    if (!hasLikedMusicArr) {
                        hasLikedMusicArr = [[NSMutableArray alloc] init];
                    } else if (![hasLikedMusicArr containsObject:_currentModel.objectId]) {
                        // 原先没有赞过
                        [hasLikedMusicArr addObject:_currentModel.objectId];
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
            _currentCenterItemView.fovCountLabel.text = [NSString stringWithFormat:@"%d", [_currentModel.like_count intValue] - 1];
            AVObject *music = [AVObject objectWithClassName:@"Musics" objectId:_currentModel.objectId];
            [music setObject:[NSString stringWithFormat:@"%d", [_currentModel.like_count intValue] - 1] forKey:@"like_count"];
            [music saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    _currentModel.like_count = [NSString stringWithFormat:@"%d", [_currentModel.like_count intValue] - 1];
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
    
    if (cell == nil) {
        [self.bottomCollectView reloadData];
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
    if ([self.viewModel.dataSource count] < 8) {
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
        cell.y = 10;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            cell.y = 15;
        }];
    }];
    
    UICollectionViewCell *lastBottomView = [self.bottomCollectView cellForItemAtIndexPath:self.lastIndex];
    
    if (lastBottomView != nil) {
        [UIView animateWithDuration:0.2 animations:^{
            lastBottomView.y = 60;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                lastBottomView.y = 50;
            }];
        }];
    }
}

- (void)setupLayout {
    
    debugMethod();
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@(SCREEN_HEIGHT*50/IPHONE5_HEIGHT));
        make.left.right.equalTo(self.view);
    }];
    
    [_bottomCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(SCREEN_HEIGHT*60/IPHONE5_HEIGHT));
    }];
    
    
    [_centerCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        //TODO: 这里需要查找为什么 headerView Height 为 320
        make.top.equalTo(_headerView).offset(50);
        make.height.equalTo(@(SCREEN_HEIGHT*420/IPHONE5_HEIGHT));
    }];
}
@end