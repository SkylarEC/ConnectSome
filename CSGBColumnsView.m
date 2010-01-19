//
//  CSGBColumnsView.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/15/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "CSGBColumnsView.h"


@interface CSGBColumnsView (PrivateMethods)
- (void)setupGameColumns;
- (void)columnsTest;
@end

@implementation CSGBColumnsView

@synthesize delegate = _delegate;
@dynamic highlightColor;

- (id)initWithFrame:(CGRect)frame columns:(NSInteger)columns andRows:(NSInteger)rows {
	if (self = [self initWithFrame:frame]) {
		_columns = columns;
		_rows = rows;
		[self setupGameColumns];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[[self layer] setMasksToBounds:YES];
		[[self layer] setCornerRadius:10];
		self.backgroundColor = [UIColor clearColor];
		columnsArray = [NSMutableArray new];
    }
    return self;
}


- (void)dealloc {
	if (_highlightColor) [_highlightColor release];
	[columnsArray removeAllObjects]; 
	[columnsArray release];
    [super dealloc];
}

- (NSInteger)detectColumnForTouch:(UITouch *)touch {
	CGPoint touchPoint = [touch locationInView:self];
	int column = -1;
	
	if (touchPoint.x < 0 || touchPoint.x > self.bounds.size.width) {
		return column;
	}
	
	for (int i = [columnsArray count] - 1; i >= 0; i--) {
		if (touchPoint.x > CGRectGetMinX([[columnsArray objectAtIndex:i] frame])) {
			column = i;
			break;
		}
	}
	
	return column;
}

- (void)highlightColumn:(BOOL)highlight number:(NSInteger)number {
	UIColor *color = highlight ? self.highlightColor : [UIColor clearColor];
	for (UIView *view in columnsArray) {
		if (view.tag == number) {
			view.backgroundColor = color;
		}
	}
}

- (NSInteger)nextAvailableRowForColumn:(NSInteger)column {
	return [[columnsArray objectAtIndex:column] numberOfPiecesInColumn];
}

- (void)addPieceForPlayer:(NSInteger)player inColumn:(NSInteger)column {
	if (column >= 0 && column < _columns) {
		[[columnsArray objectAtIndex:column] addCheckerWithType:player == 0 ? CSCheckerTypeRed : CSCheckerTypeBlack];
	}
}

- (void)emptyColumns:(BOOL)animated {
	if (animated) {
#if MANUALLY_DROP_CHECKERS
		[col dropPiecesFromBoard];
#else
		[UIView beginAnimations:@"RemoveCheckers" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView setAnimationDuration:COLUMN_GRAVITY * 2 * _rows];
		self.alpha = 0.0;
		self.center = CGPointMake(self.center.x, self.center.y + self.bounds.size.height);
		[UIView commitAnimations];
#endif
	} else {
		for (Column *col in columnsArray) {
			[col removePiecesFromBoard];
		}
	}
}

#pragma mark
#pragma mark UIAnimationDelegate Methods

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if ([animationID isEqualToString:@"RemoveCheckers"]) {
		[self emptyColumns:NO];
		self.center = CGPointMake(self.center.x, self.center.y - self.bounds.size.height);
		self.alpha = 1.0;
	}
}

#pragma mark
#pragma mark Property Overrides

- (UIColor *)highlightColor {
	if (!_highlightColor) {
		_highlightColor = [UIColor colorWithWhite:1.0 alpha:0.75];
		[_highlightColor retain];
	}
	return _highlightColor;
}

- (void)setHighlightColor:(UIColor *)color {
	if (_highlightColor) {
		[_highlightColor release];
	}
	_highlightColor = color;
	[_highlightColor retain];
}

#pragma mark
#pragma mark CSGBColumnDelegate Methods

- (void)column:(Column *)column didFinishPlacingChecker:(BOOL)finished {
	if (_delegate != nil && [_delegate respondsToSelector:@selector(columnView:didFinishPlacingChecker:inColumn:)]) {
		[_delegate columnView:self didFinishPlacingChecker:finished inColumn:column.tag];
	}
}

#pragma mark
#pragma mark PrivateMethods

- (void)setupGameColumns {
	float columnHeight = self.bounds.size.height;
	float columnWidth = self.bounds.size.width / _columns;
	float columnOffset = columnWidth;
	
	[columnsArray removeAllObjects];	
	for (int i = 0; i < _columns; i++) {
		Column *column = [[Column alloc] initWithFrame:CGRectMake(i * columnOffset, 0, columnWidth, columnHeight)];
		column.delegate = self;
		column.rows = _rows;
		[self addSubview:column];
		column.tag = i;
		[columnsArray addObject:column];
		[column release];
	}
	
#if defined COLUMNS_TEST	
	[self columnsTest];
#endif	//COLUMNS_TEST
}

- (void)columnsTest {
	if ([columnsArray count] > 0) {
		for (UIView *vw in columnsArray) {
			switch (vw.tag % 9) {
				case 0:
					vw.backgroundColor = [UIColor redColor];
					break;
				case 1:
					vw.backgroundColor = [UIColor greenColor];
					break;
				case 2:
					vw.backgroundColor = [UIColor blueColor];
					break;
				case 3:
					vw.backgroundColor = [UIColor cyanColor];
					break;
				case 4:
					vw.backgroundColor = [UIColor magentaColor];
					break;
				case 5:
					vw.backgroundColor = [UIColor orangeColor];
					break;
				case 6:
					vw.backgroundColor = [UIColor blackColor];
					break;
				case 7:
					vw.backgroundColor = [UIColor grayColor];
					break;
				case 8:
					vw.backgroundColor = [UIColor whiteColor];
					break;
				default:
					vw.backgroundColor = [UIColor whiteColor];
					break;
			}
		}
	}	
}


@end
