//
//  NewTech.m
//  New Earth
//
//  Created by Scott Alexander on 7/5/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "NewTech.h"
#import "NENotification.h"
#import "NeNotifications.h"
#import "Globals.h"
#import "ModelProduction.h"
#import "CapTech.h"
// At top of file


NSString* const kMySizeKey = @"MySizeKey";
NSString* const kMyLocKey = @"MyLocKey";
NSString* const kMyCostKey = @"MyCostKey";
NSString* const kMyTypeKey = @"MyTypeKey";
NSString* const kMyStatusKey = @"MyStatusKey";
NSString* const kMyNameKey = @"MyNameKey";
NSString* const kMyPlacedKey = @"MyPlacedKey";
NSString* const kMyIDKey = @"MyIDKey";
NSString* const kMyCleanKey = @"MyCleanKey";
NSString* const kMyClearKey = @"MyClearKey";
NSString* const kMySmoothKey = @"MySmoothKey";
NSString* const kMyConnectedKey = @"MyConnectedKey";
NSString* const kMyBuildRateKey = @"MyBuildRateKey";
NSString* const kMyRepairRateKey = @"MyRepairRateKey";
NSString* const kMyProduceRateKey = @"MyProduceRateKey";
NSString* const kMyWearoutRateKey = @"MyWearoutRateKey";
NSString* const kMyConnectRateKey = @"MyConnectRateKey";
NSString* const kMySmoothRateKey = @"MySmoothRateKey";
NSString* const kMyClearRateKey = @"MyClearRateKey";
NSString* const kMyCleanRateKey = @"MyCleanRateKey";
NSString* const kMyEnvelopeKey = @"MyEnvelopeKey";
NSString* const kMyHealthKey = @"MyHealthKey";
NSString* const kpowerUsageKey = @"powerUsageKey";
NSString* const kstructureUsageKey = @"structureUsageKey";
NSString* const kcomponentUsageKey = @"componentUsageKey";
NSString* const ksupplyUsageKey = @"supplyUsageKey";
NSString* const kmaterialUsageKey = @"materialUsageKey";
NSString* const kwaterUsageKey = @"waterUsageKey";
NSString* const kairUsageKey = @"airUsageKey";
NSString* const kfoodUsageKey = @"foodUsageKey";
NSString* const klaborUsageKey = @"laborUsageKey";

@interface NewTech()
@property NENotification* theMessage;
@property NewEarthGlobals* myGlobals;
@property NeNotifications* neNotes;

@end

@implementation NewTech
@synthesize mySize, myLoc, myHealth, myColorIs, myCreateDate;
@synthesize myBuildRate, myRepairRate, myProduceRate, myWearoutRate, myCost;
@synthesize myType, itemIcon;
@synthesize myStatus;
@synthesize myName;
@synthesize myPlaced;
@synthesize myID;
@synthesize myClean, myClear, mySmooth, myConnected;
@synthesize myCleanRate, myClearRate, mySmoothRate, myConnectRate, myEnvelope, mapScale;
@synthesize makerBOM, takerBOM, repairBOM, myStockpiles;
@synthesize myClass;
@synthesize myTileItem;
@synthesize delays, source, pathsToSources;

#pragma mark - Initialization methods

