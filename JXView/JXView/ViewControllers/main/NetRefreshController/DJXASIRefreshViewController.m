//
//  DJXASIRefreshViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-25.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXASIRefreshViewController.h"
#import "AppModel.h"


#define kLimitFreeUrlString @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d"
@interface DJXASIRefreshViewController ()
{
    NSMutableArray *_dataArray;
}
@end

@implementation DJXASIRefreshViewController


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
    _dataArray = [[NSMutableArray alloc] init];
    //发起数据请求
    [[RequestManager getInstance]request:self url:kLimitFreeUrlString pageCount:1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//分类
- (void)leftItemClicked{
    
}
//设置
- (void)rightItemClicked{
    
}
#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"App";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    AppModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.applicationId;
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
    
    [[RequestManager getInstance]request:self url:kLimitFreeUrlString pageCount:_currentPage];
}
//加载调用的方法
-(void)reloadTableViewDataSource
{
    
    self.currentPage ++;
    self.requestType = request_type_loadMoreData;
    
    [[RequestManager getInstance]request:self url:kLimitFreeUrlString pageCount:_currentPage];
    
}
#pragma mark - RequestManagerDelegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    
}
-(void)responseSuccess:(id)arrData nTag:(int)nTag{
    if (nTag == t_Api_limitFree_tag) {
        if (self.requestType == request_type_loadMoreData) {
            [_dataArray addObjectsFromArray:(NSMutableArray *)arrData];
        }else if (self.requestType == request_type_refreshData){
            [_dataArray removeAllObjects];
            _dataArray = (NSMutableArray *)arrData;
        }else{
            _dataArray = (NSMutableArray *)arrData;
        }
        [self.tableView reloadData];
        [self createFooterView];
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
