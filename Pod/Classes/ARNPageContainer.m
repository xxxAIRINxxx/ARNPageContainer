//
//  ARNPageContainer.m
//  ARNPageContainer
//
//  Created by Airin on 2014/10/25.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ARNPageContainer.h"

#import "ARNPageContainerLayout.h"

CGFloat const ARNPageContainerTopBarDefaultHeight = 44.0f;

@interface ARNPageContainer () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *topBarLayerView;
@property (nonatomic, weak) UIScrollView *observingScrollView;
@property (nonatomic, assign) BOOL shouldObserveContentOffset;

@property (nonatomic, strong) NSLayoutConstraint *topBarHeightConstraint;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation ARNPageContainer

- (void)dealloc
{
    [self stopObservingContentOffset];
}

- (void)commonInit
{
    self.viewControllers = [NSMutableArray array];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)settingTopBarView
{
    self.topBarLayerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.topBarLayerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.topBarLayerView];
    
    [ARNPageContainerLayout pinParentView:self.view subView:self.topBarLayerView toEdge:NSLayoutAttributeTop];
    [ARNPageContainerLayout pinParentView:self.view subView:self.topBarLayerView toEdge:NSLayoutAttributeLeft];
    [ARNPageContainerLayout pinParentView:self.view subView:self.topBarLayerView toEdge:NSLayoutAttributeRight];
    self.topBarHeightConstraint = [ARNPageContainerLayout addConstraintView:self.topBarLayerView
                                                                     toEdge:NSLayoutAttributeHeight
                                                                   constant:ARNPageContainerTopBarDefaultHeight];
    [self.view addConstraint:self.topBarHeightConstraint];
}

- (void)settingCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.collectionView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topBarLayerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [ARNPageContainerLayout pinParentView:self.view subView:self.collectionView toEdge:NSLayoutAttributeBottom];
    [ARNPageContainerLayout pinParentView:self.view subView:self.collectionView toEdge:NSLayoutAttributeLeft];
    [ARNPageContainerLayout pinParentView:self.view subView:self.collectionView toEdge:NSLayoutAttributeRight];
}

- (instancetype)init
{
    if (!(self = [super init])) { return nil; }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) { return nil; }
    
    [self commonInit];
    
    return self;
}

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldObserveContentOffset = YES;
    
    [self settingTopBarView];
    [self settingCollectionView];
    
    [self startObservingContentOffsetForScrollView:self.collectionView];
}

- (void)viewDidUnload
{
    [self stopObservingContentOffset];
    
    self.shouldObserveContentOffset = NO;
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    self.collectionView = nil;
    
    [super viewDidUnload];
}

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - Public

- (void)setParentVC:(UIViewController *)controller
{
    if (self.parentViewController) { return; }
    
    [self willMoveToParentViewController:self];
    self.view.frame = controller.view.bounds;
    [controller.view addSubview:self.view];
    [controller addChildViewController:self];
    
    [ARNPageContainerLayout allPinParentView:controller.view subView:self.view];
    
    [self didMoveToParentViewController:controller];
}

- (void)setTopBarView:(UIView *)topBarView
{
    if (self.topBarLayerView.subviews.count) {
        for (UIView *view in self.topBarLayerView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    topBarView.frame = self.topBarLayerView.bounds;
    topBarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.topBarLayerView addSubview:topBarView];
    
    [ARNPageContainerLayout allPinParentView:self.topBarLayerView subView:topBarView];
}

- (void)addVC:(UIViewController *)controller
{
    NSUUID *uuid = [NSUUID UUID];
    NSString *uuidString = uuid.UUIDString;
    
    [self.viewControllers addObject:@{uuidString : controller}];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:uuidString];
    
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    if (selectedIndex > self.viewControllers.count) {
        selectedIndex = self.viewControllers.count;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
    } completion:^(BOOL finished) {
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:animated];
        if (!animated) {
            // no animated is not call scrollViewDidEndScrollingAnimation
            weakSelf.collectionView.userInteractionEnabled = YES;
            
            if (weakSelf.changeOffsetBlock) {
                weakSelf.changeOffsetBlock(weakSelf.collectionView, selectedIndex);
            }
        }
        
        if (weakSelf.changeIndexBlock) {
            NSDictionary *dict = weakSelf.viewControllers[selectedIndex];
            UIViewController *controller = dict[dict.allKeys[0]];
            weakSelf.changeIndexBlock(controller, selectedIndex);
        }
    }];
    
    _selectedIndex = selectedIndex;
}

- (NSArray *)headerTitles
{
    NSMutableArray *headerTitles = [NSMutableArray array];
    
    for (NSUInteger i = 0 ; i < self.viewControllers.count; ++i) {
        NSDictionary *dict = self.viewControllers[i];
        UIViewController *controller = dict[dict.allKeys[0]];
        [headerTitles addObject:controller.title.copy];
    }
    return [NSArray arrayWithArray:headerTitles];
}

- (void)updateHeaderTitle
{
    if (self.updateHeaderTitleBlock) {
        self.updateHeaderTitleBlock([self headerTitles]);
    }
}

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - Getter,  Setter

- (CGFloat)topBarHeight
{
    if (!self.topBarHeightConstraint) { return 0.0f; }
    
    return self.topBarHeightConstraint.constant;
}

- (void)setTopBarHeight:(CGFloat)topBarHeight
{
    if (!self.topBarHeightConstraint) { return; }
    
    self.topBarHeightConstraint.constant = topBarHeight;
    
    [self.topBarLayerView setNeedsUpdateConstraints];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - KVO

- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.observingScrollView = scrollView;
}

- (void)stopObservingContentOffset
{
    if (self.observingScrollView) {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    CGFloat oldX = self.selectedIndex * CGRectGetWidth(self.collectionView.frame);
    
    if (oldX != self.collectionView.contentOffset.x && self.shouldObserveContentOffset) {
        if (self.changeOffsetBlock) {
            self.changeOffsetBlock(self.collectionView, self.selectedIndex);
        }
    }
}

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.viewControllers[indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dict.allKeys[0]
                                                                           forIndexPath:indexPath];
    
    cell.contentView.clipsToBounds = YES;
    
    if (!cell.contentView.subviews.count) {
        UIViewController *controller = dict[dict.allKeys[0]];
        controller.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:controller.view];
    }
    
    return cell;
}

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - UICollectionView Delegate

- (CGSize)  collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = NO;
}

@end
