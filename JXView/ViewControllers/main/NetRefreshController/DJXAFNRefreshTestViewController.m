//
//  DJXAFNRefreshTestViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-25.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXAFNRefreshTestViewController.h"
#import "appEntity.h"


@interface DJXAFNRefreshTestViewController ()
{
    AFNRequestTestModel * entity;
}
@end

#define kLimitFreeUrlString @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d"
#define kBasicUrl            @"http://app.yonghui.cn:8081/"
#define kGoodsList           @"v2/goods/list"                  // 商品列表


#define kUseTargetAction 0
#define kUseDelegate     1
#define kUseBlock        0
@implementation DJXAFNRefreshTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        entity = [[AFNRequestTestModel alloc]init ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [[NSMutableArray alloc] init];
    //发起数据请求
    //target-action
    if (kUseTargetAction) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag delegate:self action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag delegate:self];
    }
    //block
    if (kUseBlock) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:12 success:^(id object) {
            //成功
            self.dataArray = (NSMutableArray *)object;
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
    static NSString *cellId = @"App";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        imageView.tag = indexPath.row + 10;
        [cell.contentView addSubview:imageView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200, 80)];
        label.tag = indexPath.row + 5000;
        [cell.contentView addSubview:label];
    }
    appEntity *model = [self.dataArray objectAtIndex:indexPath.row];
    
    UIImageView * imageView = (UIImageView *) [cell.contentView viewWithTag:indexPath.row + 10];
    [imageView setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    UILabel * label = (UILabel *)[cell.contentView viewWithTag:indexPath.row + 5000];
    label.text = model.name;
    
    //    cell.appTimeLabel.text = model.expireDatetime;
    //    cell.appPriceLabel.text = model.lastPrice;
    //    cell.appCategoryLabel.text = model.categoryName;
    //    [cell.appStarView setStarViewWithStar:[model.starCurrent floatValue]];
    //    cell.appTipLabel.text = [NSString stringWithFormat:@"分享:%@次 收藏:%@次 下载:%@次",model.shares,model.favorites,model.downloads];
    return cell;
}
#pragma mark - RefreshMethod

//刷新调用的方法
-(void)refreshTableViewDataSource
{
    
    self.currentPage = 1;
    self.requestType = request_type_refreshData;
    
    //发起数据请求
    //target-action
    if (kUseTargetAction) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag delegate:self action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag delegate:self];
    }
    //block
    if (kUseBlock) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag success:^(id object) {
            //成功
            [self.dataArray removeAllObjects];
            self.dataArray = (NSMutableArray *)object;
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
    
    //发起数据请求
    //target-action
    if (kUseTargetAction) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag delegate:self action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag delegate:self];
    }
    //block
    if (kUseBlock) {
        [entity requestWithMentod:kRequestTestMethodGet WithUrl:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:12 success:^(id object) {
            //成功
            [self.dataArray addObjectsFromArray:(NSMutableArray *)object];
            [self.tableView reloadData];
            [self createFooterView];
        } failure:^(id object) {
            //失败
        }];
    }
}
#pragma mark - RequestManagerDelegate
-(void)responseSuccessObj:(id)netTransObj nTag:(DJXAFNApiTag)nTag{
    
}
#pragma mark - actionMethod  ---- 加载更多数据混乱。。。待修正。。。
-(void)responseSuccess:(id)object{
    if (self.requestType == request_type_loadMoreData) {
        [self.dataArray addObjectsFromArray:entity.objArray];
        
    }else if (self.requestType == request_type_refreshData){
        [self.dataArray removeAllObjects];
        self.dataArray = (NSMutableArray *)entity.objArray;
        
    }else{
        self.dataArray = (NSMutableArray *)entity.objArray;
        
    }
    [self.tableView reloadData];
    [self createFooterView];
}
#pragma mark - delegateMethod
-(void)afnTestResponseSuccess:(id)arrData tag:(DJXAFNApiTag)tag{
    if (tag == kAFNApiLimitFreeTag) {
        if (self.requestType == request_type_loadMoreData) {
            [self.dataArray addObjectsFromArray:(NSMutableArray *)arrData];
            
        }else if (self.requestType == request_type_refreshData){
            [self.dataArray removeAllObjects];
            self.dataArray = (NSMutableArray *)arrData;
            
        }else{
            self.dataArray = (NSMutableArray *)arrData;
            
        }
        [self.tableView reloadData];
        [self createFooterView];
    }
}



@end
