//
//  ColumnsViewController.m
//  MagnetDynamicTable
//
//  Created by ufuk on 15/03/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "ColumnsViewController.h"
#import "DynamicTable.h"

@interface ColumnsViewController ()

@end

@implementation ColumnsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DynamicTable *table = [[DynamicTable alloc] initWithFrame:CGRectMake(50, 50, 600, 100) columnWidths:@[[NSNumber numberWithFloat:380.0], [NSNumber numberWithFloat:200.0]] cellHeight:10 cellMargin:5 title:nil];
    
    table.backgroundColor = [UIColor lightGrayColor];
    
    for(int i = 0; i < 14; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 380, 60)];
        label.text = @"CELL";
        
        label.backgroundColor = (i % 2 == 0) ? [UIColor yellowColor] :[UIColor cyanColor];
        [table addCell:label];
    }
    
    
    [self.view addSubview:table];
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
