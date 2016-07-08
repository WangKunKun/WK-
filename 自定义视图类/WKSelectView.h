//
//  WKSelectView.h
//  Example
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WKSelectViewClick)();

@interface WKSelectView : UIView
+ (instancetype)viewFromNIB;
@property (nonatomic, copy) WKSelectViewClick click;
@property (nonatomic, strong) NSString * title;
@end
