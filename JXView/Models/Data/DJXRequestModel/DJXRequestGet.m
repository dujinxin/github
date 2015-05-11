//
//  DJXRequestGet.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXRequestGet.h"

@implementation DJXRequestGet


//变量名称与key值不一致，为了防止程序崩溃，需要在数据模型中，重写setValue: forUndefinedKey:方法
//key:为与属性名称不一致的key值
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"undefinedKey:%@",key);
    
}
@end

@implementation ApplicationObj


-(NSInteger)cacheTimeInSeconds{
    return 60;
}
-(BOOL)useCache{
    return YES;
}
- (BOOL)requestFailed:(id)responseData
{
    if(![super requestFailed:responseData]){
        return NO;
    }
    NSLog(@"request fail");
    [self.delegate responseFailed:self.tag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[DJXRequestManager sharedInstance] cancelRequest:self];
    return YES;
}

-(BOOL)requestSuccess:(id)responseData{
    if(![super requestSuccess:responseData]){
        return NO;
    }
    id result = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:nil];
    //返回结果是以Dictionary存在
    NSMutableArray * downArray = [NSMutableArray array];
    self.objArray = [NSMutableArray array ];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        NSMutableArray * apps = [dict objectForKey:@"applications"];
        if([apps count] == 0){
            if ([dict valueForKey:@"total"]==0) {
                [self.delegate responseFailed:self.tag withStatus:@"999" withMessage:@"数据为空。"];
                [[DJXRequestManager sharedInstance]cancelRequest:self];
                return YES;
            }
        }
        
        for (NSDictionary *dataDic in apps) {
            DJXRequestGet* model = [[DJXRequestGet alloc] init];
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
        [self.delegate responseSuccess:downArray tag:kApiLimitFreeTag];
    }
    //block
    if (self.success) {
        self.success(downArray);
    }
    //target-action
    if ([self.delegate respondsToSelector:self.action] && self.action){
        self.objArray = [NSMutableArray arrayWithArray:downArray];
        SuppressPerformSelectorLeakWarning(
            [self.delegate performSelector:self.action withObject:self];
        );
    }
    [[DJXRequestManager sharedInstance]cancelRequest:self];
    return YES;
}

@end
