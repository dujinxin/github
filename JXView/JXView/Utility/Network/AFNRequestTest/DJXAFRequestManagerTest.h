//
//  DJXAFRequestManager.h
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@class DJXAFRequestObjTest;
@interface DJXAFRequestManagerTest : NSObject
{
    NSMutableArray* arrRequst; //value:HttpRequestObj
    NSMutableArray* arrTongJiKey;
//    RequestType * requestType;
}

//@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) NSMutableDictionary * paramDict;
@property (nonatomic, strong) NSMutableDictionary * requestDictionary;
//@property (nonatomic, strong) DJXAFRequestObj * request;

+ (DJXAFRequestManagerTest *)sharedInstance;

- (void)addRequest:(DJXAFRequestObjTest *)request;
- (void)cancelRequest:(DJXAFRequestObjTest *)request;
- (void)addOperation:(DJXAFRequestObjTest *)request;
- (void)removeOperation:(AFHTTPRequestOperation *)operation;
- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation;
#pragma mark 取消某一请求   netObj:HttpRequestObj

#pragma mark 取消界面发起的所有 request  ui:当前界面对象
-(void)cancelRequestByViewController:(id)vc;

#pragma mark 根据apiTag获取请求对象（HttpRequestObj）  nTag：apitag re:HttpRequestObj

//-(id)getRequestManagerByApiTag:(EnumApiTag)nTag;

#pragma mark

#pragma mark 所有请求
- (void)request:(id)delegate action:(SEL)selector url:(NSString *)urlString pageCount:(NSInteger)page;

@end

