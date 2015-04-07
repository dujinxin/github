//
//  DJXScanViewController.h
//  JXView
//
//  Created by dujinxin on 14-11-7.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

/*二维码扫描
导入ZBarSDK文件并引入一下框架
AVFoundation.framework
CoreMedia.framework
CoreVideo.framework
QuartzCore.framework
libiconv.dylib
引入头文件#import “ZBarSDK.h” 即可使用
 */
/*字符转二维码
 导入 libqrencode文件
 引入头文件#import "QRCodeGenerator.h" 即可使用
 */
#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "JXAlertView.h"

typedef enum{
    barCode = 0,
    twoDimensionCode,
}ScanType;

@interface DJXScanViewController : UIViewController<ZBarReaderDelegate,ZBarReaderViewDelegate,ZBarHelpDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,JXAlertViewDelegate>
{
    ZBarReaderView * readerView;
    ZBarCameraSimulator * cameraSimularor;
    ZBarHelpController * helpContorller;
    ScanType scanType;
}
@end
