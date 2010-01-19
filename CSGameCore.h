//
//  CSGameCore.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/19/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "c4.h"
#import "CSSettingsController.h"

@protocol CSGameCoreDelegate;

enum {
	HUMAN = 0,
	COMPUTER = 1
};

typedef struct {
	int numberOfPlayers;
	int player[2];
	int level[2];
	int turn;
} GameValues;

@interface CSGameCore : NSObject {
	GameValues gameValues;
	id<CSGameCoreDelegate> _delegate;
}

@property (nonatomic, assign) id <CSGameCoreDelegate> delegate;

+ (id)sharedGameController;

- (void)createNewGame;
- (void)endGame;

- (NSInteger)maximumAILevel;

- (BOOL)gameInProgress;
- (NSInteger)lastPlayer;
- (NSInteger)currentPlayer;
- (BOOL)playerIsHuman:(NSInteger)player;

- (BOOL)attemptMoveForPlayer:(NSInteger)player inColumn:(NSInteger)column andRow:(NSInteger)row;
- (BOOL)attemptMoveForComputer:(NSInteger)player inColumn:(NSInteger *)column andRow:(NSInteger *)row;
- (void)interfaceDidFinishPlacingPiece:(BOOL)finished;
- (NSInteger)scoreForPlayer:(NSInteger)player;
- (void)determineWinOrTieStatus;
- (void)winCoordinates:(NSInteger *)x1 :(NSInteger *)y1 :(NSInteger *)x2 :(NSInteger *)y2;

- (NSString *)getC4CoreVersion;

@end

@protocol CSGameCoreDelegate <NSObject>
- (void)gameCore:(CSGameCore *)gameCore foundWinningPlayer:(NSInteger)winningPlayer;
- (void)gameCore:(CSGameCore *)gameCore gameDidTie:(BOOL)tied;
@optional
- (void)player:(NSInteger)player didMakeSuccessfulMove:(BOOL)success;
- (void)player:(NSInteger)player canMakeNextMove:(BOOL)canMove;
@end

