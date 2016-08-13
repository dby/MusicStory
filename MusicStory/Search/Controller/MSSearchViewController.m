//
//  MSSearchViewController.m
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSearchViewController.h"

#import "MSSearchHeaderView.h"
#import "MSSearchViewCell.h"
#import "MSSearchViewModel.h"

#import "MSHomeDetailController.h"

#import "MusicStory-Common-Header.h"

@interface MSSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) MSSearchHeaderView *headerView;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) MSSearchViewModel *viewModel;

@end

@implementation MSSearchViewController

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self buildComponents];
    [self setLayout];
}

-(void)buildComponents {
    
    debugMethod();
    self.headerView = [[MSSearchHeaderView alloc] init];
    [self.headerView cancleBtnDidClickWithBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.headerView textfieldDidChangeWithBlock:^(NSString *test) {
        [self.viewModel getData:test withSuccessBack:^(NSArray *datasource) {
            
        } withErrorCallBack:^(NSError *error) {
            
        }];
    }];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(self.headerView.frame),
                                                                          SCREEN_WIDTH,
                                                                          SCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame))];
    self.contentTableView.delegate      = self;
    self.contentTableView.dataSource    = self;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewModel = [[MSSearchViewModel alloc] initWithTableView:self.contentTableView];
    
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.contentTableView];
}

-(void)setLayout {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@70);
    }];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSSearchViewCell *cell = [MSSearchViewCell cellWithTableView:tableView];
    [cell loadData:[self.viewModel.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MSHomeDetailController *mshdc = [[MSHomeDetailController alloc] initWithModel:[self.viewModel.dataSource objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:mshdc animated:YES];
}

@end