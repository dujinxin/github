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

-(void)afnResponseSuccess:(NSMutableArray *)arrayObj tag:(int)tag;
-(void)afnResponseSuccessObj:(id)responseObj tag:(int)tag;

-(void)afnRequestFailedWithMessage:(NSString*)errMsg;
-(void)afnRequestFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg;
-(void)afnRequestFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg withObj:(id)obj;

-(void)afnRequestSuccess:(id)request;
-(void)afnRequestFailed:(DJXAFNRequestObj *)request;
-(void)afnRequestCancel:(int)tag;

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

-(void)cancelRequestByViewController:(id)vc;


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

