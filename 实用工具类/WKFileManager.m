//
//  WKFileManager.m
//  UICollectionView
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 王琨. All rights reserved.
//

#import "WKFileManager.h"

static WKFileManager * WKFM;
@interface WKFileManager()

@property (nonatomic, strong) NSFileManager * FM;
@property (nonatomic, strong) NSString * pathForFileName;

@end

@implementation WKFileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _FM = [NSFileManager defaultManager];
    }
    return self;
}

//得到文件路径
- (NSString *)getPathForFileName:(NSString *)fileName
{
    //得到沙盒的Documents目录
    NSArray  * paths      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * plistPath = [paths objectAtIndex:0];
    //拼接路径
    NSString * pathWithFileName = [plistPath stringByAppendingPathComponent:fileName];
    //返回路径
    return pathWithFileName;
}

//判断文件存在与否
- (BOOL)isExistWithFile:(NSString *)fileName
{
    return [_FM fileExistsAtPath:_pathForFileName];
}
//判断目录是否存在
- (WKIsDir)isExistWithDirectory:(NSString *)directory
{
    BOOL isDir ;
    BOOL isExist = [_FM fileExistsAtPath:_pathForFileName isDirectory:&isDir];
    return isExist == YES ? (isDir == YES ? ExistAndDir : ExistAndFile) : NotExist;
    
}

//创建文件
- (BOOL)creatFileWithFileName:(NSString *)fileName
{
    BOOL exist = [self isExistWithFile:fileName];
    if (exist == NO) {
       return [_FM createFileAtPath:_pathForFileName contents:nil attributes:nil];
    }
    //已存在也作为创建成功
    return YES;
}

- (void)setMyFileName:(NSString *)myFileName
{
    _myFileName = myFileName;
    _pathForFileName = [self getPathForFileName:myFileName];
}



+ (WKFileManager *)sharedFM
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WKFM = [WKFileManager new];
    });
    
    return WKFM;
}




+ (WKFileManager *)sharedFMWithFileName:(NSString *)fileName
{
    WKFM = [self sharedFM];
    WKFM.myFileName = fileName;
    //直接创建文件
    [WKFM creatFileWithFileName:fileName];
    return WKFM;
}

//打开沙盒中某文件
- (NSMutableDictionary *)openFile
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:_pathForFileName];
    NSAssert(nil != dict, @"%@ isn't exist",_pathForFileName);
    return dict;
}

//添加内容
- (BOOL) additionValue:(NSObject *)value Key:(NSString *)key
{
    NSMutableDictionary * dict = [self openFile];
    [dict setObject:value forKey:key];
    [dict writeToFile:_pathForFileName atomically:YES];
    return YES;
}
//删除内容
- (BOOL) deleteKey:(NSString *)key
{
    NSMutableDictionary * dict = [self openFile];
    [dict removeObjectForKey:key];
    [dict writeToFile:_pathForFileName atomically:YES];
    return YES;
}
//改内容
- (BOOL) changeValue:(NSObject *)value Key:(NSString *)key
{
    return [self additionValue:value Key:key];
}
//查内容
- (NSObject *)valueForKey:(NSString *)key
{
    NSMutableDictionary * dict = [self openFile];
    return dict[key];
}


@end
