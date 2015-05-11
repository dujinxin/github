//
//  DJXRequestManager.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXRequestManager.h"
#import "DJXBasicRequest.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFDownloadRequestOperation.h"

#import "DJXRequestGet.h"

@interface DJXRequestManager(){
    NSMutableDictionary * requestDictionary;
    AFHTTPRequestOperationManager *manager;
}
- (void)requestWithClass:(NSString *)className delegate:(id)target param:(NSDictionary *)param urlString:(NSString *)url method:(DJXRequestMethod)requestMethod kApiTag:(DJXApiTag)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure action:(SEL)action;

@end

@implementation DJXRequestManager

static DJXRequestManager * requestManager = nil;
+ (DJXRequestManager *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[DJXRequestManager alloc] init];
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
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//，任意类型的数据，自己解析
    manager.requestSerializer.timeoutInterval = 3;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
}
#pragma mark - OperationMethod
/*任务队列的操作*/
- (void)addOperation:(DJXBasicRequest *)request {
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
#pragma mark - RequestMethod
/*请求类的操作*/
- (id)getRequestByApiTag:(DJXApiTag)tag;
{
    return NULL;
}
- (id)getRequestByKey:(NSString *)key;
{
    NSDictionary *copyRecord = [requestDictionary copy];
    DJXBasicRequest *request = copyRecord[key];
    if (request) {
        return request;
    }
    return NULL;
}

- (void)cancelRequestByViewController:(id)vc
{
    NSDictionary *copyRecord = [requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXBasicRequest *request = copyRecord[key];
        if(request.delegate == vc)
            [request stopAsynchronous];
    }
}
- (void)cancelAllRequests {
    NSDictionary *copyRecord = [requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXBasicRequest *request = copyRecord[key];
        [request stopAsynchronous];
    }
}
- (void)cancelRequest:(DJXBasicRequest *)request
{
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}

- (void)addRequest:(DJXBasicRequest *)request {
    //    YTKRequestMethod method = [request requestMethod];
    //    NSString *url = [self buildRequestUrl:request];
    NSString *url;
    if ([request requestUrl]) {
        url = [request requestUrl];
    }else{
        url = request.requestUrl;
    }
    id param = request.requestDictionary;
    //    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    if (request.requestSerializerType == DJXRequestSerializerTypeHTTP) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == DJXRequestSerializerTypeJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if(request.requestMethod == kRequestMethodGet) {
        request.requestOperation = [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleSuccessResult:operation responseObject:(id)responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
        
    }else if (request.requestMethod == kRequestMethodPost) {
        request.requestOperation = [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[self handleSuccessResult:operation responseObject:(id)responseObject];
            [self handleRequestResult:operation error:nil];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[self handleFailureResult:operation error:error];
            [self handleRequestResult:operation error:error];
        }];
    }else if (request.requestMethod == kRequestMethodHead) {
        request.requestOperation = [manager HEAD:url parameters:param success:^(AFHTTPRequestOperation *operation) {
            [self handleSuccessResult:operation responseObject:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
    }else if (request.requestMethod == kRequestMethodPut) {
        request.requestOperation = [manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleSuccessResult:operation responseObject:(id)responseObject];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureResult:operation error:error];
        }];
    }else if (request.requestMethod == kRequestMethodDelete) {
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
#pragma mark - ResultMethod
/*请求结果的处理*/
- (void)handleSuccessResult:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject{
    NSString *key = [[DJXRequestManager sharedInstance] requestHashKey:operation];
    DJXBasicRequest *request = [requestDictionary objectForKey:key];
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
    NSLog(@"operation.response.allHeaderFields:%@",operation.response.allHeaderFields);
    NSLog(@"operation.response.statusCode:%d",operation.response.statusCode);
    NSLog(@"StatusString: %@",[[operation.response class]localizedStringForStatusCode:operation.response.statusCode]);
    
//    [request toggleAccessoriesWillStopCallBack];
    /*
     *可以返回到request类进行相关操作
     */
    [request requestCompleteFilter];
    if (request != nil && [request respondsToSelector:@selector(requestSuccess:)]) {
        [request requestSuccess:operation.responseObject];
    }
    if (request.success) {
        request.success(request);
    }
    /*
     *也可以直接返回到视图界面操作
     *
    if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestSuccess:)]) {
        [request.delegate responseSuccess:operation.responseObject];
    }
    if (request.success) {
        request.success(request);
    }
     */
//    [request toggleAccessoriesWillStopCallBack];

    [[DJXRequestManager sharedInstance] removeOperation:operation];
    [request clearCompletionBlock];
}
- (void)handleFailureResult:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    NSLog(@"error.localizedDescription:%@",error.localizedDescription);
    NSLog(@"error.domain:%@",error.domain);
    NSLog(@"operation.response.allHeaderFields:%@",operation.response.allHeaderFields);
    NSLog(@"operation.response.statusCode:%d",operation.response.statusCode);
    NSLog(@"StatusString: %@",[[operation.response class]localizedStringForStatusCode:operation.response.statusCode]);
    NSString *key = [[DJXRequestManager sharedInstance] requestHashKey:operation];
    DJXBasicRequest *request = [requestDictionary objectForKey:key];
//   [request toggleAccessoriesWillStopCallBack];
    /*
     *可以返回到request类进行相关操作
     */
    [request requestFailedFilter];
    NSLog(@"Failure Request: %@", NSStringFromClass([request class]));
    if (request != nil && [request respondsToSelector:@selector(requestFailed:)]) {
        [request requestFailed:operation];
    }
    if (request.failure) {
        request.failure(operation);
    }
    /*
     *也可以直接返回到视图界面操作
     *
     if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
     [request.delegate responseFailed:request];
     }
     if (request.failure) {
     request.failure(request);
     }
     */
//   [request toggleAccessoriesDidStopCallBack];
    NSLog(@"%@ Request failed, status code = %ld",NSStringFromClass([request class]), (long)request.responseStatusCode);
    [[DJXRequestManager sharedInstance] removeOperation:operation];
    [request clearCompletionBlock];
}
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    NSString *key = [self requestHashKey:operation];
    DJXBasicRequest *request = requestDictionary[key];
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed && !error) {
            //    [request toggleAccessoriesWillStopCallBack];
            /*
             *可以返回到request类进行相关操作
             */
            [request requestCompleteFilter];
            if (request && [request respondsToSelector:@selector(requestSuccess:)]) {
                [request requestSuccess:operation.responseObject];
            }
            if (request.success) {
                request.success(request);
            }
            /*
             *也可以直接返回到视图界面操作
             *
             if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestSuccess:)]) {
             [request.delegate responseSuccess:operation.responseObject];
             }
             if (request.success) {
             request.success(request);
             }
             */
            //    [request toggleAccessoriesWillStopCallBack];
        } else {
            if (!error) {
                //。。。
                BOOL isJsonData = [NSJSONSerialization isValidJSONObject:operation.responseObject];
                if (!isJsonData) {
                    NSLog(@"error with data is not json format")
                }
            }else{
                //NSURLErrorDomain 点进去可以查看众多错误类型，
                NSLog(@"%@ request failed, status code = %ld error:%@",
                      NSStringFromClass([request class]), (long)request.responseStatusCode,error.localizedDescription);
            }
            //   [request toggleAccessoriesWillStopCallBack];
            /*
             *可以返回到request类进行相关操作
             */
            [request requestFailedFilter];
            if (request && [request respondsToSelector:@selector(requestFailed:)]) {
                [request requestFailed:operation];
            }
            if (request.failure) {
                request.failure(operation);
            }
            /*
             *也可以直接返回到视图界面操作
             *
             if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
             [request.delegate responseFailed:request];
             }
             if (request.failure) {
             request.failure(request);
             }
             */
            //   [request toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}
- (BOOL)checkResult:(DJXBasicRequest *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
        //id json = [request responseJSONObject];
        //        result = [YTKNetworkPrivate checkJson:json withValidator:validator];
    }
//    id json = [request responseJSONObject];
//    if (json)
//        result = [NSJSONSerialization isValidJSONObject:json];
    return result;
}

