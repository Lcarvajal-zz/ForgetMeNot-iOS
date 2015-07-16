//
//  SignUpViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/15/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "SignUpViewController.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    // Attempt user sign up.
    NSLog(@"Attempt user sign up!");
}

- (IBAction)cancelSignUpAction:(id)sender {
    
    // Go to previous view.
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
