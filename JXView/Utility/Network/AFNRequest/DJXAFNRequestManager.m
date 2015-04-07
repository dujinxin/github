//
//  DJXAFRequestManager.m
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXAFNRequestManager.h"
#import "DJXAFNRequestObj.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFDownloadRequestOperation.h"

#import "AppModel.h"
#import "appEntity.h"

@interface DJXAFNRequestManager(){
    NSMutableDictionary * requestDictionary;
    AFHTTPRequestOperationManager * manager;
}

@end

@implementation DJXAFNRequestManager

static DJXAFNRequestManager * requestManager = nil;
+ (DJXAFNRequestManager *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[DJXAFNRequestManager alloc] init];
        [requestManager initData];
    });
    return requestManager;
}

- (void)dealloc
{
    DJXSuperDealloc;
}

- (void)initData
{
    manager = [AFHTTPRequestOperationManager manager];
    requestDictionary = [NSMutableDictionary dictionary];
    manager.operationQueue.maxConcurrentOperationCount = 4;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
}

/*请求类的操作*/
//- (id)getRequestByApiTag:(EnumApiTag)nTag;
//{
//    return NULL;
//}
- (id)getRequestByKey:(NSString *)key;
{
    NSDictionary *copyRecord = [requestDictionary copy];
    DJXAFNRequestObj *request = copyRecord[key];
    if (request) {
        return request;
    }
    return NULL;
}

- (void)cancelRequestByViewController:(id)vc
{
    NSDictionary *copyRecord = [requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXAFNRequestObj *request = copyRecord[key];
        if(request.delegate == vc)
            [request stopAsynchronous];
    }
}
- (void)cancelAllRequests {
    NSDictionary *copyRecord = [requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXAFNRequestObj *request = copyRecord[key];
        [request stopAsynchronous];
    }
}
- (void)cancelRequest:(DJXAFNRequestObj *)request
{
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}
/*任务队列的操作*/
- (void)addOperation:(DJXAFNRequestObj *)request {
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        requestDictionary[key] = request;
    }
}
- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    [requestDictionary removeObjectForKey:key];
    NSLog(@"Request queue size = %lu", (unsigned long)[requestDictionary count]);
}
- (void)addRequest:(DJXAFNRequestObj *)request {
    //    YTkAFNRequestMethod method = [request requestMethod];
    //    NSString *url = [self buildRequestUrl:request];
    NSString *url = request.requestUrl;
    id param = request.paramDict;
    //    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    
    if (request.requestSerializerType == DJXAFNRequestSerializerTypeHTTP) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == DJXAFNRequestSerializerTypeJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if(request.requestMethod == kAFNRequestMethodGet) {
        request.requestOperation = [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleSuccessResult:operation responseObject:(id)responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
        
    }else if (request.requestMethod == kAFNRequestMethodPost) {
        request.requestOperation = [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleSuccessResult:operation responseObject:(id)responseObject];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
    }else if (request.requestMethod == kAFNRequestMethodHead) {
        request.requestOperation = [manager HEAD:url parameters:param success:^(AFHTTPRequestOperation *operation) {
            [self handleSuccessResult:operation responseObject:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
    }else if (request.requestMethod == kAFNRequestMethodPut) {
        request.requestOperation = [manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleSuccessResult:operation responseObject:(id)responseObject];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
    }else if (request.requestMethod == kAFNRequestMethodDelete) {
        request.requestOperation = [manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleSuccessResult:operation responseObject:(id)responseObject];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
    }else {
        NSLog(@"Error, unsupport method type");
        return;
    }
    
    
    NSLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
}
/*请求结果的处理*/
- (void)handleSuccessResult:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject{
    NSString *key = [[DJXAFNRequestManager sharedInstance] requestHashKey:operation];
    DJXAFNRequestObj *request = [requestDictionary objectForKey:key];
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
    //    [request toggleAccessoriesWillStopCallBack];
    [request requestCompleteFilter];
    if (request != nil && [request respondsToSelector:@selector(requestSuccess:)]) {
        [request requestSuccess:operation.responseObject];
    }
    if (request.success) {
        request.success(request);
    }
    //    [request toggleAccessoriesWillStopCallBack];
    
    [[DJXAFNRequestManager sharedInstance] removeOperation:operation];
    [request clearCompletionBlock];
}
- (void)handleFailureResult:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    NSLog(@"error.localizedDescription:%@",error.localizedDescription);
    NSLog(@"error.domain:%@",error.domain);
    NSString *key = [[DJXAFNRequestManager sharedInstance] requestHashKey:operation];
    DJXAFNRequestObj *request = [requestDictionary objectForKey:key];
    //   [request toggleAccessoriesWillStopCallBack];
    [request requestFailedFilter];
    NSLog(@"Failure Request: %@", NSStringFromClass([request class]));
    if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
        [request.delegate requestFailed:request];
    }
    if (request.failure) {
        request.failure(request);
    }
    //   [request toggleAccessoriesDidStopCallBack];
    NSLog(@"Request %@ failed, status code = %ld",NSStringFromClass([request class]), (long)request.responseStatusCode);
    [[DJXAFNRequestManager sharedInstance] removeOperation:operation];
    [request clearCompletionBlock];
}
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    DJXAFNRequestObj *request = requestDictionary[key];
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
//            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil && [request.delegate respondsToSelector:@selector(responseSuccess:)]) {
                [request.delegate responseSuccess:request];
            }
//            if (request.successCompletionBlock) {
//                request.successCompletionBlock(request);
//            }
//            [request toggleAccessoriesDidStopCallBack];
        } else {
            NSLog(@"Request %@ failed, status code = %ld",
                   NSStringFromClass([request class]), (long)request.responseStatusCode);
//            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
                [request.delegate requestFailed:request];
            }
