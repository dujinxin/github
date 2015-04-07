//
//  HttpRequestObj.h
//  JXView
//
//  Created by dujinxin on 14-11-2.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
//#import "JSONKit.h"
#pragma mark --------------------------界面对象接口
@protocol HttpRequestDelegate <NSObject>

@optional
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg;
-(void)requestCancel:(int)nTag;
-(void)responseSuccess:(NSMutableArray *)arrData nTag:(int)nTag;
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag;
-(void)setProgress:(float)newProgress;

@end

#pragma mark --------------------------网络通信对象-与指令相对应
@interface HttpRequestObj : NSObject{
    
    id<HttpRequestDelegate> viewController;//界面对象
    ASIFormDataRequest      * postRequest;
    ASIHTTPRequest          * getRequest;
    int                       nApiTag;
}

@property (nonatomic, assign,readwrite)int nApiTag;
@property (nonatomic, retain,readwrite)id<HttpRequestDelegate> viewController;
@property (nonatomic, retain,readwrite)ASIFormDataRequest * postRequest;
@property (nonatomic, retain,readwrite)ASIHTTPRequest * getRequest;

-(id)init:(id<HttpRequestDelegate>)vc nApiTag:(int)apiTag;

-(BOOL)requestFailed:(ASIHTTPRequest *)request;

-(BOOL)responseSuccess:(ASIHTTPRequest *)request;

#pragma mark --------------------------检测非法字符串
-(NSString *)testErroStr:(id)text;
#pragma mark --------------------------检测非法数组类型
-(id)testErroArray:(id)text;

@end
