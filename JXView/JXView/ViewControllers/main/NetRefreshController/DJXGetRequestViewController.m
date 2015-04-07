//
//  DJXRequestViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXGetRequestViewController.h"
#import "DJXRequestGet.h"
#import "DJXAPPTableViewCell.h"


@interface DJXGetRequestViewController ()
{
    ApplicationObj * entity;
}
@end

#define kLimitFreeUrlString  @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d"
#define kBasicUrl            @"http://app.yonghui.cn:8081/"
#define kGoodsList           @"v2/goods/list"                  // 商品列表


#define kUseTargetAction  0
#define kUseDelegate      1
#define kUseBlock         0
@implementation DJXGetRequestViewController

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
    //target-action
    if (kUseTargetAction) {
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[ApplicationObj className] param:nil kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
//        ApplicationObj * applicationObj = [[ApplicationObj alloc]initWithDelegate:self action:nil nApiTag:kApiLimitFreeTag];
//        [applicationObj startAsynchronous];
        //
//        ApplicationObj * applicationObj = [[ApplicationObj alloc]init ];
//        [applicationObj requestWithDelegate:self urlString:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] kApiTag:kApiLimitFreeTag];
        //
//        [ApplicationObj requestWithClass:@"ApplicationObj" delegate:self urlString:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] kApiTag:kApiLimitFreeTag];
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[ApplicationObj className] urlString:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[ApplicationObj className] param:nil success:^(id object) {
            //成功
            self.dataArray = (NSMutableArray *)object;
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
    DJXRequestGet *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.image setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    cell.name.text = model.name;
    cell.detail.text = [NSString stringWithFormat:@"分享:%@次 收藏:%@次 下载:%@次",model.shares,model.favorites,model.downloads];
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
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[ApplicationObj className] param:nil kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[ApplicationObj className] urlString:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[ApplicationObj className] param:nil success:^(id object) {
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
        [[DJXRequestManager sharedInstance] requestWithTarget:self className:[ApplicationObj className] param:nil kApiTag:kApiLimitFreeTag action:@selector(responseSuccess:)];
    }
    //代理
    if (kUseDelegate) {
        [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[ApplicationObj className] urlString:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] kApiTag:kApiLimitFreeTag];
    }
    //block
    if (kUseBlock) {
        [[DJXRequestManager sharedInstance] requestWithBlock:[ApplicationObj className] param:nil success:^(id object)  {
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
-(void)responseSuccessObj:(id)netTransObj nTag:(DJXApiTag)nTag{
    
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
-(void)responseSuccess:(id)arrData tag:(DJXApiTag)tag{
    if (tag == kApiLimitFreeTag) {
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