//            if (request.failureCompletionBlock) {
//                request.failureCompletionBlock(request);
//            }
//            [request toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}
- (BOOL)checkResult:(DJXAFNRequestObj *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
//        id json = [request responseJSONObject];
//        result = [YTKNetworkPrivate checkJson:json withValidator:validator];
    }
    return result;
}

#pragma mark -/*用户部分*/ ------建议新实例一个类，然后把这些请求方法归到一起，方便查看，修改。具体可参考TestRequestObj类
- (void)requestWithDelegate:(id)delegate action:(SEL)selector url:(NSString *)urlString pageCount:(NSInteger)page
{
    DJXAFNRequestObj * request = NULL;
    request = [[AppModelRequest2 alloc]initWithTarget:delegate action:selector nApiTag:kAFNApiLimitFreeTag];
    if(!request){
        DJXRelease(request);
        return;
    }
    request.requestUrl = [NSString stringWithFormat:urlString,page];
    request.requestMethod = kAFNRequestMethodGet;
    [request startAsynchronous];
    DJXRelease(request);
}
- (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    [self requestWithDelegate:nil action:nil url:url success:success failure:failure tag:tag];
}
- (void)requestWithTarget:(id)target action:(SEL)action url:(NSString *)url param:(NSDictionary *)param tag:(DJXAFNApiTag)tag{
    [self requestWithDelegate:target action:action url:url success:nil failure:nil tag:tag];
}
- (void)requestWithDelegate:(id)delegate action:(SEL)selector url:(NSString *)urlString success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure tag:(DJXAFNApiTag)tag{
    DJXAFNRequestObj * request = NULL;
    request = [[AppModelRequest2 alloc]initWithTarget:delegate action:selector nApiTag:kAFNApiLimitFreeTag];
    request.success = success;
    request.failure = failure;
    if(!request){
        DJXRelease(request);
        return;
    }
    request.action = selector;
    request.requestUrl = urlString;
    request.delegate = delegate;
    request.requestMethod = kAFNRequestMethodGet;
    [request startAsynchronous];
    DJXRelease(request);
}
@end
