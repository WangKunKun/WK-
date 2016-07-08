//
//  NavigationBar.h
//  Example
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^navItemClick)(void);


//typedef enum : NSUInteger {
//    NoData,
//    HasData
//} NavigationBarState;

@interface NavigationBar : UIView

@property (nonatomic, strong) NSString * wkTitle;
@property (nonatomic, strong) NSString * wkRightStr;
+ (instancetype)viewFromNIB;

@property (nonatomic, copy) navItemClick leftClick;
@property (nonatomic, copy) navItemClick rightClick;

@property (nonatomic, assign) BOOL isRightBtnHidde;
@end
