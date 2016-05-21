//
//  MSUserModel.h
//  MusicStory
//
//  Created by sys on 16/5/21.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVOSCloud/AVOSCloud.h>

@interface MSUserModel : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) AVRelation *music_collections;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *mobilePhoneNumber;
@property (nonatomic, strong) NSArray *hasLikedMusic;

-(instancetype)initWithAVO :(AVObject *)avo;

@end