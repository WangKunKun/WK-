//
//  HttpHelper.h
//  icitynanchongiphone
//
//  Created by liuyang on 13-9-11.
//
//

#import <Foundation/Foundation.h>


typedef enum {
    CodeResponse_Successed = 0,
    CodeResponse_Failled = 1
}CodeResponse;

@interface HttpHelper : NSObject


+ (NSString *)httpPostUpload:(NSString*)url params:(NSDictionary*)params files:(NSDictionary *)files retCode:(uint16_t *)retCode;

+ (NSString *)getResponseData:(NSURLRequest *)request retCode:(uint16_t *)retCode;


@end
