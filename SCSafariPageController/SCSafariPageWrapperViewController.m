//
//  SCSafariPageWrapperViewController.m
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/30/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "SCSafariPageWrapperViewController.h"

@interface SCSafariPageWrapperViewControllerView : UIView

@end

@interface SCSafariPageWrapperViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIViewController *childViewController;

@end

@implementation SCSafariPageWrapperViewController

- (instancetype)initWithViewController:(UIViewController *)viewController
{
	if(self = [super init]) {
		_childViewController = viewController;
	}
	
	return self;
}

- (void)loadView
{
    self.view = [[SCSafariPageWrapperViewControllerView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self.view setFrame:self.childViewController.view.frame];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.scrollView setDelegate:self];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setClipsToBounds:NO];
    [self.scrollView setScrollEnabled:self.scrollEnabled];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setDirectionalLockEnabled:YES];
    [self.view addSubview:self.scrollView];
	
	[self addChildViewController:self.childViewController];
	[self.scrollView addSubview:self.childViewController.view];
	[self.childViewController.view setFrame:self.scrollView.bounds];
	[self.childViewController didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds) * 2.0f, 0.0f)];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
	if(_scrollEnabled == scrollEnabled) {
		return;
	}
	
	_scrollEnabled = scrollEnabled;
	
	[self.scrollView setScrollEnabled:scrollEnabled];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat percentage = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds);
	self.scrollPercentage = percentage;
	
	if([self.delegate respondsToSelector:@selector(safariPageWrapperViewController:didScrollToPercentage:)]) {
		[self.delegate safariPageWrapperViewController:self didScrollToPercentage:percentage];
	}
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
					 withVelocity:(CGPoint)velocity
			  targetContentOffset:(inout CGPoint *)targetContentOffset
{
	CGFloat percentage = targetContentOffset->x / CGRectGetWidth(self.scrollView.bounds);
	
	if([self.delegate respondsToSelector:@selector(safariPageWrapperViewControllerDidEndDragging:atPercentage:)]) {
		[self.delegate safariPageWrapperViewControllerDidEndDragging:self atPercentage:percentage];
	}
}

@end

@implementation SCSafariPageWrapperViewControllerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView *hitView = [super hitTest:point withEvent:event];
	
	if([hitView isEqual:self]) {
		return nil;
	}
	
	return hitView;
}

@end