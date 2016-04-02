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

@synthesize rightTitle = _rightTitle;
@synthesize homeModel = _homeModel;

#pragma mark - Setter Getter
-(void)setRightTitle:(NSString *)rightTitle
{
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    _rightTitle = rightTitle;
    self.rightTitleLabel.text = _rightTitle;
}

-(NSString *)rightTitle
{
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    return _rightTitle;
}

-(MSHomeDataModel *)homeModel {
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    return _homeModel;
}

-(void)setHomeModel:(MSHomeDataModel *)homeModel
{
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
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
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MSHomeHeaderView" owner:nil options:nil].firstObject;
    }
    return self;
}

//MARK: --- ACTION EVENT
- (IBAction)menuImgDidClick:(id)sender {
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    [self.delegate homeHeaderViewMenuDidClick:self :sender];
}
- (IBAction)moveToFirstImgDidClick:(id)sender {
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    [self.delegate homeHeaderViewMoveToFirstDidClick:self :sender];
    [self hiddenMoveToFirstAnimation];
}

//MARK: --- PRIVATE
- (void) hiddenMoveToFirstAnimation
{
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.moveToFirstBtn.alpha = 0;
    } completion:nil];
}
- (void) showMoveToFirstAnimation {
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    [UIView animateWithDuration:0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        self.moveToFirstBtn.alpha = 1;
    } completion: nil];
}

//MARK : -- Public
- (void) setRightTitleHidden:(BOOL)flag {
    
    NSLog(@"%@%s", @"MSHomeHeaderView", __func__);
    self.rightTitleLabel.hidden = flag;
    self.dateLabel.hidden = !flag;
    self.weakLabel.hidden = !flag;
    self.moveToFirstBtn.hidden = !flag;
}
@end