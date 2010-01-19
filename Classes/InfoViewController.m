//
//  InfoViewController.m
//  ConnectSome
//
//  Created by Skylar Cantu on 11/4/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController


- (void)loadView {
	[super loadView];
	self.navigationItem.title = @"Info";
	UITextView *textView = [[UITextView alloc] initWithFrame:self.view.frame];
	textView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:0.90];
	textView.dataDetectorTypes = UIDataDetectorTypeLink;
	textView.font = [UIFont boldSystemFontOfSize:16];
	textView.editable = NO;
	textView.scrollEnabled = YES;
	textView.text = [NSString stringWithContentsOfFile:[NSString pathWithComponents:[NSArray arrayWithObjects:[[NSBundle mainBundle] bundlePath], @"INFO", nil]] encoding:NSUTF8StringEncoding error:nil];
	textView.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:textView];
	[textView release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}


@end
