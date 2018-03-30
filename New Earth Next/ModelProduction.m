//
//  ModelProduction.m
//  junk
//
//  Created by Scott Alexander on 7/23/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "ModelProduction.h"
#import "AppDelegate.h"
#import "NENotification.h"
#import "NeNotifications.h"
#import "Globals.h"

@interface ModelProduction()
@property NENotification* theMessage;
@property NewEarthGlobals* myGlobals;
@property NeNotifications* neNotes;

@end

@implementation ModelProduction
@synthesize Units; //, theGlobals;

#pragma mark-Initialization methods

-(id) init
{
    self = [super init];
    if (self) {
        _myGlobals =  [NewEarthGlobals sharedSelf];
        _neNotes = [NeNotifications sharedSelf];

//        theGlobals = [[NewEarthGlobals alloc] init];
    }
    return self;
}

#pragma mark-Public methods

-(void) doProduction: (UnitInventory*) myUnits
{
    //    NSMutableDictionary* theUnits;
    //    theUnits = Units.unitInventory;
    
    NewTech* unit = [[NewTech alloc] init];
    
    /*
     if(theUnits)
     {
     for(NSString* aKey in theUnits)
     {
     unit = [theUnits objectForKey:aKey];
     NSLog(@"%@", [unit printMe]);
     [self doUnitProduction:unit];
     }
     }
     */
    
    if ([myUnits count] > 0)
    {
        for (NSInteger i = 0; i < [myUnits count]; i++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: i inSection:0];
            unit = [myUnits unitAtIndexPath:indexPath];
            NSLog(@"%@", [unit printMe]);
            [self doUnitProduction:unit];
        }
    }
    else { NSLog(@"doProduction ... have no units in warehouse");}
}

-(CGFloat) roundToThreePlaces: (CGFloat) theFloat
{
    NSInteger locInt = theFloat * 1000 + 0.5;
    CGFloat theReturn = theFloat;
    theReturn = locInt / 1000.0;
//    theReturn *= 1000.0;
    return theFloat; // theReturn;
}

-(CGFloat) startPositionForRow: (CGFloat) rowLoc
{
    CGFloat theStart;
//    if (!theGlobals) {
//        theGlobals = [[NewEarthGlobals alloc] init];
//    }
    
    theStart = _myGlobals.gridXOrigin - (fmod((int)((rowLoc - _myGlobals.gridYOrigin) / (_myGlobals.gridSpacing)), 2.0) == 0.0 ? 0.0 : _myGlobals.gridSpacing / 2.0);
    theStart = [self roundToThreePlaces:theStart];
    return theStart;
}

// translates a tap point onto a grid tile
-(CGPoint) positionInGrid:(CGPoint) theLoc
{
    CGPoint myLocalLoc = theLoc;
    return myLocalLoc;
}

// translates a tap point onto a grid tile
-(CGPoint) tileVertexForPosition:(CGPoint) theLoc
{
    CGFloat yPos = (CGFloat)(((int)((theLoc.y - _myGlobals.gridYOrigin) / _myGlobals.gridSpacing))*_myGlobals.gridSpacing);
    yPos += _myGlobals.gridYOrigin;
//    yPos = [self roundToThreePlaces:yPos];

    CGFloat xPos = (CGFloat)((int)((theLoc.x - [self startPositionForRow:yPos]) / _myGlobals.gridSpacing)*_myGlobals.gridSpacing);
    xPos += [self startPositionForRow:yPos];// +_theGlobals;
//    xPos = [self roundToThreePlaces:xPos];
    
    CGPoint myLocalLoc = CGPointMake(xPos, yPos);
    if ([_myGlobals.geoTileList objectForKey:NSStringFromCGPoint(myLocalLoc)]) {
        //NSLog(@"is a real vertex");
        return myLocalLoc;
    }
    NSLog(@"================ is not a real vertex");
    return myLocalLoc;
}

// enforce rules to prevent placing items atop others or NOGO areas
-(CGPoint) nearestAvailablePositionInGrid: (CGPoint) theLoc
{
    CGPoint myLocalLoc = theLoc;
    return myLocalLoc;
}

#pragma mark-Private methods

