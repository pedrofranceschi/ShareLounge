//
//  SLMainWindowController.h
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SLServerRequests.h"
#import "SLGroupTableCellView.h"
#import "SLUserTableCellView.h"
#import "SLTorrentTableCellView.h"

@interface SLMainWindowController : NSWindowController {
    IBOutlet NSTableView *groupsTableView, *torrentsTableView;
    IBOutlet NSProgressIndicator *progressIndicator;
    NSMutableArray *groups, *cellsInformations, *torrentsInformations;
    SLServerRequests *serverRequests;
    int selectedGroup;
}

- (void)updateInformations;
- (void)expandGroup:(int)group;

@property (assign) IBOutlet NSTableView *groupsTableView, *torrentsTableView;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

@end
