//
//  DJXFileManager.h
//  JXView
//
//  Created by dujinxin on 15-4-17.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

//文件管理类的类别

@interface DJXFileManager : NSObject

@property (nonatomic, copy)NSString * folderPath;
@property (nonatomic, copy)NSString * filePath;


+(DJXFileManager *)defaultManager;

//判断指定路径的文件是否超出了规定的时间
//NSTimeInterval 时间差变量，单位是秒
+(BOOL)isTimeOutWithPath:(NSString *)path time:(NSTimeInterval)time;

-(NSString *)sizeOfFolder;
-(CGFloat)sizeOfFile;
-(NSString *)sizeOfFolderWithPath:(NSString *)path;
-(CGFloat)sizeOfFileWithPath:(NSString *)path;
//清除缓存--文件夹，文件
-(void)cleanCacheFolder;
-(void)cleanCacheFile;
-(void)cleanCacheFolderWithPath:(NSString *)path;
-(void)cleanCacheFileWithPath:(NSString *)path;

@end
