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

- (id)initWithFrame:(CGRect)frame cellWidth:(int)cellWidth cellMargin:(int)cellMargin title:(NSString *)title;

- (id)initWithFrame:(CGRect)frame columnWidths:(NSArray *)columnWidths cellMargin:(int)cellMargin title:(NSString *)title;

- (UIView *)cellForIndex:(int)cellIndex;

- (void)addCell:(UIView *)cell;

- (void)replaceCell:(UIView *)cell cellIndex:(int)cellIndex;

- (void)removeCell:(int)cellIndex;

- (void)updateSize;

- (int)columnCount;

- (BOOL)isRowCollapsed:(int)rowIndex;

- (void)collapseRow:(int)rowIndex animate:(BOOL)animate;

- (void)expandRow:(int)rowIndex animate:(BOOL)animate;

- (void)toggleRow:(int)rowIndex animate:(BOOL)animate;


@end
