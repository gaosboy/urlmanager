//
//  UMNavigationControllerTestCase.m
//  Demo
//
//  Created by jiajun on 7/17/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "UMNavigationController.h"
#import "UMNavigationControllerTestCase.h"
#import "UMViewController.h"
#import "HCIsCollectionHavingInAnyOrder.h"

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface ViewControllerA : UMViewController
@end
@implementation ViewControllerA
@end

@interface ViewControllerB : UMViewController
@end
@implementation ViewControllerB
@end

@interface UMNavigationControllerTestCase ()

@property   (strong, nonatomic) UMNavigationController          *navigator;

@property   (strong, nonatomic) ViewControllerA               *viewControllerA;
@property   (strong, nonatomic) ViewControllerB               *viewControllerB;

@end

@implementation UMNavigationControllerTestCase

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUpClass
{
    [UMNavigationController setViewControllerName:@"ViewControllerA" forURL:@"um://viewa"];
    [UMNavigationController setViewControllerName:@"ViewControllerB" forURL:@"um://viewb"];
    self.navigator = [[UMNavigationController alloc]
                      initWithRootViewControllerURL:[NSURL URLWithString:@"um://viewa"]];
}

- (void)testAddConfig
{
    [UMNavigationController setViewControllerName:@"ViewControllerA" forURL:@"um://viewa2"];
    NSMutableDictionary *config = [UMNavigationController config];
    HC_assertThat([config allKeys],
                  HC_hasInAnyOrder(HC_equalTo(@"um://viewa2"), nil));
    GHAssertEqualStrings(config[@"um://viewa2"], @"ViewControllerA",
                         @"config set error.");
}

- (void)testViewControllerForURL
{
    self.viewControllerA = (ViewControllerA *)[self.navigator
                            viewControllerForURL:[NSURL URLWithString:@"um://viewa?p1=v1&p2=v2"]
                            withQuery:@{@"k1":@"v1", @"k2":@"v2"}];

    HC_assertThat(self.viewControllerA, HC_instanceOf([UMViewController class]));
    HC_assertThat(self.viewControllerA, HC_isA([ViewControllerA class]));
    
    HC_assertThat([self.viewControllerA.params allKeys], HC_containsInAnyOrder(@"p1", @"p2", nil));
    GHAssertEqualStrings(self.viewControllerA.params[@"p1"], @"v1", @"param error.");
    GHAssertEqualStrings(self.viewControllerA.params[@"p2"], @"v2", @"param error.");

    HC_assertThat([self.viewControllerA.query allKeys], HC_containsInAnyOrder(@"k1", @"k2", nil));
    GHAssertEqualStrings(self.viewControllerA.query[@"k1"], @"v1", @"param error.");
    GHAssertEqualStrings(self.viewControllerA.query[@"k2"], @"v2", @"param error.");
}

@end
