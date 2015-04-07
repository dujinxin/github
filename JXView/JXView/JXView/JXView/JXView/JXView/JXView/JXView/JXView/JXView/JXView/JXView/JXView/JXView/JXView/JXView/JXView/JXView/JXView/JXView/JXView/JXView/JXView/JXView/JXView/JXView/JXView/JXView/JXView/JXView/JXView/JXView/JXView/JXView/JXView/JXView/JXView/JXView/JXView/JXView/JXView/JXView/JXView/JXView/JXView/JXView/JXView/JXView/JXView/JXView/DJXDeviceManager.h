//
//  DJXDeviceManager.h
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

//跟设备有关的参数，从此类获取
@interface DJXDeviceManager : NSObject

//获取屏幕的高度
+ (NSInteger)currentScreenHeight;

//get systerm version
+ (NSInteger)IOSVersion;

//获取设备的型号
+ (NSString *)currentDeviceModel;
@end
