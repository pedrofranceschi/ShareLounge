//
//  SLTorrentTableCellView.m
//  ShareLounge
//
//  Created by iMac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLTorrentTableCellView.h"

@implementation SLTorrentTableCellView

@synthesize name, creator, description, age;

- (IBAction)delete:(id)sender {
    NSLog(@"%s ", _cmd);
}

- (IBAction)download:(id)sender {
    NSLog(@"%s ", _cmd);
}

@end
