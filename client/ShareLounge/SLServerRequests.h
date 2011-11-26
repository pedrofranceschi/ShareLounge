//
//  SLServerRequests.h
//  ShareLounge
//
//  Created by iMac on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLServerConnection.h"
#import "SLSessionManager.h"

@protocol SLServerRequestsDelegate

@optional
- (void)didVerifyCredentialsWithError:(NSError *)_error response:(NSDictionary *)_response;

@end

@interface SLServerRequests : NSObject {
    SLServerConnection *serverConnection;
    id delegate;
}

- (id)initWithDelegate:(id)_delegate;
- (void)verifyCredentialsWithEmail:(NSString *)email password:(NSString *)password;

@end
