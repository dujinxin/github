//
//  DJXCachePost.m
//  JXView
//
//  Created by dujinxin on 15-4-15.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXCachePost.h"


#define kGoodsList           @"v2/goods/list"

@implementation DJXCachePost

- (void)setGoodEntity:(NSDictionary *)goodDic{
    
    if ([goodDic objectForKey:@"price"]) {
        self.price = [goodDic objectForKey:@"price"];
    }
    if ([goodDic objectForKey:@"goods_num"]) {
        self.goodNum = [goodDic objectForKey:@"goods_num"];
    }
    if ([goodDic objectForKey:@"goods_name"]) {
        self.goods_name = [goodDic objectForKey:@"goods_name"];
    }
    if ([goodDic objectForKey:@"discount"]) {
        self.discount = [goodDic objectForKey:@"discount"];
    }
    if ([goodDic objectForKey:@"promotion"]) {
        self.discount_price = [goodDic objectForKey:@"promotion"];
    }
    if ([goodDic objectForKey:@"discount_price"]) {
        self.discount_price = [goodDic objectForKey:@"discount_price"];
    }
    if ([goodDic objectForKey:@"id"]) {
        self.cart_id = [goodDic objectForKey:@"id"];
    }
    if ([goodDic objectForKey:@"bu_goods_id"]) {
        self.bu_goods_id = [goodDic objectForKey:@"bu_goods_id"];
    }
    if ([goodDic objectForKey:@"bu_goods_code"]) {
        self.bu_goods_code = [goodDic objectForKey:@"bu_goods_code"];
    }
    if ([goodDic objectForKey:@"id"]) {
        self.goods_id = [goodDic objectForKey:@"id"];
    }
    if ([goodDic objectForKey:@"total"]) {
        self.goodNum = [goodDic objectForKey:@"total"];
    }
    if ([goodDic objectForKey:@"goods_image"]) {
        self.goods_image = [goodDic objectForKey:@"goods_image"];
    }
    if ([goodDic objectForKey:@"photo"]) {
        self.goods_image = [goodDic objectForKey:@"photo"];
    }
    if ([goodDic objectForKey:@"pay_type"]) {
        self.pay_type = [goodDic objectForKey:@"pay_type"];
    }
    if ([goodDic objectForKey:@"is_sell"]) {
        self.is_sell = [goodDic objectForKey:@"is_sell"];
    }
    if ([[goodDic objectForKey:@"specifications"] isKindOfClass:[NSArray class]]) {
        self.specifications = [NSMutableArray arrayWithArray:[goodDic objectForKey:@"specifications"]];
    }
    if ([goodDic objectForKey:@"stock"]) {
        self.stock = [goodDic objectForKey:@"stock"];
    }
    if ([goodDic objectForKey:@"out_of_stock"]) {
        self.out_of_stock = [goodDic objectForKey:@"out_of_stock"];
    }
    
    if ([goodDic objectForKey:@"region_id"]) {
        self.region_id = [goodDic objectForKey:@"region_id"];
    }
    if ([goodDic objectForKey:@"region_name"]) {
        self.region_name = [goodDic objectForKey:@"region_name"];
    }
    if ([goodDic objectForKey:@"goods_weight"]) {
        self.goods_weight = [goodDic objectForKey:@"goods_weight"];
    }
    
    if ([goodDic objectForKey:@"date_time"]) {
        self.date_time = [goodDic objectForKey:@"date_time"];
    }
    if ([goodDic objectForKey:@"start_time"]) {
        self.start_time = [goodDic objectForKey:@"start_time"];
    }
    if ([goodDic objectForKey:@"end_time"]) {
        self.end_time = [goodDic objectForKey:@"end_time"];
    }
    if ([goodDic objectForKey:@"is_or_not_salse"]) {
        self.is_or_not_salse =[ goodDic objectForKey:@"is_or_not_salse"];
    }
    if ([goodDic objectForKey:@"limit_the_purchase_type"]) {
        self.limit_the_purchase_type = [goodDic objectForKey:@"limit_the_purchase_type"];
    }
    if ([goodDic objectForKey:@"goods_introduction"]) {
        self.goods_introduction = [goodDic objectForKey:@"goods_introduction"];
    }
}

