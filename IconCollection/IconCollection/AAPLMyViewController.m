/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Controls the collection view of icons.
 */

#import "AAPLMyViewController.h"

@interface AAPLIconViewBox : NSBox
@end


#pragma mark -

@implementation AAPLIconViewBox

// -------------------------------------------------------------------------------
//	hitTest:aPoint
// -------------------------------------------------------------------------------
- (NSView *)hitTest:(NSPoint)aPoint
{
    // don't allow any mouse clicks for subviews in this NSBox
    return nil;
}

@end


#pragma mark -

@interface AAPLMyViewController () <NSCollectionViewDelegate>

@property (strong) NSArray *savedAlternateColors;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSCollectionView *collectionView;

@end


#pragma mark -

@implementation AAPLMyViewController

static NSString * const KEY_IMAGE = @"icon";
static NSString * const KEY_NAME = @"name";

// -------------------------------------------------------------------------------
//	viewDidLoad
// -------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // bug in OS X 10.11.x in that NSCollectionView cannot be connected to its prototype item in the storyboard
    // so we set it here programmatically
    //
    NSCollectionViewItem *collectionViewItem = [self.storyboard instantiateControllerWithIdentifier:@"collectionViewItem"];
    self.collectionView.itemPrototype = collectionViewItem;

    // save this for later when toggling between alternate colors
    _savedAlternateColors = self.collectionView.backgroundColors;

    self.sortingMode = 0;		// ascending sort order
    self.alternateColors = NO;	// no alternate background colors (initially use gradient background)
    
    // Determine the content of the collection view by reading in the plist "icons.plist",
    // and add extra "named" template images with the help of NSImage class.
    //
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icons" ofType:@"plist"];
    NSArray	*iconEntries = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *icons = [[NSMutableArray alloc] init];
    if (iconEntries != nil)
    {
        for (NSDictionary *entry in iconEntries)
        {
            NSString *codeStr = entry[KEY_IMAGE];
            NSString *iconName = entry[KEY_NAME];
            
            OSType code = UTGetOSTypeFromString((__bridge CFStringRef)codeStr);
            NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
            [icons addObject: @{KEY_IMAGE: picture, KEY_NAME: iconName}];
        }
    }
    
    // now add named image templates
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameIconViewTemplate], KEY_NAME: NSImageNameIconViewTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameBluetoothTemplate], KEY_NAME: NSImageNameBluetoothTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameIChatTheaterTemplate], KEY_NAME: NSImageNameIChatTheaterTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameSlideshowTemplate], KEY_NAME: NSImageNameSlideshowTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameActionTemplate], KEY_NAME: NSImageNameActionTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameSmartBadgeTemplate], KEY_NAME: NSImageNameSmartBadgeTemplate}];
    
    // Finder icon templates
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameListViewTemplate], KEY_NAME: NSImageNameListViewTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameColumnViewTemplate], KEY_NAME: NSImageNameColumnViewTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameFlowViewTemplate], KEY_NAME: NSImageNameFlowViewTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNamePathTemplate], KEY_NAME: NSImageNamePathTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameInvalidDataFreestandingTemplate], KEY_NAME: NSImageNameInvalidDataFreestandingTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameLockLockedTemplate], KEY_NAME: NSImageNameLockLockedTemplate}];
    [icons addObject: @{KEY_IMAGE: [NSImage imageNamed:NSImageNameLockUnlockedTemplate], KEY_NAME: NSImageNameLockUnlockedTemplate}];

    [self.arrayController addObjects:icons];
    
    self.arrayController.selectionIndex = -1;
    [self.collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

// -------------------------------------------------------------------------------
//	setAlternateColors:useAlternateColors
// -------------------------------------------------------------------------------
- (void)setAlternateColors:(BOOL)useAlternateColors
{
    _alternateColors = useAlternateColors;

    self.collectionView.backgroundColors =
        _alternateColors ?  @[[NSColor gridColor], [NSColor lightGrayColor]] : self.savedAlternateColors;
}

// -------------------------------------------------------------------------------
//	setSortingMode:newMode
// -------------------------------------------------------------------------------
- (void)setSortingMode:(NSUInteger)newMode
{
    _sortingMode = newMode;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                               initWithKey:KEY_NAME
                               ascending:(_sortingMode == 0)
                               selector:@selector(caseInsensitiveCompare:)];
    self.arrayController.sortDescriptors = @[sort];
}

// -------------------------------------------------------------------------------
//	collectionView:writeItemsAtIndexes:indexes:pasteboard
//
//	Collection view drag and drop
//  User must click and hold the item(s) to perform a drag.
// -------------------------------------------------------------------------------
- (BOOL)collectionView:(NSCollectionView *)cv writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
    NSMutableArray *urls = [NSMutableArray array];
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
        {
            NSDictionary *dictionary = cv.content[idx];
            NSImage *image = dictionary[KEY_IMAGE];
            NSString *name = dictionary[KEY_NAME];
            if (image && name)
            {
                // construct the url of the tiff image to be used as our drag source
                NSURL *url = [temporaryDirectoryURL URLByAppendingPathComponent:name];
                url = [url URLByAppendingPathExtension:@"tiff"];
                              
                [urls addObject:url];
                [image.TIFFRepresentation writeToURL:url atomically:YES];
            }
        }];
    if (urls.count > 0)
    {
        [pasteboard clearContents];
        return [pasteboard writeObjects:urls];
    }
    return NO;
}

@end
