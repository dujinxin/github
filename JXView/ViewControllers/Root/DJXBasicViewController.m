//
//  DJXBasicViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-4.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXBasicViewController.h"
#import "UITool.h"

@interface DJXBasicViewController ()

@end

@implementation DJXBasicViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 *custom NavigationBar
 */
-(UIView *)setNavigationBar:(NSString *)title backgroundColor:(UIColor *)backgroundColor leftItem:(UIView *)leftItem rightItem:(UIView *)rightItem delegete:(id)delegate{
    UIView * navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigationBar.backgroundColor = backgroundColor;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    titleLabel.center = CGPointMake(SCREEN_WIDTH /2, 20 + titleLabel.center.y);
    
    leftItem.frame = CGRectMake(10, 20, 44, 44);
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 44, 44);
    if ([leftItem isKindOfClass:[UIButton class]]) {
        UIButton * btn = (UIButton *)leftItem;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if ([rightItem isKindOfClass:[UIButton class]]) {
        UIButton * btn = (UIButton *)rightItem;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [navigationBar addSubview:leftItem];
    [navigationBar addSubview:rightItem];
    return navigationBar;
}
/*
 *title/titleView
 */
- (void)setTitleViewWithTitle:(NSString *)title{
    self.navigationItem.title = title;
}
- (void)setTitleView:(UIView *)titleView{
    self.navigationItem.titleView = titleView;
}
/*
 * NavigationItem
 */
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    return [self getNavigationItem:delegate selector:selector title:title image:nil style:style isLeft:isLeft];
}
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    return [self getNavigationItem:delegate selector:selector title:nil image:image style:style isLeft:isLeft];
}
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector title:(NSString *)title image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    UIButton *superBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    superBtn.frame = CGRectMake(0, 0, 30, 30);
    if (image) {
        [superBtn setImage:image forState:UIControlStateNormal];
    }
    if (title) {
        superBtn.frame = CGRectMake(0, 0, 52, 44);
        [superBtn setTitle:title forState:UIControlStateNormal];
        //        [superBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
        if(style == kDoubleLineWords){
            superBtn.frame = CGRectMake(0, 0, 30, 30);
            superBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            superBtn.titleLabel.numberOfLines = 2;
        }
    }
    [superBtn addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:superBtn];
    
    return rightBarItem;
}
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    return [self getNavigationItems:delegate selector:selector title:title image:nil style:style isLeft:isLeft];
}
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    return [self getNavigationItems:delegate selector:selector title:nil image:image style:style isLeft:isLeft];
}

- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    UIButton *superBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    superBtn.frame = CGRectMake(0, 0, 30, 30);
//    superBtn.backgroundColor = [UIColor purpleColor];
    [superBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [superBtn addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    if (style) {
        self.navigationItemStyle = style;
    }else{
        self.navigationItemStyle = kDefault;
    }
    switch (self.navigationItemStyle) {
        case kDefault:
        {
            if (title) {
                superBtn.frame = CGRectMake(0, 0, 52, 44);
                [superBtn setTitle:title forState:UIControlStateNormal];
            }
            if (image) {
                superBtn.frame = CGRectMake(0, 0, 30, 30);
                [superBtn setImage:image forState:UIControlStateNormal];
            }
            
        }
            break;
        case kSingleLineWords:
        {
            superBtn.frame = CGRectMake(0, 0, 52, 44);
            [superBtn setTitle:title forState:UIControlStateNormal];
        }
            break;
        case kSingleImage:
        {
            [superBtn setImage:image forState:UIControlStateNormal];
        }
            break;
        case kDoubleLineWords:
        {
            superBtn.frame = CGRectMake(0, 0, 30, 30);
            [superBtn setTitle:title forState:UIControlStateNormal];
            superBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            superBtn.titleLabel.numberOfLines = 2;
        }
            break;
        case kDoubleImages:
        {
            
        }
            break;
        case kImage_textWithLeftImage:
        {
            superBtn.frame = CGRectMake(0, 0, 60, 30);
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            imageView.image = image;
            
            UIButton * titleView = [UIButton buttonWithType:UIButtonTypeCustom];
            titleView.frame = CGRectMake(30, 0, 30, 30);
            [titleView setTitle:title forState:UIControlStateNormal];
            //        [leftBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
            titleView.titleLabel.font = [UIFont systemFontOfSize:11];
            titleView.titleLabel.numberOfLines = 2;
            [titleView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            [superBtn addSubview:imageView];
            [superBtn addSubview:titleView];
        }
            break;
        case kImage_textWithLeftWord:
        {
            
        }
            break;
            
        default:
            break;
    }
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:superBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /****** 消除间距 ********
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    if (title) {
        if (IOS_VERSION >= 7) {
            negativeSpacer.width = -10;
        }else{
            negativeSpacer.width = -5;
        }
    }
    NSMutableArray *buttonArray;
    if (isLeft) {
        buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,barButtonItem, nil];
    }else{
        //        buttonArray= [NSMutableArray arrayWithObjects:barButtonItem,negativeSpacer, nil];
        buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,barButtonItem, nil];
    }
    
    return buttonArray;
}

- (void)showMessage:(NSString *)message{
    [self showMessage:message target:nil];
}
- (void)showMessage:(NSString *)message target:(id)target{
    [UITool showAlertView:message target:target];
}
@end
