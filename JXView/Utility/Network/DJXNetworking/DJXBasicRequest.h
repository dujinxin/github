//
//  DJXBasicReqest.h
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXRequestManager.h"
#import "AFNetworking.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#pragma mark --------------------------界面对象接口


//typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
//typedef void (^AFDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);


@protocol DJXRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@class DJXBasicRequest;
@protocol DJXRequestDelegate <NSObject>

@optional

-(void)responseSuccess:(id)responseObj tag:(int)tag;
-(void)responseFailed:(int)tag withMessage:(NSString*)errMsg;
-(void)responseFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg;
-(void)responseFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg withObj:(id)object;
-(void)requestCancel:(int)tag;

-(void)setProgress:(float)newProgress;

-(void)clearRequest;

@end

typedef void (^requestCompletionBlock)(id object);

@interface DJXBasicRequest : NSObject<DJXRequestDelegate>


@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

/*
 *请求信息
 */

@property (nonatomic,   copy) NSString             *   className;
//Tag
@property (nonatomic, assign) NSInteger                tag;
//请求url
@property (nonatomic,   copy) NSString             *   baseUrl;
//请求url
@property (nonatomic,   copy) NSString             *   requestUrl;
//请求参数
@property (nonatomic, strong) NSMutableDictionary  *   requestDictionary;
//需要登录时，用户的信息
@property (nonatomic, strong) NSDictionary         *   userInfo;
//请求类型
@property (nonatomic, assign) DJXRequestMethod         requestMethod;
//请求的SerializerType
@property (nonatomic, assign) DJXRequestSerializerType requestSerializerType;
//请求队列
@property (nonatomic, strong) AFHTTPRequestOperation * requestOperation;
//请求代理
@property (nonatomic, assign) id<DJXRequestDelegate>   delegate;
@property (nonatomic, assign) SEL                      action;



/*
 *返回信息
 */

//返回头信息
@property (nonatomic, strong, readonly) NSDictionary * responseHeaders;
//返回的数据
@property (nonatomic, strong, readonly) NSString     * responseString;
@property (nonatomic, strong)           NSData       * responseData;
@property (nonatomic, strong, readonly) id             responseJSONObject;
//返回状态码
@property (nonatomic, assign, readonly) NSInteger      responseStatusCode;
//成功的回调
@property (nonatomic, copy)requestCompletionBlock      success;
//失败的回调
@property (nonatomic, copy)requestCompletionBlock      failure;
@property (nonatomic, strong) NSMutableArray         * requestAccessories;

+ (NSString *)className;
//初始化
- (instancetype)initWithDelegate:(id)vc nApiTag:(DJXApiTag)tag;
- (instancetype)initWithDelegate:(id)vc action:(SEL)selector nApiTag:(DJXApiTag)tag;
- (instancetype)initWithDelegate:(id)vc success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(DJXApiTag)tag;

- (BOOL)requestSuccess:(id)responseData;
- (BOOL)requestFailed:(id)responseData;
// append self to request queue
- (void)startAsynchronous;
// remove self from request queue
- (void)stopAsynchronous;

- (BOOL)isExecuting;

// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(DJXBasicRequest *request))success
                                    failure:(void (^)(DJXBasicRequest *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(DJXBasicRequest *request))success
                              failure:(void (^)(DJXBasicRequest *request))failure;

// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

// Request Accessory，可以hook Request的start和stop
//- (void)addAccessory:(id<YTKRequestAccessory>)accessory;

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
//返回数据格式
- (NSSet *)acceptableContentTypes;
// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

// Http请求的方法
- (DJXRequestMethod)requestMethod;

// 请求的SerializerType
- (DJXRequestSerializerType)requestSerializerType;

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

@end
