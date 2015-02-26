//
//  DynamicTable.h
//  MagnetDynamicTable
//
//  Created by ufuk on 25/02/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicTable : UIView

@property (readonly) NSArray *columnWidths;

@property (readonly) CGFloat cellWidth;

@property (readonly) CGFloat cellHeight;

@property (readonly) CGFloat cellMargin;

@property (readonly) int rowIteratorIndex;

@property UILabel *titleView;

- (id)initWithFrame:(CGRect)frame cellWidth:(int)cellWidth cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title;

- (id)initWithFrame:(CGRect)frame columnWidths:(NSArray *)columnWidths cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title;

- (void)addCell:(UIView *)cell;

- (void)replaceCell:(UIView *)cell cellIndex:(int)cellIndex;

- (void)updateSize;

- (int)columnCount;

- (BOOL)isRowCollapsed:(int)rowIndex;

- (void)collapseRow:(int)rowIndex;

- (void)expandRow:(int)rowIndex;

- (void)toggleRow:(int)rowIndex;


@end
