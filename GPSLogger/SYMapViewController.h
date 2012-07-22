//
//  SYMapViewController.h
//  GPSLogger
//
//  Created by Steven Shen on 7/22/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMapViewController : UIViewController

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longtitude;

- (void)setLocationCenter:(NSNumber *)latitude andWithLongtitude:(NSNumber *)longtitude;

@end
