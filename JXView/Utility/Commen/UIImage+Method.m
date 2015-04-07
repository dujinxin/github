//
//  UIImage+Method.m
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "UIImage+Method.h"

@implementation UIImage (Method)


//在指定的视图内进行截屏操作,返回截屏后的图片
+(UIImage *)imageWithScreenContentsInView:(UIView *)view
{
    //根据屏幕大小，获取上下文
    UIGraphicsBeginImageContext([[UIScreen mainScreen] bounds].size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

//在指定的视图内进行截屏操作,返回截屏后的图片
+(UIImage*)resizeImageToSize:(CGSize)size
                 sizeOfImage:(UIImage*)image
{
    
    UIGraphicsBeginImageContext(size);
    //获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    //根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

//- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    double ratio;
//    double delta;
//    CGPoint offset;
//    
//    //make a new square size, that is the resized imaged width
//    CGSize sz = CGSizeMake(newSize.width, newSize.width);
//    
//    //figure out if the picture is landscape or portrait, then
//    //calculate scale factor and offset
//    if (image.size.width > image.size.height) {
//        ratio = newSize.width / image.size.width;
//        delta = (ratio*image.size.width - ratio*image.size.height);
//        offset = CGPointMake(delta/2, 0);
//    } else {
//        ratio = newSize.width / image.size.height;
//        delta = (ratio*image.size.height - ratio*image.size.width);
//        offset = CGPointMake(0, delta/2);
//    }
//    
//    //make the final clipping rect based on the calculated values
//    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
//                                 (ratio * image.size.width) + delta,
//                                 (ratio * image.size.height) + delta);
//    
//    
//    //start a new context, with scale factor 0.0 so retina displays get
//    //high quality image
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
//    } else {
//        UIGraphicsBeginImageContext(sz);
//    }
//    UIRectClip(clipRect);
//    [image drawInRect:clipRect];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}
//- (CGImageRef)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
//{
//    // Get a CMSampleBuffer's Core Video image buffer for the media data
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    
//    // Lock the base address of the pixel buffer
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    
//    // Get the base address
//    void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
//    
//    // Get the number of bytes per row for the pixel buffer
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    // Get the pixel buffer width and height
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    
//    // Create a device-dependent RGB color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    // Create a bitmap graphics context with the sample buffer data
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
//                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    
//    // Create a Quartz image from the pixel data in the bitmap graphics context
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    
//    // Unlock the pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    
//    // Free up the context and color space
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    // We should return CGImageRef rather than UIImage because QR Scan needs CGImageRef
//    return quartzImage;
//}
@end
