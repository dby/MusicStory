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
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)getCommentData:(NSInteger)page withSuccessBack:(MSHomeViewModelSuccessBack)successCallBack withErrorCallBack:(MSHomeViewModelErrorCallBack)errorCallBack
{
    self.successCallBack    = successCallBack;
    self.errorCallBack      = errorCallBack;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Comments"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            NSArray<AVObject *> *nearbyTodos = objects;
            for (AVObject *obj in nearbyTodos) {
                
                MSCommentModel *model = [[MSCommentModel alloc] initWithAVO:obj];
                [self.dataSource addObject:model];
            }
            
            if (successCallBack) {
                [self.commentTableView reloadData];
                self.successCallBack(self.dataSource);
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
