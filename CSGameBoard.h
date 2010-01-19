//
//  CSGameBoard.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/15/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSGameCore.h"
#import "CSGBColumnsView.h"
#import "GameBoard.h"
#import "CSPieceConnectionView.h"

@interface CSGameBoard : UIView <CSGBColumnsViewDelegate> {
	GameBoard			*gameBoard;
	CSGBColumnsView		*columnsView;
	CSPieceConnectionView *pieceConnectionView;
	NSInteger			lastColumnTouched;
	BOOL				_gameInProgress;
	BOOL				okayToPlacePiece;
}

@property (nonatomic) BOOL gameInProgress;

- (id)initWithFrame:(CGRect)frame autoCreateGrid:(BOOL)autoCreateGrid;	//Preferred initializer. Loads sizes directly from CSSettingsController
- (id)initWithFrame:(CGRect)frame andColumns:(NSInteger)columns andRows:(NSInteger)rows;	//Fallback initializer.

- (void)placeComputerGamePieceInColumn:(NSInteger)column andRow:(NSInteger)row;

- (void)connectWinningPieces:(BOOL)animated;
- (void)clearBoard:(BOOL)animated;

@end
