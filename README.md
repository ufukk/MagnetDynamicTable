MagnetDynamicTable is a simple replacement for UITableView. Basic idea is to provide HTML table like functionality on IOS. Instead of using delegate events as with UITableView, you'll add, replace and remove cells directly after initialization or at runtime.

A table cell is simply an instance of UIView. Cell positions are set as you add them to the table, so you won't need to worry about that. You can also replace and remove cells and all cell positions will be automatically updated.

Creating a table is simple:

		DynamicTable *table = [[DynamicTable alloc] initWithFrame:CGRectMake(0, 0, 500, 100) cellWidth:260 cellMargin:5 title:nil];

Height is unimportant as it will be automatically set to total row height.

Adding a cell:

		UIView *view = [UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)]
		[table addCell:view];

For table cells, position given at the initialization is unimportant as it will be reset after calling addCell method. 

You can use a table instance as another table's cell. In that case, height of parent table will be updated as the child table's size changes:

		[parentTable updateSize];

You can also expand and collapse rows with or without animation:

		[table expandRow:rowOrCellIndex animate:YES];
		[table collapseRow:rowOrCellIndex animate:YES];
		[table toggleRow:rowOrCellIndex animate:YES];
		