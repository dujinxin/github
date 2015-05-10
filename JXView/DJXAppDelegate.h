//
//  DJXAppDelegate.h
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"
#import "AGViewDelegate.h"
#import "DDMenuController.h"


//微信官方
#import "WXApi.h"

@class DJXAppDelegate;
@interface DJXAppDelegate : UIResponder <UIApplicationDelegate,LeveyTabBarControllerDelegate,DDMenuControllerDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) LeveyTabBarController *mytabBarController;
@property (strong, nonatomic) AGViewDelegate * viewDelegate;

+ (DJXAppDelegate *)appDelegate;
- (void)hideTabBar:(BOOL)hidden;
@end
