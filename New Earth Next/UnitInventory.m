//
//  UnitInventory.m
//  New Earth
//
//  Created by Scott Alexander on 8/4/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "UnitInventory.h"
#import "NewTech.h"

NSString* const kUnitInventoryBeginChangesNotification = @"UnitInventoryBeginChangesNotification";
NSString* const kUnitInventoryInsertEntryNotification = @"UnitInventoryInsertEntryNotification";
NSString* const kUnitInventoryDeleteEntryNotification = @"UnitInventoryDeleteEntryNotification";
NSString* const kUnitInventoryChangesCompleteNotification = @"UnitInventoryChangesCompleteNotification";

// to access data in the notifications
NSString* const kUnitInventoryNotificationIndexPathKey = @"UnitInventoryNotificationIndexPathKey";

NSString* const kUnitInventoryKey = @"UnitInventoryKey";
NSString* const kUnitInventoryListKey = @"UnitInventoryListKey";
CGFloat stockpileTotals[(stockType) 9]; // holds parts made by unit

@interface UnitInventory()
@property (strong, nonatomic) NSMutableArray* unitInventoryList;
@end

@implementation UnitInventory
//@synthesize unitInventory, unitInventoryList, theGlobals;
@synthesize theGlobals;

#pragma mark - Singleton Methods
+(id)sharedSelf
{
    static UnitInventory *sharedUnits = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUnits = [[self alloc] init];
    });
    return sharedUnits;
}

#pragma mark - Initialization Methods
-(id)init
{
    self = [super init];
    if(self)
    {
        _unitInventoryList = [[NSMutableArray alloc] initWithCapacity:10];
        theGlobals = [NewEarthGlobals sharedSelf];
//        [self addInitialUnit];
    }
    return self;
}

-(void) updateMe
{
    [self howsMySustain];

    [self clearNonConsumables];
    [self makeThings];
    [self fixThings];
    [self howsMySustain];
}

// run this before making/taking resources (labor/power allocated, not created)
-(void) clearNonConsumables
{
    stockpileTotals[powerStock] = 0.0;
    stockpileTotals[laborStock] = 0.0;
}

