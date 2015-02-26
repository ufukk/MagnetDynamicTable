//
//  StaticTable.h
//  Whizz3.0
//
//  Created by ufuk on 4/30/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticTable : UIView

@property (readonly) NSArray *columnWidths;

@property (readonly) CGFloat cellWidth;

@property (readonly) CGFloat cellHeight;

@property (readonly) CGFloat cellMargin;

@property (readonly) int rowIteratorIndex;

@property (readonly) CGFloat rowIteratorHeight;

@property UILabel *titleView;

- (id)initWithFrame:(CGRect)frame cellWidth:(int)cellWidth cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title;

- (id)initWithFrame:(CGRect)frame columnWidths:(NSArray *)columnWidths cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title;

- (void)addCell:(UIView *)cell;

- (void)updateSize;

- (int)columnCount;

@end
