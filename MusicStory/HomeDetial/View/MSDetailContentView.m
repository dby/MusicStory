//
//  MSDetailContentView.m
//  MusicStory
//
//  Created by sys on 16/4/23.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSDetailContentView.h"

#import "Masonry.h"
#import "GRMustache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "UIView+MS.h"
#import "MSPlayMusicView.h"

@interface MSDetailContentView() <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MSPlayMusicView *playMusicView;
@property (nonatomic, strong) UIImageView *backMusicImageView;

@end

@implementation MSDetailContentView

@synthesize model = _model;

#pragma mark - Setter Getter
-(MSMusicModel *)model {
    return _model;
}

-(void)setModel:(MSMusicModel *)model {
    
    _model = model;
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webView loadHTMLString:[self demoFormatWithName:_model.music_name
                                                        value:_model.music_story
                                                     musicImg:_model.music_imgs
                                      ] baseURL:baseURL];
    
    [self.backMusicImageView setImageWithURL:[NSURL URLWithString:_model.music_imgs]
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.playMusicView.model    = _model;
}

#pragma mark - Init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponent];
        [self setLayout];
        self.contentSize = CGSizeMake(SCREEN_WIDTH,
                                      _backMusicImageView.height + _playMusicView.height + _webView.height);
    }
    return self;
}

-(void)initComponent
{
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate           = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator    = true;
    self.webView.scrollView.showsHorizontalScrollIndicator  = false;
    [self addSubview:self.webView];
    
    self.backMusicImageView = [[UIImageView alloc] init];
    [self addSubview:_backMusicImageView];
    
    self.playMusicView          = [[MSPlayMusicView alloc] init];
    self.playMusicView.layer.borderWidth = 1;
    [self addSubview:_playMusicView];
}

#pragma mark - Custiom Function
- (NSString *)demoFormatWithName:(NSString *)name value:(NSString *)value musicImg:(NSString *)imgurl {
    
    NSString *filename  = @"template.html";
    NSString *path      = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
    NSString *template  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *renderObject  = @{ @"name": name, @"content":value, @"music_img":imgurl};
    NSString *content           = [GRMustacheTemplate renderObject:renderObject fromString:template error:nil];
    
    return content;
}

- (void)setLayout {
    [_backMusicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_WIDTH * 0.5));
    }];
    
    [_playMusicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(100));
        make.left.equalTo(@20);
        make.width.equalTo(@(SCREEN_WIDTH - 40));
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(_playMusicView.y + _backMusicImageView.height));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
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