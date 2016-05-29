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
            for (AVObject *obj in nearbyTodos) {
                MSMusicModel *model = [[MSMusicModel alloc] initWithAVO:obj];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
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