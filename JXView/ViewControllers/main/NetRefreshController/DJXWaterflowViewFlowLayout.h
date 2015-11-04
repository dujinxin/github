//
//  DJXWaterflowViewFlowLayout.h
//  JXView
//
//  Created by dujinxin on 15-7-23.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJXWaterflowViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign)id <UICollectionViewDelegateFlowLayout>delegate;
@property (nonatomic, assign)NSInteger cellCount;
@property (nonatomic, strong)NSMutableArray * colArr;
@property (nonatomic, strong)NSMutableDictionary * attributesDic;
@end
