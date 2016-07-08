//
//  WKFileManager.h
//  UICollectionView
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 王琨. All rights reserved.
//

//针对沙盒中Plist文件的增删改查
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WKIsDir) {
    NotExist,
    ExistAndFile,
    ExistAndDir
};



@interface WKFileManager : NSObject
@property (nonatomic, strong) NSString * myFileName;




+(WKFileManager *)sharedFMWithFileName:(NSString *)fileName;

//添加内容
- (BOOL) additionValue:(NSObject *)value Key:(NSString *)key;
//删除内容
- (BOOL) deleteKey:(NSString *)key;
//改内容
- (BOOL) changeValue:(NSObject *)value Key:(NSString *)key;
//查内容
- (NSObject *)valueForKey:(NSString *)key;

@end
