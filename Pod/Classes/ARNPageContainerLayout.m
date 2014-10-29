//
//  ARNPageContainerLayout.m
//  ARNPageContainer
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ARNPageContainerLayout.h"

@implementation ARNPageContainerLayout

+ (NSLayoutConstraint *)pinParentView:(UIView *)parentView subView:(UIView *)subView toEdge:(NSLayoutAttribute)attribute
{
    return [self addConstraintParentView:parentView withItem:subView toItem:parentView toEdge:attribute];
}

+ (void)allPinParentView:(UIView *)parentView subView:(UIView *)subView
{
    [self addConstraintParentView:parentView withItem:subView toItem:parentView toEdge:NSLayoutAttributeTop];
    [self addConstraintParentView:parentView withItem:subView toItem:parentView toEdge:NSLayoutAttributeBottom];
    [self addConstraintParentView:parentView withItem:subView toItem:parentView toEdge:NSLayoutAttributeLeft];
    [self addConstraintParentView:parentView withItem:subView toItem:parentView toEdge:NSLayoutAttributeRight];
}

+ (NSLayoutConstraint *)addConstraintParentView:(UIView *)parentView
                                       withItem:(UIView *)withItem
                                         toItem:(UIView *)toItem
                                         toEdge:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withItem
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:toItem
                                                                  attribute:attribute
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
    [parentView addConstraint:constraint];
    
    return constraint;
}

+ (NSLayoutConstraint *)addConstraintView:(UIView *)view
                                   toEdge:(NSLayoutAttribute)attribute
                                 constant:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:attribute
                                                                 multiplier:1.0f
                                                                   constant:constant];
    [view addConstraint:constraint];
    
    return constraint;
}

@end
