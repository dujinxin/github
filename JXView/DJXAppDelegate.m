//
//  DJXAppDelegate.m
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXAppDelegate.h"
#import "DJXRefreshAndLoadViewController.h"
#import "DJXBottomAutomaticLoadingViewController.h"
#import "DDMenuController.h"
#import "DJXMainViewController.h"
#import "DJXLeftViewController.h"
#import "DJXRightViewController.h"

#import "LeveyTabBarController.h"
//#import "MainViewController.h"
#import "DJXCategoryViewController.h"
#import "DJXPromotionViewController.h"
#import "DJXMyViewController.h"
#import "DJXCardViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "JXCartView.h"


@implementation DJXAppDelegate

+ (DJXAppDelegate *)appDelegate {
    return (DJXAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)hideTabBar:(BOOL)hidden{
    [_mytabBarController hidesTabBar:hidden animated:YES];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x184fa2)];
//        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Futura" size:18],
//                                      NSForegroundColorAttributeName: [UIColor whiteColor]};
//        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    }
    
    
    //    /* 创建五个viewcontroller */
    DJXMainViewController        *mainVC         = [[DJXMainViewController alloc] init] ;
    //    YHTableViewController * mainVC = [[YHTableViewController alloc ]init ];
    DJXCategoryViewController    *categoryVC     = [[DJXCategoryViewController alloc] init];
    DJXPromotionViewController   *promotionVC    = [[DJXPromotionViewController alloc] init];
    DJXMyViewController          *myVC           = [[DJXMyViewController alloc] init];
    DJXCardViewController        *cartVC         = [[DJXCardViewController alloc] init];
    /* 创建五个viewcontroller的导航条 */
    UINavigationController      *mainVcNav      = [[UINavigationController alloc ]initWithRootViewController:mainVC];
    UINavigationController      *categoryNav    = [[UINavigationController alloc ]initWithRootViewController:categoryVC];
    UINavigationController      *promotionNav   = [[UINavigationController alloc]initWithRootViewController:promotionVC];
    UINavigationController      *myNav          = [[UINavigationController alloc]initWithRootViewController:myVC ];
    UINavigationController      *cartNav        = [[UINavigationController alloc]initWithRootViewController:cartVC];
    
    // 逛－三分页控制
    NSArray *_navControllers= @[mainVcNav,categoryNav,promotionNav,myNav,cartNav];
    /* 创建tabbar viewcontroller */
    _mytabBarController = [[LeveyTabBarController alloc] initWithViewControllers:_navControllers imageArray:[self getTabBarIconArray]];
    _mytabBarController.delegate = self;
    
    
//    DJXMainViewController *mainController = [[DJXMainViewController alloc] init];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];

    _menuController = [[DDMenuController alloc] initWithRootViewController:_mytabBarController];
    
    DJXLeftViewController *leftController = [[DJXLeftViewController alloc] init];
    UINavigationController * nleft = [[UINavigationController alloc]initWithRootViewController:leftController];
    _menuController.leftViewController = nleft;
    
    DJXRightViewController *rightController = [[DJXRightViewController alloc] init];
//    rootController.rightViewController = rightController;
    
    self.window.rootViewController = _menuController;
    
    //想摇就写在这～～～
    application.applicationSupportsShakeToEdit=YES;
    
    //shareSDK,分享,微信，新浪
    [ShareSDK registerApp:@"7b13dc65eca"];
    // 导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK connectWeChatWithAppId:@"wxbceed00462510262"
                           wechatCls:[WXApi class]];
    [ShareSDK connectSinaWeiboWithAppKey:@"520063555" appSecret:@"334067194b7b54899444832d7bc75373" redirectUri:@"https://api.weibo.com/oauth2/default.html" weiboSDKCls:[WeiboSDK class]];
    
    //官方，微信，新浪
    
    //购物车
    JXCartView * cart = [[JXCartView alloc]initWithFrame:CGRectMake(135, 235, 50, 50)];
    cart.delegate = _menuController;
    [self.window.rootViewController.view addSubview:cart];
    
    [self.window makeKeyAndVisible];
    return YES;
    
    
    //UDID iOS5以前使用，已废弃
    //    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
    //CFUUID iOS5 需自己存储
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    //NSUUID iOS6 需自己存储
    NSString *uuid = [[NSUUID UUID] UUIDString];
    //广告标示符（IDFA-identifierForIdentifier）iOS6 系统存储
