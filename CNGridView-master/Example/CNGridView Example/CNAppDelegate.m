//
//  CNAppDelegate.m
//  CNGridView Example
//
//  Created by cocoa:naut on 12.10.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "CNAppDelegate.h"
#import "CNGridViewItem.h"
#import "CNGridViewItemLayout.h"


static NSString *kContentTitleKey, *kContentImageKey, *kItemSizeSliderPositionKey;

@interface CNAppDelegate ()
@property (strong) CNGridViewItemLayout *defaultLayout;
@property (strong) CNGridViewItemLayout *hoverLayout;
@property (strong) CNGridViewItemLayout *selectionLayout;
@end

@implementation CNAppDelegate

+ (void)initialize {
	kContentTitleKey = @"itemTitle";
	kContentImageKey = @"itemImage";
	kItemSizeSliderPositionKey = @"ItemSizeSliderPosition";
}

- (id)init {
	self = [super init];
	if (self) {
		_items = [[NSMutableArray alloc] init];
		_defaultLayout = [CNGridViewItemLayout defaultLayout];
		_hoverLayout = [CNGridViewItemLayout defaultLayout];
		_selectionLayout = [CNGridViewItemLayout defaultLayout];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.hoverLayout.backgroundColor = [[NSColor grayColor] colorWithAlphaComponent:0.42];
	self.selectionLayout.backgroundColor = [NSColor colorWithCalibratedRed:0.542 green:0.699 blue:0.807 alpha:0.420];

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewWillHoverItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewWillUnhoverItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewWillSelectItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewDidSelectItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewWillDeselectItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewDidDeselectItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewDidClickItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewDidDoubleClickItemNotification object:nil];
	[nc addObserver:self selector:@selector(detectedNotification:) name:CNGridViewRightMouseButtonClickedOnItemNotification object:nil];

	/// insert some content
	for (int i = 0; i < 200; i++) {
		[self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                       [NSImage imageNamed:NSImageNameComputer], kContentImageKey,
		                       NSImageNameComputer, kContentTitleKey,
		                       nil]];
		[self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                       [NSImage imageNamed:NSImageNameNetwork], kContentImageKey,
		                       NSImageNameNetwork, kContentTitleKey,
		                       nil]];
		[self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                       [NSImage imageNamed:NSImageNameFolder], kContentImageKey,
		                       NSImageNameFolder, kContentTitleKey,
		                       nil]];
		[self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                       [NSImage imageNamed:NSImageNameFolderSmart], kContentImageKey,
		                       NSImageNameFolderSmart, kContentTitleKey,
		                       nil]];
		[self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                       [NSImage imageNamed:NSImageNameBonjour], kContentImageKey,
		                       NSImageNameBonjour, kContentTitleKey,
		                       nil]];
		[self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                       [NSImage imageNamed:@"AppleLogo"], kContentImageKey,
		                       @"AppleLogo", kContentTitleKey,
		                       nil]];
		[self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                       [NSImage imageNamed:NSImageNameFolderBurnable], kContentImageKey,
		                       NSImageNameFolderBurnable, kContentTitleKey,
		                       nil]];
	}

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults integerForKey:kItemSizeSliderPositionKey]) {
		self.itemSizeSlider.integerValue = [defaults integerForKey:kItemSizeSliderPositionKey];
	}
	self.gridView.itemSize = NSMakeSize(self.itemSizeSlider.integerValue, self.itemSizeSlider.integerValue);
	self.gridView.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"BackgroundDust"]];
	self.gridView.scrollElasticity = YES;
	[self.gridView reloadData];
}

- (IBAction)testContextMenuItemAction:(id)sender {
	NSMenuItem *item = sender;
	NSIndexSet *index = item.representedObject;
	NSLog(@"Clicked 'test' menu item in item context menu for item at index '%@'", index);
}

- (IBAction)itemSizeSliderAction:(id)sender {
	self.gridView.itemSize = NSMakeSize(self.itemSizeSlider.integerValue, self.itemSizeSlider.integerValue);
	[[NSUserDefaults standardUserDefaults] setInteger:self.itemSizeSlider.integerValue forKey:kItemSizeSliderPositionKey];
}

