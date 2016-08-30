//
//  FileManager.h --- 主要涉及沙盒的操作
//  MusicStory
//
//  Created by sys on 16/8/28.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface FileManager : NSObject

+ (NSString *)getDocumentsPath;
+ (BOOL)createDirectory: (NSString *)dirName;
+ (BOOL)createFile: (NSString *)fileName;
+ (BOOL)isExistAtPath:(NSString *)filePath;
+ (BOOL)writeFile:(NSString *)filePath fileName:(NSString *)fileName fileData:(NSData *)fileData;
+ (NSData *)readFileContent: (NSString *)filePath;

+ (AVURLAsset *)getSpecialLocalMusic: (NSString *)name;

@end
