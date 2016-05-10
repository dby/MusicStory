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
    debugMethod();
    return _model;
}

-(void)setModel:(MSMusicModel *)model {
    debugMethod();
    
    _model = model;
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webView loadHTMLString:[self demoFormatWithName:_model.music_name
                                                    value:_model.music_story
                                                 musicImg:_model.music_imgs
                                  ] baseURL:baseURL];
    debugLog(@"self.webview height: %lf", self.webView.height);
    
    [self.backMusicImageView setImageWithURL:[NSURL URLWithString:_model.music_imgs]
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.playMusicView.model    = _model;
    
}

#pragma mark - Init

-(instancetype)initWithFrame:(CGRect)frame
{
    debugMethod();
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponent];
        [self setLayout:0];
    }
    return self;
}

-(void)initComponent
{
    debugMethod();
    debugLog(@"Width: %f, Height: %f", self.width, self.height);
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate               = self;
    self.webView.scrollView.bounces     = NO;
    self.webView.scrollView.delegate    = self;
    self.webView.scrollView.userInteractionEnabled = false;
    self.webView.scrollView.showsVerticalScrollIndicator    = false;
    self.webView.scrollView.showsHorizontalScrollIndicator  = false;
    [self.webView sizeToFit];
    [self addSubview:_webView];
    
    self.backMusicImageView = [[UIImageView alloc] init];
    self.backMusicImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_backMusicImageView];
    
    self.playMusicView          = [[MSPlayMusicView alloc] init];
    self.playMusicView.layer.borderWidth = 1;
    [self addSubview:_playMusicView];
    
    //[self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)dealloc {
    debugMethod();
    //[self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    debugMethod();
    if ([keyPath isEqualToString:@"contentSize"]) {
        debugMethod();
        debugLog(@"contentSize: %f", self.webView.height);
    }
}

#pragma mark - Custiom Function
- (NSString *)demoFormatWithName:(NSString *)name value:(NSString *)value musicImg:(NSString *)imgurl {
    
    debugMethod();
    NSString *filename  = @"template.html";
    NSString *path      = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
    NSString *template  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *renderObject  = @{ @"name": name, @"content":value, @"music_img":imgurl};
    NSString *content           = [GRMustacheTemplate renderObject:renderObject fromString:template error:nil];
    
    return content;
}

/*!
 *  @brief 布局
 */
- (void)setLayout:(CGFloat)height {
    
    debugMethod();
    [_backMusicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(-20);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_WIDTH * 0.5));
    }];
    
    [_playMusicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backMusicImageView.mas_bottom).offset(-1 * _playMusicView.height * 0.5);
        make.left.equalTo(@20);
        make.width.equalTo(@(SCREEN_WIDTH - 40));
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playMusicView.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    debugMethod();
    NSString *urlStr = request.URL.absoluteString;
    
    if ([urlStr containsString:@"imgsrc"]) {
        //NSRange range = [urlStr rangeOfString:@"imgsrc="];
        //NSString *url = [urlStr substringWithRange:NSMakeRange(range.location + range.length, urlStr.length - range.location - range.length)];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    debugMethod();
    
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    
    //获取WebView最佳尺寸（点）
    //CGSize frame = [webView sizeThatFits:CGSizeZero];
    
    //self.contentSize = CGSizeMake(SCREEN_WIDTH, clientheight);
    webView.height = clientheight;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
        debugLog(@"update height, %f", self.webView.height);
    }];
}

@end