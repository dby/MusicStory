//
//  MSHomeDetailAnimationUtil.h
//  MusicStory
//
//  Created by sys on 16/6/6.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MSHomeDetailToolView.h"

@interface MSHomeDetailAnimationUtil : NSObject

+ (void)homeDetailToolBarToNavAnimation :(MSHomeDetailToolView *)toolView;
+ (void)homeDetailToolBarToScrollAnimation:(MSHomeDetailToolView *)toolView;

@end
