//
//  DJXWaterFlowViewController.m
//  JXView
//
//  Created by dujinxin on 15-7-22.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXWaterFlowViewController.h"
#import "DJXCollectionWaterFlowCell.h"
#import "DJXWaterflowViewFlowLayout.h"
#import "DJXCollectionReusableView.h"
#import "DJXCachePost.h"

#import "SDWebImageManager.h"

static NSString  * const cellIdentifier = @"Cell";
static NSString  * const headerIdentifier = @"Header";

static  CGFloat const  DJXGoodCollectionCellSPACE = 10;

@interface DJXWaterFlowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView * _collectionView;
    NSMutableArray   * _dataArray;
    NSInteger          _currentPage;
    
    NSMutableArray   * colArr;
}

@end

@implementation DJXWaterFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor purpleColor]];
    //[self.navigationController.navigationBar setAlpha:0.5];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleViewWithTitle:@"collectionView瀑布流"];
    _currentPage = 1;
    _dataArray = [[NSMutableArray alloc] init];
    colArr = [[NSMutableArray alloc] init ];
    
    
    DJXWaterflowViewFlowLayout *flowLayout= [[DJXWaterflowViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    //flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.minimumLineSpacing = 10.0;//行间距(最小值)
//    flowLayout.minimumInteritemSpacing = 10.0;//item间距(最小值)
//    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH -3* DJXGoodCollectionCellSPACE)/2,(SCREEN_WIDTH -3* DJXGoodCollectionCellSPACE)/2/2*2.5);//item的大小
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//设置section的边距,默认(0,0,0,0)
    //flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 120);
    //flowLayout.footerReferenceSize = CGSizeMake(320, 20);
    //第二个参数是cell的布局
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCREEN_HEIGHT -49) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    //1 注册复用cell(cell的类型和标识符)(可以注册多个复用cell, 一定要保证重用标示符是不一样的)注册到了collectionView的复用池里
    [_collectionView registerClass:[DJXCollectionWaterFlowCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    //第一个参数:返回的View类型
    //第二个参数:设置View的种类(header, footer)
    //第三个参数:设置重用标识符
    //[_collectionView registerClass:[DJXCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    //    [collectionView registerClass:[FootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    [self.view addSubview:_collectionView];
    
    
    
    
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [weakSelf requestWithPage:_currentPage];
    }];
    _collectionView.header.autoChangeAlpha = YES;
    [_collectionView.header beginRefreshing];
    
    // 上拉加载
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _currentPage ++;
        [weakSelf requestWithPage:_currentPage];
    }];
    // 默认先隐藏footer
    _collectionView.footer.hidden = YES;
    _collectionView.footer.backgroundColor = [UIColor yellowColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    DJXCachePost * model = _dataArray[indexPath.item];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.goods_image]]];
    //UIImage *image = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:model.goods_image]];
    if (!model.goods_image) {
        return CGSizeZero;
    }
    if (!image){
        return CGSizeZero;
    }
    float height = [self imgHeight:image.size.height Width:image.size.width];
//    if (indexPath.item %3 == 0){
//        height *= 1.2;
//    }else if (indexPath.item %3 == 1){
//        height *= 1.0;
//    }else{
//        height *= 0.8;
//    }

    return CGSizeMake(90,height);
}
//单元格中的间隙
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);// {5,5,5,5};
    return edgeInsets;
}
-(float)imgHeight:(float)height Width:(float)width{
    //单元格固定宽度为100   高度/宽度 = 压缩后高/100
    float newHeigth = height /width *100;
    return newHeigth;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DJXCollectionWaterFlowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DJXCollectionWaterFlowCell alloc]init ];
    }
    
    DJXCachePost * model = [_dataArray objectAtIndex:indexPath.item];
    cell.image = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:model.goods_image]];
//    [cell.goodImage setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:nil];
//    cell.goodName.text = model.goods_name;
//    [cell setPriceText:model.price andNewPirce:model.discount_price];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader ]){
        reuseIdentifier = headerIdentifier;
    }else{
        reuseIdentifier = nil;
        return nil;
    }
    
    DJXCollectionReusableView *headView =  [collectionView dequeueReusableSupplementaryViewOfKind :UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    
    //    DJXCachePost * model = [_dataArray objectAtIndex:indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        [headView.headImage setImageWithURL:[NSURL URLWithString:@"http://image.yonghui.cn:8088/amp-resource-webin/resource/E73ABFE919E0677DDB1126606A1A66C2?thumbnail=180:180"]];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        //        view.backgroundColor = [UIColor lightGrayColor];
        //        label.text = [NSString stringWithFormat:@"这是footer:%d",indexPath.section];
    }
    return headView;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击：%d",indexPath.row);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        NSLog(@"这个不可点击");
        return NO;
    }
    return YES;
}
#pragma mark - RequestMethod
- (void)requestWithPage:(NSInteger)page{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [param setObject:@"10" forKey:@"limit"];
    [param setObject:@"1001" forKey:@"region_id"];
    [param setObject:@"" forKey:@"session_id"];
    [param setObject:@"0" forKey:@"bu_id"];
    [param setObject:@"dm_home_goods" forKey:@"type"];
    [param setObject:@"0" forKey:@"is_stock"];
    [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[GoodListCacheObj className] param:param kApiTag:kApiLimitFreeTag];
}
#pragma mark - RequestManagerDelegate
-(void)responseFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    NSLog(@"status:%@ error:%@",status,errMsg);
    if (tag == kApiLimitFreeTag) {
        if (_currentPage > 1) {
            [_collectionView.footer endRefreshing];
        }else{
            [_collectionView.header endRefreshing];
        }
    }
}
-(void)responseSuccess:(id)responseObj tag:(DJXApiTag)tag{
    
    if (tag == kApiLimitFreeTag) {
        if (_currentPage > 1) {
            [_dataArray addObjectsFromArray:(NSMutableArray *)responseObj];
            [_collectionView.footer endRefreshing];
            [_collectionView reloadData];
            
        }else{
            _dataArray = (NSMutableArray *)responseObj;
            [_collectionView reloadData];
            [_collectionView.header endRefreshing];
        }
        if (_dataArray.count >= 10) {
            _collectionView.footer.hidden = NO;
        }
    }
    NSLog(@"colArr:%@ Footer:%f contentSize:%f",nil,_collectionView.footer.frame.origin.y,_collectionView.contentSize.height);
}
@end