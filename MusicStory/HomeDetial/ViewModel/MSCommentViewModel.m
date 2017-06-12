//
//  MSCommentViewModel.m
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSCommentViewModel.h"

#import "MSCommentModel.h"

@implementation MSCommentViewModel

-(instancetype)initWithCommentTableView : (UITableView *)tableView {
    self = [super init];
    if (self) {
        self.commentTableView = tableView;
    }
    return self;
}

- (void)animationTable: (UITableView *)tableView {
    
    [tableView reloadData];
    
    NSArray *cells = tableView.visibleCells;
    CGFloat tableHeight = tableView.bounds.size.height;
    
    for (UITableViewCell *cell in cells) {
        cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
    }
    
    double index = 0;
    
    for (UITableViewCell *cell in cells) {
        [UIView animateWithDuration:1.0
                              delay:0.05 * index
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             cell.transform = CGAffineTransformMakeTranslation(0, 0);
                         } completion:nil];
        index += 1;
    }
}

-(void)getCommentData:(NSInteger)num music_id:(NSString *)music_id withSuccessBack:(MSHomeViewModelSuccessBack)successCallBack withErrorCallBack:(MSHomeViewModelErrorCallBack)errorCallBack
{
    self.successCallBack    = successCallBack;
    self.errorCallBack      = errorCallBack;
    
    NSMutableArray *dataSource = [NSMutableArray new];
    AVQuery *query = [AVQuery queryWithClassName:@"Comments"];
    [query whereKey:@"music_id" equalTo:music_id];
    [query orderByDescending:@"createdAt"];
    query.skip  = num;
    query.limit = EVERY_DATA_NUM;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSArray<AVObject *> *nearbyTodos = objects;
            for (AVObject *obj in nearbyTodos) {
                
                MSCommentModel *model = [[MSCommentModel alloc] initWithAVO:obj];
                [dataSource addObject:model];
            }
            
            if (successCallBack) {
                self.successCallBack(dataSource);
            }
        }
        else {
            if (errorCallBack) {
                self.errorCallBack(nil);
            }
        }
    }];
}

@end
