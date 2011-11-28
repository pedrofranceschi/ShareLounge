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

- (void)generateCellsInformationsArray
{
    cellsInformations = [[NSMutableArray alloc] init];
    int i = 0;
    
    for(NSDictionary *groupInformations in groups) {
        NSString *torrentsString;
        int torrentsCount = [[groupInformations objectForKey:@"torrents"] count];
        if(torrentsCount == 1) {
            torrentsString = @"torrent";
        } else {
            torrentsString = @"torrents";
        }

        NSString *usersString;
        int usersCount = [[groupInformations objectForKey:@"users"] count];

        if(usersCount == 1) {
            usersString = @"user";
        } else {
            usersString = @"users";
        }
        
        [cellsInformations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"group", @"type", [groupInformations objectForKey:@"name"], @"name", [NSNumber numberWithInt:i], @"index",
        [NSString stringWithFormat:@"%i %@", torrentsCount, torrentsString], @"torrents", [NSString stringWithFormat:@"%i %@", usersCount, usersString], @"users", nil]];
        
        for(NSDictionary *userInformations in [groupInformations objectForKey:@"users"]) {
            [cellsInformations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"user", @"type", [userInformations objectForKey:@"name"], @"name", nil]];
        }
        
        i += 1;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if([[[cellsInformations objectAtIndex:row] objectForKey:@"type"] isEqualToString:@"group"]) {
        return 37;
    } else { // user cell
        return 20;
    }
}

- (void)didGetGroupsWithError:(NSError *)_error response:(NSArray *)_groups
{
    NSLog(@"%s reloading tableview ", _cmd);
    [progressIndicator stopAnimation:self];
    groups = [_groups mutableCopy];
    [self generateCellsInformationsArray];
    [groupsTableView reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [cellsInformations count];
}

- (void)expandGroup:(int)group {
    // [expandedGroupsIds addObject:[NSNumber numberWithInt:group]];
    // [groupsTableView reloadData];
    // [groupsTableView beginUpdates];
    // NSLog(@"%s expanding for %i", _cmd, group);
    // [groupsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(group+1, [[[groups objectAtIndex:group] objectForKey:@"users"] count])] withAnimation:NSTableViewAnimationSlideDown];
    // [groupsTableView endUpdates];
    // NSLog(@"%s did insert ", _cmd);
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *cellInformations = [cellsInformations objectAtIndex:row];
    
    if([[cellInformations objectForKey:@"type"] isEqualToString:@"group"]) {
        SLGroupTableCellView *cellView = [tableView makeViewWithIdentifier:@"GroupCell" owner:self];
        
        cellView.groupName.stringValue = [cellInformations objectForKey:@"name"];
        cellView.torrentsCount.stringValue = [cellInformations objectForKey:@"torrents"];
        cellView.usersCount.stringValue = [cellInformations objectForKey:@"users"];
        
        return cellView;
    } else if([[cellInformations objectForKey:@"type"] isEqualToString:@"user"]) {
        SLUserTableCellView *cellView = [tableView makeViewWithIdentifier:@"UserCell" owner:self];
        
        cellView.userName.stringValue = [cellInformations objectForKey:@"name"];
        cellView.backgroundStyle = NSBackgroundStyleRaised;
        
        return cellView;
    }
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
    if([[[cellsInformations objectAtIndex:rowIndex] objectForKey:@"type"] isEqualToString:@"group"]) {
        selectedGroup = [[[cellsInformations objectAtIndex:rowIndex] objectForKey:@"index"] intValue];
        return YES;
    }
    return NO;
}

@end
