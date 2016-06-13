//
//  MSHomeDetailAnimationUtil.m
//  MusicStory
//
//  Created by sys on 16/6/6.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDetailAnimationUtil.h"

@implementation MSHomeDetailAnimationUtil

+(void)homeDetailToolBarToNavAnimation:(MSHomeDetailToolView *)toolView {
    [UIView animateWithDuration:0.5 animations:^{
        
        toolView.collectLabel.alpha     = 0;
        toolView.downloadLabel.alpha    = 0;
        toolView.shareLabel.alpha       = 0;
        
        toolView.collectButton.transform    = CGAffineTransformMakeTranslation(13, 0);
        toolView.shareButton.transform      = CGAffineTransformMakeTranslation(-12, 0);
        toolView.downloadButton.transform   = CGAffineTransformMakeTranslation(-37, 0);
        
    }];
}

+(void)homeDetailToolBarToScrollAnimation:(MSHomeDetailToolView *)toolView {
    [UIView animateWithDuration:0.5 animations:^{
        
        toolView.collectLabel.alpha     = 1;
        toolView.downloadLabel.alpha    = 1;
        toolView.shareLabel.alpha       = 1;
        
        toolView.collectButton.transform    = CGAffineTransformIdentity;
        toolView.shareLabel.transform       = CGAffineTransformIdentity;
        toolView.downloadButton.transform   = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
