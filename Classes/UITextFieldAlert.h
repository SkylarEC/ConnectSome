//
//  UITextFieldAlert.h
//  ConnectSome
//
//  Created by Skylar Cantu on 11/9/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITextFieldAlertDelegate;

@interface UITextFieldAlert : UIAlertView <UITextFieldDelegate> {
	UITextField		*_textField;
	id<UITextFieldAlertDelegate> _textFieldAlertDelegate;
}

@property (nonatomic, assign) id<UITextFieldAlertDelegate> textFieldAlertDelegate;
@property (nonatomic, retain, readonly) UITextField *textField;

@end

@protocol UITextFieldAlertDelegate <NSObject>
- (void)textFieldAlert:(UITextFieldAlert *)textFieldAlert textField:(UITextField *)textField didEnterText:(NSString *)text;
@end

