//
//  MSCommentView.m
//  MusicStory
//
//  Created by sys on 16/5/28.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSCommentView.h"

#import "AppConfig.h"
#import "MSMakeCommentsController.h"

@implementation MSCommentView

-(void)awakeFromNib {
    debugMethod();
    [super awakeFromNib];
}

- (instancetype)init
{
    debugMethod();
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSCommentView" owner:nil options:nil].firstObject;
        self.userInteractionEnabled = true;
        self.commentLabel.userInteractionEnabled = true;
        [self.commentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMakeCommentsController:)]];
    }
    return self;
}

#pragma mark - Comment Event
-(void) goToMakeCommentsController:(UITapGestureRecognizer *)recognizer{
    debugMethod();
    if (self.delegate) {
        [self.delegate commentLabelDidClick];
    }
}

@end
