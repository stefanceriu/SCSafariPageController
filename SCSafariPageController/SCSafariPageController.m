//
//  SCSafariPageController.m
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "SCSafariPageController.h"
#import "SCPageViewController.h"

#import "SCSafariZoomedInLayouter.h"
#import "SCSafariZoomedOutLayouter.h"

#import "SCSafariPageWrapperViewController.h"

#import "SCScrollView.h"

@interface SCSafariPageController () <SCPageViewControllerDataSource, SCPageViewControllerDelegate, SCSafariPageWrapperViewControllerDelegate>

@property (nonatomic, strong) SCPageViewController *pageViewController;

@property (nonatomic, strong) id<SCPageLayouterProtocol> zoomedInLayouter;
@property (nonatomic, strong) SCSafariZoomedOutLayouter *zoomedOutLayouter;

@property (nonatomic, assign) BOOL isZoomedOut;

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign) BOOL shouldIgnoreUpdates;

@end

@implementation SCSafariPageController

#pragma mark - Defaults Init

- (instancetype)init
{
    if(self = [super init]) {
        _canRemoveOnSwipe = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.zoomedInLayouter = [[SCSafariZoomedInLayouter alloc] init];
	self.zoomedOutLayouter = [[SCSafariZoomedOutLayouter alloc] init];
	
	self.pageViewController = [[SCPageViewController alloc] init];
	[self.pageViewController setDataSource:self];
	[self.pageViewController setDelegate:self];
	[self.pageViewController setLayouter:self.zoomedInLayouter animated:NO completion:nil];
	
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	[self.pageViewController.view setFrame:self.view.bounds];
	[self.pageViewController didMoveToParentViewController:self];
	
	[self.pageViewController.scrollView setScrollEnabled:NO];
	[self.pageViewController setPagingEnabled:NO];
	[self.pageViewController setContinuousNavigationEnabled:YES];
	[self.pageViewController setAnimationDuration:0.35f];
}

#pragma mark - Public

- (void)scrollToTopAnimated:(BOOL)animated
{
    [self.pageViewController.scrollView setContentOffset:CGPointMake(0, -self.pageViewController.scrollView.contentInset.top)
                                                animated:animated];
}

- (void)zoomOutAnimated:(BOOL)animated completion:(void(^)(void))completion
{
	if(self.isZoomedOut) {
		return;
	}
    
    if ([self.delegate respondsToSelector:@selector(pageController:shouldZoomOutAnimated:)]) {
       if (![self.delegate pageController:self shouldZoomOutAnimated:animated])
           return;
    }
	
	self.isZoomedOut = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [self.pageViewController setLayouter:self.zoomedOutLayouter animated:animated completion:^{
        if([weakSelf.delegate respondsToSelector:@selector(pageController:didZoomOutAnimated:)]) {
            [weakSelf.delegate pageController:weakSelf didZoomOutAnimated:animated];
        }
        if (completion)
            completion();
    }];
	[self.pageViewController.scrollView setScrollEnabled:YES];
	
    if (self.canRemoveOnSwipe){
        for(SCSafariPageWrapperViewController *page in self.pageViewController.loadedViewControllers) {
            [page setScrollEnabled:YES];
        }
    }
}

- (void)zoomIntoPageAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void(^)(void))completion
{
	if(!self.isZoomedOut) {
		return;
	}
	
    if ([self.delegate respondsToSelector:@selector(pageController:shouldZoomInAnimated:)]) {
        if (![self.delegate pageController:self shouldZoomInAnimated:animated])
            return;
    }
    
	self.isZoomedOut = NO;
	self.currentPage = index;
	
    __weak typeof(self) weakSelf = self;
    
    [self.pageViewController setLayouter:self.zoomedInLayouter andFocusOnIndex:index animated:animated completion:^{
        if([weakSelf.delegate respondsToSelector:@selector(pageController:didZoomInAnimated:)]) {
            [weakSelf.delegate pageController:weakSelf didZoomInAnimated:animated];
        }
        if (completion)
            completion();
    }];
	[self.pageViewController.scrollView setScrollEnabled:NO];
	
	for(SCSafariPageWrapperViewController *page in self.pageViewController.loadedViewControllers) {
		[page setScrollEnabled:NO];
	}
}

