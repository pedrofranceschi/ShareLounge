//
//  SLUserTableCellView.h
//  ShareLounge
//
//  Created by iMac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SLUserTableCellView : NSTableCellView {
    IBOutlet NSTextField *userName;
}

@property (strong, nonatomic) IBOutlet NSTextField *userName;

@end
