//
//  SLServerRequests.m
//  ShareLounge
//
//  This class handles all the communication between the 
//  web requests' response, persistency and user interface,
//  to make the web requests as simple as possible.
//
//  Created by iMac on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLServerRequests.h"

#define kAPIURL @"http://0.0.0.0:3000/api/"
#define kVerifyCredentialsCallback @selector(didVerifyCredentialsWithError:response:)
#define kGetGroupsCallback @selector(didGetGroupsWithError:response:)

@implementation SLServerRequests

- (id)initWithDelegate:(id)_delegate {
    delegate = _delegate;
    serverConnection = [[SLServerConnection alloc] initWithDelegate:self];
    
    return self;
}

// Request helpers

- (NSURL *)_requestURLForAPIMethod:(NSString *)method {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAPIURL, method]];
}

- (void)_performSelectorIfDelegateRespondsToSelector:(SEL)_selector withObject:(id)_object withObject:(id)_otherObject {
    if([delegate respondsToSelector:_selector]) {
        [delegate performSelector:_selector withObject:_object withObject:_otherObject];
    }
}

- (NSError *)_errorFromResponseObject:(NSDictionary *)responseObject {
    return [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:-3 userInfo:nil];
}

// Verify Credentials (/api/verify_credentials)

- (void)verifyCredentialsWithEmail:(NSString *)email password:(NSString *)password {
    sessionPassword = password;
    [serverConnection setSuccessCallback:@selector(_verifyCredentialsDidReceiveResponse:)];
    [serverConnection setErrorCallback:@selector(_verifyCredentialsDidFailWithError:)];
    
    [serverConnection performRequestWithURL:[self _requestURLForAPIMethod:@"verify_credentials"] 
    parameters:[NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil] parseResponse:YES];
}

- (void)_verifyCredentialsDidReceiveResponse:(NSDictionary *)response {
    if([[response objectForKey:@"success"] boolValue] && [response objectForKey:@"user"]) {
        NSMutableDictionary *sessionInformations = [[response objectForKey:@"user"] mutableCopy];
        [sessionInformations setObject:sessionPassword forKey:@"password"];
        [SLSessionManager saveSessionWithInformations:sessionInformations];
        [self _performSelectorIfDelegateRespondsToSelector:kVerifyCredentialsCallback withObject:nil withObject:response];
    } else {
        [self _performSelectorIfDelegateRespondsToSelector:kVerifyCredentialsCallback withObject:[self _errorFromResponseObject:response] withObject:response];
    }
}

- (void)_verifyCredentialsDidFailWithError:(NSError *)error {
    [self _performSelectorIfDelegateRespondsToSelector:kVerifyCredentialsCallback withObject:error withObject:nil];
}

// Get groups (/api/groups)

- (void)getGroups {
    [serverConnection setSuccessCallback:@selector(_getGroupsDidReceiveResponse:)];
    [serverConnection setErrorCallback:@selector(_getGroupsDidFailWithError:)];
    
    NSDictionary *sessionInformations = [SLSessionManager savedSession];
    
    [serverConnection performRequestWithURL:[self _requestURLForAPIMethod:@"groups"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:
    [sessionInformations objectForKey:@"email"], @"email", [sessionInformations objectForKey:@"password"], @"password", nil] parseResponse:YES];
}

- (void)_getGroupsDidReceiveResponse:(NSDictionary *)response {
    if([[response objectForKey:@"success"] boolValue] && [response objectForKey:@"groups"]) {
        NSArray *groupsInformations = [response objectForKey:@"groups"];
        [[SLPersistencyManager sharedInstance] setObject:groupsInformations forKey:@"groups" useKeyedArchive:YES];
        [[SLPersistencyManager sharedInstance] save];
        [self _performSelectorIfDelegateRespondsToSelector:kGetGroupsCallback withObject:nil withObject:groupsInformations];
    } else {
        [self _performSelectorIfDelegateRespondsToSelector:kGetGroupsCallback withObject:[self _errorFromResponseObject:response] withObject:response];
    }
}

- (void)_getGroupsDidFailWithError:(NSError *)error {
    [self _performSelectorIfDelegateRespondsToSelector:kGetGroupsCallback withObject:error withObject:nil];
}

// Other methods

@end
