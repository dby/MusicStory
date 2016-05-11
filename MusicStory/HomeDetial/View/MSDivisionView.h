//
//  MSDivisionView.h
//  MusicStory
//
//  Created by sys on 16/5/11.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DivisionDelegate <NSObject>

-(void)lyricsBtnDidClick;
-(void)storyBtnDidClick;

@end

@interface MSDivisionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *storyBtn;
@property (weak, nonatomic) IBOutlet UIButton *lyricsBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seperateLine;

@property (nonatomic,weak) id<DivisionDelegate> delegate;

@end
