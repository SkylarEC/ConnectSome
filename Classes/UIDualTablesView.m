//
//  UIDualTablesView.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/5/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "UIDualTablesView.h"

@interface UIDualTablesView (PrivateMethods)
- (void)createButtons;
- (void)createLabels;
- (void)createTables;
@end

@implementation UIDualTablesView

@synthesize delegate = _delegate;
@synthesize options = _options, table1Title = _table1Title, table2Title = _table2Title;


- (id)initWithFrame:(CGRect)frame Options:(NSArray *)opts title1:(NSString *)title1 andTitle2:(NSString *)title2 {
	_options = [[NSMutableArray alloc] initWithArray:opts];
	_table1Title = [title1 copy];
	_table2Title = [title2 copy];
	
	return [self initWithFrame:frame];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		[self createTables];
		[self createLabels];
		[self createButtons];
    }
    return self;
}

- (void)dealloc {
	[_options removeAllObjects];
	[_options release];
	[_table1Title release];
	[_table2Title release];
    [super dealloc];
}


#pragma mark 
#pragma mark PrivateMethods


- (void)createButtons {
	int padding = 5;	//pixels
	int halfWidth = self.bounds.size.width / 2;
	
	UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, BUTTON_HEIGHT)];
	buttonsView.backgroundColor = [UIColor clearColor];
	
	Class $UIGlassButton = objc_getClass("UIGlassButton");
	UIGlassButton *backButton = [[$UIGlassButton alloc] initWithFrame:CGRectMake(padding, 0, (self.bounds.size.width / 2) - padding * 2, BUTTON_HEIGHT)];
	backButton.tintColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.75 alpha:1.0];
	[backButton setTitle:@"Set" forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UIGlassButton *addButton = [[$UIGlassButton alloc] initWithFrame:CGRectMake(padding + halfWidth, 0, (self.bounds.size.width / 2) - padding * 2, BUTTON_HEIGHT)];
	addButton.tintColor = [UIColor colorWithRed:0.00 green:0.75 blue:0.00 alpha:1.0];
	[addButton setTitle:@"Add Player" forState:UIControlStateNormal];
	[addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[buttonsView addSubview:backButton];
	[buttonsView addSubview:addButton];
	
	[self addSubview:buttonsView];
	
	[backButton release];
	[addButton release];
}

- (void)createLabels {
	int padding = 15;	//pixels
	int halfWidth = self.bounds.size.width / 2;
	
	UILabel *table1TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, LABEL_Y_OFFSET, halfWidth - padding * 2, TABLELABEL_HEIGHT)];
	UILabel *table2TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, LABEL_Y_OFFSET, halfWidth - padding * 2, TABLELABEL_HEIGHT)];
	table2TitleLabel.center = CGPointMake(table1TitleLabel.center.x + halfWidth, table1TitleLabel.center.y);
	
	table1TitleLabel.backgroundColor = table2TitleLabel.backgroundColor	= [UIColor clearColor];
	table1TitleLabel.font = table2TitleLabel.font						= [UIFont boldSystemFontOfSize:16];
	table1TitleLabel.shadowColor = table2TitleLabel.shadowColor			= [UIColor colorWithWhite:0.0 alpha:0.50];
	table1TitleLabel.shadowOffset = table2TitleLabel.shadowOffset		= CGSizeMake(0, -1); 
	table1TitleLabel.textColor = table2TitleLabel.textColor				= [UIColor colorWithWhite:0.90 alpha:1.0];
	
	table1TitleLabel.text = _table1Title;
	table2TitleLabel.text = _table2Title;
	
	[self addSubview:table1TitleLabel];
	[self addSubview:table2TitleLabel];
	
	[table1TitleLabel release];
	[table2TitleLabel release];
	
}

- (void)createTables {
	int padding = 0;	//10 for plain tables!
	int groupTableXOffset = -10;
	float halfWidth = self.bounds.size.width / 2;
	
	UITableView *table1 = [[UITableView alloc] initWithFrame:CGRectMake(groupTableXOffset, 0, halfWidth - padding * 2, self.frame.size.height - padding - 97) style:UITableViewStyleGrouped];
	UITableView *table2 = [[UITableView alloc] initWithFrame:table1.frame style:UITableViewStyleGrouped];
	
	table1.tag = TABLE1TAG;
	table2.tag = TABLE2TAG;
	
	table1.backgroundColor = table2.backgroundColor =[UIColor clearColor];
	table1.delegate = table2.delegate = table1.dataSource = table2.dataSource = self;
	table1.sectionHeaderHeight = table2.sectionHeaderHeight = 0;
	
	UIView *table1Container = [[UIView alloc] initWithFrame:CGRectInset(table1.frame, 9, 9)];	
	UIView *table2Container = [[UIView alloc] initWithFrame:CGRectInset(table2.frame, 9, 9)];
	
	[table1Container addSubview:table1];
	[table2Container addSubview:table2];
	
	table1Container.center = CGPointMake(table1.center.x + 10 , table1Container.center.y + TABLE_Y_OFFSET);	
	table2Container.center = CGPointMake(table1Container.center.x + halfWidth, table1Container.center.y);
	
	
	CALayer *table1Layer = [table1Container layer];
	[table1Layer setMasksToBounds:YES];
	[table1Layer setCornerRadius:10];
	
	CALayer *table2Layer = [table2Container layer];
	[table2Layer setMasksToBounds:YES];
	[table2Layer setCornerRadius:10];
	
	[self addSubview:table1Container];
	[self addSubview:table2Container];
	
	[table1 release];
	[table2 release];
	[table1Container release];
	[table2Container release];
}


