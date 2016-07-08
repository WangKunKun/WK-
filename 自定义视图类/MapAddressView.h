//
//  MapAddressView.h
//  Example
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

//typedef void(^navigationBtnClick)(void);

@interface MapAddressView : UIImageView


//坐标传值需要
@property (nonatomic, assign) CLLocationCoordinate2D  customerCoordinate;//客人的坐标
@property (nonatomic, assign) CLLocationCoordinate2D  storeCoordinate;//商家的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, strong) NSString * address;
//@property (nonatomic, copy) navigationBtnClick btnClick;

@property (nonatomic, assign) BOOL isClick;

//导航状态 0 表示 我到商家的导航，1表示商家到客户
@property (nonatomic, assign) NSUInteger navState;

+ (instancetype)viewFromNIB;
//- (void)changeHeight;

@end
