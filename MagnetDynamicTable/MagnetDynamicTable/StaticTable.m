//
//  StaticTable.m
//  Whizz3.0
//
//  Created by ufuk on 4/30/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import "StaticTable.h"

@interface StaticTable()

@property int cellCount;

@property CGFloat currentHeight;


@end

@implementation StaticTable


- (id)initWithFrame:(CGRect)frame cellWidth:(int)cellWidth cellHeight:(int)cellHeight cellMargin:(int)cellMargin title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellCount = 0;
        self->_cellWidth = cellWidth;
        self->_cellHeight = cellHeight;
        self->_cellMargin = cellMargin;
        
        self->_rowIteratorHeight = 0;
        self->_rowIteratorIndex = 0;
        
        if(title)
        {
            self->_titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
            self.titleView.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
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

-(CGFloat)calculatedCellWidth
{
    return self.cellWidth + self.cellMargin;
}

-(CGFloat)calculatedCellHeight
{
    return self.cellHeight + self.cellMargin;
}

-(CGFloat)topMargin
{
    if(self.titleView)
        return self.titleView.frame.size.height + self.cellMargin;
    else
        return 0;
}

-(int)rowCount
{
    int rowCount = ceil((self.cellCount * [self calculatedCellWidth]) / self.frame.size.width);
    if(self.columnWidths != nil)
        rowCount = ceil(self.cellCount / self.columnWidths.count);
    if(rowCount == 0)
        rowCount = 1;
    return rowCount;
}

- (int)columnCount {
    float width = self.frame.size.width;
    if(self.columnWidths == nil)
        return floor(self.frame.size.width / [self calculatedCellWidth]);
    else
        return self.columnWidths.count;
}

-(CGPoint)pointForNewCell:(CGFloat)height;
{
    int columnCount = [self columnCount];
    int cellCount = self.cellCount;
    int rowIndex = floor(cellCount / columnCount);
    int columnIndex = cellCount % columnCount;
    
    CGFloat widthUnit = [self calculatedCellWidth];
    
    if(self.columnWidths != nil) {
        widthUnit = 0;
        
        for(int i = 0; i < columnCount - 1; i++) {
            widthUnit += [(NSNumber *)[self.columnWidths objectAtIndex:i] floatValue];
            widthUnit += self.cellMargin;
        }
    }
    
    
    if(rowIndex != self.rowIteratorIndex)
    {
        self.currentHeight += self.rowIteratorHeight + self.cellMargin;
        self->_rowIteratorHeight = height;
        self->_rowIteratorIndex = rowIndex;
    } else {
        if(height > self.rowIteratorHeight)
            self->_rowIteratorHeight = height;
    }
    CGFloat y = self.currentHeight;
    return CGPointMake(columnIndex * widthUnit, y);
}



-(void)updateSize
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.currentHeight + self.rowIteratorHeight)];
}

- (void)willRemoveSubview:(UIView *)subview {
    int rowCount = [self rowCount];
    self.cellCount--;
    if([self rowCount] < rowCount) {
        self.currentHeight -= (subview.frame.size.height + self.cellMargin);
        self->_rowIteratorIndex--;
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self updateSize];
}

-(void)addCell:(UIView *)cell
{
    int height = cell.frame.size.height > 0 ? cell.frame.size.height : self.cellHeight;
    int columnIndex = self.cellCount % [self columnCount];
    CGPoint point = [self pointForNewCell:height];
    int width = self.columnWidths == nil ? self.cellWidth : [[self.columnWidths objectAtIndex:columnIndex] floatValue];
    cell.frame = CGRectMake(point.x, point.y, width, cell.frame.size.height);
    [self addSubview:cell];
    self.cellCount++;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
