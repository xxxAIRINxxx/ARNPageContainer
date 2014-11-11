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
    
    {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.clipsToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.JPG"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = controller.view.bounds;
        [controller.view addSubview:imageView];
        [controller.view arn_allPinWithSubView:imageView];
        controller.title = @"controller 1";
        [pageContainer addVC:controller];
        
    }
    {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.clipsToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.JPG"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = controller.view.bounds;
        [controller.view addSubview:imageView];
        [controller.view arn_allPinWithSubView:imageView];
        controller.title = @"controller 2";
        [pageContainer addVC:controller];
    }
    {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.clipsToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.JPG"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = controller.view.bounds;
        [controller.view addSubview:imageView];
        [controller.view arn_allPinWithSubView:imageView];
        controller.title = @"controller 3";
        [pageContainer addVC:controller];
    }
    {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.clipsToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.JPG"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = controller.view.bounds;
        [controller.view addSubview:imageView];
        [controller.view arn_allPinWithSubView:imageView];
        controller.title = @"controller 4";
        [pageContainer addVC:controller];
    }
    
    ARNPageContainerTopTabView *tabView = [[ARNPageContainerTopTabView alloc] init];
    [pageContainer setTopBarView:tabView];
    tabView.backgroundColor = [UIColor darkGrayColor];
    
    tabView.itemTitles = [pageContainer headerTitles];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
