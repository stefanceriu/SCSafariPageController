//
//  SCSafariPageWrapperViewController.h
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/30/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCSafariPageWrapperViewControllerDelegate;

/** A view controller that wraps other view controllers and enables swipe to delete */
@interface SCSafariPageWrapperViewController : UIViewController


/** The view controller that is currently being wrapped */
@property (nonatomic, strong, readonly) UIViewController *childViewController;


/** The wrapper's delegate, informs of internal scroll view events */
@property (nonatomic, weak) id<SCSafariPageWrapperViewControllerDelegate> delegate;


/** Enables or disabls the scrolling on the internal scroll view
 * and, implicitely, the swipe to delete gesture
 */
@property (nonatomic, assign) BOOL scrollEnabled;


/** The percentage the page has been moved by */
@property (nonatomic, assign) CGFloat scrollPercentage;


/**
 * The wrappers designated initializer
 * @param viewController The view controller that should be
 * wrapped inside the scroll view
 */
- (instancetype)initWithViewController:(UIViewController *)viewController NS_DESIGNATED_INITIALIZER;

@end

/** The wrapper's delegate, informs of internal scroll view events */
@protocol SCSafariPageWrapperViewControllerDelegate <NSObject>

@optional

/**
 * Notifies the observer when the internal scroll view moved
 * @param safariPageWrapperViewController the calling wrapper
 * @param percentage the percentage the page has moved
 */
- (void)safariPageWrapperViewController:(SCSafariPageWrapperViewController *)safariPageWrapperViewController
		   didScrollToPercentage:(CGFloat)percentage;


/**
 * Notifies the observer when the user has stopped dragging
 * on the internal scroll view
 * @param safariPageWrapperViewController the calling wrapper
 * @param percentage the percentage at which the dragging ended
 */
- (void)safariPageWrapperViewControllerDidEndDragging:(SCSafariPageWrapperViewController *)safariPageWrapperViewController
								  atPercentage:(CGFloat)percentage;

@end