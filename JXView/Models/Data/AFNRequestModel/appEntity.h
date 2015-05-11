//
//  appEntity.h
//  JXView
//
//  Created by dujinxin on 14-12-1.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXAFNRequestManager.h"
#import "DJXAFNRequestObj.h"

#import "DJXAFRequestManagerTest.h"
#import "DJXAFRequestObjTest.h"

@interface appEntity : NSObject

//程序的唯一标识
@property (nonatomic,copy) NSString *applicationId;
@property (nonatomic,copy) NSString *categoryId;
//种类
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,copy) NSString *currentPrice;
@property (nonatomic,copy) NSString *_description;
//下载数
@property (nonatomic,copy) NSString *downloads;
//时间
@property (nonatomic,copy) NSString *expireDatetime;
@property (nonatomic,copy) NSString *favorites;
@property (nonatomic,copy) NSString *fileSize;
//图片的下载地址
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *ipa;
@property (nonatomic,copy) NSString *itunesUrl;
@property (nonatomic,copy) NSString *lastPrice;
//名称
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *priceTrend;
@property (nonatomic,copy) NSString *ratingOverall;
@property (nonatomic,copy) NSString *releaseDate;
@property (nonatomic,copy) NSString *releaseNotes;
@property (nonatomic,copy) NSString *shares;
@property (nonatomic,copy) NSString *slug;
//评分
@property (nonatomic,copy) NSString *starCurrent;
@property (nonatomic,copy) NSString *starOverall;
@property (nonatomic,copy) NSString *updateDate;
@property (nonatomic,copy) NSString *version;


@end


//afn
@interface AFNRequestModel : DJXAFNRequestObj
//@property (nonatomic, copy)callBackBlock successBlock;
@end

//afn
@interface AFNRequestTestModel : DJXAFRequestObjTest
//@property (nonatomic, copy)callBackBlock successBlock;
@property (nonatomic,strong)NSMutableArray * objArray;
@end