-(void) howsMySustain
{
    NewTech* tempUnit = [NewTech alloc];
    CGFloat Resource00 = 0;
    CGFloat Resource01 = 0;
    CGFloat Resource02 = 0;
    CGFloat Resource03 = 0;
    CGFloat Resource04 = 0;
    CGFloat Resource05 = 0;
    CGFloat Resource06 = 0;
    CGFloat Resource07 = 0;
    CGFloat Resource08 = 0;
    CGFloat Resource09 = 0;
    
    for (int i = 0; i<_unitInventoryList.count; i++)
    {
        tempUnit = _unitInventoryList[i];
//        NSLog(@"%@",[tempUnit printMyStores]);
        
        if (tempUnit.myStatus != operating && tempUnit.myStatus != repairingFull && tempUnit.myStatus != repairingHalf) {
            continue;
        }
        
        for (int j=0; j<sizeof(stockpileTotals)/sizeof(CGFloat); j++) {
            switch (j) {
                case 0://struct
                    Resource00 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource00 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 1://comp
                    Resource01 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource01 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 2://supp
                    Resource02 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource02 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 3://matl
                    Resource03 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource03 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 4://power
                    Resource04 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource04 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 5://water
                    Resource05 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource05 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 6://air
                    Resource06 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource06 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 7://food
                    Resource07 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource07 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 8://labor
                    Resource08 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource08 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                case 9:
                    Resource09 += [tempUnit.takerBOM[j] floatValue] * tempUnit.myProduceRate;
                    Resource09 += [tempUnit.repairBOM[j] floatValue] * tempUnit.myWearoutRate / 100.0;
                    break;
                    
                default:
                    break;
            }
        }
    }
//    NSLog(@"Take str:%0.1f comp:%0.1f sup:%0.1f mat:%0.1f power:%0.1f water:%0.1f air:%0.1f food:%0.1f lab:%0.1f oth:%0.1f", Resource00, Resource01, Resource02, Resource03, Resource04, Resource05, Resource06, Resource07, Resource08, Resource09);
    
    Resource00 = 0;
    Resource01 = 0;
    Resource02 = 0;
    Resource03 = 0;
    Resource04 = 0;
    Resource05 = 0;
    Resource06 = 0;
    Resource07 = 0;
    Resource08 = 0;
    Resource09 = 0;
    
    for (int i = 0; i<_unitInventoryList.count; i++)
    {
        tempUnit = _unitInventoryList[i];
        if (tempUnit.myStatus != operating && tempUnit.myStatus != repairingFull && tempUnit.myStatus != repairingHalf) {
            continue;
        }
        
        CGFloat produceFactor = 1.0;
        
        if (tempUnit.myStatus == repairingHalf) {
            produceFactor = 0.5;
        }
        
        for (int j=0; j<sizeof(stockpileTotals)/sizeof(CGFloat); j++) {
            switch (j) {
                case 0: //structure
                    Resource00 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 1: //comp
                    Resource01 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 2: //supplies
                    Resource02 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 3: //materials
                    Resource03 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 4: //power
                    Resource04 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 5: //water
                    Resource05 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 6: //air
                    Resource06 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 7: //food
                    Resource07 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                case 8: //labor
                    Resource08 += [tempUnit.makerBOM[j] floatValue]; break;
                    
                case 9:
                    Resource09 += [tempUnit.makerBOM[j] floatValue] * tempUnit.myProduceRate * produceFactor; break;
                    
                default:
                    break;
            }
        }
    }
    
//    NSLog(@"Make str:%0.1f comp:%0.1f sup:%0.1f mat:%0.1f power:%0.1f water:%0.1f air:%0.1f food:%0.1f lab:%0.1f oth:%0.1f", Resource00, Resource01, Resource02, Resource03, Resource04, Resource05, Resource06, Resource07, Resource08, Resource09);

    Resource00 = 0;
    Resource01 = 0;
    Resource02 = 0;
    Resource03 = 0;
    Resource04 = 0;
    Resource05 = 0;
    Resource06 = 0;
    Resource07 = 0;
    Resource08 = 0;
    Resource09 = 0;
    
    for (int i = 0; i<_unitInventoryList.count; i++)
    {
        tempUnit = _unitInventoryList[i];
        if (tempUnit.myStatus != operating && tempUnit.myStatus != repairingHalf) {
            continue;
        }
        
        for (int j=0; j<sizeof(stockpileTotals)/sizeof(CGFloat); j++) {
            switch (j) {
                case structureStock: //structure
                    Resource00 += [tempUnit.myStockpiles[structureStock] floatValue]; stockpileTotals[structureStock] = Resource00; break;
                    
                case componentStock: //comp
                    Resource01 += [tempUnit.myStockpiles[componentStock] floatValue]; stockpileTotals[componentStock] = Resource01; break;
                    
                case supplyStock: //supplies
                    Resource02 += [tempUnit.myStockpiles[supplyStock] floatValue]; stockpileTotals[supplyStock] = Resource02; break;
                    
                case materialStock: //materials
                    Resource03 += [tempUnit.myStockpiles[materialStock] floatValue]; stockpileTotals[materialStock] = Resource03; break;
                    
                case powerStock: //power
                    Resource04 += [tempUnit.makerBOM[powerStock] floatValue] * tempUnit.myProduceRate; stockpileTotals[powerStock] = Resource04; break;
                    
                case waterStock: //water
                    Resource05 += [tempUnit.myStockpiles[waterStock] floatValue]; stockpileTotals[waterStock] = Resource05; break;
                    
                case airStock: //air
                    Resource06 += [tempUnit.myStockpiles[airStock] floatValue]; stockpileTotals[airStock] = Resource06; break;
                    
                case foodStock: //food
                    Resource07 += [tempUnit.myStockpiles[foodStock] floatValue]; stockpileTotals[foodStock] = Resource07; break;
                    
                case laborStock: //labor
                    Resource08 += [tempUnit.makerBOM[laborStock] floatValue]; stockpileTotals[laborStock] = Resource08; break;
                    
                case 9:
                    Resource09 += [tempUnit.myStockpiles[j] floatValue]; stockpileTotals[j] = Resource09; break;
                    
                default:
                    break;
            }
        }
    }
    
    /*
     stockpileTotals[structureStock] = Resource00;
     stockpileTotals[componentStock] = Resource01;
     stockpileTotals[supplyStock] = Resource02;
     stockpileTotals[materialStock] = Resource03;
     stockpileTotals[powerStock] = Resource04;
     stockpileTotals[waterStock] = Resource05;
     stockpileTotals[airStock] = Resource06;
     stockpileTotals[foodStock] = Resource07;
     stockpileTotals[laborStock] = Resource08;
     */
    
//    NSLog(@"Stck str:%0.1f comp:%0.1f sup:%0.1f mat:%0.1f power:%0.1f water:%0.1f air:%0.1f food:%0.1f lab:%0.1f oth:%0.1f", Resource00, Resource01, Resource02, Resource03, Resource04, Resource05, Resource06, Resource07, Resource08, Resource09);
    
}

