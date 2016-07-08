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

typedef enum : NSUInteger {
    SearchNearby = 0,
    SearchTips,
} SearchModle;

@protocol WKTipsSearchDelegate<NSObject>

- (void)getResultArray:(NSArray *)result;

@end

@protocol WKReGeocodeSearchDelegate <NSObject>

- (void)getResult:(AMapReGeocode *)result;

@end

@protocol WKPOISearchDelegate <NSObject>

- (void)getResultArray:(NSArray *)result;

@end

@protocol WKNearbySearchDelegate <NSObject>

- (void)getResultArray:(NSArray *)result;

@end

@interface GDMapManager : NSObject

+ (GDMapManager *)shardGDManager;

#pragma mark 逆向地址编码
@property (nonatomic, assign) id <WKReGeocodeSearchDelegate> ReGeocodeSearchDelegate;
- (void)startReGeocodeSearchWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude delegate:(id<WKReGeocodeSearchDelegate>)delegate;


#pragma mark 检索周边服务者
- (void)startSearchNearbyWithDelegate:(id<WKNearbySearchDelegate>)nearbySearchDelegate;
@property (nonatomic, assign) id <WKNearbySearchDelegate> NearbySearchDelegate;

#pragma mark tips检索
- (void)startSearchTipsWithCity:(NSString *)city keyWords:(NSString *)keyWords delegate:(id<WKTipsSearchDelegate>)delegate;
@property (nonatomic, assign) id <WKTipsSearchDelegate> TipsSearchDelegate;

#pragma mark POI检索

- (void)startPOISearchWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude delegate:(id<WKPOISearchDelegate>)delegate;
@property (nonatomic, assign) id<WKPOISearchDelegate> POISearchDelegate;

#pragma mark 计算两点之间的距离
- (CGFloat )calculateDistanceWithPoint:(CLLocationCoordinate2D)point1 point:(CLLocationCoordinate2D)point2;


- (CLLocationCoordinate2D)GaoDeToBaiDu:(CLLocationCoordinate2D)point;
- (CLLocationCoordinate2D)BaiDuToGaoDe:(CLLocationCoordinate2D)point;

@end
