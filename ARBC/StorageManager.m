//
//  StorageManager.m
//  Jestr
//
//  Created by Árpád Kiss on 2014.04.30..
//  Copyright (c) 2014 Peabo Media LLC. All rights reserved.
//

#import "StorageManager.h"

@implementation StorageManager

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)setUpCDStack {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"ARBC"];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [NSManagedObjectContext MR_defaultContext];
}

- (void)saveContext
{
    [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if(error){
            NSLog(@"Core data mentés hiba %@", error.localizedDescription);
        } else {
            NSLog(@"Core data mentés sikeres.");
        }
    }];
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


+(StorageManager *)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end
