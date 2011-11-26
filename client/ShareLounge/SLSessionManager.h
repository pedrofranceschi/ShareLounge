//
//  SLSessionManager.h
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPersistencyManager.h"

@interface SLSessionManager : NSObject

+ (BOOL)hasSavedSession;
+ (NSDictionary *)savedSession;
+ (void)saveSessionWithInformations:(NSDictionary *)informations;
+ (void)destroySession;

@end
