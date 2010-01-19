//
//  Checker.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/19/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "Checker.h"

@implementation Checker

- (void)dealloc {
    [super dealloc];
}

- (id)initWithCheckerType:(CSCheckerType)checkerType {
	if (self = [super initWithFrame:CGRectZero]) {
		NSString *checkerPath = 
		checkerType == CSCheckerTypeRed
				? [NSString pathWithComponents:[NSArray arrayWithObjects:[[NSBundle mainBundle] bundlePath], @"Checker-LIGHT.png", nil]]
				: [NSString pathWithComponents:[NSArray arrayWithObjects:[[NSBundle mainBundle] bundlePath], @"Checker-DARK.png", nil]];
		UIImage *checkerImage = [[UIImage alloc] initWithContentsOfFile:checkerPath];

		[self setImage:checkerImage];
		[checkerImage release];
	}
	return self;
}

#pragma mark
#pragma mark PrivateMethods




@end
