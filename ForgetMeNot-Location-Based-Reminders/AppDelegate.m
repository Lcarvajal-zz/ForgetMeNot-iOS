//
//  AppDelegate.m
//  ForgetMeNot-Location-Based-Reminders
//
//  Created by Lukas Carvajal on 7/13/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Parse API keys for user login.
    [Parse setApplicationId:@"Ve9m0hJAXAQQHWWRiACW066ZZCzn9BCbO9s1Lf3n"
                  clientKey:@"2VAKzWd5oQlAkl0mtyG2bd6ijxiiVZbUumgSo3uQ"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed: 0.0/255.0f green:153.0/255.0f blue:255.0/255.0f alpha:1.0];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    // Set up location manager.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //ask for permission
    if ([[self locationManager] respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //****Standard Location Service used to check if it all works****
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    // Notifications
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notication

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self showNotificationAlert:notification.alertBody];
}

- (void)showNotificationAlert:(NSString *)alertMsg
{
    if (!alertMsg)
        return;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notification", nil)
                                                    message:alertMsg
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)createNotificationForPinId:(NSString *)pinId whileEntering:(BOOL)entering {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *pinDictionary = [[defaults objectForKey:@"PinValues"] mutableCopy];
    
    if(!entering) {
        [self cancelLocalNotification:pinId];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"%@ - %@",
                                   [pinDictionary valueForKeyPath:[NSString stringWithFormat:@"%@.title", pinId]],
                                   [pinDictionary valueForKeyPath:[NSString stringWithFormat:@"%@.notes", pinId]]
                                   ];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber += 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)cancelLocalNotification:(NSString*)notificationID
{
    for (int j =0;j<[[[UIApplication sharedApplication]scheduledLocalNotifications]count]; j++)
    {
        UILocalNotification *someNotification = [[[UIApplication sharedApplication]scheduledLocalNotifications]objectAtIndex:j];
        if([[someNotification.userInfo objectForKey:@"pinId"] isEqualToString:notificationID])
        {
            NSLog(@"canceled notifications %@",someNotification);
            [[UIApplication sharedApplication] cancelLocalNotification:someNotification];
        }
        
    }
}

#pragma mark - CLLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"You entered a region!");
    [self createNotificationForPinId:region.identifier whileEntering:YES];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"You exited a region!");
    [self createNotificationForPinId:region.identifier whileEntering:NO];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Im monitoring for a region!");
}


@end
