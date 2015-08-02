//
//  ViewController.m
//  ForgetMeNot_map
//
//  Created by Tyler Hunnefeld on 7/16/15.
//  Copyright (c) 2015 iOS Test. All rights reserved.
//

#import "MapViewController.h"
#import "SetUserInRadiusReminderViewController.h"
#import "SetUserOutsideRadiusReminderViewController.h"

#pragma mark -
#pragma mark Defines
#define METERS_MILE 1609.344
#define METERS_FEET 3.28084

#pragma mark -
#pragma mark Interface

@interface MapViewController () 
{
    CLPlacemark *placemark;                 // Pin.
    double centerx,centery,cirRadius;       // Info about annotation.
    double userX,userY;
    MKCoordinateRegion region;              // Stores user location for map view changes.
    NSMutableArray *overlayArray;                  // Keeps track of overlays for deletion etc.
    bool annotationIsSelected, moveToUserLocation;
}
@end

@implementation MapViewController
@synthesize locationManager;
@synthesize mapView;
@synthesize coordinate;
@synthesize userInRadius;

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    
    // Show navigation bar.
    self.navigationController.navigationBarHidden = NO;
    
    // Show toolbar.
    self.navigationController.toolbarHidden = NO;
    
    // Hide back button.
    self.navigationItem.hidesBackButton = YES;
    
    // Reset.
    [self resetGestures];
    [self removeAllPinsButUserLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Up mapView.
    self.mapView.delegate = self;
    
    //*****Used for storing location******
    //Set up location manager
    locationManager = [[CLLocationManager alloc] init];
    [[self locationManager] setDelegate:self];
    
    // Ask for permission.
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    [[self mapView] setShowsUserLocation:YES];
    
    
    //****Standard Location Service used to check if it all works****
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate


// If an error with reading location is detected.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Location lookup failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

#pragma mark - MKMapView Delegate Functions

// Upon user location update zooms the map to 1 miles out.
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, METERS_MILE/3, METERS_MILE/3);
    
    // Stores user location for use in other areas of program.
    userX = userLocation.coordinate.longitude;
    userY = userLocation.coordinate.latitude;
    
    // Centers on the user location.
    if(region.center.longitude == -180.00000000){
        NSLog(@"Invalid region!");
    }else if(moveToUserLocation){
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        moveToUserLocation=NO;
        MKCircle* userLocationCircle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:100];
        [self.mapView addOverlay:userLocationCircle];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)pin_mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[pin_mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            //If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

#pragma mark - MKOverlayView


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    // Use ForgetMeNot theme color for radius graphic.
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    [circleRenderer setFillColor:[UIColor colorWithRed:0.0/255.0f green:153.0/255.0f blue:255.0/255.0f alpha:0.2f]];
    return circleRenderer;
}

#pragma mark - GestureRecognizer

- (void)resetGestures {
    
    // Remove all gestures.
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
    
    // Add gesture implementation.
    // Once the view is tapped once the gesture is disabled.
    UITapGestureRecognizer *tpgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchMap:)];
    tpgr.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:tpgr];
    
    // Once the tap is done sets the pan gesture.
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRadius:)];
    [self.mapView addGestureRecognizer:panGesture];
}

// Doubletaps will be prioritized over single taps.
- (void)doDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{}


- (void)didTouchMap:(UITapGestureRecognizer *)gestureRecognizer
{
    
    // Get touched points for map annotation placement.
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    
    // Creates new pin named "New Pin".
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    centerx=annot.coordinate.longitude;
    centery=annot.coordinate.latitude;
    annot.title=@"New Pin";
    [self.mapView addAnnotation:annot];
    
    // Gets distance of touch from user.
    CLLocation *touchLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:userY longitude:userX];
    CLLocationDistance distanceMeters = [touchLocation distanceFromLocation:userLocation];
    
    // If the distance is within the circle sets bool for later use.
    if (distanceMeters<=100) {
        userInRadius = YES;
        printf("Pin is within 100m of user!\n");
    }
    else {
        userInRadius = NO;
        printf("Pin NOT within 100m of user");
    }
    
    // Zooms on the pin placement location.
    MKCoordinateRegion pinRegion = MKCoordinateRegionMakeWithDistance(annot.coordinate, 100, 100);
    [self.mapView setRegion:[self.mapView regionThatFits:pinRegion] animated:YES];
    
    // Initializes a placeholder circle around the point with radius 100m.
    cirRadius=100;
    MKCircle* circle = [MKCircle circleWithCenterCoordinate:annot.coordinate radius:cirRadius];
    [self.mapView addOverlay:circle];
    
    // Disables the scroll so the pan takes priority.
    // Disables buttons so as not to disrupt flow.
    self.mapView.scrollEnabled = NO;
    gestureRecognizer.enabled=NO;
    self.removePinButton.enabled = YES;
    self.currentLocationButton.enabled = NO;
}

