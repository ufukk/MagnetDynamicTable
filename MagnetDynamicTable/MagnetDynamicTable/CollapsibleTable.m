//
//  CollapsibleTable.m
//  Whizz3.0
//
//  Created by ufuk on 26/12/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import "CollapsibleTable.h"

@interface CollapsibleTable()

@property NSMutableDictionary *rowHeights;


@end

@implementation CollapsibleTable


-(void)addCell:(UIView *)cell {
    [super addCell:cell];
    if(self.rowHeights == nil)
        self.rowHeights = [NSMutableDictionary new];
    
    [self.rowHeights setObject:[NSNumber numberWithInt:self.rowIteratorHeight] forKey:[NSNumber numberWithInt:self.rowIteratorIndex]];
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
