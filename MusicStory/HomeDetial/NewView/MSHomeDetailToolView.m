//
//  MSHomeDetailToolView.m
//  MusicStory
//
//  Created by sys on 16/6/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDetailToolView.h"
#import "MusicStory-Common-Header.h"

@interface MSHomeDetailToolView()

@end

@implementation MSHomeDetailToolView

@synthesize model = _model;

-(MSMusicModel *)model {
    return _model;
}

-(void)setModel:(MSMusicModel *)model {
    _model = model;
    [self estimateIsCollection];
}

+(MSHomeDetailToolView *)toolView {
    return [[NSBundle mainBundle] loadNibNamed:@"MSHomeDetailToolView" owner:nil options:nil].firstObject;
}

- (IBAction)collectionDidClick:(id)sender {
    [self.delegate homeDetailToolViewCollectBtnClick];
}

- (IBAction)shareDidClick:(id)sender {
    [self.delegate homeDetailToolViewShareBtnClick];
}

- (IBAction)downloadDidClick:(id)sender {
    [self.delegate homeDetailToolViewDownloadBtnClick];
}

#pragma mark - Custom Function
/*
 * 设置 是否 收藏了
 */
-(void)estimateIsCollection {
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
@end
