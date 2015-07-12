//
//  SCViewController.h
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCViewControllerDelegate;

@interface SCViewController : UIViewController

@property (nonatomic, weak) id<SCViewControllerDelegate> delegate;

- (void)setHeaderVisible:(BOOL)visible animated:(BOOL)animated;

@end

@protocol SCViewControllerDelegate <NSObject>

- (void)viewControllerDidReceiveTap:(SCViewController *)viewController;
- (void)viewControllerDidRequestDelete:(SCViewController *)viewController;

@end