#pragma mark -/*用户部分*/
#pragma mark - RequestWithTarget-Action
//target-action
- (void)requestWithTarget:(id)target className:(NSString *)className action:(SEL)action{
    [self requestWithTarget:target className:className kApiTag:0 action:action];
}
- (void)requestWithTarget:(id)target className:(NSString *)className kApiTag:(DJXApiTag)tag action:(SEL)action{
    [self requestWithTarget:target className:className param:nil kApiTag:tag action:(SEL)action];
}
- (void)requestWithTarget:(id)target className:(NSString *)className urlString:(NSString *)url kApiTag:(DJXApiTag)tag action:(SEL)action{
    [self requestWithTarget:target className:className param:nil urlString:url method:kRequestMethodGet kApiTag:tag action:(SEL)action];
}
- (void)requestWithTarget:(id)target className:(NSString *)className param:(NSDictionary *)param kApiTag:(DJXApiTag)tag action:(SEL)action{
    [self requestWithTarget:target className:className param:param urlString:nil method:kRequestMethodGet kApiTag:tag action:(SEL)action];
}
- (void)requestWithTarget:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url kApiTag:(DJXApiTag)tag action:(SEL)action{
    [self requestWithTarget:target className:className param:param urlString:url method:kRequestMethodGet kApiTag:tag action:(SEL)action];
}
- (void)requestWithTarget:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url method:(DJXRequestMethod)requestMethod kApiTag:(DJXApiTag)tag action:(SEL)action{
    [self requestWithClass:className delegate:target param:param urlString:url method:requestMethod kApiTag:tag success:nil failure:nil action:(SEL)action];
}
#pragma mark - RequestWithDelegate
- (void)requestWithDelegate:(id)target className:(NSString *)className{
    [self requestWithDelegate:target className:className urlString:nil kApiTag:0];
}
- (void)requestWithDelegate:(id)target className:(NSString *)className kApiTag:(DJXApiTag)tag{
    [self requestWithDelegate:target className:className param:nil kApiTag:tag];
}
- (void)requestWithDelegate:(id)target className:(NSString *)className urlString:(NSString *)url kApiTag:(DJXApiTag)tag{
    [self requestWithDelegate:target className:className param:nil urlString:url method:kRequestMethodGet kApiTag:tag];
}
- (void)requestWithDelegate:(id)target className:(NSString *)className param:(NSDictionary *)param kApiTag:(DJXApiTag)tag{
    [self requestWithDelegate:target className:className param:param urlString:nil method:kRequestMethodGet kApiTag:tag];
}
- (void)requestWithDelegate:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url kApiTag:(DJXApiTag)tag{
    [self requestWithDelegate:target className:className param:param urlString:url method:kRequestMethodGet kApiTag:tag];
}
- (void)requestWithDelegate:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url method:(DJXRequestMethod)requestMethod kApiTag:(DJXApiTag)tag{
    [self requestWithClass:className delegate:target param:param urlString:url method:requestMethod kApiTag:tag success:nil failure:nil action:nil];
}

