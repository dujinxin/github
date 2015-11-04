//
//  UITool.h
//  LimitFreeProject
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

//将创建控件的通用的代码 可以写在此类中
@interface UITool : NSObject

/*
 快速创建基本视图控件
 */
//button
+(UIButton *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName frame:(CGRect)frame tag:(NSInteger)tag;
//label
+(UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font frame:(CGRect)frame;
//imageView
+(UIImageView *)createImageViewWithImageName:(NSString *)imageName frame:(CGRect)frame tag:(NSInteger )tag;

//背景视图
+(UIView *)createBackgroundViewWithColor:(UIColor *)color frame:(CGRect)frame;
//item
+(UIBarButtonItem *)createItemWithTitle:(NSString *)title imageName:(NSString *)imageName delegate:(id)delegate selector:(SEL)selector;
+(UIBarButtonItem *)createItemWithNormalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle normalImage:(NSString *)normalImage selectedImage:(NSString * )selectedImage delegate:(id)delegate selector:(SEL)selector tag:(NSInteger)tag;
//tab
//循环创建button
//+(UIView *)createButtonsWithClass:(Class *)className count:(NSInteger)count row:(NSInteger)row calumn:(NSInteger)calumn tag:(NSInteger)tag titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;
+(UIView *)createButtonsWithClassName:(NSString *)className count:(NSInteger)count row:(NSInteger)row calumn:(NSInteger)calumn tag:(NSInteger)tag titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray delegate:(id)delegate selector:(SEL)selector;


/*
 *弹窗提示
 */
+ (void)showAlertView:(NSString *)message;
+ (void)showAlertView:(NSString *)message target:(id)target;
@end
