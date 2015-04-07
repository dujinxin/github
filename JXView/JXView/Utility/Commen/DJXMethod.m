//
//  DJXMethod.m
//  JXView
//
//  Created by dujinxin on 14-11-3.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXMethod.h"

@implementation DJXMethod

//当程序崩溃（Crash）时发出通知
//BSCrashNotifier is a bundle that allows you to be notified when your app is crashing.
- (void)addCrashNotification{
    NSBundle* bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"BSCrashNotifier" ofType:@"bundle"]];
    Class crashNotifierClass = [bundle principalClass];
    if (crashNotifierClass)
    {
//        [crashNotifierClass onCrashSend:@selector(weCrashed:) to:self];
    }
    else
    {
        NSLog(@"couldn't load bundle");
    }
}
//and implement the notification method like:
- (void)weCrashed:(int)signalNumber
{
    NSLog(@"we crashed: %i",signalNumber);
}
@end
