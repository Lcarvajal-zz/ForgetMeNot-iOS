//
//  ResetEmailViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/22/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *emailTF;

- (IBAction)resetPasswordAction:(id)sender;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (IBAction)resetPasswordAction:(id)sender {
    
    // Send email to user for password reset.
    [PFUser requestPasswordResetForEmailInBackground:
     [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    // Alert user that reset password email has been sent.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Has Been Sent"
                                                    message:@"We've sent an email with instructions on how to reset your password!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
}
@end
