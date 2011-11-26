//
//  SLAlertSheet.m
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLAlertSheet.h"

@implementation SLAlertSheet

+ (void)alertSheetWithTitle:(NSString *)_title description:(NSString *)_description window:(NSWindow *)_window {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:_title];
    [alert setInformativeText:_description];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:_window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

@end
