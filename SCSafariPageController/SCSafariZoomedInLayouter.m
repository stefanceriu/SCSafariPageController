//
//  SCSafariZoomedInLayouter.m
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/28/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "SCSafariZoomedInLayouter.h"

@implementation SCSafariZoomedInLayouter

- (instancetype)init
{
	if(self = [super init]) {
		self.navigationType = SCPageLayouterNavigationTypeVertical;
		self.navigationConstraintType = SCPageLayouterNavigationContraintTypeNone;
		
		self.numberOfPagesToPreloadBeforeCurrentPage = 5;
		self.numberOfPagesToPreloadAfterCurrentPage  = 5;
		
		self.interItemSpacing = 0.0f;
	}
	
	return self;
}

- (NSUInteger)zPositionForPageAtIndex:(NSUInteger)index
				   pageViewController:(SCPageViewController *)pageViewController
{
	return index;
}

@end
