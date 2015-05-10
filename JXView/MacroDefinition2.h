//
//  Header1.h
//  JXView
//
//  Created by dujinxin on 14-11-2.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#ifndef JXView_Header1_h
#define JXView_Header1_h


/* 网络返回状态 */
#define WEB_STATUS_0        @"0"
#define WEB_STATUS_1        @"1"
#define WEB_STATUS_2        @"2"
#define WEB_STATUS_3        @"3"


#ifdef  kProduction /* 生产环境 */
#define kBaseUrl            @"http://app.yonghui.cn:8081/"

#define kAppId              @"q18AEnLYfpAyuH9fhIQr73"
#define kAppKey             @"U9MPBdOeOe98FnIB5joQ16"
#define kAppSecret          @"j3KrrYcihE9lBfQyJIqJY5"

#else               /* 测试环境 */
#define kBaseUrl            @"http://newtest.app.yonghui.cn:8081/" //永辉
//#define kBaseUrl            @"http://app.cloud360.com.cn/"      //e-future

#define kAppId              @"fkHg2NGHo66HbLmAVzrlWA"
#define kAppKey             @"TkANjN9MwI76ehMVHax896"
#define kAppSecret          @"3NRsdfnZ2w76lFM8ptBit3"

#endif

#define kTestUrl            @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=1"

#define kCacheFolderPath          [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"LazyRequestCache"]

#endif
