//
//  FileManager.m
//  MusicStory
//
//  Created by sys on 16/8/28.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

/// 获取Documents路径
+ (NSString *)getDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (BOOL)createDirectory:(NSString *)dirName {
    NSString *documentsPath    = [self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSDirectory     = [documentsPath stringByAppendingPathComponent:dirName];
    
    return [fileManager createDirectoryAtPath:iOSDirectory withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)createFile:(NSString *)fileName {
    NSString *documentsPath    = [self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSPath          = [documentsPath stringByAppendingPathComponent:fileName];
    
    return [fileManager createFileAtPath:iOSPath contents:nil attributes:nil];
}

+ (BOOL)isExistAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
}

+ (BOOL)writeFile:(NSString *)filePath fileName:(NSString *)fileName fileData:(NSData *)fileData {
    filePath = [filePath stringByAppendingPathComponent:[fileName stringByReplacingOccurrencesOfString:@" "
                                                                                            withString:@""]];
    if (![self isExistAtPath:filePath]) {
        [self createFile:filePath];
    }
    
    NSLog(@"filePath: %@", filePath);
    NSError *error = nil;
    BOOL isSuccess = [fileData writeToFile:filePath options:NSDataWritingWithoutOverwriting error:&error];
    
    return isSuccess;
}

+ (NSData *)readFileContent: (NSString *)filePath{
    return [[NSFileManager defaultManager] contentsAtPath:filePath];
}

@end
