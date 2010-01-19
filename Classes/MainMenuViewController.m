//
//  MainMenuViewController.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController (PrivateMethods)
- (void)playButtonPressed:(UIButton *)button;
- (void)infoButtonPressed:(UIButton *)button;
- (void)mainTableSelectedCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)slideTable:(NSInteger)direction;
@end


@implementation MainMenuViewController


- (void)loadView {
	[super loadView];
	self.navigationController.navigationBarHidden = YES;
	self.navigationItem.title = @"Main Menu";
	self.view.backgroundColor = [UIColor clearColor];
	[self drawTitle];
	[self setupTableView];
	[self createButtons];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mainTable release];
	[tableContainer release];
    [super dealloc];
}



#pragma mark 
#pragma mark Methods

- (void)drawTitle {
	
	const char *textString = "ConnectSome";
	const char *fontString = "Trebuchet MS";
	int fontSize = 48;
	CGRect labelFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 4);
	UIImageView *labelImage = [[UIImageView alloc] initWithFrame:labelFrame];
	
	/*		Set some basic information we'll need to draw						
			Also, invert the image contest so he text will be right side up		*/
	UIGraphicsBeginImageContext(labelFrame.size);
	CGContextConcatCTM(UIGraphicsGetCurrentContext(), CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, labelFrame.size.height), 1.0, -1.0));
	CGContextSelectFont(UIGraphicsGetCurrentContext(), fontString, fontSize, kCGEncodingMacRoman);
	CGContextSetTextPosition(UIGraphicsGetCurrentContext(), 15, (labelFrame.size.height / 2) - (fontSize / 2));	
	
	/*		Set the text color and text outline width							*/
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 0.66);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2);
	CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 0.75);
	CGContextSetTextDrawingMode(UIGraphicsGetCurrentContext(), kCGTextFillStroke);	
	
	/*		Finally, since we're not actually drawing to screen right now,
			draw the text and make an image out of it							*/
	CGContextShowText(UIGraphicsGetCurrentContext(), textString, strlen(textString));
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeOverlay);
	labelImage.image = UIGraphicsGetImageFromCurrentImageContext();		
	UIGraphicsEndImageContext();
	
	[self.view addSubview:labelImage];
	labelImage.center = CGPointMake(labelFrame.size.width / 2, labelFrame.size.height / 2);
	
	[labelImage release];
}


- (void)setupTableView {
	float quarterHeight = self.view.frame.size.height / 4;
	
	tableContainer = [[UIView alloc] initWithFrame:CGRectMake(0, quarterHeight, self.view.bounds.size.width, quarterHeight * 3)];
	tableContainer.backgroundColor = [UIColor clearColor];
	
	mainTable = [[UITableView alloc] initWithFrame:tableContainer.bounds style:UITableViewStyleGrouped];
	mainTable.backgroundColor = [UIColor clearColor];
	mainTable.dataSource = self;
	mainTable.delegate = self;
	mainTable.scrollEnabled = NO;
	mainTable.tag = MAINTABLE_TAG;
		
	[self.view addSubview:tableContainer];
	[tableContainer addSubview:mainTable];

}


