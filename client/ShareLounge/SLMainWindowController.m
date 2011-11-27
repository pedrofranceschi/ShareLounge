//
//  SLMainWindowController.m
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLMainWindowController.h"

@implementation SLMainWindowController

- (NSString *)windowNibName 
{
    return @"MainWindow";
}

- (id)init {
    serverRequests = [[SLServerRequests alloc] initWithDelegate:self];
    return self;
}

- (void)windowDidLoad {
    // NSLog(@"%s awakeFromNib ", _cmd, );
    [self updateInformations];
}

- (void)updateInformations {
    [serverRequests getGroups];
}

- (void)didGetGroupsWithError:(NSError *)_error response:(id)_response
{
    NSLog(@"%s GOT GROUPS! error: %@", _cmd, _error);
    NSLog(@"%s RESPONSE: %@", _cmd, _response);
}

// Groups table view methods

// - (int)numberOfRowsInTableView:(NSTableView *)tableView
// {
//     return [iPodVolumes count];
// }
// 
// - (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row {
//     return [iPodVolumes objectAtIndex:row];
// }

@end
