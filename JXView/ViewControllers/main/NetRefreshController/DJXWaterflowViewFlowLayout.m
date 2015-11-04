//
//  DJXWaterflowViewFlowLayout.m
//  JXView
//
//  Created by dujinxin on 15-7-23.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXWaterflowViewFlowLayout.h"

NSInteger const colCount  =  3;
@implementation DJXWaterflowViewFlowLayout

//准备布局
-(void)prepareLayout{
    [super prepareLayout];
    _attributesDic = [NSMutableDictionary dictionary];
    self.delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    //获取cell的总个数
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    if (_cellCount == 0){
        return;
    }
    _colArr = [NSMutableArray array];//列数 此处为3列 数组中存储每列的高度
    float top = 0;
    for (int i = 0; i < colCount; i++){
        [_colArr addObject:[NSNumber numberWithFloat:top]];
    }
    //循环调用layoutAttributesForItemAtIndexPath方法为每个cell计算布局，将indexPath传入,做为布局字典的key
    for (int i =0; i < _cellCount; i++){
        [self layoutForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
}

//此方法会多次调用 为每个cell布局
-(void)layoutForItemAtIndexPath:(NSIndexPath *)indexPath{
    //调用协议方法得到cell间的间隙
    UIEdgeInsets edgeInsets  = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.row];
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    NSInteger col = 0;//列数
    //找出高度最小列，将cell加到最小列中
    float shortHeigth = [[_colArr objectAtIndex:col] floatValue];
    for (int i = 1; i< _colArr.count; i++) {
        float colHeight = [[_colArr objectAtIndex:i] floatValue];
        if (colHeight < shortHeigth) {
            shortHeigth = colHeight;
            col = i;
        }
    }
    float top = [[_colArr objectAtIndex:col] floatValue];
    //确定每个cell的frame
    CGRect frame = CGRectMake(edgeInsets.left + col*(edgeInsets.left+itemSize.width), top+edgeInsets.top, itemSize.width, itemSize.height);
    //cell加入后，更新列高
    [_colArr replaceObjectAtIndex:col withObject:[NSNumber numberWithFloat:top + edgeInsets.top +itemSize.height]];
    //每个cell的frame对应一个indexPath,存入字典中
    [_attributesDic setObject:indexPath forKey:NSStringFromCGRect(frame)];
}
-(NSArray*)indexPathsOfItemsInRect:(CGRect)rect{
    //遍历布局字典通过CGRectIntersectsRect方法确定每个cell的rect与传入的rect是否有交集，如果结果为true，则此cell应该显示，将布局字典中对应的indexPath加入数组
    NSMutableArray *indexPaths = [NSMutableArray array];
    for(NSString *rectStr in _attributesDic){
        CGRect cellRect = CGRectFromString(rectStr);
        if(CGRectIntersectsRect(rect,cellRect)){
            NSIndexPath *indexPath= _attributesDic[rectStr];
            [indexPaths addObject:indexPath];
        }
    }
    return indexPaths;
}
//此方法会传入一个collectionView当前可见的rect,视图滑动时调用
//需要返回每个cell的布局信息，如果忽略传入的rect一次性将所有的cell布局信息返回，图片过多时性能会很差
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributes =[NSMutableArray array];
    //调用indexPathsOfItemsInRect方法，将rect传入，计算当前rect中应该出现的cell，返回值为cell的indexPath数组
    NSArray *indexPaths =[self indexPathsOfItemsInRect:rect];
    for(NSIndexPath *indexPath in indexPaths){
        UICollectionViewLayoutAttributes *attribute =[self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:attribute];
    }
    return attributes;
}
//此方法需要返回，collectionView内容的大小，只需要遍历前面创建的存放列高的数组得到列高最大的一个作为高度返回就可以了
-(CGSize)collectionViewContentSize{
    CGSize size = self.collectionView.frame.size;
    //找出3列中最高的一列，作为collectionView的高度
    float maxHeight = 0.0f;
    if ([_colArr objectAtIndex:0]) {
        maxHeight = [[_colArr objectAtIndex:0] floatValue];
    };
    for (int i = 1; i < _colArr.count; i++) {
        float colHeight = [[_colArr objectAtIndex:i] floatValue];
        if (colHeight > maxHeight) {
            maxHeight = colHeight;
        }
    }
    size.height = maxHeight + 44;
    NSLog(@"colArr:%@ Footer:%f contentSize:%f",_colArr,self.collectionView.footer.frame.origin.y,self.collectionView.contentSize.height);
    return size;
}
@end
