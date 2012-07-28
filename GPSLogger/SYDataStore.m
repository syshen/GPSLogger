//
//  SYDataStore.m
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYDataStore.h"


@interface SYDataStore ()

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistenStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end

@implementation SYDataStore
@synthesize persistenStoreCoordinator = _persistenStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize context = _context;

+ (SYDataStore *)defaultStore {
    static SYDataStore *store = nil;
    if (store != nil)
        return store;
    
    store = [[self alloc] init];

    NSPersistentStoreCoordinator *coord = [store persistenStoreCoordinator];
    if (coord != nil) {
        store.context = [[NSManagedObjectContext alloc] init];
        [store.context setPersistentStoreCoordinator:coord];
    }

    return store;
}

- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GPSLogger" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistenStoreCoordinator
{
    if (_persistenStoreCoordinator != nil)
        return _persistenStoreCoordinator;
    
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"gps_events.sqlite"];
    
    NSError *error = nil;
    _persistenStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistenStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Unresolved error: %@ %@", error, [error userInfo]);
        abort();
    }
    return _persistenStoreCoordinator;
}

#pragma mark - Application Document Directory
- (NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