- (IBAction)allowMultipleSelectionCheckboxAction:(id)sender {
	self.gridView.allowsMultipleSelection = (self.allowMultipleSelectionCheckbox.state == NSOnState ? YES : NO);

	if (self.gridView.allowsMultipleSelection) {
		[_allowMultipleSelectionWithDragCheckbox setEnabled:YES];
	}
	else {
		[_allowMultipleSelectionWithDragCheckbox setEnabled:NO];
	}
}

- (void)allowMultipleSelectionCheckboxWithDragAction:(id)sender {
	self.gridView.allowsMultipleSelectionWithDrag = (self.allowMultipleSelectionWithDragCheckbox.state == NSOnState ? YES : NO);
}

- (IBAction)deleteButtonAction:(id)sender {
}

- (IBAction)selectAllItemsButtonAction:(id)sender {
	[self.gridView selectAllItems];
}

- (IBAction)testAddItem:(id)sender {
	NSUInteger count = self.items.count;
	NSUInteger index = count / 2;
	NSString *title = [NSString stringWithFormat:@"new %lu", count];
	[self.items insertObject:[NSDictionary dictionaryWithObjectsAndKeys:
	                          [NSImage imageNamed:NSImageNameFolderBurnable], kContentImageKey,
	                          title, kContentTitleKey,
	                          nil]
	                 atIndex:index];
    //    [self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
    //                               [NSImage imageNamed:NSImageNameFolderBurnable], kContentImageKey,
    //                               title, kContentTitleKey,
    //                               nil]];

	[self.gridView insertItemAtIndex:index animated:YES];
}

- (IBAction)testAddItems:(id)sender {
	NSUInteger count = self.items.count;
	NSUInteger index = count / 2;
	NSUInteger len = 5;
	for (NSUInteger i = 0; i < len; i++) {
		NSString *title = [NSString stringWithFormat:@"new %lu", count + i];
		[self.items insertObject:[NSDictionary dictionaryWithObjectsAndKeys:
		                          [NSImage imageNamed:NSImageNameFolderBurnable], kContentImageKey,
		                          title, kContentTitleKey,
		                          nil]
		                 atIndex:index];
	}

	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, len)];
	[self.gridView insertItemsAtIndexes:indexSet animated:YES];
}

#pragma mark - CNGridView DataSource

- (NSUInteger)gridView:(CNGridView *)gridView numberOfItemsInSection:(NSInteger)section {
	return self.items.count;
}

- (CNGridViewItem *)gridView:(CNGridView *)gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section {
	static NSString *reuseIdentifier = @"CNGridViewItem";

	CNGridViewItem *item = [gridView dequeueReusableItemWithIdentifier:reuseIdentifier];
	if (item == nil) {
		item = [[CNGridViewItem alloc] initWithLayout:self.defaultLayout reuseIdentifier:reuseIdentifier];
	}
	item.hoverLayout = self.hoverLayout;
	item.selectionLayout = self.selectionLayout;

	NSDictionary *contentDict = [self.items objectAtIndex:index];
	item.itemTitle = [contentDict objectForKey:kContentTitleKey]; // [NSString stringWithFormat:@"Item: %lu", index];
	item.itemImage = [contentDict objectForKey:kContentImageKey];

	return item;
}

#pragma mark - NSNotifications

- (void)detectedNotification:(NSNotification *)notif {
    //    CNLog(@"notification: %@", notif);
}

#pragma mark - CNGridView Delegate

- (void)gridView:(CNGridView *)gridView didClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	CNLog(@"didClickItemAtIndex: %li", index);
}

- (void)gridView:(CNGridView *)gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	CNLog(@"didDoubleClickItemAtIndex: %li", index);
}

- (void)gridView:(CNGridView *)gridView didActivateContextMenuWithIndexes:(NSIndexSet *)indexSet inSection:(NSUInteger)section {
	CNLog(@"rightMouseButtonClickedOnItemAtIndex: %@", indexSet);
}

- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	CNLog(@"didSelectItemAtIndex: %li", index);
}

- (void)gridView:(CNGridView *)gridView didDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	CNLog(@"didDeselectItemAtIndex: %li", index);
}

@end
