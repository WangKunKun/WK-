//
//  WKPayView.m
//  Example
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKPayView.h"
#import "WKPaymentMethodBtn.h"
#define TAG 200

@interface WKPayView()<WKPaymentMethodBtnDelegate>

@property (nonatomic, strong) NSMutableArray * btnArray;

@end
@implementation WKPayView


+ (WKPayView *)payView
{
    WKPayView * payView = [[WKPayView alloc] init];
    payView.btnArray = [NSMutableArray array];
    [payView setInterFace];
    
    return payView;
}

- (void)setInterFace
{
    self.bounds = CGRectMake(0, 0, SCREEN_Width, 83);
    WKPaymentMethodBtn * aliPayBtn = [WKPaymentMethodBtn viewFromNIBWithStyle:PaymentMethodAliPay];
    aliPayBtn.originS = CGPointMake(0, 0);
    [self addSubview:aliPayBtn];
    aliPayBtn.tag = TAG + PaymentMethodAliPay;
    aliPayBtn.delegate = self;
    WKPaymentMethodBtn * wxPayBtn =  [WKPaymentMethodBtn viewFromNIBWithStyle:PaymentMethodWXPay];
    wxPayBtn.originS = CGPointMake(0, aliPayBtn.bottomS);
    wxPayBtn.tag = TAG + PaymentMethodWXPay;
    [self addSubview:wxPayBtn];
    wxPayBtn.delegate = self;

    [_btnArray addObject:aliPayBtn];
    [_btnArray addObject:wxPayBtn];
    
    self.method = PaymentMethodAliPay;
}

- (void)paymentMethodBtnClick:(WKPaymentMethodBtn *)btn
{
    self.method = btn.tag - TAG;
    
}

-(void)setMethod:(PaymentMethod)method
{
    _method = method;
    for (WKPaymentMethodBtn * temp in _btnArray) {
        temp.selected = temp.tag - TAG == method;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
