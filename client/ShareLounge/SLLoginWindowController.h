//
//  SLLoginWindowController.h
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SLServerRequests.h"
#import "SLAlertSheet.h"
#import "SLMainWindowController.h"

@interface SLLoginWindowController : NSWindowController {
    IBOutlet NSTextField *emailField;
    IBOutlet NSSecureTextField *passwordField;
    IBOutlet NSProgressIndicator *progressIndicator;
}

- (IBAction)login:(id)sender;

@property (assign) IBOutlet NSTextField *emailField;
@property (assign) IBOutlet NSSecureTextField *passwordField;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

@end
