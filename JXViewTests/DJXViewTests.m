//
//  DJXViewTests.m
//  JXView
//
//  Created by dujinxin on 15-4-8.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface DJXViewTests : XCTestCase

@end

@implementation DJXViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testInitWithScrollView{
    NSLog(@"1111111111111111111111");
    XCTAssert(1, @"Can not be zero");
}
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
