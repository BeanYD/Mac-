/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This sample's main window controller object.
 */

#import "AAPLMyWindowController.h"

@interface AAPLMyWindowController ()

@property (weak) IBOutlet NSButton *alternateColors;
@property (weak) IBOutlet NSSegmentedControl *iconOrdering;

@end


#pragma mark -

@implementation AAPLMyWindowController

// -------------------------------------------------------------------------------
//	awakeFromNib
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
    self.alternateColors.state = 0;
    self.iconOrdering.selectedSegment = 0;
}

@end