- (UIViewController *)viewControllerForPageAtIndex:(NSUInteger)pageIndex
{
	SCSafariPageWrapperViewController *page = (SCSafariPageWrapperViewController *)[self.pageViewController viewControllerForPageAtIndex:pageIndex];
	return page.childViewController;
}

#pragma mark - SCPageViewControllerDataSource

- (NSUInteger)numberOfPagesInPageViewController:(SCPageViewController *)pageViewController
{
	return [self.dataSource numberOfPagesInPageController:self];
}

- (UIViewController *)pageViewController:(SCPageViewController *)pageViewController viewControllerForPageAtIndex:(NSUInteger)pageIndex
{
	UIViewController *viewController = [self.dataSource pageController:self viewControllerForPageAtIndex:pageIndex];
	
	SCSafariPageWrapperViewController *safariPageViewController = [[SCSafariPageWrapperViewController alloc] initWithViewController:viewController];
	[safariPageViewController setScrollEnabled:self.isZoomedOut];
	[safariPageViewController setDelegate:self];
	
	return safariPageViewController;
}

#pragma mark - SCPageViewControllerDelegate

- (void)pageViewController:(SCPageViewController *)pageViewController didShowViewController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if([self.delegate respondsToSelector:@selector(pageController:didShowViewController:atIndex:)]) {
		[self.delegate pageController:self didShowViewController:controller atIndex:index];
	}
}

- (void)pageViewController:(SCPageViewController *)pageViewController didHideViewController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if([self.delegate respondsToSelector:@selector(pageController:didHideViewController:atIndex:)]) {
		[self.delegate pageController:self didHideViewController:controller atIndex:index];
	}
}

- (void)pageViewController:(SCPageViewController *)pageViewController didNavigateToPageAtIndex:(NSUInteger)pageIndex
{
	if([self.delegate respondsToSelector:@selector(pageController:didNavigateToPageAtIndex:)]) {
		[self.delegate pageController:self didNavigateToPageAtIndex:pageIndex];
	}
}

- (void)pageViewController:(SCPageViewController *)pageViewController didNavigateToOffset:(CGPoint)offset
{
	if([self.delegate respondsToSelector:@selector(pageController:didNavigateToOffset:)]) {
		[self.delegate pageController:self didNavigateToOffset:offset];
	}
}

#pragma mark - SCSafariPageWrapperViewControllerDelegate

- (void)safariPageWrapperViewController:(SCSafariPageWrapperViewController *)safariPageWrapperViewController
				  didScrollToPercentage:(CGFloat)percentage
{
	[self _updatePageLayout];
}

- (void)safariPageWrapperViewControllerDidEndDragging:(SCSafariPageWrapperViewController *)safariPageWrapperViewController
										 atPercentage:(CGFloat)percentage
{
	if(percentage <= 0.5f) {
		return;
	}
	
	NSUInteger pageIndex = [self.pageViewController pageIndexForViewController:safariPageWrapperViewController];
	
	if(pageIndex == NSNotFound) {
		return;
	}
	
	[safariPageWrapperViewController setDelegate:nil];
	
	if([self.delegate respondsToSelector:@selector(pageController:willDeletePageAtIndex:)]) {
		[self.delegate pageController:self willDeletePageAtIndex:pageIndex];
	}
	
	[self.view setUserInteractionEnabled:NO];
	[self setShouldIgnoreUpdates:YES];
	
	[self deletePagesAtIndexes:[NSIndexSet indexSetWithIndex:pageIndex] animated:YES completion:^{
		if([self.delegate respondsToSelector:@selector(pageController:didDeletePageAtIndex:)]) {
			[self.delegate pageController:self didDeletePageAtIndex:pageIndex];
		}
		
		[self.view setUserInteractionEnabled:YES];
		[self setShouldIgnoreUpdates:NO];
	}];
}

#pragma mark - Forwarding

