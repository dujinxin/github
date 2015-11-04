//
//  DJXRequest.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "DJXFileManager.h"

@interface DJXRequest()

@property (strong, nonatomic) id cacheJson;

@end

@implementation DJXRequest {
    BOOL _dataFromCache;
}

- (BOOL)useCache{
    return NO;
}
- (NSInteger)cacheTimeInSeconds {
    return -1;
}

- (long long)cacheVersion {
    return 0;
}

- (id)cacheSensitiveData {
    return nil;
}

- (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {//......
        [self addDoNotBackupAttribute:path];
    }
}

- (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];
    //清除缓存用。。。
    [DJXFileManager defaultManager ].folderPath = path;
    // filter cache base path
//    NSArray *filters = [[YTKNetworkConfig sharedInstance] cacheDirPathFilters];
//    if (filters.count > 0) {
//        for (id<YTKCacheDirPathFilterProtocol> f in filters) {
//            path = [f filterCacheDirPath:path withRequest:self];
//        }
//    }
    
    [self checkDirectory:path];
    return path;
}
#pragma mark - cache file name
- (NSString *)cacheFileName {
    NSString *requestUrl = self.requestUrl;
    id  param = self.requestDictionary;
    
    NSString * requestInfo = [NSString stringWithFormat:@"url:%@ param:%@",requestUrl,param];
    NSLog(@"requestInfo:%@",requestInfo);
    NSString *cacheFileName = [self md5StringFromString:requestInfo];
    return cacheFileName;
}
#pragma mark - cache file path
- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}
#pragma mark - cache time
- (int)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        NSLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return -1;
    }
    NSLog(@"fileDictionary:%@",attributes);
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}
#pragma mark - CacheVersion
- (NSString *)cacheVersionFilePath {
    NSString *cacheVersionFileName = [NSString stringWithFormat:@"%@.version", [self cacheFileName]];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheVersionFileName];
    return path;
}

- (long long)cacheVersionFileContent {
    NSString *path = [self cacheVersionFilePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        NSNumber *version = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [version longLongValue];
    } else {
        return 0;
    }
}
- (BOOL)isCacheVersionExpired {
    // check cache version
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion]) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark - Request
- (void)startAsynchronous{
    if ( ![self useCache]) {
        [super startAsynchronous];
        return;
    }
    // check cache version
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion]) {
        [super startAsynchronous];
        return;
    }
    
    // check cache time
    if ([self cacheTimeInSeconds] < 0) {
        [super startAsynchronous];
        return;
    }
    
    // check cache existance
    NSString *path = [self cacheFilePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
        [super startAsynchronous];
        return;
    }
    
    // check cache time
    NSInteger seconds = [self cacheFileDuration:path];
    if (seconds < 0) {
        [super startAsynchronous];
        return;
    }
    if (seconds > [self cacheTimeInSeconds]) {
        NSLog(@"Cache file overtime:%ld seconds",seconds - (long)[self cacheTimeInSeconds]);
        NSError * error = nil;
//        [fileManager removeItemAtPath:path error:&error];
//        [fileManager removeItemAtPath:pathVersion error:&error];
        if (error) {
            NSLog(@"Remove cache file error: %@",error.description);
        }
        [super startAsynchronous];
        return;
    }
    
    // load cache
    _cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (_cacheJson == nil) {
        [super startAsynchronous];
        return;
    }
    
    _dataFromCache = YES;
    [self requestCompleteFilter];
    DJXRequest *strongSelf = self;
    [strongSelf requestSuccess:strongSelf.responseJSONObject];
//    if (strongSelf.success) {
//        strongSelf.success(strongSelf);
//    }
    [strongSelf clearCompletionBlock];
}

- (void)startWithoutCache {
    [super startAsynchronous];
}

- (id)cacheJson {
    if (_cacheJson) {
        return _cacheJson;
    } else {
        NSString *path = [self cacheFilePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path isDirectory:nil] == YES) {
            _cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
        return _cacheJson;
    }
}

- (BOOL)isDataFromCache {
    return _dataFromCache;
}

