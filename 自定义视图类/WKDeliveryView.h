//
//  WKDeliveryView.h
//  Example
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WKDeliveryViewClick)();

@interface WKDeliveryView : UIView
//默认明细不可点击
@property (assign, nonatomic) BOOL isClick;
@property (strong, nonatomic) NSString * distance;
@property (strong, nonatomic) NSString * money;


@property (copy  , nonatomic) WKDeliveryViewClick detailClick;

+ (instancetype)viewFromNIB;

@end
