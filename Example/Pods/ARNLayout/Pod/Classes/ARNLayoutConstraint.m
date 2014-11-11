//
//  ARNLayoutConstraint.m
//  ARNLayout
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ARNLayoutConstraint.h"

@implementation ARNLayoutConstraint

+ (NSLayoutConstraint *)addConstraintWithView:(UIView *)addView
                                    relatedBy:(NSLayoutRelation)relation
                                     withItem:(UIView *)withItem
                                     withEdge:(NSLayoutAttribute)withEdge
                                       toItem:(UIView *)toItem
                                       toEdge:(NSLayoutAttribute)toEdge
                                     constant:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withItem
                                                                  attribute:withEdge
                                                                  relatedBy:relation
                                                                     toItem:toItem
                                                                  attribute:toEdge
                                                                 multiplier:1.0f
                                                                   constant:constant];
    [addView addConstraint:constraint];
    
    return constraint;
}

+ (NSLayoutConstraint *)addPinConstraintWithParentView:(UIView *)parentView
                                              withItem:(UIView *)withItem
                                                toItem:(UIView *)toItem
                                             attribute:(NSLayoutAttribute)attribute
                                              constant:(CGFloat)constant
{
    return [self addConstraintWithView:parentView
                             relatedBy:NSLayoutRelationEqual
                              withItem:withItem
                              withEdge:attribute
                                toItem:toItem
                                toEdge:attribute
                              constant:constant];
}

+ (NSLayoutConstraint *)addPinConstraintWithParentView:(UIView *)parentView
                                              withItem:(UIView *)withItem
                                         withAttribute:(NSLayoutAttribute)withAttribute
                                                toItem:(UIView *)toItem
                                           toAttribute:(NSLayoutAttribute)toAttribute;
{
    return [self addConstraintWithView:parentView
                             relatedBy:NSLayoutRelationEqual
                              withItem:withItem
                              withEdge:withAttribute
                                toItem:toItem
                                toEdge:toAttribute
                              constant:0.0f];
}

+ (NSLayoutConstraint *)addConstraintWithView:(UIView *)view
                                    attribute:(NSLayoutAttribute)attribute
                                     constant:(CGFloat)constant
{
    return [self addConstraintWithView:view
                             relatedBy:NSLayoutRelationEqual
                              withItem:view
                              withEdge:attribute
                                toItem:nil
                                toEdge:attribute
                              constant:constant];
}

@end