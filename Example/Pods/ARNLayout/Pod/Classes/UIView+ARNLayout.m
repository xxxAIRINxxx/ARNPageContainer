//
//  UIView+ARNLayout.m
//  ARNLayout
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "UIView+ARNLayout.h"

#import "ARNLayoutConstraint.h"

@implementation UIView (ARNLayout)

- (NSLayoutConstraint *)arn_pinWithSubView:(UIView *)subView attribute:(NSLayoutAttribute)attribute
{
    return [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:self toItem:subView attribute:attribute];
}

- (void)arn_allPinWithSubView:(UIView *)subView
{
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:self toItem:subView attribute:NSLayoutAttributeTop];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:self toItem:subView attribute:NSLayoutAttributeBottom];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:self toItem:subView attribute:NSLayoutAttributeLeft];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:self toItem:subView attribute:NSLayoutAttributeRight];
}

- (NSLayoutConstraint *)arn_addConstraintWithAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    return [ARNLayoutConstraint addConstraintWithView:self attribute:attribute constant:constant];
}

@end
