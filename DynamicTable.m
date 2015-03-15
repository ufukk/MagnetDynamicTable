//
//  DynamicTable.m
//  MagnetDynamicTable
//
//  Created by ufuk on 25/02/15.
//  Copyright (c) 2015 macroismicro. All rights reserved.
//

#import "DynamicTable.h"

@interface DynamicTable()

@property NSMutableArray *cells;

@end


@implementation DynamicTable

- (id)initWithFrame:(CGRect)frame cellWidth:(int)cellWidth cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self->_cellWidth = cellWidth;
        self->_cellHeight = cellHeight;
        self->_cellMargin = cellMargin;
        self.cells = [NSMutableArray new];
        
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

- (void)setCellWidth:(CGFloat)cellWidth {
    self->_cellWidth = cellWidth;
    [self repositionAllCells];
}

- (void)setCellMargin:(CGFloat)cellMargin {
    self->_cellMargin = cellMargin;
    [self repositionAllCells];
}

- (void)setColumnWidths:(NSArray *)columnWidths {
    self->_columnWidths = columnWidths;
    [self repositionAllCells];
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
    int rowCount = ceil((self.cells.count * [self calculatedCellWidth]) / self.frame.size.width);
    if(self.columnWidths != nil)
        rowCount = ceil(self.cells.count / self.columnWidths.count);
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
    CGFloat height = [self pointForCell:self.cells.count].y;
    int columnCount = [self columnCount];
    int rowIndex = floor((self.cells.count - 1) / columnCount);
    if(self.cells.count % columnCount != 0)
        height += [self heightForRow:rowIndex] + self.cellMargin;
    return height;
}

- (CGFloat)heightForRow:(int)rowIndex {
    int columnCount = [self columnCount];
    int currentHeight = 0;
    for(int i = rowIndex * columnCount; i < (rowIndex * columnCount) + columnCount && i < self.cells.count; i++) {
        UIView *cell = [self cellForIndex:i];
        if(cell.frame.size.height > currentHeight)
            currentHeight = cell.frame.size.height;
    }
    
    return currentHeight;
}

- (CGPoint)pointForNewCell {
    return [self pointForCell:self.cells.count];
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
    return [self.cells objectAtIndex:cellIndex];
}

- (void)replaceCell:(UIView *)cell cellIndex:(int)cellIndex {
    int columnIndex = cellIndex % [self columnCount];
    if(cellIndex < self.cells.count) {
        UIView *subView = [self cellForIndex:cellIndex];
        [self.cells removeObject:subView];
        [subView removeFromSuperview];
    }
    
    CGPoint point = [self pointForCell:cellIndex];
    int width = self.columnWidths == nil ? self.cellWidth : [[self.columnWidths objectAtIndex:columnIndex] floatValue];
    cell.frame = CGRectMake(point.x, point.y, width, cell.frame.size.height);
    [self addSubview:cell];
    
    [self.cells insertObject:cell atIndex:cellIndex];
    
    if(cellIndex < self.cells.count)
        [self repositionAllCells];

    [self updateSize];
}

- (void)repositionAllCells {
    for(int i = 0; i < self.cells.count; i++) {
        UIView *cell = [self cellForIndex:i];
        CGPoint position = [self pointForCell:i];
        cell.frame = CGRectMake(position.x, position.y, cell.frame.size.width, cell.frame.size.height);
    }
}

- (void)addCell:(UIView *)cell {
    [self replaceCell:cell cellIndex:self.cells.count];
}

- (void)removeCell:(int)cellIndex {
    UIView *cell = [self cellForIndex:cellIndex];
    [cell removeFromSuperview];
    [self repositionAllCells];
    [self updateSize];
}

- (BOOL)isRowCollapsed:(int)rowIndex {
    UIView *view = [self cellForIndex:rowIndex];
    return view.hidden;
}

- (void)collapseRow:(int)rowIndex animate:(BOOL)animate {
    if([self isRowCollapsed:rowIndex])
        return;
    
    UIView *view = [self cellForIndex:rowIndex];
    CGFloat height = view.frame.size.height + self.cellMargin;
    CGRect frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    CGRect newFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
    CGFloat duration = animate ? 1.0 : 0;
    [UIView animateWithDuration:duration animations:^{
        view.frame = newFrame;
        for(int i = rowIndex+1; i < self.cells.count; i++) {
            UIView *rowView = [self cellForIndex:i];
            rowView.frame = CGRectMake(rowView.frame.origin.x, rowView.frame.origin.y - height, rowView.frame.size.width, rowView.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        view.frame = frame;
        [view setHidden:YES];
    }];
}


- (void)expandRow:(int)rowIndex animate:(BOOL)animate{
    if(![self isRowCollapsed:rowIndex])
        return;
    
    UIView *view = [self cellForIndex:rowIndex];
    CGFloat height = view.frame.size.height + self.cellMargin;
    
    CGRect frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0);
    CGRect newFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
    view.frame = frame;
    [view setHidden:NO];

    CGFloat duration = animate ? 1.0 : 0;
    
    [UIView animateWithDuration:duration animations:^{
        view.frame = newFrame;
        for(int i = rowIndex+1; i < self.cells.count; i++) {
            UIView *rowView = [self cellForIndex:i];
            rowView.frame = CGRectMake(rowView.frame.origin.x, rowView.frame.origin.y + height, rowView.frame.size.width, rowView.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
    }];
}


- (void)toggleRow:(int)rowIndex animate:(BOOL)animate {
    UIView *view = [[self subviews] objectAtIndex:rowIndex];
    if(view.isHidden)
        [self expandRow:rowIndex animate:animate];
    else
        [self collapseRow:rowIndex animate:animate];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self repositionAllCells];
}

@end
