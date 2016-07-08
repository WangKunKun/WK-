//
//  PaymentManager.m
//  Example
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "PaymentManager.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import "payRequsestHandler.h"
#import "Order.h"
#import "AFNetworking.h"

@interface PaymentManager ()

@property (nonatomic, assign) id<WKPaymentManagerDelegate> delegate;

@end

@implementation PaymentManager


+ (PaymentManager *)shardPaymentManager
{
    static PaymentManager * pm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pm = [[PaymentManager alloc] init];
    });
    return pm;
}

+ (void)startPayWithMehtod:(PaymentMethod)method orderID:(NSString *)orderID price:(NSString *)price delegate:(id<WKPaymentManagerDelegate>)delegate
{
    PaymentManager * pm = [PaymentManager shardPaymentManager];
    pm.delegate = delegate;
    if (method == PaymentMethodWXPay) {
        [pm wxPayWithorderID:orderID price:price];
    }
    else
    {
        [pm aliPayWithOrderID:orderID price:price];
    }
}

- (void)wxPayWithorderID:(NSString *)orderID price:(NSString *)price{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        //创建支付签名对象
        payRequsestHandler *req = [payRequsestHandler alloc];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];

        
        //获取到实际调起微信支付的参数后，在app端调起支付
        NSMutableDictionary *dict = [req sendPay_demo:orderID Price:price IfCharge:NO];
        
        if(dict == nil){
            //错误提示
            NSString *debug = [req getDebugifo];
            NSLog(@"%@\n\n",debug);
        }else{
            NSLog(@"%@\n\n",[req getDebugifo]);
            //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            
        }
    }
    else{
        [MBProgressHUD showError:@"微信支付必须安装微信" delay:2.0];
    }
}
//不能加提示信息的原因，在于还要去后台确认。
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if (_delegate && [_delegate respondsToSelector:@selector(WXPayFinished:)]) {
                    [_delegate WXPayFinished:WXPAYSuccess];
                }
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                if (_delegate && [_delegate respondsToSelector:@selector(WXPayFinished:)]) {
                    [_delegate WXPayFinished:WXPAYFail];
                }
                break;
        }
    }
}

-(void)aliPayWithOrderID:(NSString *)orderID price:(NSString *)price{
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
    NSString *privateKey = PartnerPrivKey;
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderID; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"及时帮订单%@",order.tradeNO]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"及时帮订单%@",order.tradeNO]; //商品描述
    order.amount = price; //商品价格
    //    order.amount = @"0.01";
    order.notifyURL =  ALIPAYCALLBACKURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"cc.jishibang.bang";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"]intValue] == 9000) {
                NSString *jsonString = resultDic[@"result"];
                NSArray *array = [jsonString componentsSeparatedByString:@"&"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                for (int i = 0; i<array.count; i++) {
                    NSArray *temp = [array[i] componentsSeparatedByString:@"="];
                    [dict setObject:temp[1] forKey:temp[0]];
                }
                if ([dict[@"success"] isEqualToString:@"\"true\""]&&[resultDic[@"resultStatus"]intValue] == 9000) {
                    [MBProgressHUD showError:@"支付成功" delay:2.0];
                    if (_delegate && [_delegate respondsToSelector:@selector(AliPayFinished:)]) {
                        [_delegate AliPayFinished:ALIPAYSuccess];
                    }
                    
                }
            }
            else{
                [MBProgressHUD showError:@"支付失败" delay:2.0];
                if (_delegate && [_delegate respondsToSelector:@selector(AliPayFinished:)]) {
                    [_delegate AliPayFinished:ALIPAYFail];
                }

            }
            
        }];
    }
}



@end
