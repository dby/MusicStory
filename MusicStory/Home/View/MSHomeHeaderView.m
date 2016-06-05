//
//  MSHomeHeaderView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeHeaderView.h"

#import "NSDate+MS.h"
#import "UiView+MS.h"

@interface MSHomeHeaderView()

@end

@implementation MSHomeHeaderView

@synthesize rightTitle  = _rightTitle;
@synthesize homeModel   = _homeModel;

#pragma mark - Setter Getter
-(void)setRightTitle:(NSString *)rightTitle {
    debugMethod();
    _rightTitle = rightTitle;
    self.rightTitleLabel.text = _rightTitle;
}

-(NSString *)rightTitle {
    debugMethod();
    return _rightTitle;
}

-(MSMusicModel *)homeModel {
    debugMethod();
    return _homeModel;
}

-(void)setHomeModel:(MSMusicModel *)homeModel
{
    debugMethod();
    
    _homeModel = homeModel;
    if ([NSDate isToDay:homeModel.publish_date]) {
        self.dateLabel.text = @"今天";
        [self hiddenMoveToFirstAnimation];
    } else if([NSDate isLastDay:homeModel.publish_date]) {
        self.dateLabel.text = @"昨天";
        [self hiddenMoveToFirstAnimation];
    } else {
        self.dateLabel.text = [NSDate formattDay: homeModel.publish_date];
        [self showMoveToFirstAnimation];
    }
    self.weakLabel.text = [NSDate weekWithDateString:homeModel.publish_date];
}

-(instancetype)init {
    debugMethod();
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSHomeHeaderView" owner:nil options:nil].firstObject;
    }
    return self;
}

//MARK: --- ACTION EVENT
- (IBAction)menuImgDidClick:(id)sender {
    debugMethod();
    [self.delegate homeHeaderViewMenuDidClick:self :sender];
}
- (IBAction)moveToFirstImgDidClick:(id)sender {
    debugMethod();
    [self.delegate homeHeaderViewMoveToFirstDidClick:self :sender];
    [self hiddenMoveToFirstAnimation];
}

//MARK: --- PRIVATE
- (void) hiddenMoveToFirstAnimation {
    debugMethod();
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.moveToFirstBtn.alpha = 0;
    } completion:nil];
}
- (void) showMoveToFirstAnimation {
    debugMethod();
    [UIView animateWithDuration:0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        self.moveToFirstBtn.alpha = 1;
    } completion: nil];
}

//MARK : -- Public
- (void) setRightTitleHidden:(BOOL)flag {
    debugMethod();
    self.rightTitleLabel.hidden = flag;
    self.dateLabel.hidden = !flag;
    self.weakLabel.hidden = !flag;
    self.moveToFirstBtn.hidden = !flag;
}
@end