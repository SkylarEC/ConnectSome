//
//  Column.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/19/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "Column.h"

#define PADDING 5
#define CHECKER_FLUFFING 2			/*Required to offset my failure to correctly PhotoShop a checker.*/
#define FALLING_CHECKER_TAG 100
#define ADJUSTED_CHECKER_CENTER CGPointMake(checker.center.x, checker.center.y + PADDING + [self rowHeight])
#define ADD_CHECKER_ANIMATION @"AddCheckerAnimation"
#define REMOVE_CHECKER_ANIMATION @"RemoveCheckerAnimation"
#define ANIMATION_KEY @"position"
#define TEST_CHECKERDROP_WITH_UIVIEWANIMATION_KEY @"TestingCheckerDropWithUIViewAnimation"

@interface Column (PrivateMethods)
- (void)addPathToChecker:(Checker *)checker alongPath:(CGPathRef)path withSpeed:(float)seconds;
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished;
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (float)determineCheckerDiameter;
- (float)rowHeight;
@end

@implementation Column

@synthesize numberOfPiecesInColumn = _numberOfPiecesInColumn, checkerDiameter = _checkerDiameter;
@synthesize checkerPadding = _checkerPadding, rows = _rows, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _numberOfPiecesInColumn = 0;
		_checkerDiameter = self.bounds.size.width;
    }
    return self;
}

- (void)addCheckerWithType:(CSCheckerType)checkerType {
	_checkerDiameter = [self determineCheckerDiameter];
	Checker *checker = [[Checker alloc] initWithCheckerType:checkerType];
	checker.frame = CGRectMake(0, 0, _checkerDiameter, _checkerDiameter);
	checker.center = CGPointMake(self.bounds.origin.x - CHECKER_FLUFFING + PADDING / 2 + _checkerDiameter / 2, 0 - _checkerDiameter / 2);
	checker.tag = FALLING_CHECKER_TAG;
	[self addSubview:checker];
	
	repeat = _rows - _numberOfPiecesInColumn;
	_numberOfPiecesInColumn++;
	
	CGRect finalRect = CGRectMake(checker.frame.origin.x, (checker.frame.origin.y + [self rowHeight] * repeat) + PADDING * (repeat - 1), checker.frame.size.width, checker.frame.size.height);
#if TEST_CHECKERDROP_WITH_UIVIEWANIMATIONS	
	[UIView beginAnimations:TEST_CHECKERDROP_WITH_UIVIEWANIMATION_KEY context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:COLUMN_GRAVITY * repeat];
	//checker.frame = finalRect;
#else
	CGPoint finalPoint = CGPointMake(finalRect.origin.x + _checkerDiameter / 2, finalRect.origin.y + _checkerDiameter / 2);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, checker.center.x, checker.center.y);
	CGPathAddLineToPoint(path, nil, finalPoint.x, finalPoint.y);
	[self addPathToChecker:checker alongPath:path withSpeed:COLUMN_GRAVITY * repeat];
	CGPathRelease(path);
#endif	
	[checker setFrame:finalRect];
#if TEST_CHECKERDROP_WITH_UIVIEWANIMATIONS 
	[UIView commitAnimations];
#endif
	
	[checker release];
}

- (void)removePiecesFromBoard {
	for (UIView *view in self.subviews) {
		[view removeFromSuperview];
		_numberOfPiecesInColumn = 0;
	}
}


- (void)dropPiecesFromBoard {
#if MANUALLY_DROP_CHECKERS
	repeat = _rows;
	[UIView beginAnimations:REMOVE_CHECKER_ANIMATION context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:COLUMN_GRAVITY * 2];
		for(UIView *checker in self.subviews) {
			checker.center = ADJUSTED_CHECKER_CENTER;
		}	
	[UIView commitAnimations];
#else
	[self removePiecesFromBoard];
#endif
}


#pragma mark
#pragma mark PrivateMethods

- (void)addPathToChecker:(Checker *)checker alongPath:(CGPathRef)path withSpeed:(float)seconds {
	CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
	animation.calculationMode = kCAAnimationPaced;
	animation.delegate = self;
    animation.duration = seconds;
	animation.fillMode = kCAFillModeForwards;
    animation.path = path;
    animation.repeatCount = 0;

	[[checker layer] addAnimation:animation forKey:ANIMATION_KEY];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
	if ([[(CAKeyframeAnimation *)animation keyPath] isEqualToString:ANIMATION_KEY]) {
		if (_delegate != nil && [_delegate respondsToSelector:@selector(column:didFinishPlacingChecker:)]) {
			[_delegate column:self didFinishPlacingChecker:finished];
		}
	}
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
#if TEST_CHECKERDROP_WITH_UIVIEWANIMATIONS
	if ([animationID isEqualToString:TEST_CHECKERDROP_WITH_UIVIEWANIMATION_KEY]) {
		if (_delegate != nil && [_delegate respondsToSelector:@selector(column:didFinishPlacingChecker:)]) {
			[_delegate column:self didFinishPlacingChecker:[finished boolValue]];
		}
	} 
#endif
	if ([animationID isEqualToString:ADD_CHECKER_ANIMATION]) {
		UIView *checker;
		for (UIView *view in self.subviews) {
			if (view.tag = FALLING_CHECKER_TAG) {
				checker = view;
			}
		}
		
		if (repeat > 0) {
			repeat--;
			[UIView beginAnimations:ADD_CHECKER_ANIMATION context:NULL];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
			[UIView setAnimationDuration:COLUMN_GRAVITY];
			checker.center = ADJUSTED_CHECKER_CENTER;
			[UIView commitAnimations];
		} else {
			checker.tag = 0;
		}	
	} 
#if MANUALLY_DROP_CHECKERS	
	else if ([animationID isEqualToString:REMOVE_CHECKER_ANIMATION]) {
		if (repeat > 0) {
			repeat--;
			[UIView beginAnimations:REMOVE_CHECKER_ANIMATION context:NULL];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
			[UIView setAnimationDuration:COLUMN_GRAVITY * 2];
			for(UIView *checker in self.subviews) {
				if (!checker.center.y > self.frame.size.height) {
					checker.center = ADJUSTED_CHECKER_CENTER;
				} else {
					[checker removeFromSuperview];
					_numberOfPiecesInColumn--;
				}
			}	
			[UIView commitAnimations];
		}
	}
#endif

}

- (float)determineCheckerDiameter {
	float columnWidth = self.bounds.size.width;
	CGFloat rowHeight = [self rowHeight] + CHECKER_FLUFFING;
	return columnWidth < rowHeight ? columnWidth : rowHeight; 
}

- (float)rowHeight {
	CGFloat adjustedHeight = self.bounds.size.height / _rows;
	adjustedHeight -= PADDING; 
	return adjustedHeight;
}


@end
