//
//  CBEnvironment.m
//  CocoaBean
//
//  Created by Kai Yu on 3/3/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "CBEnvironment.h"
#import "CBApplication.h"
#import "CBLoadingList.h"
#import "CBLoader.h"

@interface CBEnvironment ()
@property (nonatomic, strong, readwrite) JSContext *context;
@property (nonatomic, strong) NSArray *loadingList;
@end

@implementation CBEnvironment

- (instancetype)init
{
    self.context = [[JSContext alloc] init];
    [self loadNativeExceptionLogger];
    [self loadDescriptorList];
    [self loadJS];
    return self;
}

- (void)loadNativeExceptionLogger
{
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        JSValue *errorJSClass = context[@"Error"];
        if ([exception isInstanceOf:errorJSClass]) {
            JSValue *stack = exception[@"stack"];
            JSValue *message = exception[@"message"];
            JSValue *name = exception[@"name"];
            NSLog(@"JS Exception: %@\n%@\n%@\n", name, message, stack);
        } else {
            NSLog(@"JS Exception: %@", exception);
        }
    };
}

- (void)loadDescriptorList
{
    self.loadingList = [CBLoadingList list];
}

- (void)loadJS
{
    [self.loadingList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *descriptor = (NSString *)obj;
        NSLog(@"%@", descriptor);
    }];
}

- (void)inject:(void (^)(JSContext *))code
{
    code(self.context);
}

#pragma mark - method forwording

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
//    } else if (sel_isEqual(aSelector, @selector(inject:))) {
//        return YES;
//    } else if (sel_isEqual(aSelector, @selector(context))) {
//        return YES;
    } else {
        return [self.context respondsToSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self.context respondsToSelector:invocation.selector]) {
        [invocation setTarget:self.context];
        [invocation invoke];
    } else {
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.context methodSignatureForSelector:sel];
}

@end
