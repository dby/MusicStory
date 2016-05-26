//
//  CommentsViewController.h
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCommentViewModel.h"


@interface CommentsViewController : UIViewController

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) MSCommentViewModel *commentViewModel;

@end