-(id) initWithType:(itemType) aType
           withLoc:(CGPoint) aLoc
            withID:(id) aID
          withSize:(CGSize) aSize
        withHealth:(float) aHealth
            onDate:(NSDate*) aCreateDate
          withCost:(float) aCost
         withColor:(UIColor*) aColorIs //not really used
        withStatus:(itemStatus) aStatus
          withName:(NSString*) aName
         wasPlaced:(BOOL) aPlaced
         withClean:(NSInteger) aClean
         withClear:(NSInteger) aClear
        withSmooth:(NSInteger) aSmooth
     withConnected:(NSInteger) aConnected
     withBuildRate:(NSInteger) aBuildRate
    withRepairRate:(NSInteger) aRepairRate
   withProduceRate:(NSInteger) aProduceRate
   withWearoutRate:(NSInteger) aWearoutRate
     withCleanRate:(NSInteger) aCleanRate
     withClearRate:(NSInteger) aClearRate
    withSmoothRate:(NSInteger) aSmoothRate
   withConnectRate:(NSInteger) aConnectRate
      withEnvelope:(float) aEnvelope
{
    self = [super init];
    if(self)
    {
        myType = aType;
        itemIcon = [self getMyIcon];
        mySize = aSize;
        myLoc = aLoc;
        myHealth = aHealth;
        myCreateDate = aCreateDate;
        myCost = aCost;
        myColorIs = aColorIs;
        myStatus = aStatus;
        myName = aName;
        myPlaced = aPlaced;
        myID = aID;
        myClean = aClean;
        myClear = aClear;
        mySmooth = aSmooth;
        myConnected = aConnected;
        myBuildRate = aBuildRate;
        myRepairRate = aRepairRate;
        myProduceRate = aProduceRate;
        myWearoutRate = aWearoutRate;
        myCleanRate = aCleanRate;
        myClearRate = aClearRate;
        mySmoothRate = aSmoothRate;
        myConnectRate = aConnectRate;
        myEnvelope = aEnvelope;
        myStockpiles = [[NSMutableArray alloc] initWithCapacity:10];
        takerBOM = [[NSMutableArray alloc] initWithCapacity:10];
        makerBOM = [[NSMutableArray alloc] initWithCapacity:10];
        repairBOM = [[NSMutableArray alloc] initWithCapacity:10];
        [self fillStockBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
        [self fillTakerBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
        [self fillMakerBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
        [self fillRepairBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
        
        int delays[3] = {0, 0, 0};
        source = [[segment alloc] init];
        pathsToSources = [[NSMutableArray alloc] init];
    }
    _theMessage = [[NENotification alloc] initNotificationOnDay:0 from:fromPlant type:info content:@"" date:nil isRemote:NO];
    _myGlobals = [NewEarthGlobals sharedSelf];
    _neNotes = [NeNotifications sharedSelf];
    
    return self;
}

-(id) initWithUnit:(NewTech*) origUnit
{
    self = [super init];
    if (self) {
        myType = origUnit.myType;
        itemIcon = origUnit.itemIcon;// @"Image-1";
        mySize = origUnit.mySize;
        myCost = origUnit.myCost;
        myColorIs = origUnit.myColorIs;
        myName = origUnit.myName;
        myID = origUnit.myID;
        myClean = origUnit.myClean;
        myClear = origUnit.myClear;
        mySmooth = origUnit.mySmooth;
        myConnected = origUnit.myConnected;
        myBuildRate = origUnit.myBuildRate;
        myRepairRate = origUnit.myRepairRate;
        myProduceRate = origUnit.myProduceRate;
        myWearoutRate = origUnit.myWearoutRate;
        myCleanRate = origUnit.myCleanRate;
        myClearRate = origUnit.myClearRate;
        mySmoothRate = origUnit.mySmoothRate;
        myConnectRate = origUnit.myConnectRate;
        myEnvelope = origUnit.myEnvelope;
        myHealth = origUnit.myHealth;
        
        myLoc = CGPointMake(0, 0);
        myCreateDate = [NSDate date];
        myStatus = isnew;
        myPlaced = NO;
        
        myStockpiles = [[NSMutableArray alloc] initWithArray:origUnit.myStockpiles];
        takerBOM = [[NSMutableArray alloc] initWithArray:origUnit.takerBOM];
        makerBOM = [[NSMutableArray alloc] initWithArray:origUnit.makerBOM];
        repairBOM = [[NSMutableArray alloc] initWithArray:origUnit.repairBOM];
        int delays[3] = {0, 0, 0};
        source = [[segment alloc] init];
        pathsToSources = [[NSMutableArray alloc] init];
    }
    _theMessage = [[NENotification alloc] initNotificationOnDay:0 from:fromPlant type:info content:@"" date:nil isRemote:NO];
    _myGlobals = [NewEarthGlobals sharedSelf];
    _neNotes = [NeNotifications sharedSelf];
    return self;
}

+(instancetype) unitLikeUnit:(NewTech*) copyUnit
{
    NewTech* aNewUnit = [[self alloc] initWithType:copyUnit.myType
                                           withLoc:copyUnit.myLoc
                                            withID:copyUnit.myID withSize:copyUnit.mySize withHealth:copyUnit.myHealth
                                            onDate:copyUnit.myCreateDate withCost:copyUnit.myCost withColor:copyUnit.myColorIs
                                        withStatus:copyUnit.myStatus
                                          withName:copyUnit.myName
                                         wasPlaced:copyUnit.myPlaced withClean:copyUnit.myClean withClear:copyUnit.myClear withSmooth:copyUnit.mySmooth withConnected:copyUnit.myConnected withBuildRate:copyUnit.myBuildRate withRepairRate:copyUnit.myRepairRate withProduceRate:copyUnit.myProduceRate withWearoutRate:copyUnit.myWearoutRate withCleanRate:copyUnit.myCleanRate withClearRate:copyUnit.myClearRate withSmoothRate:copyUnit.mySmoothRate withConnectRate:copyUnit.myConnectRate withEnvelope:copyUnit.myEnvelope
                         ];
    
    aNewUnit.itemIcon = copyUnit.itemIcon;// @"Image-1";
    aNewUnit.myCreateDate = [NSDate date];
    aNewUnit.myLoc = CGPointMake(-100, -100); // TODO: this needs to be a routine that makes a unique location
    aNewUnit.myPlaced = NO;
    aNewUnit.myStatus = (itemStatus) isnew;
    aNewUnit.myName = [NSString stringWithFormat: @"%@ copy", copyUnit.myName];
    aNewUnit.myStockpiles = [[NSMutableArray alloc] initWithCapacity:10];
    aNewUnit.takerBOM = [[NSMutableArray alloc] initWithArray:copyUnit.takerBOM];
    aNewUnit.makerBOM = [[NSMutableArray alloc] initWithArray:copyUnit.makerBOM];
    aNewUnit.repairBOM = [[NSMutableArray alloc] initWithArray:copyUnit.repairBOM];
    [aNewUnit fillStockBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
    [aNewUnit fillMakerBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
    [aNewUnit fillRepairBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
    [aNewUnit fillMakerBOMStruct:0 comp:0 supp:0 matl:0 powr:0 watr:0 air:0 food:0 labr:0];
        
    return aNewUnit;
}

#pragma mark - Display Methods

-(noteSource) getMyMessageSource
{
    noteSource retVal = 0;
    
    switch (myType)
    {
        case plant: retVal = fromPlant; break; // plant food
        case meat: retVal = fromMeat; break; // animal food (fish, poultry, etc.)
        case air: retVal = fromAir; break; // generates breathable air
        case water: retVal = fromWater; break; // generates potable water
        case mine: retVal = fromMine; break; // mining, etc to get minerals
        case power: retVal = fromPower; break; // converts input to useable power
        case waste: retVal = fromWaste; break; // waste treatment
        case civil: retVal = fromCivil; break; // services police, fire, admin
        case home: retVal = fromHome; break; // homestead
        case tree: retVal = fromTree; break; // trees ... non food producing but may provide lumber or fruit
        case fab: retVal = fromFab; break; // generates components, supplies, structure material
        default: retVal = news; break; // error ... should never get here
    }
    return retVal;
}

-(NSString*) getMyIcon
{
    NSString* retVal = 0;
    
    switch (myType)
    {
        case plant: retVal = @"ResourceGrainIcon"; break; // plant food
        case meat: retVal = @"ResourceShrimpIcon"; break; // animal food (fish, poultry, etc.)
        case air: retVal = @"ToxinRadioactiveIcon"; break; // generates breathable air
        case water: retVal = @"ToxinLiquidIcon"; break; // generates potable water
        case mine: retVal = @"ResourceRockRawIcon"; break; // mining, etc to get minerals
        case power: retVal = @"ResourcePowerSolarIcon"; break; // converts input to useable power
        case waste: retVal = @"ToxinGasIcon"; break; // waste treatment
        case civil: retVal = @"flower02_48"; break; // services police, fire, admin
        case home: retVal = @"TechGroupHomeIcon"; break; // homestead
        case tree: retVal = @"ResourceTreesIcon"; break; // trees ... non food producing but may provide lumber or fruit
        case fab: retVal = @"ResourceAluminumRawIcon"; break; // generates components, supplies, structure material
        default: retVal = @"news"; break; // error ... should never get here
    }
    return retVal;
}

-(NSString*) getResourceName:(stockType) theResource
{
    NSString* retValue = @"";
    
    switch (theResource) {
        case airStock:          retValue = @"Air"; break;
        case foodStock:         retValue = @"Food"; break;
        case laborStock:        retValue = @"Labor"; break;
        case powerStock:        retValue = @"Power"; break;
        case waterStock:        retValue = @"Water"; break;
        case supplyStock:       retValue = @"Supply"; break;
        case materialStock:     retValue = @"Material"; break;
        case structureStock:    retValue = @"Structure"; break;
        case componentStock:    retValue = @"Component"; break;
        case happinessStock:    retValue = @"Happiness"; break;
            
        default: retValue = @"UNKNOWN"; break;
    }
    
    return retValue;
}

-(NSString*) getMyStatus
{
    NSString* retValue = @"";
    
    switch (myStatus) {
        case clearing:      retValue = @"Clearing"; break;
        case cleaning:      retValue = @"Cleaning"; break;
        case connecting:    retValue = @"Connecting"; break;
        case repairingHalf: retValue = @"Repair half"; break;
        case repairingFull: retValue = @"Repairing full"; break;
        case preparing:     retValue = @"Preparing"; break;
        case isnew:         retValue = @"IsNew"; break;
        case operating:     retValue = @"Operating"; break;
        case building:      retValue = @"Building"; break;
        case standby:       retValue = @"Standby"; break;
            
        default: retValue = @"UNKNOWN"; break;
    }
    
    return retValue;
}

-(NSString*) getMyType
{
    NSString* retValue = @"";
    
    switch (myType) {
        case plant: retValue = @"PLANT"; break;
        case meat: retValue = @"MEAT"; break;
        case air: retValue = @"AIR"; break;
        case water: retValue = @"WATER"; break;
        case power: retValue = @"POWER"; break;
        case waste: retValue = @"WASTE"; break;
        case civil: retValue = @"CIVIL"; break;
        case home: retValue = @"HOME"; break;
        case tree: retValue = @"TREE"; break;
        case fab: retValue = @"FAB"; break;
            
        default: break;
    }
    return retValue;
}

-(void) setStockpileType:(stockType) theType toValue:(CGFloat) theValue
{
    [self fillStockBOMStruct:0 comp:0 supp:0 matl:theValue powr:0 watr:0 air:0 food:0 labr:0];
    return;
}

#pragma mark - Stockpile Utility Methods

-(void) fillStockBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor
{
    myStockpiles[structureStock] = [NSNumber numberWithFloat:aStructure];
    myStockpiles[componentStock] = [NSNumber numberWithFloat:aComponent];
    myStockpiles[supplyStock] = [NSNumber numberWithFloat:aSupply];
    myStockpiles[materialStock] = [NSNumber numberWithFloat:aMaterial];
    myStockpiles[powerStock] = [NSNumber numberWithFloat:aPower];
    myStockpiles[waterStock] = [NSNumber numberWithFloat:aWater];
    myStockpiles[airStock] = [NSNumber numberWithFloat:aAir];
    myStockpiles[foodStock] = [NSNumber numberWithFloat:aFood];
    myStockpiles[laborStock] = [NSNumber numberWithFloat:aLabor];
}

-(void) fillMakerBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor
{
    makerBOM[structureStock] = [NSNumber numberWithFloat:aStructure];
    makerBOM[componentStock] = [NSNumber numberWithFloat:aComponent];
    makerBOM[supplyStock] = [NSNumber numberWithFloat:aSupply];
    makerBOM[materialStock] = [NSNumber numberWithFloat:aMaterial];
    makerBOM[powerStock] = [NSNumber numberWithFloat:aPower];
    makerBOM[waterStock] = [NSNumber numberWithFloat:aWater];
    makerBOM[airStock] = [NSNumber numberWithFloat:aAir];
    makerBOM[foodStock] = [NSNumber numberWithFloat:aFood];
    makerBOM[laborStock] = [NSNumber numberWithFloat:aLabor];
}

-(void) fillTakerBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor
{
    takerBOM[structureStock] = [NSNumber numberWithFloat:aStructure];
    takerBOM[componentStock] = [NSNumber numberWithFloat:aComponent];
    takerBOM[supplyStock] = [NSNumber numberWithFloat:aSupply];
    takerBOM[materialStock] = [NSNumber numberWithFloat:aMaterial];
    takerBOM[powerStock] = [NSNumber numberWithFloat:aPower];
    takerBOM[waterStock] = [NSNumber numberWithFloat:aWater];
    takerBOM[airStock] = [NSNumber numberWithFloat:aAir];
    takerBOM[foodStock] = [NSNumber numberWithFloat:aFood];
    takerBOM[laborStock] = [NSNumber numberWithFloat:aLabor];
}

-(void) fillRepairBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor
{
    repairBOM[structureStock] = [NSNumber numberWithFloat:aStructure];
    repairBOM[componentStock] = [NSNumber numberWithFloat:aComponent];
    repairBOM[supplyStock] = [NSNumber numberWithFloat:aSupply];
    repairBOM[materialStock] = [NSNumber numberWithFloat:aMaterial];
    repairBOM[powerStock] = [NSNumber numberWithFloat:aPower];
    repairBOM[waterStock] = [NSNumber numberWithFloat:aWater];
    repairBOM[airStock] = [NSNumber numberWithFloat:aAir];
    repairBOM[foodStock] = [NSNumber numberWithFloat:aFood];
    repairBOM[laborStock] = [NSNumber numberWithFloat:aLabor];
}

#pragma mark - Output and Display Methods

-(NSString*) printMyStores
{
    return [NSString stringWithFormat: @"Stor %@ str:%0.1f comp:%0.1f sup:%0.1f mat:%0.1f power:%0.1f water:%0.1f air:%0.1f food:%0.1f lab:%0.1f", myName, [myStockpiles[0] floatValue], [myStockpiles[1] floatValue], [myStockpiles[2] floatValue], [myStockpiles[3] floatValue], [myStockpiles[4] floatValue], [myStockpiles[5] floatValue], [myStockpiles[6] floatValue], [myStockpiles[7] floatValue], [myStockpiles[8] floatValue] ];
}

-(NSString*) printMe
{
    return [NSString stringWithFormat: @"--- %@:%@:%@ %d:%d:%d:%d heal:%0.1f", myName, [self getMyType], [self getMyStatus], (int) myClean, (int) myClear, (int) mySmooth,(int) myConnected, myHealth ];
}

#pragma mark - Private Methods

-(CGFloat)roundToTens: (CGFloat) theNumber
{
    CGFloat locNumb = 0;
    
    locNumb = (CGFloat)(NSInteger)(theNumber / 10);
    locNumb *=10;
    return (CGFloat)locNumb;
}

-(void) placeMe:(id)myID atPoint: (CGPoint) theLoc atScale: (CGFloat) theScale inContext: (CGContextRef) context
{
    // need to save context before doing stuff
    mapScale = 118.29 / 1000;
    
//    CGFloat theDrawScale = theScale * mapScale;
    CGFloat theDrawScale = mapScale;

    UIImage* anIcon = [UIImage imageNamed:itemIcon];

    if (anIcon != nil) { NSLog(@"loaded image: %@", itemIcon); [myTileItem changeMyIcon: anIcon]; }
//    else { NSLog(@"failed loading: <<%@>> for %@", itemIcon, [self getMyType]); }
    
    if(!myTileItem) { NSLog(@"no myTileItem in placeMe"); myTileItem = [[TileItem alloc] initAtLocation: theLoc ofType: anIcon withStartingValue: myHealth]; }
    else {
        [myTileItem showMeAtLoc:theLoc atScale:theDrawScale inContext:context];
        
        [myTileItem.itemIcon setImage:anIcon];
        myTileItem.itemLabel.text = [NSString stringWithFormat:@"%0.0f", myHealth];        
    }

    if (theScale > 1) { [self showMeSmallAtPoint: theLoc atScale: theScale inContext: context]; }
        else          { [self showMeBigAtPoint: theLoc atScale: theScale inContext: context]; }
    
    self.myPlaced = YES;
    
//    NSLog(@"inside PlaceMe name: %@", myName);
    // need to replace the original context

}

-(void) showMeBigAtPoint: (CGPoint)theLoc atScale: (CGFloat)theDrawScale inContext: (CGContextRef)context
{
    // theDrawScale should be the viewScale to keep the icons at a fixed size
    
    UIColor* theColorIs;
    CGRect bigRect;
    
    switch (myStatus) {
        case preparing:
            //            NSLog(@"i am preparing"); // color, shape, image
            theColorIs = [UIColor colorWithRed:0.678 green:1.0 blue:0.184 alpha:1.0];
//            theColorIs = [UIColor lightGrayColor];
//            theColorIs = [UIColor greenColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"Image-1";
            break;
            
        case cleaning:
            //            NSLog(@"i am preparing"); // color, shape, image
            theColorIs = [UIColor colorWithRed:0.678 green:1.0 blue:0.184 alpha:1.0];
//            theColorIs = [UIColor brownColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"StageCleanIcon";
            break;
            
        case clearing:
            //            NSLog(@"i am preparing"); // color, shape, image
            theColorIs = [UIColor colorWithRed:0.627 green:0.322 blue:0.176 alpha:0.75];
//            theColorIs = [UIColor redColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"StageClearIcon";
            break;
            
        case smoothing:
            //            NSLog(@"i am preparing"); // color, shape, image
            theColorIs = [UIColor colorWithRed:0.678 green:1.0 blue:0.184 alpha:1.0];
//            theColorIs = [UIColor orangeColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"StageSmoothIcon";
            break;
            
        case building:
//            NSLog(@"i am building"); // color, shape, image
            theColorIs = [UIColor blueColor];
            theColorIs = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5]; // hot pink
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"StageBuildIcon";
            break;
            
        case connecting:
            //            NSLog(@"i am preparing"); // color, shape, image
            theColorIs = [UIColor colorWithRed:1.0 green:1.0 blue:0.6 alpha:1.0];
//            theColorIs = [UIColor yellowColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"StageConnectIcon";
            break;
            
        case operating:
//            NSLog(@"i am operating"); // color, shape, image
            theColorIs = [UIColor clearColor];
//            theColorIs = [UIColor magentaColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = [self getMyIcon];
            break;
            
        case repairingHalf:
            //            NSLog(@"i am repairing"); // color, shape, image
            theColorIs = [UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:0.5]; // hot pink
//            theColorIs = [UIColor grayColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"Image-2";
            break;
            
        case repairingFull:
            //            NSLog(@"i am repairing"); // color, shape, image
            theColorIs = [UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:0.5]; // hot pink
//            theColorIs = [UIColor blackColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            itemIcon = @"Image-3";
            break;
            
        default:
            theColorIs = [UIColor whiteColor];//[self showMyColor];
            bigRect = CGRectMake(0, 0, 25, 25);
            break;
    }
    
    CGFloat tempX = theLoc.x;
    CGFloat tempY = theLoc.y;
    
    if (myStatus == operating) {
        myColorIs = [self showMyColor];
    } else {
        myColorIs = theColorIs;
    }
    
    CGRect theRectToShow = CGRectMake(tempX-(bigRect.size.width/2.0f)*theDrawScale, tempY-(bigRect.size.height/2.0f)*theDrawScale, (bigRect.size.width)*theDrawScale, (bigRect.size.height)*theDrawScale);
    
    if (theRectToShow.origin.x<0 || theRectToShow.origin.y<0) { return; }
    
    CGContextSaveGState(context);
    
    CGContextBeginPath(context);
//    CGContextAddRect(context, theRectToShow);
    
    [theColorIs setFill];
    [theColorIs setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
    
    UIImage* newIcon = [UIImage imageNamed:itemIcon];
    myTileItem.imageIcon = newIcon;
}

-(void) showMeSmallAtPoint2: (CGPoint)theLoc atScale: (CGFloat)theDrawScale inContext: (CGContextRef)context
{
    CGFloat tempX = [self roundToTens: theLoc.x];
    CGFloat tempY = [self roundToTens: theLoc.y];
    
    tempX = theLoc.x;
    tempY = theLoc.y;
    
    CGFloat scaleVal = _myGlobals.mapScale;
    
    CGRect theRectToShow = CGRectMake(tempX-(mySize.width/2.0f*scaleVal)*theDrawScale, tempY-(mySize.height/2.0f*scaleVal)*theDrawScale, (mySize.width*scaleVal)*theDrawScale, (mySize.height*scaleVal)*theDrawScale);
    
    ModelProduction* mp = [[ModelProduction alloc] init];
    CGPoint theDirLoc = [mp tileVertexForPosition:theLoc];
    __unused CGFloat theDir = [[_myGlobals.geoTileList objectForKey: NSStringFromCGPoint(theDirLoc)] slopeDir];
    
    if (theRectToShow.origin.x<0 || theRectToShow.origin.y<0) { return; }
    
    CGContextSaveGState(context);
    // Rotate the context
//    CGContextTranslateCTM( context, 0.5f * theRectToShow.size.width, 0.5f * theRectToShow.size.height ) ;
//    CGContextRotateCTM(context, theDir * M_PI / 180);
    
    CGContextBeginPath(context);
    CGContextAddRect(context, theRectToShow);
    
    [[self showMyColor] setFill];
    [[self showMyColor] setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
    itemIcon = @"Nothing";
    UIImage* newIcon = [UIImage imageNamed:itemIcon];
    myTileItem.imageIcon = newIcon;

}

//-(void) drawRect:(CGSize) mySize rotated:(CGFloat) tileSlopeDir around:(CGPoint) myLoc atScale: (CGFloat)theDrawScale inContext: (CGContextRef)context
-(void) showMeSmallAtPoint: (CGPoint)theLoc atScale: (CGFloat)theDrawScale inContext: (CGContextRef)context
{
    CGFloat scaleVal = _myGlobals.mapScale;
    ModelProduction* mp = [[ModelProduction alloc] init];
    
    CGPoint temp = [mp tileVertexForPosition: myLoc];
    GeoTile* theTile = (GeoTile*)[_myGlobals.geoTileList objectForKey: NSStringFromCGPoint(temp)];
    CGFloat tileSlopeDir = theTile.slopeDir * M_PI / 180.0;

    // transform mySize so X <= y
    CGSize localSize;
    if (self.mySize.width > self.mySize.height) {
        localSize = CGSizeMake(self.mySize.height, self.mySize.width);
    } else {localSize = self.mySize;}
    
    // calculate the radius of rotation
    CGFloat theRadius = 0.5 * scaleVal * sqrt(
                                                             pow((double) mySize.height, 2.0) +
                                                             pow((double) mySize.width, 2.0)
                                                             );
/*
    CGFloat theRadius = 0.5 * theDrawScale * scaleVal * sqrt(
                                                             pow((double) mySize.height, 2.0) +
                                                             pow((double) mySize.width, 2.0)
                                                             );
*/
    // calculate angle to first vertex
    CGFloat theAngle = atan(localSize.height / localSize.width);

    // calculate vertexes
    double X1 = theRadius * cos(theAngle + tileSlopeDir);
    double Y1 = theRadius * sin(theAngle + tileSlopeDir);
    double X2 = theRadius * cos(M_PI - theAngle + tileSlopeDir);
    double Y2 = theRadius * sin(M_PI - theAngle + tileSlopeDir);
    CGPoint ptA = CGPointMake( X1+myLoc.x, Y1+myLoc.y);
    CGPoint ptB = CGPointMake( X2+myLoc.x, Y2+myLoc.y);
    CGPoint ptC = CGPointMake( -X1+myLoc.x, -Y1+myLoc.y);
    CGPoint ptD = CGPointMake( -X2+myLoc.x, -Y2+myLoc.y);
    
/*
    CGPoint points[4];
    points[0] = ptA;
    points[1] = ptB;
    points[2] = ptC;
    points[3] = ptD;
 
    // 3
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathAddLines(cgPath, &CGAffineTransformIdentity, points, sizeof points / sizeof *points);
    CGPathCloseSubpath(cgPath);
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
 */

    // draw Bezier curve for new Rect (... ooh this should return the rect)
    UIBezierPath* thePath = [UIBezierPath bezierPath];
    [thePath setLineWidth: 3.0];
    [thePath stroke];
    [thePath setLineCapStyle: kCGLineCapSquare];
    [thePath moveToPoint:ptA];
    [thePath addLineToPoint:ptB];
    [thePath addLineToPoint:ptC];
    [thePath addLineToPoint:ptD];
    [thePath closePath];
    
    // 4
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = thePath.CGPath;
    shape.fillColor = [self showMyColor].CGColor;
    
//    shape.path = path.CGPath;
//    shape.fillColor = [UIColor colorWithRed:255/255.0 green:20/255.0 blue:147/255.0 alpha:1].CGColor;
    // 5
//    [self.view.layer addSublayer:shape];
    CGContextSaveGState(context);
    // Rotate the context
    //    CGContextTranslateCTM( context, 0.5f * theRectToShow.size.width, 0.5f * theRectToShow.size.height ) ;
    //    CGContextRotateCTM(context, theDir * M_PI / 180);
    
    CGContextBeginPath(context);
    CGContextAddPath(context, thePath.CGPath);
    
    [[self showMyColor] setFill];
    [[self showMyColor] setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
    itemIcon = @"Nothing";
    UIImage* newIcon = [UIImage imageNamed:itemIcon];
    myTileItem.imageIcon = newIcon;
    
}

-(void) showMyEnvelope:(id)myID atPoint:(CGPoint) theLoc atScale:(CGFloat) theScale inContext:(CGContextRef)context
{
    // need to save context before doing stuff
    CGFloat scaleVal = _myGlobals.mapScale;
//    mapScale = 118.29 / 1000;
    
//    CGFloat theDrawScale = theScale * mapScale;
    CGFloat theDrawScale = scaleVal;

    // round the pick location
    CGFloat tempX = [self roundToTens: theLoc.x];// * theScale;
    CGFloat tempY = [self roundToTens: theLoc.y];// * theScale;
    
    tempX = theLoc.x;// * theScale;
    tempY = theLoc.y;// * theScale;
    
    CGRect envRect = CGRectMake(tempX-(myEnvelope/2.0f)*theDrawScale, tempY-(myEnvelope/2.0f)*theDrawScale, (myEnvelope)*theDrawScale, (myEnvelope)*theDrawScale);
    CGFloat dashPattern[] = {4, 2, 4, 2}; // points of line - space - line - space

    CGColorRef tempColor = myColorIs.CGColor;
    const CGFloat* colorParts =  CGColorGetComponents(tempColor);

    CGContextSaveGState(context);
    
    // draw the envelope first
    [myColorIs setFill];
    [[UIColor colorWithRed:colorParts[0] green:colorParts[1] blue:colorParts[2] alpha:0.5] setFill];

    CGContextFillEllipseInRect(context, envRect);
    [[UIColor whiteColor] setStroke];
    CGContextSetAlpha(context, 0.4);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);

/*******************************************************/;
    
    CGContextSaveGState(context);
    
    // draw the envelope first
    CGContextAddEllipseInRect(context, envRect);
    CGContextSetLineDash(context, 3, dashPattern, 4);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
}

-(UIColor*) showMyColor //(itemType)myType
{
 /*
    plant, // plant food
    meat, // animal food (fish, poultry, etc.)
    air, // generates breathable air
    water, // generates potable water
    mineral, // mining, etc to get minerals
    power, // converts input to useable power
    waste, // waste treatment
    civil, // services police, fire, admin
    home, // homestead
    tree // trees ... non food producing but may provide lumber or fruit
*/
    UIColor* theColorIs;
    
    switch (myType) {
        case home: theColorIs = [UIColor purpleColor]; break;
        case plant: theColorIs = [UIColor greenColor]; break;
        case meat: theColorIs = [UIColor redColor]; break;
        case air: theColorIs = [UIColor whiteColor]; break;
        case water: theColorIs = [UIColor blueColor]; break;
        case waste: theColorIs = [UIColor brownColor]; break;
        case mine: theColorIs = [UIColor grayColor]; break;
        case civil: theColorIs = [UIColor magentaColor]; break;
        case tree: theColorIs = [UIColor orangeColor]; break;
        case power: theColorIs = [UIColor yellowColor]; break;
        case fab: theColorIs = [UIColor lightGrayColor]; break;
            
        default:
            theColorIs = [UIColor cyanColor]; break;
    }
    return theColorIs;
}
#pragma mark - Coder methods for saving state

// not going to use this as store fixed (predetermined)
- (void)saveTechDataToFile: (NSString*) FileNameAndPath {
    
    //     [self createDataPath];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* ds = [df stringFromDate: myCreateDate];
    
    // make a string with the tile information
    NSString* myLocString = NSStringFromCGPoint(myLoc);
    NSString* newString = [NSString stringWithFormat: @"%@ \t %d \t %@ \t %@ \t %d \t %d \t %f \t %d \t %@", myLocString, (int)myPlaced, myID, myName, (int) myType, (int)myClass, myHealth, (int) myStatus, ds];
    
    newString = [NSString stringWithFormat: @"%@ \t %d \t %d \t %d \t %d", newString, (int)myClean, (int)myClear, (int)mySmooth, (int)myConnected];
    
    newString = [NSString stringWithFormat: @"%@ \t %@ \t %0.6f \t %0.6f", newString, [NSString stringWithFormat:@"%0.6fx%0.6f",mySize.width, mySize.height], myEnvelope, myCost];
    
    newString = [NSString stringWithFormat: @"%@ \t %d \t %0.6f \t %d \t %d \t %d \t %d \t %d \t %d", newString, (int)myProduceRate, myWearoutRate, (int)myRepairRate, (int)myCleanRate, (int)myClearRate, (int)mySmoothRate, (int)myConnectRate, (int)myBuildRate];
    
    __unused int sizeOfStockpile = (int) myStockpiles.count;
    
    NSString* stockpileContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [myStockpiles[0] floatValue], [myStockpiles[1] floatValue], [myStockpiles[2] floatValue], [myStockpiles[3] floatValue], [myStockpiles[4] floatValue], [myStockpiles[5] floatValue], [myStockpiles[6] floatValue], [myStockpiles[7] floatValue], [myStockpiles[8] floatValue], 0.0];//, [myStockpiles[9] floatValue] ];
    NSString* takerBOMContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [takerBOM[0] floatValue], [takerBOM[1] floatValue], [takerBOM[2] floatValue], [takerBOM[3] floatValue], [takerBOM[4] floatValue], [takerBOM[5] floatValue], [takerBOM[6] floatValue], [takerBOM[7] floatValue], [takerBOM[8] floatValue], 0.0];//, [takerBOM[9] floatValue] ];
    NSString* makerBOMContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [makerBOM[0] floatValue], [makerBOM[1] floatValue], [makerBOM[2] floatValue], [makerBOM[3] floatValue], [makerBOM[4] floatValue], [makerBOM[5] floatValue], [makerBOM[6] floatValue], [makerBOM[7] floatValue], [makerBOM[8] floatValue], 0.0];//, [makerBOM[9] floatValue] ];
    NSString* repairBOMContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [repairBOM[0] floatValue], [repairBOM[1] floatValue], [repairBOM[2] floatValue], [repairBOM[3] floatValue], [repairBOM[4] floatValue], [repairBOM[5] floatValue], [repairBOM[6] floatValue], [repairBOM[7] floatValue], [repairBOM[8] floatValue], 0.0];//, [repairBOM[9] floatValue] ];

    newString = [NSString stringWithFormat: @"%@ \t %@ \t %@ \t %@ \t %@", newString, stockpileContents, takerBOMContents, makerBOMContents, repairBOMContents];
    
    NSData* data = [newString dataUsingEncoding:NSUTF8StringEncoding];
    
    // find the folder to deposit the tile data
    NSString *dataPath = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:FileNameAndPath];//@"Store"];
    
    NSError *error;
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    BOOL result = [fileMgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!result) { NSLog(@"Unable to find/create %@.", documentsDirectory); }
    
    //tt    numeric code for base type, like 01 = power
    NSString* tt = @"";
    switch (myType) {
        case home:  tt = @"01"; break;
        case plant: tt = @"02"; break;
        case meat:  tt = @"03"; break;
        case air:   tt = @"04"; break;
        case water: tt = @"05"; break;
        case waste: tt = @"06"; break;
        case mine:  tt = @"07"; break;
        case civil: tt = @"08"; break;
        case tree:  tt = @"09"; break;
        case power: tt = @"10"; break;
        case fab:   tt = @"11"; break;
            
        default:
            tt = @"00"; break;
    }
    
    //sssss alpha code for subtype, like HYDRO = hydroelectric power
    NSString* sssss = @"sssss";
    //g     numeric code for good 0, better 1, best 2
    NSString* g = [NSString stringWithFormat:@"%1.0f", (CGFloat)myClass];
    //xxxx  numeric point location X coord
    NSString* xxxx = [NSString stringWithFormat:@"%4.0f", myLoc.x];
    //yyyy  numeric point location Y coord
    NSString* yyyy = [NSString stringWithFormat:@"%4.0f", myLoc.y];
    NSString* fileName = [NSString stringWithFormat:@"%@%@%@-%@%@.tech",tt,sssss,g,xxxx,yyyy];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString: @"0"];
    NSLog(@"\t\t\tfileName = %@", fileName);
    dataPath = [documentsDirectory stringByAppendingPathComponent: fileName];
    
    NSLog(@"\n\n\nsaving tech at: %@\n\n\n\n\n\n", dataPath);
    result = [fileMgr createFileAtPath: dataPath contents: data attributes: nil];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }
    
    // same function but different method used
    result = [data writeToFile: dataPath atomically: YES];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGSize:mySize forKey: kMySizeKey];
    [aCoder encodeCGPoint:myLoc forKey: kMyLocKey];
    [aCoder encodeDouble:myCost forKey: kMyCostKey];
    [aCoder encodeDouble:myType forKey: kMyTypeKey];
    [aCoder encodeDouble:myStatus forKey: kMyStatusKey];
    [aCoder encodeObject:myName forKey: kMyNameKey];
    [aCoder encodeDouble:myPlaced forKey: kMyPlacedKey];
//    [aCoder encodeInt64:myID forKey: kMyIDKey];
    [aCoder encodeDouble:myClean forKey: kMyCleanKey];
    [aCoder encodeDouble:myClear forKey: kMyClearKey];
    [aCoder encodeDouble:mySmooth forKey: kMySmoothKey];
    [aCoder encodeDouble:myConnected forKey: kMyConnectedKey];
    [aCoder encodeDouble:myBuildRate forKey: kMyBuildRateKey];
    [aCoder encodeDouble:myRepairRate forKey: kMyRepairRateKey];
    [aCoder encodeDouble:myProduceRate forKey: kMyProduceRateKey];
    [aCoder encodeDouble:myWearoutRate forKey: kMyWearoutRateKey];
    [aCoder encodeDouble:myConnectRate forKey: kMyConnectRateKey];
    [aCoder encodeDouble:mySmoothRate forKey: kMySmoothRateKey];
    [aCoder encodeDouble:myClearRate forKey: kMyClearRateKey];
    [aCoder encodeDouble:myCleanRate forKey: kMyCleanRateKey];
    [aCoder encodeDouble:myEnvelope forKey: kMyEnvelopeKey];
    [aCoder encodeDouble:myHealth forKey: kMyHealthKey];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        mySize = [aDecoder decodeCGSizeForKey:kMySizeKey];
        myLoc = [aDecoder decodeCGPointForKey: kMyLocKey];
        myCost = [aDecoder decodeDoubleForKey: kMyCostKey];
        myType = [aDecoder decodeDoubleForKey: kMyTypeKey];
        myStatus = [aDecoder decodeDoubleForKey: kMyStatusKey];
        myName = [aDecoder decodeObjectForKey: kMyNameKey];
        myPlaced = [aDecoder  decodeDoubleForKey: kMyPlacedKey];
        //    [aCoder encodeInt64:myID forKey: kMyIDKey];
        myClean = [aDecoder decodeDoubleForKey: kMyCleanKey];
        myClear = [aDecoder decodeDoubleForKey: kMyClearKey];
        mySmooth = [aDecoder decodeDoubleForKey: kMySmoothKey];
        myConnected = [aDecoder decodeDoubleForKey: kMyConnectedKey];
        myBuildRate = [aDecoder decodeDoubleForKey: kMyBuildRateKey];
        myRepairRate = [aDecoder decodeDoubleForKey: kMyRepairRateKey];
        myProduceRate = [aDecoder decodeDoubleForKey: kMyProduceRateKey];
        myWearoutRate = [aDecoder decodeDoubleForKey: kMyWearoutRateKey];
        myConnectRate = [aDecoder decodeDoubleForKey: kMyConnectRateKey];
        mySmoothRate = [aDecoder decodeDoubleForKey: kMySmoothRateKey];
        myClearRate = [aDecoder decodeDoubleForKey: kMyClearRateKey];
        myCleanRate = [aDecoder decodeDoubleForKey: kMyCleanRateKey];
        myEnvelope = [aDecoder decodeDoubleForKey: kMyEnvelopeKey];
        myHealth = [aDecoder decodeDoubleForKey: kMyHealthKey];
    }
    return self;
}

