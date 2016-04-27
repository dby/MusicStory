//
//  MSDetialHeaderView.h
//  MusicStory
//
//  Created by sys on 16/4/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MSDetailHeaderViewDelegate

- (void)backButtonDidClick;
- (void)commentDidClick;

@end

@interface MSDetialHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (assign, nonatomic) id<MSDetailHeaderViewDelegate> delegate;

@end
