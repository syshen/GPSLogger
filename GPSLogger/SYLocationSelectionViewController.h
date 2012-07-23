//
//  SYLocationSelectionViewController.h
//  GPSLogger
//
//  Created by Steven Shen on 7/22/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYLocationSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longtitude;

@end
