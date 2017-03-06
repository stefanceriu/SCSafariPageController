# SCSafariPageController


SCSafariPageController page view controller component that reproduces the behavior seen in Mobile Safari's tab switcher and is intended as a demo for [SCPageViewController](https://github.com/stefanceriu/SCPageViewController)

Features:

- can zoom out, partially overlap and lean in pages similar to Safari
- can zoom in and focus on any of the pages and animates the layout change
- allows swipe to delete on one or multiple pages at the same time
- dynamically adapts the inter-item spacings and page angles based on the total number of pages, even while swiping to delete
- increases the page angles when scrolling outside its bounds
- supports incremental updates

and all the rest of the [SCPageViewController](https://github.com/stefanceriu/SCPageViewController) niceties.


![](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoN29jUXItTGNPNHc)

### Implementation details

SCSafariPageController is built on top of [SCPageViewController](https://github.com/stefanceriu/SCPageViewController) and makes use of custom page layouters to get the desired effects.

It wraps view controllers inside the scroll view based SCSafariPageWrapperViewController to get the slide to delete feature and then applies variable inter-item spacings and sublayer transforms (angle, perspective and scale) to the pages, based on the total number of pages and the content offset.

### Usage

- Create a new instance and register as its data source and, optionally, delegate

```objc
    self.safariPageController = [[SCSafariPageController alloc] init];
	[self.safariPageController setDataSource:self];
	[self.safariPageController setDelegate:self];
```

- Implement the SCSafariPageControllerDateSource protocol to define the total number of pages and the view controllers to be used for each of them

```
- (NSUInteger)numberOfPagesInPageController:(SCSafariPageController *)pageController;

- (UIViewController *)pageController:(SCSafariPageController *)pageController viewControllerForPageAtIndex:(NSUInteger)index;
```

- Optionally, listen to any of the following delegate events

```
- (void)pageController:(SCSafariPageController *)pageController didShowViewController:(UIViewController *)controller atIndex:(NSUInteger)index;

- (void)pageController:(SCSafariPageController *)pageController didHideViewController:(UIViewController *)controller atIndex:(NSUInteger)index;
			  
- (void)pageController:(SCSafariPageController *)pageController didNavigateToOffset:(CGPoint)offset;
   
- (void)pageController:(SCSafariPageController *)pageController didNavigateToPageAtIndex:(NSUInteger)pageIndex;

- (void)pageController:(SCSafariPageController *)pageController willDeletePageAtIndex:(NSUInteger)pageIndex;

- (void)pageController:(SCSafariPageController *)pageController didDeletePageAtIndex:(NSUInteger)pageIndex;
```

- Zoom in and out

```objc
- (void)zoomOutAnimated:(BOOL)animated completion:(void(^)())completion;

- (void)zoomIntoPageAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void(^)())completion;
```

- SCSafariPageController also supports incremental updates with animations that are customizable through its active layouter

```objc
	[self.safariPageController insertPagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:^(void)completion];

	[self.safariPageController deletePagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:^(void)completion]

	[self.safariPageController reloadPagesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated completion:^(void)completion]

	[self.safariPageController movePageAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex animated:(BOOL)animated completion:^(void)completion]
```

### For more usage examples please have a look at the included demo project (`pod try SCSafariPageController`)

### License
SCSafariPageController is released under the MIT License (MIT) (see the LICENSE file)

### Contact
Any suggestions or improvements are more than welcome  and I would also love to know if you are using this component in a published application.
Feel free to contact me at [stefan.ceriu@yahoo.com](mailto:stefan.ceriu@yahoo.com) or [@stefanceriu](https://twitter.com/stefanceriu).
