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
#import "UIViewController+MS.h"


@interface MSHomeViewController () <MSHomeHeaderViewDelegate, MSHomeHeaderViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

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
@synthesize index = _index;
@synthesize headerView = _headerView;
@synthesize centerCollectView = _centerCollectView;

#pragma mark - Setter Getter
-(NSInteger)index {
    return _index;
}
-(void)setIndex:(NSInteger)index {
    self.index = index;
    if ([self.viewModel.dataSource count] == 0) {
        return;
    }
    // 获取模型
    MSHomeDataModel *model = self.viewModel.dataSource[index];
    // 设置header的模型
    // self.headerView.homeModel = model;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor colorWithHexString: model.recommanded_background_color];
    }];
}

-(MSHomeHeaderView *)headerView {
    _headerView = [[MSHomeHeaderView alloc] init];
    _headerView.delegate = self;
    
    return _headerView;
}

-(void)setHeaderView:(MSHomeHeaderView *)headerView {
    _headerView = headerView;
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

- (void)setCenterCollectView:(UICollectionView *)centerCollectView
{
    _centerCollectView = centerCollectView;
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
    //self.setupLayout()
    
}

#pragma mark Init

- (void)initComponents {
    //[self.view setBackgroundColor:[UIColor orangeColor]];
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
#warning 写到这里
    }
}

@end
