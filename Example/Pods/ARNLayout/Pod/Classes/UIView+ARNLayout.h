//
//  UIView+ARNLayout.h
//  ARNLayout
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ARNLayout)

- (NSLayoutConstraint *)arn_pinWithSubView:(UIView *)subView attribute:(NSLayoutAttribute)attribute;

- (void)arn_allPinWithSubView:(UIView *)subView;

- (NSLayoutConstraint *)arn_addConstraintWithAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;

@end
