//
//  CSGameBoard.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/11/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "CSSettingsController.h"

@interface GameBoard : UIView {
	NSInteger	_columns;
	NSInteger	_rows;
}

- (id)initWithFrame:(CGRect)frame autoCreateGrid:(BOOL)autoCreateGrid;	//Preferred initializer. Loads sizes directly from CSSettingsController
- (id)initWithFrame:(CGRect)frame andColumns:(NSInteger)columns andRows:(NSInteger)rows;	//Fallback initializer.

- (NSInteger)columns;
- (NSInteger)rows;

@end