//
//  UMViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMNavigationController.h"
#import "UMNavigator.h"

@implementation UINavigationController (UINavigationController_Ext)

- (id)initWithRootViewControllerURL:(NSURL *)url
{
    UIViewController *rootVC = [[UMNavigator sharedNavigator]
                                viewControllerForURL:url withQuery:nil];
    return [self initWithRootViewController:rootVC];
}

@end
