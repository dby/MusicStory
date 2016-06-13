//
//  MSHomeDetailToolView.m
//  MusicStory
//
//  Created by sys on 16/6/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSHomeDetailToolView.h"

@interface MSHomeDetailToolView()

@end

@implementation MSHomeDetailToolView

+(MSHomeDetailToolView *)toolView {
    return [[NSBundle mainBundle] loadNibNamed:@"MSHomeDetailToolView" owner:nil options:nil].firstObject;
}

- (IBAction)collectionDidClick:(id)sender {
    [self.delegate homeDetailToolViewCollectBtnClick];
}

- (IBAction)shareDidClick:(id)sender {
    [self.delegate homeDetailToolViewShareBtnClick];
}

- (IBAction)downloadDidClick:(id)sender {
    [self.delegate homeDetailToolViewDownloadBtnClick];
}
@end
