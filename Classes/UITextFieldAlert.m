//
//  UITextFieldAlert.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/9/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "UITextFieldAlert.h"


@implementation UITextFieldAlert

@synthesize textFieldAlertDelegate = _textFieldAlertDelegate, textField = _textField;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		_textField = [[UITextField alloc] initWithFrame:CGRectZero];
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.borderStyle = UITextBorderStyleLine;
		_textField.delegate = self;
		_textField.keyboardAppearance = UIKeyboardAppearanceAlert;
		_textField.keyboardType = UIKeyboardTypeAlphabet;
		_textField.placeholder = @"Name";
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.textAlignment = UITextAlignmentLeft;
		[self addSubview:_textField];
    }
    return self;
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:CGRectMake(0, 0, rect.size.width, 150)];
	//self.center = CGPointMake(320/2, 480/2 - 50);
	self.center = CGPointMake(320/2, 480/2);
}


- (void)layoutSubviews {
	CGFloat buttonTop;
	for (UIView *view in self.subviews) {
		if ([[[view class] description] isEqualToString:@"UIThreePartButton"]) {
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);
			buttonTop = view.frame.origin.y;
		}
	}	
	buttonTop -= 7; buttonTop -= 40;
	
	_textField.frame = CGRectMake(12, buttonTop, self.frame.size.width - 53, 40);
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
}

- (void)show {
	[super show];
	//[_textField becomeFirstResponder];	//Causes MAJOR slowdown.
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
	if ([_textField isFirstResponder]) {
		[_textField resignFirstResponder];
	}
	
	switch (buttonIndex) {
		case 0:		//Cancel
			break;
		case 1:		//Save
			if (_textFieldAlertDelegate != nil && [_textFieldAlertDelegate respondsToSelector:@selector(textFieldAlert:textField:didEnterText:)]) {
				[_textFieldAlertDelegate textFieldAlert:self textField:_textField didEnterText:_textField.text];
			}
			break;
		default:
			break;
	}
	
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (void)dealloc {
	[_textField release];
    [super dealloc];
}



#pragma mark 
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[UIView beginAnimations:nil context:NULL];
	self.center = CGPointMake(320/2, 480/2 - 50);
	[UIView commitAnimations];
	return YES;	
}


- (void)textFieldDidEndEditing:(UITextField *)textField {	
	[UIView beginAnimations:nil context:NULL];
	self.center = CGPointMake(320/2, 480/2);
	[UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (![textField.text isEqualToString:@""]) {
	}
	[textField resignFirstResponder];
	
	return YES;
}



@end
