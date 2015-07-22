//
//  SignUpViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/15/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)signUpAction:(id)sender;
- (IBAction)cancelSignUpAction:(id)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set text field delegates.
    self.nameTF.delegate = self;
    self.emailTF.delegate = self;
    self.passwordTF.delegate = self;
    
    // Assign first responder.
    [self.nameTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Sign Up.

- (BOOL)isValidSignUpInfo {
    
    // Format text fields.
    self.nameTF.text = [[self.nameTF.text lowercaseString] capitalizedString];
    self.emailTF.text = [self.emailTF.text lowercaseString];
    
    // Get text field values.
    NSString *name = self.nameTF.text;
    NSString *email = self.emailTF.text;
    NSString *password = self.passwordTF.text;
    
    // Make sure no fields are empty.
    if ([name length] == 0) {
        
        // Alert user that name is not valid.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name"
                                                        message:@"Name cannot be blank."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else if ([email length] == 0) {
        
        // Alert user that email is not valid.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                        message:@"Email cannot be blank."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else if ([password length] < 8) {
        
        // Alert user that password is not valid.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Password"
                                                        message:@"Password must be eight characters or longer."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    // Check for valid email.
    NSArray *checkEmail = [email componentsSeparatedByString:@"@"];
    if ([checkEmail count] <= 1) {
        
        // Alert user that password is not valid.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                        message:@"ForgetMeNot requires a valid email address."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    // Trim any outside white space user may have typed.
    name = [name stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    email = [email stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceCharacterSet]];
    
    // Check for any white space in username and email. (There should not be any)
    NSRange whiteSpaceRangeEmail = [email rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRangeEmail.location != NSNotFound){
        
        // Alert user that password is not valid.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username or Email"
                                                        message:@"Your Email and Username cannot contain any spaces!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    // Valid user info.
    return true;
}

#pragma mark - Button Actions

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Get next text field tag number.
    NSInteger nextTag = textField.tag + 1;
    
    // Get next text field
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    
    if(nextResponder) {
        
        // Next text field available, user can now type in it.
        [nextResponder becomeFirstResponder];
    }
    else {
        
        // No next text field, exit keyboard and attempt user sign up.
        [textField resignFirstResponder];
        [self signUpAction:self];
    }
    
    return NO;
}

- (IBAction)signUpAction:(id)sender {
    
    // Check for valid sign up info.
    if (![self isValidSignUpInfo])
        return;
    
    // Create PFUser object with formatted fields.
    PFUser *user = [PFUser user];
    user.username = self.emailTF.text;
    user.email = self.emailTF.text;
    user.password = self.passwordTF.text;
    user[@"name"] = self.nameTF.text;
    
    // Sign user up, Parse checks for existing users.
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // User is signed up! Show view explaining confirmation process.
            [self performSegueWithIdentifier:@"verifyEmailSegue" sender:self];
        } else {
            
            NSString *errorString = [error userInfo][@"error"];
            
            // Alert user that sign up did not work. Show error message.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error"
                                                            message:errorString
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)cancelSignUpAction:(id)sender {
    
    // Go to previous view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
