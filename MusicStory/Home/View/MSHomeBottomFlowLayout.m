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
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(SCREEN_WIDTH/8-2, 60);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2);
    self.minimumLineSpacing = 2;
}

@end
