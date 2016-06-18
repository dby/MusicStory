//
//  SettingViewController.m
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSettingViewController.h"

#import "MusicStory-Common-Header.h"

#import "AboutCenterView.h"
#import "SettingViewCell.h"
#import "SettingHeaderView.h"

#import "MSAboutViewController.h"

@interface MSSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SettingHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MSSettingViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self buildComponent];
    [self setLayout];
    
}

-(void)viewWillAppear:(BOOL)animated {
    debugMethod();
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - build

- (void)buildComponent {
    
    debugMethod();
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settingDataSource" ofType:@"plist"]];
    
    [self buildTableView];
    [self setupNavView];
    
}

- (void)buildTableView {
    debugMethod();
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.rowHeight = 60;
    
    [self.view addSubview:_tableView];
}

// MARK: - private
- (void)setupNavView {
    debugMethod();
    _headerView = [SettingHeaderView headerView];
    [self.view addSubview:_headerView];
    [_headerView backBtnDidClickWithBlock:^{
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

#pragma mark - custom function

- (void)setLayout {
    debugMethod();
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(_headerView.height));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

#pragma mark - uitableview delegate datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    SettingViewCell *cell = [SettingViewCell cellWithTableView:self.tableView];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    debugMethod();
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    debugMethod();
    return [_dataSource count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 关于我们
        MSAboutViewController *aboutController = [[MSAboutViewController alloc] init];
        [self.navigationController pushViewController:aboutController animated:YES];
    } else if (indexPath.row == 1) {
        // 推荐给朋友
        [SVProgressHUD showInfoWithStatus:@"正在加班加点的研发中..."];
    } else if (indexPath.row == 2) {
        // 意见反馈
        [SVProgressHUD showInfoWithStatus:@"正在加班加点的研发中..."];
    } else if (indexPath.row == 3) {
        // 清空缓存
        [SVProgressHUD showInfoWithStatus:@"正在加班加点的研发中..."];
    }
}

@end
