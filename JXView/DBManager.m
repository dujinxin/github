//
//  DBManager.m
//  LimitFree
//
//  Created by student on 14-4-3.
//  Copyright (c) 2014年 djxin. All rights reserved.
//

#import "DBManager.h"
//iOS开发中使用的是sqlite3轻量级的数据库,FMDB第三方开源库，封装了对sqlite3的所有操作，简化了操作数据库的流程
#import "FMDatabase.h"


@class DBManager;
@implementation DBManager
{
    //声明一个操作sqlite3数据库的成员变量
    //默认情况下，FMDatabase 没有考虑多个线程同时操作数据库中数据的问题，可以使用线程锁，来避免多个线程同时对数据库进行不同的操作
    FMDatabase * _dataBase;
    NSLock * _lock;
    
}
static DBManager * manager = nil;
+ (DBManager *)shareManager
{
    //@synchronized 同一时刻，只能有一个线程来执行{}中的代码
    //为了防止多个线程同时来调用杀人Manager而造成实例化多个对象
    //单例 要保证只有一个单例对象，还要保证单例对象不会被提前释放
    //工作中实现单例，只需要用类方法，返回一个单例即可
    @synchronized(self){
        if (manager == nil) {
            manager = [[DBManager alloc]init ];
        }
    }
    return manager;
}
//重写init方法，完成必要的初始化操作
-(id)init
{
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
        //指定数据库的路径 applications.db
        NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Documents/applications.db"];
        //创建一个FMDataBase（操作sqlite3）的对象,并将数据库的路径传递给对象
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        //open有两层含义:如果指定路径下没有user.db则创建一个user.db数据库文件，并打开，如果已经存在user.db则直接打开,返回值反映操作是否成功
        BOOL isSuccessed = [_dataBase open];
        if (isSuccessed) {
            //创建一个表(用sql语句：对数据库进行操作的语句，是一种语言)
            //blob 指代二进制的对象 image 要转化成NSData存入数据库
            NSString * createSql = @"create table if not exists application(id integer primary key autoincrement,name varchar(256),iconUrl varchar(256),applicationId varchar(256))";
            //需要执行创建表的语句,创建表、增、删、改 写的sql语句，执行的话全用executeUpdate方法,返回值为执行的结果
            BOOL isCreateSuccessed = [_dataBase executeUpdate:createSql];
            if (! isCreateSuccessed) {
                //执行语句失败
                //lastErrorMessage 会获取到执行sql语句失败的信息
                NSLog(@"create error:%@",_dataBase.lastErrorMessage);
            }
        }
    }
    return self;
}
- (void)insertDataWithModel:(FavoriteModel *)model
{
    [_lock lock];
    //insert的sql语句,sql语句中，用？来作为占位符,不管字段是何种类型
    NSString * insertSql = @"insert into application(name,iconUrl,applicationId) values(?,?,?)";
    //executeUpdate:后面跟的参数类型必须是NSObject或它的子类，
    //FMDataBase对象会将传过来的参数，转化成与数据库字段相匹配的类型，再进行后续处理
    BOOL isSuccessed = [_dataBase executeUpdate:insertSql,model.name,model.iconUrl,model.applicationId ];
    if (! isSuccessed) {
        //插入语句执行失败
        NSLog(@"insert error:%@",[_dataBase lastErrorMessage]);
    }
    [_lock unlock];
}
- (void)deleteDataWithAppId:(NSInteger)appId
{
    [_lock lock];
    NSString * deleteSql = @"delete from application where id = ?";
    //需要把基本数据类型，转化成NSObject类型，再作为executeUpdate:方法的参数
    BOOL isSuccessed  =[ _dataBase executeUpdate:deleteSql,[NSNumber numberWithInteger: appId]];
    if (! isSuccessed) {
        NSLog(@"delete error:%@",_dataBase.lastErrorMessage);
    }
    [_lock unlock];
}
- (void)deleteAllApplication
{
    [_lock lock];
    NSString * deleteSql = @"delete from application ";
    BOOL isSuccessed  =[_dataBase executeUpdate:deleteSql];
    if (! isSuccessed) {
        NSLog(@"delete error:%@",_dataBase.lastErrorMessage);
    }
    [_lock unlock];
}
- (void)updateDataWithModel:(FavoriteModel *)model
{
    [_lock lock];
    NSString * updateSql = @"update application set name=?,iconUrl =?,applicationId= ? where id = ?";
    BOOL isSuccessed = [_dataBase executeUpdate:updateSql,model.name,model.iconUrl,model.applicationId];
    if (isSuccessed == NO) {
        NSLog(@"update error:%@",_dataBase.lastErrorMessage);
    }
    [_lock unlock];
}
- (NSArray *)fetchAllApplications
{
    [_lock lock];
    //取到application表中所有的数据
    NSString * selectSql = @"select * from application";
    //FMResultSet (查询结果所用的类，查询出来的所有的数据都放入FMResultSet中)
    FMResultSet * set = [_dataBase executeQuery:selectSql];
    //用来存放FavoriteModel
    NSMutableArray * array = [[NSMutableArray alloc] init ];
    //next 方法 会在resultSet中：从第一条数据开始取，一直取到最后一条，如果能够取到当前这一条数据返回YES,取不到返回NO,next含义是会一直向下取数据
    while ([set next]) {
        //每次取出一整条数据
        //根据字段名称，取出字段的值
        NSString * name = [set stringForColumn:@"name"];
        NSString * iconUrl = [set stringForColumn:@"iconUrl"];
        NSString * applicationId = [set stringForColumn:@"applicationId"];
        FavoriteModel * model = [[FavoriteModel alloc]init ];
        model.name = name;
        model.iconUrl = iconUrl;
        model.applicationId = applicationId;
        [array addObject:model];
        DJXRelease(model);
    }
    [_lock unlock];
    return array;
}
@end
