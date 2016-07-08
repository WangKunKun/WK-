//
//  WKUploadImageManager.h
//  QTRunningBang
//
//  Created by MacBook on 16/5/6.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    WKUploadImageResult_SuccessLittle = 2,//上传完成一张
    WKUploadImageResult_Success = 1,
    WKUploadImageResult_Fail = 0
} WKUploadImageResult;

@interface WKUploadImageManager : NSObject

+ (void)uploadImages:(NSArray <UIImage *>*)images handler:(void(^)(WKUploadImageResult,NSString*))handler;


@end
