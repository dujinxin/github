//
//  RequestManager.h
//  JXView
//
//  Created by dujinxin on 14-11-2.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef enum {
    t_Api_limitFree_tag = 0,
}EnumApiTag;

typedef enum {
    request_type_initData =0,
    request_type_refreshData,
    request_type_loadMoreData,
}RequestType;

@interface RequestManager : NSObject
{
    NSMutableArray* arrRequst; //value:HttpRequestObj
    NSMutableArray* arrTongJiKey;
    RequestType * requestType;
}

@property (nonatomic, retain) NSMutableArray* arrRequst;
@property (nonatomic, retain) NSMutableArray* arrTongJiKey;
@property (nonatomic, assign) RequestType requestType;

+ (RequestManager *)getInstance;
- (ASIHTTPRequest *)get:(NSString *)strUrl;
- (ASIFormDataRequest *)post:(NSString*)strUrl;

#pragma mark 取消某一请求   netObj:HttpRequestObj
-(void)cancelRequest:(id)netObj;

#pragma mark 取消界面发起的所有 request  ui:当前界面对象
-(void)cancelRequestByViewController:(id)vc;

#pragma mark 根据apiTag获取请求对象（HttpRequestObj）  nTag：apitag re:HttpRequestObj

-(id)getRequestManagerByApiTag:(EnumApiTag)nTag;


#pragma mark 
#pragma mark 所有请求
- (void)request:(id)delegate url:(NSString *)urlString pageCount:(NSInteger)page;

@end
