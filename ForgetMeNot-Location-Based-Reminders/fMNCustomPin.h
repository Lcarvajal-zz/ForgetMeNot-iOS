//
//  fMNCustomPin.h
//  ForgetMeNot_map
//
//  Created by iOS Developer on 7/27/15.
//  Copyright (c) 2015 iOS Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface fMNCustomPin : NSObject <MKAnnotation>{
    double radius;
    CLLocationCoordinate2D coordinate;
}

@property double radius;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;


@end