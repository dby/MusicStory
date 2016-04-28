//
//  MSHomeDetailViewController.m
//  MusicStory
//
//  Created by sys on 16/4/23.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDetailViewController.h"

#import "Masonry.h"
#import "GRMustache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "UIView+MS.h"

#import "AppConfig.h"
#import "MSPlayMusicView.h"
#import "MSDetailContentView.h"
#import "MSDetialHeaderView.h"

@interface MSHomeDetailViewController ()<UIWebViewDelegate, MSDetailHeaderViewDelegate>

@property (nonatomic, strong) MSDetialHeaderView    *headerView;
@property (nonatomic, strong) MSDetailContentView   *contentView;
@property (nonatomic, strong) MSPlayMusicView       *playMusicView;
@property (nonatomic, strong) UIImageView           *backMusicImageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MSHomeDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComponent];
    [self setupLayout];
}

#pragma mark - init

- (void)initComponent {
    
    self.headerView             = [[MSDetialHeaderView alloc] init];
    self.headerView.delegate    = self;
    [self.view addSubview:self.headerView];
    
    self.backMusicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height * 0.5)];
    [self.backMusicImageView setImageWithURL:[NSURL URLWithString:_model.music_imgs]
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.playMusicView          = [[MSPlayMusicView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 100)];
    self.playMusicView.model    = _model;
    self.playMusicView.layer.borderWidth = 1;
    
    self.contentView            = [[MSDetailContentView alloc] initWithFrame:CGRectMake(0,
                                                                                        _playMusicView.frame.size.height + _playMusicView.y,
                                                                                        SCREEN_WIDTH,
                                                                                        500)];
    self.contentView.delegate           = self;
    self.contentView.scrollView.bounces = NO;
    self.contentView.scrollView.userInteractionEnabled          = false;
    self.contentView.scrollView.showsVerticalScrollIndicator    = false;
    self.contentView.scrollView.showsHorizontalScrollIndicator  = false;
  
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    
    [self.scrollView addSubview:_backMusicImageView];
    [self.scrollView addSubview:_playMusicView];
    [self.scrollView addSubview:_contentView];
    [self.view addSubview:self.scrollView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.contentView loadHTMLString:[self demoFormatWithName:_model.music_name
                                                        value:_model.music_story
                                                     musicImg:_model.music_imgs
                                      ] baseURL:baseURL];
}

- (NSString *)demoFormatWithName:(NSString *)name value:(NSString *)value musicImg:(NSString *)imgurl {
    
    NSString *filename  = @"template.html";
    NSString *path      = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
    NSString *template  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *renderObject  = @{ @"name": name, @"content":value, @"music_img":imgurl};
    NSString *content           = [GRMustacheTemplate renderObject:renderObject fromString:template error:nil];
    
    return content;
}

#pragma mark - Custom Function

- (void)setupLayout {
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@(SCREEN_HEIGHT * 50 / IPHONE5_HEIGHT));
        make.left.right.equalTo(self.view);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    /*
    [_playMusicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.width.equalTo(@(self.view.frame.size.width - 40));
        make.left.offset(20);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playMusicView.mas_bottom).offset(-20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(self.view.frame.size.height - self.headerView.frame.size.height));
    }];
     */
}

#pragma mark - Custom Delegate

-(void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commentDidClick {
    debugMethod();
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = request.URL.absoluteString;
    
    if ([urlStr containsString:@"imgsrc"]) {
        NSRange range = [urlStr rangeOfString:@"imgsrc="];
        NSString *url = [urlStr substringWithRange:NSMakeRange(range.location + range.length, urlStr.length - range.location - range.length)];
        debugLog(@"URL: %@", url);
    }
    
    return YES;
}

@end