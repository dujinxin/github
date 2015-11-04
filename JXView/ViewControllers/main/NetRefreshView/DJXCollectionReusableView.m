//
//  DJXCollectionReusableView.m
//  JXView
//
//  Created by dujinxin on 15-7-22.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXCollectionReusableView.h"

@interface DJXCollectionReusableView (){
    CGRect  _frame;
}

@end

@implementation DJXCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        [self addSubview:self.headImage];
    }
    return self;
}
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _frame.size.width - 20, _frame.size.height -20)];
        
    }
    return _headImage;
}
@end
