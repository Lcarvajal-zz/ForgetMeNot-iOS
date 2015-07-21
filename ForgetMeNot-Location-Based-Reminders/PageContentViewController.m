//
//  PageContentViewController.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/14/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set image and text.
    UIImage *iconImage = [UIImage imageNamed:self.iconName];
    self.iconImageView.image = iconImage;
    self.titleLabel.text = self.titleText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller styling

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
