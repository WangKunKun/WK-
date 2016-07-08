//
//  WKRequestBase.m
//  Example
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKRequestBase.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "AppManager.h"

@implementation WKRequestBase

+ (BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback
{
    
    
    return [self sendPostWithUrl:url parameter:parameter requestCallback:callback hint:nil];
}

+ (BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback hint:(NSString *)hint
{
    

    if([self checkNetworkState]){
        WKNetWorkConnection * connection = [[WKNetWorkConnection alloc] init];
        return [connection sendPostWithUrl:url parameter:parameter requestCallback:callback hint:hint];
    }
    return NO;
}


//YES为有网，No为无网络
+ (BOOL)checkNetworkState
{
    Reachability * interManager = [Reachability reachabilityForInternetConnection];
    interManager.currentReachabilityStatus == NotReachable ? ({
//        [MBProgressHUD showError:@"请检测您的网络连接" toView:[UIApplication sharedApplication].keyWindow delay:1.5];
    }) : ({
       
    });
    
    
    return interManager.currentReachabilityStatus != NotReachable;
}

@end
