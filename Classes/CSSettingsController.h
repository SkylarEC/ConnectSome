//
//  CSSettingsController.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#ifndef __CSSETTINGSCONTROLLER_H__
#define __CSSETTINGSCONTROLLER_H__

#import <Foundation/Foundation.h>

@interface CSSettingsController : NSObject {
}

+ (id)sharedController;

- (void)resetSettings;
- (void)resetStats;

- (NSString *)humanName1;
- (NSString *)humanName2;
- (NSArray *)humanNames;
- (NSInteger)humanName1Index;
- (NSInteger)humanName2Index;
- (NSArray *)fakeHumanNames;
- (NSString *)deviceName;
- (NSInteger)players;
- (NSInteger)firstPlayer;
- (NSInteger)adjustedFirstPlayer;
- (NSInteger)adjustedSecondPlayer;
- (NSString *)getPlayerNameForPlayer:(NSInteger)player;
- (NSInteger)piecesToWin;
- (NSInteger)computerAILevel;
- (NSInteger)columns;
- (NSInteger)rows;

- (void)setHumanName1:(NSString *)name;
- (void)setHumanName2:(NSString *)name;
- (void)addHumanName:(NSString *)name;
- (BOOL)removeHumanNameAtIndex:(NSInteger)index;
- (BOOL)setHumanName1Index:(NSInteger)index;
- (BOOL)setHumanName2Index:(NSInteger)index;
- (void)setPlayers:(NSInteger)players;
- (void)setFirstPlayer:(NSInteger)firstPlayer;
- (void)setPiecesToWin:(NSInteger)totalPieces;
- (void)setComputerAILevel:(NSInteger)aiLevel;
- (void)setNumberOfColumns:(NSInteger)columns;
- (void)setNumberOfRows:(NSInteger)rows;

/*		The following methods return reader friendly values.
		These may not be the actual value of the option.		
		They are meant to reduce obfuscation				*/
- (NSArray *)validPlayersValues;
- (NSArray *)validHumanName1Values;
- (NSArray *)validHumanName2Values;
- (NSArray *)validFirstValues;
- (NSArray *)validPiecesToWinValues;
- (NSArray *)validComputerAILevelValues;
- (NSArray *)validColumnValues;
- (NSArray *)validRowValues;

@end


#endif //__CSSETTINGSCONTROLLER_H__
