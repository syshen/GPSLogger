//
//  SYMapTabViewController.m
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYMapTabViewController.h"
#import "Locations.h"
#import "SYDataStore.h"
#import "SYDataStore+MapHelper.h"
#import "SYAnnotation.h"
#import "SYAnnotationView.h"

@interface SYMapTabViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Locations *firstLocation;

@end

@implementation SYMapTabViewController
@synthesize mapView = _mapView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize firstLocation = _firstLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.firstLocation != nil) {
        MKCoordinateRegion region;
        region.center.latitude = [self.firstLocation.latitude doubleValue];
        region.center.longitude = [self.firstLocation.longtitude doubleValue];
        MKCoordinateSpan span;
        span.latitudeDelta = .04;
        span.longitudeDelta = .04;
        region.span = span;
        [self.mapView setRegion:region];
        
        
        [self dropAnnotationsWithinRegion:region];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (Locations *)firstLocation
{
    return [[SYDataStore defaultStore] firstLocation];
}

- (void) dropAnnotations:(NSArray*)locations
{
    if (locations == nil) return;
    
    NSMutableArray *anns = [[NSMutableArray alloc] init];
    
    for (Locations *location in locations) {
        CLLocationCoordinate2D coord;
        coord.latitude = [location.latitude doubleValue];
        coord.longitude = [location.longtitude doubleValue];

        SYAnnotation *ann = [[SYAnnotation alloc] initWithCoordinate:coord];
        ann.title = location.name;
        ann.creationDate = location.creationDate;
        [anns addObject:ann];
    }
    
    [self.mapView addAnnotations:anns];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSManagedObjectContext *) managedObjectContext
{
    return [[SYDataStore defaultStore] context];
}

- (void) dropAnnotationsWithinRegion:(MKCoordinateRegion) region
{
    CLLocationCoordinate2D topLeft, bottomRight;
    topLeft.latitude  = region.center.latitude  + (region.span.latitudeDelta  / 2.0);
    topLeft.longitude = region.center.longitude - (region.span.longitudeDelta / 2.0);
    bottomRight.latitude  = region.center.latitude  - (region.span.latitudeDelta  / 2.0);
    bottomRight.longitude = region.center.longitude + (region.span.longitudeDelta / 2.0);
    
    NSArray *array = [[SYDataStore defaultStore] locationsWithinRegion:topLeft withBottomRight:bottomRight];
    [self dropAnnotations:array];
}


#pragma mark - MKMapView delegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self dropAnnotationsWithinRegion:mapView.region];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self dropAnnotationsWithinRegion:mapView.region];    
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

@end
