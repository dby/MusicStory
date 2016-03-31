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

#import "MSHomeViewModel.h"
#import "MSHomeDataModel.h"

#import "UIColor+MS.h"
#import "UIView+MS.h"
#import "Masonry.h"
#import "UIViewController+MS.h"


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

@end

@implementation MSHomeViewController
@synthesize index               = _index;

#pragma mark - Setter Getter
-(NSInteger)index {
    return _index;
}
-(void)setIndex:(NSInteger)index {
    _index = index;
    if ([self.viewModel.dataSource count] == 0) {
        return;
    }
    // 获取模型
    MSHomeDataModel *model = self.viewModel.dataSource[index];
    // 设置header的模型
    self.headerView.homeModel = model;
    // 设置背景动画
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor colorWithHexString: model.recommanded_background_color];
    }];
}

-(MSHomeHeaderView *)headerView {
    _headerView = [[MSHomeHeaderView alloc] init];
    _headerView.delegate = self;
    
    return _headerView;
}

-(UICollectionView *)centerCollectView {
    MSHomeCenterFlowLayout *collectLayout = [[MSHomeCenterFlowLayout alloc] init];
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 420) collectionViewLayout:collectLayout];
    
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.showsHorizontalScrollIndicator = false;
    collectView.pagingEnabled = true;
    
    [collectView registerNib:[UINib nibWithNibName:@"MSHomeCenterItemView" bundle:nil] forCellWithReuseIdentifier:@"MSHomeCenterItemViewID"];
    collectView.backgroundColor = [UIColor clearColor];
    collectView.tag  = 100;
    
    return collectView;
}

-(MSHomeBottomCollectView *)bottomCollectView {
    MSHomeBottomFlowLayout *collectionLayout = [[MSHomeBottomFlowLayout alloc] init];
    MSHomeBottomCollectView *collectView = [[MSHomeBottomCollectView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH-60, SCREEN_WIDTH, 60) collectionViewLayout:collectionLayout];
    
    collectView.bottomViewDelegate = self;
    collectView.delegate = self;
    collectView.dataSource = self;
    
    return collectView;
}

#pragma mark life circle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initComponents];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorBtnDidClick) name:NOTIFY_ERRORBTNCLICK object:nil];
    // 初始化界面
    self.view.backgroundColor = UI_COLOR_APPNORMAL;
    // 添加头部view
    [self.view addSubview:_headerView];
    // 添加中间的Collection
    [self.view addSubview:_centerCollectView];
    // 添加底部的Collection
    [self.view addSubview:_bottomCollectView];
    
    // 获取ViewModel
    _viewModel = [[MSHomeViewModel alloc] initWithHeaderView:_headerView withCenterView:_centerCollectView withBottomView:_bottomCollectView];
    // 获取数据
    [self.viewModel getData:self.page withSuccessBack:^(NSArray *datasource) {
        // 默认选择0
        self.lastIndex = nil;
        self.index = 0;
        [self.bottomCollectView setContentOffset:CGPointZero animated:false];
        [self scrollViewDidEndDecelerating:self.centerCollectView];
        
    } withErrorCallBack:^(NSError *error) {
        
    }];
    
    // 加载更多
#warning 加载更多未完成
    // 首次加载时， 中间显示加载框
    
    [self showProgress];
    [self.viewModel getData:self.page withSuccessBack:^(NSArray *datasource) {
        // 默认选中0
        self.lastIndex = nil;
        self.index = 0;
        [self.bottomCollectView setContentOffset:CGPointZero animated:false];
        [self scrollViewDidEndDecelerating:self.centerCollectView];
        
        [self hiddenProgress];
    } withErrorCallBack:^(NSError *error) {
        // 显示网络错误按钮
        [self showNetWorkErrorView];
        [self hiddenProgress];
        
    }];
    // 适配屏幕
    [self setupLayout];
}

#pragma mark Init

- (void)initComponents {
    self.headerView = [self headerView];
    self.centerCollectView = [self centerCollectView];
    self.bottomCollectView = [self bottomCollectView];
}

#pragma mark - scrollerDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
    if (scrollView.tag == 100) {
        // 设置底部动画
        [self bottomAnimation: [NSIndexPath indexPathForRow:_index inSection:0]];
        // 发送通知改变侧边栏的颜色
        MSHomeDataModel *model = self.viewModel.dataSource[_index];
        NSNotification *noti = [NSNotification notificationWithName:NOTIFY_SETUPBG object:model.recommanded_background_color];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
}


#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.dataSource count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSHomeDataModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    if (collectionView.tag == 100) {
        MSHomeCenterItemView *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"MSHomeCenterItemViewID" forIndexPath:indexPath];
        cell.homeModel = model;
        
        return cell;
    } else {
        MSHomeBottomitemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSHomeBottomItemViewID" forIndexPath:indexPath];
        cell.y = 50;
        cell.iconUrl = model.icon_image;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didselect");
}

#pragma mark - Custom Delegate
-(void)homeHeaderViewMoveToFirstDidClick:(MSHomeHeaderView *)headerView :(UIButton *)moveToFirstBtn {
    [_centerCollectView setContentOffset:CGPointZero animated:false];
    [_bottomCollectView setContentOffset:CGPointZero animated:false];
    self.index = 0;
    [self scrollViewDidEndDecelerating:self.centerCollectView];
}

-(void)homeHeaderViewMenuDidClick:(MSHomeHeaderView *)header :(UIButton *)menuBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOWMENU object:nil];
}

-(void)homeBottomCollectView:(UICollectionView *)bottomView touchIndexDidChangeWithIndexPath:(NSIndexPath *)indexPath cellArrayCount:(NSUInteger)cellArrayCount {
    
    [_centerCollectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    self.index = indexPath.row;
    // 执行底部横向动画
    UICollectionViewCell *cell = [self.bottomCollectView cellForItemAtIndexPath:indexPath];
    // 如果当前不够8个item就不让他滚动
    [self bottomHorizontalAnimation:cell forIndexPath:indexPath];
    // 发送通知改变侧滑菜单的颜色
    MSHomeDataModel *model = [self.viewModel.dataSource objectAtIndex:_index];
    NSNotification *noti = [NSNotification notificationWithName:NOTIFY_SETUPBG object:model.recommanded_background_color];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    self.lastIndex = indexPath;
}

#pragma mark - Event or Action
- (void) errorBtnDidClick {
    //self.centerCollectView.headerViewBeginRefreshing()
}

#pragma mark - Private Method
// 底部标签动画
- (void)bottomAnimation:(NSIndexPath *)indexpath {
    if (self.lastIndex.row == indexpath.row) {
        return;
    }
    UICollectionViewCell *cell = [self.bottomCollectView cellForItemAtIndexPath:indexpath];
    if (cell == nil) {
        [self.bottomCollectView layoutIfNeeded];
        cell = [self.bottomCollectView cellForItemAtIndexPath:indexpath];
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
    
    if ([self.viewModel.dataSource count] > 8) {
        
    } else {
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
    [UIView animateWithDuration:0.2 animations:^{
        cell.y = 10;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            cell.y = 15;
        }];
    }];
    if (self.lastIndex!= nil) {
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
}

- (void)setupLayout {
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@(SCREEN_HEIGHT*50/IPHONE5_HEIGHT));
        make.left.right.equalTo(self.view);
    }];
    
    [_bottomCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(SCREEN_HEIGHT*60/IPHONE5_HEIGHT));
    }];
    
    [_centerCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_headerView).offset(_headerView.height);
        make.height.equalTo(@(SCREEN_HEIGHT*420/IPHONE5_HEIGHT));
    }];
}
@end