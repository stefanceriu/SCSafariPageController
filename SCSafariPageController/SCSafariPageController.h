//
//  SCSafariPageController.h
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

@import UIKit;

@protocol SCSafariPageControllerDataSource;
@protocol SCSafariPageControllerDelegate;

/**
 * A page view controller component that reproduces the
 * tab switching effects seen in Mobile Safari
 */
@interface SCSafariPageController : UIViewController

@property (nonatomic, assign, readonly) BOOL isZoomedOut;

/**
 * If set to false swipe guesture for removing views will be disabled default true
 */
@property (nonatomic,assign) BOOL canRemoveOnSwipe;

/**
 * Scroll display zoomed out view to top
 */
- (void)scrollToTop;

/**
 * Reloads and re-layouts all the pages in the controller
 */
- (void)reloadData;


/**
 * Reloads and re-layouts the page at the given index
 */
- (void)reloadPagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:(void(^)())completion;


/**
 * Inserts a new page at the given index
 */
- (void)insertPagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:(void(^)())completion;


/**
 * Removes the page at the given index
 */
- (void)deletePagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:(void(^)())completion;


/**
 * Moves the page to the given index
 */
- (void)movePageAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex animated:(BOOL)animated completion:(void(^)())completion;


/**
 * @param pageIndex The page index to navigate to
 * @param animated Whether the transition will be animated
 */
- (void)navigateToPageAtIndex:(NSUInteger)pageIndex
					 animated:(BOOL)animated
				   completion:(void(^)())completion;


/**
 * Zooms out to show multiple pages
 */
- (void)zoomOutAnimated:(BOOL)animated completion:(void(^)())completion;


/**
 * Zooms into the given page
 */
- (void)zoomIntoPageAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void(^)())completion;


/**
 * @return Float value representing the visible percentage
 * @param viewController The view controller for which to fetch the
 * visible percentage
 *
 */
- (CGFloat)visiblePercentageForViewController:(UIViewController *)viewController;


/**
 * @param pageIndex The page index you want to retrieve the view controller for
 * @return the view controller for the given page index if already loaded, nil otherwise
 */
- (UIViewController *)viewControllerForPageAtIndex:(NSUInteger)pageIndex;


/**
 * The page controller's data source
 */
@property (nonatomic, weak) id<SCSafariPageControllerDataSource> dataSource;


/**
 * The page controller's delegate
 */
@property (nonatomic, weak) id<SCSafariPageControllerDelegate> delegate;

/**
 * The current page in the page controller
 */
@property (nonatomic, readonly) NSUInteger currentPage;


/**
 * The total number of pages the page controller holds at any given time
 */
@property (nonatomic, readonly) NSUInteger numberOfPages;


/**
 * An array of currently loaded view controllers in the page controller
 */
@property (nonatomic, readonly) NSArray *loadedViewControllers;


/**
 * An array of currently visible view controllers in the page controller
 */
@property (nonatomic, readonly) NSArray *visibleViewControllers;


@end

/**
 * The page controller's dataSource protocol
 */
@protocol SCSafariPageControllerDataSource <NSObject>

/**
 * Method that the page controller calls in order to
 * get the total number of pages it should display
 * @param pageController the calling page controller
 * @return total number of pages
 */
- (NSUInteger)numberOfPagesInPageController:(SCSafariPageController *)pageController;

/**
 * Method that the page controler calls when it requires
 * the view controller for the given page
 * @param pageController the calling page controller
 * @param index the page index for which the view controller
 * is required
 * @return a view controller for the given page index
 */
- (UIViewController *)pageController:(SCSafariPageController *)pageController
		viewControllerForPageAtIndex:(NSUInteger)index;

@end

/**
 * The page controller's delegate protocol
 */
@protocol SCSafariPageControllerDelegate <NSObject>

@optional

/** Delegate method that the page controller calls when a view controller becomes visible
 *
 * @param pageController The calling page controller
 * @param controller The view controller that became visible
 * @param index The position where the view controller resides
 *
 */
- (void)pageController:(SCSafariPageController *)pageController
 didShowViewController:(UIViewController *)controller
			   atIndex:(NSUInteger)index;


/** Delegate method that the page controller calls when a view controller is hidden
 * @param pageController The calling page controller
 * @param controller The view controller that was hidden
 * @param index The position where the view controller resides
 *
 */
- (void)pageController:(SCSafariPageController *)pageController
didHideViewController:(UIViewController *)controller
			  atIndex:(NSUInteger)index;


/** Delegate method that the page controller calls when its scrollView scrolls
 * @param pageController The calling page controller
 * @param offset The current offset in the page controllers's scrollView
 *
 */
- (void)pageController:(SCSafariPageController *)pageController
   didNavigateToOffset:(CGPoint)offset;


/** Delegate method that the page controller calls when its scrollView rests
 * on a page
 * @param pageController The calling page controller
 * @param pageIndex The index of the page
 *
 */
- (void)pageController:(SCSafariPageController *)pageController
didNavigateToPageAtIndex:(NSUInteger)pageIndex;


/** Delegate methods that the page controller calls when a page
 * is about to be deleted
 */
- (void)pageController:(SCSafariPageController *)pageController willDeletePageAtIndex:(NSUInteger)pageIndex;


/** Delegate methods that the page controller calls when a page
 * has been deleted
 */
- (void)pageController:(SCSafariPageController *)pageController didDeletePageAtIndex:(NSUInteger)pageIndex;

/** Delegate methods that the page controller calls when view
 * zoom out starts
 */
- (BOOL)pageController:(SCSafariPageController *)pageController shouldZoomOutAnimated:(BOOL)animated;

/** Delegate methods that the page controller calls when view
 * has been zoomed out
 */
- (void)pageController:(SCSafariPageController *)pageController didZoomOutAnimated:(BOOL)animated;

/** Delegate methods that the page controller calls when view
 * zoom in starts
 */
- (BOOL)pageController:(SCSafariPageController *)pageController shouldZoomInAnimated:(BOOL)animated;

/** Delegate methods that the page controller calls when view
 * has been zoomed in
 */
- (void)pageController:(SCSafariPageController *)pageController didZoomInAnimated:(BOOL)animated;

@end
