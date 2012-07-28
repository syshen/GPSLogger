//
//  SYAnnotationView.m
//  GPSLogger
//
//  Created by Shen Steven on 7/28/12.
//  Copyright (c) 2012 Waveface Inc. All rights reserved.
//

#import "SYAnnotationView.h"

@implementation SYAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"pin.png"];
        self.canShowCallout = YES;
        self.opaque = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
