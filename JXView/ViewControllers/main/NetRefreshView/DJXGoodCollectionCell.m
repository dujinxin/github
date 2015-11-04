//
//  DJXGoodCollectionCelll.m
//  JXView
//
//  Created by dujinxin on 15-7-20.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXGoodCollectionCell.h"

@interface DJXGoodCollectionCell(){
    CGRect  _frame;
}

@end
@implementation DJXGoodCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.goodImage];
        [self addSubview:self.goodName];
        [self addSubview:self.goodPrice];
    }
    return self;
}
#pragma mark - InitView
-(UIImageView *)goodImage{
    if (!_goodImage) {
        _goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _frame.size.width -10, _frame.size.width -10)];
        _goodImage.backgroundColor = [UIColor clearColor];
    }
    return _goodImage;
}
-(UILabel *)goodName{
    if (!_goodName) {
        _goodName = [[UILabel alloc]initWithFrame:CGRectMake(5, self.goodImage.bottom, _frame.size.width -10, 20)];
        _goodName.backgroundColor = [UIColor clearColor];
        _goodName.font = [UIFont systemFontOfSize:12.f];
    }
    return _goodName;
}
-(UILabel *)goodPrice{
    if (!_goodPrice) {
        _goodPrice = [[UILabel alloc] initWithFrame:CGRectMake(5, self.goodName.bottom, _frame.size.width -10, 20)];
        _goodPrice.backgroundColor = [UIColor clearColor];
        _goodPrice.font = [UIFont systemFontOfSize:10.f];
    }
    return _goodPrice;
}

#pragma mark - CellMethod
-(void)setPriceText:(NSString *)oldPrice andNewPirce:(NSString *)newPrice{
//    NSParameterAssert(oldPrice);
    NSMutableString * s = [NSMutableString stringWithFormat:@"￥%@  ￥%@",newPrice,oldPrice];
    //设置特殊颜色
    NSRange oldRange = [s rangeOfString:[NSString stringWithFormat:@"￥%@",oldPrice]];
    NSRange newRange = [s rangeOfString:[NSString stringWithFormat:@"￥%@",newPrice]];
    NSMutableAttributedString *attributedString;
    if (!newPrice) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",oldPrice]];
        [attributedString addAttributes:@{
                                          NSForegroundColorAttributeName: [UIColor redColor],
                                          NSFontAttributeName: [UIFont systemFontOfSize:20]
                                          }
                                  range:NSMakeRange(0,[NSString stringWithFormat:@"￥%@",oldPrice].length)];
        _goodPrice.attributedText = attributedString;
        return;
    }
    if (newPrice.integerValue < oldPrice.integerValue) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:s];
        
        [attributedString addAttributes:@{
                                          NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                                          NSFontAttributeName: [UIFont systemFontOfSize:10]
                                          }
                                  range:NSMakeRange(0, s.length)];
        [attributedString addAttributes:@{
                                          NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
                                          NSFontAttributeName: [UIFont systemFontOfSize:10]
                                          }
                                  range:oldRange];
        [attributedString addAttributes:@{
                                          NSForegroundColorAttributeName: [UIColor redColor],
                                          NSFontAttributeName: [UIFont systemFontOfSize:20]
                                          }
                                  range:newRange];
        
    
    }else{
        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",oldPrice]];
        [attributedString addAttributes:@{
                                          NSForegroundColorAttributeName: [UIColor redColor],
                                          NSFontAttributeName: [UIFont systemFontOfSize:20]
                                          }
                                  range:NSMakeRange(0,[NSString stringWithFormat:@"￥%@",oldPrice].length)];
    }
    _goodPrice.attributedText = attributedString;
}
@end
