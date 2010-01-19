//
//  UILabel-CSAdditions.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/23/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "UILabel-CSAdditions.h"


@implementation UILabel (CSAdditions)
- (void)setActive:(BOOL)active {
	self.textColor = active ? [UIColor yellowColor] : [UIColor whiteColor];
}
@end
