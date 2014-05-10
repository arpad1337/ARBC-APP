//
//  StorageManager.h
//  Jestr
//
//  Created by Árpád Kiss on 2014.04.30..
//  Copyright (c) 2014 Peabo Media LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData+MagicalRecord.h"

@interface StorageManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(StorageManager *) sharedManager;
- (void)setUpCDStack;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
