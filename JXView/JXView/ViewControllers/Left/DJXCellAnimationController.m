//
//  DJXSSSS.m
//  JXView
//
//  Created by dujinxin on 14-12-31.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXCellAnimationController.h"
#import "DJXAnimationCell.h"

@interface DJXCellAnimationController ()
{
    NSMutableArray * _dataArray;
    BOOL isShowAnimation;
}

@end
@implementation DJXCellAnimationController

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
    [_dataArray addObject:@"cell 加载动画"];
    isShowAnimation = YES;

    self.view.backgroundColor = [UIColor yellowColor];
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

- (void)backToMain{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString * cellIdentifier = @"Cell";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    DJXAnimationCell * cell = (DJXAnimationCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static CGFloat initialDelay = 0.2f;
    static CGFloat stutter = 0.06f;
    
    if (isShowAnimation) {
        DJXAnimationCell *cardCell = (DJXAnimationCell *)cell;
        [cardCell startAnimationWithDelay:initialDelay + ((indexPath.row) * stutter)];
        if (indexPath.row == 10) {
            isShowAnimation = NO;
        }
    }
    
    
    
}
@end