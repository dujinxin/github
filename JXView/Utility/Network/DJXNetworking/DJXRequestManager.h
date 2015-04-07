//
//  DJXRequestManager.h
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

typedef enum{
    kRequestMethodGet = 0,
    kRequestMethodPost,
    kRequestMethodHead,
    kRequestMethodPut,
    kRequestMethodDelete,
}DJXRequestMethod;

typedef enum {
    DJXRequestSerializerTypeHTTP = 0,
    DJXRequestSerializerTypeJSON,
}DJXRequestSerializerType;

typedef enum {
    kApiLimitFreeTag = 12,
}DJXApiTag;

typedef enum {
    kRequestTypeInit =0,
    kRequestTypeRefresh,
    kRequestTypeLoadMore,
}DJXRequestType;

@class DJXBasicRequest;

@protocol DJXRequestManagerDelegate <NSObject>

@optional

-(void)requestSuccess:(DJXBasicRequest *)request;
-(void)requestFailed:(DJXBasicRequest *)request;

@end

typedef void (^requestCompletionBlock)(id object);

@interface DJXRequestManager : NSObject<DJXRequestManagerDelegate>

+ (DJXRequestManager *)sharedInstance;

- (void)addRequest:(DJXBasicRequest *)request;
- (void)cancelRequest:(DJXBasicRequest *)request;
- (void)cancelRequestByViewController:(id)vc;

- (void)addOperation:(DJXBasicRequest *)request;
- (void)removeOperation:(AFHTTPRequestOperation *)operation;

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation;
#pragma mark 根据apiTag获取请求对象（HttpRequestObj）  nTag：apitag re:HttpRequestObj

//-(id)getRequestManagerByApiTag:(DJXApiTag)tag;

#pragma mark


//// block回调
//- (void)startWithCompletionBlockWithSuccess:(void (^)(DJXBasicRequest *request))success
//                                    failure:(void (^)(DJXBasicRequest *request))failure;
//
//- (void)setCompletionBlockWithSuccess:(void (^)(DJXBasicRequest *request))success
//                              failure:(void (^)(DJXBasicRequest *request))failure;


// Request Accessory，可以hook Request的start和stop
//- (void)addAccessory:(id<YTKRequestAccessory>)accessory;


#pragma mark 所有请求
//target-action
- (void)requestWithTarget:(id)target className:(NSString *)className action:(SEL)action;
- (void)requestWithTarget:(id)target className:(NSString *)className kApiTag:(DJXApiTag)tag action:(SEL)action;
- (void)requestWithTarget:(id)target className:(NSString *)className param:(NSDictionary *)param kApiTag:(DJXApiTag)tag action:(SEL)action;
- (void)requestWithTarget:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url kApiTag:(DJXApiTag)tag action:(SEL)action;
- (void)requestWithTarget:(id)target className:(NSString *)className urlString:(NSString *)url kApiTag:(DJXApiTag)tag action:(SEL)action;
- (void)requestWithTarget:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url method:(DJXRequestMethod)requestMethod kApiTag:(DJXApiTag)tag action:(SEL)action;
//delegate
- (void)requestWithDelegate:(id)target className:(NSString *)className;
- (void)requestWithDelegate:(id)target className:(NSString *)className kApiTag:(DJXApiTag)tag;
- (void)requestWithDelegate:(id)target className:(NSString *)className param:(NSDictionary *)param kApiTag:(DJXApiTag)tag;
- (void)requestWithDelegate:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url kApiTag:(DJXApiTag)tag;
- (void)requestWithDelegate:(id)target className:(NSString *)className urlString:(NSString *)url kApiTag:(DJXApiTag)tag;
- (void)requestWithDelegate:(id)target className:(NSString *)className param:(NSDictionary *)param urlString:(NSString *)url method:(DJXRequestMethod)requestMethod kApiTag:(DJXApiTag)tag;
//block
- (void)requestWithBlock:(NSString *)url success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
- (void)requestWithBlock:(NSString *)className param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
- (void)requestWithBlock:(NSString *)className method:(DJXRequestMethod)requestMethod url:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
@end
