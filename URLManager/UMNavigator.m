//
//  UMNavigator.m
//  Demo
//
//  Created by jiajun on 9/27/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "UMNavigator.h"
#import "UMSlideNavigationController.h"
#import "UMViewController.h"
#import "UMWebViewController.h"

#import <objc/objc.h>
#import <objc/runtime.h>

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UMNavigator ()

@property (nonatomic, strong)   NSMutableDictionary         *config;

@end

@implementation UMNavigator

+ (UMNavigator *)sharedNavigator
{
    static UMNavigator      *_sharedNavigator = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNavigator = [[UMNavigator alloc] init];
    });
    return _sharedNavigator;
}

#pragma mark - Public
- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url
{
    if (nil == self.config) {
        self.config = [[NSMutableDictionary alloc] init];
    }
    [self.config setValue:className forKey:url];
}

- (void)openURL:(NSURL *)url
{
    [self openURL:url withQuery:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    UIViewController *hostVC = [self viewControllerForURL:url withQuery:query];
    NSArray *paths = [[NSArray alloc] initWithArray:
                          [url.path componentsSeparatedByString:@"/"]];
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    for (NSString *p in paths) {
        if (p && 0 < p.length) {
            [pArray addObject:p];
        }
    }
    paths = nil;
    
    if ([hostVC isKindOfClass:[UITabBarController class]]) { // 只支持1位数index
        NSInteger index = (0 < paths.count) ? [[paths objectAtIndex:0] integerValue] : 0;
        UITabBarController *tabBarVC = (UITabBarController *)hostVC;
        if (index <= tabBarVC.viewControllers.count) {
            tabBarVC.selectedIndex = index;
        }
    }
    else if ([hostVC isKindOfClass:[UINavigationController class]]) {
        ;;
    }
    else if ([hostVC isKindOfClass:[UIViewController class]]) {
        if (nil == pArray || 0 >= pArray.count) {
            if ([[UMNavigator sharedNavigator].currentNav
                 respondsToSelector:@selector(pushViewController:animated:)]) {
                [[UMNavigator sharedNavigator].currentNav pushViewController:hostVC animated:YES];
            }
            else if ([[UMNavigator sharedNavigator].currentVC.navigationController
                      respondsToSelector:@selector(pushViewController:animated:)]) {
                [[UMNavigator sharedNavigator].currentVC.navigationController
                 pushViewController:hostVC
                 animated:YES];
            }
        }
    }
//    UMViewController *lastViewController = (UMViewController *)[self.viewControllers lastObject];
//    UMViewController *viewController = [self viewControllerForURL:url withQuery:query];
//    if ([lastViewController shouldOpenViewControllerWithURL:url]) {
//        [self pushViewController:viewController animated:YES];
//        [viewController openedFromViewControllerWithURL:lastViewController.url];
//    }
}

- (UIViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    UIViewController* viewController = nil;

    if ([self URLAvailable:url]) {
        if ([[self.config objectForKey:urlString] isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)[self.config objectForKey:urlString];
        }
        else if (nil == query) {
            Class class = NSClassFromString([self.config objectForKey:urlString]);
            viewController = (UIViewController *)[[class alloc] initWithURL:url];
        }
        else {
            Class class = NSClassFromString([self.config objectForKey:urlString]);
            viewController = (UIViewController *)[[class alloc] initWithURL:url query:query];
        }
    }
    else if ([@"http" isEqualToString:[url scheme]]) {
        viewController = (UIViewController *)[[UMWebViewController alloc] initWithURL:url
                                                                                query:query];
    }
    
    return viewController;
}

- (BOOL)URLAvailable:(NSURL *)url
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    return [self.config.allKeys containsObject:urlString];
}

#pragma mark - Hook

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
    
    [self performSelector:@selector(originViewDidAppear:)
               withObject:[NSNumber numberWithBool:animated]];
}

+ (void)initialize
{
    Method oriDidAppear = class_getInstanceMethod([UIViewController class],
                                                  @selector(viewDidAppear:));
    Method newDidAppear = class_getInstanceMethod([self class],
                                                  @selector(newViewDidAppear:));
    
    IMP oriDidAppearImp = method_getImplementation(oriDidAppear);
    class_addMethod([UIViewController class], @selector(originViewDidAppear:),
                    oriDidAppearImp, method_getTypeEncoding(oriDidAppear));
    
    IMP newDidAppearImp = method_getImplementation(newDidAppear);
    class_replaceMethod([UIViewController class], @selector(viewDidAppear:),
                        newDidAppearImp, method_getTypeEncoding(oriDidAppear));
}

@end
