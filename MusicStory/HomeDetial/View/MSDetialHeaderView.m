//
//  MSDetialHeaderView.m
//  MusicStory
//
//  Created by sys on 16/4/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSDetialHeaderView.h"

#import <AVOSCloud/AVOSCloud.h>

@implementation MSDetialHeaderView

@synthesize model = _model;

-(MSMusicModel *)model {
    return _model;
}

-(void)setModel:(MSMusicModel *)model {
    _model = model;
    [self updateUI];
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSDetialHeaderView" owner:nil options:nil].firstObject;
        
        [self.backButton    addTarget:self action:@selector(goToBack)     forControlEvents:UIControlEventTouchUpInside];
        [self.commentButton addTarget:self action:@selector(goToComment)  forControlEvents:UIControlEventTouchUpInside];
        [self.collectButton addTarget:self action:@selector(collectMusic) forControlEvents:UIControlEventTouchUpInside];
        
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"collect_normal"] forState:UIControlStateNormal];
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"collect_pressed"] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark - Custom Function
/*
 * 设置 是否 收藏了
 */
-(void)updateUI {
    AVUser *user    = [AVUser currentUser];
    if (user) {
        AVRelation *relation = [user relationForKey:@"musics_collections"];
        AVQuery *query = [relation query];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (AVObject *obj in objects) {
                    if ([obj.objectId isEqualToString:_model.objectId]) {
                        self.collectButton.selected = YES;
                        break;
                    }
                }
            }
        }];
    }
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