// 将商品entity转换为NSDictionary
- (NSMutableDictionary *)convertGoodsEntityToDictionary{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.order_goods_id) {
        [dataDic setValue:self.order_goods_id forKey:@"order_goods_id"];
    }
    if (self.bu_goods_id) {
        [dataDic setValue:self.bu_goods_id forKey:@"bu_goods_id"];
    }
    if (self.bu_goods_code) {
        [dataDic setValue:self.bu_goods_code forKey:@"bu_goods_code"];
    }
    if (self.photo) {
        [dataDic setValue:self.photo forKey:@"photo"];
    }
    if (self.goods_image) {
        [dataDic setValue:self.goods_image forKey:@"photo"];
    }
    if (self.goods_name) {
        [dataDic setValue:self.goods_name forKey:@"goods_name"];
    }
    if (self.goodNum) {
        [dataDic setValue:self.goodNum forKey:@"goods_num"];
    }
    return dataDic;
}

@end

@implementation GoodsListCacheEntity

- (void)setGoodsListEntity:(NSMutableArray *)listArray{
    _goodsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in listArray) {
        DJXCachePost *good = [[DJXCachePost alloc] init];
        [good setGoodEntity:dic];
        [self.goodsArray addObject:good];
    }
}
@end


@implementation GoodListCacheObj

-(NSString *)requestUrl{
    //    return [NSString stringWithFormat:@"%@%@",kBaseUrl,kGoodsList];
    return [NSString stringWithFormat:@"%@%@?session_id=&region_id=1001",kBaseUrl,kGoodsList];
}
-(BOOL)useCache{
    return YES;
}
- (NSInteger)cacheTimeInSeconds {
    return 60 * 1;
}
-(DJXRequestMethod)requestMethod{
    return kRequestMethodPost;
}
-(NSSet *)acceptableContentTypes{
    return [NSSet setWithObject:@"text/html"];
}
-(BOOL)isUseFormat{
    return NO;
}
-(void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    if (isSuccess) {
        /* 将数据传给界面 */
        //代理方法
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccess:tag:)]) {
            [self.delegate responseSuccess:object tag:self.tag];
        }
        //        //block
        //        if (self.success) {
        //            self.success(object);
        //        }
        //        //target-action
        //        if ([self.delegate respondsToSelector:self.action] && self.action){
        //            SuppressPerformSelectorLeakWarning(
        //                                               [self.delegate performSelector:self.action withObject:object];
        //                                               );
        //        }
    }else{
        /* 将数据传给界面 */
        //代理方法
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseFailed:withMessage:)]) {
            [self.delegate responseFailed:self.tag withMessage:message];
        }
        //        //block
        //        if (self.failure) {
        //            self.failure(message);
        //        }
        //        //target-action
        //        if ([self.delegate respondsToSelector:self.action] && self.action){
        //            SuppressPerformSelectorLeakWarning(
        //                                               [self.delegate performSelector:self.action withObject:message];
        //                                               );
        //        }
    }
}
- (BOOL)requestFailed:(id)responseData
{
    if(![super requestFailed:responseData]){
        return NO;
    }
    NSLog(@"request fail");
    [self.delegate responseFailed:self.tag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[DJXRequestManager sharedInstance] cancelRequest:self];
    return YES;
}

-(BOOL)requestSuccess:(id)responseData{
    if(![super requestSuccess:responseData]){
        return NO;
    }
    id result = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:nil];
    //返回结果是以Dictionary存在
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        NSMutableArray * datas = [dict objectForKey:@"data"];
        //        if([datas count] == 0){
        //            if ([dict valueForKey:@"total"]==0) {
        //                [self.delegate requestFailed:self.tag withStatus:@"999" withMessage:@"数据为空。"];
        //                [[DJXRequestManager sharedInstance]cancelRequest:self];
        //                return YES;
        //            }
        //        }
        NSString *status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"status:%@",status);
        GoodsListCacheEntity *goodsList = [[GoodsListCacheEntity alloc] init];
        if([status isEqualToString:WEB_STATUS_1] ){
            goodsList.total = [dict objectForKey:@"total"];
            [goodsList setGoodsListEntity:datas];
        }else if ([status isEqualToString:WEB_STATUS_3])
        {
            [self.delegate responseFailed:self.tag withStatus:WEB_STATUS_3 withMessage:[dict objectForKey:@"message"]];
            return YES;
        }else{
            NSLog(@"status 10000 %@",[dict objectForKey:@"message"]);
        }
        /* 将数据传给界面 */
        //        //代理方法
        //        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccessObj:tag:)]) {
        //            [self.delegate responseSuccessObj:goodsList tag:self.tag];
        //        }
        //        //block
        //        if (self.success) {
        //            self.success(goodsList);
        //        }
        //target-action
        if ([self.delegate respondsToSelector:self.action] && self.action){
            SuppressPerformSelectorLeakWarning(
                [self.delegate performSelector:self.action withObject:goodsList];
            );
        }
        
    }
    
    
    [[DJXRequestManager sharedInstance]cancelRequest:self];
    return YES;
}

@end
