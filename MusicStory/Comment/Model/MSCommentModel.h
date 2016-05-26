//
//  MSCommentModel.h
//  MusicStory
//
//  Created by sys on 16/5/26.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MSCommentModel : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *author_id;
@property (nonatomic, strong) NSString *author_name;
@property (nonatomic, strong) NSString *author_portrait;
@property (nonatomic, strong) NSString *music_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate   *createdAt;

-(instancetype)initWithAVO :(AVObject *)avo;

@end
