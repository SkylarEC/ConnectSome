//
//  ConnectSomeViewController.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright Skylar Cantu 2009. All rights reserved.
//

#import "ConnectSomeViewController.h"


@implementation ConnectSomeViewController


- (void)loadView {
	[super loadView];
	isOkayToChangeBGColor = YES;
	srand(time(0));
	[self setRandomBGColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bgNotificationReceived:) name:@"ISOKAYTOCHANGEBGCOLOR" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bgNotificationReceived:) name:@"ISNOTOKAYTOCHANGEBGCOLOR" object:nil];
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setRandomBGColor) userInfo:nil repeats:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ISOKAYTOCHANGEBGCOLOR" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ISNOTOKAYTOCHANGEBGCOLOR" object:nil];
    [super dealloc];
}


#pragma mark 
#pragma mark Methods

- (void)setRandomBGColor {
	if (isOkayToChangeBGColor) {
		float randomColor[3];
	
		for (int i = 0; i < 3; i++) {
			float component = (float)(rand() % 100 + 1) / 100;
			randomColor[i] = component;		
		}
	
		[self setBackgroundColor:[UIColor colorWithRed:randomColor[0] green:randomColor[1] blue:randomColor[2] alpha:1]];
	}
}

- (void)setBackgroundColor:(UIColor *)color {		//TODO:  This *really* should be in the view's code, as a property override. Subclass the view wand get on that.
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.60];
	self.view.backgroundColor = color;
	[UIView commitAnimations];
}


#pragma mark
#pragma mark NSNotificationCenter Methods

- (void)bgNotificationReceived:(NSNotification *)notification {
	if ([notification.name isEqualToString:@"ISOKAYTOCHANGEBGCOLOR"]) {
		isOkayToChangeBGColor = YES;
	} else if ([notification.name isEqualToString:@"ISNOTOKAYTOCHANGEBGCOLOR"]) {
		isOkayToChangeBGColor = NO;
	}
}



@end
