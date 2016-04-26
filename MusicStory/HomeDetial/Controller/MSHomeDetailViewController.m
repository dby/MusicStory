//
//  MSHomeDetailViewController.m
//  MusicStory
//
//  Created by sys on 16/4/23.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDetailViewController.h"

#import "AppConfig.h"
#import "GRMustache.h"
#import "MSDetailContentView.h"

@interface MSHomeDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) MSDetailContentView *contentView;

@end

@implementation MSHomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComponent];
}

#pragma mark - init

- (void)initComponent {
    
    self.contentView            = [[MSDetailContentView alloc] initWithFrame:self.view.frame];
    self.contentView.delegate   = self;
    [self.view addSubview:self.contentView];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    [self.contentView loadHTMLString:[self demoFormatWithName:@"dubinyuan" value:@"<p> Objective </p> -C语言调用J<p>avaScript语言，</p>是通过UIWebView实现额。起来，不愿做奴隶的人们，起来起来"] baseURL:baseURL];
}

- (NSString *)demoFormatWithName:(NSString *)name value:(NSString *)value {
    
    NSString *filename  = @"template.html";
    NSString *path      = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
    NSString *template  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *renderObject  = @{ @"name": name, @"content":value };
    NSString *content           = [GRMustacheTemplate renderObject:renderObject fromString:template error:nil];
    
    return content;
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