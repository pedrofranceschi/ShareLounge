//
//  SLLoginWindowController.m
//  ShareLounge
//
//  Created by iMac on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLLoginWindowController.h"

@implementation SLLoginWindowController

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)login:(id)sender {
    SLServerRequests *serverRequests = [[SLServerRequests alloc] initWithDelegate:self];
    [serverRequests verifyCredentialsWithEmail:[emailField stringValue] password:[passwordField stringValue]];
}

- (void)didVerifyCredentialsWithError:(NSError *)_error response:(NSDictionary *)_response {
    NSLog(@"%s error: %@", _cmd, _error);
    NSLog(@"%s response: %@", _cmd, _response);
}

@end
