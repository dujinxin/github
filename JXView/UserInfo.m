//
//  UserInfo.m
//  JXView
//
//  Created by dujinxin on 15-4-30.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "UserInfo.h"
#import "DJXLoginViewController.h"

@interface UserInfo (){
    @private
        NSString   * _userInfo_path;
}

@end

@implementation UserInfo

static UserInfo * manager = nil;
+(UserInfo *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserInfo alloc]init ];
    });
    return manager;
}
-(instancetype)init{
    if (self = [super init]) {
        [manager initializeFile];
        [manager initializeData];
    }
    return self;
}
-(void)initializeFile{
    NSString* documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    _userInfo_path= [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:@"userInfo.txt"]];
//    _timePath= [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:@"time.txt"]];
//    _avatarPath= [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:@"avatar.txt"]];
}
-(void)initializeData{
    [manager setValuesForKeysWithDictionary:[manager getUserInfo:_userInfo_path]];
}
-(BOOL)isHadLogin{
    BOOL isLogined = YES;
    if (self.session_id && self.mobile) {
        
    }else{
        isLogined = NO;
    }
    return isLogined;
}
-(void)login{
    DJXLoginViewController * login = [[DJXLoginViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:login animated:YES completion:^{
        //
    }];
}
-(void)logOut{

    NSArray * keyArray = [self getUserInfo:@"userInfo"].allKeys;
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    for (NSString * key in keyArray) {
        [userInfo setObject:@"" forKey:key];
    }
    if (userInfo && userInfo.count !=0) {
        [self setValuesForKeysWithDictionary:userInfo];
        NSLog(@"退出登陆！")
        [self removeUserInfo:_userInfo_path];
    }
    
}
-(void)saveUserInfo:(NSDictionary *)userInfo{
    if (userInfo) {
        [manager setValuesForKeysWithDictionary:userInfo];
        [userInfo writeToFile:_userInfo_path atomically:YES];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_userInfo_path]) {
            NSLog(@"save userInfo success!");
        }
    }
}
-(void)removeUserInfo:(NSString *)key{
    if ([[NSFileManager defaultManager] fileExistsAtPath:key]) {
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:key error:&error];
        if (error) {
            NSLog(@"clear userInfo error :%@",error.localizedDescription);
        }else{
            NSLog(@"clear userInfo success!");
        }
    }
}
-(NSDictionary *)getUserInfo:(NSString *)key{
    NSDictionary * userInfo;
    if ([[NSFileManager defaultManager] fileExistsAtPath:_userInfo_path]) {
        userInfo = [NSDictionary dictionaryWithContentsOfFile:_userInfo_path];
    }else{
        NSLog(@"userInfo is not existed!")
    }
    return userInfo;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"userInfo has undefined value for key: %@",key);
}
@end
