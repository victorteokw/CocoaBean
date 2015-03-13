//
//  CBEnvironment.h
//  CocoaBean
//
//  Created by Kai Yu on 3/3/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSContext;
@interface CBEnvironment : NSObject

@property (nonatomic, strong, readonly) JSContext *context;

- (void)inject:(void (^)(JSContext *))code;

- (instancetype)init;

@end
