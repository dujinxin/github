//
//  DJXRequestAndRefreshViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-27.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXRequestAndRefreshViewController.h"
#import "DJXGetRequestViewController.h"
#import "DJXPostRequestViewController.h"
#import "DJXASIRefreshViewController.h"
#import "DJXAFNRefreshViewController.h"
#import "DJXAFNRefreshTestViewController.h"
#import "DJXBottomAutomaticLoadingViewController.h"
#import "DJXRefreshAndLoadViewController.h"

@interface DJXRequestAndRefreshViewController ()
{
    NSMutableArray * _dataArray;
}
@end

@implementation DJXRequestAndRefreshViewController

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
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x704fa2)];
    self.navigationItem.rightBarButtonItems =  [self getNavigationItems:self selector:@selector(count) title:@"点击右边" style:kDoubleLineWords isLeft:NO];
    [self setTitleViewWithTitle:@"促销"];
    
    _dataArray = [[NSMutableArray alloc]initWithObjects:@"DJXGetRequest",@"DJXPostRequest", nil];
    // Do any additional setup after loading the view.
    UITableView * _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            DJXGetRequestViewController * rlvc = [[DJXGetRequestViewController alloc]init ];
            [self.navigationController pushViewController:rlvc animated:YES];
        }
            break;
        case 1:{
            DJXPostRequestViewController * rlvc = [[DJXPostRequestViewController alloc]init ];
            [self.navigationController pushViewController:rlvc animated:YES];
        }
            break;
            
        default:
            break;
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

