//
//  CBApplication.h
//  CocoaBean
//
//  Created by Kai Yu on 3/1/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBApplication : NSObject

- (instancetype)init;

- (void)loadScript:(NSString *)script;

@end
