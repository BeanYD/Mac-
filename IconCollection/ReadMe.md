# IconCollection

IconCollection is a Cocoa sample application that demonstrates how to use NSCollectionView with Cocoa Bindings along with NSWorkspace and named images to determine its content.  


## Using the Sample

Simply build and run the sample using Xcode.  Use the window's toolbar items to manipulate the contents of the collection view.

1) Ascending/Descending sort order -
	Affects the collection view's sort order indirectly by setting the NSArrayController sort descriptors.
2) Alternate colors -
	Set on the collection view's background colors (alternate colors) by calling:
		- (void)setBackgroundColors:(NSArray *)colors;
	If alternate colors is turned off, the NSCollectionView's enclosing scroll view draws its background using NSGradient.
3) Searching - 
	Changes what the collection view displays based on the icon display name indirectly by setting the NSArrayController's filterPredicate.
4) Uses NSBox "Transparent" binding to affect the collection view's selection appearance.
5) Collection view selection -
	A text label binds to the array controller selection to detect selection changes.
	This is done by binding to MyWindowController,
		model key path = "contentViewController.arrayController.selection.name".
	It also overrides both "Multiple Values Placeholder" and "No Selection Placeholder" for this this value binding.

## Requirements

### Build

OS X 10.11 SDK or later

### Runtime

OS X 10.11 or later


Copyright (C) 2007-2016 Apple Inc. All rights reserved.