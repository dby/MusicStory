//
//  SettingHeaderView.h
//  MusicStory
//
//  Created by sys on 16/6/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backBtnClickBlock)();

@interface SettingHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, copy) backBtnClickBlock block;

-(void) backBtnDidClickWithBlock:(backBtnClickBlock)block;
+(SettingHeaderView *) headerView ;

@end
