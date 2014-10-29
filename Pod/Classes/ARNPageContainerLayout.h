//
//  ARNPageContainerLayout.h
//  ARNPageContainer
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARNPageContainerLayout : NSObject

+ (NSLayoutConstraint *)pinParentView:(UIView *)parentView subView:(UIView *)subView toEdge:(NSLayoutAttribute)attribute;

+ (void)allPinParentView:(UIView *)parentView subView:(UIView *)subView;

+ (NSLayoutConstraint *)addConstraintView:(UIView *)view
                                   toEdge:(NSLayoutAttribute)attribute
                                 constant:(CGFloat)constant;

@end
