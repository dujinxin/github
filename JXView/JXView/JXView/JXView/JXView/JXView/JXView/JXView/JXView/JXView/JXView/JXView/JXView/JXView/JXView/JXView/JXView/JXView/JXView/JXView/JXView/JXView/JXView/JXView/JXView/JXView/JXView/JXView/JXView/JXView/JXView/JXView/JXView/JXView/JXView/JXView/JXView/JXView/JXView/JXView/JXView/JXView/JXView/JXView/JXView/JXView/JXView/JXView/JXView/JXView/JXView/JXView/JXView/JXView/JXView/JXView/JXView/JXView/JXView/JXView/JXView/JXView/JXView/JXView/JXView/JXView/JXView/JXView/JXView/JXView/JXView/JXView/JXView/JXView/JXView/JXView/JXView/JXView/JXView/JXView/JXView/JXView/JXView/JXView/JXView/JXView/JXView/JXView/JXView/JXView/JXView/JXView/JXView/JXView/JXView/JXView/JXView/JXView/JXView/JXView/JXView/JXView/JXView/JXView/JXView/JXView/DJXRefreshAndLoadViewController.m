//
//  DJXRefreshAndLoadViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-2.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXRefreshAndLoadViewController.h"



#define kLimitFreeUrlString @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d"
@interface DJXRefreshAndLoadViewController ()
{
    NSMutableArray *_dataArray;
    NSInteger _currentPage;//用于标识当前页
}
@end

@implementation DJXRefreshAndLoadViewController


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
    
    //key 多语言文件中写的key值,tbl 要填写多语言文件的名称:MyFree comment 预留参数，一般设为nil
    
    _dataArray = [[NSMutableArray alloc] init];
    //发起数据请求
//    [HttpRequest requestWithUrlString:[NSString stringWithFormat:kLimitFreeUrlString,1] target:self];
#if 0
    //下拉刷新
    [_tableView setPullToRefreshHandler:^{
        //写下拉刷新的代码
        //重新请求第一页的数据
        [HttpRequest requestWithUrlString:[NSString stringWithFormat:kLimitFreeUrlString,1] target:self apiType:kRefreshType];
    }];
    //加载更多
    [_tableView setPullToLoadMoreHandler:^{
        //写加载更多的代码
        _currentPage++;
        [HttpRequest requestWithUrlString:[NSString stringWithFormat:kLimitFreeUrlString,_currentPage] target:self apiType:kLoadMoreType];
    }];
#endif
}

//分类
- (void)leftItemClicked{
    
}
//设置
- (void)rightItemClicked{
   
}

- (void)loadDataWithCategoryId:(NSString *)cateId{
    NSLog(@"categoryId:%@",cateId);
    //最初请求限免app的地址
    NSString *basicString = [NSString stringWithFormat:kLimitFreeUrlString,1];
    //
    NSString *cateString = [basicString stringByAppendingFormat:@"&cate_id=%@",cateId];
    //清旧数据
    [_dataArray removeAllObjects];
    //让tableView显示为空,等着新的数据的到来
    [_tableView reloadData];
    if ([cateId integerValue]==0) {
        //全部
//        [HttpRequest requestWithUrlString:basicString target:self];
    }else{
        //不同的分类
//        [HttpRequest requestWithUrlString:cateString target:self];
    }
}

#pragma mark - UISearchBarDelegate
//点击键盘的搜索按钮时，触发此方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search:%@",searchBar.text);
    NSString *search = searchBar.text;
    //如果参数带中文，需要对中文参数进行转码处理，否则服务器可能无法正确识别中文参数
    //stringByAddingPercentEscapesUsingEncoding 固定的方法，将中文做一个百分比的字符转义
    NSString *searchKey = [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"searchKey:%@",searchKey);
    //用转码后的中文参数，拼接请求地址
//    NSString *searchString = [NSString stringWithFormat:kSearchUrlString,searchKey];
//    //正向传值
//    SearchResultViewController *searchVc = [[SearchResultViewController alloc] init];
//    searchVc.searchString = searchString;
//    [self.navigationController pushViewController:searchVc animated:YES];
//    [searchVc release];
//    //收键盘
//    [searchBar resignFirstResponder];
}

#ifdef 0
#pragma mark - httpRequestDelegate
- (void)httpRequestFinished:(HttpRequest *)request{
    if (request.downloadData) {
        //json解析
        if ([request.apiType isEqualToString:kRefreshType]) {
            //刷新的request
            _currentPage = 1;
            [_dataArray removeAllObjects];
            //告诉tableView刷新完成
            [_tableView refreshFinished];
        }else if ([request.apiType isEqualToString:kLoadMoreType]){
            //告诉tableView 加载更多完成
            [_tableView loadMoreFinished];
        }
        
        id myResult = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)myResult;
            NSArray *array = [dic objectForKey:@"applications"];
            for (NSDictionary *appDic in array) {
                AppModel *model = [[AppModel alloc] init];
                //字典会根据key值去model中找与key值名称相同的变量，并为变量赋上value值
                //setValuesForKeysWithDictionary 内部会自动执行多次[model setValue: forKey:];方法,key和value均来自于appDic
                [model setValuesForKeysWithDictionary:appDic];
                //[model setValue:<#(id)#> forKey:<#(NSString *)#>]
                [_dataArray addObject:model];
                NSLog(@"name:%@",model.name);
                [model release];
            }
        }
        [_tableView reloadData];
    }
}

- (void)httpRequestFailed:(HttpRequest *)request{
    
}
#endif

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSString *detailString = [NSString stringWithFormat:kDetailUrlString,model.applicationId];
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.detailUrlString = detailString;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"App";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]autorelease];
    }
    AppModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    cell.titleLabel.text = model.name;
//    cell.appTimeLabel.text = model.expireDatetime;
//    cell.appPriceLabel.text = model.lastPrice;
//    cell.appCategoryLabel.text = model.categoryName;
//    [cell.appStarView setStarViewWithStar:[model.starCurrent floatValue]];
//    cell.appTipLabel.text = [NSString stringWithFormat:@"分享:%@次 收藏:%@次 下载:%@次",model.shares,model.favorites,model.downloads];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
