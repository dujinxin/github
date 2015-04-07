//
//  DJXAFRequestObj.m
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXAFRequestObjTest.h"

// 存放当前所有的BSI链接...
NSMutableArray *allBsiConnections;

@implementation DJXAFRequestObjTest
@synthesize tag = _tag;
@synthesize delegate = _delegate;
@synthesize baseUrl = _baseUrl;
@synthesize paramDict = _paramDict;
@synthesize manager = _manager;

#pragma mark - RequestMethods
-(id)init{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPRequestOperationManager manager];
//        self.requestDictionary = [NSMutableDictionary dictionary];
        self.manager.operationQueue.maxConcurrentOperationCount = 4;
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.requestSerializer.timeoutInterval = 30;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        self.paramDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}
+ (void) initialize {
    // 只是调用一次 BSIHttpRequest第一次实例化就会调用 z
    allBsiConnections = [[NSMutableArray alloc] init];
}
//- (id) initWithURL:(id)s {
//    self = [super init];
//    if (self) {
//        if ([s isKindOfClass:[NSString class]]) {
//            _url = [NSURL URLWithString:s];
//        } else if ([s isKindOfClass:[NSURL class]]) {
//            _url = (NSURL *)s;
//        } else
//            return nil;
//        paramDict = [[NSMutableDictionary alloc] init];
//        
//    }
//    return self;
//}
//+ (id) requestWithURL:(id)s {
//    return [[[self class] alloc] initWithURL:s];
//}
- (id)initWithDelegate:(id)vc action:(SEL)selector nApiTag:(NSInteger)tag{
    self = [super init];
    if (self) {
        self.delegate = vc;
        self.action = selector;
        self.tag = tag;
    }
    return self;
}
//-(void)setDelegate:(id<DJXAFRequestDelegate>)delegate{
//    self.delegate = delegate;
//}
//-(void)setAction:(SEL)action{
//    self.action = action;
//}
//-(void)setTag:(NSInteger)tag{
//    self.tag =tag;
//}
//-(void)setUserInfo:(NSDictionary *)userInfo{
//    self.userInfo = userInfo;
//}
//-(void)setParamDict:(NSMutableDictionary *)paramDict{
//    self.paramDict = paramDict;
//}
//-(void)setBaseUrl:(NSString *)baseUrl{
//    self.baseUrl = baseUrl;
//}
//-(void)setCompletionBlockWithSuccess:(void (^)(DJXAFRequestObj *))success failure:(void (^)(DJXAFRequestObj *))failure{
//    self.success = success;
//    self.failure = failure;
//}
//-(void)setSuccess:(requestCompletionBlock)success{
//    self.success = success;
//}
//-(void)setFailure:(requestCompletionBlock)failure{
//    self.failure = failure;
//}
//-(void)setResponseHeaders:(NSDictionary *)responseHeaders{
//    self.responseHeaders = responseHeaders;
//}
//-(void)setResponseJSONObject:(id)responseJSONObject{
//    self.responseJSONObject = responseJSONObject;
//}
//-(void)setResponseStatusCode:(NSInteger)responseStatusCode{
//    self.responseStatusCode = responseStatusCode;
//}
//-(void)setResponseString:(NSString *)responseString{
//    self.responseString = responseString;
//}
//+ (id)requestWithDelegate:(id<DJXRequestDelegate>)target{
//    
//}
- (void) addPostValue:(id)value forKey:(NSString *)key {
    [self.paramDict setObject:value forKey:key];
}
- (void) startAsynchronous {
    [[DJXAFRequestManagerTest sharedInstance] addRequest:self];
}
- (BOOL)isExecuting {
    return self.requestOperation.isExecuting;
}

- (id)responseJSONObject {
    return self.requestOperation.responseObject;
}

- (NSString *)responseString {
    return self.requestOperation.responseString;
}

- (NSInteger)responseStatusCode {
    return self.requestOperation.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.requestOperation.response.allHeaderFields;
}
- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)requestFailed:(id)responseData{
//    NSLog(@"failed----\n%@\n%@", request.baseUrl.description,request.paramDict);
//    NSLog(@"failed----:%ld", (long)request.responseStatusCode);
//    if(request.responseStatusCode == ASIRequestTimedOutErrorType)
//    {
//        //        [[iToast makeText:@"联网连接超时，请重试！"]show];
//        return TRUE;
//    }
    return YES;
}

