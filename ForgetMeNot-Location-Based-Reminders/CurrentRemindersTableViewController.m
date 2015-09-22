//
//  CurrentRemindersTableViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/22/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "CurrentRemindersTableViewController.h"
#import <Parse/Parse.h>

@interface CurrentRemindersTableViewController ()

- (IBAction)logOutAction:(id)sender;
@property (nonatomic) NSMutableDictionary *pinValues;
@property (nonatomic) NSArray *pinKeyArray; // Stores the key of each pin in an array

@property NSUserDefaults *defaults;

@end

@implementation CurrentRemindersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadReminders];
}

#pragma mark - Reminders

- (void)loadReminders {
    
    _defaults = [NSUserDefaults standardUserDefaults];
    self.pinValues = [[self.defaults objectForKey:@"PinValues"] mutableCopy];
    self.pinKeyArray = [self.pinValues allKeys];
}

- (void)removeReminderAtIndex: (NSUInteger)index {
    
    // Remove reminder and save to NSUserDefaults.
    [self.pinValues removeObjectForKey:[self.pinKeyArray objectAtIndex:index]];
    [self.defaults setObject:self.pinValues forKey:@"PinValues"];
    [self.defaults synchronize];
    
    // Reset table data.
    self.pinValues = [[self.defaults objectForKey:@"PinValues"] mutableCopy];
    self.pinKeyArray = [self.pinValues allKeys];
    
    // Show reminders without removed reminder.
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.pinKeyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"CurrentReminderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    // Set reminder title of cell.
    UILabel *reminderTitle = (UILabel *)[cell viewWithTag:101];
    reminderTitle.text = [self.pinValues valueForKeyPath:[NSString stringWithFormat:@"%@.title", [self.pinKeyArray objectAtIndex:indexPath.row]]];
    
    // Set reminder notes of cell.
    UILabel *reminderNotes = (UILabel *)[cell viewWithTag:102];
    reminderNotes.text = [self.pinValues valueForKeyPath:[NSString stringWithFormat:@"%@.notes", [self.pinKeyArray objectAtIndex:indexPath.row]]];
    
    // Display expired label if reminder has gone off.
    UILabel *reminderExpired = (UILabel *)[cell viewWithTag:103];
    if (![[self.pinValues valueForKeyPath:[NSString stringWithFormat:@"%@.isExpired", [self.pinKeyArray objectAtIndex:indexPath.row]]] boolValue]) {
        
        reminderExpired.hidden = YES;
    }
    else {
        
        reminderExpired.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove cell selection.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Remove Notification at cell selected.
    [self removeReminderAtIndex:indexPath.row];
}

- (IBAction)logOutAction:(id)sender {
    
    // Log out user.
    [PFUser logOutInBackground];
    
    // Pop view controller.
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // Go to welcome view.
    [self performSegueWithIdentifier:@"welcomeSegue" sender:self];
    
}
@end