- (void)createButtons {
	/*		Info Button		*/
	int padding = 5;	//pixels
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	infoButton.frame = CGRectMake(0, 0, 20, 20);
	[infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	infoButton.center = CGPointMake(self.view.bounds.size.width - padding - infoButton.bounds.size.width / 2, 0 + padding + infoButton.bounds.size.height / 2);
	[self.view addSubview:infoButton];
	
	/*		Play button		*/
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainTable.bounds.size.width, 47)];
	headerView.backgroundColor = [UIColor clearColor];
	
	Class $UIGlassButton = objc_getClass("UIGlassButton");
	UIGlassButton *playButton = [[$UIGlassButton alloc] initWithFrame:CGRectMake(5, 0, mainTable.bounds.size.width - 10, 47)];
	playButton.tintColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.75 alpha:1.0];
	[playButton setTitle:@"Play !" forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(playButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
	[headerView addSubview:playButton];
	mainTable.tableHeaderView = headerView;
	[mainTable reloadData];
	[headerView release];
	[playButton release];
}


- (void)presentPlayersLists {
	UIDualTablesView *dualTableView = [[UIDualTablesView alloc] initWithFrame:tableContainer.bounds Options:[[CSSettingsController sharedController] humanNames] title1:@"Human Player 1" andTitle2:@"Human Player 2"];
	dualTableView.delegate = self;
	
	
	[self slideTable:0];
	[[tableContainer.subviews objectAtIndex:0] removeFromSuperview];
	[tableContainer addSubview:dualTableView];
	 
	[dualTableView release];
}

#pragma mark 
#pragma mark TableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:  return 6; break;
		default: return 0;  break;
	}
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:0.90];
		//cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
	
	static NSString *players = @"";
	if (indexPath.section == 0 && indexPath.row == 0) {
		switch ([[CSSettingsController sharedController] players]) {
			case 0:
				players = [NSString stringWithFormat:@"%@ v %@", [[CSSettingsController sharedController] humanName1], [[CSSettingsController sharedController] deviceName]];
				break;
			case 1:
				players = [NSString stringWithFormat:@"%@ v %@", [[CSSettingsController sharedController] humanName1], [[CSSettingsController sharedController] humanName2]];
				break;
			case 2:
				players = [NSString stringWithFormat:@"%@ v %@", [[CSSettingsController sharedController] deviceName], [[CSSettingsController sharedController] deviceName]];
				break;
			default:
				break;
		}
	}
	
	static NSString *firstPlayer = @"Nobody";
	if (indexPath.section == 0 && indexPath.row == 1) {
		int fp = [[CSSettingsController sharedController] adjustedFirstPlayer];
		switch (fp) {
			case 0: firstPlayer = [NSString stringWithFormat:@"%@", [[CSSettingsController sharedController] humanName1]];	break;
			case 1: firstPlayer = [NSString stringWithFormat:@"%@", [[CSSettingsController sharedController] humanName2]];	break;
			case 2: firstPlayer = [NSString stringWithFormat:@"%@", [[CSSettingsController sharedController] deviceName]];	break;
			default: firstPlayer = [NSString stringWithFormat:@"%@", [[CSSettingsController sharedController] humanName1]];	break;
		}
	}
	
	
	static NSString *AIIntellegenceLevel = @"?";
	if (indexPath.section == 0 && indexPath.row == 2) {
		int aiLevel = [[CSSettingsController sharedController] computerAILevel];
		if (aiLevel >= 10) {
			AIIntellegenceLevel = @"Expert";
		}
		else if (aiLevel >= 7) {
			AIIntellegenceLevel = @"Advanced";
		}
		else if (aiLevel >= 5) {
			AIIntellegenceLevel = @"Average";
		}
		else if (aiLevel >= 3) {
			AIIntellegenceLevel = @"Beginner";
		}
		else if (aiLevel >= 0) {
			AIIntellegenceLevel = @"Idiot";
		}
	}
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Players";
					cell.detailTextLabel.text = players;
					break;
				case 1:
					cell.textLabel.text = @"Who plays first?";
					cell.detailTextLabel.text = firstPlayer;
					break;
				case 2:
					cell.textLabel.text = @"Number to connect";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[CSSettingsController sharedController] piecesToWin]];
					break;
				case 3:
					cell.textLabel.text = @"AI Intelligence";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", AIIntellegenceLevel];
					break;
				case 4:
					cell.textLabel.text = @"Number of Columns";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[CSSettingsController sharedController] columns]];
					break;
				case 5:
					cell.textLabel.text = @"Number of Rows";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[CSSettingsController sharedController] rows]];
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


#pragma mark
#pragma mark TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView.tag == MAINTABLE_TAG) {
		UITableAlert *alert = [[UITableAlert alloc] initWithTitle:@" " message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		alert.delegate = self;
		[alert show];
		[alert release];
	}
}


#pragma mark
#pragma mark Table Cell Selection Methods

- (void)mainTableSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
	[mainTable deselectRowAtIndexPath:indexPath animated:YES];
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	switch (indexPath.row) {
		case 0:
			[animation setType:kCATransitionPush];
			[animation setSubtype:kCATransitionFromRight];
			break;
		default:
			break;
	}
	 [animation setFillMode:@"extended"];
	 [animation setRemovedOnCompletion:NO];
	 [[tableContainer layer] addAnimation:animation forKey:@"animation"];
}


#pragma mark 
#pragma mark UITableAlert Methods 


- (void)willPresentAlertView:(UIAlertView *)alertView {
	NSString *alertTitle;

	NSIndexPath *indexPath = [mainTable indexPathForSelectedRow];
	switch (indexPath.row) {
		case 0:
			alertTitle = @"Players";
			break;
		case 1:
			alertTitle = @"First Player";
			break;
		case 2:
			alertTitle = @"Number to Connect";
			break;
		case 3:
			alertTitle = @"AI Intelligence";
			break;
		case 4:
			alertTitle = @"Columns";
			break;
		case 5:
			alertTitle = @"Rows";
			break;
		default:
			alertTitle = @"";
			break;
	}
	
	alertView.title = alertTitle;
}


