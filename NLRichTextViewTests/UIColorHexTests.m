//
//  UIColorHexTests.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/12/4.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UIColor+Hex.h"

@interface UIColorHexTests : XCTestCase

@end

@implementation UIColorHexTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testColorFromHex {
    // This is an example of a functional test case.
    UIColor *color = [UIColor colorFromHex:0x889922];
    XCTAssertNotNil(color, @"");

    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    BOOL result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    XCTAssert(result, @"");
    XCTAssertEqual(red, 0x88/(CGFloat)255.0, @"");
    XCTAssertEqual(green, 0x99/(CGFloat)255.0, @"");
    XCTAssertEqual(blue, 0x22/(CGFloat)255.0, @"");
    XCTAssertEqual(alpha, 1, @"");
}
- (void)testColorFromHexErrorNumber{
    UIColor *color = [UIColor colorFromHex:0x8899];
    XCTAssertNotNil(color, @"");
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    BOOL result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    XCTAssert(result, @"");
    XCTAssertEqual(red, 0x00/(CGFloat)255.0, @"");
    XCTAssertEqual(green, 0x88/(CGFloat)255.0, @"");
    XCTAssertEqual(blue, 0x99/(CGFloat)255.0, @"");
    XCTAssertEqual(alpha, 1, @"");
    
    color = [UIColor colorFromHex:0x88995522];
    XCTAssertNotNil(color, @"");

    result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    XCTAssert(result, @"");
    XCTAssertEqual(red, 0x99/(CGFloat)255.0, @"");
    XCTAssertEqual(green, 0x55/(CGFloat)255.0, @"");
    XCTAssertEqual(blue, 0x22/(CGFloat)255.0, @"");
    XCTAssertEqual(alpha, 1, @"");
}

- (void)testColorFromHexStringRight{
    UIColor *color = [UIColor colorFromHexString:@"0x889911"];
    XCTAssertNotNil(color, @"");
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    BOOL result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    XCTAssert(result, @"");
    XCTAssertEqual(red, 0x88/(CGFloat)255.0, @"");
    XCTAssertEqual(green, 0x99/(CGFloat)255.0, @"");
    XCTAssertEqual(blue, 0x11/(CGFloat)255.0, @"");
    XCTAssertEqual(alpha, 1, @"");
    
    color = [UIColor colorFromHexString:@"0xjjjjii"];
    XCTAssertNotNil(color, @"");

    result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    XCTAssert(result, @"");
    XCTAssertEqual(red, 0/(CGFloat)255.0, @"");
    XCTAssertEqual(green, 0/(CGFloat)255.0, @"");
    XCTAssertEqual(blue, 0/(CGFloat)255.0, @"");
    XCTAssertEqual(alpha, 1, @"");
    
    color = [UIColor colorFromHexString:@"#889911"];
    XCTAssertNotNil(color, @"");
    
    result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    XCTAssert(result, @"");
    XCTAssertEqual(red, 0x88/(CGFloat)255.0, @"");
    XCTAssertEqual(green, 0x99/(CGFloat)255.0, @"");
    XCTAssertEqual(blue, 0x11/(CGFloat)255.0, @"");
    XCTAssertEqual(alpha, 1, @"");
    
    color = [UIColor colorFromHexString:@"#jjjjii"];
    XCTAssertNotNil(color, @"");
    
    result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    XCTAssert(result, @"");
    XCTAssertEqual(red, 0/(CGFloat)255.0, @"");
    XCTAssertEqual(green, 0/(CGFloat)255.0, @"");
    XCTAssertEqual(blue, 0/(CGFloat)255.0, @"");
    XCTAssertEqual(alpha, 1, @"");
}

- (void)testColorFromHexStringWrongFormat{
    UIColor *color = [UIColor colorFromHexString:nil];
    XCTAssertNil(color, @"");
    
    color = [UIColor colorFromHexString:@""];
    XCTAssertNil(color, @"");
    
    color = [UIColor colorFromHexString:@"123445555"];
    XCTAssertNil(color, @"");
    
    color = [UIColor colorFromHexString:@"123456"];
    XCTAssertNil(color, @"");
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        UIColor *color = [UIColor colorFromHexString:@"#jjjjii"];
    }];
}

@end
