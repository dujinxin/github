//
//  NSFileManager+PathMethod.h
//  LimitFree
//
//  Created by student on 14-4-4.
//  Copyright (c) 2014年 djxin. All rights reserved.
//

#import <Foundation/Foundation.h>
//文件管理类的类别
@interface NSFileManager (PathMethod)

//判断指定路径的文件是否超出了规定的时间
//NSTimeInterval 时间差变量，单位是秒
+(BOOL)isTimeOutWithPath:(NSString *)path time:(NSTimeInterval)time;
@end
