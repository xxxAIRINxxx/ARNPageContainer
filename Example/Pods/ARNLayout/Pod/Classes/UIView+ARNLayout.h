//
//  UIView+ARNLayout.h
//  ARNLayout
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ARNLayout)

- (NSLayoutConstraint *)arn_addConstraintWithView:(UIView *)withView
                                        relatedBy:(NSLayoutRelation)relation
                                    withAttribute:(NSLayoutAttribute)withAttribute
                                           toView:(UIView *)toView
                                      toAttribute:(NSLayoutAttribute)toAttribute
                                         constant:(CGFloat)constant;

- (NSLayoutConstraint *)arn_pinWithView:(UIView *)withView
                                 toView:(UIView *)toView
                              attribute:(NSLayoutAttribute)attribute
                               constant:(CGFloat)constant;

- (NSLayoutConstraint *)arn_pinWithView:(UIView *)withView
                          isWithViewTop:(BOOL)isWithViewTop
                                 toView:(UIView *)toView
                            isToViewTop:(BOOL)isToViewTop;

- (void)arn_allPinWithSubView:(UIView *)suvView;

- (void)arn_allPinWithView:(UIView *)withView toView:(UIView *)toView;

- (void)arn_allPinWithView:(UIView *)withView toView:(UIView *)toView margin:(CGFloat)margin;

- (NSLayoutConstraint *)arn_addConstraintWithAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;

@end