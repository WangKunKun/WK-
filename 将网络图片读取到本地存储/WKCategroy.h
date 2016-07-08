//
//  UITableViewCell+Model.h
//  Example
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSNull+InternalNullExtention.h"
@class WKBaseModel;
//时间戳转字符串
@interface NSString (dateToString)
+ (NSString *)dateConvertToStringWithDate:(NSString *)date style:(NSString *)style;
@end

@interface UITableViewCell (Model)
- (void)setValueWithModel:(WKBaseModel *)model;

@end

@interface UIImage (urlToImage)
+ (UIImage *)setNewsHeadImage:(NSString *)headImgUrl;
@end

@interface UINavigationController (getVCWithClassName)

- (UIViewController *)getVCWithClassName:(NSString *)className;
- (UIViewController *)getVCWithClass:(Class)c;

@end

//异常处理 空元素
#define NSNullObjects @[@"",@0,@{},@[]]

@interface NSNull (InternalNullExtention)


@end

@interface NSData (SSToolkitAdditions)

///--------------
/// @name Hashing
///--------------

/**
 Returns a string of the MD5 sum of the receiver.
 
 @return The string of the MD5 sum of the receiver.
 */
- (NSString *)MD5Sum;

/**
 Returns a string of the SHA1 sum of the receiver.
 
 @return The string of the SHA1 sum of the receiver.
 */
- (NSString *)SHA1Sum;


///-----------------------------------
/// @name Base64 Encoding and Decoding
///-----------------------------------

/**
 Returns a string representation of the receiver Base64 encoded.
 
 @return A Base64 encoded string
 */
- (NSString *)base64EncodedString;

/**
 Returns a new data contained in the Base64 encoded string.
 
 @param base64String A Base64 encoded string
 
 @return Data contained in `base64String`
 */
+ (NSData *)dataWithBase64String:(NSString *)base64String;

@end