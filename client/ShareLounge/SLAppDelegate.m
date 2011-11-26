//
//  SLAppDelegate.m
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLAppDelegate.h"

@implementation SLAppDelegate

// @synthesize window = _window;

- (id)init {
    loginWindowController = [[SLLoginWindowController alloc] init];
    mainWindowController = [[SLMainWindowController alloc] init];
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

- (IBAction)menuLogoutPressed:(id)sender {
    [SLSessionManager destroySession];
    NSLog(@"%s window: %@", _cmd, [mainWindowController window]);
    [[mainWindowController window] orderOut:self];
    [[loginWindowController window] makeKeyAndOrderFront:self];
}

- (void)presentMainWindow {
    [[mainWindowController window] makeKeyAndOrderFront:self];
}

@end
