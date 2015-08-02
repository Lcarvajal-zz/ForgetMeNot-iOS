//
//  Reminder.h
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lauren Koulias on 7/25/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *details;

@property (strong, nonatomic) NSNumber *reminderLongitude;
@property (strong, nonatomic) NSNumber *reminderLatitude;
@property (strong, nonatomic) NSNumber *reminderRadius;

@end
