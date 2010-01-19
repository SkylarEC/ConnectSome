//
//  Checker.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/19/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	CSCheckerTypeRed,
	CSCheckerTypeBlack	
} CSCheckerType;

@interface Checker : UIImageView {

}

- (id)initWithCheckerType:(CSCheckerType)checkerType;

@end
