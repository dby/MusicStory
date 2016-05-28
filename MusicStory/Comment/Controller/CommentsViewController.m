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

#import "MSCommentView.h"
#import "MSCommentCell.h"

#import "MSMakeCommentsController.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource, MSCommentViewDelegate>

@property (nonatomic, strong) MSCommentView *commentView;

@end

@implementation CommentsViewController

static NSString *CellIdentifier = @"commentIdentifier";

#pragma mark - life cycle

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self buildComponent];
    [self loadData];
    self.view.userInteractionEnabled = true;
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
    self.commentTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.commentTableView.delegate      = self;
    self.commentTableView.dataSource    = self;
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.commentTableView registerClass:[MSCommentCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:_commentTableView];
    
    self.commentView        = [[MSCommentView alloc] init];
    self.commentView.frame  = CGRectMake(0,
                                         SCREEN_HEIGHT - CGRectGetHeight(self.commentView.frame),
                                         SCREEN_WIDTH,
                                         CGRectGetHeight(self.commentView.frame));
    self.commentView.delegate = self;
    [self.view addSubview:_commentView];
    
    self.commentViewModel = [[MSCommentViewModel alloc] initWithCommentTableView:_commentTableView];
}

- (void)loadData {
    debugMethod();
    [self.commentViewModel getCommentData:0 withSuccessBack:^(NSArray *datasource) {
        debugLog(@"comment count: %lu", (unsigned long)[datasource count]);
    } withErrorCallBack:^(NSError *error) {
        
    }];
}

#pragma mark - uitableview delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    MSCommentCell *cell = (MSCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellData:[self.commentViewModel.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    debugMethod();
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    debugMethod();
    return [self.commentViewModel.dataSource count];
}

#pragma mark - MSCommentViewDelegate

-(void)commentLabelDidClick {
    
    debugMethod();
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MSComment" bundle:[NSBundle mainBundle]];
    MSMakeCommentsController *vc = [story instantiateViewControllerWithIdentifier:@"msmakecommentscontroller"];
    vc.model = _model;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

@end