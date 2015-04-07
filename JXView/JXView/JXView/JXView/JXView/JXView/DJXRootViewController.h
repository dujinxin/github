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

@interface DJXRootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableDelegate>
{
    UITableView *_tableView;
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    
}
@end
