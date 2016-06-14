//
//  MSMakeCommentsController.m
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSMakeCommentsController.h"

#import <AVOSCloud/AVOSCloud.h>

#import "AppConfig.h"
#import "SVProgressHUD.h"

@interface MSMakeCommentsController ()

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@end

@implementation MSMakeCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_contentTextField becomeFirstResponder];
}

- (IBAction)completeCommentDidClick:(id)sender {
    debugMethod();
    AVUser *user = [AVUser currentUser];
    if (user && ![_contentTextField.text isEqualToString:@""] && _model) {
        AVObject *commentAvobject = [[AVObject alloc] initWithClassName:@"Comments"];
        [commentAvobject setObject:user.objectId forKey:@"author_id"];
        [commentAvobject setObject:[user objectForKey:@"username"] forKey:@"author_name"];
        [commentAvobject setObject:[user objectForKey:@"author_portrait"] forKey:@"author_portrait"];
        [commentAvobject setObject:_model.objectId forKey:@"music_id"];
        [commentAvobject setObject:_contentTextField.text forKey:@"content"];
        [commentAvobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [SVProgressHUD setMinimumDismissTimeInterval:0.2];
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                }];
            } else {
                [SVProgressHUD setMinimumDismissTimeInterval:0.2];
                [SVProgressHUD showSuccessWithStatus:[error description]];
            }
        }];
    }
    else {
        debugLog(@"error");
    }
}

- (IBAction)goBackDidClick:(id)sender {
    debugMethod();
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
