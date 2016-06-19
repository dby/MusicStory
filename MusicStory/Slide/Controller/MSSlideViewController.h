//
//  MSSlideViewController.h
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMusicModel.h"
#import "MSSlideCenterView.h"

@interface MSSlideViewController : UIViewController

@property(nonatomic, strong) MSMusicModel *model;
@property (nonatomic, strong) MSSlideCenterView *centerView;

@end
