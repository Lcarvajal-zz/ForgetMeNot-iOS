//
//  ViewController.m
//  ForgetMeNot_map
//
//  Created by Tyler Hunnefeld on 7/16/15.
//  Copyright (c) 2015 iOS Test. All rights reserved.
//

#import "MapViewController.h"

#pragma mark -
#pragma mark Defines
#define METERS_MILE 1609.344
#define METERS_FEET 3.28084

#pragma mark -
#pragma mark Interface

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate,MKAnnotation,UISearchBarDelegate>
{
    CLPlacemark *placemark;
    double centerx,centery,cirRadius;
    //CLGeocoder *geoCoder;
    //MKCircleRenderer *circleRenderer;
}
@end

@implementation MapViewController
@synthesize locationManager;
@synthesize mapView;
@synthesize coordinate;



#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Shoe navigation bar.
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    

    
    //Set Up mapView
    self.mapView.delegate = self;
    
    //Set up searchBar
    //self.searchBar.delegate = self;
    
    
    //Add gesture implementation
    //Once the view is tapped once the gesture is disabled
    UITapGestureRecognizer *tpgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchMap:)];
    tpgr.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:tpgr];
    
    /*
    //only exists to allow the doubletap to execute without placing a pin
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [tpgr requireGestureRecognizerToFail:doubleTap];
     */
    
    
    //Once the tap is done sets the pan gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRadius:)];
    [self.mapView addGestureRecognizer:panGesture];
    
    
    //*****Used for storing location******
    //Set up location manager
    locationManager = [[CLLocationManager alloc] init];
    [[self locationManager] setDelegate:self];
    
    //ask for permission
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

#pragma mark -
#pragma mark CLLocationManagerDelegate


//If an error with reading location is detected
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Location lookup failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



#pragma mark -
#pragma mark MKMapView Delegate Functions


//Upon user location update zooms the map to 1 miles out
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, METERS_MILE, METERS_MILE);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
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

//will be used later
- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view {
    printf("control passed to didSelectAnnotationView. \n");
    
}

/*-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
 id <MKAnnotation> annotation = [view annotation];
 if ([annotation isKindOfClass:[MKPointAnnotation class]])
 {
 NSLog(@"Clicked");
 }
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
 [alertView show];
 }*/

#pragma mark -
#pragma mark MKOverlayView


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    [circleRenderer setFillColor:[UIColor colorWithRed:0.0/255.0f green:153.0/255.0f blue:255.0/255.0f alpha:0.2f]];
    return circleRenderer;
}



#pragma mark -
#pragma mark GestureRecognizer

//Only here to ensure that the mapkit doubletaps will be prioritized over the single taps
- (void)doDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{}


- (void)didTouchMap:(UITapGestureRecognizer *)gestureRecognizer
{
    
    //Get touched points for map annotation placement
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    //stores coordinates, prints location to console,adds annotation
    NSLog(@"%.1f,%.1f",touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    
    //Disables Tap gestureRecognizer
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    centerx=annot.coordinate.longitude;
    centery=annot.coordinate.latitude;
    [self.mapView addAnnotation:annot];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annot.coordinate, 100, 100);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    //disables the scroll so the pan takes priority
    //if
    self.mapView.scrollEnabled = NO;
    gestureRecognizer.enabled=NO;
    
}

//Allows gesture recognizers to be used from source code and from mapkit
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//performs the functions for panning
- (void)panRadius:(UIPanGestureRecognizer *)panGesture
{
    CGPoint radPoint = [panGesture locationInView:self.mapView];
    CLLocationCoordinate2D radMapCoordinate =
    [self.mapView convertPoint:radPoint toCoordinateFromView:self.mapView];
    
    //place where touch ended
    CLLocation *loc1= [[CLLocation alloc] initWithLatitude:(radMapCoordinate.latitude) longitude:radMapCoordinate.longitude];
    
    //store pin center location
    CLLocationCoordinate2D center;
    center.longitude=centerx;
    center.latitude=centery;
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:centery longitude:centerx];
    
    //Calculate distance between the two
    CLLocationDistance dist = [loc1 distanceFromLocation:loc2];
    cirRadius=dist;
    MKCircle* circle = [MKCircle circleWithCenterCoordinate:center radius:cirRadius];
    if (mapView.overlays.count > 0) {
        //WILL DELETE ALL OVERLAYS ON MAP. Could be alright if I'm only displaying a temp annot
        [mapView removeOverlays:mapView.overlays];
    }
    [self.mapView addOverlay:circle];
    //NSLog(@"Radius is: %.3f", cirRadius);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, cirRadius*10, cirRadius*10);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    if(panGesture.state == UIGestureRecognizerStateEnded){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Pin Details:"
                                                                       message:[NSString stringWithFormat:@"Center Longitude: %.2f, Center Latitude: %.2f, Center Radius: %.2f", centerx, centery, cirRadius]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        MKCircle* finalCircle = [MKCircle circleWithCenterCoordinate:center radius:cirRadius];
        [self.mapView addOverlay:finalCircle];
        self.mapView.scrollEnabled = YES;
    }
    
}

#pragma mark -
#pragma mark SearchBar Delegate Functions

/*- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
 
 {
 [self.searchBar setShowsCancelButton:NO animated:YES];
 [self.searchBar resignFirstResponder];
 }
 
 
 
 - (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
 
 {
 [self.searchBar setShowsCancelButton:YES animated:YES];
 }
 
 
 
 - (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
 
 {
 [self.searchBar setShowsCancelButton:NO animated:YES];
 }
 
 -(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
 {
 
 MKLocalSearchRequest *localSearchReq = [[MKLocalSearchRequest alloc] init];
 localSearchReq.naturalLanguageQuery = self.searchBar.text;
 MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchReq];
 [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
 {
 
 NSMutableArray *placemarks = [NSMutableArray array];
 
 for (MKMapItem *item in response.mapItems) {
 
 [placemarks addObject:item.placemark];
 
 }
 
 [self.mapView removeAnnotations:[self.mapView annotations]];
 
 [self.mapView showAnnotations:placemarks animated:YES];
 
 }];
 }*/




#pragma mark -
#pragma mark Segue (commented out)

/*
 
 //uncomment at completion, once this is being passed to
 
 
 //SAMPLE CODE. NEEDS TO BE UPDATED FOR VARIABLE NAMES ETC.
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Make sure your segue name in storyboard is the same as this line
 if ([[segue identifier] isEqualToString:@"YOUR_SEGUE_NAME_HERE"])
 {
 // Get reference to the destination view controller
 YourViewController *vc = [segue destinationViewController];
 
 // Pass any objects to the view controller here, like...
 [vc setMyObjectHere:object];
 }
 }
 */


@end
