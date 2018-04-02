//
//  RootTabBarViewController.h
//  New Earth
//
//  Created by Scott Alexander on 7/10/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Calendar.h"

@class UnitInventory;
@class AvailTech;
@class NeNotifications;
@class NewEarthGlobals;
//@class Calendar;

@interface RootTabBarViewController : UITabBarController

@property (strong, nonatomic) UnitInventory* unitInventory;
@property (strong, nonatomic) AvailTech* availTech;
@property (strong, nonatomic) NeNotifications* neNotes;
@property (strong, nonatomic) NewEarthGlobals* neGlobals;
//@property (strong, nonatomic) Calendar* theCalendar;

@end
