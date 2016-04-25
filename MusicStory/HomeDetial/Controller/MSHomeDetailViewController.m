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
    
    self.contentView = [[MSDetailContentView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.contentView];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    [self.contentView loadHTMLString:[self demoFormatWithName:@"dubinyuan" value:@"Objective-C语言调用JavaScript语言，是通过UIWebView实现额。起来，不愿做奴隶的人们，起来起来"] baseURL:baseURL];
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
    
    return YES;
}

@end
