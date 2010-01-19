//
//  CSGameCore.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/19/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "CSGameCore.h"

#define SETTINGS [CSSettingsController sharedController]

static CSGameCore *sharedCSGameCoreDelegate = nil;

@interface CSGameCore (PrivateMethods)
- (void)alertDelegateToSuccessfulMoveCompletion:(BOOL)success;
- (int)numOfHumanPlayers;
@end

@implementation CSGameCore

@synthesize delegate = _delegate;

- (void)createNewGame {
	gameValues.numberOfPlayers = [self numOfHumanPlayers];
	switch (gameValues.numberOfPlayers) {
		case 0:
			gameValues.player[0] = gameValues.player[1] = COMPUTER;
			gameValues.level[0] = gameValues.level[1] = [SETTINGS computerAILevel];
			break;
		case 1:
			gameValues.player[0] = HUMAN;
			gameValues.player[1] = COMPUTER;
			gameValues.level[1] = [SETTINGS computerAILevel];
			break;
		case 2:
			gameValues.player[0] = gameValues.player[1] = HUMAN;
			break;
		default:
			gameValues.player[0] = gameValues.player[1] = COMPUTER;
			gameValues.level[0] = gameValues.level[1] = [SETTINGS computerAILevel];
			break;
	}
	
	gameValues.turn = [SETTINGS firstPlayer];
	
	c4_new_game([SETTINGS columns], [SETTINGS rows], [SETTINGS piecesToWin]);
}

- (void)endGame {
	if ([self gameInProgress]) {
		c4_end_game();
	}
}

- (NSInteger)maximumAILevel {
	return C4_MAX_LEVEL;
}

- (BOOL)gameInProgress {
	return c4_game_in_progress();
}

- (NSInteger)lastPlayer {
	return gameValues.turn == 0 ? 1 : 0;
}

- (NSInteger)currentPlayer {
	return gameValues.turn;
}

- (BOOL)playerIsHuman:(NSInteger)player {
	return gameValues.player[player] == 0 ? YES : NO;
}

- (BOOL)attemptMoveForPlayer:(NSInteger)player inColumn:(NSInteger)column andRow:(NSInteger)row {
	BOOL success = NO;
	if (gameValues.player[player] == HUMAN) {
		success = c4_make_move(player, column, NULL);
	} else if (gameValues.player[player] == COMPUTER) {
		success = NO;
	}
	
	if (success) {
		gameValues.turn = gameValues.turn == 0 ? 1 : 0;
	}	
	[self alertDelegateToSuccessfulMoveCompletion:success];	
	return success;		
}

- (BOOL)attemptMoveForComputer:(NSInteger)player inColumn:(NSInteger *)column andRow:(NSInteger *)row {
	BOOL success = NO;
	if (gameValues.player[player] == HUMAN) {
		success = NO;
	} else if (gameValues.player[player] == COMPUTER) {
		success = c4_auto_move(player, gameValues.level[player], column, row);
	}
	
	if (success) {
		gameValues.turn = gameValues.turn == 0 ? 1 : 0;
	}
	[self alertDelegateToSuccessfulMoveCompletion:success];	
	return success;		
}

- (void)interfaceDidFinishPlacingPiece:(BOOL)finished {
	BOOL canMakeNextMove = [self gameInProgress] ? finished : NO;

	if (_delegate != nil && [_delegate respondsToSelector:@selector(player:canMakeNextMove:)]) {
		[_delegate player:gameValues.turn canMakeNextMove:canMakeNextMove];
	}
}

- (NSInteger)scoreForPlayer:(NSInteger)player {
	return c4_score_of_player(player);
}

- (void)determineWinOrTieStatus {
	if(![self gameInProgress]) return;
	
	int lastPlayer = gameValues.turn == 0 ? 1 : 0;
	if (c4_is_winner(lastPlayer)) {
		if (_delegate != nil && [_delegate respondsToSelector:@selector(gameCore:foundWinningPlayer:)]) {
			[_delegate gameCore:self foundWinningPlayer:lastPlayer];
		}		
	} else if (c4_is_tie()) {
		if (_delegate != nil && [_delegate respondsToSelector:@selector(gameCore:gameDidTie:)]) {
			[_delegate gameCore:self gameDidTie:YES];
		}
	}
	
}

- (void)winCoordinates:(NSInteger *)x1 :(NSInteger *)y1 :(NSInteger *)x2 :(NSInteger *)y2 {
	c4_win_coords(x1, y1, x2, y2);
}

- (NSString *)getC4CoreVersion {
	return [NSString stringWithCString:c4_get_version() encoding:NSUTF8StringEncoding];
}

#pragma mark
#pragma mark PrivateMethods

- (void)alertDelegateToSuccessfulMoveCompletion:(BOOL)success {
	if (_delegate != nil && [_delegate respondsToSelector:@selector(player:didMakeSuccessfulMove:)]) {
		[_delegate player:gameValues.turn didMakeSuccessfulMove:success];
	}
}

- (int)numOfHumanPlayers {
	int players = 0;
	switch ([SETTINGS players]) {
		case 0:
			players = 1;
			break;
		case 1:
			players = 2;
			break;
		case 2:
			players = 0;
			break;
		default:
			break;
	}
	return players;
}

#pragma mark
#pragma mark SharedController

- (id)init {
	if (self = [super init]) {
		
	}
	return self;
}

+ (id)sharedGameController {
	@synchronized(self) {
		if (sharedCSGameCoreDelegate == nil) {
			[[[self alloc] init] release];	//release statement is to make the Analyzer happy. It's irrelevant in actual use: see below.
		}
	}
	return sharedCSGameCoreDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedCSGameCoreDelegate == nil) {
			sharedCSGameCoreDelegate = [super allocWithZone:zone];
			return sharedCSGameCoreDelegate;
		}
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (void)release {
	//Do nothing
}

- (id)autorelease {
	return self;
}


@end
