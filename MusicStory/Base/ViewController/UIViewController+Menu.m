//
//  UIViewController+Menu.m
//  MusicStory
//
//  Created by sys on 16/6/15.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "UIViewController+Menu.h"

@implementation UIViewController (Menu)

- (MSMenuViewController *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[MSMenuViewController class]]) {
            return (MSMenuViewController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark IB Action Helper methods

/*
- (IBAction)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)presentRightMenuViewController:(id)sender
{
    [self.sideMenuViewController presentRightMenuViewController];
}
*/
 
@end
