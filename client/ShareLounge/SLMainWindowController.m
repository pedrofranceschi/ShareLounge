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
    
    NSString *torrentsString;
    int torrentsCount = [[[groups objectAtIndex:row] objectForKey:@"torrents"] count];
    
    if(torrentsCount == 1) {
        torrentsString = @"torrent";
    } else {
        torrentsString = @"torrents";
    }
    
    cellView.torrentsCount.stringValue = [NSString stringWithFormat:@"%i %@", torrentsCount, torrentsString];
    
    NSString *usersString;
    int usersCount = [[[groups objectAtIndex:row] objectForKey:@"users"] count];
    
    if(usersCount == 1) {
        usersString = @"user";
    } else {
        usersString = @"users";
    }
    
    cellView.usersCount.stringValue = [NSString stringWithFormat:@"%i %@", usersCount, usersString];
    
    return cellView;
}

@end
