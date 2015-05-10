//
//  DJXScanViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-7.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXScanViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>

@interface DJXScanViewController ()
{
    UIImageView * scanImage;
    BOOL isScan;
}
@end

@implementation DJXScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isScan = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addScanReadView];
    [self addShadowView];
    [self setScanView];
    [self beginAnimation:YES];
    [self addOtherView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始扫描
    [readerView start];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //结束扫描，不结束的话，默认一直再扫描，会用内存警告~~~
    [readerView stop];
    [self beginAnimation:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitUIView
- (void)addScanReadView{
    
    readerView = [[ZBarReaderView alloc]init];
    readerView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    readerView.readerDelegate = self;
    //不适用手势变焦
    readerView.allowsPinchZoom = NO;
    readerView.tracksSymbols = YES;
    //关闭闪光灯
    readerView.torchMode = 0;
    //扫描区域
    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(readerView.frame) - 126, 200, 200);
    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = readerView;
    }
    [self.view addSubview:readerView];
    //扫描区域计算
    readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.bounds];
}

-(void)setScanView
{
    //扫描框
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-227)/2,CGRectGetMinY(self.navigationController.navigationBar.frame)+110, 227, 220)];
    imgView.backgroundColor = [UIColor clearColor];
    //blw 14-10-20
    imgView.image = [UIImage imageNamed:@"image_resize_frame4.png"];
    [self.view addSubview:imgView];
    
    //扫描线
    scanImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-227)/2+4, CGRectGetMinY(self.navigationController.navigationBar.frame)+110, 219, 14.5)];
    scanImage.image = [UIImage imageNamed:@"zbarScan.png"];

}
- (void)addOtherView{
    NSArray * array = [NSArray arrayWithObjects:@"相册",@"开灯",@"条码",@"二维码",@"生成二维码", nil];
    for (int i = 0;  i < array.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + i * 60, SCREEN_HEIGHT - 120, 60, 35);
//        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel sizeToFit];
        btn.tag = 10+i;
        [self.view addSubview:btn];
    }
}
//添加阴影视图
-(void)addShadowView
{
    UIView * view_top = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.navigationController.navigationBar.frame), SCREEN_WIDTH, 110)];
    view_top.backgroundColor = [UIColor blackColor];
    view_top.alpha = 0.5;
    
    UIView * view_down = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(self.navigationController.navigationBar.frame)+330 , SCREEN_WIDTH, SCREEN_HEIGHT-330)];
    view_down.backgroundColor = [UIColor blackColor];
    view_down.alpha = 0.5;
    
    UIView * view_left = [[UIView alloc] initWithFrame:CGRectMake(0, 110, (SCREEN_WIDTH-227)/2, 220)];
    view_left.backgroundColor = [UIColor blackColor];
    view_left.alpha = 0.5;
    
    UIView * view_right = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- (SCREEN_WIDTH-227)/2, 110,  (SCREEN_WIDTH-227)/2, 220)];
    view_right.backgroundColor = [UIColor blackColor];
    view_right.alpha = 0.5;
    [self.view addSubview:view_top];
    [self.view addSubview:view_down];
    [self.view addSubview:view_left];
    [self.view addSubview:view_right];
    
}
//扫描区域计算
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
//  动画
- (void)beginAnimation:(BOOL)isAnimation{
    if (!isAnimation)
    {
        isScan = NO;
        return;
    }else{
        [self.view addSubview:scanImage];
        scanImage.hidden = NO;
        [UIView animateWithDuration:2 animations:^{
            [scanImage setFrame:CGRectMake( (SCREEN_WIDTH-227)/2+4, CGRectGetMinY(self.navigationController.navigationBar.frame)+100+220, 219, 14.5)];
            
        } completion:^(BOOL finish){
            [scanImage setFrame:CGRectMake((SCREEN_WIDTH-227)/2+4, CGRectGetMinY(self.navigationController.navigationBar.frame)+103, 219, 14.5)];
            if (isScan == YES)
            {
                [self beginAnimation:YES];
            }
        }];
    }
}
- (void)btnClick:(UIButton *)btn{

    switch (btn.tag) {
        case 10:
        {
            
        }
            break;
        case 11:
        {
            if (readerView.torchMode == 0) {
                readerView.torchMode = 1;
            }else{
                readerView.torchMode = 0;
            }
            
        }
            break;
        case 12:
        {
            
        }
            break;
        case 13:
        {
            
        }
            break;
        case 14:
        {
            NSString * myString = @"wode";
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 240)];
            imageView.image = [QRCodeGenerator qrImageForString:myString imageSize:imageView.bounds.size.width];
            NSArray * array = [[NSArray alloc]initWithObjects:@"保存", nil];
            JXAlertView * alert = [[JXAlertView alloc]initWithTitle:@"我的二维码" customView:imageView target:self buttonTitles:array];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - ZBarScanDelegate
#pragma mark --------------------------解码
//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample)
{
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundID);
    //    CFRelease(sample);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    [readerView stop];
    ZBarSymbol *symbol = nil;
    // do something useful with results
    for(symbol in syms)
    {
        CFBundleRef mainBundle;
        SystemSoundID soundID;
        mainBundle = CFBundleGetMainBundle ();
        
        // Get the URL to the sound file to play
        CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (mainBundle,
                                                             CFSTR ("scan_tip"),
                                                             CFSTR ("wav"),
                                                             NULL
                                                             );
        // Create a system sound object representing the sound file
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
        // Add sound completion callback
        AudioServicesAddSystemSoundCompletion (soundID, NULL, NULL,
                                               SoundFinished,
                                               (void *) CFBridgingRetain(self));
        // Play the audio
        AudioServicesPlaySystemSound(soundID);
        NSString *symbolStr= symbol.data;
        NSLog(@"type:%@",symbolStr);
        break;
    }
    [self parseResultString:symbol.data ];
}

-(void)parseResultString:(NSString*)resultString
{
    //    [self beginAnimation:NO];
    scanImage.hidden = YES;
    NSLog(@"resultString = %@" ,resultString);
    if (resultString == nil){
        if (scanType == barCode){
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有扫描结果" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [readerView stop];
            [view show];
        }else{
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本商品暂未在永辉微店售卖，请试试其他商品，谢谢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [readerView stop];
            [view show];
        }
        return;
    }
    //  根据扫瞄结果下单
    if (scanType == twoDimensionCode){
        //
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"扫描二维码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [readerView stop];
        [view show];
    }
    else{
        //
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"扫描条码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [readerView stop];
        [view show];
    }
}
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader withRetry: (BOOL) retry{
    NSLog(@"false");
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImage * ima_03 = [UIImage imageNamed:@"ioslook-3.png"];
    //        UIImage * ima_04 = [ZbarViewController scaleAndRotateImage:ima_03 resolution:144];
}
+(UIImage *)scaleAndRotateImage:(UIImage *)image resolution:(int)kMaxResolution
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(floorf(bounds.size.width), floorf(bounds.size.height)));
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, floorf(width), floorf(height)), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
@end
