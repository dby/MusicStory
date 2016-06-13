//
//  MSCommentView.h
//  MusicStory
//
//  Created by sys on 16/5/28.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSCommentViewDelegate

- (void)commentLabelDidClick;

@end

@interface MSCommentView : UIView

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) id<MSCommentViewDelegate> delegate;

@end
