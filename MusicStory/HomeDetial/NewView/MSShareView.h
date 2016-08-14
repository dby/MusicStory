//
//  MSShareView.h
//  MusicStory
//
//  Created by sys on 16/8/14.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate
- (void)weixinShareButtonDidClick;
- (void)friendsCircleShareButtonDidClick;
- (void)shareMoreButtonDidClick;
@end

@interface MSShareView : UIView

@property (nonatomic, strong) id<ShareViewDelegate> delegate;

@end
