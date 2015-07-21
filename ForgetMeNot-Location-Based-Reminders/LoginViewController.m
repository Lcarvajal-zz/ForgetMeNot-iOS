//
//  LoginViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/13/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)logInAction:(id)sender;
- (IBAction)cancelLoginAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set text field delegates.
    self.emailTF.delegate = self;
    self.passwordTF.delegate = self;
    
    // Assign first responder.
    [self.emailTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions.

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
        
        // No next text field exists, dismiss keyboard and attempt user log in.
        [textField resignFirstResponder];
        [self logInAction:self];
    }
    
    return NO;
}

- (IBAction)logInAction:(id)sender {
    
    // Attempt user log in.
    NSLog(@"Attempt user log in!");
}

- (IBAction)cancelLoginAction:(id)sender {
    
    // Return to previous view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
