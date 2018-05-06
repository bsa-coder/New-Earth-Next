//
//  UnitsViewController.h
//  New Earth
//
//  Created by Scott Alexander on 4/21/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTech.h"
//#import "AvailTech.h"
//#import "UnitInventory.h"
//#import "Globals.h"
//#import "AppDelegate.h"
#import "UnitsDetailViewController.h"

@class UnitInventory;
@class AvailTech;
@class NewEarthGlobals;

@interface UnitsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//@property (retain) AvailTech* myStore;
//@property (retain) UITableView* theTable;
//@property (retain) UnitInventory* myWarehouse;
@property (retain) NewTech* aNewUnit;
@property CGPoint theTapLocation;
//@property (retain) AppDelegate* myAppDel;

@property (weak) IBOutlet UITableView* theTable;
@property (weak) IBOutlet UITableViewCell* theCell;

-(void) setAvailTech: (AvailTech*) availTech;
-(void) setUnitInventory:(UnitInventory *) unitInventory;
-(void) setMyGlobals:(NewEarthGlobals *) theGlobals;
- (IBAction)placeTheNewUnit:(id)sender;

@end
