//
//  Utility.h
//
//  Created by liuyang on 13-5-18.
//
//

#import <Foundation/Foundation.h>

@interface ICUtility : NSObject


+(void)imageAsynDownloadImageView:(UIImageView*)imageView
                        imagePath:(NSString*) imagePath
                         imageUrl:(NSString*) imageUrl
                     imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                    beginDownload:(void(^)()) beginDownload
                      endDownload:(void(^)(BOOL success)) endDownload;

+(void)imageAsynDownloadUIbutton:(UIButton*) button
                       imagePath:(NSString*) imagePath
                        imageUrl:(NSString*) imageUrl
                    imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                   beginDownload:(void(^)()) beginDownload
                     endDownload:(void(^)(BOOL success)) endDownload;

+(void)imageAsynDownloadImageView:(UIImageView*)imageView
                        imagePath:(NSString*) imagePath
                         imageUrl:(NSString*) imageUrl
                    imageCanbeSet:(BOOL(^)()) imageCanbeSet
                     imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                    beginDownload:(void(^)()) beginDownload
                      endDownload:(void(^)(BOOL success)) endDownload;

+(void)imageAsynDownloadUIbutton:(UIButton*) button
                       imagePath:(NSString*) imagePath
                        imageUrl:(NSString*) imageUrl
                   imageCanbeSet:(BOOL(^)()) imageCanbeSet
                    imageSetDone:(void(^)(BOOL isDownload)) imageSetDone
                   beginDownload:(void(^)()) beginDownload
                     endDownload:(void(^)(BOOL success)) endDownload;

+(NSData*) dataSynFromUrl:(NSString *)url;

+(void)networkIndicatorBlock:(void(^)())block;
+(NSString*)genUDID;

+ (BOOL) isConnectionAvailable;

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidatePassword:(NSString *)password;

+ (UIImage *) createImageWithColor: (UIColor *) color;


+ (NSString *)genNumDate:(NSString*)dateString;

@end
