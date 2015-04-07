//
//  DJXDeviceManager.m
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXDeviceManager.h"

//跟设备有关的参数，从此类获取
@implementation DJXDeviceManager


//获取屏幕的高度
+ (NSInteger)currentScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}
//获取设备的型号
+ (NSString *)currentDeviceModel
{
    //UIDevice 设备参数相关的类，设备的版本号，设备型号，设备名称等参数通过此类获取。
    //currentDevice 通过此方法来获取到UIDevice单例
    return [UIDevice currentDevice].model;
}

+ (NSInteger)IOSVersion
{
    //获取到操作系统的版本号
    NSString * currentVersion = [UIDevice currentDevice].systemVersion;
    //字符串方法（7.01,7.1//6.1.3）
    NSString * subString = [currentVersion substringToIndex:1];
    return subString.integerValue;
}
@end
