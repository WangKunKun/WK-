//
//  FileManager.h
//  icitynanchongiphone
//
//  Created by  on 13-1-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICFileManager : NSObject

+ (void) writeFileByC:(NSString *) filepath streamFileData:(NSMutableData*) data isAppend:(BOOL)append;

+(BOOL) checkAndcreateFolderForFilePath:(NSString *)filePath;

//取上一级目录,使用于文件或者目录
+ (NSString *)getParentFolder:(NSString *)filePath;

#pragma mark - 文件时间
+(BOOL) isModificationToday:(NSString*)filepath;
+(BOOL) isModificationInTime:(int)inSeconds filePath:(NSString*)filepath;
+(NSDate *) fileModifyDate:(NSString*)filePath;

//删除文件或者目录
+(void)deleteFileOrDir:(NSString*)path;

@end
