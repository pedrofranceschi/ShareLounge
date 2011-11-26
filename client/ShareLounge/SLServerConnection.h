//
//  SLServerConnection.h
//  ShareLounge
//
//  Created by iMac on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJsonParser.h"

@protocol SLServerConnectionDelegate

// @required
// - (void)serverConnection:(id)serverConnection didReceiveResponse:(id)response;
// - (void)serverConnection:(id)serverConnection didFailWithError:(NSError *)error;

@end

@interface SLServerConnection : NSObject {
    BOOL parseResponse;
    NSURL *requestURL;
    NSMutableData *receivedData;
    SEL successCallback, errorCallback;
    id delegate;
}

- (id)initWithDelegate:(<SLServerConnectionDelegate>)_delegate;
- (void)performRequestWithURL:(NSURL *)_requestURL parameters:(NSDictionary *)_parameters parseResponse:(BOOL)_parseResponse;
- (void)performRequestWithURL:(NSURL *)_requestURL content:(NSString *)_content parseResponse:(BOOL)_parseResponse;

@property (readonly) NSURL *requestURL;
@property (assign) SEL successCallback, errorCallback;

@end
