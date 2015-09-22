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
    
    // Initialize Picker View Data.
    NSMutableArray *myIntegers1 = [[NSMutableArray alloc] initWithCapacity:0];
    
    [myIntegers1 addObject:@"hour"];
    
    for (NSInteger i = 0; i < 24; i++){
        [myIntegers1 addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    
    self.arrayHours = [[NSMutableArray alloc] initWithArray:myIntegers1];
    
    NSMutableArray *myIntegers2 = [[NSMutableArray alloc] initWithCapacity:0];
    
    [myIntegers2 addObject:@"minute"];
    
    for (NSInteger i = 0; i < 60; i++){
        [myIntegers2 addObject:[NSString stringWithFormat: @"%ld", i]];
    }
    
    self.arrayMins = [[NSMutableArray alloc] initWithArray:myIntegers2];
    
    // Connect data.
    self.doublePicker.dataSource = self;
    self.doublePicker.delegate = self;
    
    // Monitor segmented control changing.
    self.doublePicker.hidden = YES;
    [self.notificationType addTarget:self
                              action:@selector(notificationTypeChanged)
                    forControlEvents:UIControlEventValueChanged];
    
    // Set initial picker values.
    [self.doublePicker selectRow:1 inComponent:0 animated:YES];
    [self.doublePicker selectRow:1 inComponent:1 animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segmented Control

- (void)notificationTypeChanged {
    switch (self.notificationType.selectedSegmentIndex) {
        case 0:
            self.doublePicker.hidden = YES;
            break;
        case 1:
            self.doublePicker.hidden = NO;
            break;
    }
}

#pragma mark - Picker View

// Number of columns of data.
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// Number of rows of data.
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.arrayHours count];
    }
    
    else
    {
        return [self.arrayMins count];
    }
    
}

// Retrieve selected item from pickerView.
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.arrayHours objectAtIndex:row];
    }
    
    else
    {
        return [self.arrayMins objectAtIndex:row];
    }
}

// Capture the picker view selection.
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSLog(@"Selected Element: %@", [self.arrayHours objectAtIndex: row]);
        self.column1 = [self.arrayHours objectAtIndex: row];
        
        if (row == 0) {
            [self.doublePicker selectRow:1 inComponent:0 animated:YES];
        }
    }
    
    else
    {
        NSLog(@"Selected Element: %@", [self.arrayMins objectAtIndex: row]);
        self.column2 = [self.arrayMins objectAtIndex: row];
        
        if (row == 0) {
            [self.doublePicker selectRow:1 inComponent:1 animated:YES];
        }
    }
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
    monitoringRegion.notifyOnExit = YES;
    monitoringRegion.notifyOnEntry = NO;
    
    [self.locationManager startMonitoringForRegion:monitoringRegion];
}

#pragma mark - SetReminderViewControllerDelegate
- (void)didSavePinInformationForUUID:(NSString *)pinUUID {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(id)sender {
    
    // When button clicked save values in details, and title.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Our dictionary key is the UUID with the title/details being values.
    NSDictionary *tempDictionary = @{
                                     self.pinUUID : @{
                                             @"title" : self.titleTF.text,
                                             @"notes" : self.notesTF.text,
                                             @"type" : @(self.notificationType.selectedSegmentIndex),
                                             @"isExpired" : @NO }
                                     };
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:tempDictionary];
    [dictionary addEntriesFromDictionary:[defaults objectForKey:@"PinValues"]];
    [defaults setObject:dictionary forKey:@"PinValues"];
    [defaults synchronize];
    
    if(self.notificationType.selectedSegmentIndex == 1) {
        [self createLeaveNotificationWithPinId:self.pinUUID];
    }
    
    
    // Start monitoring region on save.
    [self startMonitoringRegion];
    
    // Dismiss view.
    [self didSavePinInformationForUUID:self.pinUUID];
    
    // Return to map view.
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)createLeaveNotificationWithPinId:(NSString *)pinId {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // Get the hours and minutes to add to the fireDate for the notification.
    
    NSTimeInterval secondsUntilNotificationFires = ([self.column1 doubleValue] * 3600.00) + ([self.column2 doubleValue] * 60.00);
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:secondsUntilNotificationFires];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"%@ - %@",
                                   self.titleTF.text,
                                   self.notesTF.text
                                   ];
    localNotification.userInfo = [NSDictionary dictionaryWithObject:self.pinUUID forKey:@"pinId"];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber += 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (IBAction)cancelAction:(id)sender {
    
    // Return to map view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
