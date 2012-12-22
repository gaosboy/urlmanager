//
//  UMAppDelegate.h
//  Demo
//
//  Created by jiajun on 12/22/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMDemoSlideNavViewController;

@interface UMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                              *window;
@property (strong, nonatomic) UMDemoSlideNavViewController          *navigator;

@end
