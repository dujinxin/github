//
//  DJXLeftViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-6.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXLeftViewController.h"
#import "DJXTableViewController.h"
#import "DDMenuController.h"
#import "DJXMainViewController.h"
#import "DJXAppDelegate.h"

@interface DJXLeftViewController ()
{
    NSMutableArray * _dataArray;
}
@end

@implementation DJXLeftViewController

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
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:@"tableView"];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // set the root controller
    DDMenuController *menuController = (DDMenuController *)((DJXAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    //选择一项后回到原来的主视图控制器
    /*
    FeedController *controller = [[FeedController alloc] init];
    controller.title = [NSString stringWithFormat:@"Cell %i", indexPath.row];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [menuController setRootController:navController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    */
    /*  左边菜单选择一项后，将这项作为主视图控制器
     DetailViewController * dvc = [[DetailViewController alloc]init];
     UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:dvc];
     [menuController setRootController:nvc animated:YES];
     */
    UINavigationController * controller = (UINavigationController *)[[DJXAppDelegate appDelegate].mytabBarController selectedViewController];
    DJXTableViewController * tvc = [[DJXTableViewController alloc]init ];
    [menuController showRootController:YES];
    [[DJXAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [controller pushViewController:tvc animated:YES];
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
