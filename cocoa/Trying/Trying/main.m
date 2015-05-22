//
//  main.m
//  Trying
//
//  Created by Kai Yu on 5/13/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        JSContext *context = [[JSContext alloc] init];
        // Define module CB
        [context evaluateScript:@"this.CB = {};"];
        // Test module CB is defined well or not
        NSLog(@"module cb is defined %@", [[context objectForKeyedSubscript:@"CB"] toObject]);
        // Define CB.Log
        context[@"CB"][@"Log"] = ^(NSString *anyString) {
            NSLog(@"%@", anyString);
        };
        // Test CB.Log works or not
        [context evaluateScript:@"CB.Log(\"CB.Log works!\");"];
        // Test module CB has Log or not
        NSLog(@"module cb has Log %@", [[context objectForKeyedSubscript:@"CB"] toObject]);
        // window defined?
        JSValue *windowValue = context[@"window"];
        NSLog(@"window is undefined? %d", [windowValue isUndefined]);
        // window is undefined by default
        [context evaluateScript:@"var window = this;"];
        windowValue = context[@"window"];
        NSLog(@"window is undefined? %d", [windowValue isObject]);
        [windowValue[@"CB"] invokeMethod:@"Log" withArguments:@[@"ABC"]];
        // set exception handler
        [context setExceptionHandler:^(JSContext *c, JSValue *v) {
            NSLog(@"Exception thrown!");
            abort();
        }];
        // setTimeout is not available in JavaScriptCore
        [context evaluateScript:@"setTimeout(function(){ CB.Log(\"Out yay!\");},0);"];

    }
    return 0;
}
