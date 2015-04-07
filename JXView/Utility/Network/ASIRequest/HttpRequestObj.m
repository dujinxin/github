//
//  HttpRequestObj.m
//  JXView
//
//  Created by dujinxin on 14-11-2.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "HttpRequestObj.h"

#import "JSONKit.h"
#import "CHKeychain.h"
#import "ASIHTTPRequest.h"

@implementation HttpRequestObj

@synthesize viewController = _viewController;
@synthesize postRequest =_postRequest;
@synthesize nApiTag =_nApiTag;
@synthesize getRequest =_getRequest;

-(void)dealloc
{
    DJXSafeRelease(_postRequest);
    DJXSafeRelease(_getRequest);
    DJXSafeRelease(_viewController);
    DJXSuperDealloc;
}

-(id)init:(id<HttpRequestDelegate>)vc nApiTag:(int)apiTag
{
    self.viewController = vc;
    self.nApiTag = apiTag;
    self.postRequest = NULL;
    self.getRequest = NULL;
    return self;
}

-(id)testErroArray:(id)text
{
    if(text == [NSNull null]){
        return nil;
    }
    if(![text isKindOfClass:[NSArray class]]){
        return nil;
    }
    
    return text;
}
-(NSString*)testErroStr:(id)text
{
    if([text isKindOfClass:[NSArray class]]){
        return @"";
    }
    if(text == nil)
        return @"";
    if(![text isKindOfClass:[NSString class]]){
        return text;
    }
    
    if(text == [NSNull null]){
        return @"";
    }
    
    if([text isEqualToString:@"<null>"]){
        return @"";
    }
    return text;
}

- (BOOL)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"faild----\n%@\n%@", request.url.description,[[[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding] autorelease]);
    
    NSLog(@"faild----:%ld, %d", (long)request.error.code, ASIConnectionFailureErrorType);
    if(request.error.code == ASIRequestTimedOutErrorType)
    {
//        [[iToast makeText:@"联网连接超时，请重试！"]show];
        
        return TRUE;
    }
    return TRUE;
}

-(BOOL) responseSuccess:(ASIHTTPRequest *)request{
    
    if([request didUseCachedResponse]){
        NSLog(@"=========资源请求：%@ 来自缓存============",[request url]);
        
    }else{
        NSLog(@"=========资源请求：%@ 不来自缓存============",[request url]);
    }
    NSLog(@"postValue:%@", [[[NSString alloc] initWithData:request.postBody encoding:    NSUTF8StringEncoding] autorelease]);
    
    NSData * myResponseData = [request responseData];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
	NSString * myResponseStr = [[[NSString alloc] initWithData:myResponseData encoding:enc] autorelease];
    NSLog(@"jsonre %@",myResponseStr);
    
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    if (jsonDic == nil) {
//        [[iToast makeText:@"网络异常!"] show];
        NSLog(@"jsonre %@",myResponseStr);
        [[RequestManager getInstance]cancelRequest:self];
        return NO;
    }
    NSLog(@"myResponseStr %@",myResponseStr);

//    NSNumber *status = [jsonDic objectForKey:@"status"];
//    if ([[status stringValue] isEqualToString:WEB_STATUS_1])
//    {
//        [_uinet responseSuccessObj:jsonDic nTag:_nApiTag];
//    }
    NSLog(@"json:%@", jsonDic);
    return YES;
}



@end

