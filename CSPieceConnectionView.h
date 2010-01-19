//
//  CSPieceConnectionView.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/21/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

/*		Done as a separate view because attempting
		to draw a line over the masked game board
		would amount to nothing but failure				*/

#import <UIKit/UIKit.h>

typedef struct {
	CGPoint	startingCoordinate;
	CGPoint	endingCoordinate;
	CGPoint	movementPoint;
	int		movementSpeed;
} Line;

@interface CSPieceConnectionView : UIView {
	Line _line;
}

@property(nonatomic) Line line;

- (void)drawLine:(BOOL)animated;

@end
