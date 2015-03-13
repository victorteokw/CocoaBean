//
//  CBLoadingListTests.m
//  CocoaBean
//
//  Created by Kai Yu on 3/13/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CBLoadingList.h"

@interface CBLoadingListTests : XCTestCase

@end

@implementation CBLoadingListTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadingListContainsAccessor
{
    XCTAssert([[CBLoadingList list] containsObject:@"accessor"]);
}

- (void)testLoadingListContainsColor
{
    XCTAssert([[CBLoadingList list] containsObject:@"color"]);
}

@end
