//
//  UITableAlertDataSource.m
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "UITableAlertDataSource.h"


@implementation UITableAlertDataSource
@synthesize data = _data, key = _key, delegate = _delegate;


- (void)dealloc {
	[_key release];
	[_data removeAllObjects];
	[_data release];
	[super dealloc];
}

- (id)initWithArray:(NSMutableArray *)array {
	if (self = [super init]) {
		self.data = [array mutableCopy];
	}
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_data count];	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [_data objectAtIndex:indexPath.row];			
			break;
		default:
			break;
	}
	
	return cell;
}


#pragma mark
#pragma mark TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectObject:atRow:forKey:)]) {
		[_delegate didSelectObject:[_data objectAtIndex:indexPath.row] atRow:indexPath.row forKey:_key];
	}
	
	[(UIAlertView *)tableView.superview.superview dismissWithClickedButtonIndex:0 animated:YES];
}

@end