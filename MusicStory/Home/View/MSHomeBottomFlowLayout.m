//
//  MSHomeBottomFlowLayout.m
//  MusicStory
//
//  Created by sys on 16/3/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeBottomFlowLayout.h"
#import "AppConfig.h"

@implementation MSHomeBottomFlowLayout

-(void)prepareLayout {
    debugMethod();
    [super prepareLayout];
    self.itemSize           = CGSizeMake(SCREEN_WIDTH/7 - 2, bottomViewHeight);
    self.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset       = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumLineSpacing = 2;    //设置间距
}

@end
