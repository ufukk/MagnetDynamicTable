//
//  CollapsibleTable.h
//  Whizz3.0
//
//  Created by ufuk on 26/12/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import "StaticTable.h"

@interface CollapsibleTable : StaticTable

- (BOOL)isRowCollapsed:(int)rowIndex;

- (void)collapseRow:(int)rowIndex;

- (void)expandRow:(int)rowIndex;

- (void)toggleRow:(int)rowIndex;


@end
