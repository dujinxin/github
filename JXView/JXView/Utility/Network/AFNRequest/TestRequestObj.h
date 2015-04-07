//
//  TestRequestObj.h
//  JXView
//
//  Created by dujinxin on 14-11-28.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXAFNRequestObj.h"

@interface TestRequestObj : NSObject

+ (TestRequestObj *) sharedManager;

- (void)request:(id)target url:(NSString *)urlString pageCount:(NSInteger)page;

@end
