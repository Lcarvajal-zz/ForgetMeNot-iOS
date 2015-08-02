//
//  SetUserInRadiusReminderViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lauren Koulias on 7/29/15.
//  Copyright (c) 2015 Lauren Koulias. All rights reserved.
//

#import "SetUserInRadiusReminderViewController.h"

@interface SetUserInRadiusReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;

- (IBAction)saveAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@end

@implementation SetUserInRadiusReminderViewController

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
        [self saveReminder];
    }
    
    return NO;
}

#pragma mark - Set Reminder

- (void)startMonitoringRegion {
    
    // Monitors the region created.
    CLCircularRegion *monitoringRegion = [[CLCircularRegion alloc] initWithCenter:self.center radius:self.radius identifier:self.pinUUID];
    
    // Set when notification is triggered.
    monitoringRegion.notifyOnExit = YES;
    monitoringRegion.notifyOnExit = NO;
    
    [self.locationManager startMonitoringForRegion:monitoringRegion];
}

- (void)saveReminder {
    
    if (self.notificationType.selectedSegmentIndex == 0) {
        
        
        // Store reminder title and notes.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // Dictionary for title and notes.
        NSDictionary *tempDictionary = @{
                                         self.pinUUID : @{
                                                 @"title" : self.titleTF.text,
                                                 @"notes" : self.notesTF.text}
                                         };
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:tempDictionary];
        [dictionary addEntriesFromDictionary:[defaults objectForKey:@"PinValues"]];
        [defaults setObject:dictionary forKey:@"PinValues"];
        [defaults synchronize];
         
        
        // Start monitoring region on save.
        [self startMonitoringRegion];
        
    }
    else {
        // Notify user this is not working.
        // Alert user that sign up did not work. Show error message.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"This feature does not work yet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
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
                                             @"notes" : self.notesTF.text}
                                     };
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:tempDictionary];
    [dictionary addEntriesFromDictionary:[defaults objectForKey:@"PinValues"]];
    [defaults setObject:dictionary forKey:@"PinValues"];
    [defaults synchronize];
    
    NSLog(@"save");
    
    // Start monitoring region on save
    [self startMonitoringRegion];
    
    // Dismiss view
    [self didSavePinInformationForUUID:self.pinUUID];
}

- (IBAction)cancelAction:(id)sender {
    
    // Return to map view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
