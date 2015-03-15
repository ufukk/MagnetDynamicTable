//
//  TableViewController.m
//  MagnetDynamicTable
//
//  Created by ufuk on 25/02/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "TableViewController.h"
#import "DynamicTable.h"

@interface TableViewController ()

@property DynamicTable *table;

@property UIButton *replaceButton;

@property UITextField *replaceCell;

@property int replacedCount;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.table = [[DynamicTable alloc] initWithFrame:CGRectMake(50, 50, 600, 100) cellWidth:280 cellHeight:0 cellMargin:10 title:nil];
    self.table.backgroundColor = [UIColor lightGrayColor];
    
    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
    subView1.backgroundColor = [UIColor redColor];

    
    UIView *subView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 70)];
    subView2.backgroundColor = [UIColor blueColor];

    
    UIView *subView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
    subView3.backgroundColor = [UIColor yellowColor];

    UIView *subView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 90)];
    subView4.backgroundColor = [UIColor purpleColor];

    UIView *subView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 110)];
    subView5.backgroundColor = [UIColor cyanColor];

    UIView *subView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    subView6.backgroundColor = [UIColor whiteColor];

    
    [self.table addCell:subView1];
    [self.table addCell:subView3];
    [self.table addCell:subView2];
    [self.table addCell:subView4];
    [self.table addCell:subView5];
    [self.table addCell:subView6];
    
    [self.table updateSize];
    
    [self.view addSubview:self.table];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 400, 100, 30)];
    label.text = @"CELL NO:";
    self.replaceCell = [[UITextField alloc] initWithFrame:CGRectMake(140, 400, 80, 30)];
    self.replaceCell.backgroundColor = [UIColor lightGrayColor];
    self.replaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replaceButton.backgroundColor = [UIColor blackColor];
    [self.replaceButton setTitle:@"REPLACE CELL" forState:UIControlStateNormal];
    self.replaceButton.frame = CGRectMake(230, 400, 150, 30);
    [self.replaceButton addTarget:nil action:@selector(replaceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:label];
    [self.view addSubview:self.replaceCell];
    [self.view addSubview:self.replaceButton];
    
    self.replacedCount = 0;
}

- (void)replaceButtonClicked {
    int cellNo = [self.replaceCell.text intValue];
    self.replacedCount++;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    subView.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 20)];
    label.text = [NSString stringWithFormat:@"replaced: %i", self.replacedCount];
    [subView addSubview:label];
    [self.table replaceCell:subView cellIndex:cellNo];
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
