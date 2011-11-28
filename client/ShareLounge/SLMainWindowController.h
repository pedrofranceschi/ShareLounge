//
//  SLMainWindowController.h
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SLServerRequests.h"
#import "SLGroupsTableCellView.h"

@interface SLMainWindowController : NSWindowController {
    IBOutlet NSTableView *groupsTableView;
    IBOutlet NSProgressIndicator *progressIndicator;
    NSMutableArray *groups;
    SLServerRequests *serverRequests;
}

- (void)updateInformations;

@property (assign) IBOutlet NSTableView *groupsTableView;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

@end
