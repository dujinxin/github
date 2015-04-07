//
//  RequestManager.m
//  JXView
//
//  Created by dujinxin on 14-11-2.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "RequestManager.h"
#import "Reachability.h"
#import "ASIDownloadCache.h"
#import "HttpRequestObj.h"


#import "AppModel.h"

static RequestManager * manager = nil;

@implementation RequestManager

@synthesize arrRequst = _arrRequst, arrTongJiKey = _arrTongJiKey;

+ (RequestManager *) getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestManager alloc] init];
        [manager initData];
    });
    return manager;
}

- (void)dealloc
{
    DJXSafeRelease(_arrRequst);
    DJXSuperDealloc;
}

- (void)initData
{
    self.arrRequst = [NSMutableArray array];
}

- (ASIHTTPRequest *)get:(NSString *)strUrl
{
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    if (networkStatus == NotReachable) {
//        [[iToast makeText:@"网络不给力，请稍后重试！"]show];
        return NULL;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.timeOutSeconds = 30;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(responseSuccess:)];
    [request setRequestMethod:@"GET"];
    [request setUseCookiePersistence:YES];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    return request;
}

- (ASIFormDataRequest *)post:(NSString*)strUrl
{
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    if (networkStatus == NotReachable) {
//        [[iToast makeText:@"网络不可用，请检查网络设置！"]show];
        return NULL;
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.timeOutSeconds = 30;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(responseSuccess:)];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIURLEncodedPostFormat];
    [request setUseCookiePersistence:YES];
    
    return request;
}

- (id)getRequestManagerByApiTag:(EnumApiTag)nTag;
{
    for(int n = 0; n < [_arrRequst count]; n++)
    {
        HttpRequestObj * obj = [_arrRequst objectAtIndex:n];
        if(obj.nApiTag == nTag)
        {
            return obj;
        }
    }
    return NULL;
}

- (void)cancelRequestByViewController:(id)vc
{
    for(int i = 0; i < [_arrRequst count];i++)
    {
        HttpRequestObj * obj = [_arrRequst objectAtIndex:i];
        if(obj.viewController == vc)
        {
            [self cancelRequest:obj];
        }
    }
}

- (void)cancelRequest:(HttpRequestObj *)netObj
{
    if(netObj.postRequest != NULL){
        netObj.postRequest.delegate = nil;
        [netObj.postRequest cancel];
        [_arrRequst removeObject:netObj];
    }
    else if(netObj.getRequest != NULL){
        netObj.getRequest.delegate = nil;
        [netObj.getRequest cancel];
        [_arrRequst removeObject:netObj];
    }
}

#pragma mark 根据apiTag获取请求对象（HttpRequestObj）nTag:apiTag re:HttpRequestObj
#pragma mark -/*用户部分*/
- (void)request:(id)delegate url:(NSString *)urlString pageCount:(NSInteger)page
{
   
    HttpRequestObj * request = NULL;
    request = [[AppModelRequest1 alloc]init:delegate nApiTag:t_Api_limitFree_tag];
    
    NSString* strurl= [NSString stringWithFormat:urlString,page];
    request.getRequest = [self get:strurl];
    if(request.getRequest == NULL){
        DJXRelease(request);
        return;
    }
    request.getRequest.delegate = request;
    [_arrRequst addObject:request];
    [request.getRequest startAsynchronous];
    DJXRelease(request);
}
- (void)request1:(id)delegate url:(NSString *)urlString appId:(NSString *)appId pageCount:(NSInteger)page
{
    
    HttpRequestObj * request = NULL;
    request = [[AppModelRequest1 alloc]init:delegate nApiTag:t_Api_limitFree_tag];
    
    NSString* strurl= [NSString stringWithFormat:@"%@",urlString];
    request.postRequest = [self post:strurl];
    if(request.postRequest == NULL){
        DJXRelease(request);
        return;
    }
    request.postRequest.delegate = request;
    [request.postRequest setPostValue:appId forKey:@"agent_id"];
    [_arrRequst addObject:request];
    [request.postRequest startAsynchronous];
    DJXRelease(request);
}
@end
