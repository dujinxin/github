//
//  DJXShareViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-23.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXShareViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
//#import "IIViewDeckController.h"
//#import "AGAppDelegate.h"
#import <AGCommon/NSString+Common.h>

#define BUNDLE_NAME @"Resource"

#define IMAGE_NAME @"sharesdk_img"
#define IMAGE_EXT @"jpg"

#define CONTENT NSLocalizedString(@"TEXT_SHARE_CONTENT", @"ShareSDK不仅集成简单、支持如QQ好友、微信、新浪微博、腾讯微博等所有社交平台，而且还有强大的统计分析管理后台，实时了解用户、信息流、回流率、传播效应等数据，详情见官网http://sharesdk.cn @ShareSDK")
#define SHARE_URL @"http://www.sharesdk.cn"
@interface DJXShareViewController ()

@end

@implementation DJXShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addShareView];
}
- (void)addShareView{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(80, 80, 160, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showShareView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)showShareView:(UIButton *)sender{
    UIImage *shareImage = [UIImage imageNamed:@"sharesdk_img.jpg"];
    id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                       defaultContent:nil
                                                image:[ShareSDK jpegImageWithImage:shareImage quality:0.8]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这时一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制人人网分享
    [publishContent addRenRenUnitWithName:NSLocalizedString(@"TEXT_HELLO_RENREN", @"Hello 人人网")
                              description:INHERIT_VALUE
                                      url:INHERIT_VALUE
                                  message:INHERIT_VALUE
                                    image:INHERIT_VALUE
                                  caption:nil];
    
    //定制QQ空间分享
    [publishContent addQQSpaceUnitWithTitle:NSLocalizedString(@"TEXT_HELLO_QZONE", @"Hello QQ空间")
                                        url:INHERIT_VALUE
                                       site:nil
                                    fromUrl:nil
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:INHERIT_VALUE
                                    playUrl:nil
                                       nswb:nil];
    
    //定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:NSLocalizedString(@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:INHERIT_VALUE
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
                                            title:INHERIT_VALUE
                                              url:@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D"
                                            image:INHERIT_VALUE
                                     musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ分享内容
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:@"Hello QQ!"
                                title:INHERIT_VALUE
                                  url:INHERIT_VALUE
                                image:INHERIT_VALUE];
    
    //定制邮件分享内容
    [publishContent addMailUnitWithSubject:INHERIT_VALUE
                                   content:@"<a href='http://sharesdk.cn'>Hello Mail</a>"
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //定制短信分享内容
    [publishContent addSMSUnitWithContent:@"Hello SMS!"];
    
    //定制有道云笔记分享内容
    [publishContent addYouDaoNoteUnitWithContent:INHERIT_VALUE
                                           title:NSLocalizedString(@"TEXT_SDK_SHARE", @"ShareSDK分享")
                                          author:@"ShareSDK"
                                          source:@"http://www.sharesdk.cn"
                                     attachments:INHERIT_VALUE];
    
    id clickHandler = ^{
//        AGCustomShareViewController *vc = [[[AGCustomShareViewController alloc] initWithImage:shareImage content:CONTENT] autorelease];
//        UINavigationController *naVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
//        
//        if ([UIDevice currentDevice].isPad)
//        {
//            naVC.modalPresentationStyle = UIModalPresentationFormSheet;
//        }
//        
//        [self presentModalViewController:naVC animated:YES];
    };
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                     clickHandler:clickHandler],
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeFacebook]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeFacebook]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTwitter]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeTwitter]
                                                     clickHandler:clickHandler],
                          SHARE_TYPE_NUMBER(ShareTypeGooglePlus),
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeRenren]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeRenren]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeKaixin]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeKaixin]
                                                     clickHandler:clickHandler],
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          SHARE_TYPE_NUMBER(ShareTypeAirPrint),
                          SHARE_TYPE_NUMBER(ShareTypeCopy),
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSohuWeibo]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeSohuWeibo]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareType163Weibo]
                                                             icon:[ShareSDK getClientIconWithType:ShareType163Weibo]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeDouBan]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeDouBan]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeInstapaper]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeInstapaper]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeYouDaoNote]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeYouDaoNote]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSohuKan]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeSohuKan]
                                                     clickHandler:clickHandler],
//                          nil];
    [ShareSDK shareActionSheetItemWithTitle:@"二维码分享"
                                             icon:[UIImage imageNamed: @"二维码"]
                               clickHandler:nil],nil];
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil
//                                      _appDelegate.viewDelegate
                                      ];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:nil
//                                    _appDelegate.viewDelegate
                                                      friendsViewDelegate:nil
//                                    _appDelegate.viewDelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
