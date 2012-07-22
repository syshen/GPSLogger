//
//  SYViewController.m
//  GPSLogger
//
//  Created by Steven Shen on 7/21/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYViewController.h"
#import "Locations.h"

@interface SYViewController ()

@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SYViewController
@synthesize managedObjectContext;
@synthesize eventsArray = _eventsArray;
@synthesize locationManager = _locationManager;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.enabled = NO;
        
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"failed to perform data store fetch due to error: %@", error);
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma makr - UITableViewControllerDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    static NSNumberFormatter *numFormatter = nil;
    if (numFormatter == nil) {
        numFormatter = [[NSNumberFormatter alloc] init];
        numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numFormatter.maximumFractionDigits = 3;
    }
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
  
    Locations *loc = (Locations*)[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [dateFormatter stringFromDate:loc.creationDate];
    NSString *string = [NSString stringWithFormat:@"%@, %@", [numFormatter stringFromNumber:[loc latitude]], [numFormatter stringFromNumber:[loc longtitude]]];

    cell.detailTextLabel.text = string;
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)addButtonPressed:(id)sender
{
    CLLocation *location = [self.locationManager location];
    if (location == nil)
        return;
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];

    NSManagedObjectContext *objContext = [_fetchedResultsController managedObjectContext];
    
    Locations *newLoc = (Locations*)[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:objContext];
    
    CLLocationCoordinate2D coord = [location coordinate];
    [newLoc setLatitude:[NSNumber numberWithDouble:coord.latitude]];
    [newLoc setLongtitude:[NSNumber numberWithDouble:coord.longitude]];
    [newLoc setCreationDate:[NSDate date]];
    
    NSError *error = nil;
    
    if (![objContext save:&error]) {
        NSLog(@"failed to save a new location: %@, %@", error, [error userInfo]);
    }    
}

#pragma mark - FetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController 
{
    if (_fetchedResultsController != nil)
        return _fetchedResultsController;
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDiscriptors = [NSArray arrayWithObjects:sort, nil];
    [request setSortDescriptors:sortDiscriptors];

    [request setFetchBatchSize:10];

    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Locations"];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Location Manager
- (CLLocationManager*)locationManager
{
    if (_locationManager != nil)
        return _locationManager;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.delegate = self;

    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
@end
