//
//  SYViewController.h
//  GPSLogger
//
//  Created by Steven Shen on 7/21/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface SYListTabViewController : UITableViewController <CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

- (void)addANewLocation:(CLLocation*)location withName:(NSString *)name;

@end
