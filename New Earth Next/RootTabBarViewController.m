//
//  RootTabBarViewController.m
//  New Earth
//
//  Created by Scott Alexander on 7/10/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "UnitInventory.h"
#import "AvailTech.h"
#import "NeNotifications.h"
#import "Globals.h"
#import "NotificationsViewController.h"
#import "NENotification.h" // for a test
#import "AppDelegate.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.unitInventory = [UnitInventory sharedSelf];
    self.availTech = [AvailTech sharedSelf];
    self.neNotes = [NeNotifications sharedSelf];
    self.neGlobals = [NewEarthGlobals sharedSelf];
    
//    [self addInitialUnit];
    
//    [self addMockData];
    
    [self containersAreReady];
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

#pragma mark - Private Methods

-(void) addInitialUnit
{
    // ==== note that the list will change with new units so 9 will change to still point at the HOME item!!!
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NewTech* aUnit = [[NewTech alloc] initWithUnit:(NewTech*)[_availTech unitAtIndexPath:indexPath]];
    
    aUnit.myName = @"HQ - HOME";
    aUnit.myType = (itemType) home;
    aUnit.myStatus = isnew;
    aUnit.myPlaced = YES;
    [aUnit fillStockBOMStruct:100 comp:100 supp:100 matl:100 powr:0 watr:100 air:0 food:100 labr:1];
    aUnit.myLoc = CGPointMake(500 * _neGlobals.mapScale,500 * _neGlobals.mapScale);

    [_unitInventory addUnit:aUnit];
}

-(void) addMockData
{
    NSTimeInterval twentyFourHours = 60.0 * 60.0 * 24.0;
    NSDate* now = [NSDate date];
    
    NSDate* yesterday = [now dateByAddingTimeInterval:-twentyFourHours];
    NSDate* twoDaysAgo = [yesterday dateByAddingTimeInterval:-twentyFourHours];
    
    NENotification* note1 = [[NENotification alloc] initNotificationOnDay:1 from:fromHome type:warning content:@"a warning from home" date:twoDaysAgo isRemote:NO];
    NENotification* note2 = [[NENotification alloc] initNotificationOnDay:2 from:fromHome type:info content:@"info from home" date:yesterday isRemote:NO];
    NENotification* note3 = [[NENotification alloc] initNotificationOnDay:3 from:fromHome type:eventGood content:@"good event from home" date:now isRemote:NO];
    NENotification* note4 = [[NENotification alloc] initNotificationOnDay:6 from:fromHome type:statusBad content:@"bad status from home" date:now isRemote:NO];
    NENotification* note5 = [[NENotification alloc] initNotificationOnDay:99 from:fromHome type:urgent content:@"urgent status from home" date:now isRemote:YES];
    NENotification* note6 = [[NENotification alloc] initNotificationOnDay:23 from:fromHome type:statusGood content:@"good status from home" date:now isRemote:NO];
    NENotification* note7 = [[NENotification alloc] initNotificationOnDay:17 from:fromHome type:eventBad content:@"bad event from home" date:now isRemote:NO];
    
//    [self.neNotes addNote:note1];
    [self.neNotes performSelector:@selector(addNote:) withObject:note3 afterDelay:20.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note2 afterDelay:10.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note1 afterDelay:30.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note5 afterDelay:35.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note4 afterDelay:5.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note6 afterDelay:15.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note7 afterDelay:25.0];
    
    [self.neNotes performSelector:@selector(addNote:) withObject:note3 afterDelay:45.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note2 afterDelay:50.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note1 afterDelay:55.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note5 afterDelay:60.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note4 afterDelay:65.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note6 afterDelay:70.0];
    [self.neNotes performSelector:@selector(addNote:) withObject:note7 afterDelay:75.0];
}

-(void) containersAreReady
{
    // automatically passes the unit inventory to
    // any of the other controlled view controllers
    for (id controller in self.viewControllers)
    {
        if ([controller respondsToSelector:@selector(setUnitInventory:)]) {
            [controller setUnitInventory:self.unitInventory];
        }
        if ([controller respondsToSelector:@selector(setAvailTech:)]) {
            [controller setAvailTech:self.availTech];
        }
        if ([controller respondsToSelector:@selector(setNeNoteList:)]) {
            [controller setNeNoteList:self.neNotes];
        }
/**/
        if ([controller respondsToSelector:@selector(setTheGlobals:)]) {
//            [controller setMyGlobals:self.neGlobals];
            [controller setTheGlobals:self.neGlobals];
        }

//        [controller setMyGlobals: [self neGlobals]];
    }
}

@end
