//
//  AppConfigManager.h
//  xinhui_dongjiao
//
//  Created by liuyang on 14-2-25.
//  Copyright (c) 2014年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TIME_ROOTDATA_AUTOREFRESH                3600*12   //12小时
#define TIME_DOCLIST_AUTOREFRESH                 900   //15分钟


#define FILE_ROOT_DATA              @"root.file"
#define FILE_DOCLIST                @"doclist.file"
#define FILE_DOC                    @"doc.file"
#define FILE_DOC_COMMENT            @"doc.comment.file"


#define FOLDER_DOC                              @"doc"
#define FOLDER_TMP                              @"/tmp/"
#define FOLDER_FORUM_UPLOAD                     @"/forum_upload/"
#define FOLDER_FEEDBACK                         @"/feedback/"



#define APP_CONFIG_FILE                          @"pf_config.plist"



#define APP_CONFIG_KEY_UDID                          @"key_udid"

#define APP_CONFIG_KEY_YES                           @"key_yes"
#define APP_CONFIG_KEY_NO                            @"key_no"


void GetDiskFreeSpaceEx(long long *freespace);
void GetDiskTotalSpaceEx(long long *totalspace);

@interface AppConfigManager : NSObject

+ (NSString *) filePathForDocument:(NSString*) fileName;

+ (NSString *) filePathRootData;

+ (NSString *) filePathDocList:(NSString*)channelID parentID:(NSString*)parentID;

+ (NSString *) filePathDoc:(NSString*)docID;

+ (NSString *) filePathdocListImage:(NSString*)docID imageName:(NSString*)imageName;

+ (NSString *) filePathdocImage:(NSString*)docID imageName:(NSString*)imageName;

+ (NSString *) filePathDocComment:(NSString*)docID;

+ (NSString *) filePathFeedbackMessageByUrl:(NSString*)fileUrl;



#pragma mark -- 配置文件
+ (void)removePropertyFromConfigFile:(NSString*)key;
+ (void)setPropertyIntoConfigFile:(NSString*)key value:(NSString*)value;
+ (NSString *)getPropertyFromConfigFile:(NSString*)key;


#pragma mark -- time
+ (NSString*)formatTimeStringByString:(NSString*)string;
+ (NSString*)formatTimeStringByDate:(NSDate*)date;

#pragma mark - 获得目录字节数
+ (unsigned long long) countByteWithFilePath:(NSString*)filepath;

#pragma mark - 清理数据
+(void) clearLocalCache:(BOOL)isClearAll;

#pragma user 

+(void)saveUserID:(NSString*) name Password:(NSString*)password;
+(NSString *)getUserID;
+(NSString *)getPassword;
+(void)clearUserNameAndPassword;


@end
