//
//  MSHomeDetailController.m
//  MusicStory
//
//  Created by sys on 16/6/12.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDetailController.h"

#import "MSMusicModel.h"

#import "MSCommentCell.h"

#import "MSCommentViewModel.h"

#import "MSPlayView.h"
#import "MSHomeDetailToolView.h"
#import "MSHomeDetailAnimationUtil.h"

#import "MusicStory-Common-Header.h"

@interface MSHomeDetailController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, MSHomeDetailToolViewDelegate, UIWebViewDelegate, PlayViewDelegate>

@property (nonatomic, strong) UIButton *returnBtn;
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIImageView *appIconView;
@property (nonatomic, strong) UILabel *appTitleLabel;
@property (nonatomic, strong) UILabel *appDetailLabel;
@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) MSCommentViewModel *commentViewModel;

@property (nonatomic, strong) MSPlayView *playMusicBtn;
@property (nonatomic, strong) MSHomeDetailToolView *toolBar;

@end

static NSString *homeDetailCellID = @"HomeDetailCell";
static NSString *commentIdentifier = @"commentIdentifier";

@implementation MSHomeDetailController

@synthesize model = _model;

#pragma mark - life cycle

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // headerview
    [self buildHeaderView];
    // webview
    [self buildWebView];
    // tableview
    [self buildTableView];
    self.commentViewModel = [[MSCommentViewModel alloc] initWithCommentTableView:self.tableview];
    // toolview
    [self buildToolView];
    
    // return button
    [self buildReturnBtn];
    // play music btn
    [self buildPlayMusicBtn];
    
    // tableview的headerview加载数据
    [self setHeaderData];
    // tableviewcell中的webview加载数据
    [self setWebViewData];
    
    [self.tableview footerViewPullToRefresh:MSRefreshDirectionVertical callback: ^{
        [self loadData];
    }];
    
    // 屏幕适配
    [self setupLayout];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    debugMethod();
    if (_playMusicBtn) {
        [_playMusicBtn stop];
    }
}

-(instancetype)initWithModel :(MSMusicModel *)model {
    debugMethod();
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - setter or getter

-(void)setModel:(MSMusicModel *)model {
    debugMethod();
    _model = model;
}

#pragma mark - build View

-(void)buildReturnBtn {
    _returnBtn = [[UIButton alloc] init];
    [_returnBtn addTarget:self action:@selector(returnBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_pressed"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:_returnBtn];
}

-(void)buildPlayMusicBtn {
    _playMusicBtn = [[MSPlayView alloc] init];
    _playMusicBtn.delegate = self;
    _playMusicBtn.model = _model;
    [self.view addSubview:_playMusicBtn];
}

-(void)buildHeaderView {
    debugMethod();
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    // 顶部图片
    self.headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    self.headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImgView.clipsToBounds = YES;
    
    [self.headerView addSubview:_headerImgView];
    // appIcon
    self.appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_MARGIN_20, CGRectGetMaxY(_headerImgView.frame) + UI_MARGIN_20, 50, 50)];
    self.appIconView.contentMode = UIViewContentModeScaleAspectFill;
    self.appIconView.layer.cornerRadius     = UI_MARGIN_10;
    self.appIconView.layer.masksToBounds    = YES;
    [self.headerView addSubview:_appIconView];
    // app大标题
    CGFloat appTitleLabelX = CGRectGetMaxX(_appIconView.frame) + UI_MARGIN_20;
    CGFloat appTitleLabelW = SCREEN_WIDTH - UI_MARGIN_20 - appTitleLabelX;
    self.appTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(appTitleLabelX, CGRectGetMaxY(_headerImgView.frame)+25, appTitleLabelW, 20)];
    self.appTitleLabel.font = UI_FONT_18;
    [self.headerView addSubview:_appTitleLabel];
    // app详情
    self.appDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(appTitleLabelX, CGRectGetMaxY(_appTitleLabel.frame), appTitleLabelW, 20)];
    self.appDetailLabel.font = UI_FONT_14;
    [self.headerView addSubview:_appDetailLabel];
    // appicon + toolbar高度
    self.headerView.height = _headerImgView.height + UI_MARGIN_20 + 100;
    debugLog(@"headerview.height: %lf", self.headerView.height);
}

- (void)buildTableView {
    debugMethod();
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:homeDetailCellID];
    [self.tableview registerClass:[MSCommentCell class] forCellReuseIdentifier:commentIdentifier];

    [self.view addSubview:self.tableview];
    self.tableview.tableHeaderView = self.headerView;
    
    [self.tableview reloadData];
}

- (void)buildToolView {
    _toolBar = [MSHomeDetailToolView toolView];
    _toolBar.frame = CGRectMake(0, 345, SCREEN_WIDTH, 30);
    _toolBar.delegate = self;
    [self.view addSubview:_toolBar];
}

