//
//  CSPieceConnectionView.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/21/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "CSPieceConnectionView.h"


@implementation CSPieceConnectionView

@synthesize line = _line;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		_line.startingCoordinate = CGPointZero;
		_line.endingCoordinate = CGPointZero;
		_line.movementPoint = _line.startingCoordinate;
		_line.movementSpeed = 0;
	}
	return self;
}

- (void)drawLine:(BOOL)animated {
	if (!animated) {
		_line.movementSpeed = 1;
	}
	if (_line.movementSpeed > 0) {
		_line.movementPoint = _line.startingCoordinate;
		[self setNeedsDisplay];
	}
}


- (void)drawRect:(CGRect)rect {	
	[super drawRect:rect];
	/*
	CGFloat movementX = (_line.endingCoordinate.x - _line.startingCoordinate.x) / _line.movementSpeed;
	CGFloat movementY = (_line.endingCoordinate.y - _line.startingCoordinate.y) / _line.movementSpeed;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(ctx, rect);
	
	CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(ctx, 5);
	CGContextSetLineCap(ctx, kCGLineCapRound);
	CGContextMoveToPoint(ctx, _line.startingCoordinate.x, _line.startingCoordinate.y);
	
	for (int i = 0; i <= _line.movementSpeed; i++) {
		_line.movementPoint.x += movementX;
		_line.movementPoint.y += movementY;
		CGContextMoveToPoint(ctx, _line.movementPoint.x, _line.movementPoint.y);
		CGContextClosePath(ctx);
		CGContextStrokePath(ctx);
	}	*/
}


- (void)dealloc {
    [super dealloc];
}


@end
