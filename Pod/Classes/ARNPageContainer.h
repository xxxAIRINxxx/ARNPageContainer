//
//  ARNPageContainer.h
//  ARNPageContainer
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARNPageContainer : UIViewController

@property (nonatomic, copy) void (^changeOffsetBlock)(UICollectionView *collectionView, NSInteger selectedIndex);
@property (nonatomic, copy) void (^changeIndexBlock)(UIViewController *selectIndexController, NSInteger selectedIndex);
@property (nonatomic, copy) void (^updateHeaderTitleBlock)(NSArray *headerTitles);

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) CGFloat topBarHeight;

- (void)setParentVC:(UIViewController *)controller;

- (void)setTopBarView:(UIView *)topBarView;

- (void)addVC:(UIViewController *)controller;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

- (NSArray *)headerTitles;
- (void)updateHeaderTitle;

@end
