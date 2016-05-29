//
//  MSSearchHeaderView.h
//  MusicStory
//
//  Created by sys on 16/5/29.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancleBtnDidClickBlock)();
typedef void(^textFieldDidChangeBlock)(NSString *test);

@interface MSSearchHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, copy) cancleBtnDidClickBlock block;
@property (nonatomic, copy) textFieldDidChangeBlock textFieldBlock;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

- (void)textfieldDidChangeWithBlock:(textFieldDidChangeBlock) block ;
- (void)cancleBtnDidClickWithBlock:(cancleBtnDidClickBlock) block;

@end
