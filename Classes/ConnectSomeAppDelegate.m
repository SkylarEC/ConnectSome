//
//  ConnectSomeAppDelegate.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright Skylar Cantu 2009. All rights reserved.
//

#import "ConnectSomeAppDelegate.h"
#import "ConnectSomeViewController.h"

@implementation ConnectSomeAppDelegate

@synthesize window = _window, viewController = _viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {

    [_window addSubview:_viewController.view];
    [_window makeKeyAndVisible];
	
	MainMenuViewController *mainMenu = [[MainMenuViewController alloc] initWithNibName:nil bundle:nil];
	navController = [[UINavigationController alloc] initWithRootViewController:mainMenu];
	navController.navigationBar.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.44 alpha:1.0];
	[mainMenu release];
	navController.delegate = self;
	[_window addSubview:navController.view];
}


- (void)dealloc {
	[navController release];
    [_viewController release];
    [_window release];
    [super dealloc];
}


#pragma mark
#pragma mark UINavigationControllerDelegate Methods


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)controller animated:(BOOL)animated {
	if ([controller respondsToSelector:@selector(viewWillAppear:)]) {
		[controller viewWillAppear:animated];
	}
}

/*	//Redundant
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)controller animated:(BOOL)animated {
	if ([controller respondsToSelector:@selector(viewDidAppear:)]) {
		[controller viewDidAppear:animated];
	}
}*/


@end
