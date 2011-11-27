//
//  SLSessionManager.m
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLSessionManager.h"

@implementation SLSessionManager

+ (BOOL)hasSavedSession {
    return [[SLPersistencyManager sharedInstance] objectForKey:@"session"] != nil;
}

+ (NSDictionary *)savedSession {
    return [[SLPersistencyManager sharedInstance] objectForKey:@"session"];
}

+ (void)destroySession {
    [[SLPersistencyManager sharedInstance] destroy];
    [[SLPersistencyManager sharedInstance] save];
}

+ (void)saveSessionWithInformations:(NSDictionary *)informations {
    NSMutableDictionary *session = [[[NSDictionary alloc] initWithObjectsAndKeys:[[NSDate alloc] init], @"sessionCreatedAt", nil] mutableCopy];
    [session addEntriesFromDictionary:informations];
    [[SLPersistencyManager sharedInstance] setObject:session forKey:@"session"];
    [[SLPersistencyManager sharedInstance] save];
}

@end
