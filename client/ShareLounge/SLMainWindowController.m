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

- (id)initWithWindowNibName:(NSString *)nibName {
    if(self = [super initWithWindowNibName:nibName]) {
        serverRequests = [[SLServerRequests alloc] initWithDelegate:self];
    }
    
    return self;
}

- (void)updateInformations {
    [serverRequests getGroups];
    [progressIndicator startAnimation:self];
}

- (void)didGetGroupsWithError:(NSError *)_error response:(NSArray *)_groups
{
    NSLog(@"%s reloading tableview ", _cmd);
    groups = [_groups mutableCopy];
    [groupsTableView reloadData];
    [progressIndicator stopAnimation:self];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [groups count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {    
    SLGroupsTableCellView *cellView = [tableView makeViewWithIdentifier:@"GroupCell" owner:self];
    
    cellView.groupName.stringValue = [[groups objectAtIndex:row] objectForKey:@"name"];
    cellView.torrentsCount.stringValue = [NSString stringWithFormat:@"%i torrents", [[[groups objectAtIndex:row] objectForKey:@"torrents"] count]];
    cellView.usersCount.stringValue = [NSString stringWithFormat:@"%i members", [[[groups objectAtIndex:row] objectForKey:@"users"] count]];
    
    return cellView;
}

// - (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
// {
//     return [[groups objectAtIndex:row] objectForKey:@"name"];
// }


@end
