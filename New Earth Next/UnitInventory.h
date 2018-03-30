//
//  UnitInventory.h
//  New Earth
//
//  Created by Scott Alexander on 8/4/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//
/*
Usage:
 
 AddEntry - adding NewTech unit to NSMutableDictionaries
    unitInventory - contains units that have been purchased for installation
    selectionInventory - contains the units that are available for sale and installation
 
 This is used to fill TABLES with lists
 
 TABLE - list of unit types (originating from itemType.h)
 TABLE - list of units from selectionInventory based on pick from unit types
 TABLE - list of units from unitInventory ordered by unit types
 TABLE - list of units
 
 PlaceEntry - select unit from unitInventory that hasn't been placed and put it onto a location
 
 
*/

#import <Foundation/Foundation.h>
#import "NewTech.h"
#import "ItemEnums.h"
#import "Globals.h"

@class NewTech;
typedef void (^UnitEnumeratorBlock) (NewTech* newTech);

extern NSString* const kUnitInventoryBeginChangesNotification;
extern NSString* const kUnitInventoryInsertEntryNotification;
extern NSString* const kUnitInventoryDeleteEntryNotification;
extern NSString* const kUnitInventoryChangesCompleteNotification;

// to access data in the notifications
extern NSString* const kUnitInventoryNotificationIndexPathKey;

@interface UnitInventory : NSObject <NSCoding>
{
    //    NSMutableArray* unitInventoryList;
    //    NewEarthGlobals* theGlobals;
}

@property CGFloat* stockpileTotals; // holds parts made by unit
@property (strong, nonatomic) NewEarthGlobals* theGlobals;

-(void) fillStockpileTotals: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor;

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger laborers;

//@property (strong, nonatomic) NSMutableDictionary* unitInventory;
//@property (strong, nonatomic) NSMutableArray* unitInventoryList;

-(NewTech*) unitAtIndexPath:(NSIndexPath*) indexPath;
-(NSIndexPath*) indexPathForUnit:(NewTech*) newTech;
-(void) addUnit:(NewTech*) newTech;
-(void) deleteUnitAtIndexPath:(NSIndexPath*) indexPath;
-(void) enumerateUnitsAscending:(BOOL) ascending withBlock:(UnitEnumeratorBlock) block;
-(void) saveContents;
-(void) resetContents;

-(void) updateMe;

-(CGFloat) getMakeRateForStocktype: (stockType) theType;
-(CGFloat) getTakeRateForStocktype: (stockType) theType;
-(CGFloat) getNewRateForStocktype: (stockType) theType;

+(id)sharedSelf;

@end
