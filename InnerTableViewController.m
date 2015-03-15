//
//  InnerTableViewController.m
//  MagnetDynamicTable
//
//  Created by ufuk on 14/03/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "InnerTableViewController.h"
#import "DynamicTable.h"

@interface InnerTableViewController ()

@end

@implementation InnerTableViewController

- (void)viewDidLoad {
    
    UIScrollView *container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    DynamicTable *table = [[DynamicTable alloc] initWithFrame:CGRectMake(50, 50, 600, 100) cellWidth:580 cellHeight:10 cellMargin:5 title:nil];
    
    table.backgroundColor = [UIColor lightGrayColor];
    
    for(int i = 0; i < 30; i++) {
        
        DynamicTable *cell = [[DynamicTable alloc] initWithFrame:CGRectMake(0, 0, 580, 100) cellWidth:260 cellHeight:10 cellMargin:5 title:nil];
        
        cell.backgroundColor = (i % 3 == 0) ? [UIColor cyanColor] : (i % 2 == 0) ? [UIColor yellowColor] : [UIColor whiteColor];
        
        for(int j = 0; j < 6; j++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 60)];
            label.text = [NSString stringWithFormat:@"Cell %i", j];
            label.backgroundColor = [UIColor lightTextColor];
            [cell addCell:label];
        }
        
        [table addCell:cell];
    }
    
    container.contentSize = table.frame.size;
    [container addSubview:table];
    [self.view addSubview:container];
    
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
