//
//  UserInfo.h
//  JXView
//
//  Created by dujinxin on 15-4-30.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * intro;
@property (nonatomic, copy) NSString * login_user_name;
@property (nonatomic, copy) NSString * member_id;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * photo_url;
@property (nonatomic, copy) NSString * session_id;
@property (nonatomic, copy) NSString * true_name;
@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * user_name;
/*
 {
 email = "";
 gender = 1;
 intro = "";
 "login_user_name" = 13121273646;
 "member_id" = "1-2402081";
 mobile = 13121273646;
 "photo_url" = "http://image.yonghui.cn:8081/upload/ori/20/36/e4e0fbb739c53745f814e0c3688c1eca.jpg";
 "session_id" = "b3726535-2835-4b37-a0cc-9fc75a693291";
 "true_name" = 13121273646;
 "user_id" = 4;
 "user_name" = "\U675c";
 }
 */
+(UserInfo *)shareManager;
-(BOOL)isHadLogin;
-(void)login;
-(void)logOut;
-(void)saveUserInfo:(NSDictionary *)userInfo;
-(void)removeUserInfo:(NSString *)key;
-(NSDictionary *)getUserInfo:(NSString *)key;
@end
