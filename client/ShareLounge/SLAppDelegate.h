//
//  SLAppDelegate.h
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SLLoginWindowController.h"
#import "SLMainWindowController.h"
#import "SLSessionManager.h"

@interface SLAppDelegate : NSObject <NSApplicationDelegate> {
    SLLoginWindowController *loginWindowController;
    SLMainWindowController *mainWindowController;
}

- (IBAction)menuLogoutPressed:(id)sender;
- (void)presentMainWindow;

@property (assign) IBOutlet NSWindow *window;

@end
