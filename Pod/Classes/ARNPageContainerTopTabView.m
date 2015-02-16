//
//  ARNPageContainerTopTabView.m
//  ARNPageContainer
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ARNPageContainerTopTabView.h"

CGFloat const ARNPageContainerTopTabViewItemMargin = 30.0f;

@interface ARNPageContainerTopTabView ()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) NSArray *itemViews;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ARNPageContainerTopTabView

- (void)commonInit
{
    [self settingScrollView];
    
    _selectedIndex = 0;
    _font = [UIFont systemFontOfSize:14];
    _itemTitleColor = [UIColor lightGrayColor];
    _selectedPageItemTitleColor = [UIColor whiteColor];
    _itemMargin = ARNPageContainerTopTabViewItemMargin;
}

- (void)settingScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.scrollEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) { return nil; }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) { return nil; }
    
    [self commonInit];
    
    return self;
}

#pragma mark - Public

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index
{
    if (self.itemViews.count <= index) {
        return CGPointZero;
    }
    
    CGPoint center = ((UIView *)self.itemViews[index]).center;
    CGPoint offset = [self contentOffsetForSelectedItemAtIndex:index];
    center.x -= offset.x - (CGRectGetMinX(self.scrollView.frame));
    return center;
}

- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index
{
    if (self.itemViews.count < index || self.itemViews.count == 1) {
        return CGPointZero;
    } else {
        CGFloat totalOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
        return CGPointMake(index * totalOffset / (self.itemViews.count - 1), 0.0f);
    }
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor
{
    if (![_itemTitleColor isEqual:itemTitleColor]) {
        _itemTitleColor = itemTitleColor;
        
        [self.itemViews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            [button setTitleColor:itemTitleColor forState:UIControlStateNormal];
        }];
    }
}

- (void)setItemTitles:(NSArray *)itemTitles
{
    if (self.itemViews) {
        [self cleanup];
    }
    
    NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:itemTitles.count];
    [itemTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        if ([title isKindOfClass:[NSString class]]) {
            UIButton *itemView = [self addItemView];
            [itemView setTitle:title forState:UIControlStateNormal];
            [mutableItemViews addObject:itemView];
        }
    }];
    self.itemViews = [NSArray arrayWithArray:mutableItemViews];
    
    [self resetButtonTitleColor];
    
    [self layoutItemViews];
}

#pragma mark - Getter,  Setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage;
}

- (void)setFont:(UIFont *)font
{
    if (![_font isEqual:font]) {
        _font = font;
        [self.itemViews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            [button.titleLabel setFont:font];
        }];
    }
}

- (void)setItemMargin:(CGFloat)itemMargin
{
    _itemMargin = itemMargin;
    [self layoutItemViews];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    [self resetButtonTitleColor];
    [self layoutItemViews];
}

#pragma mark * Lazy getters

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_backgroundImageView belowSubview:self.scrollView];
    }
    return _backgroundImageView;
}

#pragma mark - Private

- (void)cleanup
{
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button removeFromSuperview];
    }];
    
    self.itemViews = nil;
}

- (void)resetButtonTitleColor
{
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (_selectedIndex == idx) {
            [button setTitleColor:self.selectedPageItemTitleColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:self.itemTitleColor forState:UIControlStateNormal];
        }
    }];
}

- (UIButton *)addItemView
{
    UIButton *itemView = [[UIButton alloc] initWithFrame:CGRectZero];
    itemView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [itemView addTarget:self action:@selector(itemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    itemView.titleLabel.font = self.font;
    [itemView setTitleColor:self.itemTitleColor forState:UIControlStateNormal];
    [self.scrollView addSubview:itemView];
    
    return itemView;
}

- (void)itemViewTapped:(UIButton *)sender
{
    _selectedIndex = [self.itemViews indexOfObject:sender];
    
    [self resetButtonTitleColor];
    
    if (self.selectTitleBlock) {
        self.selectTitleBlock(self.selectedIndex);
    }
}

- (void)layoutItemViews
{
    __block CGFloat x = self.itemMargin;
    
    [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = self.itemViews[idx];
        CGFloat width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
        button.frame = CGRectMake(x, 0.0f, width, CGRectGetHeight(self.frame));
        x += width + self.itemMargin;
    }];
    
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.frame));
    CGRect frame = self.scrollView.frame;
    
    if (CGRectGetWidth(self.frame) > x) {
        frame.origin.x = (CGRectGetWidth(self.frame) - x) / 2.0f;
        frame.size.width = x;
    } else {
        frame.origin.x = 0.0f;
        frame.size.width = CGRectGetWidth(self.frame);
    }
    self.scrollView.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutItemViews];
}

