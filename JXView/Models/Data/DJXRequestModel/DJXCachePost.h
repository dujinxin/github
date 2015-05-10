//
//  DJXCachePost.h
//  JXView
//
//  Created by dujinxin on 15-4-15.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXRequest.h"

@interface DJXCachePost : NSObject

/*单个商品entity*/
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *discount_price; // 现价（优惠价）
@property (nonatomic, strong) NSString *cart_id;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *bu_goods_id;   // 商品编码
@property (nonatomic, strong) NSString *goods_id;      // 商品id
@property (nonatomic, strong) NSString *is_sell;
@property (nonatomic, strong) NSString *goods_image;   // 购物车图片路径
@property (nonatomic, strong) NSString *photo;          // 商品图片url
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *goodNum;      // 商品数量
@property (nonatomic, strong) NSString *stock;        // 库存数量
@property (nonatomic, strong) NSString *out_of_stock;
@property (nonatomic, strong) NSMutableArray *specifications;
@property (nonatomic, strong) NSString *goods_weight;
// 退货商品（新增）
@property (nonatomic, strong) NSString *order_goods_id;//商品在订单中的ID
@property (nonatomic, strong) NSString *bu_goods_code; //商品编码

@property (nonatomic, strong) NSString       *region_id;
@property (nonatomic, strong) NSString       *region_name;
//12.15限购
@property (nonatomic, copy) NSString * date_time;
@property (nonatomic, copy) NSString * start_time;
@property (nonatomic, copy) NSString * end_time;
@property (nonatomic, copy) NSString * is_or_not_salse;
@property (nonatomic, copy) NSString * limit_the_purchase_type;

@property(nonatomic , copy)NSString * goods_introduction;

- (void)setGoodEntity:(NSDictionary *)goodEntity;
- (NSMutableDictionary *)convertGoodsEntityToDictionary;

@end

/*商品列表实体*/
@interface GoodsListCacheEntity : NSObject
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSString       *total;
@property (nonatomic, strong) NSString       *active_info;
@property (nonatomic, strong) NSString       *title;
@property (nonatomic, strong) NSString       *content;
@property (nonatomic, strong) NSString       *goods_weight;
- (void)setGoodsListEntity:(NSMutableArray *)listArray;

@end

@interface GoodListCacheObj : DJXRequest

@end
//{
//    "brand_pricing_type" = N;
//    "bu_brand_code" = 0006590;
//    "bu_category_code" = 004005001001;
//    "category_brand_pricing_type" = N;
//    "category_pricing_type" = N;
//    "date_time" = "2015-04-17 16:07:35";
//    discount = "";
//    "discount_price" = "1.70";                                //原价
//    "end_time" = "";
//    "goods_code" = 7777;
//    "goods_image" = "http://110.90.11.74:8080/amp-resource-webin/resource/9183D7DFACD0C6F8AAA2035CF3E16208?thumbnail=180:180";  //商品图片
//    "goods_introduction" = "";                                //说明性文字
//    "goods_name" = "\U5c71\U5cf0\U8425\U517b\U513f\U7ae5\U69a8\U83dc\U7247150g";                                          //商品名称
//    id = 2314;                                                //加入购物车，进入商品详情需要
//    "is_or_not_salse" = 0;                                    //专享
//    "is_sell" = 0;
//    "limit_the_purchase_e_date" = "";
//    "limit_the_purchase_s_date" = "";
//    "limit_the_purchase_type" = 0;                            //是否限购
//    "out_of_stock" = 0;                                       //是否缺货
//    price = "1.70";                                           //现价
//    "region_id" = 1001;
//    "salse_deductions_num" = 0;
//    "salse_num" = "-1";
//    "sku_pricing_type" = Y;
//    "source_type" = 1;
//    "start_time" = "";
//    stock = 0;
//}