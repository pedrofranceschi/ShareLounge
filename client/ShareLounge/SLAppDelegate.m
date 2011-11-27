//
//  SLAppDelegate.m
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLAppDelegate.h"

@implementation SLAppDelegate

- (id)init {
    loginWindowController = [[SLLoginWindowController alloc] initWithWindowNibName:@"LoginWindow"];    
    mainWindowController = [[SLMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    if([SLSessionManager hasSavedSession]) {
        [self presentMainWindow];
    } else {
        [[loginWindowController window] makeKeyAndOrderFront:self];
    }
}

- (void)closeAllWindows {
    for(NSWindow *window in [[NSApplication sharedApplication] windows]) {
        [window orderOut:self];
    }
}

- (IBAction)menuLogoutPressed:(id)sender {
    if([SLSessionManager hasSavedSession]) {
        [SLSessionManager destroySession];
        [self closeAllWindows];
        [[mainWindowController window] orderOut:self];
        [[loginWindowController window] makeKeyAndOrderFront:self];
    }
}

- (void)presentMainWindow {
    [self closeAllWindows];
    [[mainWindowController window] makeKeyAndOrderFront:nil];
    [mainWindowController updateInformations];
}

@end
