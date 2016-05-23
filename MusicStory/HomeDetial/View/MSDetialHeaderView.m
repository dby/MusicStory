//
//  MSDetialHeaderView.m
//  MusicStory
//
//  Created by sys on 16/4/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSDetialHeaderView.h"

@implementation MSDetialHeaderView


-(instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSDetialHeaderView" owner:nil options:nil].firstObject;
        
        [self.backButton    addTarget:self action:@selector(goToBack)     forControlEvents:UIControlEventTouchUpInside];
        [self.commentButton addTarget:self action:@selector(goToComment)  forControlEvents:UIControlEventTouchUpInside];
        [self.collectButton addTarget:self action:@selector(collectMusic) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)goToBack {
    if (_delegate) {
        [_delegate backButtonDidClick];
    }
}

-(void)goToComment {
    if (_delegate) {
        [_delegate commentDidClick];
    }
}

-(void)collectMusic {
    if (_delegate) {
        [_delegate collectDidClick];
    }
}

@end
