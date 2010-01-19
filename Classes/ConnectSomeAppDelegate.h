//
//  ConnectSomeAppDelegate.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright Skylar Cantu 2009. All rights reserved.
//


/*		UINavigationController *navController was begrudgedly 
		added into the application as an Ivar.  This is useless 
		and serves absolutely no in app purpose.
		**Why then?**	When you build /this/ application with 
		either a release or autorelease statement immediately after 
		you use navController, the application won't draw 
		navController's root view controller.  Now, knowing how
		the application works there would be no memory or 
		performance drain for omitting the release statement.
		However, doing so causes the static analyzer to yell about
		the possible leak of navController.  The simple solution is
		to make navController an Ivar and release it in -dealloc.
																		*/

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"

@class ConnectSomeViewController;

@interface ConnectSomeAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> {
    UIWindow *_window;
    ConnectSomeViewController *_viewController;
	UINavigationController *navController;		//See note above
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ConnectSomeViewController *viewController;

@end

