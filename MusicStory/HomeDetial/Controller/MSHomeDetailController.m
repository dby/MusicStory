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

#import "ShareUtil.h"
#import "FileManager.h"
#import "MSPlayView.h"
#import "MSCommentView.h"
#import "MSHomeDetailToolView.h"
#import "MSHomeDetailAnimationUtil.h"

#import "MSMakeCommentsController.h"

#import "MusicStory-Common-Header.h"

@import GoogleMobileAds;

@interface MSHomeDetailController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, MSHomeDetailToolViewDelegate, UIWebViewDelegate, PlayViewDelegate, MSCommentViewDelegate, ShareViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) MSCommentViewModel *commentViewModel;

// 返回按钮
@property (nonatomic, strong) UIButton *returnBtn;
// 工具栏
@property (nonatomic, strong) MSHomeDetailToolView *toolBar;
// 播放音乐的按钮
@property (nonatomic, strong) MSPlayView *playMusicBtn;
@property (nonatomic, assign) NSInteger lastPosition;
// FooterView
@property (nonatomic, strong) MSCommentView *commentView;
@property (nonatomic, strong) NSMutableArray *commentSource;

// HeaderView
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIImageView *appIconView;
@property (nonatomic, strong) UILabel *appTitleLabel;
@property (nonatomic, strong) UILabel *appDetailLabel;
@property (nonatomic, strong) UIWebView *webview;

// MSDivisionView
@property (nonatomic, strong) UIButton *storyBtn;
@property (nonatomic, strong) UIButton *lyricsBtn;
@property (nonatomic, strong) UILabel *infoLabel;

// GoogleAds
@property (nonatomic, strong) GADInterstitial *interstitial;

@end

static NSString *homeDetailCellID = @"HomeDetailCell";
static NSString *commentIdentifier = @"commentIdentifier";

@implementation MSHomeDetailController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.lastPosition       = 0;
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.returnBtn];
    [self.view addSubview:self.playMusicBtn];
    
    [self loadGoogleAdsData];
    [self setHeaderData];
    [self setWebViewData:self.model.music_story];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusicPlaying) name:@"STOP_PLAY_MUSIC" object:nil];
    
    [self.tableview footerViewPullToRefresh:MSRefreshDirectionVertical callback: ^{
        [self loadData];
    }];
    
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    debugMethod();
    /*
    if (self.playMusicBtn) {
        [self.playMusicBtn stop];
    }
    
    if ([JDStatusBarNotification isVisible]) {
        [JDStatusBarNotification dismiss];
    }
    
    [self.playMusicBtn deallocTimer];
     */
}

-(void)dealloc {
    
}

- (instancetype)initWithModel :(MSMusicModel *)model {
    debugMethod();
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - 加载数据
- (void)loadGoogleAdsData {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on test devices.
    request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9b"];
    [self.interstitial loadRequest:request];
}

- (void)setHeaderData {
    debugMethod();
    [self.headerImgView setImageWithURL:[NSURL URLWithString:self.model.music_imgs]
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.appIconView setImageWithURL:[NSURL URLWithString:self.model.singer_portrait]
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.appTitleLabel.text     = self.model.singer_name;
    self.appDetailLabel.text    = self.model.singer_brief;
}

- (void)setWebViewData:(NSString *)content {
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webview loadHTMLString:[self demoFormatWithName:self.model.music_name
                                                    value:content
                                                 musicImg:self.model.music_imgs
                                  ] baseURL:baseURL];
    
}

#pragma mark - Event Response
- (void)showStory {
    if (!self.storyBtn.selected) {
        [self.storyBtn setSelected:true];
        [self.lyricsBtn setSelected:false];
        [self.infoLabel setText:@"音乐故事"];
        [self setWebViewData:self.model.music_story];
    }
}

- (void)showLyrics {
    if (!self.lyricsBtn.selected) {
        [self.storyBtn setSelected:false];
        [self.lyricsBtn setSelected:true];
        [self.infoLabel setText:@"音乐歌词"];
        
        NSArray *lyricsArr = [self.model.music_lyrics componentsSeparatedByString:@"\r"];
        NSString *lyrics = @"";
        
        for (NSString *item in lyricsArr) {
            lyrics = [lyrics stringByAppendingString:@"<p>"];
            lyrics = [lyrics stringByAppendingString:item];
            lyrics = [lyrics stringByAppendingString:@"</p>"];
        }
        
        [self setWebViewData:lyrics];
    }
}

- (void)returnBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Function
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
    CGFloat HeaderHeight = self.headerImgView.height;
    CGFloat HeaderCutAway = 270;
    
    CGRect headerRect = CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight);
    
    if (self.tableview.contentOffset.y < 0) {
        headerRect.origin.y     = self.tableview.contentOffset.y;
        headerRect.size.height  = -self.tableview.contentOffset.y + HeaderCutAway;
        self.headerImgView.frame = headerRect;
    }
}

