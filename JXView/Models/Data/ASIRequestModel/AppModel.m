//
//  AppModel.m
//  JXView
//
//  Created by dujinxin on 14-11-2.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel


//变量名称与key值不一致，为了防止程序崩溃，需要在数据模型中，重写setValue: forUndefinedKey:方法
//key:为与属性名称不一致的key值
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"undefinedKey:%@",key);

}
@end

@implementation AppModelRequest1

- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request]){
        return NO;
    }
    NSLog(@"request fail");
    
    if([request isCancelled]){
        NSLog(@"request cancel");
    }
    [self.viewController requestFailed:self.nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[RequestManager getInstance]cancelRequest:self];
    return YES;
}

-(BOOL) responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request]){
        return NO;
    }
    NSData * myResponseData = [request responseData];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
	NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    
    //    NSLog(@"jsonre fren %@",myResponseStr);
    
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSArray* datas = [jsonDic objectForKey:@"applications"];
    if([datas count] == 0){
        if ([jsonDic valueForKey:@"total"]==0) {
            [viewController requestFailed:self.nApiTag withStatus:@"999" withMessage:@"数据为空。"];
            [[RequestManager getInstance]cancelRequest:self];
            return YES;
        }
    }
    NSMutableArray * downArray = [NSMutableArray array];
//    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
//    if([status isEqualToString:WEB_STATUS_1] ){
    
        for (NSDictionary *dataDic in datas) {
            AppModel* model = [[AppModel alloc] init];
            
            model.name = [dataDic valueForKey:@"name"];
            model.iconUrl = [dataDic valueForKey:@"iconUrl"];
            model.applicationId = [dataDic valueForKey:@"applicationId"];
            NSLog(@"name:%@",model.name);
            [downArray addObject:model];
            DJXRelease(model);
        }
    /* 将数据传给界面 */
    if ([self.viewController respondsToSelector:@selector(responseSuccess:nTag:)])
    {
        [self.viewController responseSuccess:downArray nTag:self.nApiTag];
    }
    
    [[RequestManager getInstance]cancelRequest:self];
    return YES;
}


@end

