//
//  AldDataCore.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 03/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AldDataCore.h"

@interface AldDataCore ()

@end

@implementation AldDataCore

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(AldDataCore *) defaultCore
{
    static AldDataCore *instance = nil;
    if (instance == nil) {
        instance = [[AldDataCore alloc] initWithName:@"DataCore"];
    }
    
    return instance;
}

-(id) initWithName: (NSString *)dataSourceName
{
    self = [super init];
    if (self) {
        [self createManagedObjectModel:dataSourceName];
        [self createPersistentStoreCoordinator:dataSourceName];
        [self createManagedObjectContext];
    }
    
    return self;
}

-(void) dealloc
{
    [self saveChanges];
}

-(void) saveChanges
{
    NSError *error = nil;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"AldDataCore: failed to save %@, %@", error, [error userInfo]);
        }
    }
}

-(void) createManagedObjectModel: (NSString *)dataSourceName
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:dataSourceName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

-(void) createPersistentStoreCoordinator: (NSString *)dataSourceName
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", dataSourceName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        

        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void) createManagedObjectContext
{
    if (_persistentStoreCoordinator == nil) {
        [NSException raise:@"Can't create a managed object context." format:@"There is no persistent store coordinator."];
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
}

-(NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