- (void)setupLayout {
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_leftMargin).offset(10);
        make.topMargin.equalTo(self.view.mas_topMargin).offset(40);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.playMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(@(self.view.width / 2 - 30));
    }];
}

- (void)loadData {
    debugMethod();
    [self.commentViewModel getCommentData:self.commentSource.count withSuccessBack:^(NSArray *datasource) {
        if (datasource.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"已经没有评论了..."];
            [SVProgressHUD dismissWithDelay:0.5];
        } else {
            [self.commentSource addObjectsFromArray:datasource];
            [self.tableview reloadData];
        }
        
        [self.tableview footerViewStopPullToRefresh];
    } withErrorCallBack:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}

- (void)stopMusicPlaying {
    if (self.playMusicBtn) {
        [self.playMusicBtn stop];
    }
    
    if ([JDStatusBarNotification isVisible]) {
        [JDStatusBarNotification dismiss];
    }
    
    [self.playMusicBtn deallocTimer];
}

#pragma mark - commentView delegate
-(void)commentLabelDidClick {
    debugMethod();
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MSComment" bundle:[NSBundle mainBundle]];
    MSMakeCommentsController *vc = [story instantiateViewControllerWithIdentifier:@"msmakecommentscontroller"];
    vc.model = self.model;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - playview delegate
-(void)playButtonDidClick:(BOOL)selected {
    if (selected) {
        [self.playMusicBtn play];
    } else {
        [self.playMusicBtn pause];
    }
}

-(void)loadingGoogleAd {
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

#pragma mark - MSHomeDetailToolViewDelegate
-(void)homeDetailToolViewShareBtnClick {
    debugMethod();
    [[ShareUtil shareInstance] showShareView];
    [ShareUtil shareInstance].shareView.delegate = self;
}

-(void)homeDetailToolViewCollectBtnClick {
    debugMethod();
    AVUser *user    = [AVUser currentUser];
    AVObject *obj   = [MSMusicModel MusicModelToAVObject:self.model];
    
    if (!self.toolBar.collectButton.isSelected) {
        [AVObject saveAllInBackground:@[] block:^(BOOL succeeded, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.description];
            } else {
                AVRelation *relation = [user relationForKey:@"musics_collections"];
                [relation addObject:obj];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                        [SVProgressHUD dismissWithDelay:0.5];
                    } else {
                        [SVProgressHUD showSuccessWithStatus:error.debugDescription];
                        [SVProgressHUD dismissWithDelay:0.5];
                    }
                }];
                [self.toolBar.collectButton setSelected:YES];
                debugLog(@"add success...");
            }
        }];
    } else {
        [AVObject saveAllInBackground:@[] block:^(BOOL succeeded, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.description];
            } else {
                AVRelation *relation = [user relationForKey:@"musics_collections"];
                [relation removeObject:obj];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
                        [SVProgressHUD dismissWithDelay:0.5];
                    } else {
                        [SVProgressHUD showSuccessWithStatus:error.debugDescription];
                        [SVProgressHUD dismissWithDelay:0.5];
                    }
                }];
                [self.toolBar.collectButton setSelected:NO];
                debugLog(@"delete success...");
            }
        }];
    }
}

-(void)homeDetailToolViewDownloadBtnClick {
    debugMethod();
    
    NSString *path = [[FileManager getDocumentsPath] stringByAppendingString:@"/MusicStory"];
    NSString *fileName = [path stringByAppendingString: [NSString stringWithFormat:@"/%@.mp3", self.model.music_name]];
    
    if (![FileManager isExistAtPath:path]) {
        [FileManager createDirectory:@"MusicStory"];
    }
    
    if ([FileManager isExistAtPath:fileName]) {
        [SVProgressHUD showInfoWithStatus:@"该音乐已经下载过..."];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    
    AVFile *file = [AVFile fileWithURL:self.model.music_url];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // 下载成功
        [FileManager writeFile:path
                      fileName:[NSString stringWithFormat:@"%@.mp3", self.model.music_name]
                      fileData:data];
        
        [SVProgressHUD showInfoWithStatus:@"下载成功!!!"];
        [SVProgressHUD dismissWithDelay:0.5];
        
    } progressBlock:^(NSInteger percentDone) {
        [SVProgressHUD showProgress:percentDone/100.0 status:@"正在下载中..."];
    }];
}

