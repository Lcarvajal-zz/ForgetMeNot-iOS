//
//  SetUserOutsideRadiusReminderViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/29/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "SetUserOutsideRadiusReminderViewController.h"
#import <Parse/Parse.h>

@interface SetUserOutsideRadiusReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *destinationName;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;

- (IBAction)saveAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@end

@implementation SetUserOutsideRadiusReminderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set text field delegates.
    self.titleTF.delegate = self;
    self.notesTF.delegate = self;
    
    // Assign first responder.
    [self.titleTF becomeFirstResponder];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Get tag of next text field.
    NSInteger nextTag = textField.tag + 1;
    
    // Get next text field.
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    
    if(nextResponder) {
        
        // Next text field exists, user now edits next text field.
        [nextResponder becomeFirstResponder];
    }
    else {
        
        // No next text field exists, dismiss keyboard and save reminder.
        [textField resignFirstResponder];
        
        // Save reminder.
        [self saveAction:nil];
    }
    
    return NO;
}

#pragma mark - Set Reminder

- (void)startMonitoringRegion {
    
    // Monitors the region created.
    CLCircularRegion *monitoringRegion = [[CLCircularRegion alloc] initWithCenter:self.center radius:self.radius identifier:self.pinUUID];
    
    // Set when notification is triggered.
    monitoringRegion.notifyOnExit = NO;
    monitoringRegion.notifyOnEntry = YES;
    
    [self.locationManager startMonitoringForRegion:monitoringRegion];
}

#pragma mark - SetReminderViewControllerDelegate
- (void)didSavePinInformationForUUID:(NSString *)pinUUID {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(id)sender {
    
    // When button clicked save values in details, and title
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Our dictionary key is the UUID with the title/details being values
    NSDictionary *tempDictionary = @{
                                     self.pinUUID : @{
                                             @"title" : self.titleTF.text,
                                             @"notes" : self.notesTF.text,
                                             @"isExpired" : @NO }
                                     };
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:tempDictionary];
    [dictionary addEntriesFromDictionary:[defaults objectForKey:@"PinValues"]];
    [defaults setObject:dictionary forKey:@"PinValues"];
    [defaults synchronize];
    
    // Store location so that it can be used again in the future.
    if ([self.destinationName.text length] != 0) {
        
        PFObject *location = [PFObject objectWithClassName:@"Location"];
        [location setObject:[PFUser currentUser] forKey:@"createdBy"];
        [location setObject:self.destinationName.text forKey:@"name"];
        [location setObject:[NSNumber numberWithDouble:self.destinationLongitude] forKey:@"longitude"];
        [location setObject:[NSNumber numberWithDouble:self.destinationLatitude] forKey:@"latitude"];
        [location saveInBackground];
    }
    
    // Start monitoring region on save
    [self startMonitoringRegion];
    
    // Dismiss view
    [self didSavePinInformationForUUID:self.pinUUID];
    
    // Return to map view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)cancelAction:(id)sender {
    
    // Return to map view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end