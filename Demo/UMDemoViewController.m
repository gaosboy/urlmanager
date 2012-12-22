//
//  UMDemoViewController.m
//  Demo
//
//  Created by jiajun on 12/22/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "UMDemoViewController.h"

@interface UMDemoViewController ()

@end

@implementation UMDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = [self.params objectForKey:@"title"];
}

@end