- (void)reloadData
{
	[self.pageViewController reloadData];
}

- (void)reloadPagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:(void (^)(void))completion
{
	[self.pageViewController reloadPagesAtIndexes:indexes animated:animated completion:completion];
}

- (void)insertPagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:(void (^)(void))completion
{
	[self.pageViewController insertPagesAtIndexes:indexes animated:animated completion:completion];
}

- (void)deletePagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:(void(^)(void))completion
{
	[self.pageViewController deletePagesAtIndexes:indexes animated:animated completion:completion];
}

- (void)movePageAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex animated:(BOOL)animated completion:(void (^)(void))completion
{
	[self.pageViewController movePageAtIndex:fromIndex toIndex:toIndex animated:animated completion:completion];
}

- (void)navigateToPageAtIndex:(NSUInteger)pageIndex animated:(BOOL)animated completion:(void (^)(void))completion
{
	[self.pageViewController navigateToPageAtIndex:pageIndex animated:animated completion:completion];
}

- (CGFloat)visiblePercentageForViewController:(UIViewController *)viewController
{
	return [self.pageViewController visiblePercentageForViewController:viewController];
}

- (NSUInteger)numberOfPages
{
	return self.pageViewController.numberOfPages;
}

- (NSArray *)loadedViewControllers
{
	return self.pageViewController.loadedViewControllers;
}

- (NSArray *)visibleViewControllers
{
	return self.pageViewController.visibleViewControllers;
}

#pragma mark - Private

- (void)_updatePageLayout
{
	if(self.shouldIgnoreUpdates) {
		return;
	}
	
	CGFloat totalOffsetPercentage = 0.0f;
	NSUInteger startingOffsetIndex = NSNotFound;
	
	for(SCSafariPageWrapperViewController *wrapper in self.pageViewController.visibleViewControllers) {
		if(wrapper.scrollPercentage) {
			startingOffsetIndex = [self.pageViewController pageIndexForViewController:wrapper];
			totalOffsetPercentage += wrapper.scrollPercentage;
		}
	}
	
	CGFloat numberOfPages = (CGFloat)self.pageViewController.numberOfPages - totalOffsetPercentage;
	
	CGFloat currentItemSpacing = [self.zoomedOutLayouter interItemSpacingForPageViewController:self.pageViewController totalNumberOfPages:self.pageViewController.numberOfPages];
	CGFloat interItemSpacing = [self.zoomedOutLayouter interItemSpacingForPageViewController:self.pageViewController totalNumberOfPages:numberOfPages];
	CGFloat spacingDelta = currentItemSpacing - interItemSpacing;
	
	for(SCSafariPageWrapperViewController *wrapper in self.pageViewController.loadedViewControllers) {
		
		NSUInteger pageIndex = [self.pageViewController pageIndexForViewController:wrapper];
		CGRect frame = [self.zoomedOutLayouter finalFrameForPageAtIndex:pageIndex pageViewController:self.pageViewController];
		
		CATransform3D transform = [self.zoomedOutLayouter sublayerTransformForPageWithFrame:frame totalNumberOfPages:numberOfPages contentOffset:CGPointZero];
		
		if(wrapper.scrollPercentage == 0.0f && pageIndex >= startingOffsetIndex) {
			CGFloat offset = -(100.0f + MAX(0, 6 - (NSInteger)self.pageViewController.numberOfPages) * 25.0f) * totalOffsetPercentage;
			transform = CATransform3DConcat(transform, CATransform3DMakeTranslation(0.0f, offset, 0.0f));
		}
		
		if(pageIndex && wrapper.scrollPercentage == 0.0f) {
			transform = CATransform3DConcat(transform, CATransform3DMakeTranslation(0.0f, pageIndex * -spacingDelta, 0.0f));
		}
		
		[self _setAnimatableSublayerTransform:transform forViewController:wrapper];
	}
}

- (void)_setAnimatableSublayerTransform:(CATransform3D)transform forViewController:(UIViewController *)viewController
{
	for(CALayer *layer in viewController.view.layer.sublayers) {
		[layer setTransform:transform];
	}
}

@end
