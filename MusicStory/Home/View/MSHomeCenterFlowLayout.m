//
//  MSHomeCenterFlowLayout.m
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeCenterFlowLayout.h"
#import "AppConfig.h"

@implementation MSHomeCenterFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    debugMethod();
    self.itemSize = CGSizeMake(SCREEN_WIDTH-2*UI_MARGIN_5, SCREEN_HEIGHT*420/IPHONE5_HEIGHT);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, UI_MARGIN_5, 0, UI_MARGIN_5);
}

@end
