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

- (void)testURLAvailable
{
    HC_assertThatBool([self.navigator URLAvailable:[NSURL URLWithString:@"bad://view"]],
                      HC_equalToBool(NO));
    HC_assertThatBool([self.navigator URLAvailable:[NSURL URLWithString:@"um://viewa"]],
                      HC_equalToBool(YES));
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)testViewControllerForSimpleURL
{
    self.viewControllerA = (ViewControllerA *)[self.navigator
                                               viewControllerForURL:
                                               [NSURL URLWithString:@"um://viewa"]
                                               withQuery:nil];
    
    HC_assertThat(self.viewControllerA, HC_instanceOf([UMViewController class]));
    HC_assertThat(self.viewControllerA, HC_isA([ViewControllerA class]));
}

- (void)testViewControllerForURLWithArgs
{
    self.viewControllerA = (ViewControllerA *)[self.navigator
                            viewControllerForURL:[NSURL URLWithString:@"um://viewa?p1=v1&p2=v2"]
                            withQuery:nil];

    HC_assertThat(self.viewControllerA, HC_instanceOf([UMViewController class]));
    HC_assertThat(self.viewControllerA, HC_isA([ViewControllerA class]));
    
    HC_assertThat([self.viewControllerA.params allKeys], HC_containsInAnyOrder(@"p1", @"p2", nil));
    GHAssertEqualStrings(self.viewControllerA.params[@"p1"], @"v1", @"param error.");
    GHAssertEqualStrings(self.viewControllerA.params[@"p2"], @"v2", @"param error.");
}

- (void)testViewControllerWithQuery
{
    self.viewControllerA = (ViewControllerA *)[self.navigator
                                               viewControllerForURL:
                                               [NSURL URLWithString:@"um://viewa"]
                                               withQuery:@{@"k1":@"v1", @"k2":@"v2"}];
    
    HC_assertThat([self.viewControllerA.query allKeys], HC_containsInAnyOrder(@"k1", @"k2", nil));
    GHAssertEqualStrings(self.viewControllerA.query[@"k1"], @"v1", @"param error.");
    GHAssertEqualStrings(self.viewControllerA.query[@"k2"], @"v2", @"param error.");
}

- (void)testViewControllerForURLAndQuery
{
    self.viewControllerA = (ViewControllerA *)[self.navigator
                                               viewControllerForURL:
                                               [NSURL URLWithString:@"um://viewa?p1=v1&p2=v2"]
                                               withQuery:@{@"k1":@"v1", @"k2":@"v2"}];

    HC_assertThat([self.viewControllerA.params allKeys], HC_containsInAnyOrder(@"p1", @"p2", nil));
    GHAssertEqualStrings(self.viewControllerA.params[@"p1"], @"v1", @"param error.");
    GHAssertEqualStrings(self.viewControllerA.params[@"p2"], @"v2", @"param error.");
    
    HC_assertThat([self.viewControllerA.query allKeys], HC_containsInAnyOrder(@"k1", @"k2", nil));
    GHAssertEqualStrings(self.viewControllerA.query[@"k1"], @"v1", @"param error.");
    GHAssertEqualStrings(self.viewControllerA.query[@"k2"], @"v2", @"param error.");
}

- (void)testInitWihtRootViewControllerURL
{
    UMNavigationController *navigator = [[UMNavigationController alloc]
                      initWithRootViewControllerURL:[NSURL URLWithString:@"um://viewb"]];
    
    HC_assertThat(navigator, HC_instanceOf([UINavigationController class]));
    HC_assertThat(navigator, HC_isA([UMNavigationController class]));

    HC_assertThat(navigator.rootViewController, HC_instanceOf([UMViewController class]));
    HC_assertThat(navigator.rootViewController, HC_isA([ViewControllerB class]));
    
    HC_assertThatInteger(navigator.viewControllers.count, HC_equalToInteger(1));
    HC_assertThat(navigator.viewControllers,
                  HC_hasInAnyOrder(HC_instanceOf([UMViewController class]), nil));
    HC_assertThat(navigator.viewControllers,
                  HC_hasInAnyOrder(HC_isA([ViewControllerB class]), nil));
    HC_assertThat(navigator.viewControllers,
                  HC_hasInAnyOrder(HC_is(navigator.rootViewController), nil));
}
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)testOpenURL
{
    [self.navigator openURL:[NSURL URLWithString:@"um://viewb?p1=v1&p2=v2"]];

    HC_assertThatInteger(self.navigator.viewControllers.count, HC_equalToInteger(2));

    HC_assertThat(self.navigator.viewControllers,
                  HC_contains(HC_is(self.navigator.rootViewController),
                              HC_isA([ViewControllerB class]),
                              nil));
    
    HC_assertThat([[(UMViewController *)self.navigator.viewControllers.lastObject params] allKeys],
                  HC_containsInAnyOrder(@"p1", @"p2", nil));
    GHAssertEqualStrings([(UMViewController *)self.navigator.viewControllers.lastObject
                          params][@"p1"],
                         @"v1", @"param error.");
    GHAssertEqualStrings([(UMViewController *)self.navigator.viewControllers.lastObject
                          params][@"p2"], @"v2", @"param error.");
}

- (void)testOpenURLWithQuery
{
    [self.navigator openURL:[NSURL URLWithString:@"um://viewb?p1=v1&p2=v2"]
                  withQuery:@{@"k1":@"v1", @"k2":@"v2"}];
    
    HC_assertThatInteger(self.navigator.viewControllers.count, HC_equalToInteger(3));
    
    HC_assertThat(self.navigator.viewControllers,
                  HC_contains(HC_is(self.navigator.rootViewController),
                              HC_isA([ViewControllerB class]),
                              HC_isA([ViewControllerB class]),
                              nil));
    
    HC_assertThat([[(UMViewController *)self.navigator.viewControllers.lastObject params] allKeys],
                  HC_containsInAnyOrder(@"p1", @"p2", nil));
    GHAssertEqualStrings([(UMViewController *)self.navigator.viewControllers.lastObject
                          params][@"p1"],
                         @"v1", @"param error.");
    GHAssertEqualStrings([(UMViewController *)self.navigator.viewControllers.lastObject
                          params][@"p2"], @"v2", @"param error.");
    
    HC_assertThat([[(UMViewController *)self.navigator.viewControllers.lastObject
                    query] allKeys], HC_containsInAnyOrder(@"k1", @"k2", nil));
    GHAssertEqualStrings([(UMViewController *)self.navigator.viewControllers.lastObject
                          query][@"k1"], @"v1", @"param error.");
    GHAssertEqualStrings([(UMViewController *)self.navigator.viewControllers.lastObject
                          query][@"k2"], @"v2", @"param error.");

}

@end