-(void) makeThings
{
    // NSLog(@"in makeThings");
    // step through each unit
    // make sure the kit is complete
    // fill the kit
    // make the items
    // repairRate = percent of health so 10 = increase unit health 10% with one days effort
    // repairBOM[i] = units of resource to create one whole unit (100% health)
    
    //    CGFloat tempTakeRate = 0;
    //    CGFloat fixItRate = 1;
    NewTech* tempUnit = [NewTech alloc];
    
    for (int i = 0; i<_unitInventoryList.count; i++)
    {
        //NSLog(@"in makeThings i = %d", i);
        tempUnit = _unitInventoryList[i];

        if ((tempUnit.myStatus == isnew) || (tempUnit.myStatus == building) || (tempUnit.myStatus == preparing) || (tempUnit.myStatus == clearing) || (tempUnit.myStatus == cleaning) || (tempUnit.myStatus == connecting) || (tempUnit.myStatus == standby)) { continue; }

//        NSLog(@"make things: %@", [tempUnit printMe]);
        
        CGFloat adjustedMakeRate = 0.0;
        CGFloat testNumber = tempUnit.myProduceRate;
        adjustedMakeRate = testNumber;

        if (tempUnit.myProduceRate <= 0) { continue; } // can't make with this unit
        
        for (int j=0; j<sizeof(stockpileTotals)/sizeof(CGFloat); j++)
        {
            //NSLog(@"in makeThings i = %d j = %d", i, j);
            CGFloat temp2a = [tempUnit.takerBOM[j] floatValue]; // resources to make one output unit
            if (temp2a <= 0) {
//                NSLog(@"--- resource not needed: %@ (%d)", [theGlobals resourceName: j], j);
                continue; } // unit uses none of this resource
            CGFloat temp2b = adjustedMakeRate; // rate to use resources
            CGFloat temp2c = stockpileTotals[j]; // resources avail for repair
            CGFloat temp2d = temp2a * temp2b; // ideal amount of resources to use
            CGFloat temp2e = (temp2c > temp2d ? temp2d : temp2c ); // actual resources to use
            
            adjustedMakeRate *= temp2e / temp2d; // adjust (reduce) adjustedFixRate if not enough resources
            
            if (adjustedMakeRate <= 0) {
//                NSLog(@"-- not enough resources: %@ (%d)", [theGlobals resourceName: j], j);
                break; }
//            else { NSLog(@"------- using resources: %@ (%d) amt: %0.1f", [theGlobals resourceName: j], j, adjustedMakeRate); }
            
        }
        
        if (adjustedMakeRate <= 0) {
//            NSLog(@"%@: no resources\n", tempUnit.myName) ;
            continue; } // no resources available for making resources
        
        for (int k=0; k<sizeof(stockpileTotals)/sizeof(CGFloat); k++) // step through each resource type
        {
            //NSLog(@"in makeThings i = %d k = %d", i, k);
            CGFloat amountToGet = [tempUnit.takerBOM[k] floatValue] * adjustedMakeRate;
            if (amountToGet <= 0) continue; // don't do anything if nothing needed
            
            for (int l=0; l < _unitInventoryList.count; l++) // step through each unit
            {
                //NSLog(@"in makeThings i = %d j = %d l = %d", i, k, l);
                NewTech *otherUnit = _unitInventoryList[l];
                if (otherUnit.myStockpiles[k] == 0) continue;
                CGFloat amountUsed = ([otherUnit.myStockpiles[k] floatValue] < amountToGet?
                                      [otherUnit.myStockpiles[k] floatValue] : amountToGet);
                if (amountUsed > 0) {
//                    NSLog(@"bef --(%d:%d): othUnit: %0.1f totals: %0.1f amtToDo: %0.1f amtUsed: %0.1f", k, l, [otherUnit.myStockpiles[k] floatValue], stockpileTotals[k], amountToGet, amountUsed);
                    
                    otherUnit.myStockpiles[k] = [NSNumber numberWithFloat: [otherUnit.myStockpiles[k] floatValue] - amountUsed]; // add to the unit stockpile
                    stockpileTotals[k] -= amountUsed; // reduce the total stockpile amount
                    
//                    NSLog(@"-- aft(%d:%d): othUnit: %0.1f totals: %0.1f amtToDo: %0.1f amtUsed: %0.1f", k, l, [otherUnit.myStockpiles[k] floatValue], stockpileTotals[k], amountToGet, amountUsed);
                    
                    amountToGet -= amountUsed; // reduce the total remaining amount
                    if (amountToGet <= 0) break;

                }
            }
        }
        
        if ((tempUnit.myType == home || tempUnit.myType == power || tempUnit.myType == water || tempUnit.myType == air) && (tempUnit.myStatus == operating || tempUnit.myStatus == repairingHalf || tempUnit.myStatus == repairingFull))
        {
            // these are capacitity types (so stuff made and passed on)
            NSInteger k = 0;
            switch (tempUnit.myType) {
                case home: k = 8; break; // labor
                case power: k = 4; break; // power
                case water: k = 5; break; // water
                case air: k = 6; break; // air
                default: break;
            }
            CGFloat amountToMake = [tempUnit.makerBOM[k] floatValue] * adjustedMakeRate;
            if (amountToMake <= 0) {continue;} // don't do anything if nothing needed
            tempUnit.myStockpiles[k] = [NSNumber numberWithFloat: amountToMake]; // add to the unit
        }
        else
        {
            // stockpileTotals[powerStock] = 0;
            // stockpileTotals[laborStock] = 0;
            
            for (int k=0; k<sizeof(stockpileTotals)/sizeof(CGFloat); k++) // step through each resource type
            {
                CGFloat amountToMake = [tempUnit.makerBOM[k] floatValue] * adjustedMakeRate;
                if (amountToMake <= 0) {continue;} // don't do anything if nothing needed
                tempUnit.myStockpiles[k] = [NSNumber numberWithFloat: [tempUnit.myStockpiles[k] floatValue] + amountToMake]; // add to the unit
                stockpileTotals[k] += amountToMake; // reduce the total stockpile amount
            }
        }
    }
}

