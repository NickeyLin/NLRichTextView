//
//  NLRichTextViewTests.m
//  NLRichTextViewTests
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SqliteViewCotroller.h"

@interface NLRichTextViewTests : XCTestCase

@end

@implementation NLRichTextViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}
- (void)testInitialSqliteViewController{
    SqliteViewCotroller *vc = [[SqliteViewCotroller alloc]init];
    XCTAssertNotNil(vc, @"");
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
