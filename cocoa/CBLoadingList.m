//
//  CBLoadingList.m
//  CocoaBean
//
//  Created by Kai Yu on 3/13/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import "CBLoadingList.h"

@implementation CBLoadingList

+ (NSArray *)list
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    [retVal addObjectsFromArray:[self supports]];
    [retVal addObjectsFromArray:[self models]];
    [retVal addObjectsFromArray:[self views]];
    [retVal addObjectsFromArray:[self controllers]];
    return retVal;
}

+ (NSArray *)supports
{
    return @[@"accessor"];
}

+ (NSArray *)models
{
    return @[];
}

+ (NSArray *)views
{
    return @[@"color", @"metrics", @"window", @"view", @"renderer"];
}

+ (NSArray *)controllers
{
    return @[@"view_controller"];
}

@end
