//
//  SLGroupTableCellView.h
//  ShareLounge
//
//  Created by iMac on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "SLMainWindowController.h"

@interface SLGroupTableCellView : NSTableCellView {
    IBOutlet NSTextField *groupName, *torrentsCount, *usersCount;
}

@property (strong, nonatomic) NSTextField *groupName, *torrentsCount, *usersCount;

@end
