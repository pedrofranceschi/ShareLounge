//
//  SLLoginWindowController.m
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLLoginWindowController.h"
#import "SLAppDelegate.h"

@implementation SLLoginWindowController

- (NSString *)windowNibName 
{
    return @"LoginWindow";
}

- (IBAction)login:(id)sender {
    SLServerRequests *serverRequests = [[SLServerRequests alloc] initWithDelegate:self];
    [serverRequests verifyCredentialsWithEmail:[emailField stringValue] password:[passwordField stringValue]];
    
    [progressIndicator startAnimation:self.window];
    [emailField setEnabled:NO];
    [passwordField setEnabled:NO];
}

- (void)didVerifyCredentialsWithError:(NSError *)_error response:(NSDictionary *)_response {
    [progressIndicator stopAnimation:self.window];
    [emailField setEnabled:YES];
    [passwordField setEnabled:YES];
    
    if(_error) {
        [SLAlertSheet alertSheetWithTitle:@"Unable to Login" description:[_error domain] window:self.window];
    } else {
        [[self window] orderOut:nil];
        [(SLAppDelegate *)[NSApp delegate] presentMainWindow];
        // SLMainWindowController *mainWindowController = [[SLMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
        // [NSBundle loadNibNamed:@"MainWindow" owner:self];
        // [mainWindowController showWindow:nil];
    }
}

@end
