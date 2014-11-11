//
//  ARNLayoutConstraint.h
//  ARNLayout
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARNLayoutConstraint : NSObject

+ (NSLayoutConstraint *)addConstraintWithView:(UIView *)addView
                                    relatedBy:(NSLayoutRelation)relation
                                     withItem:(UIView *)withItem
                                     withEdge:(NSLayoutAttribute)withEdge
                                       toItem:(UIView *)toItem
                                       toEdge:(NSLayoutAttribute)toEdge
                                     constant:(CGFloat)constant;

+ (NSLayoutConstraint *)addPinConstraintWithParentView:(UIView *)parentView
                                              withItem:(UIView *)withItem
                                                toItem:(UIView *)toItem
                                             attribute:(NSLayoutAttribute)attribute
                                              constant:(CGFloat)constant;

+ (NSLayoutConstraint *)addPinConstraintWithParentView:(UIView *)parentView
                                              withItem:(UIView *)withItem
                                         withAttribute:(NSLayoutAttribute)withAttribute
                                                toItem:(UIView *)toItem
                                           toAttribute:(NSLayoutAttribute)toAttribute;

+ (NSLayoutConstraint *)addConstraintWithView:(UIView *)view
                                    attribute:(NSLayoutAttribute)attribute
                                     constant:(CGFloat)constant;

@end