-(void) fixThings
{
    // NSLog(@"in fixThings");
    // step through each unit
    // make sure the kit is complete
    // fill the kit
    // make the items
    // repairRate = percent of health so 10 = increase unit health 10% with one days effort
    // repairBOM[i] = units of resource to create one whole unit (100% health)
    
    NewTech* tempUnit = [NewTech alloc];
    
    for (int i = 0; i<_unitInventoryList.count; i++)
    {
        tempUnit = _unitInventoryList[i];
        
        if ((tempUnit.myStatus == isnew) || (tempUnit.myStatus == preparing) || (tempUnit.myStatus == building)) { continue; }

        CGFloat adjustedFixRate = (tempUnit.myRepairRate > (100 - tempUnit.myHealth) ? (100 - tempUnit.myHealth) : tempUnit.myRepairRate);
        if (tempUnit.myRepairRate <= 0) { continue; } // can't repair this unit
        if (tempUnit.myHealth > 80) continue; // don't waste resources if not too broken
        
        for (int j=0; j<sizeof(stockpileTotals)/sizeof(CGFloat); j++) {
            if (adjustedFixRate <= 0) {break;}
            CGFloat temp2a = [tempUnit.repairBOM[j] floatValue]; // resources for whole unit
            if (temp2a <= 0) { continue; } // unit contains none of this resource
            CGFloat temp2b = adjustedFixRate; // rate to use resources
            CGFloat temp2c = stockpileTotals[j]; // resources avail for repair
            CGFloat temp2d = temp2a * temp2b / 100.0; // ideal amount of resources to use
            CGFloat temp2e = (temp2c > temp2d ? temp2d : temp2c ); // actual resources to use
            
            adjustedFixRate *= temp2e / temp2d; // adjust (reduce) adjustedFixRate if not enough resources
            
        }
        
        if (adjustedFixRate <= 0) { continue; } // no resources available for repairing
        
        for (int k=0; k<sizeof(stockpileTotals)/sizeof(CGFloat); k++) // step through each resource type
        {
            CGFloat amountToGet = [tempUnit.repairBOM[k] floatValue] * adjustedFixRate / 100.0;
            if (amountToGet <= 0) continue; // don't do anything if nothing needed
            
            for (int l=0; l < _unitInventoryList.count; l++) // step through each unit
            {
                NewTech *otherUnit = _unitInventoryList[l];
                if (otherUnit.myStockpiles[k] == 0) continue;
                CGFloat amountUsed = ([otherUnit.myStockpiles[k] floatValue] < amountToGet?
                                      [otherUnit.myStockpiles[k] floatValue] : amountToGet);
                otherUnit.myStockpiles[k] = [NSNumber numberWithFloat: [otherUnit.myStockpiles[k] floatValue] - amountUsed]; // add to the unit stockpile
                stockpileTotals[k] -= amountUsed; // reduce the total stockpile amount
                amountToGet -= amountUsed; // reduce the total remaining amount
                if (amountToGet <= 0) break;
            }
        }
        tempUnit.myHealth += adjustedFixRate;
    }
}

