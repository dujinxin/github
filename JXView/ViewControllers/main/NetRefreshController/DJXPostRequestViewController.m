//
//  DJXPostRequestViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-27.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXPostRequestViewController.h"
#import "DJXRequestPost.h"
#import "DJXAPPTableViewCell.h"


@interface DJXPostRequestViewController ()
{
    GoodListObj * entity;
}
@end

#define kLimitFreeUrlString  @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d"
#define kGoodsList           @"v2/goods/list"                  // 商品列表


#define kUseTargetAction  0
#define kUseDelegate      1
#define kUseBlock         0
@implementation DJXPostRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [[NSMutableArray alloc] init];
    //发起数据请求
    
    //
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"page"];
    [param setObject:@"10" forKey:@"limit"];
    [param setObject:@"1001" forKey:@"region_id"];
    [param setObject:@"" forKey:@"session_id"];
    [param setObject:@"0" forKey:@"bu_id"];
    [param setObject:@"dm_home_goods" forKey:@"type"];
    [param setObject:@"0" forKey:@"is_stock"];
    //target-action
    if (kUseTargetAction) {
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[GoodListObj className] param:param kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        //        GoodListObj * goodObj = [[GoodListObj alloc]initWithDelegate:self action:nil nApiTag:kApiLimitFreeTag];
        //        [GoodObj startAsynchronous];
        //
        //        GoodListObj * goodObj = [[GoodListObj alloc]init ];
        //        [GoodListObj requestWithDelegate:self urlString:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] kApiTag:kApiLimitFreeTag];
        //
        
        
//        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:[NSString stringWithFormat:@"%@%@?session_id=&region_id=1001",kBaseUrl,kGoodsList] param:param kApiTag:kApiLimitFreeTag];
        
//        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:nil param:param kApiTag:kApiLimitFreeTag];
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:@"GoodListObj" param:param kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[GoodListObj className] param:param success:^(id object) {
            //成功
            GoodsListEntity * good = (GoodsListEntity *)object;
            self.dataArray = (NSMutableArray *)good.goodsArray;
            [self.tableView reloadData];
            [self createFooterView];
        } failure:^(id object) {
            //失败
        }];
    }
    
    //    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //    [params setValue:@"10" forKey:@"limit"];
    //    [params setValue:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"countPage"];
    //    [entity requestWithMentod:kRequestMethodPost WithUrl:[NSString stringWithFormat:@"%@%@",kBasicUrl,kGoodsList] param:params tag:12 delegate:self];
    
    //    [[PSNetTrans getInstance] buy_getGoodsList:self
    //                                          type:[params objectForKey:@"type"]
    //                                         bu_id:[params objectForKey:@"bu_id"]
    //                                   bu_brand_id:[params objectForKey:@"bu_brand_id"]
    //                                bu_category_id:[params objectForKey:@"bu_category_id"]
    //                                   bu_goods_id:[params objectForKey:@"bu_goods_id"]
    //                                         dm_id:[params objectForKey:@"dm_id"]
    //                                          page:[NSString stringWithFormat:@"%d",countPage]
    //                                         limit:@"10"
    //                                         order:[params objectForKey:@"order"]
    //                                        tag_id:[params objectForKey:@"tag_id"]
    //                                        ApiTag:t_API_PS_GOODS_LIST is_stock:[params objectForKey:@"is_stock"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    AppModel *model = [_dataArray objectAtIndex:indexPath.row];
    //    NSString *detailString = [NSString stringWithFormat:kDetailUrlString,model.applicationId];
    //    DetailViewController *detail = [[DetailViewController alloc] init];
    //    detail.detailUrlString = detailString;
    //    [self.navigationController pushViewController:detail animated:YES];
    //    [detail release];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    DJXAPPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DJXAPPTableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    DJXRequestPost *model = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
    [cell.image setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"goods_image"]]];
    cell.name.text = [dict objectForKey:@"goods_name"];
//    [cell.image setImageWithURL:[NSURL URLWithString:model.goods_image]];
//    cell.name.text = model.goods_name;
//    cell.detail.text = [NSString stringWithFormat:@"分享:%@次 收藏:%@次 下载:%@次",model.price,model.,model.downloads];
    return cell;
}
#pragma mark - RefreshMethod

