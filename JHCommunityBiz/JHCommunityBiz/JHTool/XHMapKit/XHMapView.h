//  地图-根据配置自动添加
//  XHMapView.h
//  JHWaiMaiUpdate
//
//  Created by xixixi on 2017/6/6.
//  Copyright © 2017年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MAPointAnnotation(XHtool)
@property(nonatomic,strong)NSString *imgStr;
@end


@interface XHMapView : UIView<MAMapViewDelegate>

//初始化地图的中心点位置
@property (nonatomic,assign)CLLocationDegrees lat;
@property (nonatomic,assign)CLLocationDegrees lng;

///**
// 是否展示当前坐标,默认为NO
// */
//@property (nonatomic,assign)BOOL showUserLocation;

//地图移动后回调中心点位置和地址
@property (nonatomic,copy)void(^CenterPostion)(CLLocationCoordinate2D centerPoint, NSString *addr);

//添加一个大头针
- (void)addAnnotation:(CLLocationCoordinate2D)point
                title:(NSString *)title
               imgStr:(NSString *)imgStr
             selected:(BOOL)selected;

/**
 设置地图的中心位置为当前位置
 */
- (void)setCenterWithCurrentLocation;

/**
 设置地图的中心位置为指定的位置
 */
- (void)setCenterWithPoint:(CLLocationCoordinate2D)point;

#pragma mark - 改变配送员和商家之间的距离的
-(void)changeDistanceWithShopCoordinate:(CLLocationCoordinate2D)shopCoordinate
                          peiCoordinate:(CLLocationCoordinate2D)peiCoordinate;

#pragma mark - 改变配送员和客户之间的距离的
-(void)changeDistanceWithCustomCoordinate:(CLLocationCoordinate2D)customCoordinate
                            peiCoordinate:(CLLocationCoordinate2D)peiCoordinate;

/**
 两点路径规划,以当前位置为起点
 @param destination_lat  终点 lats
 @param destination_lng  终点 lng
 */
- (void)createRouteSearchWithDestination_lat:(double)destination_lat
                             destination_lng:(double)destination_lng;

/**
 两点路径规划,以特定位置为起点

 @param origin_lat 起点 lat
 @param origin_lng 起点 lng
 @param destination_lat 终点 lat
 @param destination_lng 终点 lng
 */
- (void)createRouteSearchWithOrigin_lat:(double)origin_lat
                             origin_lng:(double)origin_lng
                        destination_lat:(double)destination_lat
                        destination_lng:(double)destination_lng;

/**
 三点路径规划,以当前位置为起点
 @param passingPoint_lat 途经点 lat
 @param passingPoint_lng 途经点 lng
 @param destination_lat  终点 lat
 @param destination_lng  终点 lng
 */
- (void)createRouteSearchWithPassingPoint_lat:(double)passingPoint_lat
                             passingPoint_lng:(double)passingPoint_lng
                              destination_lat:(double)destination_lat
                              destination_lng:(double)destination_lng;


/**
 获取地图某个屏幕点的相对应坐标

 @param point 屏幕的点
 @return 相应的坐标
 */
- (CLLocationCoordinate2D)coordinateForPoint:(CGPoint)point;

/**
 移除所有的大头针
 */
- (void)removeAllAnnotations;
@end





