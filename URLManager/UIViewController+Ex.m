//
//  UIViewController+Ex.m
//  Demo
//
//  Created by jiajun on 6/18/14.
//  Copyright (c) 2014 SegmentFault.com. All rights reserved.
//

#import "UIViewController+Ex.h"
#import "UMSlideNavigationController.h"
#import "UMViewController.h"
#import "UMNavigator.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation UIViewController (Ex)

- (void)newViewDidAppear:(BOOL)animated
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        [UMNavigator sharedNavigator].currentNav = (UINavigationController *)self;
    }
    else if ([self isKindOfClass:[UITabBarController class]]) {
        [UMNavigator sharedNavigator].currentTab = (UITabBarController *)self;
    }
    else if ([self isKindOfClass:[UMSlideNavigationController class]]) {
        [UMNavigator sharedNavigator].currentSlide = (UMSlideNavigationController *)self;
    }
    else if ([self isKindOfClass:[UMViewController class]]) {
        [UMNavigator sharedNavigator].currentVC = (UMViewController *)self;
    }
    [self originViewDidAppear:animated];
}

- (void)originViewDidAppear:(BOOL)animated
{
}

+ (void)load
{
    Method oriDidAppear = class_getInstanceMethod([UIViewController class],
                                                  @selector(viewDidAppear:));
    IMP oriDidAppearImp = method_getImplementation(oriDidAppear);
    Method newDidAppear = class_getInstanceMethod([UIViewController class],
                                                  @selector(newViewDidAppear:));
    IMP newDidAppearImp = method_getImplementation(newDidAppear);
    class_replaceMethod([UIViewController class], @selector(originViewDidAppear:),
                        oriDidAppearImp, method_getTypeEncoding(oriDidAppear));
    class_replaceMethod([UIViewController class], @selector(viewDidAppear:),
                        newDidAppearImp, method_getTypeEncoding(oriDidAppear));
}

@end
