//
//  DJXRequest.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXRequest.h"

@implementation DJXRequest
/// for subclasses to overwrite
- (void)requestCompleteFilter {
}

- (void)requestFailedFilter {
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    return kBaseUrl;
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

@end
