//
//  DJXFileManager.m
//  JXView
//
//  Created by dujinxin on 15-4-17.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXFileManager.h"



@interface DJXFileManager ()

-(void)cleanCacheWithPath:(NSString *)path;
@end

NSString * const DJXFileErrorMessage = @"you need set FilePath first!";
NSString * const DJXFolderErrorMessage = @"you need set FolderPath first!";

@implementation DJXFileManager

static DJXFileManager * _manager = nil;
+(DJXFileManager *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DJXFileManager alloc]init ];
    });
    return _manager;
}

-(void)setFilePath:(NSString *)filePath{
    _filePath = filePath;
}
-(void)setFolderPath:(NSString *)folderPath{
    _folderPath = folderPath;
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
    NSAssert(!_filePath, DJXFileErrorMessage);
    return [self sizeOfFileWithPath:_filePath];
}
//单个文件的大小
-(CGFloat)sizeOfFileWithPath:(NSString *)path{
    if (!path) {
        return 0;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}
-(NSString *)sizeOfFolder{
    NSAssert(_folderPath, DJXFolderErrorMessage);
    return [self sizeOfFolderWithPath:_folderPath];
}
//遍历文件夹获得文件夹大小，返回多少M
-(NSString *)sizeOfFolderWithPath:(NSString *)path{
    if (!path) {
        return 0;
    }
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
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
    NSAssert(_folderPath, DJXFolderErrorMessage);
    [self cleanCacheFolderWithPath:_folderPath];
}
-(void)cleanCacheFile{
    NSAssert(_filePath, DJXFileErrorMessage);
    [self cleanCacheFileWithPath:_filePath];
}
-(void)cleanCacheFolderWithPath:(NSString *)path{
    [self cleanCacheWithPath:path];
}
-(void)cleanCacheFileWithPath:(NSString *)path{
    [self cleanCacheWithPath:path];
}
-(void)cleanCacheWithPath:(NSString *)path{
    if (!path) {
        return;
    }
    NSError * error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}
@end
