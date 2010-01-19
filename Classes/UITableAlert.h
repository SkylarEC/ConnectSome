//
//  UITableAlert.h
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UITableAlert : UIAlertView <UITableViewDelegate> {
	id	_tableData;
@private
	UITableView *table;
}

@property (nonatomic, assign, setter=setTableData:) id tableData;

@end
