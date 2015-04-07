//
//  DJXShareManager.m
//  JXView
//
//  Created by dujinxin on 14-11-26.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXShareManager.h"
#import "DJXAppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"

@implementation DJXShareManager

//分享，装有客户端则调用客户端分享（新浪微博，微信，朋友圈），没有安装则点默认界面分享（新浪）
/*
 shareCallBackBlock - 分享成功的回调方法
 */
+ (void)showCustomShareListViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block VController:(UIViewController *)VController shareType:(ShareType)shareType, ... {
    DJXAppDelegate *appDelegate = (DJXAppDelegate *)[UIApplication sharedApplication].delegate;
    DJXShareManager * manager = [[DJXShareManager alloc]init ];
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    //定义点击事件
//    id clickHandler = ^{
//        AGCustomShareViewController *vc = [[[AGCustomShareViewController alloc] initWithImage:shareImage content:CONTENT] autorelease];
//        UINavigationController *naVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
//
//        if ([UIDevice currentDevice].isPad)
//        {
//            naVC.modalPresentationStyle = UIModalPresentationFormSheet;
//        }
//
//        [self presentModalViewController:naVC animated:YES];
//    };
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    //定义菜单分享列表
    /*新浪*/
    id<ISSShareActionSheetItem> sinaItem =
       [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                          icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                  clickHandler:^{
          //调用微博客户端来发微博
          if([WeiboSDK isWeiboAppInstalled]){
              [ShareSDK clientShareContent:publishContent
                                      type:ShareTypeSinaWeibo
                             statusBarTips:YES
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                  if(state == SSPublishContentStateSuccess){                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                      if (block) {
                          manager.block = [block copy];
                          manager.block(statusInfo);
                      }
                  }else if (state == SSPublishContentStateFail){                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                  }
                                                                                                    }];
         //没有安装客户端则调用默认界面来分享
         }else{
              [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                                    container:container
                                      content:publishContent
                                statusBarTips:YES
                                  authOptions:authOptions
                                 shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                   qqButtonHidden:NO
            wxSessionButtonHidden:NO
           wxTimelineButtonHidden:NO
             showKeyboardOnAppear:NO
                shareViewDelegate:appDelegate.viewDelegate
              friendsViewDelegate:appDelegate.viewDelegate
            picViewerViewDelegate:nil]
                           result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                 if (state == SSPublishContentStateSuccess){
                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                     if (block) {
                         manager.block = [block copy];
                         manager.block(statusInfo);
                     }
                 }else if (state == SSPublishContentStateFail){
                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                 }
                                         }];
                                                                              
         }
     }];
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
        //微信
        [ShareSDK shareActionSheetItemWithTitle:
            [ShareSDK getClientNameWithType:ShareTypeWeixiSession]
                                       icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession]
                               clickHandler:
           //点击事件
           ^{
                [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                                      container:nil
                                        content:publishContent
                                  statusBarTips:YES
                                    authOptions:authOptions
                                   shareOptions:
                   [ShareSDK defaultShareOptionsWithTitle:nil
                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                           qqButtonHidden:NO
                                    wxSessionButtonHidden:NO
                                   wxTimelineButtonHidden:NO
                                     showKeyboardOnAppear:NO
                                        shareViewDelegate:appDelegate.viewDelegate
                                      friendsViewDelegate:appDelegate.viewDelegate
                                    picViewerViewDelegate:nil]
                                         result:
                 //分享结果
                ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                    if (state == SSPublishContentStateSuccess){
                        NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                        if (block) {
                            manager.block = [block copy];
                            manager.block(statusInfo);
                        }
                    }else if (state == SSPublishContentStateFail){
                        NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                    }
                }];
        }],
        //微信朋友圈
        [ShareSDK shareActionSheetItemWithTitle:
           [ShareSDK getClientNameWithType:ShareTypeWeixiTimeline]
                                      icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline]
                              clickHandler:
              //点击事件
              ^{
                  [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                                        container:nil
                                          content:publishContent
                                    statusBarTips:YES
                                      authOptions:authOptions
                                     shareOptions:
                     [ShareSDK defaultShareOptionsWithTitle:nil
                                            oneKeyShareList:[NSArray defaultOneKeyShareList]
                                             qqButtonHidden:NO
                                      wxSessionButtonHidden:NO
                                     wxTimelineButtonHidden:NO
                                       showKeyboardOnAppear:NO
                                          shareViewDelegate:appDelegate.viewDelegate
                                        friendsViewDelegate:appDelegate.viewDelegate
                                      picViewerViewDelegate:nil]
                                           result:
                     //分享结果
                     ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                         if (state == SSPublishContentStateSuccess){
                             NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                             if (block) {
                                 manager.block = [block copy];
                                 manager.block(statusInfo);
                             }
                         }else if (state == SSPublishContentStateFail){
                             NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                         }
                     }];
                }],
    sinaItem,nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK
                                    defaultShareOptionsWithTitle:nil
                                    oneKeyShareList:[NSArray defaultOneKeyShareList]
                                    qqButtonHidden:NO
                                    wxSessionButtonHidden:NO
                                    wxTimelineButtonHidden:NO
                                    showKeyboardOnAppear:NO
                                    shareViewDelegate:appDelegate.viewDelegate
                                    friendsViewDelegate:appDelegate.viewDelegate
                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                    if (block) {
                                        manager.block = [block copy];
                                        manager.block(statusInfo);
                                    }
                                }else if (state == SSPublishContentStateFail){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
@end
