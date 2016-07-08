//
//  UITableViewCell+Model.m
//  Example
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKCategroy.h"

//NSNull异常处理使用
#import <objc/runtime.h>
//NSData使用
#include <CommonCrypto/CommonDigest.h>

#import "AppConfigManager.h"
#import "ICWaitingIndicator.h"
#import "ICFileManager.h"
#import "ICUtility.h"
@implementation UIImage (urlToImage)
+ (UIImage *)setNewsHeadImage:(NSString *)headImgUrl
{
    NSString * imageFilePath = [AppConfigManager filePathdocListImage:@"serverHead" imageName:[headImgUrl lastPathComponent]];
    NSData *imageData;
    NSString * fullImageUrl = headImgUrl;
    if([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath]){
        return  [UIImage imageWithContentsOfFile:imageFilePath];
    }
    else
    {
        imageData = [ICUtility dataSynFromUrl:fullImageUrl];
        if (imageData) {
            if ([ICFileManager checkAndcreateFolderForFilePath:imageFilePath]) {
                [imageData writeToFile:imageFilePath atomically:YES];
            }
        }
        
        
        
        return [UIImage imageWithData:imageData];
        
    }
    
    
}
@end

@implementation NSString (dateToString)
+ (NSString *)dateConvertToStringWithDate:(NSString *)date style:(NSString *)style
{
    if ([date isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:[date intValue]];
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:style];
    NSString *locationString=[formatter stringFromDate:time];
    return locationString;
}
@end

@implementation UITableViewCell (Model)

- (void)setValueWithModel:(WKBaseModel *)model
{
    
}
@end

@implementation UINavigationController (getVCWithClassName)

- (UIViewController *)getVCWithClassName:(NSString *)className
{
    Class c = NSClassFromString(className);
    return  [self getVCWithClass:c];
}

- (UIViewController *)getVCWithClass:(Class)c
{
    for (id temp in self.viewControllers) {
        if([temp isKindOfClass:c])
            return temp;
    }
    
    return nil;
}

@end


@implementation NSNull (InternalNullExtention)


+ (void)load
{
    @autoreleasepool {
        
        [self wt_swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(methodSignatureForSelector:) replacementSel:@selector(wt_methodSignatureForSelector:)];
        [self wt_swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(forwardInvocation:) replacementSel:@selector(wt_forwardInvocation:)];
    }
}

- (NSMethodSignature *)wt_methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:aSelector];
            if (!signature) {
                continue;
            }
            if (strcmp(signature.methodReturnType, "@") == 0) {
                signature = [[NSNull null] methodSignatureForSelector:@selector(wt_nil)];
            }
            return signature;
        }
        return [self wt_methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)wt_forwardInvocation:(NSInvocation *)anInvocation
{
    if (strcmp(anInvocation.methodSignature.methodReturnType, "@") == 0)
    {
        anInvocation.selector = @selector(wt_nil);
        [anInvocation invokeWithTarget:self];
        return;
    }
    
    for (NSObject *object in NSNullObjects)
    {
        if ([object respondsToSelector:anInvocation.selector])
        {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self wt_forwardInvocation:anInvocation];
}

- (id)wt_nil
{
    return nil;
}



+ (void)wt_swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
{
    Method originMethod = class_getInstanceMethod(clazz, original);
    Method replaceMethod = class_getInstanceMethod(clazz, replacement);
    if (class_addMethod(clazz, original, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod)))
    {
        class_replaceMethod(clazz, replacement, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else
    {
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}

@end

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@implementation NSData (SSToolkitAdditions)

- (NSString *)MD5Sum {
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5(self.bytes, self.length, digest);
    NSMutableString *ms = [NSMutableString string];
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

- (NSString *)SHA1Sum {
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, self.length, digest);
    for (NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}


// Adapted from http://www.cocoadev.com/index.pl?BaseSixtyFour
- (NSString *)base64EncodedString {
    const uint8_t *input = self.bytes;
    NSInteger length = self.length;
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] = _base64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = _base64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? _base64EncodingTable[(value >> 6) & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? _base64EncodingTable[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


// Adapted from http://www.cocoadev.com/index.pl?BaseSixtyFour
+ (NSData *)dataWithBase64String:(NSString *)base64String {
    const char *string = [base64String cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger inputLength = base64String.length;
    
    if (string == NULL/* || inputLength % 4 != 0*/) {
        return nil;
    }
    
    while (inputLength > 0 && string[inputLength - 1] == '=') {
        inputLength--;
    }
    
    NSInteger outputLength = inputLength * 3 / 4;
    NSMutableData* data = [NSMutableData dataWithLength:outputLength];
    uint8_t *output = data.mutableBytes;
    
    NSInteger inputPoint = 0;
    NSInteger outputPoint = 0;
    while (inputPoint < inputLength) {
        char i0 = string[inputPoint++];
        char i1 = string[inputPoint++];
        char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to \0 */
        char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
        
        output[outputPoint++] = (_base64DecodingTable[i0] << 2) | (_base64DecodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((_base64DecodingTable[i1] & 0xf) << 4) | (_base64DecodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((_base64DecodingTable[i2] & 0x3) << 6) | _base64DecodingTable[i3];
        }
    }
    
    return data;
}

@end

