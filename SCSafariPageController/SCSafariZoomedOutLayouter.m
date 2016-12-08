//
//  SCSafariZoomedOutLayouter.m
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "SCSafariZoomedOutLayouter.h"

@interface SCSafariZoomedOutLayouter ()

@property (nonatomic, assign) CGFloat pagePercentage;

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) CGFloat interItemSpacing;

@end

@implementation SCSafariZoomedOutLayouter

@synthesize interItemSpacing;
@synthesize navigationType;
@synthesize numberOfPagesToPreloadBeforeCurrentPage;
@synthesize numberOfPagesToPreloadAfterCurrentPage;
@synthesize navigationConstraintType;

- (instancetype)init
{
	if(self = [super init]) {

		self.navigationType = SCPageLayouterNavigationTypeVertical;
		self.navigationConstraintType = SCPageLayouterNavigationContraintTypeNone;
		
		self.numberOfPagesToPreloadBeforeCurrentPage = 5;
		self.numberOfPagesToPreloadAfterCurrentPage  = 5;
		
		self.pagePercentage = 0.75f;
	}
	
	return self;
}

- (UIEdgeInsets)contentInsetForPageViewController:(SCPageViewController *)pageViewController
{
	self.contentInset = UIEdgeInsetsMake(50.0f, 50.0f, 0.0f, 0.0f);
	return self.contentInset;
}

- (CGFloat)interItemSpacingForPageViewController:(SCPageViewController *)pageViewController
{
	self.interItemSpacing = [self interItemSpacingForPageViewController:pageViewController totalNumberOfPages:pageViewController.numberOfPages];
	return self.interItemSpacing;
}

- (CGRect)finalFrameForPageAtIndex:(NSUInteger)index
				pageViewController:(SCPageViewController *)pageViewController
{
	CGRect frame = pageViewController.view.bounds;
	frame.size.height = frame.size.height * self.pagePercentage;
	frame.size.width = frame.size.width * self.pagePercentage;
	
	if(self.navigationType == SCPageLayouterNavigationTypeVertical) {
		frame.origin.y = index * (CGRectGetHeight(frame) + self.interItemSpacing);
		frame.origin.x = CGRectGetMidX(pageViewController.view.bounds) - CGRectGetMidX(frame);
	} else {
		frame.origin.x = index * (CGRectGetWidth(frame) + self.interItemSpacing);
		frame.origin.y = CGRectGetMidY(pageViewController.view.bounds) - CGRectGetMidY(frame);
	}
	
	return frame;
}

- (NSUInteger)zPositionForPageAtIndex:(NSUInteger)index
				   pageViewController:(SCPageViewController *)pageViewController
{
	return index;
}

- (CATransform3D)sublayerTransformForPageAtIndex:(NSUInteger)index
								   contentOffset:(CGPoint)contentOffset
							  pageViewController:(SCPageViewController *)pageViewController
{
	CGRect finalFrame = [self finalFrameForPageAtIndex:index pageViewController:pageViewController];
	return [self _sublayerTransformForPageWithFrame:finalFrame totalNumberOfPages:pageViewController.numberOfPages contentOffset:contentOffset];
}

- (void)animatePageInsertionAtIndex:(NSUInteger)index
					 viewController:(UIViewController *)viewController
				 pageViewController:(SCPageViewController *)pageViewController
						 completion:(void (^)())completion
{
	CGRect frame = viewController.view.frame;
	CATransform3D sublayerTransform = [self _sublayerTransformForPageWithFrame:frame totalNumberOfPages:pageViewController.numberOfPages contentOffset:CGPointZero];
	
	[viewController.view setFrame:CGRectOffset(frame, 0.0f, CGRectGetHeight(frame))];
	[viewController.view setAlpha:0.0f];
	
	[UIView animateWithDuration:pageViewController.animationDuration animations:^{
		[viewController.view setFrame:frame];
		[viewController.view setAlpha:1.0f];
		[(CALayer *)viewController.view.layer.sublayers.firstObject setTransform:sublayerTransform];
	} completion:^(BOOL finished) {
		completion();
	}];
}

- (void)animatePageDeletionAtIndex:(NSUInteger)index
					viewController:(UIViewController *)viewController
				pageViewController:(SCPageViewController *)pageViewController
						completion:(void (^)())completion
{
	[UIView animateWithDuration:pageViewController.animationDuration animations:^{
		[viewController.view setFrame:CGRectOffset(viewController.view.frame, -CGRectGetMaxX(viewController.view.bounds), 0.0f)];
		[viewController.view setAlpha:0.0f];
	} completion:^(BOOL finished) {
		completion();
	}];
}

- (CGFloat)interItemSpacingForPageViewController:(SCPageViewController *)pageViewController
							  totalNumberOfPages:(CGFloat)numberOfPages
{
	if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
		return -CGRectGetWidth(pageViewController.view.bounds) / 5.0f - MIN(6, numberOfPages) * 10.0f;
	}
	else {
		return -CGRectGetHeight(pageViewController.view.bounds) / 3.0f  - MIN(6, numberOfPages) * 30.0f;
	}
}

#pragma mark - Private

- (CATransform3D)_sublayerTransformForPageWithFrame:(CGRect)frame
                                 totalNumberOfPages:(CGFloat)numberOfPages
                                      contentOffset:(CGPoint)contentOffset
{
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0 / 900.0f;
	
	CGFloat angle = 30.0f + MIN(numberOfPages * 5.0f, 30.0f);
	if(contentOffset.y < -self.contentInset.top) {
		angle += (ABS(contentOffset.y) - self.contentInset.top) / 9.0f;
	}
	
	transform = CATransform3DRotate(transform, (angle * M_PI / 180.0f), 1.0f, 0.0f, 0.0f);
	transform = CATransform3DScale(transform, 0.9f, 0.9f, 1.0f);
	
	return transform;
}

@end
