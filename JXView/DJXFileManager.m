//
//  DJXFileManager.m
//  JXView
//
//  Created by dujinxin on 15-4-17.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXFileManager.h"

@implementation DJXFileManager

static DJXFileManager * _manager = nil;
+(DJXFileManager *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DJXFileManager alloc]init ];
    });
    return _manager;
}
//判断指定路径的文件是否超出了规定的时间
//NSTimeInterval 时间差变量，单位是秒
+(BOOL)isTimeOutWithPath:(NSString *)path time:(NSTimeInterval)time
{
    //通过NSFileManager取到path下的文件的属性（属性中包括文件的创建时间）
    //defaultManager 方法得到文件管理类的单例对象
    //获取path路径下文件的属性
    NSDictionary * info  = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
    NSLog(@"%@",info);
    //取到文件的创建时间
    NSDate *createDate = [info objectForKey:@"NSFileCreationDate"];
    //获取当前时间
    NSDate *date = [NSDate date];
    //计算时间差
    NSTimeInterval currentTime = [date timeIntervalSinceDate:createDate];
    if (currentTime > time) {
        //YES代表已经超时
        return YES;
    }
    else
        return NO;
}

#pragma mark - sizeOfCache

-(CGFloat)sizeOfFile{
    return [self sizeOfFileWithPath:nil];
}
//单个文件的大小
-(CGFloat)sizeOfFileWithPath:(NSString *)path{
    if (path) {
        self.filePath = path;
    }
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.filePath]){
        return [[manager attributesOfItemAtPath:self.filePath error:nil] fileSize];
    }
    return 0;
}
-(NSString *)sizeOfFolder{
    return [self sizeOfFolderWithPath:nil];
}
//遍历文件夹获得文件夹大小，返回多少M
-(NSString *)sizeOfFolderWithPath:(NSString *)path{
    if (path) {
        self.folderPath = path;
    }
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self.folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:self.folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [self.folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self sizeOfFileWithPath:fileAbsolutePath];
    }
//    CGFloat newSize = folderSize /1024.0;
    if (folderSize /1024.0 < 1024.0) {
        return [NSString stringWithFormat:@"%.2fK", folderSize/1024.0];
    }else{
        return [NSString stringWithFormat:@"%.2fM", folderSize/(1024.0 *1024.0)];
    }
    
}

#pragma mark - cleanCache
-(void)cleanCacheFolder{
    [self cleanCacheFolderWithPath:nil];
}
-(void)cleanCacheFile{
    [self cleanCacheFileWithPath:nil];
}
-(void)cleanCacheFolderWithPath:(NSString *)path{
    if (path) {
        self.folderPath = path;
    }
    NSError * error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}
-(void)cleanCacheFileWithPath:(NSString *)path{
    if (path) {
        self.filePath = path;
    }
    NSError * error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}
@end
