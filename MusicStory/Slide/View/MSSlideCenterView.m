//
//  MSSlideCenterView.m
//  MusicStory
//
//  Created by sys on 16/3/20.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "AppConfig.h"
#import "MSSlideCenterView.h"

@implementation MSSlideCenterView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    _curView = self.recommandView;
    debugMethod();
    
}

+(MSSlideCenterView *)centerView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"MSSlideCenterView" owner:nil options:nil] firstObject];
}

#pragma mark -- Click Event

- (void)loginViewDidClick {
    debugMethod();
    if (_curView == self.loginview)
        return;
    [self.delegate slideCenterViewLoginViewDidClick:self loginView:self.loginview];
}

- (void)recommandDidClick {
    debugMethod();
    if (_curView == self.recommandView)
        return;
    [self.delegate slideCenterViewRecommendViewDidClick:self recommendView:self.recommandView];
}

- (void)collectViewDidClick {
    debugMethod();
    if (_curView == self.collectView)
        return;
    [self.delegate slideCenterViewCollectViewDidClick:self collectView:self.collectView];
}

@end
