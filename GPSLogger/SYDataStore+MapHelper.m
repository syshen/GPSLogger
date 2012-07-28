//
//  SYDataStore+MapHelper.m
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYDataStore+MapHelper.h"

@implementation SYDataStore (MapHelper)


- (Locations*) firstLocation
{
    Locations *_firstLocation = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Locations"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
    request.fetchBatchSize = 1;
    
    NSError *error = nil;
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    if (result == nil) {
        if (error != nil) {
            NSLog(@"Fail to fetch data: %@", error);
        }
        return nil;
    }
    
    _firstLocation = [result objectAtIndex:0];
    return _firstLocation;
}

- (NSArray *) locationsWithinRegion:(CLLocationCoordinate2D) topLeft withBottomRight:(CLLocationCoordinate2D) bottomRight
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Locations"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude < %f AND latitude > %f AND longtitude < %f AND longtitude > %f", topLeft.latitude, bottomRight.latitude, bottomRight.longitude, topLeft.longitude];
    request.predicate = predicate;
    request.fetchBatchSize = 100;
    
    NSError *error = nil;
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    if (result == nil) {
        if (error != nil)
            NSLog(@"Fail to fetch data: %@", error);
        return nil;
    }
        
    return result;
}

@end
