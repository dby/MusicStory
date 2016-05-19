//
//  MSLoginViewController.m
//  MusicStory
//
//  Created by sys on 16/5/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSLoginViewController.h"

#import "AppConfig.h"

#import <RESideMenu/RESideMenu.h>

@interface MSLoginViewController ()

@end

@implementation MSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor brownColor]];
    
    [self buildComponent];
}

- (void)buildComponent {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
}

#pragma mark - Custom Function

@end
