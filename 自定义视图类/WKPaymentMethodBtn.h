//
//  WKPaymentMethodView.h
//  Example
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKPaymentMethodBtn;
//typedef void(^WKPaymentMethodBtnClick)(NSUInteger tag);
@protocol WKPaymentMethodBtnDelegate <NSObject>

- (void)paymentMethodBtnClick:(WKPaymentMethodBtn *)btn;

@end

@interface WKPaymentMethodBtn : UIView<UITableViewDelegate>
@property (nonatomic, assign) id <WKPaymentMethodBtnDelegate> delegate;
@property (nonatomic, assign) BOOL selected;

+ (instancetype)viewFromNIBWithStyle:(PaymentMethod)style;


@end
