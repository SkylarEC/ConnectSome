//
//  CSGameBoard.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/11/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//


#import "GameBoard.h"

#define PADDING 5
#define GAMEBOARD_INSET 10
#define GAMEBOARD_SIZE_OFFSET GAMEBOARD_INSET * 2
#define MASK_LAYER_NAME @"CS_GAMEBOARD_MASKING_LAYER"

@interface GameBoard (PrivateMethods)
- (CGFloat)columnWidth;
- (CGFloat)rowHeight;
- (CALayer *)createGameMask;
@end

@implementation GameBoard

- (id)initWithFrame:(CGRect)frame autoCreateGrid:(BOOL)autoCreateGrid {	//YES. else grid is fed default values, 7x6.
	if (self = [self initWithFrame:frame]) {
		if (autoCreateGrid) {
			_columns = [[CSSettingsController sharedController] columns];
			_rows = [[CSSettingsController sharedController] rows];
		}
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame andColumns:(NSInteger)columns andRows:(NSInteger)rows {
	if (self = [self initWithFrame:frame]) {
		_columns = columns;
		_rows = rows;		
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _columns = 7;
		_rows = 6;
		self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)layoutSubviews {
	CALayer *maskLayer = [self createGameMask];
	[maskLayer setNeedsDisplay];
	[[self layer] setMask:maskLayer];
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
}


- (void)dealloc {
    [super dealloc];
}

- (NSInteger)columns {
	return _columns;
}

- (NSInteger)rows {
	return _rows;
}

#pragma mark
#pragma mark Property Overrides

/*- (UIView *)columnView {
	if (_columnView == nil) {
		_columnView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, GAMEBOARD_INSET, GAMEBOARD_INSET)];
		_columnView.backgroundColor = [UIColor whiteColor];
		_columnView.tag = COLUMNVIEW_TAG;
		[[_columnView layer] setMasksToBounds:YES];
		[[_columnView layer] setCornerRadius:10];
	}
	return _columnView;
}*/

/*- (void)setCenter:(CGPoint)ctr {
	[super setCenter:ctr];
	self.columnView.center = ctr;
}*/


#pragma mark
#pragma mark PrivateMethods


- (CGFloat)columnWidth {
	CGFloat adjustedWidth = ([[self layer] bounds].size.width - GAMEBOARD_SIZE_OFFSET) / _columns;
	adjustedWidth -= PADDING;
	return adjustedWidth;
}

- (CGFloat)rowHeight {
	CGFloat adjustedHeight = ([[self layer] bounds].size.height - GAMEBOARD_SIZE_OFFSET) / _rows;
	adjustedHeight -= PADDING; 
	return adjustedHeight;
}

- (float)circleDiameter {
	CGFloat columnWidth = [self columnWidth];
	CGFloat rowHeight = [self rowHeight];
	return columnWidth < rowHeight ? columnWidth : rowHeight; 
}

- (float)circleRadius {
	return [self circleDiameter] / 2;
}

- (CALayer *)createGameMask {
	CALayer *maskLayer = [CALayer layer];
	maskLayer.name = MASK_LAYER_NAME;
	maskLayer.frame = CGRectInset(self.bounds, GAMEBOARD_INSET, GAMEBOARD_INSET);
	maskLayer.delegate = self;
	return maskLayer;	
}


#pragma mark
#pragma mark  CALayerDelegate Methods


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	if ([[layer name] isEqualToString:MASK_LAYER_NAME]) {
		CGRect rect = CGContextGetClipBoundingBox(ctx);
		
		CGFloat boardRadius = 10.0;	
		CGFloat borderWidth = PADDING / 2;
		CGFloat columnWidth = [self columnWidth];
		CGFloat rowHeight = [self rowHeight];
		CGFloat circleDiameter = columnWidth < rowHeight ? columnWidth : rowHeight;
		CGFloat circleRadius = circleDiameter / 2;
		CGPoint circlePoint = CGPointMake(borderWidth, borderWidth + circleRadius);
	
		//CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, rect.size.height), 1.0, -1.0));	//FLIP	: )
		CGContextSetShouldAntialias(ctx, YES);
		CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 1.0);
	
		CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
		CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);	
		CGContextMoveToPoint(ctx, minx, midy);
		CGContextAddArcToPoint(ctx, minx, miny, midx, miny, boardRadius);
		CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, boardRadius);
		CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, boardRadius);
		CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, boardRadius);
		CGContextClosePath(ctx);
		
		for (int i = 0; i < _columns; i++) {
			for (int j  = 0; j < _rows; j++) {
				CGFloat minxCircle = circlePoint.x, midxCircle = circlePoint.x + circleRadius, maxxCircle = circlePoint.x + circleDiameter;
				CGFloat minyCircle = circlePoint.y - circleRadius, midyCircle = circlePoint.y, maxyCircle = circlePoint.y + circleRadius;
			
				CGContextMoveToPoint(ctx, circlePoint.x, circlePoint.y);
				CGContextAddArcToPoint(ctx, minxCircle, minyCircle, midxCircle, minyCircle, circleRadius);
				CGContextAddArcToPoint(ctx, maxxCircle, minyCircle, maxxCircle, midyCircle, circleRadius);
				CGContextAddArcToPoint(ctx, maxxCircle, maxyCircle, midxCircle, maxyCircle, circleRadius);
				CGContextAddArcToPoint(ctx, minxCircle, maxyCircle, minxCircle, midyCircle, circleRadius);
				CGContextClosePath(ctx);			
			
				circlePoint = CGPointMake(circlePoint.x, circlePoint.y + PADDING + rowHeight);
			}
			circlePoint = CGPointMake(circlePoint.x + PADDING + columnWidth, borderWidth + circleRadius);
		}
		
		CGContextDrawPath(ctx, kCGPathEOFill);
	} else {
		[super drawLayer:layer inContext:ctx];
	}
}


@end
