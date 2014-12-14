//
//  DemoAViewController.m
//  URLManager
//
//  Created by jiajun on 12/14/14.
//  Copyright (c) 2014 gaosboy.com. All rights reserved.
//

#import "DemoAViewController.h"

@interface DemoAViewController ()

@end

@implementation DemoAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image   = [UIImage imageNamed:@"first"];
        self.tabBarItem.title   = @"First";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(200.f, 200.f, 100.f, 100.f)];
    img.image = [UIImage imageNamed:@"first"];
    
    [self.view addSubview:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
