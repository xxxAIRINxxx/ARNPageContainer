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

#import <ARNLayout.h>

#import "ARNPageContainerViewCell.h"

CGFloat const ARNPageContainerTopBarDefaultHeight = 44.0f;

@interface ARNPageContainer () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *topBarLayerView;
@property (nonatomic, weak) UIScrollView *observingScrollView;
@property (nonatomic, assign) BOOL shouldObserveContentOffset;

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *topBarHeightConstraint;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation ARNPageContainer

- (void)dealloc
{
    [self stopObservingContentOffset];
    
    _shouldObserveContentOffset = NO;
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    _collectionView = nil;
}

- (void)commonInit
{
    self.viewControllers = [NSMutableArray array];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)settingTopBarView
{
    self.topBarLayerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.topBarLayerView];
    
    [self.view arn_pinWithView:self.topBarLayerView toView:self.view attribute:NSLayoutAttributeLeft constant:0.0f];
    [self.view arn_pinWithView:self.topBarLayerView toView:self.view attribute:NSLayoutAttributeRight constant:0.0f];
    self.topConstraint = [self.view arn_pinWithView:self.topBarLayerView toView:self.view attribute:NSLayoutAttributeTop constant:0.0f];
    self.topBarHeightConstraint = [self.topBarLayerView arn_addConstraintWithAttribute:NSLayoutAttributeHeight
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
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.collectionView];
    
    [self.view arn_pinWithView:self.collectionView isWithViewTop:YES toView:self.topBarLayerView isToViewTop:NO];
    [self.view arn_pinWithView:self.collectionView toView:self.view attribute:NSLayoutAttributeLeft constant:0.0f];
    [self.view arn_pinWithView:self.collectionView toView:self.view attribute:NSLayoutAttributeRight constant:0.0f];
    self.bottomConstraint = [self.view arn_pinWithView:self.collectionView toView:self.view attribute:NSLayoutAttributeBottom constant:0.0f];
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

// ------------------------------------------------------------------------------------------------------------------//
#pragma mark - Public

- (void)setParentVC:(UIViewController *)controller
{
    if (self.parentViewController) { return; }
    
    [self willMoveToParentViewController:self];
    self.view.frame = controller.view.bounds;
    [controller.view addSubview:self.view];
    [controller addChildViewController:self];
    
    [controller.view arn_allPinWithView:self.view toView:controller.view];
    
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
    
    [self.topBarLayerView addSubview:topBarView];
    
    [self.topBarLayerView arn_allPinWithView:topBarView toView:self.topBarLayerView];
}

- (void)addControler:(UIViewController *)controller
{
    NSUUID *uuid = [NSUUID UUID];
    NSString *uuidString = uuid.UUIDString;
    
    [self.viewControllers addObject:@{uuidString : controller}];
    
    [self.collectionView registerClass:[ARNPageContainerViewCell class] forCellWithReuseIdentifier:uuidString];
    
    [self.collectionView reloadData];
    
    self.selectedIndex = self.viewControllers.count - 1;
}

- (void)addVCs:(NSArray *)controllers
{
    if (!controllers || !controllers.count) { return; }
    
    for (NSUInteger i = 0; i < controllers.count; ++i) {
        UIViewController *controller = controllers[i];
        [self addControler:controller];
    }
}

- (void)addVC:(UIViewController *)controller
{
    [self addControler:controller];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{}
                                  completion:
     ^(BOOL finished) {
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

- (CGFloat)topMargin
{
    return self.topConstraint.constant;
}

- (void)setTopMargin:(CGFloat)topMargin
{
    self.topConstraint.constant = topMargin;
    
    [self.view setNeedsUpdateConstraints];
}

- (CGFloat)bottomMargin
{
    return self.bottomConstraint.constant;
}

- (void)setBottomMargin:(CGFloat)bottomMargin
{
    self.bottomConstraint.constant = bottomMargin;
    
    [self.collectionView setNeedsUpdateConstraints];
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
    
    ARNPageContainerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dict.allKeys[0]
                                                                               forIndexPath:indexPath];
    
    if (!cell.contentView.subviews.count) {
        UIViewController *controller = dict[dict.allKeys[0]];
        [cell addContentView:controller.view];
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
    _selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
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
