//
//  UIImageView+Method.m
//  JXView
//
//  Created by dujinxin on 15-6-4.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "UIImageView+Method.h"

@implementation UIImageView (Method)


-(void)setImageWithString:(NSString *)imageString{
    [self setImageWithString:imageString placeholderImage:nil];
}

-(void)setImageWithString:(NSString *)imageString placeholderImage:(NSString *)placeholderImage{
    if (imageString && [imageString hasPrefix:@"http"]) {
        [self setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:placeholderImage]];
    }else{
        [self setImage:[UIImage imageNamed:imageString]];
    }
}
@end
