//
//  GDMapManager.h
//  Example
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


//这个枚举是用于 更改 poi检索的type
//它的实际模式 是根据key有无值来判断的
typedef enum : NSUInteger {
    WKPOISearchModel_Other = 0,
    WKPOISearchModel_GroupActivity,
} WKPOISearchModel;

@protocol WKTipsSearchDelegate<NSObject>

- (void)getResultArray_Tips:(NSArray *)result;

@end

@protocol WKReGeocodeSearchDelegate <NSObject>

- (void)getResult:(AMapReGeocode *)result;

@end

@protocol WKPOISearchDelegate <NSObject>
@required
- (void)getResultArray_POISearch:(NSArray *)result;

- (NSUInteger)POISearchPage;
- (NSUInteger)POISearchRow;

@end

@protocol WKNearbySearchDelegate <NSObject>

- (void)getResultArray:(NSArray *)result;

@end

@protocol WKLocationDelegate <NSObject>

- (void)getResult:(CLLocation *)location;

@end

@protocol WKOnceLocationDelegate <NSObject>

- (void)getOnceLocationResult:(CLLocation *)location;

@end


//为什么我没用Block呢?
@interface GDMapManager : NSObject

+ (GDMapManager *)shardGDManager;

@property (nonatomic, assign) id <WKOnceLocationDelegate> onceLocationDelegate;

+ (void)startLocationOnceWithDelegate:(id<WKOnceLocationDelegate>)locationDelegate;

- (void)startLocationOnce;

#pragma mark 开始持续定位
@property (nonatomic, assign) id <WKLocationDelegate> locationDelegate;

+ (void)startLocationWithDelegate:(id<WKLocationDelegate>)locationDelegate;
+ (void)stopLocation;



#pragma mark 逆向地址编码
@property (nonatomic, assign) id <WKReGeocodeSearchDelegate> ReGeocodeSearchDelegate;
- (void)startReGeocodeSearcLocationCoordinate:(CLLocationCoordinate2D)ll delegate:(id<WKReGeocodeSearchDelegate>)delegate;




#pragma mark 检索周边服务者
- (void)startSearchNearbyWithDelegate:(id<WKNearbySearchDelegate>)nearbySearchDelegate;
@property (nonatomic, assign) id <WKNearbySearchDelegate> NearbySearchDelegate;

#pragma mark tips检索
- (void)startSearchTipsWithCity:(NSString *)city keyWords:(NSString *)keyWords delegate:(id<WKTipsSearchDelegate>)delegate;
@property (nonatomic, assign) id <WKTipsSearchDelegate> TipsSearchDelegate;

#pragma mark POI检索 

- (void)startPOISearchWithKey:(NSString *)key searchModel:(WKPOISearchModel)model;

@property (nonatomic, assign) id<WKPOISearchDelegate> POISearchDelegate;

#pragma mark 计算两点之间的距离
- (CGFloat )calculateDistanceWithPoint:(CLLocationCoordinate2D)point1 point:(CLLocationCoordinate2D)point2;


- (CLLocationCoordinate2D)GaoDeToBaiDu:(CLLocationCoordinate2D)point;
- (CLLocationCoordinate2D)BaiDuToGaoDe:(CLLocationCoordinate2D)point;

@end
