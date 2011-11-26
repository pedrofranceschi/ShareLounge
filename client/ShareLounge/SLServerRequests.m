//
//  SLServerRequests.m
//  ShareLounge
//
//  Created by iMac on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLServerRequests.h"

#define kAPIURL @"http://0.0.0.0:3000/api/"
#define kVerifyCredentialsCallback @selector(didVerifyCredentialsWithError:response:)

@implementation SLServerRequests

- (id)initWithDelegate:(id)_delegate {
    delegate = _delegate;
    serverConnection = [[SLServerConnection alloc] initWithDelegate:self];
    
    return self;
}

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

// Verify Credentials

- (void)verifyCredentialsWithEmail:(NSString *)email password:(NSString *)password {
    [serverConnection setSuccessCallback:@selector(_verifyCredentialsDidReceiveResponse:)];
    [serverConnection setErrorCallback:@selector(_verifyCredentialsDidFailWithError:)];
    
    [serverConnection performRequestWithURL:[self _requestURLForAPIMethod:@"verify_credentials"] 
    parameters:[NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil] parseResponse:YES];
}

- (void)_verifyCredentialsDidReceiveResponse:(NSDictionary *)response {
    if([[response objectForKey:@"success"] boolValue]) {
        [self _performSelectorIfDelegateRespondsToSelector:kVerifyCredentialsCallback withObject:nil withObject:response];
    } else {
        [self _performSelectorIfDelegateRespondsToSelector:kVerifyCredentialsCallback withObject:[self _errorFromResponseObject:response] withObject:response];
    }
}

- (void)_verifyCredentialsDidFailWithError:(NSError *)error {
    [self _performSelectorIfDelegateRespondsToSelector:kVerifyCredentialsCallback withObject:error withObject:nil];
}

// Other methods

@end
