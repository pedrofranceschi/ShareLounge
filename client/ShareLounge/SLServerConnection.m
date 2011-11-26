//
//  SLServerConnection.m
//  ShareLounge
//
//  Created by iMac on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLServerConnection.h"

@implementation SLServerConnection

@synthesize successCallback, errorCallback;

- (id)initWithDelegate:(<SLServerConnectionDelegate>)_delegate {
    delegate = _delegate;
    receivedData = [[NSMutableData alloc] init];
    return self;
}

- (void)performRequestWithURL:(NSURL *)_requestURL parameters:(NSDictionary *)_parameters parseResponse:(BOOL)_parseResponse {
    NSMutableString *content = [[NSMutableString alloc] init];
    NSArray *keys = [_parameters allKeys];
    
    for(int i = 0; i < [keys count]; i++) {
        [content appendString:[NSString stringWithFormat:@"%@=%@&", [keys objectAtIndex:i], [_parameters objectForKey:[keys objectAtIndex:i]]]];
    }
    
    [self performRequestWithURL:_requestURL content:content parseResponse:_parseResponse];
}

- (void)performRequestWithURL:(NSURL *)_requestURL content:(NSString *)_content parseResponse:(BOOL)_parseResponse {
    receivedResponse = NO;
    requestURL = _requestURL;
    parseResponse = _parseResponse;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:[_content dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	
	if(!connection && !receivedResponse) {
        receivedResponse = YES;
		[delegate performSelector:errorCallback withObject:[NSError errorWithDomain:@"Unable to start connection." code:-1 userInfo:nil]];
	}
}

#pragma NSURLConnection Delegate Methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(!receivedResponse) {
        receivedResponse = YES;
	    [delegate performSelector:errorCallback withObject:[NSError errorWithDomain:@"Unable to connect to server." code:-1 userInfo:nil]];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if(!receivedResponse) {
        receivedResponse = YES;
        if(parseResponse) {
            NSError *parseError = nil;
            SBJsonParser *parser = [SBJsonParser new];
            id jsonObject = [parser objectWithString:responseString error:&parseError];
            
            if(parseError) {
                [delegate performSelector:errorCallback withObject:[NSError errorWithDomain:@"Invalid server response." code:-2 userInfo:nil]];
            } else {
                [delegate performSelector:successCallback withObject:jsonObject];
            }
        } else {
            [delegate performSelector:successCallback withObject:responseString];
        }
    }
}


@end