#pragma mark - ShareViewDelegate
-(void)weixinShareButtonDidClick {
    [[ShareUtil shareInstance] shareToFriend:self.model.singer_name
                               shareImageUrl:self.model.music_imgs
                                    shareUrl:@"www.baidu.com"
                                  shareTitle:self.model.music_name
                                  shareMusic:self.model.music_url];
}

-(void)friendsCircleShareButtonDidClick {
    [[ShareUtil shareInstance] shareToFriendsCircle:self.model.singer_name
                                         shareTitle:self.model.music_name
                                           shareUrl:@"www.baidu.com"
                                      shareImageUrl:self.model.music_imgs
                                         shareMusic:self.model.music_url];
}

-(void)shareMoreButtonDidClick {
    [[ShareUtil shareInstance] shareToSinaWeibo:self.model.singer_name
                                     shareTitle:self.model.music_name
                                       shareUrl:@"www.baidu.com"
                                  shareImageUrl:self.model.music_imgs
                                     shareMusic:self.model.music_url];
}

#pragma mark - UIScrollviewDelegate
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
    
    // 下拉--playMusicBtn隐藏  上拉--playMusicBtn取消隐藏
    NSInteger currentPosition = self.tableview.contentOffset.y;
    if (currentPosition - self.lastPosition > 200) {
        self.lastPosition = currentPosition;
        [self.playMusicBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
            make.leading.equalTo(@(self.view.width / 2 - 30));
        }];
        [UIView animateWithDuration:0.35 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    else if (currentPosition - self.lastPosition < -50){
        self.lastPosition = currentPosition;
        [self.playMusicBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
            make.leading.equalTo(@(self.view.width / 2 - 30));
        }];
        [UIView animateWithDuration:0.35 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - UIWebviewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame        = webView.frame;
    frame.size.height   = 1;
    webView.frame       = frame;
    
    CGRect newFrame         = webView.frame;
    CGFloat webViewHeight   = [webView.scrollView contentSize].height;
    newFrame.size.height    = webViewHeight;
    webView.frame           = newFrame;
    
    [self hiddenProgress];
    [self.tableview reloadData];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self showProgress];
}

