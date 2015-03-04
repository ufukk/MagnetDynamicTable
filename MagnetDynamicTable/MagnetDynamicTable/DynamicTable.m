//
//  DynamicTable.m
//  MagnetDynamicTable
//
//  Created by ufuk on 25/02/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "DynamicTable.h"

@interface DynamicTable()

@property int cellCount;

@end


@implementation DynamicTable

- (id)initWithFrame:(CGRect)frame cellWidth:(int)cellWidth cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellCount = 0;
        self->_cellWidth = cellWidth;
        self->_cellHeight = cellHeight;
        self->_cellMargin = cellMargin;
        
        if(title) {
            self->_titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
            self.titleView.text = title;
            self.titleView.textColor = [UIColor whiteColor];
            [self addSubview:self.titleView];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame columnWidths:(NSArray *)columnWidths cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title {
    if(self = [self initWithFrame:frame cellWidth:0 cellHeight:cellHeight cellMargin:cellMargin title:title]) {
        self->_columnWidths = columnWidths;
    }
    
    return self;
}

-(CGFloat)calculatedCellWidth {
    return self.cellWidth + self.cellMargin;
}

-(CGFloat)calculatedCellHeight {
    return self.cellHeight + self.cellMargin;
}

-(CGFloat)topMargin {
    if(self.titleView)
        return self.titleView.frame.size.height + self.cellMargin;
    else
        return 0;
}

-(int)rowCount {
    int rowCount = ceil((self.cellCount * [self calculatedCellWidth]) / self.frame.size.width);
    if(self.columnWidths != nil)
        rowCount = ceil(self.cellCount / self.columnWidths.count);
    if(rowCount == 0)
        rowCount = 1;
    return rowCount;
}

- (int)columnCount {
    if(self.columnWidths == nil)
        return floor(self.frame.size.width / [self calculatedCellWidth]);
    else
        return self.columnWidths.count;
}


- (CGFloat)totalHeight {
    CGFloat height = [self pointForCell:self.cellCount].y;
    int columnCount = [self columnCount];
    int rowIndex = floor((self.cellCount - 1) / columnCount);
    if(self.cellCount % columnCount != 0)
        height += [self heightForRow:rowIndex] + self.cellMargin;
    return height;
}

- (CGFloat)heightForRow:(int)rowIndex {
    int columnCount = [self columnCount];
    int currentHeight = 0;
    for(int i = rowIndex * columnCount; i < (rowIndex * columnCount) + columnCount && i < self.cellCount; i++) {
        UIView *cell = [self cellForIndex:i];
        if(cell.frame.size.height > currentHeight)
            currentHeight = cell.frame.size.height;
    }
    
    return currentHeight;
}

- (CGPoint)pointForNewCell {
    return [self pointForCell:self.cellCount];
}

- (CGPoint)pointForCell:(int)cellIndex {
    int columnCount = [self columnCount];
    int rowIndex = floor(cellIndex / columnCount);
    int columnIndex = cellIndex % columnCount;
    
    CGFloat widthUnit = [self calculatedCellWidth];
    
    if(self.columnWidths != nil) {
        widthUnit = 0;
        
        for(int i = 0; i < columnCount - 1; i++) {
            widthUnit += [(NSNumber *)[self.columnWidths objectAtIndex:i] floatValue];
            widthUnit += self.cellMargin;
        }
    }
    
    CGFloat height = [self topMargin];
    int currentRowIndex = 0;
    CGFloat currentRowHeight = 0;
    for(int j = 0; j < cellIndex; j++) {
        int iteratorRowIndex = floor(j / columnCount);
        UIView *cell = [self cellForIndex:j];
        if(iteratorRowIndex != currentRowIndex) {
            currentRowIndex = iteratorRowIndex;
            height += currentRowHeight + self.cellMargin;
            currentRowHeight = cell.frame.size.height;
        } else {
            if(cell.frame.size.height > currentRowHeight)
                currentRowHeight = cell.frame.size.height;
        }
    }
    if(currentRowIndex != rowIndex)
        height += currentRowHeight + self.cellMargin;
    
    return CGPointMake(columnIndex * widthUnit, height);
}



-(void)updateSize {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self totalHeight])];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self updateSize];
}

- (int)rowForCell:(int)cellIndex {
    return floor(cellIndex / [self columnCount]);
}

- (UIView *)cellForIndex:(int)cellIndex {
    return self.titleView != nil ? [self.subviews objectAtIndex:cellIndex+1] : [self.subviews objectAtIndex:cellIndex];
}

- (void)replaceCell:(UIView *)cell cellIndex:(int)cellIndex {
    int columnIndex = cellIndex % [self columnCount];
    if(cellIndex < self.cellCount) {
        UIView *subView = [self cellForIndex:cellIndex];
        [subView removeFromSuperview];
    }
    
    CGPoint point = [self pointForCell:cellIndex];
    int width = self.columnWidths == nil ? self.cellWidth : [[self.columnWidths objectAtIndex:columnIndex] floatValue];
    cell.frame = CGRectMake(point.x, point.y, width, cell.frame.size.height);
    [self addSubview:cell];
    if(self.cellCount <= cellIndex)
        self.cellCount++;
    
    if(cellIndex < self.cellCount)
        [self repositionAllCells];

    [self updateSize];
}

- (void)repositionAllCells {
    for(int i = 0; i < self.cellCount; i++) {
        UIView *cell = [self cellForIndex:i];
        CGPoint position = [self pointForCell:i];
        cell.frame = CGRectMake(position.x, position.y, cell.frame.size.width, cell.frame.size.height);
    }
}

- (void)addCell:(UIView *)cell {
    [self replaceCell:cell cellIndex:self.cellCount];
}

- (void)removeCell:(int)cellIndex {
    UIView *cell = [self cellForIndex:cellIndex];
    [cell removeFromSuperview];
    self.cellCount--;
    [self repositionAllCells];
    [self updateSize];
}

- (BOOL)isRowCollapsed:(int)rowIndex {
    UIView *view = [[self subviews] objectAtIndex:rowIndex];
    return view.hidden;
}

- (void)collapseRow:(int)rowIndex {
    if([self isRowCollapsed:rowIndex])
        return;
    
    UIView *view = [[self subviews] objectAtIndex:rowIndex];
    CGFloat height = view.frame.size.height + self.cellMargin;
    [view setHidden:YES];
    
    for(int i = rowIndex + 1; i < self.subviews.count; i++) {
        UIView *rowView = [self.subviews objectAtIndex:i];
        rowView.frame = CGRectMake(rowView.frame.origin.x, rowView.frame.origin.y - height, rowView.frame.size.width, rowView.frame.size.height);
    }
}


- (void)expandRow:(int)rowIndex {
    if(![self isRowCollapsed:rowIndex])
        return;
    
    UIView *view = [[self subviews] objectAtIndex:rowIndex];
    CGFloat height = view.frame.size.height + self.cellMargin;
    
    for(int i = rowIndex + 1; i < self.subviews.count; i++) {
        UIView *rowView = [self.subviews objectAtIndex:i];
        rowView.frame = CGRectMake(rowView.frame.origin.x, rowView.frame.origin.y + height, rowView.frame.size.width, rowView.frame.size.height);
    }
    
    [view setHidden:NO];
}

- (void)toggleRow:(int)rowIndex {
    UIView *view = [[self subviews] objectAtIndex:rowIndex];
    if(view.isHidden)
        [self expandRow:rowIndex];
    else
        [self collapseRow:rowIndex];
}

@end
