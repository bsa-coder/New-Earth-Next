//
//  WarehouseViewController.h
//  New Earth
//
//  Created by David Alexander on 9/23/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTech.h"
#import "UnitsDetailViewController.h"

//@class UnitInventory;
//@class AvailTech;
//@class NewEarthGlobals;

@interface WarehouseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain) NewTech* aNewUnit;
@property CGPoint theTapLocation;

@property (weak) IBOutlet UITableView* theTable;
@property (weak) IBOutlet UITableViewCell* theCell;

-(void) setAvailTech: (AvailTech*) availTech;
-(void) setUnitInventory:(UnitInventory *) unitInventory;
-(void) setMyGlobals:(NewEarthGlobals *) theGlobals;
- (IBAction)placeTheNewUnit:(id)sender;

@end