-(BOOL)calcSiteScore:(CGPoint)aLoc forUnit:(NewTech*)aUnit
{
    BOOL returnValue = NO;

    if (aUnit.myStatus == isnew) {
        
        // get the clear area
        aUnit.myClear = [self calcSiteClearScoreForUnit:aUnit];
        
        // get the clean area
        aUnit.myClean = [self calcSiteCleanScoreForUnit:aUnit];
        
        // get the smooth area
        aUnit.mySmooth = [self calcSiteSmoothScoreForUnit:aUnit];
        
        // get the connect area
        // get distance to nearest utility source (all of the required ones)
        // find nearest waste, water, power (depends on unit type for requirements)
        aUnit.myConnected = [self getUtilConnectValue:aUnit];
    }
    
    returnValue = (aUnit.myClean + aUnit.myClear + aUnit.mySmooth + aUnit.myConnected > 0);
    
    return returnValue;
}

// find utilities near unit
-(NSInteger) getUtilConnectValue:(NewTech*) aUnit
{
    if (aUnit.myConnected > 0) {
        return 0;
    }
    return 15;
}

// rect is the area to be surveyed from multiple data maps
// of type selects the maps
-(NSInteger) getSiteValue:(CGRect)theRect ofType:(NSInteger)futureEnum
{
    NSInteger theReturnValue = 0;
    
    switch (futureEnum)
    {
        case 0:
            // smooth the terrain ... large slopes
            theReturnValue =  5;
        case 1:
            // clear trees and boulders from area
            theReturnValue = 10;
        case 2:
            // clean the area of pollution, hazardous materials, etc.
            theReturnValue = 20;
            break;
        default:
            // hmmm not really but could be to build transmission lines from power station to unit
            theReturnValue =  0;
            break;
    }
    return theReturnValue;
}

-(NSUInteger) calcSiteSmoothScoreForUnit:(NewTech*) theUnit
{
    NSInteger smoothScore = 0;

    // get the area to smooth (level)
    CGFloat unitRadiusAtMapScale = theUnit.myEnvelope / 2.0 * _myGlobals.mapScale;
    CGFloat envArea = (CGFloat)(int)(M_PI * unitRadiusAtMapScale * unitRadiusAtMapScale);
    
    // get the tile this unit resides in
    CGPoint theTileID = [self tileVertexForPosition:theUnit.myLoc];
    NSMutableDictionary* theTileList = _myGlobals.geoTileList;
    GeoTile* theTileToUse = [theTileList objectForKey: NSStringFromCGPoint(theTileID)];
    
    smoothScore = envArea;

    if (theTileToUse) {
        CGFloat smoothDepth = theUnit.mySize.width;
        CGFloat smoothWidth = theUnit.mySize.height;
        CGFloat theRatio = MAX(smoothDepth, smoothWidth) / MIN(smoothDepth, smoothWidth);
        smoothDepth = sqrt(envArea / theRatio);
        smoothWidth = smoothDepth * theRatio;
        
        CGFloat smoothVolume = smoothDepth * tan(theTileToUse.slope * M_PI / 180) * smoothWidth * smoothDepth / 2.0;
        
        smoothScore = smoothVolume;
    }
    
    return MAX(0.1, smoothScore);
}

-(NSUInteger) calcSiteClearScoreForUnit:(NewTech*) theUnit
{
    // get the area to evaluate
    CGFloat unitRadiusAtMapScale = theUnit.myEnvelope / 2.0 * _myGlobals.mapScale;
    CGFloat envArea = (CGFloat)(int)(M_PI * unitRadiusAtMapScale * unitRadiusAtMapScale);
    CGFloat clearScore = envArea;
    
    // get the tile this unit resides in
    
    CGPoint theTileID = [self tileVertexForPosition:theUnit.myLoc];
    NSMutableDictionary* theTileList = _myGlobals.geoTileList;
    GeoTile* theTileToUse = [theTileList objectForKey: NSStringFromCGPoint(theTileID)];
    
    if (theTileToUse)
    {
        clearScore = theTileToUse.roughness / 100.0 * envArea;
        clearScore = MAX(0.1, clearScore);
    }
    return clearScore;
}

