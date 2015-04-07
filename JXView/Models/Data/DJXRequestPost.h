//
//  DJXRequestPost.h
//  JXView
//
//  Created by dujinxin on 15-3-27.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXRequest.h"

@interface DJXRequestPost : NSObject

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
@interface GoodsListEntity : NSObject
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSString       *total;
@property (nonatomic, strong) NSString       *active_info;
@property (nonatomic, strong) NSString       *title;
@property (nonatomic, strong) NSString       *content;
@property (nonatomic, strong) NSString       *goods_weight;
- (void)setGoodsListEntity:(NSMutableArray *)listArray;

@end

@interface GoodListObj : DJXRequest

@end
