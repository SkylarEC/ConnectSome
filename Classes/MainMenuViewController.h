//
//  MainMenuViewController.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "CSGameViewController.h"
#import "CSSettingsController.h"
#import "InfoViewController.h"
#import "ModalSettingsEntryController.h"
#import "UIDualTablesView.h"
#import "UIGlassButton.h"
#import "UITableAlert.h"
#import "UITableAlertDataSource.h"

#define MAINTABLE_TAG	100

@interface MainMenuViewController : UIViewController <UIAlertViewDelegate, UIDualTablesViewDelegate, UITableAlertDelegate, UITableViewDataSource, UITableViewDelegate> {
	UIView		*tableContainer;
	UITableView	*mainTable;
	UITableView	*humanNamesTable;
}

- (void)drawTitle;
- (void)setupTableView;
- (void)createButtons;
- (void)presentPlayersLists;

@end
