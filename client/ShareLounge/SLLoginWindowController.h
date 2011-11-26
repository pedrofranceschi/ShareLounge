//
//  SLLoginWindowController.h
//  ShareLounge
//
//  Created by iMac on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SLServerConnection.h"

@interface SLLoginWindowController : NSObject <NSApplicationDelegate> {
    IBOutlet NSTextField *emailField;
    IBOutlet NSSecureTextField *passwordField;
}

- (IBAction)login:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *emailField;
@property (assign) IBOutlet NSSecureTextField *passwordField;

@end
