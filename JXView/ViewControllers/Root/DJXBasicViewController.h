//
//  DJXBasicViewController.h
//  JXView
//
//  Created by dujinxin on 15-3-4.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kDefault,                           /* 默认     */
    kSingleLineWords,                   /* 单行显示  */
    kDoubleLineWords,                   /* 两行显示  */
    kSingleImage,                       /* 单张图片  */
    kDoubleImages,                      /* 两张图片  */
    kImage_textWithLeftImage,           /* 左图右文  */
    kImage_textWithLeftWord,            /* 左文右图  */
}kNavigationItemStyle;


typedef void (^CallBackBlock)();    /* block回调 */

@interface DJXBasicViewController : UIViewController


/*
 *@public viewContorller method
 */
@property (nonatomic, assign)kNavigationItemStyle navigationItemStyle;
@property (nonatomic, copy)  CallBackBlock        callBackBlock;

- (void)setTitleViewWithTitle:(NSString *)title;
- (void)setTitleView:(UIView *)titleView;

- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message target:(id)target;
/*
 *custom NavigationBar
 */
#pragma mark -- cus
-(UIView *)setNavigationBar:(NSString *)title backgroundColor:(UIColor *)backgroundColor leftItem:(UIView *)leftItem rightItem:(UIView *)rightItem delegete:(id)delegate;

- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;

- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;

@end
