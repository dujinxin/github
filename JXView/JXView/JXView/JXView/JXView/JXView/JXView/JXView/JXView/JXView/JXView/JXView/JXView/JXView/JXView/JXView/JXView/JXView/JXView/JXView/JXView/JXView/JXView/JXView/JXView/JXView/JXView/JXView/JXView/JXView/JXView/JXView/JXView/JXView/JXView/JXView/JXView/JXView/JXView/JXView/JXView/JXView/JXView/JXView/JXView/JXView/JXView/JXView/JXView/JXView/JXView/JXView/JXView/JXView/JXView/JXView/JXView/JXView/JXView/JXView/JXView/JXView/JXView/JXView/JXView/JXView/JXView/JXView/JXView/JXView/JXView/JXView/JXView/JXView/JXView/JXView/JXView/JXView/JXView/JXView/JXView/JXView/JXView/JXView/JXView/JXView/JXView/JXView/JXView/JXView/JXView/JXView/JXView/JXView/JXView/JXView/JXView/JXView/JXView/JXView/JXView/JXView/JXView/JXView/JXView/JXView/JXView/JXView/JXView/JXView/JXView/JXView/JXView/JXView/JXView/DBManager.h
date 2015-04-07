//
//  DBManager.h
//  LimitFree
//
//  Created by student on 14-4-3.
//  Copyright (c) 2014年 djxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteModel.h"
//将数据库操作数据的逻辑写在此类中,为了方便整个工程都能操作和访问数据，将此类作为单例
@interface DBManager : NSObject
//通过此类方法，得到单例
+ (DBManager *)shareManager;
//将数据模型中的数据插入到表中
- (void)insertDataWithModel:(FavoriteModel *)model;
//根据主键id删除某条数据
- (void)deleteDataWithAppId:(NSInteger)appId;
//删除所有的数据
- (void)deleteAllApplication;
//根据主键id来更改某条数据
- (void)updateDataWithModel:(FavoriteModel *)model;
//获取所有的数据
- (NSArray *)fetchAllApplications;
@end