#pragma mark - UITableview Delegate and Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    debugMethod();
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    debugMethod();
    if (section == 0) {
        return 1;
    }
    else {
        return [self.commentSource count];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"评论";
    } else {
        return @"";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    if ([indexPath section] == 0) {
        UITableViewCell *cell           = [self.tableview dequeueReusableCellWithIdentifier:homeDetailCellID forIndexPath:indexPath];
        cell.selectionStyle             = UITableViewCellSeparatorStyleNone;
    
        self.webview.frame = CGRectMake(0, 0, cell.width, cell.height);
        [cell.contentView addSubview:self.webview];
        return cell;
    }
    else {
        MSCommentCell *cell = (MSCommentCell *)[tableView dequeueReusableCellWithIdentifier:commentIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellData:[self.commentSource objectAtIndex:indexPath.row]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
    if ([indexPath section] == 0) {
        return self.webview.height;
    } else {
        return 100;
    }
}

#pragma mark - Setter Getter
-(void)setModel:(MSMusicModel *)model {
    debugMethod();
    _model = model;
}

-(UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc] init];
        [_returnBtn addTarget:self action:@selector(returnBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
        [_returnBtn setImage:[UIImage imageNamed:@"detail_icon_back_pressed"] forState:UIControlStateHighlighted];
    }
    return _returnBtn;
}

-(MSPlayView *)playMusicBtn {
    if (!_playMusicBtn) {
        _playMusicBtn = [[MSPlayView alloc] init];
        _playMusicBtn.delegate  = self;
        _playMusicBtn.model     = self.model;
        [_playMusicBtn.contentIV sd_setImageWithURL:[NSURL URLWithString:self.model.music_imgs]];
    }
    return _playMusicBtn;
}

-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        // 顶部图片
        self.headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
        self.headerImgView.contentMode   = UIViewContentModeScaleAspectFill;
        self.headerImgView.clipsToBounds = true;
        
        [_headerView addSubview:self.headerImgView];
        // appIcon
        self.appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_MARGIN_20, CGRectGetMaxY(_headerImgView.frame) + UI_MARGIN_20, 50, 50)];
        self.appIconView.contentMode = UIViewContentModeScaleAspectFill;
        self.appIconView.layer.cornerRadius     = UI_MARGIN_10;
        self.appIconView.layer.masksToBounds    = YES;
        [_headerView addSubview:self.appIconView];
        // app大标题
        CGFloat appTitleLabelX  = CGRectGetMaxX(_appIconView.frame) + UI_MARGIN_20;
        CGFloat appTitleLabelW  = SCREEN_WIDTH - UI_MARGIN_20 - appTitleLabelX;
        self.appTitleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(appTitleLabelX, CGRectGetMaxY(_headerImgView.frame)+25, appTitleLabelW, 20)];
        self.appTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.appTitleLabel.textColor = MS_BLACK;
        [_headerView addSubview:self.appTitleLabel];
        // app详情
        self.appDetailLabel         = [[UILabel alloc] initWithFrame:CGRectMake(appTitleLabelX, CGRectGetMaxY(_appTitleLabel.frame), appTitleLabelW, 20)];
        self.appDetailLabel.font    = UI_FONT_14;
        self.appDetailLabel.textColor = MS_BLACK;
        [_headerView addSubview:self.appDetailLabel];
        
        
        // Division View
        self.storyBtn  = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 380, 50, 50)];
        self.lyricsBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 380, 50, 50)];
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 380, 100, 50)];
        UILabel *seperateLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, SCREEN_WIDTH, 1)];
        
        self.infoLabel.text = @"音乐故事";
        self.storyBtn.contentMode    = UIViewContentModeScaleAspectFill;
        self.lyricsBtn.contentMode   = UIViewContentModeScaleAspectFill;
        [seperateLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.storyBtn   setBackgroundImage:[UIImage imageNamed:@"music_story_default"] forState:UIControlStateNormal];
        [self.storyBtn   setBackgroundImage:[UIImage imageNamed:@"music_story_selected"] forState:UIControlStateSelected];
        [self.lyricsBtn  setBackgroundImage:[UIImage imageNamed:@"music_lyric_default"] forState:UIControlStateNormal];
        [self.lyricsBtn  setBackgroundImage:[UIImage imageNamed:@"music_lyric_selected"] forState:UIControlStateSelected];
        
        [self.storyBtn addTarget:self action:@selector(showStory) forControlEvents:UIControlEventTouchUpInside];
        [self.lyricsBtn addTarget:self action:@selector(showLyrics) forControlEvents:UIControlEventTouchUpInside];
        self.storyBtn.selected  = true;
        self.lyricsBtn.selected = false;
        
        [_headerView addSubview:self.storyBtn];
        [_headerView addSubview:self.lyricsBtn];
        [_headerView addSubview:self.infoLabel];
        [_headerView addSubview:seperateLine];
        
        // appicon + toolbar高度
        _headerView.height = self.headerImgView.height + UI_MARGIN_20 + 150;
    }
    return _headerView;
}

-(MSCommentView *)commentView {
    if (!_commentView) {
        _commentView        = [[MSCommentView alloc] init];
        _commentView.frame  = CGRectMake(0,
                                         0,
                                         SCREEN_WIDTH,
                                         CGRectGetHeight(_commentView.frame));
        _commentView.delegate = self;
    }
    return _commentView;
}

-(NSMutableArray *)commentSource {
    if (!_commentSource) {
        _commentSource = [NSMutableArray new];
    }
    return _commentSource;
}

-(MSCommentViewModel *)commentViewModel {
    if (!_commentViewModel) {
        _commentViewModel   = [[MSCommentViewModel alloc] initWithCommentTableView:self.tableview];
    }
    return _commentViewModel;
}

-(UITableView *)tableview {
    debugMethod();
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableview.delegate     = self;
        _tableview.dataSource   = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:homeDetailCellID];
        [_tableview registerClass:[MSCommentCell class] forCellReuseIdentifier:commentIdentifier];
        
        _tableview.tableHeaderView = self.headerView;
        _tableview.tableFooterView = self.commentView;
        
    }
    return _tableview;
}

-(MSHomeDetailToolView *)toolBar {
    if (!_toolBar) {
        _toolBar = [MSHomeDetailToolView toolView];
        _toolBar.frame      = CGRectMake(0, 345, SCREEN_WIDTH, 30);
        _toolBar.delegate   = self;
        _toolBar.model      = _model;
    }
    return _toolBar;
}

-(UIWebView *)webview {
    if (!_webview) {
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _webview.scrollView.showsVerticalScrollIndicator    = false;
        _webview.scrollView.showsHorizontalScrollIndicator  = false;
        _webview.scrollView.bounces     = false;
        _webview.userInteractionEnabled = false;
        _webview.delegate = self;
    }
    return _webview;
}
@end
