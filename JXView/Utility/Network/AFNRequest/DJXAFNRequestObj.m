//
//  DJXAFRequestObj.m
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXAFNRequestObj.h"


@implementation DJXAFNRequestObj
@synthesize tag = _tag;
@synthesize delegate = _delegate;
@synthesize baseUrl = _baseUrl;
@synthesize paramDict = _paramDict;

#pragma mark - RequestMethods
-(id)init{
    self = [super init];
    if (self) {
        //
    }
    return self;
}
- (instancetype)initWithDelegate:(id)vc nApiTag:(NSInteger)tag{
    return [self initWithTarget:vc action:nil nApiTag:tag];
}
- (instancetype)initWithTarget:(id)vc action:(SEL)selector nApiTag:(NSInteger)tag{
    return [self initWithDelegate:vc action:selector success:nil failure:nil nApiTag:tag];
}
- (instancetype)initWithSuccessBlock:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(NSInteger)tag{
    return [self initWithDelegate:nil action:nil success:success failure:failure nApiTag:tag];
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
        if (tag) {
            self.tag = tag;
        }
    }
    return self;
}

/// for subclasses to overwrite
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

- (DJXAFNRequestMethod)requestMethod {
    return kAFNRequestMethodGet;
}

- (DJXAFNRequestSerializerType)requestSerializerType {
    return DJXAFNRequestSerializerTypeHTTP;
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

- (void)addPostValue:(id)value forKey:(NSString *)key {
    [self.paramDict setObject:value forKey:key];
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
/*请求*/
- (void)startAsynchronous {
    [[DJXAFNRequestManager sharedInstance] addRequest:self];
}
/*结束*/
- (void)stopAsynchronous{
    self.delegate = nil;
    [[DJXAFNRequestManager sharedInstance] cancelRequest:self];
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

@end
