//
//  CBApplication.m
//  CocoaBean
//
//  Created by Kai Yu on 3/1/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import "CBApplication.h"
#import "CBEnvironment.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif
#import <JavaScriptCore/JavaScriptCore.h>

@interface CBApplication ()

@property (nonatomic, strong) CBEnvironment *environment;

@end

@implementation CBApplication

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *defaultNotificationCenter = [NSNotificationCenter defaultCenter];
#if TARGET_OS_IPHONE
        [defaultNotificationCenter addObserver:self selector:@selector(applicationDidFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
#else
        [defaultNotificationCenter addObserver:self selector:@selector(applicationDidFinishLaunching) name:NSApplicationDidFinishLaunchingNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:NSApplicationDidBecomeActiveNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationWillResignActive:) name:NSApplicationWillResignActiveNotification object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(applicationWillTerminate) name:NSApplicationWillTerminateNotification object:nil];
#endif
    }
    return self;
}

# pragma mark - Application Life Cycle Methods

- (void)applicationDidFinishLaunching
{
    // CBEnvironment
    if (!self.environment) {
        self.environment = [[CBEnvironment alloc] init];
    }
}

- (void)applicationDidBecomeActive
{

}

- (void)applicationWillResignActive
{

}

- (void)applicationWillEnterForeground
{

}

- (void)applicationDidEnterBackground
{

}

- (void)applicationWillTerminate
{

}

# pragma mark - Load JS Application

- (void)loadScript:(NSString *)script
{
    [self.environment.context evaluateScript:script];
}

# pragma mark - Framework

- (void)dealloc
{
    NSNotificationCenter *defaultNotificationCenter = [NSNotificationCenter defaultCenter];
    [defaultNotificationCenter removeObserver:self];
}

@end
