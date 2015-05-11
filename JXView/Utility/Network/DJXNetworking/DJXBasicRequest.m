//
//  DJXBasicReqest.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXBasicRequest.h"



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
- (instancetype)initWithDelegate:(id)vc nApiTag:(DJXApiTag)tag{
    return [self initWithDelegate:vc action:nil success:nil failure:nil nApiTag:tag];
}
- (instancetype)initWithDelegate:(id)vc action:(SEL)selector nApiTag:(DJXApiTag)tag{
    return [self initWithDelegate:vc action:selector success:nil failure:nil nApiTag:tag];
}
- (instancetype)initWithDelegate:(id)vc success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(DJXApiTag)tag{
    return [self initWithDelegate:vc action:nil success:success failure:failure nApiTag:tag];
}
- (instancetype)initWithDelegate:(id)vc action:(SEL)selector success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(DJXApiTag)tag{
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


+ (NSString *)className{
    return NSStringFromClass(self.class);
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
