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
@property (nonatomic) NSDictionary *pinValues;
@property (nonatomic) NSArray *pinKeyArray; // Stores the key of each pin in an array

@end

@implementation CurrentRemindersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.pinValues = [defaults objectForKey:@"PinValues"];
    self.pinKeyArray = [self.pinValues allKeys];
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
    
    // Configure the cell...
    cell.textLabel.text = [self.pinValues valueForKeyPath:[NSString stringWithFormat:@"%@.title", [self.pinKeyArray objectAtIndex:indexPath.row]]];
    cell.detailTextLabel.text = [self.pinValues valueForKeyPath:[NSString stringWithFormat:@"%@.notes", [self.pinKeyArray objectAtIndex:indexPath.row]]];
    
    return cell;
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
