//
//  TestViewController.m
//  UIView_SubviewByName
//
//  Created by ufuk on 06/03/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+SubviewByName.h"

@interface TestViewController ()

@property UIView *containerView;

@property UIView *subview1;

@property UIView *subview2;

@property UIView *subview3;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 700)];
    self.containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.containerView];
    
    self.subview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.subview1.backgroundColor = [UIColor redColor];
    
    [self.containerView addSubview:self.subview1 withName:@"subview1"];
    
    self.subview2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 280, 100)];
    self.subview2.backgroundColor = [UIColor blueColor];

    [self.containerView addSubview:self.subview2];
    [self.containerView setNames:@[@"subview2"] groupNames:nil forSubviews:@[self.subview2]];
    
    self.subview3 = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 300, 100)];
    self.subview3.backgroundColor = [UIColor yellowColor];
    
    [self.containerView addSubview:self.subview3 withName:@"subview3"];
    
    
    [self.containerView removeSubviewWithName:@"subview2"];
    
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
