//
//  WKMultiBtnView.h
//  Example
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#define STARTTAG  88

typedef void(^WKMultiBtnClick)(NSUInteger tag);

//模式，可以扩展为竖向的
typedef enum : NSUInteger {
    WKMultiBtnViewModelForStartVC = 0,//开始页面
    WKMultiBtnViewModelForMyOrderVC,//我的订单

} WKMultiBtnViewModel;


@interface WKMultiBtnView : UIView

//默认为WKMultiBtnViewModelForMyOrderVC模式
+ (WKMultiBtnView *)multiBtnViewWithTitleArray:(NSArray *)titleArray;

+ (WKMultiBtnView *)multiBtnViewWithTitleArray:(NSArray *)titleArray model:(WKMultiBtnViewModel)model;


@property (nonatomic, copy) WKMultiBtnClick btnClick;
@property (nonatomic, assign) NSUInteger selectedIndex;



@end
