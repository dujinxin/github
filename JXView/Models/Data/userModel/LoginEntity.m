//
//  LoginEntity.m
//  JXView
//
//  Created by dujinxin on 15-4-30.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "LoginEntity.h"

@implementation LoginEntity

@end

@implementation LoginObj

-(NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@?session_id=2a94cad6-4e26-4b4d-8eaa-57bf3e202b0c&region_id=1001",@"http://newtest.app.yonghui.cn:8081/",@"v3/user/login"];
}
-(DJXRequestMethod)requestMethod{
    return kRequestMethodPost;
}
- (NSInteger)cacheTimeInSeconds {
    return 60 * 1;
}
-(NSSet *)acceptableContentTypes{
    return [NSSet setWithObject:@"text/html"];
}

-(BOOL)isUseFormat{
    return YES;
}
-(void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    if (isSuccess) {
        /* 将数据传给界面 */
        //代理方法
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccess:tag:)]) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                [[UserInfo shareManager] saveUserInfo:dict];
            }
            [self.delegate responseSuccess:object tag:kApiUserLoginTag];
        }
    }else{
        /* 将数据传给界面 */
        //代理方法
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseFailed:withStatus:withMessage:)]) {
            //[self.delegate responseFailed:self.tag withMessage:message];
            [self.delegate responseFailed:self.tag withStatus:nil withMessage:message];
        }
    }
}


@end