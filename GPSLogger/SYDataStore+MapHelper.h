//
//  SYDataStore+MapHelper.h
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYDataStore.h"
#import "Locations.h"
#import <CoreLocation/CoreLocation.h>

@interface SYDataStore (MapHelper)

- (Locations*) latestRecordedLocation;
- (NSArray *) locationsWithinRegion:(CLLocationCoordinate2D) topLeft withBottomRight:(CLLocationCoordinate2D) bottomRight;

@end
