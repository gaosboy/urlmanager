//
//  UMViewController.h
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UMTools.h"
#import "UMNavigationController.h"

@interface UMViewController : UIViewController

@property (unsafe_unretained, nonatomic) UMNavigationController         *navigator;
@property (strong, nonatomic) NSDictionary                              *params;
@property (strong, nonatomic) NSDictionary                              *query;
@property (strong, nonatomic) NSURL                                     *url;

- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;
- (void)openedFromViewControllerWithURL:(NSURL *)aUrl;
- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl;

@end
