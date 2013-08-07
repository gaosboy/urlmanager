//
//  UMViewControllerTestCase.m
//  Demo
//
//  Created by jiajun on 7/29/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "UMViewController.h"
#import "UMViewControllerTestCase.h"

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface UMViewControllerTestCase ()

@property (nonatomic, strong)   UMViewController        *viewController;
@property (nonatomic, strong)   UMNavigationController  *navigator;

@end

@implementation UMViewControllerTestCase

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setUpClass
{
    self.viewController = [[UMViewController alloc]
                           initWithURL:[NSURL URLWithString:@"um://view?p1=v1&p2=v2"]
                           query:@{@"k1":@"v1", @"k2":@"v2"}];
}

- (void)testInitWithSimpleURL
{
    UMViewController *vc = [[UMViewController alloc]
                           initWithURL:[NSURL URLWithString:@"um://view"]];
    HC_assertThat(vc, HC_instanceOf([UIViewController class]));
    HC_assertThat(vc, HC_isA([UMViewController class]));
}

- (void)testInitWithURL
{
    UMViewController *vc = [[UMViewController alloc]
                           initWithURL:[NSURL URLWithString:@"um://view?p1=v1&p2=v2"]];
    HC_assertThat(vc, HC_isA([UMViewController class]));
}

@end
