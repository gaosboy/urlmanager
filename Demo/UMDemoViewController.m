//
//  UMDemoViewController.m
//  Demo
//
//  Created by jiajun on 12/22/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "UMDemoViewController.h"
#import "UMAppDelegate.h"
#import "UMNavigator.h"

@interface UMDemoViewController ()

@end

@implementation UMDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:@"侧栏导航"
                                                                style:UIBarButtonItemStylePlain
                                                               target:[(UMAppDelegate *)[[UIApplication sharedApplication] delegate] navigator]
                                                               action:@selector(slideButtonClicked)];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    UIButton *btnA = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnA.frame = CGRectMake(10.0f, 75.0f, 300.0f, 44.0f);
    [btnA setTitle:@"um://demo?title=openfrombtn&keya=valuea&keyb=valueb" forState:UIControlStateNormal];
    [btnA addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnA];
    
    UIButton *btnB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnB.frame = CGRectMake(10.0f, 129.0f, 300.0f, 44.0f);
    [btnB setTitle:@"bad://donotopen/wrong/path/?notopen=1" forState:UIControlStateNormal];
    [btnB addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnB];
    
    NSLog(@"self url:%@", self.url.absoluteString);
    NSLog(@"Params:%@", self.params);
}

- (void)open:(UIButton *)btn
{
    [self.navigationController pushViewController:
     [[UMNavigator sharedNavigator] viewControllerForURL:
      [NSURL URLWithString:btn.titleLabel.text]
                                               withQuery:nil]
                                         animated:YES];
//    [[UMNavigator sharedNavigator] openURL:[NSURL URLWithString:btn.titleLabel.text]];
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
    NSLog(@"Opend From:%@", aUrl.absoluteString);
}

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl
{
    // if it will open bad://donotopen/wrong/path/?notopen=1
    if ([@"bad" isEqualToString:[aUrl scheme]]
        || [@"donotopen" isEqualToString:[aUrl host]]
        || [@"1" isEqualToString:[[aUrl params] objectForKey:@"notopen"]]
        || [[aUrl path] containsString:@"/wrong/"]
        ) {
        NSLog(@"do not open.");
        return NO;
    }
    return YES;
}

@end
