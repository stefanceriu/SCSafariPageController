//
//  SCSafariZoomedOutLayouter.h
//  SCSafariPageController
//
//  Created by Stefan Ceriu on 6/22/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import <SCPageViewController/SCPageLayouterProtocol.h>

/** A SCPageViewController page layouter that lays out
 * pages vertically and tilts them to an angle based
 * on the total number of pages and content offset.
 */
@interface SCSafariZoomedOutLayouter : NSObject <SCPageLayouterProtocol>

/** Used by the pageController when pages are being swiped for deletion
 * @param frame the view controller frame
 * @param numberOfPages the total number of pages
 * @param contentOffset the current content offset
 * @return the affine transform that will be used for the given values
 */
- (CATransform3D)sublayerTransformForPageWithFrame:(CGRect)frame
								totalNumberOfPages:(CGFloat)numberOfPages
									 contentOffset:(CGPoint)contentOffset;

/** Used by the pageController when pages are being swiped for deletion
 * @param pageViewController the page view controller where this will be applied
 * @param numberOfPages the total number of pages
 * @return the inter items spacing that will be used for the given values
 */
- (CGFloat)interItemSpacingForPageViewController:(SCPageViewController *)pageViewController
							  totalNumberOfPages:(CGFloat)numberOfPages;

@end
