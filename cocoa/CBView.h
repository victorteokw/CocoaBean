//
//  CBView.h
//  CocoaBean
//
//  Created by Kai Yu on 3/3/15.
//  Copyright (c) 2015 Zhang Kai Yu. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface CBView : UIView

#else

#import <AppKit/AppKit.h>

@interface CBView : NSView

#endif

@end