- (void)didPresentAlertView:(UIAlertView *)alertView {
	
	NSIndexPath *indexPath = [mainTable indexPathForSelectedRow];
	[mainTable deselectRowAtIndexPath:indexPath animated:YES];
	
	NSArray *data;
	NSString *key;
	
	switch (indexPath.row) {
		case 0:
			data = [[CSSettingsController sharedController] validPlayersValues];
			key = @"CSPlayers";
			break;
		case 1:
			data = [[CSSettingsController sharedController] validFirstValues];
			key = @"CSFirstPlayer";
			break;
		case 2:
			data = [[CSSettingsController sharedController] validPiecesToWinValues];
			key = @"CSPiecesRequiredToWin";
			break;
		case 3:
			data = [[CSSettingsController sharedController] validComputerAILevelValues];
			key = @"CSComputerAIIntellegence";
			break;
		case 4:
			data = [[CSSettingsController sharedController] validColumnValues];
			key = @"CSColumns";
			break;
		case 5:
			data = [[CSSettingsController sharedController] validRowValues];
			key = @"CSRows";
			break;
		default:
			data = nil;
			break;
	}
	
	if (data) {
		UITableAlertDataSource *dataSource = [[UITableAlertDataSource alloc] initWithArray:data];	
		((UITableAlert *)alertView).tableData = dataSource;
		((UITableAlertDataSource *)((UITableAlert *)alertView).tableData).key = key;
		((UITableAlertDataSource *)((UITableAlert *)alertView).tableData).delegate = self;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
}

- (void)didSelectObject:(id)object atRow:(NSInteger)row forKey:(NSString *)key {
	if ([key isEqualToString:@"CSPlayers"]) {
		[[CSSettingsController sharedController] setPlayers:row];
		if (row < 2) [self presentPlayersLists];
	} else if ([key isEqualToString:@"CSFirstPlayer"]) {
		[[CSSettingsController sharedController] setFirstPlayer:row];
	} else if ([key isEqualToString:@"CSPiecesRequiredToWin"]) {
		[[CSSettingsController sharedController] setPiecesToWin:[[[[CSSettingsController sharedController] validPiecesToWinValues] objectAtIndex:row] integerValue]];
	} else if ([key isEqualToString:@"CSComputerAIIntellegence"]) {
		int ptw;
		switch (row) {
			case 0:			//Idiot
				ptw = 1;
				break;
			case 1:			//Beginner
				ptw = 4;
				break;
			case 2:			//Average
				ptw = 5;
				break;
			case 3:			//Advanced
				ptw = 7;
				break;
			case 4:			//Expert
				ptw = 10;
				break;
			case 5:			//Master
				ptw = 12;
				break;
			case 6:			//GOD
				ptw = [[CSGameCore sharedGameController] maximumAILevel];
				break;
			default:
				ptw = 5;
				break;
		}
		[[CSSettingsController sharedController] setComputerAILevel:ptw];	
	} else if ([key isEqualToString:@"CSColumns"]) {
		[[CSSettingsController sharedController] setNumberOfColumns:[[[[CSSettingsController sharedController] validColumnValues] objectAtIndex:row] integerValue]];		
	} else if ([key isEqualToString:@"CSRows"]) {
		[[CSSettingsController sharedController] setNumberOfRows:[[[[CSSettingsController sharedController] validRowValues] objectAtIndex:row] integerValue]];
	}
	
	[mainTable reloadData];
}


#pragma mark
#pragma mark UIDualTablesViewDelegate Methods

- (void)dualTableView:(UIDualTablesView *)tableView backButtonPressed:(UIButton *)button {
	[self slideTable:1];
	[[tableContainer.subviews objectAtIndex:0] removeFromSuperview];
	[tableContainer addSubview:mainTable];	
}

- (void)dualTableView:(UIDualTablesView *)dualTableView tableView:tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self slideTable:1];
	[[tableContainer.subviews objectAtIndex:0] removeFromSuperview];
	[tableContainer addSubview:mainTable];
}


#pragma mark
#pragma mark PrivateMethods

- (void)slideTable:(NSInteger)direction {
	CATransition *animation = [CATransition animation];
	if (direction == 1) {
		[animation setDelegate:self];
	}
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	switch (direction) {
		case 0:
			[animation setType:kCATransitionPush];
			[animation setSubtype:kCATransitionFromRight];
			break;
		case 1:			
			[animation setType:kCATransitionPush];
			[animation setSubtype:kCATransitionFromLeft];
			break;
		case 2:			
			[animation setType:kCATransitionPush];
			[animation setSubtype:kCATransitionFromTop];
			break;
		case 3:			
			[animation setType:kCATransitionPush];
			[animation setSubtype:kCATransitionFromBottom];
			break;
		default:
			break;
	}
	[animation setFillMode:@"extended"];
	[animation setRemovedOnCompletion:NO];
	[[tableContainer layer] addAnimation:animation forKey:@"animation"];	
}

- (void)playButtonPressed:(UIButton *)button {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ISNOTOKAYTOCHANGEBGCOLOR" object:nil]];
	CSGameViewController *gameViewController = [[CSGameViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:gameViewController animated:YES];
	[gameViewController release];
	
}

- (void)infoButtonPressed:(UIButton *)button {
	InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:infoViewController animated:YES];
	[infoViewController release];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
	[mainTable reloadData];
}

@end