-(instancetype) initWithSaveString: (NSString*) stringWithData
{
    self = [super init];
    if (self) {
        NSArray *lineArr = [stringWithData componentsSeparatedByString:@"\t"];
        
        if (lineArr.count > 1) {
            myType = (itemType) [lineArr[4] intValue];
            itemIcon = @"Image-1";
//            mySize = origUnit.mySize;
            myCost = [lineArr[15] floatValue];
            myColorIs = [self showMyColor];
            myName = lineArr[3];
            myID = lineArr[2];
            myClean = [lineArr[9] intValue];
            myClear = [lineArr[10] intValue];
            mySmooth = [lineArr[11] intValue];
            myConnected = [lineArr[12] intValue];
            myBuildRate = [lineArr[23] intValue];
            myRepairRate = [lineArr[18] intValue];
            myProduceRate = [lineArr[16] intValue];
            myWearoutRate = [lineArr[17] floatValue];
            myCleanRate = [lineArr[19] intValue];
            myClearRate = [lineArr[20] intValue];
            mySmoothRate = [lineArr[21] intValue];
            myConnectRate = [lineArr[22] intValue];
            myEnvelope = [lineArr[14] floatValue];
            myHealth = [lineArr[6] intValue];
            
            myLoc = CGPointFromString(lineArr[0]);
            myCreateDate = lineArr[8];
            myStatus = (itemStatus)[lineArr[7] intValue];
            myPlaced = (BOOL)[lineArr[1] intValue];
            myClass = [lineArr[5] intValue];
            
            NSArray* aSizeItems = [lineArr[13] componentsSeparatedByString: @"x"];
            CGRect tempRect = CGRectMake(0,0, [aSizeItems[0] floatValue], [aSizeItems[1] floatValue]);
            mySize = tempRect.size;
            
            myStockpiles = [[NSMutableArray alloc] initWithCapacity:10];
            takerBOM = [[NSMutableArray alloc] initWithCapacity:10];
            makerBOM = [[NSMutableArray alloc] initWithCapacity:10];
            repairBOM = [[NSMutableArray alloc] initWithCapacity:10];
            
            NSArray* stockContents = [lineArr[24] componentsSeparatedByString: @"::"];
            [self fillStockBOMStruct: [stockContents[0] floatValue] comp: [stockContents[1] floatValue] supp: [stockContents[2] floatValue] matl: [stockContents[3] floatValue] powr: [stockContents[4] floatValue] watr: [stockContents[5] floatValue] air: [stockContents[6] floatValue] food: [stockContents[7] floatValue] labr: [stockContents[8] floatValue]];

            NSArray* takerContents = [lineArr[25] componentsSeparatedByString: @"::"];
            [self fillTakerBOMStruct: [takerContents[0] floatValue] comp: [takerContents[1] floatValue] supp: [takerContents[2] floatValue] matl: [takerContents[3] floatValue] powr: [takerContents[4] floatValue] watr: [takerContents[5] floatValue] air: [takerContents[6] floatValue] food: [takerContents[7] floatValue] labr: [takerContents[8] floatValue]];
            
            NSArray* makerContents = [lineArr[26] componentsSeparatedByString: @"::"];
            [self fillMakerBOMStruct: [makerContents[0] floatValue] comp: [makerContents[1] floatValue] supp: [makerContents[2] floatValue] matl: [makerContents[3] floatValue] powr: [makerContents[4] floatValue] watr: [makerContents[5] floatValue] air: [makerContents[6] floatValue] food: [makerContents[7] floatValue] labr: [makerContents[8] floatValue]];
            
            NSArray* repairContents = [lineArr[27] componentsSeparatedByString: @"::"];
            [self fillRepairBOMStruct: [repairContents[0] floatValue] comp: [repairContents[1] floatValue] supp: [repairContents[2] floatValue] matl: [repairContents[3] floatValue] powr: [repairContents[4] floatValue] watr: [repairContents[5] floatValue] air: [repairContents[6] floatValue] food: [repairContents[7] floatValue] labr: [repairContents[8] floatValue]];
        }
    }
    
    _theMessage = [[NENotification alloc] initNotificationOnDay:0 from:fromPlant type:info content:@"" date:nil isRemote:NO];
    _myGlobals = [NewEarthGlobals sharedSelf];
    _neNotes = [NeNotifications sharedSelf];
    return self;
}

@end

