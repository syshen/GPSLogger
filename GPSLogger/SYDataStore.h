//
//  SYDataStore.h
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SYDataStore : NSObject

+ (SYDataStore*) defaultStore;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
