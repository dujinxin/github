//
//  DJXBasicReqest.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXBasicRequest.h"


// 存放当前所有的BSI链接...
NSMutableArray *allBsiConnections;

@implementation DJXBasicRequest
@synthesize tag = _tag;
@synthesize delegate = _delegate;
@synthesize requestDictionary = _requestDictionary;
@synthesize manager = _manager;
@synthesize requestUrl = _requestUrl;

#pragma mark - RequestMethods
-(id)init{
    self = [super init];
    if (self) {
        //
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
- (instancetype)initWithDelegate:(id)vc action:(SEL)selector nApiTag:(NSInteger)tag{
    return [self initWithDelegate:vc action:selector success:nil failure:nil nApiTag:tag];
}
- (instancetype)initWithDelegate:(id)vc success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(NSInteger)tag{
    return [self initWithDelegate:vc action:nil success:success failure:failure nApiTag:tag];
}
- (instancetype)initWithDelegate:(id)vc action:(SEL)selector success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(NSInteger)tag{
    self = [super init];
    if (self) {
        if (vc)
            self.delegate = vc;
        if (selector)
            self.action = selector;
        if (success)
            self.success = [success copy];
        if (failure)
            self.failure = [failure copy];
        self.tag = tag;
    }
    return self;
}

+ (NSString *)className{
    return NSStringFromClass(self.class);
}
#pragma mark - setter
//-(void)setDelegate:(id<DJXRequestDelegate>)delegate{
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
//-(void)setCompletionBlockWithSuccess:(void (^)(DJXBasicRequest *))success failure:(void (^)(DJXBasicRequest *))failure{
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
//
//- (void) addPostValue:(id)value forKey:(NSString *)key {
//    [self.paramDict setObject:value forKey:key];
//}
// for subclasses to overwrite
#pragma mark - subClass need to overwrite
- (void)requestCompleteFilter {
    
}
- (void)requestFailedFilter {
    
}
//- (NSString *)requestUrl {
//    return @"";
//}
- (NSString *)cdnUrl {
    return @"";
}
- (NSString *)baseUrl {
    return @"";
}
- (id)requestArgument {
    return nil;
}
- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}
- (DJXRequestMethod)requestMethod {
    return kRequestMethodGet;
}
- (NSSet *)acceptableContentTypes{
    return [NSSet setWithObject:@"application/json"];
}
- (DJXRequestSerializerType)requestSerializerType {
    return DJXRequestSerializerTypeHTTP;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (id)jsonValidator {
    return nil;
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
/*数据请求*/
+ (void)requestWithClass:(NSString *)className delegate:(id)target kApiTag:(DJXApiTag)tag{
    [DJXBasicRequest requestWithClass:className delegate:target urlString:nil param:nil kApiTag:tag];
}
+ (void)requestWithClass:(NSString *)className delegate:(id)target urlString:(NSString *)url kApiTag:(DJXApiTag)tag{
    [DJXBasicRequest requestWithClass:className delegate:target urlString:url param:nil kApiTag:tag];
}
+ (void)requestWithClass:(NSString *)className delegate:(id)target urlString:(NSString *)url param:(NSDictionary *)param kApiTag:(DJXApiTag)tag{

    Class class = NSClassFromString(className);
    DJXBasicRequest * basicRequest = [[class alloc]init ];
    if (basicRequest.requestMethod) {
        basicRequest.requestMethod = kRequestMethodPost;
    }else{
        basicRequest.requestMethod = kRequestMethodGet;
    }
    if (target) {
        basicRequest.delegate = target;
    }
    if (url) {
        basicRequest.requestUrl = url;
    }
    if (param) {
        basicRequest.requestDictionary = (NSMutableDictionary *) param;
    }
    if (tag) {
        basicRequest.tag = tag;
    }
    [basicRequest startAsynchronous];
}
- (void)requestWithDelegate:(id)target urlString:(NSString *)url kApiTag:(DJXApiTag)tag{
    [self requestWithDelegate:target urlString:url param:nil kApiTag:tag];
}
- (void)requestWithDelegate:(id)target urlString:(NSString *)url param:(NSDictionary *)param kApiTag:(DJXApiTag)tag{
    self.requestMethod = kRequestMethodGet;
    if (target) {
        self.delegate = target;
    }
    if (url) {
        self.requestUrl = url;
    }
    if (param) {
        self.requestDictionary = [NSMutableDictionary dictionaryWithDictionary: param];
    }
    if (tag) {
        self.tag = tag;
    }
    [self startAsynchronous];
}

/*请求*/
- (void)startAsynchronous {
    [[DJXRequestManager sharedInstance] addRequest:self];
}
/*结束*/
- (void)stopAsynchronous{
    self.delegate = nil;
    [[DJXRequestManager sharedInstance] cancelRequest:self];
}

- (BOOL)requestFailed:(id)responseData{
    BOOL isJsonData = [NSJSONSerialization isValidJSONObject:responseData];
    if (!isJsonData) {
        NSLog(@"error with data is not json format")
    }
    //    NSLog(@"failed----\n%@\n%@", request.baseUrl.description,request.paramDict);
    //    NSLog(@"failed----:%ld", (long)request.responseStatusCode);
    //    if(request.responseStatusCode == ASIRequestTimedOutErrorType)
    //    {
    //        //        [[iToast makeText:@"联网连接超时，请重试！"]show];
    //        return TRUE;
    //    }
    return YES;
}

- (BOOL)requestSuccess:(id)responseData{
    return YES;
}
- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.success = nil;
    self.failure = nil;
}

#pragma mark -- description
- (NSString *)description {
    id requestParam;
    if (self.requestDictionary) {
        requestParam = self.requestDictionary;
    }else{
        requestParam = @"null";
    }
    return [NSString stringWithFormat:@"<%@: %p>\n properties:%@", NSStringFromClass([self class]), self,@{@"requestMethod":@(self.requestMethod),@"apiTag":@(self.tag),@"delegate":self.delegate,@"requestUrl":self.requestUrl,@"requestDictionary":requestParam}];
}
- (NSString *)debugDescription{
    id requestParam;
    if (self.requestDictionary) {
        requestParam = self.requestDictionary;
    }else{
        requestParam = @"null";
    }
    return [NSString stringWithFormat:@"<%@: %p>\n properties:%@", NSStringFromClass([self class]), self,@{@"requestMethod":@(self.requestMethod),@"apiTag":@(self.tag),@"delegate":self.delegate,@"requestUrl":self.requestUrl,@"requestDictionary":requestParam}];
}
@end
