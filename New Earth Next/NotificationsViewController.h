//
//  NotificationsViewController.h
//  New Earth
//
//  Created by Scott Alexander on 7/17/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NENotification.h"
#import "NeNotifications.h"
#import "AppDelegate.h"

// message to update GUI
//extern NSString* const kSetUpdateNotification;

@interface NotificationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
//    UITableView* theTable;
    
}

//@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UITableViewCell* tableViewCellLocal;
@property (strong, nonatomic) UITableViewCell* tableViewCellRemote;

//@property IBOutlet UITableView* theTable;
@property IBOutlet UITableViewCell* theCellLocal;
@property IBOutlet UITableViewCell* theCellRemote;
@property NSMutableArray* aTable;

@property (nonatomic, readonly) NSUInteger count;
@property (retain) NSNotificationCenter* center;
-(void) handleUpdateNotification:(NSNotification*) paramNotification;

-(void) setNeNoteList:(NeNotifications*) noteList;

//- (IBAction)placeTheNewUnit:(id)sender;

@end
