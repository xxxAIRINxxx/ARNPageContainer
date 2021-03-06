//
//  ARNViewController.m
//  ARNPageContainer
//
//  Created by xxxAIRINxxx on 10/25/2014.
//  Copyright (c) 2014 xxxAIRINxxx. All rights reserved.
//

#import "ARNViewController.h"

#import <ARNPageContainer.h>
#import <ARNPageContainerTopTabView.h>
#import <ARNLayout.h>

@interface ARNViewController ()

@end

@implementation ARNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ARNPageContainer *pageContainer = [[ARNPageContainer alloc] init];
    [pageContainer setParentVC:self];
    
    for (NSInteger i = 1; i < 6; i ++) {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.clipsToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.JPG"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [controller.view addSubview:imageView];
        [controller.view arn_allPinWithSubView:imageView];
        controller.title = [NSString stringWithFormat:@"Controller %zd", i];
        [pageContainer addVC:controller];
    }
    
    ARNPageContainerTopTabView *tabView = [ARNPageContainerTopTabView new];
    tabView.font = [UIFont boldSystemFontOfSize:20];
    tabView.backgroundColor = [UIColor blackColor];
    tabView.itemTitleColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:255/255.0 alpha:1.0];
    tabView.itemTitles = [pageContainer headerTitles];
    [pageContainer setTopBarView:tabView];
    
    __weak typeof(tabView) weakTabView = tabView;
    pageContainer.changeOffsetBlock = ^(UICollectionView *collectionView, NSInteger selectedIndex){
        [weakTabView changeParentScrollView:collectionView
                              selectedIndex:selectedIndex
                               totalVCCount:[collectionView numberOfItemsInSection:0]];
    };
    
    tabView.selectTitleBlock = ^(NSInteger selectedIndex){
        [pageContainer setSelectedIndex:selectedIndex animated:YES];
    };
    
    pageContainer.changeIndexBlock = ^(UIViewController *selectIndexController, NSInteger selectedIndex){
        NSLog(@"---------- call changeIndexBlock ---------- ");
        NSLog(@"selectIndexController : %@", selectIndexController.title);
        weakTabView.selectedIndex = selectedIndex;
    };
    
    [pageContainer setSelectedIndex:2 animated:YES];
    [pageContainer setTopBarHeight:60.0];
}

@end