//刷新调用的方法
-(void)refreshTableViewDataSource
{
    
    self.currentPage = 1;
    self.requestType = request_type_refreshData;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"page"];
    [param setObject:@"10" forKey:@"limit"];
    [param setObject:@"1001" forKey:@"region_id"];
    [param setObject:@"" forKey:@"session_id"];
    [param setObject:@"0" forKey:@"bu_id"];
    [param setObject:@"dm_home_goods" forKey:@"type"];
    [param setObject:@"0" forKey:@"is_stock"];
    //发起数据请求
    //target-action
    if (kUseTargetAction) {
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[GoodListObj className] param:param kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
//        [[DJXRequestManager sharedInstance] requestWithMentod:kRequestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kApiLimitFreeTag delegate:self];
    
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:[NSString stringWithFormat:@"%@%@?session_id=&region_id=1001",kBaseUrl,kGoodsList] param:param kApiTag:kApiLimitFreeTag];
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:nil param:param kApiTag:kApiLimitFreeTag];
        
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[GoodListObj className] param:param kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[GoodListObj className] param:param success:^(id object) {
            //成功
            [self.dataArray removeAllObjects];
            GoodsListEntity * good = (GoodsListEntity *)object;
            self.dataArray = (NSMutableArray *)good.goodsArray;
            [self.tableView reloadData];
            [self createFooterView];
        } failure:^(id object) {
            //失败
        }];
    }
}
//加载调用的方法
-(void)reloadTableViewDataSource
{
    
    self.currentPage ++;
    self.requestType = request_type_loadMoreData;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"page"];
    [param setObject:@"10" forKey:@"limit"];
    [param setObject:@"1001" forKey:@"region_id"];
    [param setObject:@"" forKey:@"session_id"];
    [param setObject:@"0" forKey:@"bu_id"];
    [param setObject:@"dm_home_goods" forKey:@"type"];
    [param setObject:@"0" forKey:@"is_stock"];
    
    //发起数据请求
    //target-action
    if (kUseTargetAction) {
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[GoodListObj className] param:param kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
//        [[DJXRequestManager sharedInstance] requestWithMentod:kRequestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kApiLimitFreeTag delegate:self];
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:[NSString stringWithFormat:@"%@%@?session_id=&region_id=1001",kBaseUrl,kGoodsList] param:param kApiTag:kApiLimitFreeTag];
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:nil param:param kApiTag:kApiLimitFreeTag];
        
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[GoodListObj className] param:param kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[GoodListObj className] param:param success:^(id object) {
            //成功
            GoodsListEntity * good = (GoodsListEntity *)object;
            [self.dataArray addObjectsFromArray:(NSMutableArray *)good.goodsArray];
            [self.tableView reloadData];
            [self createFooterView];
        } failure:^(id object) {
            //失败
        }];
    }
}
#pragma mark - RequestManagerDelegate
-(void)responseSuccessObj:(id)responseObj tag:(DJXApiTag)tag{
    GoodsListEntity * good = (GoodsListEntity *)responseObj;
    if (self.requestType == request_type_loadMoreData) {
        [self.dataArray addObjectsFromArray:good.goodsArray];
        
    }else if (self.requestType == request_type_refreshData){
        [self.dataArray removeAllObjects];
        self.dataArray = (NSMutableArray *)good.goodsArray;
        
    }else{
        self.dataArray = (NSMutableArray *)good.goodsArray;
        
    }
    [self.tableView reloadData];
    [self createFooterView];
    
}
#pragma mark - actionMethod
-(void)responseSuccess:(id)object{
    GoodsListEntity * good = (GoodsListEntity *)object;
    if (self.requestType == request_type_loadMoreData) {
        [self.dataArray addObjectsFromArray:good.goodsArray];
        
    }else if (self.requestType == request_type_refreshData){
        [self.dataArray removeAllObjects];
        self.dataArray = (NSMutableArray *)good.goodsArray;
        
    }else{
        self.dataArray = (NSMutableArray *)good.goodsArray;
        
    }
    
    [self.tableView reloadData];
    [self createFooterView];
}
#pragma mark - delegateMethod
-(void)responseSuccess:(id)arrData tag:(DJXApiTag)tag{
    if (tag == kApiLimitFreeTag) {
//        if (self.requestType == request_type_loadMoreData) {
//            [self.dataArray addObjectsFromArray:(NSMutableArray *)arrData];
//            
//        }else if (self.requestType == request_type_refreshData){
//            [self.dataArray removeAllObjects];
//            self.dataArray = (NSMutableArray *)arrData;
//            
//        }else{
//            self.dataArray = (NSMutableArray *)arrData;
//            
//        }
        NSMutableArray * good = (NSMutableArray *)arrData;
        if (self.requestType == request_type_loadMoreData) {
            [self.dataArray addObjectsFromArray:good];
            
        }else if (self.requestType == request_type_refreshData){
            [self.dataArray removeAllObjects];
            self.dataArray = (NSMutableArray *)good;
            
        }else{
            self.dataArray = (NSMutableArray *)good;
            
        }
        [self.tableView reloadData];
        [self createFooterView];
    }
}



@end
