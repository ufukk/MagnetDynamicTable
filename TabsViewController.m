//
//  TabsViewController.m
//  MagnetDynamicTable
//
//  Created by ufuk on 14/03/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "TabsViewController.h"
#import "TableViewController.h"
#import "InnerTableViewController.h"
#import "ColumnsViewController.h"

@interface TabsViewController ()

@property UITabBarController *tabController;

@end

@implementation TabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:25.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UITabBar.appearance.barStyle = UIBarStyleBlack;
    [UITabBar.appearance setItemWidth:200];
    TableViewController *tableController = [[TableViewController alloc] initWithNibName:nil bundle:nil];
    
    InnerTableViewController *innerController = [[InnerTableViewController alloc] initWithNibName:nil bundle:nil];
    
    ColumnsViewController *columnsController = [[ColumnsViewController alloc] initWithNibName:nil bundle:nil];
    
    tableController.tabBarItem.title = @"Add & Replace Cell";
    columnsController.tabBarItem.title = @"Column widths";
    innerController.tabBarItem.title = @"Table in table";
    
    
    self.tabController.viewControllers = @[tableController, columnsController, innerController];
    [self.view addSubview:self.tabController.view];
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
