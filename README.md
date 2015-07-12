# SCSafariPageController


SCSafariPageController page view controller component that reproduces the behavior seen in Mobile Safari's tab switcher and is intended as a demo for [SCPageViewController](https://github.com/stefanceriu/SCPageViewController)

Features:

- can zoom out, partially overlap and lean in pages similar to Safari
- allows swipe to delete for one or multiple pages at the same time
- increases the page angles when scrolling outside its bounds
- can zoom into any of the pages 
- supports incremental updates

and all the rest of the [SCPageViewController](https://github.com/stefanceriu/SCPageViewController) niceties.


![](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCSafariPageController/v1.0.0/SCSafariPageController%201.0.0.gif)

### Implementation details

SCSafariPageController is built on top of [SCPageViewController](https://github.com/stefanceriu/SCPageViewController) and makes use of custom page layouters to get the desired effect.

It wraps view controllers inside the scroll view based SCSafariPageWrapperViewController to get the slide to delete feature and then applies variable inter-item spacings and sublayer transforms (angle, perspective and scale) to the pages, based on the total number of pages and the content offset.

### Usage

- Create a new instance and implement its data source and delegate

```objc
    self.safariPageController = [[SCSafariPageController alloc] init];
	[self.safariPageController setDataSource:self];
	[self.safariPageController setDelegate:self];
```

- Implement the SCSafariPageControllerDateSource protocol which defines the total number of pages and the view controllers to be used for each of them.

```
- (NSUInteger)numberOfPagesInPageController:(SCSafariPageController *)pageController;

- (UIViewController *)pageController:(SCSafariPageController *)pageController viewControllerForPageAtIndex:(NSUInteger)index;
```

- Zoom in and out

```objc
- (void)zoomOutAnimated:(BOOL)animated completion:(void(^)())completion;

- (void)zoomIntoPageAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void(^)())completion;
```

- SCSafariPageController also supports incremental updates and all the animations are customizable through the layouter.

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