-(void) fillStockpileTotals: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor
{
    stockpileTotals[structureStock] += aStructure;
    stockpileTotals[componentStock] += aComponent;
    stockpileTotals[supplyStock] += aSupply;
    stockpileTotals[materialStock] += aMaterial;
    stockpileTotals[powerStock] += aPower;
    stockpileTotals[waterStock] += aWater;
    stockpileTotals[airStock] += aAir;
    stockpileTotals[foodStock] += aFood;
    stockpileTotals[laborStock] += aLabor;
}


#pragma mark - Accessor Methods
-(NSUInteger) count
{
    return [self.unitInventoryList count];
}

+(NSSet*) keyPathsforValuesAffectingCount
{
    return [NSSet setWithObjects:@"unitInventoryList", nil];
}

-(NSUInteger) laborers
{
    return stockpileTotals[laborStock];// may need to step through units to count laborers if stockpiletotals not kept current
}

+(NSSet*) keyPathsForValuesAffectingLaborers
{
    return [NSSet setWithObjects:@"laborers", nil];
}

#pragma mark - KVO Accessors

-(void) insertObject:(NewTech *)object inUnitInventoryListAtIndex:(NSUInteger)index
{
    [self.unitInventoryList insertObject:object atIndex:index];
}

-(void) removeObjectFromUnitInventoryListAtIndex:(NSUInteger)index
{
    [self.unitInventoryList removeObjectAtIndex:index];
}

/*
-(void) insertUnit:(NewTech *)newTech atLoc:(NSString*)theLoc
{
    [self.unitInventory setObject: newTech forKey:theLoc];
}

-(void) removeUnitFromUnitInventoryAtIndex:(NSString*)theLoc
{
    [self.unitInventory removeObjectForKey:theLoc];
}

-(NewTech*) unitAtLoc:(NSString *)theLoc
{
    return [self.unitInventory objectForKey:theLoc];
}
 */

#pragma mark - Public Methods

-(NewTech*) unitAtIndexPath:(NSIndexPath *)indexPath
{
    return self.unitInventoryList[(NSUInteger)indexPath.row];
}

-(NSIndexPath*) indexPathForUnit:(NewTech*) newTech
{
    NSUInteger row = [self.unitInventoryList indexOfObject:newTech];
    return [NSIndexPath indexPathForRow:row inSection:0]; // TODO: may have sections and will need to handle
}

-(NSInteger) insertionPointForLoc: (CGPoint) theLoc
{
    NSInteger index = 0;

    CGFloat newDist = sqrt(theLoc.x*theLoc.x + theLoc.y*theLoc.y);
    newDist = (theLoc.x<0 || theLoc.y<0 ? -1.0*newDist : newDist);
    
    for (NewTech* newTech in self.unitInventoryList)
    {
        CGFloat unitDist = sqrt(newTech.myLoc.x*newTech.myLoc.x + newTech.myLoc.y*newTech.myLoc.y);
        unitDist = (newTech.myLoc.x<0 || newTech.myLoc.y<0 ? -1.0*unitDist : unitDist);
        
        if (unitDist < newDist) {
            return index;
        }
        index++;
    }
    return index;
}

