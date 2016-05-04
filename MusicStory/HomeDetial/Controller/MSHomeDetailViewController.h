//
//  MSHomeDetailViewController.h
//  MusicStory
//
//  Created by sys on 16/4/23.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMusicModel.h"

@interface MSHomeDetailViewController : UIViewController

@property(nonatomic, strong) MSMusicModel *model;

-(instancetype)initWithModel:(MSMusicModel *)model;

@end
