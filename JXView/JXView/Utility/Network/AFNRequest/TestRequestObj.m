//
//  TestRequestObj.m
//  JXView
//
//  Created by dujinxin on 14-11-28.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "TestRequestObj.h"
#import "DJXAFNRequestObj.h"
#import "AppModel.h"
#import "appEntity.h"

@implementation TestRequestObj

static TestRequestObj * _manager = nil;
+(TestRequestObj *)sharedManager{
    if (_manager == nil) {
        _manager = [[TestRequestObj alloc]init ];
    }
    return _manager;
}

- (void)request:(id)target url:(NSString *)urlString pageCount:(NSInteger)page
{
    DJXAFNRequestObj * request = NULL;
    request = [[AppModelRequest2 alloc]initWithDelegate:target nApiTag:kAFNApiLimitFreeTag];
    if(!request){
        DJXRelease(request);
        return;
    }
    request.requestUrl = [NSString stringWithFormat:urlString,page];
    [request startAsynchronous];
    DJXRelease(request);
}
@end
