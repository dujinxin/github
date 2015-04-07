//
//  DJXShareManager.h
//  JXView
//
//  Created by dujinxin on 14-11-26.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

typedef void (^shareCallBackBlock) (id obj);

@interface DJXShareManager : NSObject

@property (nonatomic,copy)shareCallBackBlock block;

+ (void)showCustomShareListViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block VController:(UIViewController *)VController  shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
@end
