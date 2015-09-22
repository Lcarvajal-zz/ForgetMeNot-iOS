#ForgetMeNot

by [Lauren Koulias](http://github.com/laurennk), [Tyler Hunnefeld](http://github.com/tjh12c), and [Lukas Carvajal](http://lukascarvajal.com)

##Location-Based Reminders

This iOS application allows users to set three types of reminders based on their location:

####1) Reminders When You Leave
When users drop a pin and set a radius so that they are inside the radius, they have the option of setting a reminder for when they leave an area. 
This area is set using a geofence (by setting the pin's location and radius) so that the user receives an alert when she/he exits the geofence.
For example, if Lukas doesn't want to leave his house without his backpack, he will set a reminder with a pin dropped on his house and set the radius to be around his home.
When he leaves, he gets alerted, keeping him from forgetting his backpack which contains the lab report due later that day.
ForgetMeNot saves Lukas from failing Physics, giving him the C+ he deserves. 

####2) Reminders When You Need To Leave
The second option users have, when setting a radius they are located in, is to set a reminder for when they need to leave an area after a certain amount of time.
This reminder makes use of a combination of a timer and geofence so that the user receives an alert when he/she hasn't left the geofence after a set time period.
So, when Lauren is up all night coding, she sets a reminder to take a break from the computer and leave the lab every couple of hours. That way, if she stays cooped up in the computer science lab for too long, ForgetMeNot will remind her to go out and take a break from working too hard.  

####3) Reminders When You Arrive
If a user sets a pin with a radius so that they are not located inside the radius, a reminder is set for when she/he enters that area.
This last reminder also makes use of geofences and alerts the user when he/she enters the geofence.
For example, when Tyler leaves for work he knows he might forget to check in with his boss. 
So he sets a reminder to let him know he can't forget to stop by the boss' office, saving him from one unhappy manager.

##User Login

####Welcome Page
The welcome page uses a view controller to display login and sign up buttons on the bottom of the view. It then uses a second view controller for navigating through pages. This allows users to get a glimpse of what the app does before signing up for an account. 

####Parse SDK
By implementing the Parse SDK, user accounts get created and the application stores locations linked to each user account. Users can even save locations they choose on a regular basis.

##Set Pin and Radius

####MapKit
Using a map view and the mapkit framework, ForgetMeNot provides a user-friendly interface everyone will enjoy. Users can place pins and set the radius with just a couple taps. It passes radius, pin, and user location information to ‘set reminder’ view controllers. These view controllers then let the user set the reminder.

####MKOverlay
ForgetMeNot implements MKOverlay to create a radius users can easily visualize. This helps with setting geofences, so that a user knows exactly where the geofence is set. The radius is filled in with ForgetMeNot blue.

##Set Reminder

####Geofences
By using a combination of Geofences and timers, ForgetMeNot can set the three different types of reminders.

####Notifications
Users get a push notification whenever their reminder gets set off.


