//
//  SetUserOutsideRadiusReminderViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/29/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "SetUserOutsideRadiusReminderViewController.h"

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
    monitoringRegion.notifyOnEntry = YES;
    
    [self.locationManager startMonitoringForRegion:monitoringRegion];
}

- (void)saveReminder {
    
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
    
    [self startMonitoringRegion];
}

- (IBAction)saveAction:(id)sender {
    
    [self saveReminder];
}

- (IBAction)cancelAction:(id)sender {
    
    // Return to map view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
