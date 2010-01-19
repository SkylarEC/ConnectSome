//
//  GameViewController.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/11/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Checker.h"
#import "CSGameBoard.h"
#import "CSGameCore.h"
#import "CSSettingsController.h"
#import "UILabel-CSAdditions.h"

#ifndef	UINAVIGATIONBARHEIGHT
#define	UINAVIGATIONBARHEIGHT	45
#define UINAVIGATIONBARHEIGHTOFFSET UINAVIGATIONBARHEIGHT / 2
#endif	//UINAVIGATIONBARHEIGHT

enum {
	PLAYER1,
	PLAYER2
};

@interface CSGameViewController : UIViewController <CSGameCoreDelegate, UIAlertViewDelegate> {
	CSGameBoard	*_gameBoard;
	UILabel		*player1Label;
	UILabel		*player2Label;
}

@property (nonatomic, retain, readonly) CSGameBoard *gameBoard;

- (void)setUpLabels;
- (void)showReplayAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
