//
//  MSSearchViewModel.m
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSSearchViewModel.h"

#import "AppConfig.h"

@implementation MSSearchViewModel

-(instancetype)initWithTableView:(UITableView *)tableView {
    debugMethod();
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.dataSource = [[NSMutableArray alloc] init];
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

-(void)getData:(NSString *)condition withSuccessBack:(MSHomeViewModelSuccessBack)successCallBack withErrorCallBack:(MSHomeViewModelErrorCallBack)errorCallBack {
    debugMethod();
    self.successCallBack = successCallBack;
    self.errorCallBack = errorCallBack;
    
    AVQuery *musicNameQuery = [AVQuery queryWithClassName:@"Musics"];
    [musicNameQuery whereKey:@"music_name" equalTo:condition];
    [musicNameQuery orderByDescending:@"createdAt"];
    
    AVQuery *authorNameQuery = [AVQuery queryWithClassName:@"Musics"];
    [authorNameQuery whereKey:@"author_name" equalTo:condition];
    [authorNameQuery orderByDescending:@"createdAt"];
    
    AVQuery *singerNameQuery = [AVQuery queryWithClassName:@"Musics"];
    [singerNameQuery whereKey:@"singer_name" equalTo:condition];
    [singerNameQuery orderByDescending:@"createdAt"];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:[NSArray arrayWithObjects:musicNameQuery, authorNameQuery, singerNameQuery, nil]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSArray<AVObject *> *nearbyTodos = results;
            self.dataSource = [[NSMutableArray alloc] init];
            for (AVObject *obj in nearbyTodos) {
                MSMusicModel *model = [[MSMusicModel alloc] initWithAVO:obj];
                [self.dataSource addObject:model];
            }
            [self animationTable:self.tableView];
            if (successCallBack) {
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