//
//  SCRootViewController.m
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "SCRootViewController.h"

#import "SCSafariPageController.h"
#import "SCViewController.h"

static const NSUInteger kDefaultNumberOfPages = 6;

@interface SCRootViewController () <SCSafariPageControllerDataSource, SCSafariPageControllerDelegate, SCViewControllerDelegate>

@property (nonatomic, strong) SCSafariPageController *safariPageController;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) IBOutlet UIButton *zoomButton;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@end

@implementation SCRootViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	self.dataSource = [[NSMutableArray alloc] init];
	for(NSUInteger i=0; i<kDefaultNumberOfPages; i++) {
		[self.dataSource addObject:[NSNull null]];
	}

	self.safariPageController = [[SCSafariPageController alloc] init];
	[self.safariPageController setDataSource:self];
	[self.safariPageController setDelegate:self];
	
	[self addChildViewController:self.safariPageController];
	[self.view insertSubview:self.safariPageController.view atIndex:0];
	[self.safariPageController.view setFrame:self.view.bounds];
	[self.safariPageController didMoveToParentViewController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.safariPageController zoomOutAnimated:YES completion:nil];
}


- (IBAction)onZoomButtonTap:(id)sender
{
	[self _toggleZoomWithPageIndex:self.safariPageController.currentPage];
}

- (IBAction)onAddButtonTap:(id)sender
{
	[self.dataSource insertObject:[NSNull null] atIndex:self.safariPageController.numberOfPages];
	[self.safariPageController insertPagesAtIndexes:[NSIndexSet indexSetWithIndex:self.safariPageController.numberOfPages] animated:YES completion:^{
		[self _toggleZoomWithPageIndex:(self.safariPageController.numberOfPages - 1)];
	}];
}

#pragma mark - SCSafariPageControllerDataSource

- (NSUInteger)numberOfPagesInPageController:(SCSafariPageController *)pageController
{
	return self.dataSource.count;
}

- (UIViewController *)pageController:(SCSafariPageController *)pageController viewControllerForPageAtIndex:(NSUInteger)index
{
	SCViewController *viewController = [self.dataSource objectAtIndex:index];
	if(!viewController || [viewController isEqual:[NSNull null]]) {
		viewController = [[SCViewController alloc] init];
		[viewController setDelegate:self];
		[self.dataSource replaceObjectAtIndex:index withObject:viewController];
	}
	
	[viewController setHeaderVisible:self.safariPageController.isZoomedOut animated:NO];
	
	return viewController;
}

- (void)pageController:(SCSafariPageController *)pageController willDeletePageAtIndex:(NSUInteger)pageIndex
{
	[self.dataSource removeObjectAtIndex:pageIndex];
}

#pragma mark - SCViewControllerDelegate

- (void)viewControllerDidReceiveTap:(SCViewController *)viewController
{
	if(![self.safariPageController isZoomedOut]) {
		return;
	}
	
	NSUInteger pageIndex = [self.dataSource indexOfObject:viewController];
	[self _toggleZoomWithPageIndex:pageIndex];
}

- (void)viewControllerDidRequestDelete:(SCViewController *)viewController
{
	NSUInteger pageIndex = [self.dataSource indexOfObject:viewController];
	[self.dataSource removeObjectAtIndex:pageIndex];
	[self.safariPageController deletePagesAtIndexes:[NSIndexSet indexSetWithIndex:pageIndex] animated:YES completion:nil];
}

#pragma mark - Private

- (void)_toggleZoomWithPageIndex:(NSUInteger)pageIndex
{
	if([self.safariPageController isZoomedOut]) {
		[self.safariPageController zoomIntoPageAtIndex:pageIndex animated:YES completion:nil];
	} else {
		[self.safariPageController zoomOutAnimated:YES completion:nil];
	}
	
	for(SCViewController *viewController in self.dataSource) {
		if(![viewController isEqual:[NSNull null]]) {
			[viewController setHeaderVisible:self.safariPageController.isZoomedOut animated:YES];
		}
	}
	
	[UIView animateWithDuration:0.25f animations:^{
		[self.addButton setAlpha:self.safariPageController.isZoomedOut];
	}];
}

@end
