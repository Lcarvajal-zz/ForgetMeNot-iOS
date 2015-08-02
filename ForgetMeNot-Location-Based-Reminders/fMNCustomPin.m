//
//  fMNCustomPin.m
//  ForgetMeNot_map
//
//  Created by iOS Developer on 7/27/15.
//  Copyright (c) 2015 iOS Test. All rights reserved.
//

#import "fMNCustomPin.h"

@interface fMNCustomPin () <MKAnnotation>
@end
@implementation fMNCustomPin
@synthesize radius, coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
        radius=20;
    }
    return self;
}


@end