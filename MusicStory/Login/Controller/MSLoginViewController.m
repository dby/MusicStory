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

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@end

@implementation MSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildComponent];
}

- (void)buildComponent {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
}

#pragma mark - Custom Function
- (IBAction)login:(id)sender {
}

@end
