//
//  ARNPageContainerViewCell.h
//  ARNPageContainer
//
//  Created by Airin on 2014/11/11.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ARNPageContainerViewCell.h"

#import <ARNLayout.h>

@interface ARNPageContainerViewCell ()

@property (nonatomic, strong) UIView *dummyContentView;

@end

@implementation ARNPageContainerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) { return nil; }
    
    self.clipsToBounds = YES;
    
    _dummyContentView = [UIView new];
    // FIXME : can not add contentView
    [self addSubview:_dummyContentView];
    [self arn_allPinWithSubView:_dummyContentView];
    
    return self;
}

- (void)addContentView:(UIView *)contentView
{
    [self.dummyContentView addSubview:contentView];
    [self.dummyContentView arn_allPinWithSubView:contentView];
}

@end
