//
//  DJXAFRequestManager.m
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXAFRequestManagerTest.h"
#import "DJXAFRequestObjTest.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFDownloadRequestOperation.h"

#import "AppModel.h"
#import "appEntity.h"


@implementation DJXAFRequestManagerTest

static DJXAFRequestManagerTest * requestManager = nil;
+ (DJXAFRequestManagerTest *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[DJXAFRequestManagerTest alloc] init];
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
    self.requestDictionary = [NSMutableDictionary dictionary];
}

/*请求类的操作*/
//- (id)getRequestByApiTag:(EnumApiTag)nTag;
//{
//    return NULL;
//}
- (id)getRequestByKey:(NSString *)key;
{
    NSDictionary *copyRecord = [_requestDictionary copy];
    DJXAFRequestObjTest *request = copyRecord[key];
    if (request) {
        return request;
    }
    return NULL;
}

- (void)cancelRequestByViewController:(id)vc
{
//    for(int i = 0; i < [_arrRequst count];i++)
//    {
//        HttpRequestObj * obj = [_arrRequst objectAtIndex:i];
//        if(obj.viewController == vc)
//        {
//            [self cancelRequest:obj];
//        }
//    }
}
- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXAFRequestObjTest *request = copyRecord[key];
        [request stopAsynchronous];
    }
}
- (void)cancelRequest:(DJXAFRequestObjTest *)request
{
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}
/*任务队列的操作*/
- (void)addOperation:(DJXAFRequestObjTest *)request {
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        _requestDictionary[key] = request;
    }
}
- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    [_requestDictionary removeObjectForKey:key];
    NSLog(@"Request queue size = %lu", (unsigned long)[_requestDictionary count]);
}


/*请求结果的处理*/
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    NSString *key = [self requestHashKey:operation];
    DJXAFRequestObjTest *request = _requestDictionary[key];
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));

    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed && !error) {
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
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}
- (BOOL)checkResult:(DJXAFRequestObjTest *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
        id json = [request responseJSONObject];
//        result = [YTKNetworkPrivate checkJson:json withValidator:validator];
    }
    return result;
}

#pragma mark -/*用户部分*/
- (void)request:(id)delegate action:(SEL)selector url:(NSString *)urlString pageCount:(NSInteger)page
{
//    NSString * className = [NSString stringWithFormat:@"AppModelRequest2"];
//    Class class = NSClassFromString(className);
//    DJXAFRequestObj * request = [[class alloc]initWithDelegate:delegate action:selector nApiTag:kApiLimitFreeTag];
    AFNRequestTestModel * request;
    request = [[AFNRequestTestModel alloc]initWithDelegate:self action:selector nApiTag:12];
//    request = [[AppModelRequest2 alloc]initWithDelegate:delegate action:selector nApiTag:t_api_limitFree_tag];
//    if(!request){
//        DJXRelease(request);
//        return;
//    }
    request.baseUrl = [NSString stringWithFormat:urlString,page];
    request.delegate = (id)request;
    [request startAsynchronous];
//    DJXRelease(request);
}

@end
