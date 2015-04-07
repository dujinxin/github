//
//  DJXAFRequestObj.h
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXAFRequestManagerTest.h"
#import "AFNetworking.h"

#pragma mark --------------------------界面对象接口

typedef enum{
    kRequestTestMethodGet = 0,
    kRequestTestMethodPost,
    kRequestTestMethodHead,
    kRequestTestMethodPut,
    kRequestTestMethodDelete,
}DJXRequestTestMethod;

typedef enum {
    DJXRequestTestSerializerTypeHTTP = 0,
    DJXRequestTestSerializerTypeJSON,
}DJXRequestTestSerializerType;

typedef enum {
    kTestApiLimitFreeTag = 12,
}DJXApiTestTag;

typedef enum {
    kRequestTestTypeInit =0,
    kRequestTestTypeRefresh,
    kRequestTestTypeLoadMore,
}DJXRequestTestType;

//typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
//typedef void (^AFDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);


@protocol DJXRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@class DJXAFRequestObjTest;
@protocol DJXAFRequestTestDelegate <NSObject>

@optional

-(void)requestFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg;
-(void)requestCancel:(int)tag;
-(void)responseSuccess:(NSMutableArray *)arrData tag:(int)tag;
-(void)responseSuccessObj:(id)responseObj tag:(int)tag;
-(void)responseSuccess:(id)request;
-(void)requestFailed:(DJXAFRequestObjTest *)request;
-(void)setProgress:(float)newProgress;
-(void)clearRequest;

@end

typedef void (^requestCompletionBlock)(id object);

@interface DJXAFRequestObjTest : NSObject<DJXAFRequestTestDelegate>
//Tag
@property (nonatomic,assign) NSInteger tag;
//请求url
@property (nonatomic, copy) NSString * baseUrl;
//请求参数
@property (nonatomic, strong) NSMutableDictionary *paramDict;
//需要登录时，用户的信息
@property (nonatomic, strong) NSDictionary *userInfo;
//请求类型
@property (nonatomic, assign) DJXRequestTestMethod requestMethod;
//请求的SerializerType
@property (nonatomic, assign) DJXRequestTestSerializerType requestSerializerType;
//请求队列
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;
//请求代理
@property (nonatomic, assign) id<DJXAFRequestTestDelegate> delegate;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
//@property (nonatomic, strong) NSMutableDictionary *requestDictionary;
//返回头信息
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
//返回的数据
@property (nonatomic, strong, readonly) NSString *responseString;
@property (nonatomic, strong) NSData * responseData;
@property (nonatomic, strong, readonly) id responseJSONObject;
//返回状态码
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;
//成功的回调
@property (nonatomic, copy)requestCompletionBlock success;
//void (^successCompletionBlock)(DJXAFRequestObj *);
//失败的回调
@property (nonatomic, copy)requestCompletionBlock failure;
//void (^failureCompletionBlock)(DJXAFRequestObj *);
@property (nonatomic, strong) NSMutableArray *requestAccessories;


//初始化
- (id)initWithDelegate:(id)vc action:(SEL)selector nApiTag:(NSInteger)tag;
+ (id)requestWithDelegate:(id<DJXAFRequestTestDelegate>)vc;
- (BOOL)requestSuccess:(id)responseData;
- (BOOL)requestFailed:(id)responseData;
// append self to request queue
- (void)startAsynchronous;
// remove self from request queue
- (void)stopAsynchronous;

- (BOOL)isExecuting;

// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(DJXAFRequestObjTest *request))success
                                    failure:(void (^)(DJXAFRequestObjTest *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(DJXAFRequestObjTest *request))success
                              failure:(void (^)(DJXAFRequestObjTest *request))failure;

// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

// Request Accessory，可以hook Request的start和stop
//- (void)addAccessory:(id<YTkRequestTestAccessory>)accessory;

/// 以下方法由子类继承来覆盖默认值

// 请求成功的回调
- (void)requestCompleteFilter;
// 请求失败的回调
- (void)requestFailedFilter;
// 请求的URL
- (NSString *)requestUrl;

// 请求的CdnURL
- (NSString *)cdnUrl;

// 请求的BaseURL
- (NSString *)baseUrl;

// 请求的参数列表
- (id)requestArgument;

// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

// Http请求的方法
//- (YTkRequestTestMethod)requestMethod;

// 请求的SerializerType
//- (YTkRequestTestSerializerType)requestSerializerType;

// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray;

// 构建自定义的UrlRequest，
// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest;

// 是否使用CDN的host地址
- (BOOL)useCDN;

// 用于检查JSON是否合法的对象
- (id)jsonValidator;

// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;

// 当POST的内容带有文件等富文本时使用
//- (AFConstructingBlock)constructingBodyBlock;

// 当需要断点续传时，指定续传的地址
- (NSString *)resumableDownloadPath;

// 当需要断点续传时，获得下载进度的回调
//- (AFDownloadProgressBlock)resumableDownloadProgressBlock;

//target-action
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target action:(SEL)action;
//代理
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target;
//block
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
//
- (void)requestWithMentod:(DJXRequestTestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target action:(SEL)action success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
@end
