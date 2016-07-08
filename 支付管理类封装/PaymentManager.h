//
//  PaymentManager.h
//  Example
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#define WXPAYSuccess 10
#define WXPAYFail 11
#define ALIPAYSuccess 12
#define ALIPAYFail 13
@protocol WKPaymentManagerDelegate <NSObject>

- (void)WXPayFinished:(NSUInteger)state;
- (void)AliPayFinished:(NSUInteger)state;


@end

@interface PaymentManager : NSObject<WXApiDelegate>
+ (PaymentManager *)shardPaymentManager;
+ (void)startPayWithMehtod:(PaymentMethod)method orderID:(NSString *)orderID price:(NSString *)price delegate:(id<WKPaymentManagerDelegate>) delegate;
@end
