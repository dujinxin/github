//
//  DJXLocationViewController.m
//  JXView
//
//  Created by dujinxin on 15-7-27.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXLocationViewController.h"
#import "SYAppStart.h"
#import <BaiduMapAPI/BMapKit.h>

static NSString *cellIdentifier  =  @"cellId";

@interface DJXLocationViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,CLLocationManagerDelegate>{
    NSMutableArray     * _dataArray;
    UITableView        * _tableView;
    BMKLocationService * _locService;
    BMKMapView         * _mapView;
    BMKGeoCodeSearch   *_geocodesearch;
    
    
    BOOL               isNearBySearch;
}

@end

@implementation DJXLocationViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        _mapView = [[BMKMapView alloc ]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
    self.navigationItem.title = @"定位";
    
    self.navigationItem.rightBarButtonItems =  [self getNavigationItems:self selector:@selector(count) title:@"继续" style:kDefault isLeft:NO];
    //    [self setTitleViewWithTitle:@"分类"];
    //[self setNavigationTitleView];
    CGFloat tabBarHeight = 0;
    if (_isFromMainViewController) {
        self.navigationItem.leftBarButtonItems = [self getNavigationItems:self selector:@selector(count) image:[UIImage imageNamed:@"btn_back"] style:kSingleImage isLeft:YES];
        tabBarHeight = 64.f;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -tabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    
    _locService = [[BMKLocationService alloc]init];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]==NO  || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启永辉微店)" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[DJXAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    [self startLocation:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
-(void)viewWillUnload{
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- buttonAction
- (void)count{
    if (_isFromMainViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SYAppStart hide:YES];
    }
}
////iOS8 新代理方法
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    switch (status)
//    {
//        case kCLAuthorizationStatusNotDetermined:{
//            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
//            {
//                [manager requestWhenInUseAuthorization];
//            }
//            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)])
//            {
//                [manager requestAlwaysAuthorization];
//            }
//        }
//            
//            break;
//        default:
//            break;
//    }
//}
#pragma mark -- BaiduLocation

//普通态
-(void)startLocation:(id)sender
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
//停止定位
-(void)stopLocation:(id)sender
{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}
/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    NSLog(@"stop locate");
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self stopLocation:nil];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"didFailToLocateUser:%@",error.localizedDescription);
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
#pragma mark -- BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        
        
        isNearBySearch = YES;
        BMKPoiSearch * poiSearch = [[BMKPoiSearch alloc] init ];
        poiSearch.delegate = self;
        
        //周边搜索
        BMKNearbySearchOption * searchOption = [[BMKNearbySearchOption alloc]init ];
        searchOption.location = result.location;
        searchOption.radius = 1000;
        searchOption.pageIndex = 0;
        searchOption.pageCapacity = 50;
        searchOption.keyword = @"永辉";
        BOOL flag = [poiSearch poiSearchNearBy:searchOption];
        if (flag) {
            NSLog(@"周边检索成功！");
        }else{
            NSLog(@"周边检索失败！");
        }
//        _dataArray = [NSMutableArray arrayWithArray:result.poiList];
//        [_tableView reloadData];
    }
}
#pragma mark -- BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        _dataArray = [NSMutableArray arrayWithArray:poiResult.poiInfoList];
        [_tableView reloadData];
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        if (isNearBySearch) {
            isNearBySearch = !isNearBySearch;
            BMKPoiSearch * poiSearch = [[BMKPoiSearch alloc] init ];
            poiSearch.delegate = self;
            
            //周边搜索
            BMKCitySearchOption * searchOption = [[BMKCitySearchOption alloc]init ];
            searchOption.pageIndex = 0;
            searchOption.pageCapacity = 10;
            searchOption.keyword = @"永辉";
            searchOption.city = @"福州市";
            BOOL flag = [poiSearch poiSearchInCity:searchOption];
            if (flag) {
                NSLog(@"周边检索成功！");
            }else{
                NSLog(@"周边检索失败！");
            }
        }else{
            NSLog(@"起始点有歧义");
        }
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        l.numberOfLines = 0;
        l.tag = indexPath.row + 10;
        [cell.contentView addSubview:l];
    }
    BMKPoiInfo * poiInfo = [_dataArray objectAtIndex:indexPath.row];
    UILabel * l = (UILabel *)[cell.contentView viewWithTag:indexPath.row + 10];
    l.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%d,%f,%f",poiInfo.name,poiInfo.uid,poiInfo.address,poiInfo.city,poiInfo.phone,poiInfo.postcode,poiInfo.epoitype,poiInfo.pt.latitude,poiInfo.pt.longitude];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
@end
