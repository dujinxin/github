//
//  NSFileManager+PathMethod.m
//  LimitFree
//
//  Created by student on 14-4-4.
//  Copyright (c) 2014年 djxin. All rights reserved.
//

#import "NSFileManager+PathMethod.h"

//文件管理类的类别
@implementation NSFileManager (PathMethod)

@dynamic filePath;
@dynamic folderPath;
//判断指定路径的文件是否超出了规定的时间
//NSTimeInterval 时间差变量，单位是秒
+(BOOL)isTimeOutWithPath:(NSString *)path time:(NSTimeInterval)time
{
    //通过NSFileManager取到path下的文件的属性（属性中包括文件的创建时间）
    //defaultManager 方法得到文件管理类的单例对象
    //获取path路径下文件的属性
    NSDictionary * info  = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    //取到文件的创建时间
    NSDate *createDate = [info objectForKey:@"NSFileCreationDate"];
    //获取当前时间
    NSDate *date = [NSDate date];
    //计算时间差
    NSTimeInterval currentTime = [date timeIntervalSinceDate:createDate];
    if (currentTime > time)//YES代表已经超时
        return YES;
    else
        return NO;
}


-(void)cleanCacheFolder{
    NSError * error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.folderPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.folderPath error:&error];
    }
}
-(void)cleanCacheFile{
    NSError * error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:&error];
    }
}

-(void)cleanCacheFolderWithPath:(NSString *)path{
    [self cleanCacheWithPath:path];
}
-(void)cleanCacheFileWithPath:(NSString *)path{
    [self cleanCacheWithPath:path];
}
-(void)cleanCacheWithPath:(NSString *)path{
    NSError * error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}


@end
