//
//  CSSettingsController.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#ifndef KEYS_DEFINED
#define KEYS_DEFINED

#define DEFAULTS [NSUserDefaults standardUserDefaults]

//Keys
#define SETTINGS_CREATED	@"CSSettingsCreated"
#define HUMAN_NAME_1		@"CSHumanName1"
#define HUMAN_NAME_2		@"CSHumanName2"
#define HUMAN_NAME_INDEX_1	@"CSHumanNameIndex1"
#define HUMAN_NAME_INDEX_2	@"CSHumanNameIndex2"
#define DEVICE_NAME			@"CSDeviceName"
#define HUMAN_NAMES			@"CSHumanNames"
#define PLAYERS				@"CSPlayers"
#define FIRST_PLAYER		@"CSFirstPlayer"
#define PIECES_REQUIRED		@"CSPiecesRequiredToWin"
#define AI_LEVEL			@"CSComputerAIIntellegence"
#define COLUMNS				@"CSColumns"
#define ROWS				@"CSRows"

//Stats
#define TOTAL_HUMAN_1_WINS			@"CSTotalHuman1Wins"
#define TOTAL_HUMAN_2_WINS			@"CSTotalHuman2Wins"
#define TOTAL_COMP_WINS_EASY		@"CSTotalComputerWinsEasy"
#define TOTAL_COMP_WINS_MED			@"CSTotalComputerWinsMedium"
#define TOTAL_COMP_WINS_HARD		@"CSTotalComputerWinsHard"
#define TOTAL_COMP_WINS_ADVANCED	@"CSTotalComputerWinsAdvanced"
#define TOTAL_COMP_WINS_EXPERT		@"CSTotalComputerWinsExpert"

//Defaults and Disobfuscators  <--todo, buy a thesaurus and find the real word for that.
#define DEFAULT_HUMAN_NAME	@"Human"
#define VERSUS_STRING		@"%@ v %@"
#define PLAYER_1_STRING		@"Player 1"
#define PLAYER_2_STRING		@"Player 2"
#define FAKE_HUMAN_NAMES	[NSArray arrayWithObjects:@"Bill", @"Mary", @"Glorgnaxx", @"Steve", @"Jill", nil]
#define VALID_AI_LEVELS		[NSArray arrayWithObjects:@"Idiot", @"Beginner", @"Average", @"Advanced", @"Expert", nil]
#define VALID_PIECES_TO_WIN	[NSArray arrayWithObjects:@"3", @"4", @"5", nil]
#define VALID_COLUMN_VALUES	[NSArray arrayWithObjects:@"5", @"6", @"7", @"8", @"9", nil]
#define VALID_ROW_VALUES	[NSArray arrayWithObjects:@"4", @"5", @"6", @"7", @"8", nil]

#endif	//KEYS_DEFINED

#import "CSSettingsController.h"

@interface CSSettingsController (PrivateMethods)
- (void)createInitialSettings;
@end

static CSSettingsController *sharedCSSettingsControllerDelegate = nil;

@implementation CSSettingsController

- (void)resetSettings {
	[self createInitialSettings];
}

- (void)resetStats {
	[DEFAULTS setInteger:0 forKey:TOTAL_HUMAN_1_WINS];
	[DEFAULTS setInteger:0 forKey:TOTAL_HUMAN_2_WINS];
	[DEFAULTS setInteger:0 forKey:TOTAL_COMP_WINS_EASY];
	[DEFAULTS setInteger:0 forKey:TOTAL_COMP_WINS_MED];
	[DEFAULTS setInteger:0 forKey:TOTAL_COMP_WINS_HARD];
	[DEFAULTS setInteger:0 forKey:TOTAL_COMP_WINS_ADVANCED];
	[DEFAULTS setInteger:0 forKey:TOTAL_COMP_WINS_EXPERT];
}

- (NSString *)humanName1 {
	return [DEFAULTS objectForKey:HUMAN_NAME_1];
}

- (NSString *)humanName2 {
	return [DEFAULTS objectForKey:HUMAN_NAME_2];
}

- (NSArray *)humanNames {
	return [DEFAULTS arrayForKey:HUMAN_NAMES];
}

- (NSInteger)humanName1Index {
	return [DEFAULTS integerForKey:HUMAN_NAME_INDEX_1];
}

- (NSInteger)humanName2Index {
	return [DEFAULTS integerForKey:HUMAN_NAME_INDEX_2];
	
}

- (NSArray *)fakeHumanNames {
	return FAKE_HUMAN_NAMES;
}

- (NSString *)deviceName {
	return [DEFAULTS objectForKey:DEVICE_NAME];
}

- (NSInteger)players {
	return [DEFAULTS integerForKey:PLAYERS];
}

