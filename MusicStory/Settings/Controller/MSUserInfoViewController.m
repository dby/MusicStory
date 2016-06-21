//
//  MSUserInfoViewController.m
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSUserInfoViewController.h"

#import "MusicStory-Common-Header.h"

#import "SettingViewCell.h"
#import "MSUserModel.h"

@interface MSUserInfoViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIImageView *userImgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *returnBtn;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) MSUserModel *user;

@end

@implementation MSUserInfoViewController

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    [self buildComponents];
}

#pragma mark - build

- (void)buildComponents {
    
    debugMethod();
    [self initData];
    [self buildHeaderView];
    [self buildFootView];
    [self buildTableView];
    [self buildReturnBtn];
    
    [self setupLayout];
}

- (void)initData {
    self.user = [[MSUserModel alloc] initWithAVO:[AVUser currentUser]];
    self.data = [NSArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:@"icon_phone", @"icon", _user.mobilePhoneNumber, @"text", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"unReadMessageRed", @"icon", _user.email, @"text", nil],
                 nil];
}

- (void)buildReturnBtn {
    debugMethod();
    _returnBtn = [[UIButton alloc] init];
    [_returnBtn addTarget:self action:@selector(returnBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_pressed"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:_returnBtn];
}

- (void)buildTableView {
    debugMethod();
    self.tableView = [[UITableView alloc] init];
    self.tableView.tableHeaderView = _headerView;
    self.tableView.tableFooterView = _footerView;
    
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    
    [self.view addSubview:self.tableView];
}

- (void)buildHeaderView {
    debugMethod();
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    // top picture
    self.headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    self.headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImgView.clipsToBounds = YES;
    [self.headerImgView setImage:[UIImage imageNamed:@"setting_bg"]];
    [self.headerView addSubview:_headerImgView];
    
    // author portrait
    self.userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerView.frame)/2 - 30, 60, 70, 70)];
    self.userImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImgView.layer.cornerRadius     = 35;
    self.userImgView.layer.masksToBounds    = YES;
    NSLog(@"portrait: %@", _user.portrait);
    if (![_user.portrait isEqualToString:@""]) {
        [self.userImgView setImageWithURL:[NSURL URLWithString:_user.portrait] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    } else {
        [self.userImgView setImage:[UIImage imageNamed:@"encourage_image"]];
    }
    [self.headerView addSubview:_userImgView];
    
    // user name
    CGSize size = [self sizeWithString:_user.username font:[UIFont systemFontOfSize:15]];
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, _userImgView.y + 70, 10, 20)];
    label.width     = size.width + 5;
    label.centerX   = self.userImgView.centerX;
    label.text      = _user.username;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    
    [self.headerView addSubview:label];
    self.headerView.height = _headerImgView.height + UI_MARGIN_20;
    debugLog(@"headerview.height: %lf", self.headerView.height);
}

- (void)buildFootView {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(logoutBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    [_footerView addSubview:btn];
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, 300) //限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin //采用换行模式
                                    attributes:@{NSFontAttributeName:font} //传入字体
                                       context:nil];
    
    return rect.size;
}

#pragma mark - custom function

- (void)returnBtnDidClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logoutBtnDidClick {
    [AVUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateHeaderView {
    debugMethod();
    CGFloat HeaderHeight = _headerImgView.height;
    CGFloat HeaderCutAway = 270;
    
    CGRect headerRect = CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight);
    
    if (self.tableView.contentOffset.y < 0) {
        headerRect.origin.y     = self.tableView.contentOffset.y;
        headerRect.size.height  = -self.tableView.contentOffset.y + HeaderCutAway;
        _headerImgView.frame    = headerRect;
    }
}

#pragma mark - setup layout

- (void)setupLayout {
    debugMethod();
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_leftMargin).offset(10);
        make.topMargin.equalTo(self.view.mas_topMargin).offset(40);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
}

#pragma mark - scrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}

#pragma mark - tableview delegate / datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    debugMethod();
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    debugMethod();
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    SettingViewCell *cell = [SettingViewCell cellWithTableView:self.tableView];
    [cell setData:[self.data objectAtIndex:indexPath.row]];
    return cell;
}

@end