- (void)buildWebView {
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _webview.scrollView.showsVerticalScrollIndicator = false;
    _webview.scrollView.showsHorizontalScrollIndicator = false;
    _webview.scrollView.bounces = false;
    _webview.userInteractionEnabled = false;
    _webview.delegate = self;
}

#pragma mark - 加载数据

- (void)setHeaderData {
    debugMethod();
    [self.headerImgView setImageWithURL:[NSURL URLWithString:_model.music_imgs] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.appIconView setImageWithURL:[NSURL URLWithString:_model.singer_portrait] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.appTitleLabel.text = _model.singer_name;
    self.appDetailLabel.text = _model.singer_brief;
}

- (void)setWebViewData {
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webview loadHTMLString:[self demoFormatWithName:_model.music_name
                                                    value:_model.music_story
                                                 musicImg:_model.music_imgs
                                  ] baseURL:baseURL];
    
}

#pragma mark - private function

- (NSString *)demoFormatWithName:(NSString *)name value:(NSString *)value musicImg:(NSString *)imgurl {
    
    debugMethod();
    NSString *filename  = @"template.html";
    NSString *path      = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
    NSString *template  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *renderObject  = @{ @"name": name, @"content":value, @"music_img":imgurl};
    NSString *content           = [GRMustacheTemplate renderObject:renderObject fromString:template error:nil];
    
    return content;
}

- (void)updateHeaderView {
    debugMethod();
    CGFloat HeaderHeight = _headerImgView.height;
    CGFloat HeaderCutAway = 270;
    
    CGRect headerRect = CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight);
    
    if (self.tableview.contentOffset.y < 0) {
        headerRect.origin.y     = self.tableview.contentOffset.y;
        headerRect.size.height  = -self.tableview.contentOffset.y + HeaderCutAway;
        _headerImgView.frame    = headerRect;
    }
}

- (void)returnBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 适配屏幕
- (void)setupLayout {
    
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_leftMargin).offset(10);
        make.topMargin.equalTo(self.view.mas_topMargin).offset(40);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [_playMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(@(self.view.width / 2 - 30));
    }];
}

- (void)loadData {
    debugMethod();
    [self.commentViewModel getCommentData:0 withSuccessBack:^(NSArray *datasource) {
        debugLog(@"comment count: %lu", (unsigned long)[datasource count]);
        [self.tableview footerViewStopPullToRefresh];
    } withErrorCallBack:^(NSError *error) {
        
    }];
}

#pragma mark - playview delegate

-(void)playButtonDidClick:(BOOL)selected {
    if (selected) {
        [_playMusicBtn.contentIV sd_setImageWithURL:[NSURL URLWithString:_model.music_imgs]];
        [_playMusicBtn play];
    } else {
        [_playMusicBtn pause];
    }
}

#pragma mark - MSHomeDetailToolViewDelegate

-(void)homeDetailToolViewShareBtnClick {
    debugMethod();
    [SVProgressHUD showInfoWithStatus:@"正在加班加点的实现中...."];
}

-(void)homeDetailToolViewCollectBtnClick {
    debugMethod();
}

-(void)homeDetailToolViewDownloadBtnClick {
    debugMethod();
    [SVProgressHUD showInfoWithStatus:@"正在加班加点的实现中...."];
}

#pragma mark - uiscrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
    if (self.tableview.contentOffset.y >= 315){
        self.toolBar.y = self.returnBtn.y;
        // 显示在标题栏动画
        [MSHomeDetailAnimationUtil homeDetailToolBarToNavAnimation:self.toolBar];
        
    } else {
        self.toolBar.y = 345 - self.tableview.contentOffset.y;
        [MSHomeDetailAnimationUtil homeDetailToolBarToScrollAnimation:self.toolBar];
    }
}

#pragma mark - webview delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    debugMethod();
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight + 20;
    webView.frame = newFrame;
    
    [self.tableview reloadData];
}

#pragma mark - tableview delegate and datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    debugMethod();
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    debugMethod();
    return 1 + [self.commentViewModel.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    if (indexPath.row == 0) {
        
        UITableViewCell *cell           = [self.tableview dequeueReusableCellWithIdentifier:homeDetailCellID forIndexPath:indexPath];
        cell.selectionStyle             = UITableViewCellSeparatorStyleNone;
    
        _webview.frame = CGRectMake(0, 0, cell.width, cell.height);
        [cell.contentView addSubview:_webview];
        return cell;
        
    }
    else {
        MSCommentCell *cell = (MSCommentCell *)[tableView dequeueReusableCellWithIdentifier:commentIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellData:[self.commentViewModel.dataSource objectAtIndex:(indexPath.row - 1)]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    if (indexPath.row == 0) {
        return _webview.height;
    } else {
        return 100;
    }
}

@end