//    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Vindor标示符 (IDFV-identifierForVendor) iOS6 返回值是NSUUID对象 需自己存储
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"CFUUID:%@", cfuuidString);
    NSLog(@"NSUUID:%@", uuid);
//    NSLog(@"advertisingIdentifier:%@", adId);
    NSLog(@"identifierForVendor:%@", idfv);
    //测试结果 同一个设备每次启动CFUUID，NSUUID是会变的，而advertisingIdentifier，identifierForVendor不会变；假如还原广告标识符，那么除了identifierForVendor之外，其他的三个都会变。不同设备，那么四项都不同。所以用identifierForVendor唯一的标识符
    /*第一次
     CFUUID:7633BB95-B81A-4F28-AAE9-50632C9B6588
     NSUUID:741C26D3-E76B-47C2-B66A-835E18B3ADD9
     advertisingIdentifier:C484A1E3-F52A-4A6C-B9CE-BAC769AE9769
     identifierForVendor:2F3B746C-008D-41BB-87A2-8CA624DD35E8
     */
    /*第二次
     CFUUID:5435185C-FED8-4AC9-827C-FEDE3ED49F99
     NSUUID:1201D4B6-EFF7-4BD1-A904-861A94FA168F
     advertisingIdentifier:C484A1E3-F52A-4A6C-B9CE-BAC769AE9769
     identifierForVendor:2F3B746C-008D-41BB-87A2-8CA624DD35E8
     */
    /*第三，四次，卸载重新安装，还原设置，后两项不变
     CFUUID:5FCD67AE-A440-444C-B7B6-49A98FACA497
     NSUUID:626BA25E-0F3A-4145-9D84-4D75009B1AE3
     advertisingIdentifier:C484A1E3-F52A-4A6C-B9CE-BAC769AE9769
     identifierForVendor:2F3B746C-008D-41BB-87A2-8CA624DD35E8
     */
    /*第五次，还原广告标识符 只有最后一项不会变
     CFUUID:16F1CD87-999C-436A-A49A-99F54EDFCAF8
     NSUUID:BC0267CF-9B59-40DC-A3A4-CDFD93025F39
     advertisingIdentifier:48249451-B07A-4CAF-BD0E-4701B0018D03
     identifierForVendor:2F3B746C-008D-41BB-87A2-8CA624DD35E8
     */
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSArray *)getTabBarIconArray{
    NSDictionary *homeIconDic   = @{@"Normal": [UIImage imageNamed:@"guang"],@"Selected" : [UIImage imageNamed:@"guang_Select"],@"Title" : @"逛"};
    NSDictionary *shoppingIconDic = @{ @"Normal" : [UIImage imageNamed:@"buy"],@"Selected" : [UIImage imageNamed:@"buy_Select.png"],@"Title" : @"买" };
    NSDictionary *shakeIconDic = @{ @"Normal" : [UIImage imageNamed:@"my"],@"Selected" : [UIImage imageNamed:@"my_Select.png"],@"Title" : @"我的" };
    NSDictionary *likeIconDic = @{ @"Normal" : [UIImage imageNamed:@"message.png"],@"Selected" : [UIImage imageNamed:@"message_Select.png"],@"Title" : @"消息" };
    NSDictionary *myIconDic = @{ @"Normal" : [UIImage imageNamed:@"more.png"],@"Selected" : [UIImage imageNamed:@"more_Select.png"],@"Title" : @"更多" };
    
    NSArray *icons = @[homeIconDic,shoppingIconDic,shakeIconDic,likeIconDic,myIconDic];
    return icons;
}
//选中标签栏上的按钮的方法
- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    int index = [tabBarController.viewControllers indexOfObject:viewController];
    //选中购物车
    if (index == 4)
    {
        DJXCardViewController * cartViewCon = [[DJXCardViewController alloc] init];
        __block DJXAppDelegate *weakSelf = self;
//            cartViewCon.callBack = ^(){
//                [weakSelf.mytabBarController setSelectedIndex:weakSelf.selectTab];
//            };
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cartViewCon];
        [_mytabBarController presentViewController:nav animated:YES completion:^{
            
        }];
//        [_mytabBarController presentModalViewController:nav animated:YES];
    }
    return YES;
}

@end
