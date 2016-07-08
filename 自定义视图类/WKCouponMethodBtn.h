//
//  WKCouponMethodBtn.h
//  Example
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCouponMethodBtn : UIView
+ (instancetype)viewFromNIB;
@property (nonatomic,strong) NSString * couponMoeny;
@property (nonatomic,strong) NSString * baseMoeny;

@end