-(NSUInteger) calcSiteCleanScoreForUnit:(NewTech*) theUnit
{
    // get the area to evaluate
    CGFloat unitRadiusAtMapScale = theUnit.myEnvelope / 2.0 * _myGlobals.mapScale;
    CGFloat envArea = (CGFloat)(int)(M_PI * unitRadiusAtMapScale * unitRadiusAtMapScale);
    CGFloat cleanScore = envArea;
    
    // get the tile this unit resides in
    
    CGPoint theTileID = [self tileVertexForPosition:theUnit.myLoc];
    NSMutableDictionary* theTileList = _myGlobals.geoTileList;
    GeoTile* theTileToUse = [theTileList objectForKey: NSStringFromCGPoint(theTileID)];
    
    if (theTileToUse)
    {
        CGFloat tileSqMeters = _myGlobals.gridSpacing*_myGlobals.gridSpacing;
        CGFloat tileTotalToxic = (theTileToUse.toxin01 + theTileToUse.toxin02 + theTileToUse.toxin03 + theTileToUse.toxin04);
        CGFloat tileMixToxic01 = (theTileToUse.toxin01 / tileTotalToxic);
        CGFloat tileMixToxic02 = (theTileToUse.toxin02 / tileTotalToxic);
        CGFloat tileMixToxic03 = (theTileToUse.toxin03 / tileTotalToxic);
        CGFloat tileMixToxic04 = (theTileToUse.toxin04 / tileTotalToxic);
        
        CGFloat toxinMax = tileSqMeters * tileTotalToxic;
        CGFloat toxinClean = envArea * tileTotalToxic;
        
        CGFloat randomClean = arc4random() % 100 / 100.0 - 0.5; // this makes the placement of toxin random within tile rather than uniform
        cleanScore = toxinClean * (randomClean * 0.5 + 1); // standard toxic units
        
        CGFloat toxinLeft = toxinMax - toxinClean;
        CGFloat newToxinTotal = toxinLeft / tileSqMeters;
        
        theTileToUse.toxin01 = MAX(0, newToxinTotal * tileMixToxic01);
        theTileToUse.toxin02 = MAX(0, newToxinTotal * tileMixToxic02);
        theTileToUse.toxin03 = MAX(0, newToxinTotal * tileMixToxic03);
        theTileToUse.toxin04 = MAX(0, newToxinTotal * tileMixToxic04);
    }
    return cleanScore;
}

-(void) doSitePreparation:(NewTech*)aUnit
{
    if (aUnit.myClean > 0)
    { // clean up pollution and toxins
        // need to resolve where to put the waste products
        // some can't be destroyed (radioactive, heavy metals)
        CGFloat newMaterial = [aUnit.myStockpiles[materialStock] floatValue];
        newMaterial += (aUnit.myClean <= aUnit.myCleanRate ? aUnit.myClean : aUnit.myCleanRate);
        aUnit.myStockpiles[materialStock] = [NSNumber numberWithFloat:newMaterial];

        aUnit.myClean -= aUnit.myCleanRate;

        if (aUnit.myClean < 0) { aUnit.myClean = 0; }
    }
    else if (aUnit.myClear > 0)
    { // clear rocks and trees
        // trees become resource
        // rocks become resource or get piled somewhere
        CGFloat newMaterial = [aUnit.myStockpiles[materialStock] floatValue];
        newMaterial += (aUnit.myClear <= aUnit.myClearRate ? aUnit.myClear : aUnit.myClearRate);
        aUnit.myStockpiles[materialStock] = [NSNumber numberWithFloat:newMaterial];

        aUnit.myClear -= aUnit.myClearRate;

        if (aUnit.myClear < 0) { aUnit.myClear = 0; }
    }
    else if (aUnit.mySmooth > 0)
    { // smooth out rough areas for foundation
        CGFloat newMaterial = [aUnit.myStockpiles[materialStock] floatValue];
        newMaterial += (aUnit.mySmooth <= aUnit.mySmoothRate ? aUnit.mySmooth : aUnit.mySmoothRate);
        aUnit.myStockpiles[materialStock] = [NSNumber numberWithFloat:newMaterial];
        
        aUnit.mySmooth -= aUnit.mySmoothRate;

        if (aUnit.mySmooth < 0) { aUnit.mySmooth = 0; }
    }
    else {
        aUnit.myConnected -= aUnit.myConnectRate;
        if (aUnit.myConnected <=0) { // connect to utilities for operation
            aUnit.myConnected = 0;
            aUnit.myStatus = building;
        }
    }
}

