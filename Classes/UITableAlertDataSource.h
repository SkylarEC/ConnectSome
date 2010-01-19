//
//  UITableAlertDataSource.h
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

/*		Object doubles as a table delegate		*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UITableAlert;

@protocol UITableAlertDelegate;

@interface UITableAlertDataSource : NSObject <UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray	*_data;
	NSString		*_key;
	id <UITableAlertDelegate> _delegate;
	
}

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) id <UITableAlertDelegate> delegate;

@end

@protocol UITableAlertDelegate <NSObject>
- (void)didSelectObject:(id)object atRow:(NSInteger)row forKey:(NSString *)key;
@end

