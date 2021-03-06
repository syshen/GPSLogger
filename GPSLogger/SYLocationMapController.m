//
//  SYMapViewController.m
//  GPSLogger
//
//  Created by Steven Shen on 7/22/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYLocationMapController.h"
#import <MapKit/MapKit.h>
#import "SYAnnotation.h"
#import "SYAnnotationView.h"

@interface SYLocationMapController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SYLocationMapController
@synthesize mapView = _mapView;
@synthesize latitude = _latitude;
@synthesize longtitude = _longtitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setLocationCenter:(NSNumber *)latitude andWithLongtitude:(NSNumber *)longtitude
{
    MKCoordinateRegion region;
    region.center.latitude = [latitude doubleValue];
    region.center.longitude = [longtitude doubleValue];
    MKCoordinateSpan span;
    span.latitudeDelta = .002;
    span.longitudeDelta = .002;
    region.span = span;
    [self.mapView setRegion:region];
    
    CLLocationCoordinate2D coord;
    coord.latitude = [latitude doubleValue];
    coord.longitude = [longtitude doubleValue];
    [self dropAnnotation:coord];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"annotationIdentifier";
    SYAnnotationView *newView = (SYAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (newView == nil) {
        newView = [[SYAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        newView.annotation = annotation;
    }
    
    return newView;
}

- (void) dropAnnotation:(CLLocationCoordinate2D)coord
{
    SYAnnotation *ann = [[SYAnnotation alloc] initWithCoordinate:coord];
    [self.mapView addAnnotation:ann];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLocationCenter:self.latitude andWithLongtitude:self.longtitude];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
