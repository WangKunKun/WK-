//
//  WKNetWorkConnection.h
//  Example
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^requestCallback)(NSError *error, id result);


@interface WKNetWorkConnection : NSObject
- (BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback;

- (BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback hint:(NSString *)hint;


@end
