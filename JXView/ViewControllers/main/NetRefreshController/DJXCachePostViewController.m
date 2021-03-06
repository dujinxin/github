//
//  DJXCachePostViewController.m
//  JXView
//
//  Created by dujinxin on 15-4-15.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXCachePostViewController.h"
#import "DJXCachePost.h"
#import "DJXAPPTableViewCell.h"


@interface DJXCachePostViewController ()
{
    GoodListCacheObj * entity;
}
@end

#define kLimitFreeUrlString  @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d"
#define kGoodsList           @"v2/goods/list"                  // 商品列表


#define kUseTargetAction  0
#define kUseDelegate      1
#define kUseBlock         0

@implementation DJXCachePostViewController

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
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[GoodListCacheObj className] param:param kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
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
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:@"GoodListCacheObj" param:param kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[GoodListCacheObj className] param:param success:^(id object) {
            //成功
            GoodsListCacheEntity * good = (GoodsListCacheEntity *)object;
            self.dataArray = (NSMutableArray *)good.goodsArray;
            [self.tableView reloadData];
            [self createFooterView];
        } failure:^(id object) {
            //失败
        }];
    }
    
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
    DJXCachePost *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.image setImageWithURL:[NSURL URLWithString:model.goods_image]];
    cell.name.text = model.goods_name;
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
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[GoodListCacheObj className] param:param kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        //        [[DJXRequestManager sharedInstance] requestWithMentod:kRequestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kApiLimitFreeTag delegate:self];
        
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:[NSString stringWithFormat:@"%@%@?session_id=&region_id=1001",kBaseUrl,kGoodsList] param:param kApiTag:kApiLimitFreeTag];
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:nil param:param kApiTag:kApiLimitFreeTag];
        
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[GoodListCacheObj className] param:param kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[GoodListCacheObj className] param:param success:^(id object) {
            //成功
            [self.dataArray removeAllObjects];
            GoodsListCacheEntity * good = (GoodsListCacheEntity *)object;
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
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[GoodListCacheObj className] param:param kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        //        [[DJXRequestManager sharedInstance] requestWithMentod:kRequestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kApiLimitFreeTag delegate:self];
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:[NSString stringWithFormat:@"%@%@?session_id=&region_id=1001",kBaseUrl,kGoodsList] param:param kApiTag:kApiLimitFreeTag];
        
        //        [GoodListObj requestWithClass:@"GoodListObj" delegate:self urlString:nil param:param kApiTag:kApiLimitFreeTag];
        
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[GoodListCacheObj className] param:param kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[GoodListCacheObj className] param:param success:^(id object) {
            //成功
            GoodsListCacheEntity * good = (GoodsListCacheEntity *)object;
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
    GoodsListCacheEntity * good = (GoodsListCacheEntity *)responseObj;
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
-(void)responseFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    NSLog(@"status:%@ error:%@",status,errMsg);
}
#pragma mark - actionMethod
-(void)responseSuccess:(id)object{
    GoodsListCacheEntity * good = (GoodsListCacheEntity *)object;
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
-(void)responseSuccess:(id)responseObj tag:(DJXApiTag)tag{
    if (tag == kApiLimitFreeTag) {
        if (self.requestType == request_type_loadMoreData) {
            [self.dataArray addObjectsFromArray:(NSMutableArray *)responseObj];
            
        }else if (self.requestType == request_type_refreshData){
            [self.dataArray removeAllObjects];
            self.dataArray = (NSMutableArray *)responseObj;
            
        }else{
            self.dataArray = (NSMutableArray *)responseObj;
            
        }
        [self.tableView reloadData];
        [self createFooterView];
    }
}

@end