- (void)changeParentScrollView:(UIScrollView *)parentScrollView
                 selectedIndex:(NSInteger)selectedIndex
                  totalVCCount:(NSInteger)totalVCCount
{
    CGFloat oldX = selectedIndex * CGRectGetWidth(parentScrollView.frame);
    BOOL scrollingTowards = (parentScrollView.contentOffset.x > oldX);
    NSInteger targetIndex = (scrollingTowards) ? selectedIndex + 1 : selectedIndex - 1;
    
    if (targetIndex >= 0 && targetIndex < totalVCCount) {
        CGFloat ratio = (parentScrollView.contentOffset.x - oldX) / CGRectGetWidth(parentScrollView.frame);
        CGFloat previousItemContentOffsetX = [self contentOffsetForSelectedItemAtIndex:selectedIndex].x;
        CGFloat nextItemContentOffsetX = [self contentOffsetForSelectedItemAtIndex:targetIndex].x;
        //        CGFloat previousItemPageIndicatorX = [self centerForSelectedItemAtIndex:selectedIndex].x;
        //        CGFloat nextItemPageIndicatorX = [self centerForSelectedItemAtIndex:targetIndex].x;
        UIButton *previosSelectedItem = self.itemViews[selectedIndex];
        UIButton *nextSelectedItem = self.itemViews[targetIndex];
        
        CGFloat red, green, blue, alpha, highlightedRed, highlightedGreen, highlightedBlue, highlightedAlpha;
        [self getRed:&red green:&green blue:&blue alpha:&alpha fromColor:self.itemTitleColor];
        [self getRed:&highlightedRed green:&highlightedGreen blue:&highlightedBlue alpha:&highlightedAlpha fromColor:self.selectedPageItemTitleColor];
        
        CGFloat absRatio = fabs(ratio);
        UIColor *prev = [UIColor colorWithRed:red * absRatio + highlightedRed * (1 - absRatio)
                                        green:green * absRatio + highlightedGreen * (1 - absRatio)
                                         blue:blue * absRatio + highlightedBlue  * (1 - absRatio)
                                        alpha:alpha * absRatio + highlightedAlpha  * (1 - absRatio)];
        UIColor *next = [UIColor colorWithRed:red * (1 - absRatio) + highlightedRed * absRatio
                                        green:green * (1 - absRatio) + highlightedGreen * absRatio
                                         blue:blue * (1 - absRatio) + highlightedBlue * absRatio
                                        alpha:alpha * (1 - absRatio) + highlightedAlpha * absRatio];
        
        [previosSelectedItem setTitleColor:prev forState:UIControlStateNormal];
        [nextSelectedItem setTitleColor:next forState:UIControlStateNormal];
        
        if (scrollingTowards) {
            self.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX +
                                                        (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.0f);
            //            self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX +
            //                                                        (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
            //                                                        [self pageIndicatorCenterY]);
            
        } else {
            self.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX -
                                                        (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.0f);
            //            self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX -
            //                                                        (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
            //                                                        [self pageIndicatorCenterY]);
        }
    }
    _selectedIndex = selectedIndex;
}

- (void)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha fromColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    
    if (colorSpaceModel == kCGColorSpaceModelRGB && CGColorGetNumberOfComponents(color.CGColor) == 4) {
        *red = components[0];
        *green = components[1];
        *blue = components[2];
        *alpha = components[3];
    } else if (colorSpaceModel == kCGColorSpaceModelMonochrome && CGColorGetNumberOfComponents(color.CGColor) == 2) {
        *red = *green = *blue = components[0];
        *alpha = components[1];
    } else {
        *red = *green = *blue = *alpha = 0;
    }
}

@end
