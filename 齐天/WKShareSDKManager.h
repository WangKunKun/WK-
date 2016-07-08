//
//  WKShareSDKManager.h
//  QTRunningBang
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WKThridLogin_QQ = 0,
    WKThridLogin_Wechat,
} WKThridLoginModel;

typedef enum : NSUInteger {
    WKShareModel_QQFriends = 2,//QQ好友
    WKShareModel_QQZone = 3,//QQ空间
    WKShareModel_WeChatFrieds = 0,//微信好友
    WKShareModel_WeChatQzone = 1,//微信朋友圈
    WKShareModel_WeChatCollect = 4,//微信收藏
} WKShareModel;

//图片数组类型_图片_Url地址
typedef enum : NSUInteger {
    WKImagesModel_Url = 1,//URL
    WKImagesModel_Source = 0//源图片 (需判断压缩)
} WKImagesModel;

typedef void(^Succeed)();

@interface WKShareSDKManager : NSObject

+ (WKShareSDKManager *)shardSDKManager;

- (void)loginWithPlatform:(WKThridLoginModel)type block:(Succeed)block;
- (void)shareWithPlatform:(WKShareModel)type;
//默认为源图片, images 只能是字符串 或者源图片
- (void)shareWithPlatform:(WKShareModel)type text:(NSString *)text images:(NSArray *)images urlStr:(NSString *)urlStr title:(NSString *)title block:(Succeed)block;

- (void)shareWithPlatform:(WKShareModel)type text:(NSString *)text images:(NSArray *)images urlStr:(NSString *)urlStr title:(NSString *)title block:(Succeed)block imagesModel:(WKImagesModel)im;



@end
