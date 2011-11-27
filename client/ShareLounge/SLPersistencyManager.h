//
//  SLPersistencyManager.h
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPersistencyManager : NSObject {
    NSMutableDictionary *persistencyData;
}

+ (SLPersistencyManager *)sharedInstance;
- (id)objectForKey:(NSString *)_key;
- (id)objectForKey:(NSString *)_key useKeyedArchive:(BOOL)_useKeyedArchive;
- (void)setObject:(id)_object forKey:(NSString *)_key;
- (void)setObject:(id)_object forKey:(NSString *)_key useKeyedArchive:(BOOL)_useKeyedArchive;
- (void)removeObjectForKey:(NSString *)_key;
- (void)save;
- (void)destroy;

@end