// Allows gesture recognizers to be used from source code and from mapkit.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

// Performs the functions for panning.
- (void)panRadius:(UIPanGestureRecognizer *)panGesture
{
    CGPoint radPoint = [panGesture locationInView:self.mapView];
    CLLocationCoordinate2D radMapCoordinate =
    [self.mapView convertPoint:radPoint toCoordinateFromView:self.mapView];
    
    // Place where touch ended.
    CLLocation *loc1= [[CLLocation alloc] initWithLatitude:(radMapCoordinate.latitude) longitude:radMapCoordinate.longitude];
    
    // Store pin center location.
    CLLocationCoordinate2D center;
    center.longitude=centerx;
    center.latitude=centery;
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:centery longitude:centerx];
    
    // Calculate distance between the two.
    CLLocationDistance dist = [loc1 distanceFromLocation:loc2];
    if (dist>20)
        cirRadius=dist;
    else
        cirRadius=20;
    MKCircle* circle = [MKCircle circleWithCenterCoordinate:center radius:cirRadius];
    
    // Redraw circle
    NSArray *pointsArray = [[NSArray alloc] initWithObjects:self.mapView.overlays.lastObject, nil];
    [mapView removeOverlays:pointsArray];
    [self.mapView addOverlay:circle];
    
    // Pin region.
    MKCoordinateRegion pinRegion = MKCoordinateRegionMakeWithDistance(center, cirRadius*10, cirRadius*10);
    [self.mapView setRegion:[self.mapView regionThatFits:pinRegion] animated:YES];
    
    if(panGesture.state == UIGestureRecognizerStateEnded){
        
        // Perform appropriate segue based on radius and user location.
        if (self.userInRadius) {
            
            // User is located in radius.
            [self performSegueWithIdentifier:@"userInRadiusReminder" sender:self];
        }
        else {
            
            [self performSegueWithIdentifier:@"userOutsideRadiusReminder" sender:self];
        }
    }
}

#pragma mark - Toolbar Actions

- (IBAction)currentLocationAction:(id)sender {
    
    if(region.center.longitude == -180.00000000){
        NSLog(@"Invalid region!");
    }else{
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    }
}

- (IBAction)removePinAction:(id)sender {
    
    // Reset all gestures and remove any current graphics created by user.
    [self resetGestures];
    [self removeAllPinsButUserLocation];
}

- (void)removeAllPinsButUserLocation
{
    
    // Remove pin.
    [mapView removeAnnotations:[mapView annotations]];
    
    // Enable correct buttons.
    self.currentLocationButton.enabled = YES;
    self.removePinButton.enabled = NO;
    
    // Remove radius graphic.
    NSArray *pointsArray = [self.mapView overlays];
    [self.mapView removeOverlays:pointsArray];
    
    // Map scroll is reenabled after being disabled by pan gesture.
    self.mapView.scrollEnabled = YES;
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     // Set current user locarion.
     CLLocationCoordinate2D center;
     center.longitude=centerx;
     center.latitude=centery;
     
     NSString *monitoringUUID = [[NSUUID UUID] UUIDString];

     // Set reminder radius and user location for next view controller.
     if ([segue.identifier isEqualToString:@"userInRadiusReminder"]) {
         
         SetUserInRadiusReminderViewController *vc = [[SetUserInRadiusReminderViewController alloc] init];
         vc.pinUUID = monitoringUUID;
         vc.radius = cirRadius;
         vc.center = center;
     }
     else if ([segue.identifier isEqualToString:@"userOutsideRadiusReminder"]) {
         
         SetUserOutsideRadiusReminderViewController *vc = [[SetUserOutsideRadiusReminderViewController alloc] init];
         vc.pinUUID = monitoringUUID;
         vc.radius = cirRadius;
         vc.center = center;
     }
 }
@end
