//
//  ConnectSomeViewController.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright Skylar Cantu 2009. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#ifndef degreesToRadians(x)
#define degreesToRadians(x) (M_PI * x / 180.0)
#endif //degreesToRadians(x)


@interface ConnectSomeViewController : UIViewController {
	BOOL	isOkayToChangeBGColor;
}

- (void)setRandomBGColor;
- (void)setBackgroundColor:(UIColor *)color;

@end

