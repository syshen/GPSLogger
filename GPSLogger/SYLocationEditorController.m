//
//  SYLocationSelectionViewController.m
//  GPSLogger
//
//  Created by Steven Shen on 7/22/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYLocationEditorController.h"
#import <MapKit/MapKit.h>
#import "SYListTabViewController.h"

@interface SYLocationEditorController ()

@property (strong, nonatomic) NSMutableArray *placeNames;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicatorView;

@end

@implementation SYLocationEditorController
@synthesize mapView = _mapView;
@synthesize tableView = _tableView;
@synthesize actIndicatorView = _actIndicatorView;
@synthesize latitude = _latitude, longtitude = _longtitude;
@synthesize placeNames = _placeNames;

static NSString *kGoogleAPIKey = @"AIzaSyBhIVUcucpsBPyHvJYu-e29Pewpj953dWM";

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
    _placeNames = [NSMutableArray new];
    [super viewDidLoad];
    [self setLocationCenter:self.latitude andWithLongtitude:self.longtitude];
    [self searchGooglePlace];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
}

- (void)searchGooglePlace
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=100&sensor=true&key=%@", [self.latitude doubleValue], [self.longtitude doubleValue], kGoogleAPIKey];
    NSURL *requestUrl = [NSURL URLWithString:url];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSData *data = [NSData dataWithContentsOfURL:requestUrl];
        [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchData:(NSData *)responseData
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if(json == nil) {
        NSLog(@"failed to parse response in json: %@", error);
        return;
    }
    
    
    NSArray *places = [json objectForKey:@"results"];
    for (NSDictionary *place in places) {
        [self.placeNames addObject:[place objectForKey:@"name"]];
    }
    
    [self.actIndicatorView setHidden:YES];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.placeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PlaceNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.placeNames objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [self.placeNames objectAtIndex:[indexPath row]];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longtitude doubleValue]];
    SYListTabViewController *mainVC;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SYListTabViewController class]]) {
            mainVC = (SYListTabViewController *)vc;
            break;
        }
    }
        
    [mainVC performSelector:@selector(addANewLocation:withName:) withObject:loc withObject:name];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