- (NSInteger)adjustedFirstPlayer {
	int players = [self players];
	int firstPlayer = [self firstPlayer];
	int adjustedFirst;
	
	switch (players) {
		case 0:		//Human v Device
			adjustedFirst = firstPlayer == 0 ? 0 : 2;
			break;
		case 1:		//Human v Human
			adjustedFirst = firstPlayer == 0 ? 0 : 1;
			break;
		case 2:		//Device v Itself
			adjustedFirst = 2;
			break;
		default:
			adjustedFirst = 0;
			break;
	}
	
	return adjustedFirst;
}

- (NSInteger)adjustedSecondPlayer {
	int players = [self players];
	int firstPlayer = [self firstPlayer];
	int adjustedSecond;
	
	switch (players) {
		case 0:		//Human v Device
			adjustedSecond = firstPlayer == 0 ? 2 : 0;
			break;
		case 1:		//Human v Human
			adjustedSecond = firstPlayer == 0 ? 1 : 0;
			break;
		case 2:		//Device v Itself
			adjustedSecond  = 2;
			break;
		default:
			adjustedSecond = 0;
			break;
	}
	
	return adjustedSecond;
}

- (NSString *)getPlayerNameForPlayer:(NSInteger)player {
	NSString *playerName = @"Player";
	int adjustedPlayer = 0;
	
	switch ([self firstPlayer]) {
		case 0:
			adjustedPlayer = player == 0 ? [self adjustedFirstPlayer] : [self adjustedSecondPlayer];
			break;
		case 1:
			adjustedPlayer = player == 1 ? [self adjustedFirstPlayer] : [self adjustedSecondPlayer];
			break;
		case 2:
			adjustedPlayer = 2;
			break;
		default:
			break;
	}
	
	switch (adjustedPlayer) {
		case 0:	 playerName = [self humanName1];	break;
		case 1:	 playerName = [self humanName2];	break;
		case 2:	 playerName = [self deviceName];	break;
		default: break;
	}
	
	return playerName;
}

- (NSInteger)firstPlayer {
	return [DEFAULTS integerForKey:FIRST_PLAYER];
}

- (NSInteger)piecesToWin {
	return [DEFAULTS integerForKey:PIECES_REQUIRED];
}

- (NSInteger)computerAILevel {
	return [DEFAULTS integerForKey:AI_LEVEL];	
}

- (NSInteger)columns {
	return [DEFAULTS integerForKey:COLUMNS];
}

- (NSInteger)rows {
	return [DEFAULTS integerForKey:ROWS];
}


/*			Methods for setting the actual Settings							*/

- (void)setHumanName1:(NSString *)name {
	[DEFAULTS setObject:name forKey:HUMAN_NAME_1];
}

- (void)setHumanName2:(NSString *)name {
	[DEFAULTS setObject:name forKey:HUMAN_NAME_2];
}

- (void)addHumanName:(NSString *)name {
	NSMutableArray *namesArray = [NSMutableArray arrayWithArray:[DEFAULTS arrayForKey:HUMAN_NAMES]];
	[namesArray addObject:name];
	[DEFAULTS setObject:namesArray forKey:HUMAN_NAMES];
}	


- (BOOL)removeHumanNameAtIndex:(NSInteger)index {
	NSMutableArray *names = [NSMutableArray arrayWithArray:[DEFAULTS objectForKey:HUMAN_NAMES]];
	if (index < 0 || index >= [names count]) {
		return NO;
	} else if ([names objectAtIndex:index]) {	//Bug alert, does not work as intended if the user selects the first name on the list, D'oh! Super easy fix here.
		if (index == [self humanName1Index]) {	//If selected name is deleted, reset it to the first name in the array.
			[self setHumanName1Index:0];
		} else if (index == [self humanName2Index]) {
			[self setHumanName2Index:0];
		}
		
		[names removeObjectAtIndex:index];
		if ([names count] > 0) {
			[DEFAULTS setObject:names forKey:HUMAN_NAMES];
		}
		else {
			[DEFAULTS setObject:[NSArray arrayWithObject:DEFAULT_HUMAN_NAME] forKey:HUMAN_NAMES];
		}

		return YES;
	}
	
	return NO;
}


- (BOOL)setHumanName1Index:(NSInteger)index {
	if (index < 0 || index >= [[self humanNames] count]) {
		return NO;
	}
	
	[DEFAULTS setInteger:index forKey:HUMAN_NAME_INDEX_1];
	[DEFAULTS setObject:[[DEFAULTS objectForKey:HUMAN_NAMES] objectAtIndex:index] forKey:HUMAN_NAME_1];
	
	return YES;
}

