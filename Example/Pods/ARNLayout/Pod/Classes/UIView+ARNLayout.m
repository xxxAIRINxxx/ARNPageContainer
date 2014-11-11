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

- (void)arn_checkTranslatesAutoresizingWithView:(UIView *)withView toView:(UIView *)toView
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    if (withView && withView.translatesAutoresizingMaskIntoConstraints) {
        withView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    if (toView && toView.translatesAutoresizingMaskIntoConstraints) {
        toView.translatesAutoresizingMaskIntoConstraints = NO;
    }
}

- (NSLayoutConstraint *)arn_addConstraintWithView:(UIView *)withView
                                        relatedBy:(NSLayoutRelation)relation
                                    withAttribute:(NSLayoutAttribute)withAttribute
                                           toView:(UIView *)toView
                                      toAttribute:(NSLayoutAttribute)toAttribute
                                         constant:(CGFloat)constant
{
    [self arn_checkTranslatesAutoresizingWithView:withView toView:toView];
    
    return [ARNLayoutConstraint addConstraintWithView:self
                                            relatedBy:relation
                                             withItem:withView
                                             withEdge:withAttribute
                                               toItem:toView
                                               toEdge:toAttribute
                                             constant:constant];
}

- (NSLayoutConstraint *)arn_pinWithView:(UIView *)withView
                                 toView:(UIView *)toView
                              attribute:(NSLayoutAttribute)attribute
                               constant:(CGFloat)constant
{
    return [self arn_addConstraintWithView:withView
                                 relatedBy:NSLayoutRelationEqual
                             withAttribute:attribute
                                    toView:toView
                               toAttribute:attribute
                                  constant:constant];
}

- (NSLayoutConstraint *)arn_pinWithView:(UIView *)withView
                          isWithViewTop:(BOOL)isWithViewTop
                                 toView:(UIView *)toView
                            isToViewTop:(BOOL)isToViewTop
{
    NSLayoutAttribute withViewAttribute = NSLayoutAttributeTop;
    NSLayoutAttribute toViewAttribute = NSLayoutAttributeTop;
    
    if (!isWithViewTop) {
        withViewAttribute = NSLayoutAttributeBottom;
    }
    if (!isToViewTop) {
        toViewAttribute = NSLayoutAttributeBottom;
    }
    
    return [self arn_addConstraintWithView:withView
                                 relatedBy:NSLayoutRelationEqual
                             withAttribute:withViewAttribute
                                    toView:toView
                               toAttribute:toViewAttribute
                                  constant:0.0f];
}

- (void)arn_allPinWithSubView:(UIView *)suvView
{
    [self arn_checkTranslatesAutoresizingWithView:suvView toView:nil];
    
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:suvView toItem:self attribute:NSLayoutAttributeTop constant:0.0f];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:suvView toItem:self attribute:NSLayoutAttributeBottom constant:0.0f];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:suvView toItem:self attribute:NSLayoutAttributeLeft constant:0.0f];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:suvView toItem:self attribute:NSLayoutAttributeRight constant:0.0f];
}

- (void)arn_allPinWithView:(UIView *)withView toView:(UIView *)toView
{
    [self arn_checkTranslatesAutoresizingWithView:withView toView:toView];
    
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:withView toItem:toView attribute:NSLayoutAttributeTop constant:0.0f];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:withView toItem:toView attribute:NSLayoutAttributeBottom constant:0.0f];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:withView toItem:toView attribute:NSLayoutAttributeLeft constant:0.0f];
    [ARNLayoutConstraint addPinConstraintWithParentView:self withItem:withView toItem:toView attribute:NSLayoutAttributeRight constant:0.0f];
}

- (void)arn_allPinWithView:(UIView *)withView toView:(UIView *)toView margin:(CGFloat)margin
{
    [self arn_checkTranslatesAutoresizingWithView:withView toView:toView];
    
    [ARNLayoutConstraint addPinConstraintWithParentView:self
                                               withItem:withView
                                                 toItem:toView
                                              attribute:NSLayoutAttributeTop
                                               constant:margin];
    [ARNLayoutConstraint addPinConstraintWithParentView:self
                                               withItem:withView
                                                 toItem:toView
                                              attribute:NSLayoutAttributeBottom
                                               constant:-margin];
    [ARNLayoutConstraint addPinConstraintWithParentView:self
                                               withItem:withView
                                                 toItem:toView
                                              attribute:NSLayoutAttributeLeft
                                               constant:margin];
    [ARNLayoutConstraint addPinConstraintWithParentView:self
                                               withItem:withView
                                                 toItem:toView
                                              attribute:NSLayoutAttributeRight
                                               constant:-margin];
}

- (NSLayoutConstraint *)arn_addConstraintWithAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    [self arn_checkTranslatesAutoresizingWithView:nil toView:nil];
    
    return [ARNLayoutConstraint addConstraintWithView:self attribute:attribute constant:constant];
}

@end