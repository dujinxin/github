//
//  NetManager.m
//  JXView
//
//  Created by dujinxin on 14-10-28.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

static NetManager * manager = nil;
+ (NetManager *)shareNetManager{
    if (manager == nil) {
        manager = [[NetManager alloc]init ];
    }
    return manager;
}

+ (BOOL)networkConnection{
    __block BOOL isConnection;
    //网络判断
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
        NSString * connectionState = [response.allHeaderFields objectForKey:@"Connection"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //连着WiFi但是网络不通 / 没有连接任何网络
            if ([connectionState isEqualToString:@"close"] || response == nil) {
                NSLog(@"没有网络");
                isConnection = NO;

            }
            else{
                NSLog(@"网络是通的");
                isConnection = YES;
            }
        });
        
    });
    return isConnection;
}
//通过状态栏来获取，但是《《连着WiFi却没有网络》》这种情况比较特殊
- (kNetworkType)getNetworkStateType{
    //获取状态栏上的东西
    UIApplication  * app = [UIApplication sharedApplication];
    //获取状态栏->状态栏前端显示的视图->所有子视图
    NSArray * children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSLog(@"children:%@",children);
    
    kNetworkType netType = kNetworkStateNone;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //dataNetworkType 为NSNumber类型
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            //netType打印出来的网络状态对应1-2G,2-3G,3-4G, 5-WIFI
            //没有网路时UIStatusBarDataNetworkItemView隐藏，无法获取dataNetworkType，所以设置0-无网络
            NSLog(@"netType:%d",netType);
        }
    }
    switch (netType) {
        case 0:
            return kNetworkStateNone;
            break;
        case 1:
            return kNetworkState2G;
            break;
        case 2:
            return kNetworkState3G;
            break;
        case 3:
            return kNetworkState4G;
            break;
        case 5:
            return kNetworkStateWIFI;
            break;
            
        default:
            break;
    }
}

- (void)startNotificationNet:(id)sender{
    //开启网络状况的监听
    //写在appDelegate中，整个工程都可以监控网络状态
    //- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    
    [[NSNotificationCenter defaultCenter] addObserver:sender selector:@selector(reachabilityChanged:)name: kReachabilityChangedNotification object: nil];
    Reachability * hostReach = [[Reachability alloc]init ];
    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    //retain];//可以以多种形式初始化
    
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    
    //.....
}
#pragma mark - kReachabilityMethod
// 连接改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
    
}
//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    
    NetworkStatus status =[curReach currentReachabilityStatus];
    
    if (status == NotReachable) {  //没有连接到网络就弹出提示
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络故障"message:@"请检查你的网络设置"delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil];
        
        [alert show];
        
        //        [alert release];
    }
}
- (NetworkStatus)getCurrentNetStatus{
    Reachability * hostReach = [[Reachability alloc]init ];
    NetworkStatus status = [hostReach currentReachabilityStatus];
    return status;
}

@end
