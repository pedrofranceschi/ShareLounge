//
//  SLPersistencyManager.m
//  ShareLounge
//
//  Created by iMac on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLPersistencyManager.h"

@implementation SLPersistencyManager

static SLPersistencyManager *sharedInstance;
+ (SLPersistencyManager *)sharedInstance
{
    if(!sharedInstance) {
        sharedInstance = [[SLPersistencyManager alloc] init];
    }

    return sharedInstance;
}

- (id)init {
    persistencyData = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"persistencyData"] mutableCopy];
    if(!persistencyData) {
        persistencyData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)objectForKey:(NSString *)_key {
    return [persistencyData objectForKey:_key];
}

- (id)objectForKey:(NSString *)_key useKeyedArchive:(BOOL)_useKeyedArchive {
    if(!_useKeyedArchive) {
        return [self objectForKey:_key];
    } else {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[self objectForKey:_key]];
    }
}

- (void)setObject:(id)_object forKey:(NSString *)_key {
    [persistencyData setObject:_object forKey:_key];
}

- (void)setObject:(id)_object forKey:(NSString *)_key useKeyedArchive:(BOOL)_useKeyedArchive {
    if(!_useKeyedArchive) {
        [self setObject:_object forKey:_key];
    } else {
        id newObject = [NSKeyedArchiver archivedDataWithRootObject:_object];
        [self setObject:newObject forKey:_key];
    }
}

- (void)removeObjectForKey:(NSString *)_key {
    [persistencyData removeObjectForKey:_key];
}

- (void)destroy {
    persistencyData = [[NSMutableDictionary alloc] init];
}

- (void)save {
    [NSUserDefaults resetStandardUserDefaults];
    [[NSUserDefaults standardUserDefaults] setObject:persistencyData forKey:@"persistencyData"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDate alloc] init] forKey:@"updatedAt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
