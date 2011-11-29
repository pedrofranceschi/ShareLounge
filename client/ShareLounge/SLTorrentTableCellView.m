//
//  SLTorrentTableCellView.m
//  ShareLounge
//
//  Created by iMac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLTorrentTableCellView.h"

@implementation SLTorrentTableCellView

@synthesize name, creator, description, age, highlightBackground;

- (void)drawRect:(NSRect)dirtyRect {
    if(highlightBackground == 1) {
        [[NSColor colorWithDeviceRed:0.85 green:0.85 blue:0.85 alpha:1.0] setFill];
        NSRectFill(dirtyRect);
    }
}

- (IBAction)delete:(id)sender {
    NSLog(@"%s ", _cmd);
}

- (IBAction)download:(id)sender {
    NSLog(@"%s ", _cmd);
}

@end
