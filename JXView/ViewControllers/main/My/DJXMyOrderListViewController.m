//
//  DJXMyOrderListViewController.m
//  JXView
//
//  Created by dujinxin on 15-5-4.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXMyOrderListViewController.h"
#import "JXHorizontalView.h"

@interface DJXMyOrderListViewController(){
    NSMutableArray * _dataArray;
}

@end
@implementation DJXMyOrderListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithData];
    
    CGFloat height = 0;
    if (IOS_VERSION >=7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        height = 64;
    }

    JXHorizontalView * horizontalView = [[JXHorizontalView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT -64-49)];
    horizontalView.style = JXHorizontalViewVariable;
    horizontalView.delegate = self;
    horizontalView.dataSource = self;
    [self.view addSubview:horizontalView];
    [horizontalView reloadData];
    
}
-(void)initWithData{
    _dataArray = [[NSMutableArray alloc]init ];
    for (NSUInteger i = 0; i < 10; i ++) {
        [_dataArray addObject:[NSString stringWithFormat:@"第%d行",i]];
    }
    
}

#pragma mark - JXHorizontalViewDelegate
-(NSInteger)horizontalView:(UIView *)contentView numberOfPagesInHorizontalView:(JXHorizontalView *)horizontalView{
    return 10;
}
-(CGFloat)horizontalView:(JXHorizontalView *)horizontalView widthForPageAtIndex:(NSUInteger)index{
    return SCREEN_WIDTH;
}
-(UIView *)horizontalView:(UIView *)contentView frame:(CGRect)frame viewForPageAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:{
            UITableView * _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
            _table.delegate = self;
            _table.dataSource = self;
            return _table;
            
        }
            break;
        case 1:{
            UILabel * red = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
            red.text = @"hong";
            red.backgroundColor = [UIColor redColor];
            return red;
        }
            break;
        case 2:{
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame;
            [button setTitle:@"点击" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor purpleColor];
            button.titleLabel.font = [UIFont systemFontOfSize:40];
            return button;
        }
            break;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame;
            [button setTitle:@"点击" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor purpleColor];
            button.titleLabel.font = [UIFont systemFontOfSize:40];
            return button;
        }
        default:
            break;
    }
    return nil;
}

- (void)horizontalView:(UIView *)contentView contentForPageAtIndex:(NSUInteger)index{
    
}









-(void)buttonClick:(id)sender{
    NSLog(@"点击了！");
}



#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击：%@",[_dataArray objectAtIndex:indexPath.row]);
}
@end