-(void) doUnitProduction:(NewTech*) aUnit
{

    if(!aUnit) return;
    
    NSTimeInterval twentyFourHours = 60.0 * 60.0 * 24.0;
    NSDate* now = [NSDate date];
    NSDate* theDate = [now dateByAddingTimeInterval: twentyFourHours * _myGlobals.dayOfContract];

    _theMessage = [[NENotification alloc] initNotificationOnDay:0 from:fromHome type:statusGood content:@"" date:[NSDate date] isRemote:NO];
    _theMessage.message = @"";
    _theMessage.day = _myGlobals.dayOfContract;
    _theMessage.date = theDate;

    //CGFloat rateMultiplier = 1.0;
    
    switch (aUnit.myStatus) {
        case isnew:
            // if here because placing unit then show POPUP
            if ((aUnit.myLoc.x) < 0 || (aUnit.myLoc.y < 0)) { return; } // still not placed
            if ([self calcSiteScore:aUnit.myLoc forUnit: aUnit]) {
                aUnit.myStatus = clearing;
                _theMessage.message = [NSString stringWithFormat: @"Site preparation started, %@ is clearing.", aUnit.myName];
                _theMessage.type = info;
            }
            else break;
            
        case clearing:
            // increment preparation fields (clean, clear, smooth, connect)
            [self doSitePreparation: aUnit];
            if (aUnit.myClear <= 0) {
                aUnit.myStatus = cleaning;
                _theMessage.message = [NSString stringWithFormat: @"%@ site is cleared", aUnit.myName];
                _theMessage.type = info;
            }
            break;
            
        case cleaning:
            // increment preparation fields (clean, clear, smooth, connect)
            [self doSitePreparation: aUnit];
            if (aUnit.myClean <= 0) {
                aUnit.myStatus = smoothing;
                _theMessage.message = [NSString stringWithFormat: @"%@ site is cleaned", aUnit.myName];
                _theMessage.type = info;
            }
            break;
            
        case smoothing:
            // increment preparation fields (clean, clear, smooth, connect)
            [self doSitePreparation: aUnit];
            if (aUnit.mySmooth <= 0) {
                aUnit.myStatus = connecting;
                _theMessage.message = [NSString stringWithFormat: @"%@ site is leveled", aUnit.myName];
                _theMessage.type = info;
            }
            break;
            
        case connecting:
            // increment preparation fields (clean, clear, smooth, connect)
            [self doSitePreparation: aUnit];
            if (aUnit.myConnected <= 0) {
                aUnit.myStatus = building;
                _theMessage.message = [NSString stringWithFormat: @"%@ site connected to power.", aUnit.myName];
                _theMessage.type = info;
            }
            break;
            
        case preparing:
            // increment preparation fields (clean, clear, smooth, connect)
            [self doSitePreparation: aUnit];
            if (aUnit.myClean + aUnit.myClear + aUnit.mySmooth + aUnit.myConnected <= 0) {
                aUnit.myStatus = building;
                _theMessage.message = [NSString stringWithFormat: @"Site preparation complete, %@ is building.", aUnit.myName];
                _theMessage.type = info;
            }
            break;
            
        case building:
            // increment construction field
            aUnit.myHealth += aUnit.myBuildRate;
            if (aUnit.myHealth >= 100) {
                aUnit.myHealth = 100;
                aUnit.myStatus = operating;
                _theMessage.message = [NSString stringWithFormat: @"%@ is now operating.", aUnit.myName];
                _theMessage.type = statusGood;
            }
            break;
            
        case standby:
            // increment construction field (unit wearing out)
            aUnit.myHealth -= aUnit.myWearoutRate;
            if (aUnit.myHealth < 0) {
                aUnit.myHealth = 0;
            }
            
        case operating:
            // increment operation fields (depends on the unit type)
            aUnit.myHealth -= aUnit.myWearoutRate;
            if (aUnit.myHealth < 70) {
                aUnit.myStatus = repairingHalf;
                _theMessage.message = [NSString stringWithFormat: @"%@ needs repair!  ", aUnit.myName];
                _theMessage.type = statusBad;
            }
            
            // actually each unit is unique in what it makes and so will require more logic here
            // producing resources (food, materials, etc.)
            break;
            
        case repairingHalf:
            // increment construction field at repair rate
            // can only repair if have materials
            // check to see if completely repaired
            if (aUnit.myHealth >= 70) {
                aUnit.myStatus = repairingFull;
            }
            
            aUnit.myHealth -= aUnit.myWearoutRate;
            if (aUnit.myHealth<40) {
                aUnit.myStatus = standby;
                _theMessage.message = [NSString stringWithFormat: @"%@ needs repair!  Now in STANDBY mode.", aUnit.myName];
                _theMessage.type = statusBad;
                break;
            }
            // will do produce if health not too slow so don't break here
            
        case repairingFull:
            // increment construction field at repair rate
            // can only repair if have materials
            // check to see if completely repaired
            if (aUnit.myHealth >= 100) {
                aUnit.myStatus = operating;
                _theMessage.message = [NSString stringWithFormat: @"%@ is now operating.", aUnit.myName];
                _theMessage.type = statusGood;
            }
            
            aUnit.myHealth -= aUnit.myWearoutRate;
            if (aUnit.myHealth<70) {
                aUnit.myStatus = repairingHalf;
                break;
            }
            // will do produce if health not too slow so don't break here
            
        default:
            break;
    }
    
    _theMessage.source = aUnit.getMyMessageSource;
    if (![_theMessage.message isEqualToString:@""]) {
        NSLog(@"BBBB %@: thisDay: %ld eventDate: %@", _theMessage.message, (long)_theMessage.day, _theMessage.date);
        [_neNotes addNote:_theMessage];

    }

}

