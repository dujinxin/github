//
//  DJXMyViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-6.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXMyViewController.h"

#import "DJXShakeViewController.h"
#import "DJXScanViewController.h"
#import "DJXShareViewController.h"

#import "JXAlertView.h"
#import "DJXShareManager.h"

#import "DJXAnimationViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface DJXMyViewController ()<JXAlertViewDelegate>
{
    NSMutableArray * _dataArray;
}
@end

@implementation DJXMyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc]init ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTranslucent:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [_dataArray addObject:@"摇一摇"];
    [_dataArray addObject:@"扫一扫"];
    [_dataArray addObject:@"JXAlertView自定义视图"];
    [_dataArray addObject:@"JXAlertView文本信息"];
    [_dataArray addObject:@"分享"];
    [_dataArray addObject:@"音量"];
    [_dataArray addObject:@"动画"];
    self.navigationItem.title = @"我的";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64) style:UITableViewStylePlain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            DJXShakeViewController * shakeVC = [[DJXShakeViewController alloc]init ];
            shakeVC.view.backgroundColor = [UIColor redColor];
            [self.navigationController pushViewController:shakeVC animated:YES];
        }
            break;
        case 1:
        {
            DJXScanViewController * scanVC = [[DJXScanViewController alloc]init ];
            scanVC.view.backgroundColor = [UIColor redColor];
            [self.navigationController pushViewController:scanVC animated:YES];
        }
            break;
        case 2:
        {
            NSArray * array = [NSArray arrayWithObjects:@"取消",@"确定",@"测试", nil];
            UIView * test = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
            test.backgroundColor = [UIColor grayColor];
            JXAlertView * alert = [[JXAlertView alloc]initWithTitle:nil customView:test delegate:self buttonTitles:array];
            alert.delegate = self;
            [alert show];
        }
            break;
        case 3:
        {
            NSArray * array = [NSArray arrayWithObjects:@"取消",@"确定",@"测试", nil];
            JXAlertView * alert = [[JXAlertView alloc]initWithTitle:@"标题" message:@"手术方式的立方时空的房间数量的" delegate:self buttonTitles:array];
            alert.delegate = self;
            [alert showInView:self.view animate:NO];
        }
            break;
        case 4:
        {
            [DJXShareManager showCustomShareListViewWithContent:@"内容" title:@"标题" imageUrl:@"图片" url:@"网址" description:@"描述" block:nil VController:self shareType:ShareTypeSinaWeibo, nil];
        }
            break;
        case 5:
        {
            MPMusicPlayerController * mp = [MPMusicPlayerController applicationMusicPlayer];
            mp.volume = 0.5;
            
            
        }
            break;
        case 6:
        {
            DJXAnimationViewController * avc = [[DJXAnimationViewController alloc]init ];
            [self.navigationController pushViewController:avc animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - JXAlertViewDelegate
- (void)alertView:(JXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex：%ld",buttonIndex);
}
@end
