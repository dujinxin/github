//
//  DJXRequestProtocol.h
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@protocol DJXRequestDelegate;

// 下载的协议
@protocol DJXRequestProtocol <NSObject>

- (id) initWithDelegate:(id <DJXRequestDelegate>)target nApiTag:(NSInteger)tag;
+ (id) requestWithDelegate:(id <DJXRequestDelegate>)target;

@property (nonatomic, assign) NSUInteger apiTag;
@property (nonatomic, assign) id <DJXRequestDelegate> delegate;
@property (nonatomic, retain,readwrite)ASIFormDataRequest * asiPostRequest;
@property (nonatomic, retain,readwrite)ASIHTTPRequest * asiGetRequest;


- (void) addPostValue:(id)value forKey:(NSString *)key;
// 开始下载
- (void) startAsync;
- (NSData *) responseData;
@end

// 下载的代理
@protocol DJXRequestDelegate <NSObject>
- (void) requestCompleted:(id <DJXRequestProtocol>)request;
- (void) requestFailed:(id <DJXRequestProtocol>)request withError:(NSError *)error;

@end
