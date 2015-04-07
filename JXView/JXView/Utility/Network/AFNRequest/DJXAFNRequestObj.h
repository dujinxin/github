//
//  DJXAFRequestObj.h
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXAFNRequestManager.h"
#import "AFNetworking.h"

#pragma mark --------------------------界面对象接口

//typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
//typedef void (^AFDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);


@protocol DJXRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@class DJXAFNRequestObj;
@protocol DJXAFNRequestDelegate <NSObject>

@optional

-(void)requestFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg;
-(void)requestCancel:(int)tag;
-(void)responseSuccess:(NSMutableArray *)arrData tag:(int)tag;
//-(void)responseSuccessObj:(id)responseObj tag:(int)tag;
-(void)responseSuccess:(id)request;
-(BOOL)requestSuccess:(id)request;
-(BOOL)requestFailed:(DJXAFNRequestObj *)request;
-(void)setProgress:(float)newProgress;
-(void)clearRequest;

@end

typedef void (^requestCompletionBlock)(id object);

@interface DJXAFNRequestObj : NSObject<DJXAFNRequestDelegate>
//Tag
@property (nonatomic,assign) NSInteger tag;
//请求url
@property (nonatomic, copy) NSString * baseUrl;
//
@property (nonatomic, copy) NSString * requestUrl;
//请求参数
@property (nonatomic, strong) NSMutableDictionary *paramDict;
//需要登录时，用户的信息
@property (nonatomic, strong) NSDictionary *userInfo;
//请求类型
@property (nonatomic, assign) DJXAFNRequestMethod requestMethod;
//请求的SerializerType
@property (nonatomic, assign) DJXAFNRequestSerializerType requestSerializerType;
//请求队列
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;
//请求代理
@property (nonatomic, assign) id<DJXAFNRequestDelegate> delegate;
@property (nonatomic, assign) SEL action;
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
- (instancetype)initWithDelegate:(id)vc nApiTag:(NSInteger)tag;
- (instancetype)initWithTarget:(id)vc action:(SEL)selector nApiTag:(NSInteger)tag;
- (instancetype)initWithSuccessBlock:(id)vc success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(NSInteger)tag;

- (BOOL)requestSuccess:(id)responseData;
- (BOOL)requestFailed:(id)responseData;
// append self to request queue
- (void)startAsynchronous;
// remove self from request queue
- (void)stopAsynchronous;

- (BOOL)isExecuting;

// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(DJXAFNRequestObj *request))success
                                    failure:(void (^)(DJXAFNRequestObj *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(DJXAFNRequestObj *request))success
                              failure:(void (^)(DJXAFNRequestObj *request))failure;

// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

// Request Accessory，可以hook Request的start和stop
//- (void)addAccessory:(id<YTKRequestAccessory>)accessory;

/// 以下方法由子类继承来覆盖默认值

// 请求成功的回调
- (void)requestCompleteFilter;
// 请求失败的回调
- (void)requestFailedFilter;
//// 请求的URL
//- (NSString *)requestUrl;

// 请求的CdnURL
- (NSString *)cdnUrl;

// 请求的BaseURL
- (NSString *)baseUrl;

// 请求的参数列表
- (id)requestArgument;

// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

// Http请求的方法
- (DJXAFNRequestMethod)requestMethod;

// 请求的SerializerType
- (DJXAFNRequestSerializerType)requestSerializerType;

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

- (void)requestWithMentod:(DJXAFNRequestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target action:(SEL)action success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
@end
