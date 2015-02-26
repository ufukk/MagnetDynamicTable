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

@property CGFloat currentHeight;

@property NSMutableDictionary *rowHeights;


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
        
        self->_rowIteratorIndex = 0;
        
        if(title)
        {
            self->_titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
            self.titleView.text = title;
            self.titleView.textColor = [UIColor whiteColor];
            [self addSubview:self.titleView];
        }
        self.currentHeight = [self topMargin];
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
    CGFloat total = self.cellMargin * self.rowHeights.count;
    for(NSNumber *key in self.rowHeights) {
        total += [[self.rowHeights objectForKey:key] floatValue];
    }
    
    return total + self.cellMargin;
}

- (CGPoint)pointForNewCell:(CGFloat)height {
    return [self pointForNewCell:height cellIndex:self.cellCount];
}

- (CGPoint)pointForNewCell:(CGFloat)height cellIndex:(int)cellIndex {
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
    
    if(self.rowIteratorIndex == 0 && self.currentHeight == 0)
        self.currentHeight += self.cellMargin;
    
    if(rowIndex > self.rowIteratorIndex) {
        self.currentHeight += [[self.rowHeights objectForKey:[NSNumber numberWithInt:self.rowIteratorIndex]] floatValue] + self.cellMargin;
        self->_rowIteratorIndex = rowIndex;
    }
    return CGPointMake(columnIndex * widthUnit, self.currentHeight);
}



-(void)updateSize {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self totalHeight])];
}

- (void)willRemoveSubview:(UIView *)subview {
    int rowCount = [self rowCount];
    self.cellCount--;
    if([self rowCount] < rowCount) {
        self.currentHeight -= (subview.frame.size.height + self.cellMargin);
        self->_rowIteratorIndex--;
    }
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
    int height = cell.frame.size.height > 0 ? cell.frame.size.height : self.cellHeight;
    int columnIndex = cellIndex % [self columnCount];
    int rowIndex = floor(cellIndex / [self columnCount]);
    
    if(cellIndex < self.cellCount) {
        UIView *subView = [self cellForIndex:cellIndex];
        [subView removeFromSuperview];
    }
    
    CGPoint point = [self pointForNewCell:height cellIndex:cellIndex];
    int width = self.columnWidths == nil ? self.cellWidth : [[self.columnWidths objectAtIndex:columnIndex] floatValue];
    cell.frame = CGRectMake(point.x, point.y, width, cell.frame.size.height);
    [self addSubview:cell];
    if(self.cellCount <= cellIndex)
        self.cellCount++;
    
    if(self.rowHeights == nil)
        self.rowHeights = [NSMutableDictionary new];
    
    if(cell.frame.size.height > [[self.rowHeights objectForKey:[NSNumber numberWithInt:rowIndex]] floatValue])
        [self.rowHeights setObject:[NSNumber numberWithInt:cell.frame.size.height] forKey:[NSNumber numberWithInt:rowIndex]];
    
    [self updateSize];

}

- (void)addCell:(UIView *)cell {
    [self replaceCell:cell cellIndex:self.cellCount];
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
