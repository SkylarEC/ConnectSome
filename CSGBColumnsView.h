//
//  CSGBColumnsView.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/15/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Column.h"

//#define COLUMNS_TEST	//Uncomment this line to test the columns. Draws each column a different color.

@protocol CSGBColumnsViewDelegate;


@interface CSGBColumnsView : UIView <CSGBColumnDelegate> {
	id<CSGBColumnsViewDelegate> _delegate;
	NSMutableArray		*columnsArray;
	NSInteger	_columns;
	NSInteger	_rows;
	UIColor		*_highlightColor;
	BOOL		droppingChecker;
}

@property (nonatomic, assign) id<CSGBColumnsViewDelegate> delegate;
@property (nonatomic, retain) UIColor *highlightColor;

- (id)initWithFrame:(CGRect)frame columns:(NSInteger)columns andRows:(NSInteger)rows;
- (NSInteger)detectColumnForTouch:(UITouch *)touch;	//-1 == Touch is within no column;
- (void)highlightColumn:(BOOL)highlight number:(NSInteger)number;
- (NSInteger)nextAvailableRowForColumn:(NSInteger)column;

- (void)addPieceForPlayer:(NSInteger)player inColumn:(NSInteger)column;
- (void)emptyColumns:(BOOL)animated;

@end

@protocol CSGBColumnsViewDelegate <NSObject>
@optional
- (void)columnView:(CSGBColumnsView *)columnsView didFinishPlacingChecker:(BOOL)finished inColumn:(NSInteger)column;
@end