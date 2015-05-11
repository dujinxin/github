//
//  DJXAFNRefreshViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-25.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXAFNRefreshViewController.h"
#import "appEntity.h"
#import "DJXAPPTableViewCell.h"
#import "TestRequestObj.h"


@interface DJXAFNRefreshViewController ()

@end

#define kLimitFreeUrlString @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%ld"
#define kBasicUrl            @"http://app.yonghui.cn:8081/"
#define kGoodsList           @"v2/goods/list"                  // 商品列表


#define kUseTargetAction 0
#define kUseDelegate     1
#define kUseBlock        0
@implementation DJXAFNRefreshViewController

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
        [[DJXAFNRequestManager sharedInstance] requestWithTarget:self action:@selector(responseSuccess:) url:[NSString stringWithFormat:kLimitFreeUrlString,(long)self.currentPage] param:nil tag:kAFNApiLimitFreeTag];
    }
    //代理
    if (kUseDelegate) {

//        [[DJXAFNRequestManager sharedInstance] requestWithDelegate:self action:nil url:kLimitFreeUrlString pageCount:self.currentPage];
        
        [[TestRequestObj sharedManager] request:self url:kLimitFreeUrlString pageCount:self.currentPage];
    }
    //block
    if (kUseBlock) {
        [[DJXAFNRequestManager sharedInstance] requestWithBlock:[NSString stringWithFormat:kLimitFreeUrlString,self.currentPage] param:nil tag:kAFNApiLimitFreeTag success:^(id object) {
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
    appEntity *model = [self.dataArray objectAtIndex:indexPath.row];
    
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
        
    }
    //代理
    if (kUseDelegate) {
        [[TestRequestObj sharedManager] request:self url:kLimitFreeUrlString pageCount:self.currentPage];
    }
    //block
    if (kUseBlock) {
        
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
        
    }
    //代理
    if (kUseDelegate) {
        [[TestRequestObj sharedManager] request:self url:kLimitFreeUrlString pageCount:self.currentPage];
    }
    //block
    if (kUseBlock) {
        
    }
}
#pragma mark - RequestManagerDelegate
-(void)responseSuccessObj:(id)netTransObj nTag:(DJXAFNApiTag)nTag{
    
}
#pragma mark - actionMethod
-(void)responseSuccess:(id)object{
    if (self.requestType == request_type_loadMoreData) {
        [self.dataArray addObjectsFromArray:(NSMutableArray *)object];
        
    }else if (self.requestType == request_type_refreshData){
        [self.dataArray removeAllObjects];
        self.dataArray = (NSMutableArray *)object;
        
    }else{
        self.dataArray = (NSMutableArray *)object;
        
    }
    [self.tableView reloadData];
    [self createFooterView];
}
#pragma mark - delegateMethod
-(void)afnResponseSuccess:(id)arrData tag:(DJXAFNApiTag)tag{
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