#pragma mark-Methods to be Deleted Maybe
// TODO: not sure why this is here ... may have been replaced by method inside NewTech class
-(void) updateMyUsage:(NewTech*) mUnit uRate: (CGFloat) mRate uLab: (CGFloat) mLabor uStruct: (CGFloat) mStruct uComp: (CGFloat) mComp
          uMater: (CGFloat) mMater uSupp: (CGFloat) mSupp uWater: (CGFloat) mWater uPower: (CGFloat) mPower uFood: (CGFloat) mFood uAir: (CGFloat) mAir
{

}

// TODO: not sure why this is here ... may have been replaced by method inside NewTech class
-(void) calculateMakerForUnit: (NewTech*) aUnit
{
    // totals the TAKER items for each unit
    // usage is not dependent upon location
    // usage is adjusted by the NewTech class based upon supply
    
}

// TODO: not sure why this is here ... may have been replaced by method inside NewTech class
-(void) calculateTakerForUnit: (NewTech*) aUnit
{
    // totals the TAKER items for each unit
    // usage is not dependent upon location
    // usage is adjusted by the NewTech class based upon supply
    
}

// TODO: not sure why this is here ... may have been replaced by method inside NewTech class
-(void) createUnits
{
    // OBSOLETE CAN ERASE SOME DAY
    
    NewTech* tempUnit = [[NewTech alloc] init];
    
    CGPoint aLoc = CGPointMake(0, 0);
    NSString* theKey = [self makeUnitKey:aLoc];
    
    tempUnit = [[NewTech alloc] init];
    
    if(!Units){
        Units = [[NSMutableDictionary alloc] init];
    }
    
    [Units setObject:[self makeUnit:@"UnitOne" ofType:tree ofSize:CGSizeMake(20, 20) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(100, 100);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"UnitTwo" ofType:power ofSize:CGSizeMake(10, 10) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(20, 50);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"UnitThree" ofType:meat ofSize:CGSizeMake(20, 50) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(200, 150);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"Unit04" ofType:plant ofSize:CGSizeMake(200, 100) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(300, 300);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"Unit05" ofType:water ofSize:CGSizeMake(50, 50) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(350, 0);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"Unit06" ofType:air ofSize:CGSizeMake(10, 50) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(0, 250);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"Unit07" ofType:mine ofSize:CGSizeMake(90, 30) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(0, 200);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"Unit08" ofType:home ofSize:CGSizeMake(30, 30) wasPlaced:NO] forKey:theKey];
    
    aLoc = CGPointMake(0, 200);
    theKey = [self makeUnitKey:aLoc];
    [Units setObject:[self makeUnit:@"Unit09" ofType:waste ofSize:CGSizeMake(60, 10) wasPlaced:NO] forKey:theKey];
    

}

// TODO: not sure why this is here ... may have been replaced by method inside NewTech class
-(NewTech*) makeUnit:(NSString*) aName ofType:(itemType) aType ofSize:(CGSize) aSize wasPlaced:(BOOL)placed
{
    NewTech* newUnit = [[NewTech alloc] init];
    newUnit.myName = aName;
    newUnit.myType = aType;
    newUnit.mySize = aSize;
    newUnit.myPlaced = placed;
    return newUnit;
}

// TODO: not sure why this is here ... may have been replaced by method inside NewTech class
-(NSString*) makeUnitKey: (CGPoint) theLocation
{
//    NSLog(@"%@", NSStringFromCGPoint(theLocation));
    return NSStringFromCGPoint(theLocation);
}


@end
