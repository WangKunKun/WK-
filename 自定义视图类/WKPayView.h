//
//  WKPayView.h
//  Example
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WKPayView : UIView


+ (WKPayView *)payView;

@property (nonatomic,assign) PaymentMethod method;

@end
