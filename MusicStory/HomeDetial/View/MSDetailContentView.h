//
//  MSDetailContentView.h
//  MusicStory
//
//  Created by sys on 16/4/23.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMusicModel.h"
#import "MSDivisionView.h"

@interface MSDetailContentView : UIScrollView

@property (nonatomic, strong) MSMusicModel *model;
@property (nonatomic, strong) MSDivisionView *divisionView;

- (void)updateWebView :(NSString *)msg;

@end
