//
//  MSHomeDetailController.h
//  MusicStory
//
//  Created by sys on 16/6/12.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMusicModel.h"

@interface MSHomeDetailController : UIViewController

@property (nonatomic, strong) MSMusicModel *model;

-(instancetype)initWithModel :(MSMusicModel *)model;

@end
