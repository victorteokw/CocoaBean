//
//  CBEnvironmentTests.m
//  CocoaBean
//
//  Created by Kai Yu on 3/13/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CBEnvironment.h"

@interface CBEnvironmentTests : XCTestCase
@property (nonatomic, strong) CBEnvironment *environment;
@end

@implementation CBEnvironmentTests

- (void)setUp {
    [super setUp];
    self.environment = [[CBEnvironment alloc] init];
}

- (void)tearDown {
    self.environment = nil;
    [super tearDown];
}

- (void)testCBEnvironmentRespondsToInit
{
    XCTAssertTrue([self.environment respondsToSelector:@selector(init)]);
}

- (void)testCBEnvironmentRespondsToContext
{
    XCTAssertTrue([self.environment respondsToSelector:@selector(context)]);
}

- (void)testCBEnvironmentRespondsToInject
{
    XCTAssertTrue([self.environment respondsToSelector:@selector(inject:)]);
}

- (void)testCBEnvironmentResponsToEvaluateScript
{
    XCTAssertTrue([self.environment respondsToSelector:@selector(evaluateScript:)]);
}

- (void)testCBEnvironmentResponsToException
{
    XCTAssertTrue([self.environment respondsToSelector:@selector(exception)]);
}

@end
