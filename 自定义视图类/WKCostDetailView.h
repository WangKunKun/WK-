//
//  WKCostDetailView.h
//  Example
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCostDetailView : UIView

+ (instancetype)viewFromNIB;
@property (nonatomic, strong) NSArray * datasource;
@property (nonatomic, assign) BOOL show;
@end
