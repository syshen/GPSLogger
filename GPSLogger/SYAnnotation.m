//
//  SYAnnotation.m
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYAnnotation.h"

@implementation SYAnnotation
@synthesize title = _title;
//@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize creationDate = _creationDate;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self != nil) {
        _coordinate = coord;
    }
    return self;
}

- (NSString *) subtitle
{
    return [NSString stringWithFormat:@"%@ (%@)", [self getCoordinatorString], [self getCreationDateString]];
}

- (NSString *) getCreationDateString
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }

    return [dateFormatter stringFromDate:self.creationDate];
}

- (NSString *)getCoordinatorString
{
    static NSNumberFormatter *numFormatter = nil;
    if (numFormatter == nil) {
        numFormatter = [[NSNumberFormatter alloc] init];
        numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numFormatter.maximumFractionDigits = 3;
    }

    NSString *string = [NSString stringWithFormat:@"%@, %@", [numFormatter stringFromNumber:[NSNumber numberWithDouble:self.coordinate.latitude]], [numFormatter stringFromNumber:[NSNumber numberWithDouble:self.coordinate.longitude]]];
    return string;
}

@end
