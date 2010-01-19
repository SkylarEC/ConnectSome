//
//  UIDualTablesView.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/5/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

/*	TODO:  abstract out class	*/

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "CSSettingsController.h"
#import "UITextFieldAlert.h"
#import "UIGlassButton.h"

#define TABLE1TAG 100
#define TABLE2TAG 101
#define BUTTON_HEIGHT 47
#define TABLELABEL_HEIGHT 20
#define SPACING 10
#define LABEL_Y_OFFSET BUTTON_HEIGHT + SPACING
#define TABLE_Y_OFFSET LABEL_Y_OFFSET + TABLELABEL_HEIGHT + SPACING

@protocol UIDualTablesViewDelegate;

@interface UIDualTablesView : UIView <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldAlertDelegate> {
	NSInteger		table1Selection;
	NSInteger		table2Selection;
	NSMutableArray  *_options;
	NSString		*_table1Title;
	NSString		*_table2Title;
	id<UIDualTablesViewDelegate> _delegate;
}

@property (nonatomic, assign) id<UIDualTablesViewDelegate> delegate;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) NSString *table1Title;
@property (nonatomic, retain) NSString *table2Title;

- (id)initWithFrame:(CGRect)frame Options:(NSArray *)opts title1:(NSString *)title1 andTitle2:(NSString *)title2;

@end

@protocol UIDualTablesViewDelegate <NSObject>
@optional
- (void)dualTableView:(UIDualTablesView *)tableView backButtonPressed:(UIButton *)button;
- (void)dualTableView:(UIDualTablesView *)dualTableView tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

