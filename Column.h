//
//  Column.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/19/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Checker.h"

#define TEST_CHECKERDROP_WITH_UIVIEWANIMATIONS 0	//Use this to compare CAKeyframeAnimation and UIView animations. As of now, they are about equal.
#define MANUALLY_DROP_CHECKERS 0	//Use this ONLY if your device can withstand the performance hit, Ie, 3GS and Simulator
#define COLUMN_GRAVITY 0.075

@protocol CSGBColumnDelegate;

@interface Column : UIView {
	id<CSGBColumnDelegate> _delegate;
	int _numberOfPiecesInColumn;
	float _checkerDiameter;
	float _checkerPadding;
	int _rows;
	int repeat;
}

@property (nonatomic, assign) id<CSGBColumnDelegate> delegate;
@property (nonatomic, readonly) int numberOfPiecesInColumn;
@property (nonatomic) float checkerDiameter;
@property (nonatomic) float checkerPadding;
@property (nonatomic) int rows;

- (void)addCheckerWithType:(CSCheckerType)checkerType;
- (void)removePiecesFromBoard;	//simple
- (void)dropPiecesFromBoard;	//animated. If not manually dropping the checkers, this will not animate the pieces falling.

@end

@protocol CSGBColumnDelegate <NSObject>
@optional
- (void)column:(Column *)column didFinishPlacingChecker:(BOOL)finished;
@end