#pragma mark
#pragma mark UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	
	switch (tableView.tag) {		//Switch is redundant, but we want to remain consistent.
		case TABLE1TAG:
			[tableView cellForRowAtIndexPath:indexPath].accessoryType = indexPath.row == table1Selection ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
			switch (indexPath.section) {
				case 0:
					cell.textLabel.text = [_options objectAtIndex:indexPath.row];
					break;
				default:
					break;
			}
			break;
		case TABLE2TAG:			
			[tableView cellForRowAtIndexPath:indexPath].accessoryType = indexPath.row == table2Selection ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
			switch (indexPath.section) {
				case 0:
					cell.textLabel.text = [_options objectAtIndex:indexPath.row];
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	
	return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_options count] <= 1) {
		return NO;
	}
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[CSSettingsController sharedController] removeHumanNameAtIndex:indexPath.row];
		[_options removeAllObjects];
		_options = [[NSMutableArray arrayWithArray:[[CSSettingsController sharedController] humanNames]] retain];
		
		int otherTableTag = tableView.tag == TABLE1TAG ? TABLE2TAG : TABLE1TAG;
		UITableView *otherTableView = nil;
		for (UIView *view in self.subviews) {
			for (UIView *subview in view.subviews)
				if (subview.tag == otherTableTag) {
					otherTableView = (UITableView *)subview;
				}
		}
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if (otherTableView) [otherTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];	
    }
}


#pragma mark
#pragma mark TableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Glorgnaxx"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Glorgnaxx The Destroyer is not human.\n\nPlease choose another player." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
		[alert show];
		[alert release];
		[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	}
	else if (_delegate != nil && [_delegate respondsToSelector:@selector(dualTableView:tableView:didSelectRowAtIndexPath:)]) {
		int oldSelectedRow = -1;
		switch (tableView.tag) {
			case TABLE1TAG:
				oldSelectedRow = table1Selection;
				table1Selection = indexPath.row;
				[[CSSettingsController sharedController] setHumanName1Index:table1Selection];
				break;
			case TABLE2TAG:
				oldSelectedRow = table2Selection;
				table2Selection = indexPath.row;
				[[CSSettingsController sharedController] setHumanName2Index:table2Selection];
				break;
			default:
				break;
		}
		
		[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldSelectedRow inSection:0]].accessoryType = UITableViewCellAccessoryNone;
		[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
		[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	}
}

/*		//TODO: Find out why this method isn't being called, yet the previous is.
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}*/			

#pragma mark
#pragma mark Button Selectors


- (void)backButtonPressed:(UIButton *)button {
	if (_delegate != nil && [_delegate respondsToSelector:@selector(dualTableView:backButtonPressed:)]) {
		[_delegate dualTableView:self backButtonPressed:button];
	}
}

- (void)addButtonPressed:(UIButton *)button {
	UITextFieldAlert *alert = [[UITextFieldAlert alloc] initWithTitle:@"Add Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	alert.textFieldAlertDelegate = self;
	[alert show];
	[alert release];
}


#pragma mark
#pragma mark UIAlertViewDelegate Methods


//TODO: This is super hacky and lame.  Find a much better way.
- (void)didPresentAlertView:(UIAlertView *)alertView {
	[((UITextFieldAlert *)alertView).textField becomeFirstResponder];
}



#pragma mark
#pragma mark UITextFieldAlertDelegate Methods

- (void)textFieldAlert:(UITextFieldAlert *)textFieldAlert textField:(UITextField *)textField didEnterText:(NSString *)text {
	if (text) {
		if (![text isEqualToString:@""]) {
			[[CSSettingsController sharedController] addHumanName:text];
			[_options addObject:text];
		}
	}
	
	for (UIView *view in self.subviews) {
		for (UIView *subview in view.subviews)
			if (subview.tag == TABLE1TAG || subview.tag == TABLE2TAG) {
				[(UITableView *)subview reloadData];
			}
	}
}


@end
