//
//  DJXGoodCollectionCelll.h
//  JXView
//
//  Created by dujinxin on 15-7-20.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJXGoodCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * goodImage;
@property (nonatomic, strong) UILabel     * goodName;
@property (nonatomic, strong) UILabel     * goodPrice;

-(void)setPriceText:(NSString *)oldPrice andNewPirce:(NSString *)newPrice;

@end
