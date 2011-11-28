//
//  SLGroupsTableCellView.h
//  ShareLounge
//
//  Created by iMac on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SLGroupsTableCellView : NSTableCellView {
    IBOutlet NSTextField *groupName, *torrentsCount, *usersCount;
}

@property (strong, nonatomic) NSTextField *groupName, *torrentsCount, *usersCount;

@end
