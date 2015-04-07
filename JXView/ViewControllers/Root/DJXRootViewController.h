//
//  DJXRootViewController.h
//  JXView
//
//  Created by dujinxin on 14-10-24.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "RequestManager.h"
#import "DJXBasicViewController.h"

@interface DJXRootViewController : DJXBasicViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFooter
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL         _reloading;
    RequestType  _requestType;
    NSInteger    _currentPage;
    NSMutableArray * _dataArray;
    
}
@property (nonatomic, retain)UITableView * tableView;
@property (nonatomic, retain)NSMutableArray * dataArray;
@property (nonatomic, assign)RequestType requestType;
@property (nonatomic, assign)NSInteger   currentPage;

-(void)refreshView;
-(void)getNextPageView;
-(void)createFooterView;
-(void)setFooterView;
-(void)removeFooterView;
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos;
@end
