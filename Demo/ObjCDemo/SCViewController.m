//
//  SCViewController.m
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewControllerView : UIView

@end

@interface SCViewController ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@property (nonatomic, assign) BOOL headerVisible;

@end

@implementation SCViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap:)];
	[self.backgroundImageView addGestureRecognizer:tapGesture];
	
	[self setHeaderVisible:self.headerVisible animated:NO];
}

- (void)setHeaderVisible:(BOOL)visible animated:(BOOL)animated
{
	self.headerVisible = visible;
	
	if(!self.isViewLoaded) {
		return;
	}
	
	[UIView animateWithDuration:(animated ? 0.25f : 0.0f) animations:^{
		[self.deleteButton setAlpha:(visible ? 1.0f : 0.0f)];
	}];
}

- (void)onBackgroundTap:(UITapGestureRecognizer *)tap
{
	if([self.delegate respondsToSelector:@selector(viewControllerDidReceiveTap:)]) {
		[self.delegate viewControllerDidReceiveTap:self];
	}
}

- (IBAction)onDeleteButtonTap:(id)sender
{
	if([self.delegate respondsToSelector:@selector(viewControllerDidRequestDelete:)]) {
		[self.delegate viewControllerDidRequestDelete:self];
	}
}

@end

@implementation SCViewControllerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView *hitView = [super hitTest:point withEvent:event];
	
	if([hitView isEqual:self]) {
		return nil;
	}
	
	return hitView;
}

@end
