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
        torrentsInformations = [[NSMutableArray alloc] init];
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
    if(tableView == groupsTableView) {
        if([[[cellsInformations objectAtIndex:row] objectForKey:@"type"] isEqualToString:@"group"]) {
            return 37;
        } else { // user cell
            return 20;
        }
    } else if(tableView == torrentsTableView) {
        return 85;
    }
}

- (void)didGetGroupsWithError:(NSError *)_error response:(NSArray *)_groups
{
    [progressIndicator stopAnimation:self];
    groups = [_groups mutableCopy];
    [self generateCellsInformationsArray];
    [groupsTableView reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    if(tableView == groupsTableView) {
        return [cellsInformations count];
    } else if(tableView == torrentsTableView) {
        return [torrentsInformations count];
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if(tableView == groupsTableView) {
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
    } else if(tableView == torrentsTableView) {
        NSDictionary *torrentInformations = [torrentsInformations objectAtIndex:row];
        
        SLTorrentTableCellView *cellView = [tableView makeViewWithIdentifier:@"TorrentCell" owner:self];
        
        cellView.name.stringValue = [torrentInformations objectForKey:@"name"];
        cellView.creator.stringValue = [NSString stringWithFormat:@"Added by %@", [[torrentInformations objectForKey:@"creator"] objectForKey:@"name"]];
        cellView.description.stringValue = [torrentInformations objectForKey:@"description"];
        
        return cellView;
    }
}

- (void)updateTorrentsTableView {
    torrentsInformations = [[NSMutableArray alloc] init];
    for(NSDictionary *_torrent in [[groups objectAtIndex:selectedGroup] objectForKey:@"torrents"]) {
        NSMutableDictionary *torrent = [_torrent mutableCopy];
        
        // searches for creator data in groups dictionary
        for(NSDictionary *userInformations in [[groups objectAtIndex:selectedGroup] objectForKey:@"users"]) {
            if([[userInformations objectForKey:@"id"] intValue] == [[torrent objectForKey:@"creatorId"] intValue]) {
                [torrent setObject:userInformations forKey:@"creator"];
                break;
            }
        }
        
        [torrentsInformations addObject:torrent];
    }
    
    [torrentsTableView reloadData];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)rowIndex {
    if(tableView == groupsTableView) {
        if([[[cellsInformations objectAtIndex:rowIndex] objectForKey:@"type"] isEqualToString:@"group"]) {
            selectedGroup = [[[cellsInformations objectAtIndex:rowIndex] objectForKey:@"index"] intValue];
            [self updateTorrentsTableView];
            
            return YES;
        }
    }
    
    return NO;
}

@end
