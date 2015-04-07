//
//  DJXRootAViewController.h
//  JXView
//
//  Created by dujinxin on 14-11-6.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGOBottomAutomaticLoadingFooterView.h"
#import "RequestManager.h"
#import "DJXBasicViewController.h"

@interface DJXRootAViewController : DJXBasicViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableDelegate>
{
    UITableView * _tableView;
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFooter
    EGOBottomAutomaticLoadingFooterView *_refreshFooterView;
    //
    BOOL         _reloading;
    RequestType  _requestType;
    NSInteger    _currentPage;
    
}
@property (nonatomic, retain)UITableView * tableView;
@property (nonatomic, assign)RequestType requestType;
@property (nonatomic, assign)NSInteger   currentPage;

-(void)refreshView;
-(void)getNextPageView;
-(void)testFinishedLoadData;
-(void)setFooterView;
-(void)removeFooterView;
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos;
@end

