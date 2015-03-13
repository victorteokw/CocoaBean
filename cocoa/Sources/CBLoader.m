//
//  CBLoader.m
//  CocoaBean
//
//  Created by Kai Yu on 3/4/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import "CBLoader.h"

NSString * const CBCannotFindScriptException = @"CBCannotFindScriptException";
NSString * const CBLoaderLoadingException = @"CBLoaderLoadingException";


@interface CBLoader ()

@property (nonatomic, strong) CBEnvironment *environment;

@end

@implementation CBLoader

- (instancetype)initWithEnvironment:(CBEnvironment *)environment
{
    self = [super init];
    if (self) {
        _environment = environment;
    }
    return self;
}

+ (BOOL)isAbstractLoader
{
    return YES;
}

+ (NSString *)scriptSourceCode
{
    NSString *className = NSStringFromClass([self class]);
    NSString *fileName = [[className substringFromIndex:2] lowercaseString];
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:fileName withExtension:@".js"];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        [NSException raise:CBCannotFindScriptException format:@"Cannot find %@", fileURL];
    }
    return content;
}

+ (NSString *)jsClassName
{
    if ([self isAbstractLoader]) {
        [NSException raise:CBLoaderLoadingException format:@"Should not requir class name of an abstract loader."];
    }
    NSMutableString *className = [NSStringFromClass([self class]) mutableCopy];
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:@"[A-Z]+[A-Z]" options:kNilOptions error:NULL];
    NSArray *result = [regExp matchesInString:className options:kNilOptions range:NSMakeRange(0, [className length])];
    NSRange range = [result[0] range];
    [className replaceCharactersInRange:NSMakeRange(range.location, range.length - 1) withString:@""];
    NSRange loaderRange = [className rangeOfString:@"Loader"];
    [className replaceCharactersInRange:loaderRange withString:@""];
    return className;
}

+ (NSString *)jsModuleName
{
    if ([self isAbstractLoader]) {
        [NSException raise:CBLoaderLoadingException format:@"Should not requir module name of an abstract loader."];
    }
    NSString *className = NSStringFromClass([self class]);
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:@"\\p{Uppercase Letter}+" options:kNilOptions error:NULL];
    NSArray *result = [regExp matchesInString:className options:kNilOptions range:NSMakeRange(0, [className length])];
    NSRange range = [result[0] range];
    return [className substringWithRange:NSMakeRange(range.location, range.length - 1)];
}

+ (NSString *)jsSuperClassName
{
    return @"Object";
}

+ (BOOL)provideNativeConstructor
{
    return NO;
}

- (id)constructorFunction
{
    return nil;
}

@end