#pragma mark - RequestWithBlock
//block
- (void)requestWithBlock:(NSString *)url success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    [self requestWithBlock:nil method:kRequestMethodGet url:url param:nil tag:0 success:success failure:failure];
}
- (void)requestWithBlock:(NSString *)className param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    [self requestWithBlock:className method:kRequestMethodGet url:nil param:param tag:0 success:success failure:failure];
}
- (void)requestWithBlock:(NSString *)className method:(DJXRequestMethod)requestMethod url:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    [self requestWithClass:className delegate:nil param:param urlString:url method:requestMethod kApiTag:tag success:success failure:failure action:nil];
}

#pragma mark - PrivateMethod
- (void)requestWithClass:(NSString *)className delegate:(id)target param:(NSDictionary *)param urlString:(NSString *)url method:(DJXRequestMethod)requestMethod kApiTag:(DJXApiTag)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure action:(SEL)action{
    
    Class class = NSClassFromString(className);
    DJXBasicRequest * basicRequest = [[class alloc]init ];
    //当数据类型发生改变时，需在具体的请求处设置类型，然后在此更换接收数据类型
    if (![basicRequest.acceptableContentTypes isEqualToSet:manager.responseSerializer.acceptableContentTypes]) {
        manager.responseSerializer.acceptableContentTypes = basicRequest.acceptableContentTypes;
    }
    if (requestMethod != basicRequest.requestMethod) {
        basicRequest.requestMethod = requestMethod;
    }
    if (target) {
        basicRequest.delegate = target;
    }
    if (url) {
        basicRequest.requestUrl = url;
    }
    if (param) {
        basicRequest.requestDictionary = (NSMutableDictionary *)param;
    }
    if (tag != 0) {
        basicRequest.tag = tag;
    }
    if (success) {
        basicRequest.success = success;
    }
    if (failure) {
        basicRequest.failure = failure;
    }
    if (action) {
        basicRequest.action = action;
    }
    NSLog(@"basic:%@",basicRequest);
    [basicRequest startAsynchronous];
}
@end
