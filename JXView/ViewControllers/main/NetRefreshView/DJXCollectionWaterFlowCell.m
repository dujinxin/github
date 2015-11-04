//
//  DJXCollectionWaterFlowCell.m
//  JXView
//
//  Created by dujinxin on 15-7-22.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXCollectionWaterFlowCell.h"

@implementation DJXCollectionWaterFlowCell

-(void)setImage:(UIImage *)image{
    if(_image !=image){
        _image = image;
    }
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect{
    float newHeigth = _image.size.height/_image.size.width *100;
    [_image drawInRect:CGRectMake(0, 0, 100, newHeigth)];
}
@end
