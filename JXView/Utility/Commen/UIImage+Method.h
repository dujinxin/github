//
//  UIImage+Method.h
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface UIImage (Method)


//返回特定尺寸的UImage  ,  image参数为原图片，size为要设定的图片大小

+(UIImage*)resizeImageToSize:(CGSize)size
                 sizeOfImage:(UIImage*)image;

//在指定的视图内进行截屏操作,返回截屏后的图片
+(UIImage *)imageWithScreenContentsInView:(UIView *)view;
@end
