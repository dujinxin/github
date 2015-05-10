//
//  appEntity.m
//  JXView
//
//  Created by dujinxin on 14-12-1.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "appEntity.h"

@implementation appEntity

//- (void)dealloc{
//    [_applicationId release];
//    [_categoryId release];
//    [_categoryName release];
//    [_currentPrice release];
//    [__description release];
//    [_downloads release];
//    [_expireDatetime release];
//    [_favorites release];
//    [_fileSize release];
//    [_iconUrl release];
//    [_ipa release];
//    [_itunesUrl release];
//    [_lastPrice release];
//    [_name release];
//    [_priceTrend release];
//    [_ratingOverall release];
//    [_releaseDate release];
//    [_releaseNotes release];
//    [_shares release];
//    [_slug release];
//    [_starCurrent release];
//    [_starOverall release];
//    [_updateDate release];
//    [_version release];
//    [super dealloc];
//}

//变量名称与key值不一致，为了防止程序崩溃，需要在数据模型中，重写setValue: forUndefinedKey:方法
//key:为与属性名称不一致的key值
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"undefinedKey:%@",key);
    
}
@end

@implementation AppModelRequest2

- (BOOL)requestFailed:(id)responseData
{
    if(![super requestFailed:responseData]){
        return NO;
    }
    NSLog(@"request fail");
    
    //    if([request stopAsynchronous]){
    //        NSLog(@"request cancel");
    //    }
    [self.delegate requestFailed:self.tag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[DJXAFNRequestManager sharedInstance] cancelRequest:self];
    return YES;
}

-(BOOL) requestSuccess:(id)responseData{
    if(![super requestSuccess:responseData]){
        return NO;
    }
    id result = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:nil];
    //返回结果是以Dictionary存在
    NSMutableArray * downArray = [NSMutableArray array];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        NSMutableArray * apps = [dict objectForKey:@"applications"];
        if([apps count] == 0){
            if ([dict valueForKey:@"total"]==0) {
               [self.delegate requestFailed:self.tag withStatus:@"999" withMessage:@"数据为空。"];
               [[DJXAFNRequestManager sharedInstance]cancelRequest:self];
               return YES;
            }
        }
        //NSString *status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        //        if([status isEqualToString:WEB_STATUS_1] ){
        
        for (NSDictionary *dataDic in apps) {
            appEntity* model = [[appEntity alloc] init];
            model.name = [dataDic valueForKey:@"name"];
            model.iconUrl = [dataDic valueForKey:@"iconUrl"];
            model.applicationId = [dataDic valueForKey:@"applicationId"];
            
            model.shares = [dataDic objectForKey:@"shares"];
            model.favorites = [dataDic objectForKey:@"favorites"];
            model.downloads = [dataDic objectForKey:@"downloads"];
            NSLog(@"name:%@",model.name);
            [downArray addObject:model];
            DJXRelease(model);
        }

    }
    /* 将数据传给界面 */
    //代理方法
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccess:tag:)]) {
        [self.delegate responseSuccess:downArray tag:kAFNApiLimitFreeTag];
    }
    //block
    if (self.success) {
        self.success(downArray);
    }
    //target-action
    if ([self.delegate respondsToSelector:self.action] && self.action){
        SuppressPerformSelectorLeakWarning(
           [self.delegate performSelector:self.action withObject:downArray];
        );
    }
    [[DJXAFNRequestManager sharedInstance]cancelRequest:self];
    return YES;
}

- (void)globalPostWithUrl:(NSString *)url tag:(NSInteger)tag delegate:(id)target action:(SEL)action success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{

//    self.delegate = target;
//    self.success = block;
//    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //成功
//         [self responseSuccess:operation.responseData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //失败
//        NSLog(@"error:%@",error.localizedDescription);
//    }];
}
//- (void)requestWithMentod:(DJXRequestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target{
//    self.delegate = target;
//    self.success = block;
//    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //成功
//        [self requestSuccess:operation.responseData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //失败
//        NSLog(@"error:%@",error.localizedDescription);
//    }];
//}
@end

@implementation AppModelRequest3

- (BOOL)requestFailed:(id)responseData
{
    if(![super requestFailed:responseData]){
        return NO;
    }
    NSLog(@"request fail");
    
    //    if([request stopAsynchronous]){
    //        NSLog(@"request cancel");
    //    }
    [self.delegate requestFailed:self.tag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[DJXAFRequestManagerTest sharedInstance] cancelRequest:self];
    return YES;
}

-(BOOL) requestSuccess:(id)responseData{
    if(![super requestSuccess:responseData]){
        return NO;
    }
    id result = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:nil];
    //返回结果是以Dictionary存在
    NSMutableArray * downArray = [NSMutableArray array];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        NSMutableArray * apps = [dict objectForKey:@"applications"];
        if([apps count] == 0){
            if ([dict valueForKey:@"total"]==0) {
                [self.delegate requestFailed:self.tag withStatus:@"999" withMessage:@"数据为空。"];
                [[DJXAFRequestManagerTest sharedInstance]cancelRequest:self];
                return YES;
            }
        }
        //NSString *status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        //        if([status isEqualToString:WEB_STATUS_1] ){
        
        for (NSDictionary *dataDic in apps) {
            appEntity* model = [[appEntity alloc] init];
            model.name = [dataDic valueForKey:@"name"];
            model.iconUrl = [dataDic valueForKey:@"iconUrl"];
            model.applicationId = [dataDic valueForKey:@"applicationId"];
            
            model.shares = [dataDic objectForKey:@"shares"];
            model.favorites = [dataDic objectForKey:@"favorites"];
            model.downloads = [dataDic objectForKey:@"downloads"];
            NSLog(@"name:%@",model.name);
            [downArray addObject:model];
            DJXRelease(model);
        }
        
    }
    /* 将数据传给界面 */
    //代理方法
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccess:tag:)]) {
        [self.delegate responseSuccess:downArray tag:kAFNApiLimitFreeTag];
    }
    //block
    if (self.success) {
        self.success(downArray);
    }
    //target-action
    if ([self.delegate respondsToSelector:self.action] && self.action){
        SuppressPerformSelectorLeakWarning(
                                           [self.delegate performSelector:self.action withObject:downArray];
                                           );
    }
    [[DJXAFRequestManagerTest sharedInstance]cancelRequest:self];
    return YES;
}

- (void)globalPostWithUrl:(NSString *)url tag:(NSInteger)tag delegate:(id)target action:(SEL)action success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    
    //    self.delegate = target;
    //    self.success = block;
    //    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        //成功
    //         [self responseSuccess:operation.responseData];
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        //失败
    //        NSLog(@"error:%@",error.localizedDescription);
    //    }];
}
//- (void)requestWithMentod:(DJXRequestMethod)requestMethod WithUrl:(NSString *)url param:(NSDictionary *)param tag:(NSInteger)tag delegate:(id)target{
//    self.delegate = target;
//    self.success = block;
//    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //成功
//        [self requestSuccess:operation.responseData];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //失败
//        NSLog(@"error:%@",error.localizedDescription);
//    }];
//}
@end
