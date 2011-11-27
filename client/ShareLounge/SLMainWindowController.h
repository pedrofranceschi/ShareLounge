//
//  SLMainWindowController.h
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SLServerRequests.h"

@interface SLMainWindowController : NSWindowController {
    IBOutlet NSTableView *groupsTableView;
    NSArray *groups;
    SLServerRequests *serverRequests;
}

- (void)updateInformations;

@property (assign) IBOutlet NSTableView *groupsTableView;

@end
