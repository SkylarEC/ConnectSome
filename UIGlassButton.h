/*
 *  UIGlassButton.h
 *  UIAlert-EmbeddedTable
 *
 *  Created by Skylar Cantu on 10/10/09.
 *  Copyright 2009 Skylar Cantu. All rights reserved.
 *
 */

#import <UIKit/UIButton.h>

@class UIColor;

@interface UIGlassButton : UIButton
{
    UIColor *_tintColor;
}

- (id)initWithFrame:(struct CGRect)fp8;
- (void)dealloc;
- (void)setTintColor:(id)fp8;
- (struct CGSize)sizeThatFits:(struct CGSize)fp8;
- (struct CGRect)titleRectForContentRect:(struct CGRect)fp8;
- (void)setTitleColor:(id)fp8 forStates:(unsigned int)fp12;
- (id)titleColorForState:(unsigned int)fp8;
- (void)setTitleShadowColor:(id)fp8 forStates:(unsigned int)fp12;
- (id)titleShadowColorForState:(unsigned int)fp8;
- (void)setBackgroundImage:(id)fp8 forStates:(unsigned int)fp12;
- (id)backgroundImageForState:(unsigned int)fp8;
- (id)tintColor;

@end