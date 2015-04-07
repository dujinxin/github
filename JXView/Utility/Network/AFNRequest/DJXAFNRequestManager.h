//
//  DJXAFRequestManager.h
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

typedef enum{
    kAFNRequestMethodGet = 0,
    kAFNRequestMethodPost,
    kAFNRequestMethodHead,
    kAFNRequestMethodPut,
    kAFNRequestMethodDelete,
}DJXAFNRequestMethod;

typedef enum {
    DJXAFNRequestSerializerTypeHTTP = 0,
    DJXAFNRequestSerializerTypeJSON,
}DJXAFNRequestSerializerType;

typedef enum {
    kAFNApiLimitFreeTag = 12,
}DJXAFNApiTag;

typedef enum {
    kAFNRequestTypeInit =0,
    kAFNRequestTypeRefresh,
    kAFNRequestTypeLoadMore,
}DJXAFNRequestType;

@class DJXAFNRequestObj;

@protocol DJXAFNRequestDelegate <NSObject>

@optional

-(void)requestFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg;
-(void)requestCancel:(int)tag;
-(void)responseSuccess:(NSMutableArray *)arrData tag:(int)tag;
-(void)responseSuccessObj:(id)responseObj tag:(int)tag;
-(void)responseSuccess:(id)request;
-(void)requestSuccess:(id)request;
-(void)requestFailed:(DJXAFNRequestObj *)request;
-(void)setProgress:(float)newProgress;
-(void)clearRequest;

@end

typedef void (^requestCompletionBlock)(id object);

@interface DJXAFNRequestManager : NSObject<DJXAFNRequestDelegate>

+ (DJXAFNRequestManager *)sharedInstance;

- (void)addRequest:(DJXAFNRequestObj *)request;
- (void)cancelRequest:(DJXAFNRequestObj *)request;

- (void)addOperation:(DJXAFNRequestObj *)request;
- (void)removeOperation:(AFHTTPRequestOperation *)operation;
- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation;
#pragma mark 取消某一请求   netObj:HttpRequestObj

#pragma mark 取消界面发起的所有 request  ui:当前界面对象
-(void)cancelRequestByViewController:(id)vc;

#pragma mark 根据apiTag获取请求对象（HttpRequestObj）  nTag：apitag re:HttpRequestObj

//-(id)getRequestManagerByApiTag:(EnumApiTag)nTag;

// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(DJXAFNRequestObj *request))success
                                    failure:(void (^)(DJXAFNRequestObj *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(DJXAFNRequestObj *request))success
                              failure:(void (^)(DJXAFNRequestObj *request))failure;

#pragma mark 所有请求
- (void)requestWithDelegate:(id)delegate action:(SEL)selector url:(NSString *)urlString pageCount:(NSInteger)page;
- (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
- (void)requestWithTarget:(id)target action:(SEL)action url:(NSString *)url param:(NSDictionary *)param tag:(DJXAFNApiTag)tag;

@end

