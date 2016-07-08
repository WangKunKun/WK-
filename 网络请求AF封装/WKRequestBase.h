//
//  WKRequestBase.h
//  Example
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKNetWorkConnection.h"

@interface WKRequestBase : NSObject
+(BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback;

+ (BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback hint:(NSString *)hint;
+ (BOOL)checkNetworkState;
@end
