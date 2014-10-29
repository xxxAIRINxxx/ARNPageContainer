//
//  ARNPageContainerTopTabView.h
//  ARNPageContainer
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 TODO : AutoLayout
 TODO : IndicatorView
 */

@interface ARNPageContainerTopTabView : UIView

@property (nonatomic, copy) void (^selectTitleBlock)(NSInteger selectedIndex);

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) UIColor *pageItemsTitleColor;
@property (nonatomic, strong) UIColor *selectedPageItemTitleColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIFont  *font;
@property (nonatomic, assign) CGFloat itemMargin;

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index;
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index;

- (void)setItemTitles:(NSArray *)itemTitles;

- (void)changeParentScrollView:(UIScrollView *)parentScrollView
                 selectedIndex:(NSInteger)selectedIndex
                  totalVCCount:(NSInteger)totalVCCount;

@end