-(void) addUnit:(NewTech *)newTech// toLoc:(CGPoint)theLoc
{
// adding a new entry to the unit inventory
// the new unit must have a unique location; but, unplaced as it is the index for the inventory so ...
// find the first entry that is unplaced (will have negative coordinates)

    NSLog(@"in addUnit");
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kUnitInventoryBeginChangesNotification object:self];
    
    CGPoint newPoint;
    if ((newTech.myLoc.x > 0)) {
        newPoint = newTech.myLoc;
    } else {
        CGPoint lastPoint = [(NewTech*)self.unitInventoryList.lastObject myLoc];
        newPoint = CGPointMake(lastPoint.x - newTech.mySize.width, lastPoint.y - newTech.mySize.height);
    }
    
//    NSInteger index = [self insertionPointForLoc:newTech.myLoc];
    NSInteger index = [self insertionPointForLoc:newPoint];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
// update unit
    newTech.myLoc = newPoint;

// add unit to unitInventory
//    [self.unitInventory setObject:newTech forKey:NSStringFromCGPoint(newPoint)];
//    [self insertUnit:newTech atLoc:NSStringFromCGPoint(newPoint)];
//    [self.unitInventoryList addObject:newTech];
//    [self.unitInventoryList insertObject:newTech atIndex:index];
    [self insertObject:newTech inUnitInventoryListAtIndex:index];
    
    for (int i = 0; i < [newTech.myStockpiles count]; i++) {
        stockpileTotals[i] += [newTech.myStockpiles[i] floatValue];
    }
    
//TODO:  get point from unitInventoryList, use it to add to unitInventory
    
    [center postNotificationName:kUnitInventoryInsertEntryNotification
                          object:self
                        userInfo:@{kUnitInventoryNotificationIndexPathKey:indexPath}];

//    [center postNotificationName:kUnitInventoryInsertEntryNotification object:self];
    [center postNotificationName:kUnitInventoryChangesCompleteNotification object:self];

}

-(void) deleteUnitAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kUnitInventoryBeginChangesNotification object:self];
//TODO:  get point from unitInventoryList, find it in unitInventory, delete it there also
    [self removeObjectFromUnitInventoryListAtIndex:indexPath.row];
    [center postNotificationName:kUnitInventoryDeleteEntryNotification object:self];
    [center postNotificationName:kUnitInventoryChangesCompleteNotification object:self];
}

-(void) enumerateUnitsAscending:(BOOL)ascending withBlock:(UnitEnumeratorBlock)block
{
    NSUInteger options = 0;
    if (ascending) {
        options = NSEnumerationReverse;
    }
    
    [self.unitInventoryList enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL* stop)
     {
         block(obj);
     }];
}

- (void)saveContents {
    
    int numberOfUnits = [self count];
    if (numberOfUnits <= 0) return;
    
    for (int i = 0; i < numberOfUnits; i++) {
        NSIndexPath* nsPath = [NSIndexPath indexPathForRow:i inSection:0];
        NewTech* nt = [self unitAtIndexPath:nsPath];
        
        [nt saveTechDataToFile: @"Warehouse"];
    }
}

-(void) resetContents
{
//    int numberOfUnits = [self count];
//    NSIndexPath* nsPath;
    [_unitInventoryList removeAllObjects];
//    while (numberOfUnits > 0) {
//        nsPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self deleteUnitAtIndexPath:nsPath];
//        numberOfUnits = [self count];
//    }
    [self addInitialUnit];
}

#pragma mark - Private Methods

