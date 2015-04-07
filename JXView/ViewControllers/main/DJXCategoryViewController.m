//
//  DJXCategoryViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-6.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXCategoryViewController.h"

@interface DJXCategoryViewController ()

@property (strong, nonatomic) JXSearchBar *searchBar;

@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NSArray *searchData;
@end

@implementation DJXCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _searchData = [[NSArray alloc]init ];
        _data = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
    self.navigationItem.leftBarButtonItems = [self getNavigationItems:self selector:@selector(count) image:[UIImage imageNamed: @"二维码"] style:kSingleImage isLeft:YES];
    self.navigationItem.rightBarButtonItems =  [self getNavigationItems:self selector:@selector(count) title:@"取消" style:kDefault isLeft:NO];
//    [self setTitleViewWithTitle:@"分类"];
    [self setNavigationTitleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - 
- (void)setNavigationTitleView{
    self.searchBar = [[JXSearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.searchBar.cancelButtonHidden = NO;
    self.searchBar.placeholder = NSLocalizedString(@"Search text here!", nil);
    self.searchBar.delegate = self;
//    [searchBar becomeFirstResponder];
    [self setTitleViewWithTitle:@"分类"];
    [self setTitleView:self.searchBar];
    
    [self.searchBar becomeFirstResponder];
    
    self.data = @[ @"Hey there!", @"This is a custom UISearchBar.", @"And it's really easy to use...", @"Sweet!" ];
    self.searchData = self.data;
}
- (void)count{
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - SSSearchBarDelegate

- (void)searchBarCancelButtonClicked:(JXSearchBar *)searchBar {
//    self.searchBar.text = @"";
//    [self filterTableViewWithText:self.searchBar.text];
}
- (void)searchBarSearchButtonClicked:(JXSearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self filterTableViewWithText:searchBar.text];
    self.searchData = @[@"1",@"2",@"3"];
    [self.tableView reloadData];
}
- (void)searchBar:(JXSearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterTableViewWithText:searchText];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchData count];;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
//    [self customiseTableViewCell:cell atIndexPath:indexPath];
    
    cell.textLabel.text = self.searchData[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:14];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark - Helper Methods

- (void)filterTableViewWithText:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.searchData = self.data;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText];
        self.searchData = [self.data filteredArrayUsingPredicate:predicate];
        self.searchData = @[@"搜索结果",@"自动匹配"];
        [self.tableView reloadData];
    }
}

- (void)customiseTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //Some fancy stuff - This really isn't needed and isn't the best way to do it. Subclass UITableViewCell if you want something like this.
    UIView *backgroundColorView = [cell.contentView viewWithTag:10];
    
    CGRect backgroundFrame = CGRectMake(2, 2, cell.bounds.size.width - 4, cell.bounds.size.height - 2 - (indexPath.row == self.searchData.count - 1? 2:0));
    
    if (!backgroundColorView) {
        backgroundColorView = [[UIView alloc] initWithFrame:backgroundFrame];
        backgroundColorView.tag = 10;
        backgroundColorView.backgroundColor = self.view.backgroundColor;
        [cell.contentView insertSubview:backgroundColorView atIndex:0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    else {
        backgroundColorView.frame = backgroundFrame;
    }
    
}
@end
