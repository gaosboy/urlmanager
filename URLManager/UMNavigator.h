//
//  UMNavigator.h
//  Demo
//
//  Created by jiajun on 9/27/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMViewController;
@class UMSlideNavigationController;

@interface UMNavigator : NSObject

@property (nonatomic, unsafe_unretained)    UINavigationController          *currentNav;
@property (nonatomic, unsafe_unretained)    UITabBarController              *currentTab;
@property (nonatomic, unsafe_unretained)    UMSlideNavigationController     *currentSlide;
@property (nonatomic, unsafe_unretained)    UMViewController                *currentVC;

@property (nonatomic, strong)               NSString                        *transitionType;
@property (nonatomic, strong)               NSString                        *transitionSubtype;

+ (UMNavigator *)sharedNavigator;

- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url;
- (void)setViewController:(UIViewController *)vc forURL:(NSString *)url;
- (void)setViewControllersForKeysFromDictionary:(NSDictionary *)dict;

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (void)openURL:(NSURL *)url;
- (BOOL)URLAvailable:(NSURL *)url;
- (UIViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query;

@end
