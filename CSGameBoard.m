//
//  CSGameBoard.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/15/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "CSGameBoard.h"


@implementation CSGameBoard

@synthesize gameInProgress = _gameInProgress;

- (id)initWithFrame:(CGRect)frame autoCreateGrid:(BOOL)autoCreateGrid {	//YES. else grid is fed default values, 7x6.
	if (self = [self initWithFrame:frame]) {
		gameBoard = [[GameBoard alloc] initWithFrame:self.bounds autoCreateGrid:autoCreateGrid];
		columnsView = [[CSGBColumnsView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10) columns:[gameBoard columns] andRows:[gameBoard rows]];
		columnsView.delegate = self;
		pieceConnectionView = [[CSPieceConnectionView alloc] initWithFrame:self.bounds];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame andColumns:(NSInteger)columns andRows:(NSInteger)rows {
	if (self = [self initWithFrame:frame]) {
		gameBoard = [[GameBoard alloc] initWithFrame:self.bounds andColumns:columns andRows:rows];
		columnsView = [[CSGBColumnsView alloc] initWithFrame:self.bounds columns:columns andRows:rows];
		columnsView.delegate = self;
		pieceConnectionView = [[CSPieceConnectionView alloc] initWithFrame:self.bounds];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		okayToPlacePiece = YES;
    }
    return self;
}

- (void)didMoveToSuperview {
	if (gameBoard) {
		[self addSubview:gameBoard];
		[self insertSubview:columnsView belowSubview:gameBoard];
		[self addSubview:pieceConnectionView];
		[columnsView becomeFirstResponder];
	}
}

- (void)dealloc {
	[pieceConnectionView release];
	[gameBoard release];
	[columnsView release];
    [super dealloc];
}

- (void)placeComputerGamePieceInColumn:(NSInteger)column andRow:(NSInteger)row {
	[columnsView addPieceForPlayer:[[CSGameCore sharedGameController] lastPlayer] inColumn:column];
}

- (void)connectWinningPieces:(BOOL)animated {
	[pieceConnectionView drawLine:YES];
}

- (void)clearBoard:(BOOL)animated {
	[columnsView emptyColumns:animated];
}

#pragma mark
#pragma mark CSGBColumnsViewDelegate Methods

- (void)columnView:(CSGBColumnsView *)columnsView didFinishPlacingChecker:(BOOL)finished inColumn:(NSInteger)column {
	okayToPlacePiece = YES;
	[[CSGameCore sharedGameController] interfaceDidFinishPlacingPiece:finished];
	[[CSGameCore sharedGameController] determineWinOrTieStatus];
}


#pragma mark
#pragma mark Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(_gameInProgress) {
		UITouch *touch = [touches anyObject];
		lastColumnTouched = [columnsView detectColumnForTouch:touch];
		[columnsView highlightColumn:YES number:lastColumnTouched];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	if (_gameInProgress) {
		UITouch *touch = [touches anyObject];
		int currentColumn = [columnsView detectColumnForTouch:touch];
		[columnsView highlightColumn:NO number:lastColumnTouched];
		if (currentColumn < 0) {
			return;
		}
		if (okayToPlacePiece) {
			if (currentColumn == lastColumnTouched) {
				int currentPlayer = [[CSGameCore sharedGameController] currentPlayer];
				if ([[CSGameCore sharedGameController] playerIsHuman:currentPlayer]) {
					int row = [columnsView nextAvailableRowForColumn:lastColumnTouched];
					if ([[CSGameCore sharedGameController] attemptMoveForPlayer:currentPlayer inColumn:lastColumnTouched andRow:row]) {
						okayToPlacePiece = !okayToPlacePiece;
						[columnsView addPieceForPlayer:currentPlayer inColumn:lastColumnTouched];
					} else {
						okayToPlacePiece = YES;
					}
				}
			}
		}
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}


@end
