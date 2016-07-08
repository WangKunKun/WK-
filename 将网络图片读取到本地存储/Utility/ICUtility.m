//
//  Utility.m
//  icitynanchongiphone
//
//  Created by liuyang on 13-5-18.
//
//

#import "ICUtility.h"
#import "ICFileManager.h"
#import "UIDevice+IdentifierAddition.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"

@implementation ICUtility

+(void)imageAsynDownloadImageView:(UIImageView*)imageView
                        imagePath:(NSString*) imagePath
                         imageUrl:(NSString*) imageUrl
                     imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                    beginDownload:(void(^)()) beginDownload
                      endDownload:(void(^)(BOOL success)) endDownload
{
    if (imagePath && imageUrl && imageView) {
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
            imageView.image = [UIImage imageWithContentsOfFile:imagePath];
            imageSetDone(NO);
        }else {
            beginDownload();
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    NSData *imageData = [ICUtility dataSynFromUrl:imageUrl];
                    if (imageData) {
                        if (imagePath && [ICFileManager checkAndcreateFolderForFilePath:imagePath]) {
                            [imageData writeToFile:imagePath atomically:YES];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageView.image = [UIImage imageWithData:imageData];
                            imageSetDone(YES);
                        });
                        endDownload(YES);
                    }
                    endDownload(NO);
                }
            });
        }
    }

}

+(void)imageAsynDownloadImageView:(UIImageView*)imageView
                        imagePath:(NSString*) imagePath
                         imageUrl:(NSString*) imageUrl
                    imageCanbeSet:(BOOL(^)()) imageCanbeSet
                     imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                    beginDownload:(void(^)()) beginDownload
                      endDownload:(void(^)(BOOL success)) endDownload
{
    if (imagePath && imageUrl && imageView) {
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
            imageView.image = [UIImage imageWithContentsOfFile:imagePath];
            imageSetDone(NO);
        }else {
            beginDownload();
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    NSData *imageData = [ICUtility dataSynFromUrl:imageUrl];
                    if (imageData) {
                        if (imagePath && [ICFileManager checkAndcreateFolderForFilePath:imagePath]) {
                            [imageData writeToFile:imagePath atomically:YES];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (imageCanbeSet()) {
                                imageView.image = [UIImage imageWithData:imageData];
                                imageSetDone(YES);
                            }
                        });
                        endDownload(YES);
                    }
                    endDownload(NO);
                }
            });
        }
    }
    
}

+(void)imageAsynDownloadUIbutton:(UIButton*) button
                       imagePath:(NSString*) imagePath
                        imageUrl:(NSString*) imageUrl
                    imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                   beginDownload:(void(^)()) beginDownload
                     endDownload:(void(^)(BOOL success)) endDownload
{
    if (imagePath && imageUrl && button) {
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
            [button setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]]
                    forState:UIControlStateNormal];
            imageSetDone(NO);
        }else {
            beginDownload();
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    NSData *imageData = [ICUtility dataSynFromUrl:imageUrl];
                    if (imageData) {
                        if (imagePath && [ICFileManager checkAndcreateFolderForFilePath:imagePath]) {
                            [imageData writeToFile:imagePath atomically:YES];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [button setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                            imageSetDone(YES);
                        });
                        endDownload(YES);
                    }
                    endDownload(NO);
                }
            });
        }
    }
}

+(void)imageAsynDownloadUIbutton:(UIButton*) button
                       imagePath:(NSString*) imagePath
                        imageUrl:(NSString*) imageUrl
                   imageCanbeSet:(BOOL(^)()) imageCanbeSet
                    imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                   beginDownload:(void(^)()) beginDownload
                     endDownload:(void(^)(BOOL success)) endDownload
{
    if (imagePath && imageUrl && button) {
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
            [button setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]]
                    forState:UIControlStateNormal];
            imageSetDone(NO);
        }else {
            beginDownload();
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    NSData *imageData = [ICUtility dataSynFromUrl:imageUrl];
                    if (imageData) {
                        if (imagePath && [ICFileManager checkAndcreateFolderForFilePath:imagePath]) {
                            [imageData writeToFile:imagePath atomically:YES];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (imageCanbeSet()) {
                                [button setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                imageSetDone(YES);
                            }
                        });
                        endDownload(YES);
                    }
                    endDownload(NO);
                }
            });
        }
    }

}

+(NSData*) dataSynFromUrl:(NSString *)url
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return data;
}

+(void)networkIndicatorBlock:(void(^)())block
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    block();
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}


+ (NSString*)genUDID
{
    
    NSString * udidFromMacAdd = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    if (udidFromMacAdd) {
        return udidFromMacAdd;
    }
    
    CFUUIDRef deviceId = CFUUIDCreate (NULL);
    CFStringRef deviceIdStringRef = CFUUIDCreateString(NULL,deviceId);
    CFRelease(deviceId);
    NSString *deviceIdString = (__bridge NSString *)deviceIdStringRef;
    NSString *udid = [[NSString alloc] initWithString:deviceIdString];
    return udid;
}

+ (BOOL) isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"http://www.apple.com/" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags /*|| (flags == 0)*/ )
    {
        return FALSE;
    } else {
        return TRUE;
    }
}


//利用正则表达式验证

+ (BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidatePassword:(NSString *)password {
    
    NSString *regex = @"[\\da-zA-Z]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:password];
}

+ (NSString *)genNumDate:(NSString*)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *srcDate = [dateFormatter dateFromString:dateString];
    if (!srcDate) {
        return @"0";
    }else {
        dateFormatter.dateFormat = @"yyyyMMddHHmmss";
        return [dateFormatter stringFromDate:srcDate];
    }
}

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