-(void) addInitialUnit
{
    // ==== note that the list will change with new units so 9 will change to still point at the HOME item!!!
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    NewTech* HOME = [[NewTech alloc] initWithType:(itemType) home withLoc:CGPointMake(-80, 0) withID:0 withSize:CGSizeMake(8, 60) withHealth:0 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"HOME" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:100 withBuildRate:10 withRepairRate:15 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:10 withSmoothRate:10 withConnectRate:10 withEnvelope:60.0];
    
    [HOME fillTakerBOMStruct:0.0 comp:0.0 supp:0 matl:0.0 powr:0 watr:0.0 air:0.0 food:0.1 labr:0.0];
    [HOME fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:0.0 powr:0.0 watr:0 air:0.0 food:0.0 labr:1];
    [HOME fillRepairBOMStruct:10 comp:10 supp:1 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    HOME.myName = @"HQ - HOME";
    HOME.myType = (itemType) home;
    HOME.myStatus = isnew;
//    HOME.myPlaced = YES;
    [HOME fillStockBOMStruct:100 comp:100 supp:100 matl:100 powr:0 watr:100 air:0 food:100 labr:1];
    HOME.myLoc = CGPointMake(500 * theGlobals.mapScale,500 * theGlobals.mapScale);
    
    [self addUnit:HOME];
}

-(NSUInteger) insertionPointForPoint:(CGPoint) point
{
    NSUInteger index = 0;
    for (NewTech* newTech in self.unitInventoryList)
    {
        if ([NSStringFromCGPoint(point) compare:NSStringFromCGPoint(newTech.myLoc)] == NSOrderedDescending) {
            return index;
        }
        index++;
    }
    return index;
}

#pragma mark - NSObject Methods

-(NSString*) description
{
    return [NSString stringWithFormat:@"UnitInventory: count = %@, history = %@", @(self.count), self.unitInventoryList];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
//    NSDictionary* tempInv = [[NSDictionary alloc] initWithDictionary:unitInventory];
    NSArray* tempInvList = [[NSArray alloc] initWithArray:_unitInventoryList];
//    [aCoder encodeObject:tempInv forKey:kUnitInventoryKey];
    [aCoder encodeObject:tempInvList forKey:kUnitInventoryListKey];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
//        unitInventory = [[NSMutableDictionary alloc] initWithDictionary:[aDecoder decodeObjectForKey:kUnitInventoryKey]];
        _unitInventoryList = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:kUnitInventoryListKey]];
    }
    return self;
}

-(CGFloat) getMakeRateForStocktype: (stockType) theType
{
    CGFloat theRate = 0.0;
    CGFloat theBOMAmt = 0.0;
    CGFloat theMakeRate = 0.0;

    for (int j=0; j<_unitInventoryList.count; j++) // step through each unit
    {
        NewTech *aUnit = _unitInventoryList[j];
        if ((aUnit.myStatus == repairingHalf) || (aUnit.myStatus == operating)) {
            theRate = aUnit.myProduceRate;
            theBOMAmt = [aUnit.makerBOM[theType] floatValue];
            theMakeRate += theRate * theBOMAmt;
        }
    }
    return theMakeRate;
}

-(CGFloat) getTakeRateForStocktype: (stockType) theType
{
    CGFloat theRate = 0.0;
    CGFloat theBOMAmt = 0.0;
    CGFloat theTakeRate = 0.0;
    
    for (int j=0; j<_unitInventoryList.count; j++) // step through each unit
    {
        NewTech *aUnit = _unitInventoryList[j];
        if ((aUnit.myStatus == repairingHalf) || (aUnit.myStatus == operating)) {
            theRate = aUnit.myProduceRate;
            theBOMAmt = [aUnit.takerBOM[theType] floatValue];
            theTakeRate += theRate * theBOMAmt;
            theRate = aUnit.myWearoutRate / 100.0;
            theBOMAmt = [aUnit.repairBOM[theType] floatValue];
            theTakeRate += theRate * theBOMAmt;
        }
    }
    return theTakeRate;
}

-(CGFloat) getNewRateForStocktype: (stockType) theType
{
    CGFloat theRate = 0.0;
    CGFloat theBOMAmt = 0.0;
    CGFloat theNewMakeRate = 0.0;
    
    for (int j=0; j<_unitInventoryList.count; j++) // step through each unit
    {
        NewTech *aUnit = _unitInventoryList[j];
        if ((aUnit.myStatus != repairingHalf) && (aUnit.myStatus != operating)) {
            theRate = aUnit.myProduceRate;
            theBOMAmt = [aUnit.makerBOM[theType] floatValue];
            theNewMakeRate += theRate * theBOMAmt;
        }
    }
    return theNewMakeRate;
}
@end
