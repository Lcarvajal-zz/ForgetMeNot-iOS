//
//  MapViewController.h
//  ForgetMeNot_map
//
//  Created by iOS Developer on 7/16/15.
//  Copyright (c) 2015 iOS Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate,MKAnnotation,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property bool userInRadius;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentLocationButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removePinButton;

- (IBAction)currentLocationAction:(id)sender;
- (IBAction)removePinAction:(id)sender;
@end
