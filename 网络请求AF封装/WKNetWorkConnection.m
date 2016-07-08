//
//  WKNetWorkConnection.m
//  Example
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKNetWorkConnection.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "ReturnValueCode.h"

@implementation WKNetWorkConnection

#define DELAYTIME 1.5

- (BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback
{
    
    return [self sendPostWithUrl:url parameter:parameter requestCallback:callback hint:nil];
}


- (BOOL)sendPostWithUrl:(NSString *)url parameter:(NSMutableDictionary *)parameter requestCallback:(requestCallback)callback hint:(NSString *)hint
{
    MBProgressHUD * HUD;
    hint != nil ? ({
        //先隐藏所有的
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        HUD = [MBProgressHUD showMessag:hint toView:[UIApplication sharedApplication].keyWindow];
    }) : ({});
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接受类型不一致请替换一致text/html或别的

    
    
    AFHTTPRequestOperation * temp = [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        if(hint != nil)
        {
            //根据code获取提示信息
            
            NSString * msg = [ReturnValueCode hintStringForCode:[responseObject objectForKey:@"code"]];
            //提示信息末尾带！号表示成功
            //为了和加载网络数据时的提示信息对应，不使用服务器返回的提示信息，
            NSString * hintsuf = [hint substringFromIndex:2];
            if ([[msg substringFromIndex:[msg length] - 1] isEqualToString:@"!"]) {
                //成功不需要提示信息，只有订单需要
            }
            else
            {
//                hintsuf = [hintsuf stringByAppendingString:@"失败"];
                [MBProgressHUD showError:[responseObject objectForKey:@"msg"] delay:2.5];
            }
  
            
        }
        if(callback != nil) callback(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        hint != nil ? ({
            
//            NSString * hintsuf = [hint substringFromIndex:2];
//            hintsuf = [hintsuf stringByAppendingString:@"失败"];
            [MBProgressHUD showError:@"网络连接失败，请检查网络" delay:2.0];
            
        }) : ({});
        
        
        if(callback) callback(error,nil);
    }];
    
    return temp != nil;
}

@end
