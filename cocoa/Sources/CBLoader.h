//
//  CBLoader.h
//  CocoaBean
//
//  Created by Kai Yu on 3/4/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CBCannotFindScriptException;
extern NSString * const CBLoaderLoadingException;

@class CBEnvironment;
@interface CBLoader : NSObject

- (instancetype)initWithEnvironment:(CBEnvironment *)environment;

+ (BOOL)isAbstractLoader;

+ (NSString *)scriptSourceCode;

+ (NSString *)jsClassName;

+ (NSString *)jsModuleName;

+ (NSString *)jsSuperClassName;

+ (BOOL)provideNativeConstructor;

- (id)constructorFunction;

// Define own js instance method this way
//- (id)instanceMethodViewDidLoad;

// Define own js class method this way
//+ (id)classMethodLayerClass;

@end