#pragma mark - Network Request Delegate

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if ([self useCache]) {
        [self saveJsonResponseToCacheFile:[super responseJSONObject]];
    }
}
- (id)responseJSONObject {
    if (_cacheJson) {
        return _cacheJson;
    } else {
        return [super responseJSONObject];
    }
}
// 手动将其他请求的JsonResponse写入该请求的缓存
// 比如AddNoteApi, UpdateNoteApi都会获得Note，且其与GetNoteApi共享缓存，可以通过这个接口写入GetNoteApi缓存
- (void)saveJsonResponseToCacheFile:(id)jsonResponse {
    if ([self cacheTimeInSeconds] > 0 && ![self isDataFromCache]) {
        NSDictionary *json = jsonResponse;
        if (json != nil) {
            [NSKeyedArchiver archiveRootObject:json toFile:[self cacheFilePath]];
//            [NSKeyedArchiver archiveRootObject:@([self cacheVersion]) toFile:[self cacheVersionFilePath]];
        }
    }
}

#pragma mark - Other

- (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

- (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (BOOL)requestFailed:(id)responseData{
//    NSLog(@"failed----\n%@\n%@", );
//    NSLog(@"failed----:%ld", (long)request.responseStatusCode);
//    if(request.responseStatusCode == ASIRequestTimedOutErrorType)
//    {
//        //        [[iToast makeText:@"联网连接超时，请重试！"]show];
//        return TRUE;
//    }
    BOOL isFailed = [super requestFailed:responseData];
    if (isFailed) {
        if ([self isUseFormat]) {
            if ([responseData isKindOfClass:[NSString class]]) {
                NSString * errorStr = (NSString *)responseData;
                [self responseResult:nil message:errorStr isSuccess:NO];
            }else{
                [self responseResult:responseData message:nil isSuccess:NO];
            }
            return !isFailed;
        }else{
            return isFailed;
        }
    }
    return YES;
}

- (BOOL)requestSuccess:(id)responseData{
    BOOL isSuccess = [super requestSuccess:responseData];
    if (isSuccess) {
        NSError * error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"error with data analyzing :%@\n%@",error.domain,error.localizedDescription);
        }else{
            if (_dataFromCache){
                NSLog(@"来自缓存path:%@\n%@",[self cacheFilePath],[self requestUrl]);
            } else{
                NSLog(@"不来自缓存:%@",[self requestUrl]);
            }
            BOOL isResult = YES;
            if ([self isUseFormat]) {
                //返回YES则在model里单独处理数据，返回NO则统一处理
                isResult = [self handleResultData:result];
                return !isResult;
            }else{
                return isResult;
            }
        }
        
    }else{
        return NO;
    }
    return YES;
}

-(BOOL)handleResultData:(id)result{
    BOOL isSuccess = YES;
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        NSInteger status = [[dict objectForKey:@"status"]integerValue];
        NSString * message = [dict objectForKey:@"message"];
        if (status == 0) {
            [self responseResult:nil message: message isSuccess:NO];
            //可以直接回到界面
            //[self.delegate responseFailed:self.tag withMessage:message];
        }else if (status == 1){
            if ([dict objectForKey:@"data"]) {
                NSMutableArray * data = [dict objectForKey:@"data"];
                [self responseResult:data message:message isSuccess:YES];
                //可以直接回到界面
                //[self.delegate responseSuccess:data tag:self.tag];
            }else{
                [self responseResult:nil message:message isSuccess:YES];
                //可以直接回到界面
                //[self responseResult:nil message: message isSuccess:YES];
                NSLog(@"%@",message);
            }
        }else if (status == 10000){
            [self responseResult:nil message:message isSuccess:YES];
            //可以直接回到界面
            //[self responseResult:nil message: message isSuccess:YES];
            NSLog(@"%@",message);
            DJXLoginViewController * login = [[DJXLoginViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:login animated:YES completion:^{
                //
            }];
        }

    }else if ([result isKindOfClass:[NSArray class]]){
        NSArray * array = (NSArray *)result;
        for (id object in array) {
            //NSString * message = [dict objectForKey:@"message"];
            //NSLog(@"%@",message);
            if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
            }
        }
    }else{
        isSuccess = NO;
        NSLog(@"error with unsupport data format (neither NSDictionary nor NSArray)");
    }
    return isSuccess;
}
-(BOOL)isUseFormat{
    return NO;
}
- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    
}
@end