-(BOOL) requestSuccess:(id)responseData{
    
//    if([request didUseCachedResponse]){
//        NSLog(@"=========资源请求：%@ 来自缓存============",[request url]);
//    }else{
//        NSLog(@"=========资源请求：%@ 不来自缓存============",[request url]);
//    }
//    NSLog(@"postValue:%@", [[[NSString alloc] initWithData:request.postBody encoding:    NSUTF8StringEncoding] autorelease]);
    
    return YES;
}
- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.success = nil;
    self.failure = nil;
}
#pragma mark - RequestMethod
//target-action
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target action:(SEL)action{
    [self requestWithMentod:requestMethod WithUrl:url param:param tag:tag delegate:target action:action success:nil failure:nil];
}
//代理
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url param:param tag:(NSInteger)tag delegate:(id)target{
    [self requestWithMentod:requestMethod WithUrl:url param:param tag:tag delegate:target action:nil success:nil failure:nil];
}
//block
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url param:param tag:(NSInteger)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    [self requestWithMentod:requestMethod WithUrl:url param:param tag:tag delegate:nil action:nil success:success failure:failure];
}
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url  param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target action:(SEL)action success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
//    if (self.requestSerializerType == DJXRequestSerializerTypeHTTP) {
//        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    } else if (self.requestSerializerType == DJXRequestSerializerTypeJSON) {
//        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    }
    self.baseUrl = url;
    self.tag = tag;
    if (target) {
        self.delegate = target;
    }
    if (success) {
        self.success = success;
    }
    if (failure) {
        self.failure = failure;
    }
    if (param) {
        self.paramDict = (NSMutableDictionary *)param;
    }
    if (action) {
        self.action  = action;
    }
    
    if (requestMethod == kRequestTestMethodGet) {
//            self.requestOperation =
        [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [self handleRequestResult:operation];
            NSLog(@"success:%@",responseObject);
                self.requestOperation = operation;
                if (self != nil && [self respondsToSelector:@selector(requestSuccess:)]) {
                    [self requestSuccess:self.requestOperation.responseData];
                }
                if (self.success) {
                    self.success(operation.responseData);
                }
            }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error:%@",error.localizedDescription);
//                [self handleRequestResult:operation];
            }
        ];
        
    } else if (requestMethod == kRequestTestMethodPost) {
//        if (constructingBlock != nil) {
//            self.requestOperation = [_manager POST:url parameters:param constructingBodyWithBlock:constructingBlock
//                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                  [self handleRequestResult:operation];
//                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                  [self handleRequestResult:operation];
//                                              }];
//        } else {
            self.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"success:%@",responseObject);
                self.requestOperation = operation;
                if (self != nil && [self respondsToSelector:@selector(requestSuccess:)]) {
                    [self requestSuccess:self.requestOperation.responseData];
                }
                if (self.success) {
                    self.success(operation.responseData);
                }
            }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error:%@",error.localizedDescription);
                //                [self handleRequestResult:operation];
            }];
//        }
    } else if (requestMethod == kRequestTestMethodHead) {
        self.requestOperation = [_manager HEAD:url parameters:param success:^(AFHTTPRequestOperation *operation) {
            [self handleRequestResult:operation];
        }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else if (requestMethod == kRequestTestMethodPut) {
        self.requestOperation = [_manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else if (requestMethod == kRequestTestMethodDelete) {
        self.requestOperation = [_manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        }                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else {
        NSLog(@"Error, unsupport method type");
        return;
    }

     NSLog(@"Add request: %@", NSStringFromClass([self class]));
    [[DJXAFRequestManagerTest sharedInstance] addOperation:self];

}
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation {
    NSString *key = [[DJXAFRequestManagerTest sharedInstance] requestHashKey:operation];
    DJXAFRequestObjTest *request = [[[DJXAFRequestManagerTest sharedInstance]requestDictionary]objectForKey:key];
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
//    if (request) {
//        BOOL succeed = [self checkResult:request];
//        if (succeed) {
            //            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccess:)]) {
                [self.delegate responseSuccess:request];
            }
            if (self.success) {
                self.success(request);
            }
//            [request toggleAccessoriesDidStopCallBack];
//        } else {
            NSLog(@"Request %@ failed, status code = %ld",
                  NSStringFromClass([request class]), (long)request.responseStatusCode);
            //            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
                [self.delegate requestFailed:request];
            }
            if (self.failure) {
                self.failure(request);
            }
//            [request toggleAccessoriesDidStopCallBack];
//        }
//    }
    [[DJXAFRequestManagerTest sharedInstance] removeOperation:operation];
    [self clearCompletionBlock];
}

@end
