//
//  UITableViewCell+Method.m
//  JXView
//
//  Created by dujinxin on 14-12-31.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "UITableViewCell+Method.h"

@implementation UITableViewCell (Method)

- (void)startAnimationWithDelay:(CGFloat)delayTime
{
    self.transform =  CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
    [UIView animateWithDuration:1. delay:delayTime usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:NULL];
}
@end
