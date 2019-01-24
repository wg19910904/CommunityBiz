//
//  JHPaiotuiOtherMapVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/31.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHPathMapVC.h"
@interface JHPathMapVC ()
{
    XHMapView *_mapView;
}
@end

@implementation JHPathMapVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"查看路线", nil);
    [self initMap];
}
#pragma mark=====初始化地图======
- (void)initMap{
    _mapView = [[XHMapView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    
    [self.view addSubview:_mapView];
    [_mapView addAnnotation:CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue])
                      title:nil
                     imgStr:@"zuobiao"
                   selected:NO];
    [_mapView createRouteSearchWithDestination_lat:[self.lat floatValue] destination_lng:[self.lng floatValue]];
}

@end

