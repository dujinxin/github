//
//  DJXMainViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-6.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXMainViewController.h"

#import "AdScrollView.h"
#import "AdDataModel.h"

@interface DJXMainViewController ()

@end

@implementation DJXMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [self getNavigationItem:self selector:@selector(count) title:@"左边" style:kSingleLineWords isLeft:YES];
    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(count) image:[UIImage imageNamed: @"二维码"] style:kSingleImage  isLeft:NO];
    [self setTitleViewWithTitle:@"主页"];
    
    //利用图片设置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackgroundImage@2x"] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTranslucent:NO];
    //利用颜色设置
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        //单个试图控制器中设置
//        [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
        //设置所有的，最好在appdelegate中设置
//        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x184fa2)];

    }
    
    // For better behavior set statusbar style to opaque on iOS < 7.0
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)) {
        // Silence depracation warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
#pragma clang diagnostic pop
    }
    
    
    [self initWithView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitWithView
- (void)initWithView{
    [self initWithScrollView];

}
- (void)initWithScrollView{
    AdScrollView * scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    AdDataModel * dataModel = [AdDataModel adDataModelWithImageNameAndAdTitleArray];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    //    scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    NSLog(@"%@",dataModel.adTitleArray);
    scrollView.imageNameArray = dataModel.imageNameArray;
    scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    [scrollView setAdTitleArray:dataModel.adTitleArray withShowStyle:AdTitleShowStyleLeft];
    
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    [self.view addSubview:scrollView];
}
- (void)count{
    
}
@end
