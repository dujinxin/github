//
//  SYAppStart.m
//  FEShareLib
//
//  Created by 余书懿 on 13-5-25.
//  Copyright (c) 2013年 珠海飞企. All rights reserved.
//

#import "SYAppStart.h"
#import "DJXLocationViewController.h"

@implementation SYAppStart


#define Tag_appStartImageView 1314521

static UIWindow * startImageWindow = nil;

+ (void)show{
    if (startImageWindow == nil) {
        startImageWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startImageWindow.backgroundColor = [UIColor clearColor];
        startImageWindow.windowLevel = UIWindowLevelStatusBar + 1; //必须加1
        DJXLocationViewController * lvc = [[DJXLocationViewController alloc] init];
        UINavigationController * nlvc = [[UINavigationController alloc ]initWithRootViewController:lvc];
        startImageWindow.rootViewController = nlvc;
    }
    
    [startImageWindow setHidden:NO];
}
+ (void)show:(UIImage *)imageUrl
{
    if (startImageWindow == nil) {
        startImageWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startImageWindow.backgroundColor = [UIColor clearColor];
        startImageWindow.userInteractionEnabled = NO;
        startImageWindow.windowLevel = UIWindowLevelStatusBar + 1; //必须加1
        DJXLocationViewController * lvc = [[DJXLocationViewController alloc] init];
        UINavigationController * nlvc = [[UINavigationController alloc ]initWithRootViewController:lvc];
        startImageWindow.rootViewController = nlvc;
    }
    
    [startImageWindow setHidden:NO];
}
+ (void)hide:(BOOL)animated
{
    UINavigationController * nlvc = (UINavigationController *)[startImageWindow rootViewController];
    if (nlvc) {
        if (animated) {
//            [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
//                [nlvc.view setTransform:CGAffineTransformMakeScale(2, 2)];
//                [nlvc.view setAlpha:0];
//            } completion:^(BOOL finished) {
//                [SYAppStart clear];
//            }];
            [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                [nlvc.view setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, SCREEN_WIDTH, 0)];
                //[nlvc.view setAlpha:0];
            } completion:^(BOOL finished) {
                [SYAppStart clear];
            }];
        }else
        {
            [SYAppStart clear];
        }
    }
}

+ (void)hideWithCustomBlock:(void (^)(UIImageView *))block
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    if (imageView) {
        if (block) {
            block(imageView);
        }
    }
}

+ (void)clear
{
    UINavigationController * nlvc = (UINavigationController *)[startImageWindow rootViewController];
    nlvc = nil;
    startImageWindow.rootViewController = nil;
    [startImageWindow removeFromSuperview];
    startImageWindow = nil;
}




@end


@implementation SYAppStartViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