- (BOOL)setHumanName2Index:(NSInteger)index; {
	if (index < 0 || index >= [[self humanNames] count]) {
		return NO;
	}
	
	[DEFAULTS setInteger:index forKey:HUMAN_NAME_INDEX_2];
	[DEFAULTS setObject:[[DEFAULTS objectForKey:HUMAN_NAMES] objectAtIndex:index] forKey:HUMAN_NAME_2];
	
	return YES;
}

- (void)setPlayers:(NSInteger)players {
	[DEFAULTS setInteger:players forKey:PLAYERS];
}

- (void)setFirstPlayer:(NSInteger)firstPlayer {
	[DEFAULTS setInteger:firstPlayer forKey:FIRST_PLAYER];
}

- (void)setPiecesToWin:(NSInteger)totalPieces {
	[DEFAULTS setInteger:totalPieces forKey:PIECES_REQUIRED];
}

- (void)setComputerAILevel:(NSInteger)aiLevel {
	[DEFAULTS setInteger:aiLevel forKey:AI_LEVEL];
}

- (void)setNumberOfColumns:(NSInteger)columns {
	[DEFAULTS setInteger:columns forKey:COLUMNS];
}

- (void)setNumberOfRows:(NSInteger)rows {
	[DEFAULTS setInteger:rows forKey:ROWS];
}


/*			Methods for feeding the alert popups in the Settings Entry area
			Not all the following methods will necessarily be used			*/

- (NSArray *)validPlayersValues {
	return [NSArray arrayWithObjects:
			[NSString stringWithFormat:VERSUS_STRING, [self humanName1], [self deviceName]],
			[NSString stringWithFormat:VERSUS_STRING, [self humanName1], [self humanName2]],
			[NSString stringWithFormat:VERSUS_STRING, [self deviceName], [self deviceName]],
			nil];
}

- (NSArray *)validHumanName1Values {
	return [NSArray arrayWithObject:[DEFAULTS objectForKey:HUMAN_NAME_1]];
}

- (NSArray *)validHumanName2Values {
	return [NSArray arrayWithObject:[DEFAULTS objectForKey:HUMAN_NAME_2]];
	
}

- (NSArray *)validFirstValues {
	return [NSArray arrayWithObjects:PLAYER_1_STRING, PLAYER_2_STRING, nil];	
}

- (NSArray *)validPiecesToWinValues {
	return VALID_PIECES_TO_WIN;
}

- (NSArray *)validComputerAILevelValues {
	return VALID_AI_LEVELS;
}


- (NSArray *)validColumnValues {
	return VALID_COLUMN_VALUES;
}

- (NSArray *)validRowValues {
	return VALID_ROW_VALUES;	
}


#pragma mark
#pragma mark PrivateMethods


- (void)createInitialSettings {
	[DEFAULTS setObject:DEFAULT_HUMAN_NAME forKey:HUMAN_NAME_1];
	[DEFAULTS setObject:DEFAULT_HUMAN_NAME forKey:HUMAN_NAME_2];
	[DEFAULTS setObject:[[UIDevice currentDevice] name] forKey:DEVICE_NAME];
	[DEFAULTS setInteger:0 forKey:PLAYERS];
	[DEFAULTS setInteger:0 forKey:HUMAN_NAME_INDEX_1];
	[DEFAULTS setInteger:0 forKey:HUMAN_NAME_INDEX_2];
	[DEFAULTS setInteger:0 forKey:PLAYERS];
	[DEFAULTS setInteger:0 forKey:FIRST_PLAYER];
	[DEFAULTS setInteger:4 forKey:PIECES_REQUIRED];
	[DEFAULTS setInteger:5 forKey:AI_LEVEL];
	[DEFAULTS setInteger:7 forKey:COLUMNS];
	[DEFAULTS setInteger:6 forKey:ROWS];
	if ([[DEFAULTS arrayForKey:HUMAN_NAMES] count] == 0) {
		[DEFAULTS setObject:[NSArray arrayWithObject:DEFAULT_HUMAN_NAME] forKey:HUMAN_NAMES];
	}
}


#pragma mark
#pragma mark SharedController

- (id)init {
	if (self = [super init]) {
		if (![DEFAULTS boolForKey:SETTINGS_CREATED]) {
			[self createInitialSettings];
			[self resetStats];
			[DEFAULTS setBool:YES forKey:SETTINGS_CREATED];
		}
	}
	return self;
}

+ (id)sharedController {
	@synchronized(self) {
		if (sharedCSSettingsControllerDelegate == nil) {
			[[[self alloc] init] release];	//release statement is to make the Analyzer happy. It's irrelevant in actual use: see below.
		}
	}
	return sharedCSSettingsControllerDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedCSSettingsControllerDelegate == nil) {
			sharedCSSettingsControllerDelegate = [super allocWithZone:zone];
			return sharedCSSettingsControllerDelegate;
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
