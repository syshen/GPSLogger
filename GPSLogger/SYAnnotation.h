//
//  SYAnnotation.h
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface SYAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;
@property (nonatomic, strong) NSDate *creationDate;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (NSString *) getCreationDateString;
- (NSString *) getCoordinatorString;

@end
