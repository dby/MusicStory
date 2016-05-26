//
//  CommentsViewController.m
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "CommentsViewController.h"

#import "UIView+MS.h"
#import "AppConfig.h"
#import "APIConfig.h"
#import "MSCommentCell.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CommentsViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self buildComponent];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    debugMethod();
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

-(void)viewWillDisappear:(BOOL)animated {
    debugMethod();
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = true;
}

#pragma mark - cumstom function

- (void)buildComponent {
    debugMethod();
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.commentTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.commentTableView.delegate      = self;
    self.commentTableView.dataSource    = self;
    
    self.commentViewModel = [[MSCommentViewModel alloc] initWithCommentTableView:self.commentTableView];
    [self.view addSubview:_commentTableView];
}

- (void)loadData {
    debugMethod();
    [self.commentViewModel getCommentData:0 withSuccessBack:^(NSArray *datasource) {
        
    } withErrorCallBack:^(NSError *error) {
        
    }];
}

#pragma mark - uitableview delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    static NSString *CellIdentifier = @"commentIdentifier";
    MSCommentCell *cell = (MSCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MSCommentCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    }
    [cell setCellData:[self.commentViewModel.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    debugMethod();
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    debugMethod();
    return [self.commentViewModel.dataSource count];
}

@end