//
//  GDMapManager.m
//  Example
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "GDMapManager.h"
#include <math.h>

typedef enum : NSUInteger {
    GaoDeToBaidu = 0,
    BaiDuToGaoDe
} CoordsTransformType;
@interface GDMapManager ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI * search;

@end

@implementation GDMapManager


+ (GDMapManager *)shardGDManager
{
    static GDMapManager * GDmapmanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GDmapmanager = [[GDMapManager alloc] init];
//        CGFloat height = DeviceHeight == 480 ? 220 : 305;
//        GDmapmanager.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, 320, height)];
//        GDmapmanager.mapView.showsUserLocation = GDmapmanager;
        [GDmapmanager initGDMap];
//        GDmapmanager.nearbyManager = [AMapNearbySearchManager sharedInstance];
//        [GDmapmanager initTimer];
    });
    return GDmapmanager;
}
#pragma mark 初始化地图
- (void)initGDMap{
    //地图
    [MAMapServices sharedServices].apiKey = @"1df6a8835b5fa295f1534915f9d6739b";
    //搜索
    [AMapSearchServices sharedServices].apiKey = @"1df6a8835b5fa295f1534915f9d6739b";
    //定位
    [AMapLocationServices sharedServices].apiKey = @"1df6a8835b5fa295f1534915f9d6739b";
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}


#pragma mark 逆向地址编码
- (void)startReGeocodeSearchWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude delegate:(id<WKReGeocodeSearchDelegate>)delegate
{
    self.ReGeocodeSearchDelegate = delegate;
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude     longitude:longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        if ([_ReGeocodeSearchDelegate respondsToSelector:@selector(getResult:)]) {
            [_ReGeocodeSearchDelegate getResult:response.regeocode];
        }
    }
}

#pragma mark 开始检索Tips信息
- (void)startSearchTipsWithCity:(NSString *)city keyWords:(NSString *)keyWords delegate:(id<WKTipsSearchDelegate>)delegate
{
    self.TipsSearchDelegate = delegate;
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = keyWords;
    tipsRequest.city = city;
    //发起输入提示搜索
    [_search AMapInputTipsSearch: tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld", (long)response.count];
    NSString *strtips = @"";
    for (AMapTip *p in response.tips) {
        strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
    NSLog(@"InputTips: %@", result);
    //将结果传出
    if ([_TipsSearchDelegate respondsToSelector:@selector(getResultArray:)]) {
        [_TipsSearchDelegate getResultArray:response.tips];
    }
    
}
#pragma mark POI检索
- (void)startPOISearchWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude delegate:(id<WKPOISearchDelegate>)delegate
{
    self.POISearchDelegate = delegate;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
//    request.keywords = @"方恒";//关键字
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
//    request.types = @"餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch: request];

}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
    if (_POISearchDelegate && [_POISearchDelegate respondsToSelector:@selector(getResultArray:)]) {
        [_POISearchDelegate getResultArray:response.pois];
    }

}
#pragma mark 开始检索周边信息
- (void)startSearchNearbyWithDelegate:(id<WKNearbySearchDelegate>)nearbySearchDelegate
{
    
    //构造AMapNearbySearchRequest对象，配置周边搜索参数
    self.NearbySearchDelegate = nearbySearchDelegate;
    
    AMapNearbySearchRequest *request = [[AMapNearbySearchRequest alloc] init];
//    104.105072,30.673353
    request.center = [AMapGeoPoint locationWithLatitude:[USERINFOManager.gDLatitude doubleValue] longitude:[USERINFOManager.gDLongitude doubleValue]];//中心点
    request.radius = 10000;//搜索半径
    request.timeRange = 10000;//查询的时间
    request.searchType = AMapNearbySearchTypeLiner;//直线距离，AMapNearbySearchTypeLiner表示直线距离
    //发起附近周边搜索
    [_search AMapNearbySearch:request];
    
    

}


//附近周边搜索回调
- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response
{
    NSLog(@"onNearbySearchDone");
    if(response.infos.count == 0)
    {
        return;
    }
    
    
    
    for (AMapNearbyUserInfo *info in response.infos)
    {
//        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
//        anno.title = info.userID;
//        anno.subtitle = [[NSDate dateWithTimeIntervalSince1970:info.updatetime] descriptionWithLocale:[NSLocale currentLocale]];
//        
//        anno.coordinate = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
//        
//        [_mapView addAnnotation:anno];
        NSLog(@"%@",info);
        NSLog(@"%@",info.userID);

        
    }
    
    if (_NearbySearchDelegate && [_NearbySearchDelegate respondsToSelector:@selector(getResultArray:)]) {
        [_NearbySearchDelegate getResultArray:response.infos];
    }
}
#pragma mark 计算方法
- (CGFloat )calculateDistanceWithPoint:(CLLocationCoordinate2D)point1 point:(CLLocationCoordinate2D)point2
{
    //1.将两个经纬度点转成投影点
    MAMapPoint Mpoint1 = MAMapPointForCoordinate(point1);
    MAMapPoint Mpoint2 = MAMapPointForCoordinate(point2);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(Mpoint1,Mpoint2);
    return distance;
}

#pragma mark 高德转百度



- (CLLocationCoordinate2D)GaoDeToBaiDu:(CLLocationCoordinate2D)point
{

    double x_pi = M_PI * 3000.0 / 180.0;
    double x = point.longitude;
    double y = point.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    point.longitude = z * cos(theta) + 0.0065;
    point.latitude = z * sin(theta) + 0.006;
    
    return point;
    
}

- (CLLocationCoordinate2D)BaiDuToGaoDe:(CLLocationCoordinate2D)point
{
    
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = point.longitude - 0.0065;
    double y = point.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    point.longitude = z * cos(theta) ;
    point.latitude = z * sin(theta) ;
    return point;
    
}

- (CLLocationCoordinate2D)CoordsTransform:(CLLocationCoordinate2D)point type:(CoordsTransformType)type
{
    double x_offset = type == GaoDeToBaidu ? 0 : -0.0065;
    double y_offset = type == GaoDeToBaidu ? 0 : -0.006;
    
    double z_offset = type == GaoDeToBaidu ? 0.00002 : -0.00002;
    double theta_offset = type == GaoDeToBaidu ? 0.000003 : -0.000003;
    
    double lon_offset = type == GaoDeToBaidu ? 0.0065 : 0;
    double lat_offset = type == GaoDeToBaidu ? 0.006 : 0;
    
    double x_pi = M_PI * 3000.0 / 180.0;
    
    
    double x = point.longitude + x_offset;
    double y = point.latitude + y_offset;
    double z = sqrt(x * x + y * y) + z_offset * sin(y * x_pi);
    double theta = atan2(y, x) + theta_offset * cos(x * x_pi);
    point.longitude = z * cos(theta) + lon_offset;
    point.latitude = z * sin(theta) + lat_offset;
    
    return point;
}

@end
