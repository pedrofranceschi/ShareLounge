//
//  SLTorrentTableCellView.h
//  ShareLounge
//
//  Created by iMac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SLTorrentTableCellView : NSTableCellView {
    IBOutlet NSTextField *name, *creator, *description, *age;
    int highlightBackground;
}

- (IBAction)delete:(id)sender;
- (IBAction)download:(id)sender;

@property (strong, nonatomic) NSTextField *name, *creator, *description, *age;
@property (assign) int highlightBackground;

@end
