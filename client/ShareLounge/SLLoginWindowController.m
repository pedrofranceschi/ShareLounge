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
    SLServerConnection *serverConnection = [[SLServerConnection alloc] initWithDelegate:self];
    
    [serverConnection performRequestWithURL:[NSURL URLWithString:@"http://0.0.0.0:3000/api/verify_credentials"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"bla@gmail.com", @"email", @"mycoolpass", @"password", nil] parseResponse:YES];
    // [serverConnection performRequestWithURL:[NSURL URLWithString:@"http://0.0.0.0:3000/api/verify_credentials"] content:@"" parseResponse:YES];
    NSLog(@"%s LOGIN! ", _cmd);
    NSLog(@"%s EMAIL: %@", _cmd, [emailField stringValue]);
}

- (void)serverConnection:(id)serverConnection didReceiveResponse:(id)response {
    NSLog(@"%s RECEIVED RESPONSE %@", _cmd, response);
}

- (void)serverConnection:(id)serverConnection didFailWithError:(NSError *)error {
    NSLog(@"%s RECEIVED ERROR %@", _cmd, error);
}

@end
