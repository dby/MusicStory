//
//  MSHomeHeaderView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeHeaderView.h"

#import "NSDate+MS.h"
#import "MSHomeDataModel.h"

@interface MSHomeHeaderView()

@property (nonatomic, strong) MSHomeDataModel *homeModel;

@end

@implementation MSHomeHeaderView

@synthesize rightTitle = _rightTitle;
@synthesize homeModel = _homeModel;

#pragma mark - Setter Getter
-(void)setRightTitle:(NSString *)rightTitle
{
    
    _rightTitle = rightTitle;
    self.rightTitleLabel.text = _rightTitle;
}

-(NSString *)rightTitle
{
    return _rightTitle;
}

- (MSHomeDataModel *)model
{
    return _homeModel;
}

-(void)setModel:(MSHomeDataModel *)homeModel
{
    _homeModel = homeModel;
    
    if ([NSDate isToDay:homeModel.publish_date]) {
        self.dateLabel.text = @"今天";
        [self hiddenMoveToFirstAnimation];
    } else if([NSDate isLastDay:homeModel.publish_date]) {
        self.dateLabel.text = @"昨天";
        [self hiddenMoveToFirstAnimation];
    } else {
        self.dateLabel.text = [NSDate formattDay: homeModel.publish_date];
        [self hiddenMoveToFirstAnimation];
    }
    self.weakLabel.text = [NSDate weekWithDateString:homeModel.publish_date];
}

- (MSHomeHeaderView *) headerView {
    return [[NSBundle mainBundle] loadNibNamed:@"MSHomeHeaderView" owner:self options:nil].firstObject;
}

//MARK: --- ACTION EVENT

- (IBAction)menuImgDidClick:(id)sender {
    [self.delegate homeHeaderViewMenuDidClick:self :sender];
}
- (IBAction)moveToFirstImgDidClick:(id)sender {
    [self.delegate homeHeaderViewMoveToFirstDidClick:self :sender];
    [self hiddenMoveToFirstAnimation];
}

//MARK: --- PRIVATE

- (void) hiddenMoveToFirstAnimation
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.moveToFirstBtn.alpha = 0;
    } completion:nil];
}

- (void) showMoveToFirstAnimation {
    [UIView animateWithDuration:0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        self.moveToFirstBtn.alpha = 1;
    } completion: nil];
}

//MARK : -- Public
- (void) setRightTitleHidden:(BOOL)flag {
    
    self.rightTitleLabel.hidden = flag;
    self.dateLabel.hidden = !flag;
    self.weakLabel.hidden = !flag;
    self.moveToFirstBtn.hidden = !flag;
}

@end
