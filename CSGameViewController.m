//
//  GameViewController.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/11/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "CSGameViewController.h"

#define OFFSET 10
#define CHECKER_DIAM 30
#define CHECKER_RAD CHECKER_DIAM / 2
#define CHECKER_CENTER_OFFSET OFFSET + CHECKER_RAD

@interface CSGameViewController (PrivateMethods)
- (void)setPlayerNames;
- (void)setActivePlayer;
- (void)deactivatePlayers;
- (void)startGame;
- (void)endGame;
- (void)player:(NSInteger)player canMakeNextMove:(BOOL)canMove;
@end


@implementation CSGameViewController

@synthesize gameBoard = _gameBoard;

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor clearColor];
	_gameBoard = [[CSGameBoard alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width) autoCreateGrid:YES];
	[self.view addSubview:_gameBoard];
	_gameBoard.center = CGPointMake(self.view.center.x, self.view.center.y - UINAVIGATIONBARHEIGHTOFFSET);
	
	[self setUpLabels];
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = [NSString stringWithFormat:@"Connect %d in a row!", [[CSSettingsController sharedController] piecesToWin]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
	}
		self.view.backgroundColor = [UIColor colorWithRed:0.20 green:0.80 blue:0.50 alpha:1.0];
	if (animated) {
		[UIView commitAnimations];
	}
	[[CSGameCore sharedGameController] setDelegate:self];
	[self setPlayerNames];
	[self startGame];
}

- (void)viewWillDisappear:(BOOL)animated {	
	[super viewWillDisappear:animated];
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
	}
	self.view.backgroundColor = [UIColor clearColor];
	if (animated) {
		[UIView commitAnimations];
	}
	[[CSGameCore sharedGameController] endGame];
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ISOKAYTOCHANGEBGCOLOR" object:nil]];
}

- (void)setUpLabels {
	Checker *redChecker = [[Checker alloc] initWithCheckerType:CSCheckerTypeRed];
	Checker *blackChecker = [[Checker alloc] initWithCheckerType:CSCheckerTypeBlack];
	
	redChecker.frame = blackChecker.frame = CGRectMake(0, 0, CHECKER_DIAM, CHECKER_DIAM);
	redChecker.center = CGPointMake(CHECKER_CENTER_OFFSET, CHECKER_CENTER_OFFSET);
	blackChecker.center = CGPointMake(CHECKER_CENTER_OFFSET, self.view.bounds.size.height - CHECKER_DIAM - UINAVIGATIONBARHEIGHT);	
	[self.view addSubview:redChecker];
	[self.view addSubview:blackChecker];
	
	CGRect labelFrame = CGRectMake(CHECKER_CENTER_OFFSET + CHECKER_DIAM, OFFSET, self.view.bounds.size.width - 60, CHECKER_DIAM);
	player1Label = [[UILabel alloc] initWithFrame:labelFrame];
	player2Label = [[UILabel alloc] initWithFrame:labelFrame];
	player2Label.center = CGPointMake(player2Label.center.x, self.view.bounds.size.height - CHECKER_DIAM - UINAVIGATIONBARHEIGHT);
	
	player1Label.backgroundColor = player2Label.backgroundColor	= [UIColor clearColor];
	player1Label.shadowColor = player2Label.shadowColor			= [UIColor colorWithWhite:1.0 alpha:0.50];
	player1Label.shadowOffset = player1Label.shadowOffset		= CGSizeMake(0, -1);
	player1Label.textColor = player2Label.textColor				= [UIColor whiteColor];

	[self.view addSubview:player1Label];
	[self.view addSubview:player2Label];
	
	[redChecker release];
	[blackChecker release];		
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[player1Label release];
	[player2Label release];
	[_gameBoard release];
    [super dealloc];
}


#pragma mark
#pragma mark PrivateMethods

- (void)setPlayerNames {
	player1Label.text = [[CSSettingsController sharedController] getPlayerNameForPlayer:PLAYER1];
	player2Label.text = [[CSSettingsController sharedController] getPlayerNameForPlayer:PLAYER2];
}

- (void)setActivePlayer {
/*	BOOL keepingScore = NO;		//Set to YES to print the scores.
	if (keepingScore) {
		int player1Score = [[CSGameCore sharedGameController] scoreForPlayer:[[CSGameCore sharedGameController] currentPlayer]];
		int player2Score = [[CSGameCore sharedGameController] scoreForPlayer:[[CSGameCore sharedGameController] lastPlayer]];
		NSLog(@"Player 1 score:\t\t\t%d", player1Score); 
		NSLog(@"Player 2 score:\t\t\t%d", player2Score);
	}*/
	
	switch ([[CSGameCore sharedGameController] currentPlayer]) {
		case PLAYER1:
			[player1Label setActive:YES];
			[player2Label setActive:NO];
			break;
		case PLAYER2:
			[player1Label setActive:NO];
			[player2Label setActive:YES];
			break;
		default:
			[player1Label setActive:NO];
			[player2Label setActive:NO];
			break;
	}
}

- (void)deactivatePlayers {
	[player1Label setActive:NO];
	[player2Label setActive:NO];
}

- (void)startGame {
	[[CSGameCore sharedGameController] createNewGame];
	_gameBoard.gameInProgress = YES;
	[self setActivePlayer];
	[self player:[[CSGameCore sharedGameController] currentPlayer] canMakeNextMove:YES];
}

- (void)endGame {
	_gameBoard.gameInProgress = NO;
	[[CSGameCore sharedGameController] endGame];	
}


#pragma mark
#pragma mark CSGameCoreDelegate Methods

- (void)player:(NSInteger)player didMakeSuccessfulMove:(BOOL)success {
	if (success) {
		[self setActivePlayer];
	}
}

- (void)player:(NSInteger)player canMakeNextMove:(BOOL)canMove {
	if (![[CSGameCore sharedGameController] playerIsHuman:player] && canMove) {
		int column, row;
		if ([[CSGameCore sharedGameController] attemptMoveForComputer:[[CSGameCore sharedGameController] currentPlayer] inColumn:&column andRow:&row]) {
			[_gameBoard placeComputerGamePieceInColumn:column andRow:row];
		}	
	}
}

- (void)gameCore:(CSGameCore *)gameCore foundWinningPlayer:(NSInteger)winningPlayer {	
	[self endGame];
	[self deactivatePlayers];
	[_gameBoard connectWinningPieces:YES];
	[self showReplayAlertWithTitle:@"WINNER!" andMessage:[NSString stringWithFormat:@"%@ wins!", [[CSSettingsController sharedController] getPlayerNameForPlayer:winningPlayer]]];
}

- (void)gameCore:(CSGameCore *)gameCore gameDidTie:(BOOL)tied {
	[self endGame];
	[self deactivatePlayers];
	[self showReplayAlertWithTitle:@"TIE!" andMessage:@"The game is a tie."];
}


#pragma mark
#pragma mark UIAlertView Methods


- (void)showReplayAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Play again", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:		//Done
			//I don't know.  Do something here.
			//[self.navigationController popToRootViewControllerAnimated:YES];
			break;
		case 1:		//Play again
			[_gameBoard clearBoard:YES];
			[self startGame];
			break;
		default:
			break;
	}
}



@end
