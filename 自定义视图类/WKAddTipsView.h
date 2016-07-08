//
//  WKAddTipsView.h
//  Example
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WKAddTipsViewClick)(NSString * money);

typedef enum : NSUInteger {
    AddViewModelTips,
    AddViewModelHour,
} AddViewModel;

@interface WKAddTipsView : UIView

@property (nonatomic, assign) BOOL show;
@property (nonatomic, copy) WKAddTipsViewClick click;
+(instancetype)viewFromNIB;
+(instancetype)viewFromNIBWithStyle:(AddViewModel)model;

@end
